
# Set fish autosuggestion color to cyan
set -g fish_color_autosuggestion E0FFFF

set -l configf ~/.config/fish/functions

# Fish prompt
source $configf/prompt.fish

# Fastfetch
fastfetch -l $HOME/Pictures/Collected/claire.jpg --logo-padding 2 --logo-padding-top 1 --logo-height 18 

# Custom aliases
source $configf/aliases.fish 2>/dev/null

if status is-interactive
# Commands to run in interactive sessions can go here
end



