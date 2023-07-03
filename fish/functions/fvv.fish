function fvv
  set selected_file (fzf)
  if test -n "$selected_file"
    nvim -u ~/.vimrc $selected_file
  end
end
