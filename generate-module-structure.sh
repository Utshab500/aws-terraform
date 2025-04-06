#! /bin/bash

read -p "Module name: " MODULE

if [ -d "./modules/$MODULE" ]; then
    echo "Modules $MODULE exists."
else
    mkdir ./modules/$MODULE
    touch ./modules/$MODULE/main.tf
    touch ./modules/$MODULE/variables.tf
    touch ./modules/$MODULE/outputs.tf
fi