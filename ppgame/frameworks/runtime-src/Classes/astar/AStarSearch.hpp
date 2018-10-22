/*
A* Algorithm Implementation using STL is
Copyright (C)2001-2005 Justin Heyes-Jones

A* Algorithm Implementation not using STL is
Copyright (C)2008 Konstantin Stupnik
Optimized version of original implementation.


Permission is given by the author to freely redistribute and
include this code in any program as long as this credit is
given where due.

  COVERED CODE IS PROVIDED UNDER THIS LICENSE ON AN "AS IS" BASIS,
  WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
  INCLUDING, WITHOUT LIMITATION, WARRANTIES THAT THE COVERED CODE
  IS FREE OF DEFECTS, MERCHANTABLE, FIT FOR A PARTICULAR PURPOSE
  OR NON-INFRINGING. THE ENTIRE RISK AS TO THE QUALITY AND
  PERFORMANCE OF THE COVERED CODE IS WITH YOU. SHOULD ANY COVERED
  CODE PROVE DEFECTIVE IN ANY RESPECT, YOU (NOT THE INITIAL
  DEVELOPER OR ANY OTHER CONTRIBUTOR) ASSUME THE COST OF ANY
  NECESSARY SERVICING, REPAIR OR CORRECTION. THIS DISCLAIMER OF
  WARRANTY CONSTITUTES AN ESSENTIAL PART OF THIS LICENSE. NO USE
  OF ANY COVERED CODE IS AUTHORIZED HEREUNDER EXCEPT UNDER
  THIS DISCLAIMER.

  Use at your own risk!

*/

#ifndef __ASTARSEARCH_HPP__
#define __ASTARSEARCH_HPP__

#include "IntrHeapHash.hpp"

template <class UserState>
class AStarSearch
{

public: // data

  enum
  {
    SEARCH_STATE_NOT_INITIALISED,
    SEARCH_STATE_SEARCHING,
    SEARCH_STATE_SUCCEEDED,
    SEARCH_STATE_FAILED,
    SEARCH_STATE_OUT_OF_MEMORY,
    SEARCH_STATE_INVALID
  };

protected:
  // A node represents a possible state in the search
  // The user provided state type is included inside this type

  struct Node:public IntrHeapHashNodeBase
  {
      Node *parent; // used during the search to record the parent of successor nodes
      Node *child; // used after the search for the application to view the search in reverse

      int g; // cost of this node + it's predecessors
      int h; // heuristic estimate of distance to goal
      int f; // sum of cumulative cost of predecessors and self and heuristic

      //used in AllocateNode
      void clear()
      {
        parent=0;
        child=0;
        g=0;
        h=0;
        f=0;
      }

      UserState m_UserState;
  };


  // Both hashset and heaphash use this traits of node

  struct NodeTraits{
    static bool Compare(const Node* x,const Node* y)
    {
      return x->f < y->f;
    }
    static bool isEqual(const Node* x,const Node* y)
    {
      return x->m_UserState.IsSameState(y->m_UserState);
    }
    static uint32_t getHashCode(const Node* x)
    {
      return x->m_UserState.getHashCode();
    }
  };


public: // methods


  // constructor just initialises private data
  AStarSearch() :
    m_State( SEARCH_STATE_NOT_INITIALISED ),
    m_CurrentSolutionNode( NULL ),
    m_CancelRequest( false )
  {
    InitPool();
  }

  ~AStarSearch()
  {
    // if additional pool page was allocated, let's free it
    NodePoolPage* page=defaultPool.nextPage;
    while(page)
    {
      NodePoolPage* next=page->nextPage;
      delete page;
      page=next;
    }
  }


  // call at any time to cancel the search
  void CancelSearch()
  {
    m_CancelRequest = true;
  }

  // Set Start and goal states
  void SetStartAndGoalStates( const UserState &Start, const UserState &Goal )
  {
    // Reinit nodes pool after previous searches
    InitPool();

    // Clear containers after previous searches
    m_OpenList.Clear();
    m_ClosedList.Clear();

    m_CancelRequest = false;

    // allocate start end goal nodes
    m_Start = AllocateNode();
    m_Goal = AllocateNode();

    m_Start->m_UserState = Start;
    m_Goal->m_UserState = Goal;

    m_State = SEARCH_STATE_SEARCHING;

    // Initialise the AStar specific parts of the Start Node
    // The user only needs fill out the state information

    m_Start->g = 0;
    m_Start->h = m_Start->m_UserState.GoalDistanceEstimate( m_Goal->m_UserState );
    m_Start->f = m_Start->g + m_Start->h;
    m_Start->parent = 0;

    // Push the start node on the Open list

    m_OpenList.Insert( m_Start );

    // Initialise counter for search steps
    m_Steps = 0;
  }

