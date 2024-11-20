echo "~~~~~ UNIT TESTS ~~~~~"
pytest --tb=short -v python || exit 1
echo

exit 0
