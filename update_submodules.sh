#!/bin/bash

pushd vim/bundle/python-mode
git checkout develop
git submodule update --recursive --remote 2>&1 | tee ../../../update.log
popd

git submodule update --recursive --remote 2>&1 | tee -a update.log

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
