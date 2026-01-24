
# Set fish autosuggestion color to cyan
set -g fish_color_autosuggestion E0FFFF

# No full/abrebiated path

function fish_prompt
    set -l last_status $status

    # Directory name (tilde-aware, basename only)
    set -l dir (basename "$PWD")
    if test "$PWD" = "$HOME"
    	set dir "~"
    end

    # Colors
    set -l bg_dir 3b4252     # dark neutral gray 
    set -l bg_git a3be8c     # muted green
    set -l bg_status bf616a  # red
    set -l fg_text eceff4

    # Powerline separator
    set -l sep ''

    # Directory segment
    set_color -b $bg_dir $fg_text
    echo -n ' ' $dir ' '

    # Git segment
    if command -sq git
        set -l branch (git symbolic-ref --short HEAD 2>/dev/null)
        if test -n "$branch"
            set_color -b $bg_git $bg_dir
            echo -n $sep
            set_color -b $bg_git $fg_text
            echo -n '  ' $branch ' '
        end
    end

    # Status segment (only on error)
    if test $last_status -ne 0
        set_color -b $bg_status $bg_git
        echo -n $sep
        set_color -b $bg_status $fg_text
        echo -n ' ✖ ' $last_status ' '
    end

    # Reset
    set_color normal
    echo -n ' '
end

# Fastfetch
fastfetch -l /home/shraddha/Pictures/Collection/pfp/miku.jpg
 
# Custom aliases
alias ls 'ls -a --color=auto'
alias grep 'grep --color=auto'
alias pm pacman
alias sdnow 'shutdown -h now'
alias nano vim

if status is-interactive
# Commands to run in interactive sessions can go here
end



