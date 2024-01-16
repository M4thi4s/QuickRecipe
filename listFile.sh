#!/bin/bash

# Vérifie si un répertoire a été donné en argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Parcourt récursivement les fichiers dans le répertoire
find "$1" -type f | while read -r file; do
    echo "----------------------------------"
    echo "File Path: $file"
    echo "----------------------------------"
    cat "$file"
    echo
    echo
done
