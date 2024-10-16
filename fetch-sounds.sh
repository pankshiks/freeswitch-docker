#!/bin/bash
stack_sounds_get () {

    read -r -p "please choose sounds install directory [/usr/share/freeswitch/sounds]: " SOUNDS_DIR
    SOUNDS_DIR=${SOUNDS_DIR:-/usr/share/freeswitch/sounds}

    read -r -p "please choose file ownership permissions [freeswitch]: " SOUNDS_PERMS
    SOUNDS_PERMS=${SOUNDS_PERMS:-freeswitch}

    if [ ! -d /tmp/sounds ]; then
	mkdir -p /tmp/sounds/md5
	cd /tmp/sounds/md5 || { printf "error on line: %s\n" "$LINENO" && exit; }
    else
	cd /tmp/sounds/md5 || { printf "error on line: %s\n" "$LINENO" && exit; }
    fi
    #
    declare -a SOUNDS=(
        freeswitch-sounds-en-ca-june-8000-1.0.51.tar.gz
    )
    #
    for SOUND in "${SOUNDS[@]}"; do
        if [ ! -f /tmp/sounds/"$SOUND" ]; then
            wget -O /tmp/sounds/"$SOUND" https://files.freeswitch.org/releases/sounds/"$SOUND" || { printf "error on line: %s\n" "$LINENO" && exit; }
        fi
	if [ ! -f /tmp/sounds/md5/"$SOUND".md5 ]; then
            wget --quiet https://files.freeswitch.org/releases/sounds/"$SOUND".md5 || printf "No md5 found for %s. Skipping this md5\n" "$SOUND.md5"
	fi
        if [ -f /tmp/sounds/"$SOUND" ] && [ -f /tmp/sounds/md5/"$SOUND".md5 ]; then
            if [[ "$(md5sum -c /tmp/sounds/md5/"$SOUND".md5)" =~ OK ]]; then
                printf "md5sum for %s passed... installing...\n" "$SOUND"
		tar -zxvf /tmp/sounds/"$SOUND" -C "$SOUNDS_DIR" || { rm -rf /tmp/sounds/"$SOUND" && printf "error with sound file %s on line %s\nRemoved sound file, please run again.\n" "$SOUND" "$LINENO" && exit; }
	    else
                rm -rf /tmp/sounds/"$SOUND"
                rm -rf /tmp/sounds/md5/"$SOUND".md5
                printf "The md5sum for %s failed.\n" "$SOUND"
		printf "The sounds tarball and md5 have been removed. Trying running script again... \n"
		exit
	    fi
	elif [ -f /tmp/sounds/"$SOUND" ]; then
	    printf "There is no md5 for %s... installing without integrity check...\n" "$SOUND"
	    tar -zxvf /tmp/sounds/"$SOUND" -C "$SOUNDS_DIR" || { rm -rf /tmp/sounds/"$SOUND" && printf "error with sound file %s on line %s\nRemoved sound file, please run again.\n" "$SOUND" "$LINENO" && exit; }
	else
	    printf "something went wrong installing %s... seems to be missing...\n" "$SOUND"
	    exit
	fi
    done
    chown -R "$SOUNDS_PERMS" "$SOUNDS_DIR" || { printf "error on line: %s\n" "$LINENO" && exit; }
    ls -la /usr/share/freeswitch/sounds || { printf "error on line: %s\n" "$LINENO" && exit; }
    printf "all done installing sounds.\n"
}
stack_sounds_get
