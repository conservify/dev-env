#!/bin/bash

git branch -m master main && git push origin --set-upstream main

echo
echo
echo For GitHub repositories we need to change the default branch. Open a
echo browser and please open go to the repository, go to Settings, then
echo Branches. Here you can change the default branch to "main" and press
echo update.
echo
echo "NOTE: It would be cool if this script just opened that page :)"
echo
echo After that is updated, press enter to delete the old branch.
echo

read -n 1

git push origin :master
