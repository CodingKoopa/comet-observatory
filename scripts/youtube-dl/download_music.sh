#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh
# shellcheck source=scripts/youtube-dl/select_music_directory.sh
source "$CO"/scripts/youtube-dl/select_music_directory.sh
# shellcheck source=scripts/sqlite3/firefox_music_bookmarks.sh
source "$CO"/scripts/sqlite3/firefox_music_bookmarks.sh
# shellcheck source=scripts/eyed3/tag_mp3.sh
source "$CO"/scripts/eyed3/tag_mp3.sh

# Downloads music from the Firefox music folder.
# Outputs:
#   - Download progress.
# Returns:
#   - 0 if successful.
#   - 1 if an error occurred at any point.
function download_music() {
  verbose "Closing Firefox to unlock the bookmark database."
  if pkill firefox; then
    # If there was an existing Firefox process, give it a second to close.
    sleep 1
  fi

  info "Downloading music from Firefox music bookmark folder."
  if local -r urls=$(get_bookmark_urls "Listening List"); then
    for url in $urls; do
      verbose "Opening \"$url\"."
      firefox -P Alternate "$url" &

      verbose "Getting info about \"$url\" and selecting music directory."
      if ! download_dir=$(select_music_directory "$(youtube-dl --get-title "$url")"); then
        error "Music directory selection failed: $download_dir"
        return 1
      fi

      if [[ $download_dir != "SKIP" ]]; then
        verbose "Downloading to \"$download_dir\"."
        local output_str="$download_dir/%(title)s.%(ext)s"
        if ! youtube-dl -q -o "$output_str" -x --audio-format mp3 --embed-thumbnail "$url"; then
          error "An error occured while downloading the file."
          return 1
        fi

        # Force MP3 here because otherwise it might return video formats, for YouTube videos.
        local file_path
        file_path=$(youtube-dl -o "$download_dir/%(title)s.mp3" --get-filename "$url")
        verbose "Cropping + trimming."
        if [[ $url == *"soundcloud"* ]]; then
          local crop=false
        else
          local crop=true
        fi
        if ! trim_err=$(trim "$file_path" "$crop"); then
          error "An error occurred while cropping/trimming the file: $trim_err"
        fi

        if ! tag_err=$(tag_mp3 "$file_path"); then
          error "An error occurred while tagging the file: $tag_err"
        fi
      fi

      verbose "Removing bookmark."
      if ! rem_err="$(remove_firefox_bookmark "Listening List" "$url")"; then
        error "An error occurred while removing the bookmark: $rem_err."
        return 1
      fi
    done
  else
    error "An error occurred while getting the Firefox bookmarks: $urls"
    return 1
  fi
  return 0
}
