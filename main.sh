#!/bin/bash

# where snapshots are being stored
STORAGE=/shots/
# what to snapshot
TARGET=/
# what is the interval of snapshots deletion
INTERVAL=10
# how the snapshot names would look like using GNU date
DISPLAY="%m.%d.%y-%H:%M:%S"

# optional logging
proclog () {
if [[ "$1" == "delete+create" ]]; then
	printf "tiny photographer: deleted '$old'\n"
	printf "tiny photographer: created '$STORAGE$time'\n"

elif [[ "$1" == "create" ]]; then
	printf "tiny photographer: created '$STORAGE$time'\n"

elif [[ "$1" == "stopped" ]]; then
	printf "tiny photographer: stopped\n"
fi
}

main() {
	# gets the amount of snapshots
	# something may break if in $STORAGE would be non snapshots
	count=$(ls $STORAGE | wc -l)
	
	# this is specifically for names
	time=$(date +${DISPLAY})

	if (( $count >= $INTERVAL )); then
		# finds the oldest snapshot and deletes it
		for f in $STORAGE*; do if [[ ! $old || $f -nt $old ]]; then old=$f; fi; done		
		btrfs su de $old/snapshot
		rmdir $old

		# creates a new snapshot and logs actions
		mkdir $STORAGE$time # additional directory is required to fix broken snapshot timestamps
		btrfs su sn $TARGET $STORAGE$time/snapshot
		btrfs pr set $STORAGE$time/snapshot ro true # optionally gives it read only permissions
		proclog delete+create
	else
		# creates a new snapshot and logs actions
		mkdir $STORAGE$time
		btrfs su sn $TARGET $STORAGE$time/snapshot
		btrfs pr set $STORAGE$time/snapshot ro true # optionally gives it read only permissions
		proclog create
	fi
}

# pause feature
# create anything with "stop" in the $STORAGE
# to stop tiny photographer
if ! [[ $(ls $STORAGE | grep stop) != "" ]]; then
	main
else
	proclog stopped
	exit
fi
