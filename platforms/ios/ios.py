#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os
import json
import time
import commands
pgyPrdConfig = {"pgyApiKey":"f86d2c653f43ba548d0ba4bfb98a0ebc","pgyUserKey":"08ec56f822c8fa26cd5dd6d988524bda"}
pgyStgConfig = {"pgyApiKey":"e93e76feff7f62fa37750ce0db8a65f8","pgyUserKey":"00668e68cf66d93f094310fa8a63ac27"}
configFilePath = 'config.json'
class ConfigUtil(object):
    @classmethod
    def instance(self):
        targets = ['target1'];
        if os.path.exists(configFilePath):
            targets = json.loads(open(configFilePath).read())
            print 'Exists config file, read it'
            return (0,targets)
        else:
            open(configFilePath,'w').write(json.dumps(targets))
            print 'Not exists, now create new config file'
            return (-1,targets)
def uploadToPgy(filePath, isRelease, updateDescription):
    pgyApiKey = pgyStgConfig['pgyApiKey']
    pgyUserKey = pgyStgConfig['pgyUserKey']
    if isRelease:
        pgyApiKey = pgyPrdConfig['pgyApiKey']
        pgyUserKey = pgyPrdConfig['pgyUserKey']
    shell = 'curl -F "file=@'+filePath+'" \
    -F "_api_key='+pgyApiKey+'" \
    -F "uKey='+pgyUserKey+'" \
    -F "updateDescription='+updateDescription+'" \
    https://www.pgyer.com/apiv1/app/upload'
    print '开始上传到蒲公英：%s' %(filePath)
    # commands.getstatusoutput(shell)[1]
    os.system(shell)
    print '上传完成'
def consoleInput():
    (status,targets) = ConfigUtil.instance()
    if status != 0:
        return (-1,-1)
    for target in targets:
        if target == 'target1':
            print '请修改默认的target名称' + json.dumps(targets)
            return (-1,-1)
    print '请选择打包的Target， 多个用英文逗号区分'
    index = 0
    print '\t0:全部'
    for target in targets:
        index = index + 1
        if target == '':
            print '\t%s:%s' % (index,'Default')
        else:
            print '\t%s:%s' % (index,target.capitalize())
    rawInputString = raw_input()
    selectedTargetIndexs = rawInputString.split(',')
    selectedTargets = []
    for index in selectedTargetIndexs:
        if index.isdigit() == False:
            print '错误的指令 ' + rawInputString
            return (-1,-1)
        index = int(index)
        if index > len(targets):
            print '错误的数字 ' + rawInputString
            return (-1,-1)
        if index == 0:
            selectedTargets = targets;
            break
        else:
            selectedTargets.append(targets[index - 1])
    print '请输入打包类型'
    print '\t0: Debug & Release'
    print '\t1: Debug'
    print '\t2: Release'
    rawInputString = raw_input()
    if rawInputString.isdigit() == False or (rawInputString != '0' and rawInputString != '1' and rawInputString != '2'):
        print '错误的打包类型'
        return (-1,-1)
    buildType = int(rawInputString)
    print '请确认如下打包信息：'
    print 'Target ：'
    for target in selectedTargets:
        if target == '':
            print '\t' + 'Default'
        else:
            print '\t' + target.capitalize()
    print 'BuildType：'
    if buildType == 0:
        print '\t Debug & Release'
    if buildType == 1:
        print '\t Debug'
    if buildType == 2:
        print '\t Release'
    print '确认按回车，取消按Ctrl + C'
    raw_input()
    return (selectedTargets, buildType)
def backupOldApk():
    (status, output) = commands.getstatusoutput('find ./*/**/outputs/** -name *.apk')
    findApks = output.split('\n')
    for apk in findApks:
        if apk != '':
            os.system('mv %s %s.backup' % (apk,apk))
def findApkAndUpload():
    (status, output) = commands.getstatusoutput('find ./*/**/outputs/** -name *.apk')
    findApks = output.split('\n')
    for apk in findApks:
        releaseType = "Debug"
        if apk.find('-release.apk') != -1:
            releaseType = "Release"
        else:
            if apk.find('-debug.apk') != -1:
                releaseType = "Debug"
            else:
                print '错误的apk名称' + apk
                os.system("mv %s %s.backup" % (apk, apk))
                continue
        uploadToPgy(apk, releaseType == "Release", '')
        apkName = apk[apk.rfind('/') + 1:]
        buildApkDir = "~/build_apk/%s/%s/%s/" % (releaseType,apkName,time.strftime("%m_%d", time.localtime()))
        buildApkName = time.strftime("%H_%M_%S", time.localtime()) + '_' + apkName
        if os.path.exists(buildApkDir) == False:
            mkdirShell = 'mkdir -p ' + buildApkDir
            os.system(mkdirShell)
        mvShell = 'mv %s %s' % (apk,buildApkDir + buildApkName)
        os.system(mvShell)
        print '备份安装包完成：' + buildApkDir + buildApkName
def buildApk(targets, buildType):
    for target in targets:
        buildTypeString = ''
        if buildType == 1:
            buildTypeString = 'Debug'
        if buildType == 2:
            buildTypeString = 'Release'
        shell = 'sh ./gradlew assemble%s%s' % (target.capitalize(),buildTypeString.capitalize())
        print(shell)
        os.system(shell)
        findApkAndUpload()
def main():
    backupOldApk()
    (targets, buildType) = consoleInput()
    if targets == -1:
        return
    buildApk(targets, buildType)
    os.system('rm pack.py')
main()