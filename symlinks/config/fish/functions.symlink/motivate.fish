# A product of my warped mind.
function motivate
  motivations=(
    "*borat voice* very nice"
    "doing it"
    "electrolytes"
    "whos a good boy"
    "T.G.I."(date +"%A" | head -c 1)
    )

  # DOING IT
  pick_one="$[($RANDOM % ${#motivations[*]}) + 1]"
  echo "\n$(unicorn say ${motivations[$pick_one]})\n"
end