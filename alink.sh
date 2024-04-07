#!/bin/bash

# Getting user's shell
shell=$(echo $SHELL | rev | cut -d / -f 1 | rev)
rc_dest=."$shell"rc

# Try to install alink if user passed -i flag
if [ "$1" == "-i" ]; then
    if [ -f $HOME/.alink/alink.sh ]; then
        echo "[+] alink already installed !"

    else
        mkdir $HOME/.alink/

    	for file in alink.sh alink.conf; do
        	cp $file $HOME/.alink/
    	done

        echo "[+] alink successfully installed !"
    fi

    if [[ -z $(grep "alias fnote" $HOME/$rc_dest) ]]
    then
        echo "alias alink='bash $HOME/.alink/alink.sh'" >> $HOME/$rc_dest
    fi

# Try to make an alias if user passed two arguments
elif [[ $1 && $2 ]]; then
    # Getting extension of the file
    ext=$(echo $1 | grep '\.\w*' | cut -d "." -f 2)

    if [ -f $HOME/.alink/alink.conf ]
    then
        if [ $ext ]
        then
            runner=$(grep $ext' \w*' $HOME/.alink/alink.conf | cut -d " " -f 2-)

        elif [ $(file $1 | grep -Eo "executable") ]
        then
            exeable=true

        else
            echo "[!] file type unknown! $1"
            exit 1
        fi

    else
        echo "[!] $HOME/.alink/alink.conf is missing !"
        echo "[!] run the alink with -i falg to fix the problem. Then try again"
        exit 2
    fi

    if [[ -z $(grep "alias $2" $HOME/$rc_dest) ]]
    then
        file_path=$(echo $1 | sed -r "s/\w*\.\w*//")
        file_name=$(echo $1 | sed -r "s/(\w*\/)*//")

        # Checking for full path
        if [[ $file_path =~ [a-zA-Z]*/[a-zA-Z]* ]]
        then
            path=$1

        else
            path=$(pwd)
        fi

        # preparing the alias for the program
        com="alias $2='$runner $path/${file_name}'"

        if [ $exeable ]
        then
            com="alias $2='$path/./${file_name}'"
        fi

        echo $com >> $HOME/$rc_dest
        echo "[+] alink : $2 [OK], reload your shell and you're good to go :)"

    else
        echo "[!] alink : $2 [NO], alias already exists !"
    fi

# Prints the usage to the standard output if arguments weren't specified.
else
    echo  "usage  :  alink [SCRIPT] [ALIAS-NAME] && source ~/${rc_dest}"
    echo  "arg    :  -i : insall the alink on your system"
    echo  "example:  alink ghost.py ghost && source ~/.zshrc"
fi
