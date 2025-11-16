#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# Set functions and aliases.

# Reloads this script.
# Globals Exported:
#   - Everything exported in this script.
function r() {
  clear
  # shellcheck source=scripts/bash/bash_rc.sh
  source ~/.bashrc
}

# Exports the contents of an "ENV" file.
# Arguments:
#   - The path to the "ENV" file.
function export-env() {
  set -o allexport
  # shellcheck source=/dev/null
  source "$1"
  set +o allexport
}

# Downloads an MP4.
# Arguments:
#   - The URL.
#   - The name of the video.
function d() {
  local -r MP4=$HOME/Videos/MP4s/$2.mp4
  if [ -f "$MP4" ]; then
    echo "already exists lol"
  else
    yt-dlp "$1" -f mp4 -o "$MP4"
  fi
}

# Strips leading "v" from all Git tags.
# Outputs:
#   - Git output, and tag status.
function retag() {
  local -a tags
  echo retag
  tags=$(git tag -l)
  while IFS= read -r tag; do
    if [[ $tag =~ ^v.+$ ]]; then
      message=$(git tag -l -n1 --format='%(contents)' "$tag" | head -n1)
      echo "Fixing $tag ($message)"
      local tag_new=${tag#v}
      git tag -f "$tag_new" "$tag"^{} -m "$message" &&
        git tag -d "$tag" &&
        git push origin :refs/tags/"$tag" &&
        git push --tags
    fi
  done <<<"$tags"
}

function wnea() {
  echo who needs eclipse anyways

  # https://askubuntu.com/a/1010708
  shopt -s globstar

  # build.
  javac -d Build Source/**/*.java || return 1

  # run.
  if [[ -n $1 ]]; then
    local -r main_class=$1
  else
    local -r main_class_file=$(grep "public static void main" . -rl | head -1)
    local -r main_class=apcs/$(basename "$main_class_file" | cut -d. -f1)
  fi
  java -cp Build "$main_class"
}

function ej() {
  prog=$1
  shift
  while true; do
    printf "Compiling:\n\n"
    j "$prog" "$@"
    read -rp "..."
  done
}

function j() {
  prog=$1
  shift
  javac "$prog".java && java "$prog" "$@"
}

function testpulse() {
  systemctl --user stop pulseaudio.{socket,service}
  pulseaudio -vvv
  pulseaudio -k
  systemctl --user start pulseaudio.{socket,service}
}

function killwine() {
  # shellcheck disable=SC2009
  local -r processes=$(ps -ef |
    grep -E -i '((wine|processid|\.exe)|pressure-vessel-adverb|reaper)' | awk '{print $2}')
  for process in $processes; do
    kill -9 "$process"
  done
}

function cleandocker() {
  docker buildx prune -a -f && docker system prune -a -f --volumes
}

alias p=pnpm
alias g=git
alias gdiff="git diff --no-index"
alias cdiff="diff --color=always"
alias play='DISPLAY= mpv --really-quiet -vo caca'
alias btc=bluetoothctl
alias activate="source .venv/bin/activate"

# Customize the prompt if we're not in a login shell. If we are in a login shell, we're probably
# in a TTY that doesn't support this fancy stuff.

if [[ $1 != "l" ]]; then
  # Don't use Agnoster for login shells, because TTYs lack ligature font support by default.
  # shellcheck source=scripts/bash/agnoster_bash.sh
  source "$CO"/scripts/bash/agnoster_bash.sh

  # The bind command also seems to be broken in the TTY.

  # Enable case insensitive matching.
  bind "set completion-ignore-case on"
  # Immediately show all options if there is ambiguity.
  bind "set show-all-if-ambiguous on"
else
  # x2go has issues here - TERM is unset.
  if [[ -z "$TERM" ]]; then
    # If here, we're in a TTY.
    setterm -cursor on
  fi
fi

# https://askubuntu.com/questions/70750/how-to-get-bash-to-stop-escaping-during-tab-completion
shopt -s globstar

