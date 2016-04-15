cd Django_Site/
echo 'yes' | python manage.py flush
python manage.py stylestodb
python manage.py barstodb
python manage.py tapstodb
