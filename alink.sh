#!/bin/bash

shell=$(echo $SHELL | grep '/\w*/\w*' | cut -d '/' -f 3-)	

function reload() {
    if [ "$shell"=="bash" ]; then
        source $HOME/.bashrc
    elif [ "$shell"=="zsh" ]; then
	source $HOME/.zshrc
    fi	
}


if [ "$1" == "-i" ]; then
    if [ -f $HOME/.alink/alink.sh ]; then
        echo "- alink already installed !"
    else
        mkdir $HOME/.alink/
    
    	for file in alink.sh alink.conf; do
        	cp $file $HOME/.alink/
    	done

	echo "- alink successfully installed !"	
    	bash alink.sh alink.sh alink	
    
	reload
    fi

elif [[ "$1" != "" && $2 != "" ]]; then
    ext=$(echo $1 | grep '\.\w*' | cut -d "." -f 2)
    
    if [ -f $HOME/.alink/alink.sh ]; then
    	runner=$(grep $ext' \w*' $HOME/.alink/alink.conf | cut -d " " -f 2-)
    else
    	runner=$(grep $ext' \w*' alink.conf | cut -d " " -f 2-)
    fi

    path=$(pwd)
    com="alias $2='$runner $path/$1'"
    shell=".$shell""rc"
    echo $com >> $HOME/$shell
	
    reload

else
    echo  "usage  :  alink [SCRIPT] [NAME_TO_LINK]"
    echo  "arg    :  -i : insall the alink on your system"
    echo  "example:  alink ghost.py ghost"
fi

