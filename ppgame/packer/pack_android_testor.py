#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
NAME
    build_native --

SYNOPSIS
    build_native [-h] [-r] [-c]

    -h show help
    -r release mode
    -c clean binary files
"""

import os
import sys
import getopt
import subprocess
import shutil
import platform
import os
import json
import hashlib
import subprocess
import sys

key = "LHPxyou520"
sign = "xxtea"
outDir = "out_android/Assets"
assetsDir = {
    "searchDir" : [outDir],
    "ignorDir" : ["cocos", "obj","version","framework"]
}

versionConfigFile = "version_info_android_ceshi.json"  #版本信息的配置文件路径
versionManifestPath = outDir + "/version.manifest"    #由此脚本生成的version.manifest文件路径
projectManifestPath = outDir + "/project.manifest"    #由此脚本生成的project.manifest文件路径

rootPath = os.path.split(os.path.realpath(__file__))[0]
new_env = os.environ.copy()
engineRoot = os.path.abspath(os.path.join(os.getcwd(), ".."))

print "------ cur dir ------"
print rootPath
print "------ parent dir ------"
print engineRoot

def joinDir(root, *dirs):
    for item in dirs:
        root = os.path.join(root, item)
    return root

def encrypt_res():
    if os.path.exists(outDir):
        shutil.rmtree(outDir)
    print "====> start encrypt_res\n"
    cmd = subprocess.Popen('%s/quick/bin/encrypt_res.bat -i ../Assets/res -o %s -ek %s -es %s' \
            %(engineRoot,outDir+'/res',key,sign), shell=True,env=new_env)
    cmd.wait()
    if cmd.returncode != 0:
        print "Error while building, check error above!"
        return
		
def compile_laucher():
    print "====> start compile_laucher\n"
    scriptDir = outDir + "/src"
    if not os.path.exists(scriptDir):
        os.makedirs(scriptDir)
    cmd = subprocess.Popen('%s/quick/bin/compile_scripts.bat -i ../Assets/src -o %s/laucher.zip -x app,kernel,lib,cocos -e xxtea_chunk -ek %s -es %s -b 32' \
            %(engineRoot,scriptDir,key,sign), shell=True,env=new_env)
    cmd.wait()
    if cmd.returncode != 0:
        print "Error while building, check error above!"
        return

def compile_cocos():
    print "====> start compile_cocos\n"
    scriptDir = outDir + "/src"
    if not os.path.exists(scriptDir):
        os.makedirs(scriptDir)
    cmd = subprocess.Popen('%s/quick/bin/compile_scripts.bat -i ../Assets/src -o %s/cocos.zip -x app,kernel,lib,laucher -e xxtea_chunk -ek %s -es %s -b 32' \
            %(engineRoot,scriptDir,key,sign), shell=True,env=new_env)
    cmd.wait()
    if cmd.returncode != 0:
        print "Error while building, check error above!"
        return

def compile_lib():
    print "====> start compile_lib\n"
    scriptDir = outDir + "/src"
    if not os.path.exists(scriptDir):
        os.makedirs(scriptDir)
    cmd = subprocess.Popen('%s/quick/bin/compile_scripts.bat -i ../Assets/src -o %s/lib.zip -x app,kernel,cocos,laucher -e xxtea_chunk -ek %s -es %s -b 32' \
            %(engineRoot,scriptDir,key,sign), shell=True, env=new_env)
    cmd.wait()
    if cmd.returncode != 0:
        print "Error while building, check error above!"
        return

def compile_kernel():
    print "====> start compile_kernel\n"
    scriptDir = outDir + "/src"
    if not os.path.exists(scriptDir):
        os.makedirs(scriptDir)
    cmd = subprocess.Popen('%s/quick/bin/compile_scripts.bat -i ../Assets/src -o %s/kernel.zip -x app,lib,cocos,laucher -e xxtea_chunk -ek %s -es %s -b 32' \
            %(engineRoot,scriptDir,key,sign), shell=True, env=new_env)
    cmd.wait()
    if cmd.returncode != 0:
        print "Error while building, check error above!"
        return
		
def compile_app():
    print "====> start compile_app\n"
    scriptDir = outDir + "/src"
    if not os.path.exists(scriptDir):
        os.makedirs(scriptDir)
    cmd = subprocess.Popen('%s/quick/bin/compile_scripts.bat -i ../Assets/src -o %s/app.zip -x kernel,lib,cocos,laucher -e xxtea_chunk -ek %s -es %s -b 32' \
            %(engineRoot,scriptDir,key,sign), shell=True, env=new_env)
    cmd.wait()
    if cmd.returncode != 0:
        print "Error while building, check error above!"
        return
	


class SearchFile:
    def __init__(self):
        self.fileList = []

        for k in assetsDir:
            if (k == "searchDir"):
                for searchdire in assetsDir[k]:	
                    self.recursiveDir(searchdire)

    def recursiveDir(self, srcPath):
        ''' 递归指定目录下的所有文件'''
        dirList = []    #所有文件夹
        #print srcPath
        files = os.listdir(srcPath) #返回指定目录下的所有文件，及目录（不含子目录）
        #print files 
        for f in files:
            #目录的处理
            if (os.path.isdir(srcPath + '/' + f)):
                if (f[0] == '.' or (f in assetsDir["ignorDir"])):
                    #排除隐藏文件夹和忽略的目录
                    pass
                else:
                    #添加需要的文件夹
                    dirList.append(f)
            #文件的处理
            elif (os.path.isfile(srcPath + '/' + f)):
                if f[0] != '.':
                    self.fileList.append(srcPath + '/' + f) #添加文件

        #遍历所有子目录,并递归
        for dire in dirList:
            #递归目录下的文件
            self.recursiveDir(srcPath + '/' + dire)

    def getAllFile(self):
        ''' get all file path'''
        return tuple(self.fileList)

def GetSvnCurrentVersion():
    popen = subprocess.Popen(['svn', 'info'], stdout = subprocess.PIPE)
    while True:
        next_line = popen.stdout.readline()
        if next_line == '' and popen.poll() != None:
            break

        valList = next_line.split(':')
        if len(valList)<2:
            continue
        valList[0] = valList[0].strip().lstrip().rstrip(' ')
        valList[1] = valList[1].strip().lstrip().rstrip(' ')

        if(valList[0]=="Revision"):
            return valList[1]
    return ""


def CalcMD5(filepath):
    """generate a md5 code by a file path"""
    with open(filepath,'rb') as f:
        md5obj = hashlib.md5()
        md5obj.update(f.read())
        return md5obj.hexdigest()

def getVersionInfo():
    '''get version config data'''
    configFile = open(versionConfigFile,"r")
    json_data = json.load(configFile)
    configFile.close()
    #json_data["version"] = json_data["version"] + '.' + str(GetSvnCurrentVersion())
    return json_data

def GenerateversionManifestPath():
    ''' 生成大版本的version.manifest'''
    json_str = json.dumps(getVersionInfo(), indent = 2)
    fo = open(versionManifestPath,"w")
    fo.write(json_str)
    fo.close()
    

def GenerateprojectManifestPath():
    searchfile = SearchFile()
    fileList = list(searchfile.getAllFile())
    project_str = {}
    project_str.update(getVersionInfo())
    dataDic = {}
    for f in fileList:
        f2 = {"md5" : CalcMD5(f)}
        #f1 = "res" + f[6:]
        f = f.replace(outDir,'Assets')
        print f
        dataDic[f] = f2
        #print f1

    project_str.update({"assets":dataDic})
    json_str = json.dumps(project_str, sort_keys = True, indent = 2)

    fo = open(projectManifestPath,"w")
    fo.write(json_str)
    fo.close()
	
if __name__ == "__main__":
    encrypt_res()
    compile_laucher()
    compile_cocos()
    compile_lib()
    compile_kernel()
    compile_app()
    GenerateprojectManifestPath()
    GenerateversionManifestPath()
