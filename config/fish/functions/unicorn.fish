# Requires boxes and toilet (brew install boxes toilet)
function unicorn
    set -lx argLen (count $argv)
	switch $argLen
	case 1
		shout "u fucked up"
	case "*"
		# if [eval $argv[1] = "say"] or [eval $argv[1] = "think"]
			shout $argv[2..-1] | boxes -a c -d "unicorn$argv[1]" | toilet --gay -t -f term
		# else
		# 	shout "param 1 needs to be shout or think."
		# end
	end
end

# unicorn say test hello wow
# unicorn think test string here