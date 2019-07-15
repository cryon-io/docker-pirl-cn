#!/bin/sh

#  PIRL Content Node docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

GIT_INFO=$(curl -sL "https://git.pirl.io/api/v4/projects/63/releases")                                       
URL=$(printf "https://git.pirl.io/community/pirl%s" "$(printf "%s" "$GIT_INFO" | jq .[0].description | awk -F"|" '{for(i=1;i<=NF;i++){if(match($i,/Masternode-Content.*?/))print $(i+1)}}' | sed 's/.*\[.*\](\(.*\)).*/\1/g')")

if [ -f "./limits.conf" ]; then 
    if grep "NODE_BINARY=" "./limits.conf"; then 
        NODE_BINARY=$(grep "NODE_BINARY=" "./limits.conf" | sed 's/NODE_BINARY=//g')
        if [ -n "$NODE_BINARY" ] && [ ! "$NODE_BINARY" = "auto" ]; then
            URL=$NODE_BINARY
        fi
    fi
fi

FILE=pirl
curl -L "$URL" -o "./$FILE" 
cp -f "./$FILE" /usr/bin/pirl 2>/dev/null

printf "%s" "$(printf "%s" "$GIT_INFO" | jq .[0].tag_name -r | sed 's\v\\')" > ./version

exit 0