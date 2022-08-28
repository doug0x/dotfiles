function sd
   cd ~ && cd (find * -type d | fzf) $argv
end
