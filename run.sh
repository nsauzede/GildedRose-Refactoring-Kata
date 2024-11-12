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

#uv run $UVOPT texttest -d . -con "$@"
echo "~~~~~ TEXTTEST ~~~~~"
$UVDIR/.venv/bin/texttest -d . -con "$@" #|| exit 1
echo

echo "~~~~~ UNIT TESTS ~~~~~"
#python3 $WD/python/test_gilded_rose.py
pytest $WD/python || exit 1
echo

echo "This is fine."
exit 0
