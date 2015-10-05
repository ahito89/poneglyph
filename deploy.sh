#!/bin/bash

echo -e "Deploying updates to github..."

#Build
hugo

cd public

git add .

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg = "$1"
fi

git commit -m "$msg"

git push origin master

cd ..
