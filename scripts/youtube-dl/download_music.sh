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
      local title
      if ! title=$(yt-dlp --get-title "$url"); then
        error "Music directory selection failed: $title"
        return 1
      fi
      info "Downloading \"$title\"".

      verbose "Opening \"$url\"."
      firefox -P Alternate "$url" &>/dev/null &

      verbose "Getting info about \"$url\" and selecting music directory."
      if ! download_dir=$(select_music_directory "$title"); then
        error "Music directory selection failed: $download_dir"
        return 1
      fi
      # Remove any trailing slashes.
      download_dir=${download_dir%/}

      local is_album=false
      # TODO: Improve this detection - see if we are working with a playlist (multiple lines).
      if [[ $download_dir =~ ^.+Music\ Artists/.+/.+$ ]]; then
        info "This looks like an album, won't ask about trimming."
        is_album=true
      fi

      if [[ $download_dir != "SKIP" ]]; then
        verbose "Downloading to \"$download_dir\"."
        local output_str="$download_dir/%(title)s.%(ext)s"
        if ! yt-dlp -q -o "$output_str" -x --audio-format mp3 --embed-thumbnail "$url"; then
          error "An error occured while downloading the file."
          return 1
        fi

        # Force MP3 here because otherwise it might return video formats, for YouTube videos.
        local file_paths
        file_paths=$(yt-dlp -o "$download_dir/%(title)s.mp3" --get-filename "$url")
        # In the case of a playlist, there will be newlines in "file_paths". Iterate over them.
        while IFS= read -r file_path; do
          verbose "Cropping + trimming."
          if [[ $url == *"soundcloud"* ]]; then
            local crop=false
          else
            local crop=true
          fi
          # Music in an album shouldn't need to be trimmed.
          if [[ $is_album == true ]]; then
            local trim=false
          else
            local trim=true
          fi
          if ! trim_err=$(trim "$file_path" "$crop" "$trim"); then
            error "An error occurred while cropping/trimming the file: $trim_err"
            return 1
          fi

          if ! tag_err=$(tag_mp3 "$file_path" "$is_album"); then
            error "An error occurred while tagging the file: $tag_err"
            return 1
          fi
        done <<<"$file_paths"
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
