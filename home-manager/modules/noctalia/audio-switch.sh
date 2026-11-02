# shellcheck shell=bash
# Routes audio to exactly one card and turns all others off, so
# pipewire's automatic port switching can't pick the wrong device.
# `audio-switch list` feeds the noctalia launcher (name<TAB>card),
# `audio-switch <line>` activates the chosen device.

# Adding a device: append one line to `devices`, then run `hm switch`.
#   name     Label shown in the launcher. No ', | or tabs, it ends up in a
#            single-quoted shell string.
#   card     From `pactl list cards short`. Bluetooth cards only exist while
#            connected, so derive those from the address:
#            AA:BB:CC:DD:EE:FF -> bluez_card.AA_BB_CC_DD_EE_FF
#   profile  Exact text before the first ": " under "Profiles:" in
#            `pactl list cards`, spaces included. Bluetooth speakers and
#            headphones normally use a2dp-sink.
#   address  Bluetooth only, from `bluetoothctl devices Paired`. Leave empty
#            for wired cards.
# Choosing a device turns off every other card listed here and disconnects
# every other Bluetooth address listed here, so list audio devices only.
#
# name|card|profile|bluetooth address
devices=(
  "speakers|alsa_card.pci-0000_64_00.6|HiFi (Mic1, Mic2, Speaker)|"
  "headphones (jack)|alsa_card.pci-0000_64_00.6|HiFi (Headphones, Mic1, Mic2)|"
  "hdmi|alsa_card.pci-0000_64_00.1|HiFi|"
  "UBA|bluez_card.78_2B_64_A0_14_84|a2dp-sink|78:2B:64:A0:14:84"
  "Onyx Studio 6|bluez_card.98_52_3D_3E_53_A3|a2dp-sink|98:52:3D:3E:53:A3"
)

if [[ ${1:-} == list ]]; then
  for d in "${devices[@]}"; do
    IFS='|' read -r name card _ _ <<<"$d"
    printf '%s\t%s\n' "$name" "$card"
  done
  exit 0
fi

selected=${1%%$'\t'*}
target=
for d in "${devices[@]}"; do
  [[ ${d%%|*} == "$selected" ]] && target=$d
done
if [[ -z $target ]]; then
  notify-send -a audio-switch "Audio" "Unknown device: $selected"
  exit 1
fi
IFS='|' read -r _ target_card target_profile target_bt <<<"$target"

declare -A seen_bt seen_card
for d in "${devices[@]}"; do
  IFS='|' read -r _ card _ bt <<<"$d"
  if [[ -n $bt && -z ${seen_bt[$bt]:-} ]]; then
    seen_bt[$bt]=1
    if [[ $bt == "$target_bt" ]]; then
      bluetoothctl connect "$bt" || true
    else
      bluetoothctl disconnect "$bt" || true
    fi
  fi
  if [[ $card != "$target_card" && -z ${seen_card[$card]:-} ]]; then
    seen_card[$card]=1
    # Bluetooth cards vanish when disconnected, so this may fail.
    pactl set-card-profile "$card" off || true
  fi
done

if ! err=$(pactl set-card-profile "$target_card" "$target_profile" 2>&1); then
  notify-send -a audio-switch -u critical "Audio" "$selected: $err"
  exit 1
fi

pactl list short sinks | cut -f1 | xargs -r -n1 pamixer --unmute --sink
pactl list short sources | cut -f1 | xargs -r -n1 pamixer --unmute --source
notify-send -a audio-switch "Audio" "$selected connected"
