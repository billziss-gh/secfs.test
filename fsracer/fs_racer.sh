#!/bin/bash
################################################################################
##                                                                            ##
## Copyright (c) Dan Carpenter., 2004                                         ##
##                                                                            ##
## This program is free software;  you can redistribute it and#or modify      ##
## it under the terms of the GNU General Public License as published by       ##
## the Free Software Foundation; either version 2 of the License, or          ##
## (at your option) any later version.                                        ##
##                                                                            ##
## This program is distributed in the hope that it will be useful, but        ##
## WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY ##
## or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License   ##
## for more details.                                                          ##
##                                                                            ##
## You should have received a copy of the GNU General Public License          ##
## along with this program;  if not, write to the Free Software               ##
## Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA    ##
##                                                                            ##
################################################################################

## DESCRIPTION:
## This test creates 20 files (0 thru 19) and then shuffles them around,
## deletes, and recreates them as fast as possible.  This is all done in
## an effort to test for race conditions in the filesystem code. This test
## runs until killed or Ctrl-C'd.  It is suggested that it run overnight
## with preempt turned on to make the system more sensitive to race
## conditions.

[[ $# -eq 2 ]] || { echo "usage: fs_racer.sh DURATION DIR" 1>&2; exit 2; }
[[ -d "$2" ]] || { echo "directory '$2' not found" 1>&2; exit 1; }

MAX_FILES=20
CLEAR_SECS=30
DURATION="$1"
DIR=$(cd "$2" && pwd)
cd $(dirname "$0")

execute_test()
{
[ -e $DIR ] || mkdir $DIR
./fs_racer_file_create.sh $DIR $MAX_FILES &
./fs_racer_file_create.sh $DIR $MAX_FILES &
./fs_racer_file_create.sh $DIR $MAX_FILES &

./fs_racer_dir_create.sh $DIR $MAX_FILES &
./fs_racer_dir_create.sh $DIR $MAX_FILES &
./fs_racer_dir_create.sh $DIR $MAX_FILES &

./fs_racer_file_rename.sh $DIR $MAX_FILES &
./fs_racer_file_rename.sh $DIR $MAX_FILES &
./fs_racer_file_rename.sh $DIR $MAX_FILES &

./fs_racer_file_link.sh $DIR $MAX_FILES &
./fs_racer_file_link.sh $DIR $MAX_FILES &
./fs_racer_file_link.sh $DIR $MAX_FILES &

./fs_racer_file_symlink.sh $DIR $MAX_FILES &
./fs_racer_file_symlink.sh $DIR $MAX_FILES &
./fs_racer_file_symlink.sh $DIR $MAX_FILES &

./fs_racer_file_concat.sh $DIR $MAX_FILES &
./fs_racer_file_concat.sh $DIR $MAX_FILES &
./fs_racer_file_concat.sh $DIR $MAX_FILES &

./fs_racer_file_list.sh $DIR &
./fs_racer_file_list.sh $DIR &
./fs_racer_file_list.sh $DIR &

./fs_racer_file_rm.sh $DIR $MAX_FILES &
./fs_racer_file_rm.sh $DIR $MAX_FILES &
./fs_racer_file_rm.sh $DIR $MAX_FILES &
}

trap "kill 0" EXIT
execute_test
sleep "$DURATION"
