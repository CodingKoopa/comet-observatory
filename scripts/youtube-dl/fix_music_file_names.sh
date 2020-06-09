#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh

declare -r MUSIC_DIRECTORY=$HOME/Music

# Fixes youtube-dl default filenames.
# Outputs:
#   - Fixing progress.
function fix_music_file_names() {
  info "Checking music file names for Youtube video IDs."

  if [[ ! -d "$MUSIC_DIRECTORY" ]]; then
    error "Music directory \"$MUSIC_DIRECTORY\" not found."
    return 1
  fi

  # TODO: soundcloud downloads
  find "$MUSIC_DIRECTORY" -type f -name '*.mp3' -o -name '*.wav' | while read -r FILE_PATH; do
    local -r file_name=$(basename "$FILE_PATH")
    local -r file_directory=$(dirname "$FILE_PATH")
    # -[-|0-9|A-Z|_|a-z]{11}\.(mp3|wav)$ is the regex used for detecting music downloaded with the
    # default youtube-dl settings, with the video ID in its name.
    # -                   The dash yotube-dl inserts to divide the video title from the video ID.
    # {11}                There's 11 of the random characters.
    # \.                  Escape the file extention dot.
    # [-|0-9|A-Z|_|a-z]   Any of the possible characters in a video ID.
    # (mp3|wav)           The two currently supported file extentions.
    # $                   The end of the string.
    if [[ $file_name =~ -[-|0-9|A-Z|_|a-z]{11}\.(mp3|wav)$ ]]; then
      # The 16 here is made up of: 1 char dash + 11 char video ID + 3 char extention + 1 char dot.
      local -r new_file_name=${file_name:0:${#file_name}-16}${file_name: -4}
      info "$file_name -> $new_file_name"
      mv "$file_directory"/"$file_name" "$file_directory"/"$new_file_name"
    fi
  done
  info "Checking finished."
}
