#!/bin/bash

if command -v xdg-open; then
	xdg-open `git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//'`| head -n1
else
	open `git remote -v | grep fetch | awk '{print $2}' | sed 's/git@/http:\/\//' | sed 's/com:/com\//'`| head -n1
fi

git branch -m master main && git push origin --set-upstream main

echo
echo
echo For GitHub repositories we need to change the default branch. Open a
echo browser and please open go to the repository, go to Settings, then
echo Branches. Here you can change the default branch to "main" and press
echo update.
echo
echo After that is updated, press enter to delete the old branch.
echo

read -n 1

echo Deleting old branch.

git push origin :master

echo Done!
