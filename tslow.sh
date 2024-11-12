
[ -x ./tfast.sh ] && ./tfast.sh || exit 1

UVDIR=venv
WD=$PWD
UVOPT=-q
[ -d $UVDIR ] || uv init $UVOPT $UVDIR
cd $UVDIR
[ -d .venv ] || (uv venv $UVOPT ; uv add $UVOPT complexipy texttest)
echo "~~~~~ COMPLEXIPY ~~~~~"
uv run $UVOPT complexipy $WD/python/g*.py # || exit 1
cd ..
echo

echo "~~~~~ TEXTTEST ~~~~~"
$UVDIR/.venv/bin/texttest -d . -con "$@" #|| exit 1
echo

echo "This is fine."
exit 0
