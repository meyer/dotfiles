# Requires boxes and toilet (brew install boxes toilet)
function unicorn
  set -lx argLen (count $argv)
  switch $argLen
  case 0 1
    shout "u fucked up"
  case "*"
    switch $argv[1]
    case say think
      shout $argv[2..-1] | boxes -a c -d "unicorn$argv[1]" | toilet --gay -t -f term
    case "*"
      shout "u fucked up again"
    end
  end
end
