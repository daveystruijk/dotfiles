#=== General ===#

# Shorthand find (current dir, case-insensitive)
function s() {
  find . -iname "*$1*"
}

# Full search & replace using ag
function agr { ag -0 -l "$1" | AGR_FROM="$1" AGR_TO="$2" xargs -0 perl -pi -e 's/$ENV{AGR_FROM}/$ENV{AGR_TO}/g'; }


# Save all python deps to requirements.txt
function pip_save() {
	pip install $1 && pip freeze | grep -i $1 >> './requirements.txt'
}

# Mark/Recall
function mark() {
  echo $PWD > "$HOME/.mark"
}
function r() {
  dir=$(cat "$HOME/.mark")
  cd $dir
}

#=== Git ===#

function gitday() {
  git --no-pager log --after="$1 00:00" --before="$1 23:59" --author=davey --stat --reverse
}

function gitmonth() {
  for day in {0..31}
  do
    timestamp="2021-$1-$day"
    echo "=========="
    echo "$timestamp"
    echo "=========="
    gitday $timestamp
  done
}

