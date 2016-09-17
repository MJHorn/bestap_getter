#python thebars.py 

awk '/"ACT"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | sed \$d | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' | sed '/^[[:space:]]*$/d' | sed 's/amp;//g' | awk '{print $0",ACT"}' > ACT
awk '/"NSW"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | sed \$d | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' | sed '/^[[:space:]]*$/d' | sed 's/amp;//g' | awk '{print $0",NSW"}' > NSW
awk '/"QLD"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | sed \$d | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' | sed '/^[[:space:]]*$/d' | sed 's/amp;//g' | awk '{print $0",QLD"}' > QLD
awk '/"SA"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | sed \$d | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' | sed '/^[[:space:]]*$/d' | sed 's/amp;//g' | awk '{print $0",SA"}' > SA
awk '/"TAS"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | sed \$d | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' | sed '/^[[:space:]]*$/d' | sed 's/amp;//g' | awk '{print $0",TAS"}' > TAS
awk '/"VIC"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | sed \$d | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' | sed 's/amp;//g' | sed '/^[[:space:]]*$/d' | sed 's/amp;//g' | awk '{print $0",VIC"}' > VIC
awk '/"WA"/ {p=1}; p; /\/optgroup/ {p=0}' barshtml | sed '/^\s*$/d' | sed 's/^*$//g' | tr -d "\t" | sed '1d' | sed \$d | sed 's/<option value="//g' | sed 's/">/,/g' | sed 's/<\/option>//g' | sed '/^[[:space:]]*$/d' | sed 's/amp;//g' | awk '{print $0",WA"}' > WA

cat ACT NSW QLD SA TAS VIC WA > State_Bars

sort State_Bars > CurrentBars

awk -F ',' -v OFS=',' '{print $1, $2, $4}' Bars_Names_Regions > OldBars

diff OldBars CurrentBars > bardiffs

grep '<' bardiffs | cut -c 3- > deadbars

grep '>' bardiffs | cut -c 3- > newbars

awk -F ',' -v OFS=',' '{print $0,$3}' newbars >> Bars_Names_Regions
awk -F ',' -v OFS=',' '{print $0,$3}' deadbars >> temp

mv temp deadbars

sort Bars_Names_Regions > temp

mv temp Bars_Names_Regions

awk -F ',' '{print $1 " 1"}' newbars >> Allll

sort Allll > temp 

mv temp Allll

grep -v -x -f deadbars Bars_Names_Regions > test

mv test Bars_Names_Regions

grep 'VIC' deadbars >> Zombie_Bars

cp Allll test

awk -F ',' '{print $1}' deadbars | while read line; do
 sed "/^$line\ /d" test > temp
 mv temp test
done

mv test Allll

#awk -F',' '{print $1" 1"}' State_Bars > Al_States

#cat Region_guide > Region_State
