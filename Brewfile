tap "borkdude/brew"
tap "clojure/tools"
tap "clojure-lsp/brew"
tap "d12frosted/emacs-plus"
tap "elastic/tap"
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/core"
tap "homebrew/services"

brew "aspell"
brew "bash"
brew "bash-completion@2"
brew "bat"
brew "chezmoi"
# To build libgit
brew "cmake"
brew "coreutils"
brew "curl"
brew "exa"
brew "fd"
brew "ffmpeg" # used by youtube-dl
brew "gcc"
brew "gnutls"
brew "git"
brew "hexyl"
brew "htop"
brew "jq"
# Mac App Store command-line util
brew "mas"
# For the system Java wrappers to find this JDK, symlink it with
#  sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
brew "openjdk@11"
brew "pass"
brew "restic"
brew "ripgrep"
brew "rust-analyzer"
brew "rustup-init"
brew "shellcheck"
brew "sk"
brew "starship"
brew "tectonic"
brew "terminal-notifier"
brew "tmux"
brew "tokei"
brew "tree"
brew "vim"
brew "youtube-dl"

brew "borkdude/brew/babashka"
brew "clojure/tools/clojure"
brew "clojure-lsp/brew/clojure-lsp-native"
brew "d12frosted/emacs-plus/emacs-plus@28"
brew "elastic/tap/elasticsearch-full", restart_service: :changed

## Services
brew "postgresql@13", restart_service: :changed, link: true
brew "redis", restart_service: :changed

cask "1password"
cask "aerial"
cask "alfred"
cask "arq"
cask "anybar"
cask "calibre"
cask "cleanmymac"
cask "daisydisk"
cask "dash"
cask "discord"
cask "docker"
cask "font-hack-nerd-font"
cask "gpg-suite" # gpg-tools
cask "intellij-idea"
cask "istat-menus"
cask "iterm2"
cask "keybase"
cask "kobo"
cask "launchcontrol"
cask "mattermost"
cask "monitorcontrol"
cask "obsidian"
cask "openaudible"
cask "plexamp"
cask "rectangle"
cask "ringcentral"
cask "spotify"
cask "transmit"
cask "viscosity"
cask "webex"
cask "wireshark"
cask "zotero"

# gaming
cask "battle-net"
cask "gog-galaxy"
cask "minecraft"
cask "nvidia-geforce-now"
cask "steam"

# mac app store
mas "Things 3", id: 904280696
mas "HomeControl", id: 1547121417
mas "Reeder", id: 1529448980
mas "Deliveries", id: 290986013
