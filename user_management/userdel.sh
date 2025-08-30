#!/bin/bash

echo "delete user"


userdel -r $1

echo "remove sudoers file"
rm -f /etc/sudoers.d/$1


