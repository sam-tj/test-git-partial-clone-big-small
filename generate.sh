#!/usr/bin/env bash
rm -rf .git small big
mkdir -p small big

# Use random bytes to make it uncompressible on the wire, requires Python 3.9.
# https://stackoverflow.com/questions/32329381/generating-random-string-of-seedable-data/66018128#66018128
randbytes() (
  python -c 'import random;import sys;random.seed(int(sys.argv[1]));sys.stdout.buffer.write(random.randbytes(int(sys.argv[2])))' "$@"
)

n=1000
randbytes 0 $n > tmp
cd small
split -a4 -b1 -d ../tmp ''
cd ..
rm tmp

i=0
while [ $i -lt 10 ]; do
  randbytes "$i" 10000000 > "big/$i"
  i=$(($i + 1))
done

date='2000-01-01T00:00:00+0000'
email=''
name='a'
export GIT_AUTHOR_DATE="$date"
export GIT_AUTHOR_EMAIL="$email"
export GIT_AUTHOR_NAME="$name"
export GIT_COMMITTER_DATE="$date"
export GIT_COMMITTER_EMAIL="$email"
export GIT_COMMITTER_NAME="$name"
git init
git add .
git commit -m 0
git remote add origin git@github.com:cirosantilli/test-git-partial-clone-big-small.git
