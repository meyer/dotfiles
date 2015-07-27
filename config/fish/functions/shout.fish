function shout
	echo $argv | tr '[:lower:]' '[:upper:]' | sed 's/.\{1\}/& /g'
end