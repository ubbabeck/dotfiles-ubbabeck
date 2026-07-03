# Shared borgbackup exclude patterns. Imported by nixosModules/borgbackup.nix
# and machines/flake-module.nix (clan client role settings) so both stay in sync.
[
  "*.pyc"
  "*.o"
  "*/node_modules/*"
  "/home/*/go/"
  "/home/*/.direnv"
  "/home/*/.cache"
  "/home/*/.cargo"
  "/home/*/.npm"
  "/home/*/.m2"
  "/home/*/.gradle"
  "/home/*/.opam"
  "/home/*/.clangd"
  "/home/*/.config/Ferdium/Partitions"
  "/home/*/.mozilla/firefox/*/storage"
  "/home/*/Android"
  "/var/lib/containerd"
  # already included in database backup
  "/var/lib/postgresql"
  "/var/lib/docker/"
  "/var/log/journal"
  "/var/lib/systemd" # not so interesting state so far
  "/var/lib/private/dendrite/searchindex"
  "/var/cache"
  "/var/tmp"
  "/var/log"

  "/home/ruben/Sync"
  "/home/ruben/Videos"
  "/home/ruben/mnt"
]
