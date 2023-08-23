if status is-interactive
    # Commands to run in interactive sessions can go here
end


function fish_mode_prompt; end

set fish_greeting
set -gx EDITOR /home/edjubert/.local/bin/lvim
set -g direnv_fish_mode disable_arrow