  // Advances search one step
  unsigned int SearchStep()
  {
    // Firstly break if the user has not initialised the search

    // Next I want it to be safe to do a searchstep once the search has succeeded...
    if( (m_State == SEARCH_STATE_SUCCEEDED) ||(m_State == SEARCH_STATE_FAILED) )
    {
		return m_State;
    }

    // Failure is defined as emptying the open list as there is nothing left to
    // search...
    // New: Allow user abort
    if( m_OpenList.isEmpty() || m_CancelRequest )
    {
		m_State = SEARCH_STATE_FAILED;
		return m_State;
    }

    // Incremement step count
    m_Steps ++;

    // Pop the best node (the one with the lowest f)
    Node *n= m_OpenList.Pop();

    //printf("n:(%d,%d):%d\n",n->m_UserState.x,n->m_UserState.y,n->f);

    // Check for the goal, once we pop that we're done
    if( n->m_UserState.IsGoal( m_Goal->m_UserState ) )
    {
      // The user is going to use the Goal Node he passed in
      // so copy the parent pointer of n
      m_Goal->parent = n->parent;

      // A special case is that the goal was passed in as the start state
      // so handle that here
      if( false == n->m_UserState.IsSameState( m_Start->m_UserState ) )
      {
        FreeNode( n );

        // set the child pointers in each node (except Goal which has no child)
        Node *nodeChild = m_Goal;
        Node *nodeParent = m_Goal->parent;
        do
        {
          nodeParent->child = nodeChild;

          nodeChild = nodeParent;
          nodeParent = nodeParent->parent;

        }
        while( nodeChild != m_Start ); // Start is always the first node by definition

      }

      m_State = SEARCH_STATE_SUCCEEDED;

      return m_State;
    }
    else // not goal
    {

      // We now need to generate the successors of this node
      // The user helps us to do this, and we keep the new nodes in
      // m_Successors ...

      m_Successors.clear(); // empty vector of successor nodes to n

      // User provides this functions and uses AddSuccessor to add each successor of
      // node 'n' to m_Successors
      n->m_UserState.GetSuccessors( this, n->parent ? &n->parent->m_UserState : NULL );

      // Now handle each successor to the current node ...
      for( typename std::vector< Node * >::iterator successor = m_Successors.begin(); successor != m_Successors.end(); successor ++ )
      {

        //  The g value for this successor ...
        int newg = n->g + n->m_UserState.GetCost( (*successor)->m_UserState );


        // Now we need to find whether the node is on the open or closed lists
        // If it is but the node that is already on them is better (lower g)
        // then we can forget about this successor

        const Node* openlist_result=m_OpenList.Find(**successor);

        if( openlist_result )
        {

          // we found this state on open

          if( openlist_result->g <= newg )
          {
            FreeNode( (*successor) );

            // the one on Open is cheaper than this one
            continue;
          }
        }

        typename NodeHash::Iterator closedlist_result=m_ClosedList.Find(**successor);

        if( closedlist_result.Found() )
        {

          // we found this state on closed

          if( closedlist_result.Get()->g <= newg )
          {
            // the one on Closed is cheaper than this one
            FreeNode( (*successor) );

            continue;
          }
        }

        // This node is the best node so far with this particular state
        // so lets keep it and set up its AStar specific data ...

        (*successor)->parent = n;
        (*successor)->g = newg;
        (*successor)->h = (*successor)->m_UserState.GoalDistanceEstimate( m_Goal->m_UserState );
        (*successor)->f = (*successor)->g + (*successor)->h;

        // Remove successor from closed if it was on it

        if( closedlist_result.Found() )
        {
          // remove it from Closed
          Node* node=(Node*)closedlist_result.Get();
          m_ClosedList.Delete( closedlist_result );
          FreeNode( node  );
        }

        // Update old version of this node
        if( openlist_result )
        {
          m_OpenList.Delete( *openlist_result );
          FreeNode( (Node*)openlist_result );
        }

        m_OpenList.Insert( (*successor) );

      }

      // push n onto Closed, as we have expanded it now

      m_ClosedList.Insert( n );

    } // end else (not goal so expand)

    return m_State; // Succeeded bool is false at this point.

  }

