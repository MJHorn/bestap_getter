export LANG=C

n=$1

nowdate=$(date +%s)
latestdate=$((nowdate - 3600*n))

awk '$2 <= n' n="$latestdate" Allll | awk '{print $1}' > thesebars

while read j
do
newline=$(awk -v bar="^$j$" -v date="$(date +%s)" '$1 ~ bar { print $1, date}' Allll)
sed -i.bak "s/$j .*/$newline/g" Allll

rm ratings.$j

echo $j > bar

echo $j

rm beerhtml

while [ ! -s 'beerhtml' ]
do

time python taplists.py

sed '/reportedList/q' html  | sed -n '/Official Tap List/,$p' | sed '/^$/d' | grep -o '=.*' | sed '/="left">/d' | cut -c 3- | sed '$ d' | sed 's/.*time-ago.*//' | sed 's/<\/a><br \/>/\'$'\n/' | sed 's/">/\'$'\n/' | sed '/sub-info/d' | sed 's/\/>//' | sed 's/<\/h4>//' | sed 's/<\/p>//' | sed '/^$/d' | sed 's/\&amp;/\&/g' | sed 's/^Stone Brewing Company$/Stone Brewing/g' | sed 's/^Ruination Double IPA 2.0$/Stone Ruination Double IPA 2.0/' > beerhtml

done

k=$(cat beerhtml | wc -l)
N=$(( k / 5 ))

for i in `seq 1 $N`;
do

one=$(( 5*i -2 ))
two=$((one + 1))

start=$(( 5*i -4 ))
finish=$(( 5*i ))

sed -n "${one},${two}p" beerhtml | sed -e's/[[:space:]]*$//' > examp
sed -n "${start},${finish}p" beerhtml | sed -e's/[[:space:]]*$//' > fullexamp

bname=$(sed -n '1{p;q;}' examp | sed -e's/[[:space:]]*$//' )
bbeer=$(sed -n '2{p;q;}' examp | sed -e's/[[:space:]]*$//' )

name=$(cat examp | sed 's/ /+/g' | tr '\n' '+' | sed 's/.$//' | sed 's/&/%26/' | sed 's/:/%3A/' | sed 's/\[/%5B/' | sed 's/\]/%5D/' )
namenoslash=$(echo $name | sed 's/\///')

findit=0

if [ -s cacheuntapped/$namenoslash ]
then
   findit=$((findit+1))
   cat bar examp | sed 's/,//' | sed 's/#//' | tr "\n" "," >> ratings."$j"
   tail -1 cacheuntapped/$namenoslash | sed 's/.$//; s/^.//' | tr "\n" "," >> ratings."$j"
   head -1 cacheuntapped/$namenoslash | tr "\n" "," >> ratings."$j"
   sed '4q;d' cacheuntapped/$namenoslash >> ratings."$j"

else 

url='untappd.com/search?q=$name&type=beer&sort='

echo $url
time wget $url -O wgetsearchr

sed '1,/results-container/d' wgetsearchr | sed '/results-add-beer/q' | tr -d "\t" | sed '/^$/d' | sed 's/.*beer-item.*//g' | sed '/<\/div>/d' | sed '/beer-details/d' | sed '/details beer/d' | sed '/img src/d' | sed '/^<\/p>$/d' | sed '/rating small r/d' | sed '/class="abv"/d' | sed '/class="ibu"/d' | sed '/class="rating"/d' | sed 's/<a class="label" href="//' | sed 's/<[^>]*>//g' | sed 's/">//' > test

rm beercellar/beer*
awk '!a[$0]++ {of="beercellar/beer" ++fc; print $0 >> of ; close(of)}' RS= ORS="\n" test

num=$(echo $(find beercellar/ -maxdepth 1 -type f | wc -l))

for l in `seq 1 $num`;
do

beerfile=beer$l

if [ "$(sed -n '3{p;q;}' beercellar/$beerfile)" == "$bname" ]; 
then
  if [ "$(sed -n '2{p;q;}' beercellar/$beerfile)" == "$bbeer" ];
  then
   cat beercellar/$beerfile > cacheuntapped/$namenoslash
   findit=$((findit+1))
   rightone=$l
  fi
fi

done

if [ "$findit" -ne "1" ]; 
then
  cat bar examp | sed 's/,//' | sed 's/#//' | tr "\n" "," >> ratings."$j"
  echo 'SEARCH ERROR' | tr "\n" "," >> ratings."$j"
  echo 'SEARCH ERROR' | tr "\n" "," >> ratings."$j"
  echo 'SEARCH ERROR' >> ratings."$j"
else
  cat bar examp | sed 's/,//' | sed 's/#//' | tr "\n" "," >> ratings."$j"
  tail -1 beercellar/beer$rightone | sed 's/.$//; s/^.//' | tr "\n" "," >> ratings."$j"
  head -1 beercellar/beer$rightone | tr "\n" "," >> ratings."$j"
  sed '4q;d' beercellar/beer$rightone >> ratings."$j"
fi

fi 

done 

sort Region_guide > sorted_regions
join -t',' sorted_regions ratings.$j > temp
cat header temp > ratings.$j

done < thesebars

bash comparebars.bash 15
