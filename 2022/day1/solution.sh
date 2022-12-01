set -e

# the argument gets the top N values
N=$1
N=${N:-1}

CURR_CALORIES=0
EOF=0
process_elf_calories() {
  local calories=0
  local got_eof=1
  while read line
  do
    if [[ -z "$line" ]]
    then
      got_eof=0
      break
    fi

    calories=$(($line + $calories))
  done

  CURR_CALORIES=$calories
  EOF=$got_eof
}

sum_calories() {
  local TOTAL_CALORIES=0
  while read line
  do
    TOTAL_CALORIES=$(($TOTAL_CALORIES + $line))
  done

  echo $TOTAL_CALORIES
}

find_max_elf_calories() {
  declare -a MAX_CALORIES

  while [[ $EOF == 0 ]]
  do
    process_elf_calories
    MAX_CALORIES+=($CURR_CALORIES)
  done

  {
    for calories in ${MAX_CALORIES[@]}
    do
      echo $calories
    done
  } | sort -n | tail -n $N | sum_calories
}

echo "Maximum calories: " $(find_max_elf_calories)
