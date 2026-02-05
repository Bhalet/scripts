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
    set prev_bg $bg_dir
    set_color normal

    # Git segment
    if command -sq git
        set -l branch (git symbolic-ref --short HEAD 2>/dev/null)
        if test -n "$branch"
            set_color $prev_bg -b $bg_git
            echo -n $sep
            set_color $fg_text -b $bg_git
            echo -n '  ' $branch ' '
            set prev_bg $bg_git
	   set_color normal
        end
    end

    # Status segment (only on error)
    if test $last_status -ne 0
        set_color $prev_bg -b $bg_status
        echo -n $sep
        set_color $fg_text -b $bg_status
        echo -n ' ✖ ' $last_status ' '
        set prev_bg $bg_status
	set_color normal
    end

    # Trailing seperator
    set_color $prev_bg
    echo -n $sep

    # Reset
    set_color normal
    echo -n ' '
end
