#!/bin/bash

# Dependencies:
#  - "/scripts/bash/common.sh"
#  - "/scripts/youtube-dl/select_music_directory.sh"
#  - "/scripts/firefox/music_bookmarks.sh"

# shellcheck source=../bash/common.sh
source "$COMET_OBSERVATORY/scripts/bash/common.sh"
# shellcheck source=../youtube-dl/select_music_directory.sh
source "$COMET_OBSERVATORY/scripts/youtube-dl/select_music_directory.sh"
# shellcheck source=../sqlite3/firefox_music_bookmarks.sh
source "$COMET_OBSERVATORY/scripts/sqlite3/firefox_music_bookmarks.sh"
# shellcheck source=../eyed3/tag_mp3.sh
source "$COMET_OBSERVATORY/scripts/eyed3/tag_mp3.sh"

# Downloads music from the Firefox music folder.
download_music()
{
  info "Downloading music from Firefox music bookmark."
  MUSIC_LIST=$(get_music_list)
  for URL in $MUSIC_LIST; do
    info "Getting info about \"$URL\" and selecting music directory."
    FILE_PATH=$(select_music_directory "$(youtube-dl --get-title "$URL")")
    if [ $? -eq 1 ]; then
      error "An error occured while selecting a music directory."
      return 1
    fi
    info "Downloading to \"$FILE_PATH\"."
    if ! youtube-dl -o "$FILE_PATH/%(title)s.%(ext)s" -x --audio-format mp3 --embed-thumbnail "$URL"; then
      error "An error occured while downloading the file."
      return 1
    fi
    info "Removing bookmark."
    remove_bookmark "$URL"
  done
}
