function gll
   git pull $argv
end

function gt
   git status $argv
end

function gp
   git push $argv 
end

function gm
   git commit -m $argv
end

function gd
   git add $argv
end 

function vv
   nvim $argv
end 

function vd
   nvim ./ $argv
end

function up
   sudo pacman -Syyu $argv
end 
