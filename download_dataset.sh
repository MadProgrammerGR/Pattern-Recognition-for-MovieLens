#!/bin/bash
SOURCE="http://files.grouplens.org/datasets/movielens/ml-100k.zip"

if type 7z; then
	EXT="7z x"
elif type unzip; then
	EXT="unzip"
else
	echo "Please install 7zip or unzip"
	exit -3
fi

if type curl; then
	CURL="curl -O"
elif type wget; then
	CURL="wget"
else
	echo "Please install curl or wget"
	exit -1
fi

$CURL $SOURCE || exit -6
md5sum -c ml-100k.zip.md5 && $EXT ml-100k.zip || exit -66
