#!/bin/bash

if [ "$1" == "-i" ]; then

    if [ -f $HOME/.alink/alink.sh ]; then
        echo "- alink already installed !"
    else
        mkdir $HOME/.alink/
    fi
    
    for file in alink.sh alink.conf; do
        cp $file $HOME/.alink/
    done

    bash alink.sh alink.sh alink
    echo "- alink successfully installed"
   
elif [[ "$1" != "" && $2 != "" ]]; then
    shell=$(echo $SHELL | grep '/\w*/\w*' | cut -d '/' -f 3-)	
    ext=$(echo $1 | grep '\.\w*' | cut -d "." -f 2)
    
    if [ -f $HOME/.alink/alink.sh ];then
    	runner=$(grep $ext' \w*' $HOME/.alink/alink.conf | cut -d " " -f 2-)
    else
    	runner=$(grep $ext' \w*' alink.conf | cut -d " " -f 2-)
    fi

    path=$(pwd)
    com="alias $2='$runner $path/$1'"
    shell=".$shell""rc"
    echo $com >> $HOME/$shell

else
    echo  "usage  :  alink [SCRIPT] [NAME_TO_RUN]"
    echo  "arg    :  -i : insall the alink on your system"
    echo  "example:  alink ghost.py ghost"
fi

