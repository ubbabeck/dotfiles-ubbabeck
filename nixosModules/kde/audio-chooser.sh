#!/usr/bin/nix-shell
#!nix-shell -i bash -p fuzzel pamixer pulseaudio libnotify bluez
#shellcheck shell=bash
set -exuo pipefail

choices=("headphones" "speakers" "headphones (output-only)" "earphones" "soundbar")
selected=$(printf "\n%s" "${choices[@]}" | fuzzel -d)

echo You Picked: " $selected"

headset=fixme
speakers=fixme
earphones=fixme
address=fixme
soundbar=fixme
webcam=fixme

notify() {
  notify-send -a audio-chooser "Audio Chooser" "$1"
}

# always disable webcam mic
pactl set-card-profile "$webcam" off || true

case $selected in
headphones)
  bluetoothctl disconnect "5C:56:A4:74:38:19" || true
  pactl set-card-profile "$headset" output:analog-stereo+input:mono-fallback || true
  pactl set-card-profile "$speakers" off || true
  pactl set-card-profile "$earphones" off || true
  pactl set-card-profile "$soundbar" off || true
  notify "Headphones Connected"
  ;;
speakers)
  bluetoothctl disconnect "$address" || true
  pactl set-card-profile "$speakers" output:analog-stereo+input:analog-stereo || true
  pactl set-card-profile "$headset" off || true
  pactl set-card-profile "$earphones" off || true
  pactl set-card-profile "$soundbar" off || true
  notify "Speakers Connected"
  ;;
"headphones (output-only)")
  bluetoothctl disconnect "$address" || true
  pactl set-card-profile "$headset" output:analog-stereo || true
  pactl set-card-profile "$speakers" off || true
  pactl set-card-profile "$earphones" off || true
  pactl set-card-profile "$soundbar" off || true
  notify "Headphones (Output-Only) Connected"
  ;;
"earphones")
  bluetoothctl connect "$address"
  pactl set-card-profile "$earphones" a2dp-sink || true
  pactl set-card-profile "$headset" off || true
  pactl set-card-profile "$speakers" off || true
  pactl set-card-profile "$soundbar" off || true
  notify "Earphones Connected"
  ;;
"soundbar")
  bluetoothctl disconnect "$address" || true
  pactl set-card-profile "$soundbar" output:analog-stereo || true
  pactl set-card-profile "$headset" off || true
  pactl set-card-profile "$speakers" off || true
  pactl set-card-profile "$earphones" off || true
  notify "Soundbar Connected"
  ;;
*)
  echo "Invalid Option $selected"
  notify "Invalid Option $selected"
  exit 1
  ;;
esac

pactl list short sinks | while read -r sink; do
  sink_idx=$(echo "$sink" | cut -f1)
  pamixer --unmute --sink "$sink_idx" || true
done

pactl list short sources | while read -r source; do
  source_idx=$(echo "$source" | cut -f1)
  pamixer --unmute --source "$source_idx" || true
done
