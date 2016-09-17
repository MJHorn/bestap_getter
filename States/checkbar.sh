source /home/BesTap/my_taps_app/myvenv/bin/activate

cd /home/BesTap/rating_builder/bestap_getter
export LANG=C

python thebars.py 

awk '/"ACT"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | head -n -1 | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' > ACT
awk '/"NSW"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | head -n -1 | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' > NSW
awk '/"QLD"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | head -n -1 | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' > QLD
awk '/"SA"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | head -n -1 | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' > SA
awk '/"TAS"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | head -n -1 | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' > TAS
awk '/"VIC"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | head -n -1 | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' | sed 's/amp;//g' > VIC
awk '/"WA"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | head -n -1 | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' > WA


