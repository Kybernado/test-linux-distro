#!/bin/bash

function print_usage {
	echo "Usage: $0 <disk> <initfs>"
}

if [ -z "$1" ] || [ -z "$2" ]; then
	print_usage
	exit 1;
fi

OUTPUT_NAME=$1
FOLDER=$2
BLOCK_SIZE=512
BLOCK_COUNT=2097152
REAL_USER_ID=$(ps -o ruid= -p $PPID | cut -d ' ' -f2)
DEPENDENCIES=("id" "rm" "getent" "mount" "mkfs.ext4" "dd" "cp" "umount")
DEPS_NOT_SATISFIED=0


function check_for_error {
	if [[ $? != 0 ]]; then
		echo $2
		if [[ $1 == 1 ]]; then
			exit 1
		fi
	else
		echo $3
	fi	
}

for DEP in ${DEPENDENCIES[@]}; do
	XDG_NOTIFY=$(command -v "notify-send" 2> /dev/null)
	LOCATION=$(command -v $DEP 2> /dev/null)
	if test "$LOCATION" == ""; then
		echo "$DEP was not found" 2>&1
		DEPS_NOT_SATISFIED=1
	fi
done
if [[ $DEPS_NOT_SATISFIED == 1 ]]; then
	exit 1
fi



# Check if running as root
echo "Checking if running as root..."
if [[ $(id -u) != 0 ]]; then
	echo "No. This script must be run as root (UID 0), with sudo or su." >&2
	exit 1
fi
echo $OUTPUT_NAME
echo "Running as root."

if [[ -e "$OUTPUT_NAME" ]]; then
    echo "Deleting old disk image ($OUTPUT_NAME)"
    rm $OUTPUT_NAME
    check_for_error 1 "Error deleting old disk image file." "Successfully deleted old disk image file"
fi


echo "Creating disk image file..."
su - $(getent passwd $REAL_USER_ID | cut -d: -f1) -c " 
	cd $(pwd)
	dd if=/dev/zero of=$OUTPUT_NAME bs=$BLOCK_SIZE count=$BLOCK_COUNT status=progress
	if [[ $? != 0 ]]; then
		exit 1
	fi
"
check_for_error 1 "Failed creating disk image file." "Disk image created successfully."

echo "Creating filesystem on created disk image file..."
mkfs.ext4 "$OUTPUT_NAME"
check_for_error 1 "Failed creating filesystem on disk image." "File system created successfully."

echo "Mounting finished disk image file..."
mount "$OUTPUT_NAME" /mnt
check_for_error 1 "Failed to mount disk image." "Disk image mounted successfully."

cd $FOLDER
echo "Copying files to disk..."
cp -r ./* /mnt/
chown root:root /mnt/*
chmod u+s /mnt/bin/su /mnt/bin/mount /mnt/bin/umount
check_for_error 0 "There was an error while copying files to disk image." "Successfully copied all files."
cd ..

echo "Unmounting disk image..."
umount /mnt
check_for_error 0 "Failed to unmount disk image." "Disk image unmounted successfully"

echo "Disk creation was successfull!"