  // User calls this to add a successor to a list of successors
  // when expanding the search frontier
  bool AddSuccessor( const UserState &State )
  {
    Node *node = AllocateNode();

    if( node )
    {
      node->m_UserState = State;
      m_Successors.push_back( node );
      return true;
    }

    return false;
  }

  // Functions for traversing the solution

  // Get start node
  UserState *GetSolutionStart()
  {
    m_CurrentSolutionNode = m_Start;
    if( m_Start )
    {
      return &m_Start->m_UserState;
    }
    else
    {
      return NULL;
    }
  }

  // Get next node
  UserState *GetSolutionNext()
  {
    if( m_CurrentSolutionNode )
    {
      if( m_CurrentSolutionNode->child )
      {
        m_CurrentSolutionNode = m_CurrentSolutionNode->child;
        return &m_CurrentSolutionNode->m_UserState;
      }
    }

    return NULL;
  }

  // Get end node
  UserState *GetSolutionEnd()
  {
    m_CurrentSolutionNode = m_Goal;
    if( m_Goal )
    {
      return &m_Goal->m_UserState;
    }
    else
    {
      return NULL;
    }
  }

  // Step solution iterator backwards
  UserState *GetSolutionPrev()
  {
    if( m_CurrentSolutionNode )
    {
      if( m_CurrentSolutionNode->parent )
      {

        m_CurrentSolutionNode = m_CurrentSolutionNode->parent;

        return &m_CurrentSolutionNode->m_UserState;
      }
    }

    return NULL;
  }

  // Get the number of steps

  int GetStepCount()
  {
    return m_Steps;
  }

private: // methods


  // Node memory management
  Node *AllocateNode()
  {
    if(freeNodesList)
    {
      Node* rv=freeNodesList;
      freeNodesList=freeNodesList->child;
      rv->clear();
      return rv;
    }
    if(currentPoolPage->nextFreeNode==currentPoolPage->endFreeNode)
    {
      currentPoolPage=currentPoolPage->nextPage=new NodePoolPage;
    }
    Node* rv=currentPoolPage->nextFreeNode++;
    rv->clear();
    return rv;
  }

  void FreeNode( Node *node )
  {
    node->child=freeNodesList;
    freeNodesList=node;
  }

private: // data

  //private copy constructor
  //class cannot be copied
  AStarSearch(const AStarSearch&);

  //both containers are intrusive containers.
  //i.e. all fields required for container are
  //already in Node thru inheritance.
  //this minimizes memory allocations.

  // binary heap and hashset '2 in 1' container with 'open' nodes
  typedef IntrHeapHash<Node,NodeTraits> NodeHeap;
  NodeHeap m_OpenList;

  // hashset for 'closed' nodes
  typedef IntrHashSet<Node,NodeTraits> NodeHash;
  NodeHash m_ClosedList;

  // Successors is a vector filled out by the user each type successors to a node
  // are generated
  typedef std::vector< Node * > NodeVector;
  NodeVector m_Successors;

  //default page size
  enum{nodesPerPage=1024};

  // page of pool of nodes for fast allocation
  struct NodePoolPage
  {
    Node nodes[nodesPerPage];
    Node* nextFreeNode;
    Node* endFreeNode;
    NodePoolPage* nextPage;
    NodePoolPage()
    {
      Init();
      nextPage=0;
    }
    void Init()
    {
      nextFreeNode=nodes;
      endFreeNode=nodes+nodesPerPage;
    }
  };

  //first page of pool allocated along with AStarSearch object on stack
  //or in data segement if static.
  //should be enough for most tasks
  NodePoolPage defaultPool;
  //pointer to current pool page. equal to address of default pool at start
  NodePoolPage* currentPoolPage;
  //pointer to first node of linked list of nodes
  Node* freeNodesList;

  void InitPool()
  {
    currentPoolPage=&defaultPool;
    freeNodesList=0;
    NodePoolPage* ptr=currentPoolPage;
    while(ptr)
    {
      ptr->Init();
      ptr=ptr->nextPage;
    }
  }
	
  // State
	unsigned int m_State;

	// Counts steps
	int m_Steps;

	// Start and goal state pointers
	Node *m_Start;
	Node *m_Goal;
	Node *m_CurrentSolutionNode;

	bool m_CancelRequest;
};

#endif
