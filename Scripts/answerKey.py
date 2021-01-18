#! /usr/bin/env python

import argparse;
import subprocess;

parser = argparse.ArgumentParser(description='Wouldn\'t you like to know?')
parser.add_argument('-f', '--filter', help='Filter the branch options by some matching text.')

args = parser.parse_args()

fRefs = subprocess.check_output(['git', 'for-each-ref', 'refs/heads'])

if fRefs.count < 2:
    print ("No selection available")
    exit

fBranchCount = 1

fTemplate = "\t{0} {1}"

print("Select a Branch (Leave Blank to Abort):")

fValidBranches = list()

for fRef in fRefs.split('\n'):
    if (fRef == ''):
        continue

    if (args.filter != None and args.filter not in fRef):
        continue
    fValidBranches.append(fRef[59:])
    print fTemplate.format(fBranchCount, fRef[59:])
    fBranchCount += 1

fChoice = raw_input("Choose a Branch number: ")

try:
    fChosenInt = int(fChoice)
    if (fChosenInt < 1 or fChosenInt > fBranchCount - 1):
        print("Not a valid choice")
        exit

    fChosenBranch = fValidBranches[fChosenInt - 1]

    print "Checking out {0}".format(fChosenBranch)

    subprocess.check_output(['git', 'checkout', fChosenBranch])
    exit
except ValueError:
    if (fChoice == None or str.strip(fChoice) == ''):
        exit
    else:
        print ("Not a number.")
        exit

