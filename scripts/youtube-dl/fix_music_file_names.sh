#!/bin/bash

# Dependencies:
#  - "$DOTFILES/scripts/bash/common.sh"
#  - "$DOTFILES/scripts/bash/config.sh"

# Fixes youtube-dl default filenames.
fix_music_file_names()
{
  info "Checking music file names for Youtube video IDs."
  # TODO: soundcloud downloads
  find "$MUSIC_DIRECTORY" -type f -name '*.mp3' -o -name '*.wav' | while read FILE_PATH; do
    FILE_NAME=$( basename "$FILE_PATH" )
    FILE_DIRECTORY=$( dirname "$FILE_PATH" )
    # -[-|0-9|A-Z|_|a-z]{11}\.(mp3|wav)$ is the regex used for detecting music downloaded with the
    # default youtube-dl settings, with the video ID in its name.
    # -                   The dash yotube-dl inserts to divide the video title from the video ID.
    # {11}                There's 11 of the random characters.
    # \.                  Escape the file extention dot.
    # [-|0-9|A-Z|_|a-z]   Any of the possible characters in a video ID.
    # (mp3|wav)           The two currently supported file extentions.
    # $                   The end of the string.
    if [[ $FILE_NAME =~ -[-|0-9|A-Z|_|a-z]{11}\.(mp3|wav)$ ]]; then
      # The 16 here is made up of: 1 char dash + 11 char video ID + 3 char extention + 1 char dot
      NEW_FILE_NAME=${FILE_NAME:0:${#FILE_NAME} - 16}${FILE_NAME: -4}
      info "$FILE_NAME -> $NEW_FILE_NAME"
      mv "$FILE_DIRECTORY/$FILE_NAME" "$FILE_DIRECTORY/$NEW_FILE_NAME"
    fi
  done
  info "Checking finished."
}
