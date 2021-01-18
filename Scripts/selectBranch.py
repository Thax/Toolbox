#! /usr/bin/env python

import sys
import argparse
import subprocess

parser = argparse.ArgumentParser()

parser.add_argument('-f', '--filter')

options = parser.parse_args()

result = subprocess.check_output(['git', 'for-each-ref', '--shell', 'refs/heads'])

splitResult = str.split(result, '\n')
branchList = list()
branchNumber = 1
lineFormat = "{0} : {1}"
for line in splitResult:
    if ('refs/heads' in line):
        branch = line[64:-1]
        if (options.filter != None and options.filter in branch):
            print lineFormat.format(branchNumber, branch)
            branchNumber+=1
            branchList.append(branch)

userChoice = raw_input("Choice: ")

if (userChoice == None):
    exit

try:
    userInt = int(userChoice)
except ValueError:
    print ("Not a number")
    exit

print branchNumber
if (userInt <= branchNumber - 1 and userInt >= 1):
    print ("sucess")
else:
    print userInt
        

result = subprocess.check_output(['git', 'co', branchList[userInt - 1]])
