#!/bin/bash

shell=$(echo $SHELL | rev | cut -d / -f 1 | rev)
rc_dest=."$shell"rc

if [ "$1" == "-i" ]; then
    if [ -f $HOME/.alink/alink.sh ]; then
        echo "- alink already installed !"
    else
        mkdir $HOME/.alink/
    
    	for file in alink.sh alink.conf; do
        	cp $file $HOME/.alink/
    	done

	echo "- alink successfully installed !"	
	echo "alias alink='bash $HOME/.alink/alink.sh'" >> $HOME/$rc_dest
    fi

elif [[ $1 && $2 ]]; then
    ext=$(echo $1 | grep '\.\w*' | cut -d "." -f 2)
    
    if [ -f $HOME/.alink/alink.sh ]; then
    	runner=$(grep $ext' \w*' $HOME/.alink/alink.conf | cut -d " " -f 2-)
    else
    	runner=$(grep $ext' \w*' alink.conf | cut -d " " -f 2-)
    fi

    path=$(pwd)
    com="alias $2='$runner $path/$1'"
    echo $com >> $HOME/$rc_dest

else
    echo  "usage  :  alink [SCRIPT] [NAME_TO_LINK] && source ~/.[YOUR-SHELL]rc"
    echo  "arg    :  -i : insall the alink on your system"
    echo  "example:  alink ghost.py ghost && source ~/.zshrc"
fi

