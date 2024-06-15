#! /bin/bash

if [ -d "./modules/$1" ]; then
    echo "Modules $1 exists."
else
    mkdir ./modules/$1
    touch ./modules/$1/main.tf
    touch ./modules/$1/variables.tf
    touch ./modules/$1/outputs.tf
fi