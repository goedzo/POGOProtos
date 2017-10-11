#!/bin/bash

BASE_LOCATION=~/pgo
OUT_LOCATION=~/out

if [ -d $BASE_LOCATION ]; then
    echo "Deleting and recreating $BASE_LOCATION"
    rm -rf $BASE_LOCATION
    mkdir $BASE_LOCATION
else
    echo "Creating $BASE_LOCATION"
    mkdir $BASE_LOCATION
fi


if [ -d $OUT_LOCATION ]; then
    echo "Deleting and recreating $OUT_LOCATION"
    rm -rf $OUT_LOCATION
    mkdir $OUT_LOCATION
else
    echo "Creating $OUT_LOCATION"
    mkdir $OUT_LOCATION
fi

if [ -d $BASE_LOCATION/pogoprotos ]; then
    echo "Removing $BASE_LOCATION/pogoprotos"
    rm -rf $BASE_LOCATION/pogoprotos
fi

git clone -b master https://github.com/nbq/POGOProtos $BASE_LOCATION/pogoprotos

if [ -d $BASE_LOCATION/pogoprotos ]; then
    echo "Removing $BASE_LOCATION/pgoapi"
    rm -rf $BASE_LOCATION/pgoapi
fi

echo "Cloning Repo to $BASE_LOCATION/pgoapi"
git clone -b 0.73.1 https://github.com/nbq/pgoapi $BASE_LOCATION/pgoapi

echo "Copy $BASE_LOCATION/pogoprotos/run.sh to $BASE_LOCATION/run.sh"
cp -f $BASE_LOCATION/pogoprotos/run.sh $BASE_LOCATION/run.sh
chmod +x $BASE_LOCATION/run.sh

echo "Change Directory to $BASE_LOCATION/pogoprotos"
cd $BASE_LOCATION/pogoprotos

echo "Running Python Compile"
python compile.py python

echo "Create out.tar.gz from out"
tar -zcvf out.tar.gz out

echo "Copy out.tar.gz to $OUT_LOCATION"
cp out.tar.gz $OUT_LOCATION

echo "Change Directory to out"
cd out

echo "Copy pogoprotos to ../../pgoapi/pgoapi/protos"
cp -Rf pogoprotos ../../pgoapi/pgoapi/protos

echo "Change Directory to $BASE_LOCATION"
cd $BASE_LOCATION

echo "Create pgoapi.tar.gz from pgoapi"
tar -zcvf pgoapi.tar.gz pgoapi

echo "Copy pgoapi.tar.gz to $OUT_LOCATION"
cp pgoapi.tar.gz $OUT_LOCATION
