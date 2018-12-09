#!/bin/bash

pushd vim/bundle/python-mode
git checkout -f develop
git pull
git submodule update --recursive --init 2>&1 | tee ../../../update.log
popd

pushd vim/bundle/YouCompleteMe
git checkout -f master
git pull
git submodule update --recursive --init 2>&1 | tee ../../../update.log
popd

git submodule update --remote 2>&1 | tee -a update.log

while read line
do
	if [[ $line == *..* ]]
	then
		#echo $line
		commits=$(echo $line | cut -d' ' -f 1)
		#echo $commits
	fi
	if [[ -n $commits && $line == Submodule\ path* ]]
	then
		#echo $line
		path=$(echo $line | cut -d"'" -f 2)
		echo
		echo -----------------------------------------------------------------
		echo $path
		echo -----------------------------------------------------------------
		echo
	    git --no-pager -C $path log -n 100 $commits
		unset commits
	fi

done < update.log
