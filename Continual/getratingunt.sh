source /home/BesTap/my_taps_app/myvenv/bin/activate

cd /home/BesTap/rating_builder/bestap_getter
export LANG=C

n=$1

mkdir archive/$(date "+%Y-%m-%d")

nowdate=$(date +%s)
latestdate=$((nowdate - 3600*n))

awk '$2 <= n' n="$latestdate" Allll | awk '{print $1}' > thesebars
#awk '$2 <= n' n="$latestdate" Al_slow | awk '{print $1}' > slowbars

time python taplists_loop.py

#if [ $(grep 'slowbeer' slowbars | wc -l) == 1 ]
#then
#    bash slowget.bash
#    cp ratings.slowbeer archive/$(date "+%Y-%m-%d")
#    newslow=$(awk -v bar="^slowbeer$" -v date="$(date +%s)" '$1 ~ bar { print $1, date}' Al_slow)
#    sed -i.bak "s/$j .*/$newslow/g" Al_slow
#fi

while read j
do
newline=$(awk -v bar="^$j$" -v date="$(date +%s)" '$1 ~ bar { print $1, date}' Allll)
sed -i.bak "s/$j .*/$newline/g" Allll
rm ratings.$j

echo $j > bar

echo $j

rm beerhtml

echo $j | tr "\n" ";" >> addresses
awk '/main/ {p=1;next}p' html_$j | sed '4q;d' >> addresses

a=0
grep 'time-ago' html_$j | grep 'Tapped' | head -1 | grep -q "day" && a=$((a+1)) || a=$a
grep 'time-ago' html_$j | grep 'Tapped' | head -1 | grep -q "hour" && a=$((a+1)) || a=$a
grep 'time-ago' html_$j | grep 'Tapped' | head -1 | grep -q "minute" && a=$((a+1)) || a=$a

echo $a $j

if [ $a -gt 0 ]
then

    sed '/reportedList/q' html_$j  | sed -n '/Official Tap List/,$p' | sed '/^$/d' | grep -o '=.*' | sed '/="left">/d' | cut -c 3- | sed '$ d' | sed 's/.*time-ago.*//' | sed 's/<\/a><br \/>/\'$'\n/' | sed 's/">/\'$'\n/' | sed '/sub-info/d' | sed 's/\/>//' | sed 's/<\/h4>//' | sed 's/<\/p>//' | sed '/^$/d' | sed 's/\&amp;/\&/g' | sed 's/^Stone Brewing Company$/Stone Brewing/g' | sed 's/Little Creatures Brewing (Lion Nathan)/Little Creatures Brewing/g' | sed 's/Malt Shovel Brewery (Lion Nathan)/Malt Shovel Brewery (James Squire)/g' | sed 's/Castlemaine Perkins (Lion Nathan)/Castlemaine Perkins/g' | sed 's/[[:space:]]*$//g' | sed 's/  / /g' > beerhtml

        M=$(cat Replace_list | wc -l)

        for y in `seq 1 $M`
        do
          sed -n "$y{p;q;}" Replace_list > replacements

          perl -0pe "s/$(awk -F '\t' '{print $1}' replacements)\n$(awk -F '\t' '{print $2}' replacements)/$(awk -F '\t' '{print $3}' replacements)\n$(awk -F '\t' '{print $4}' replacements)/igs" beerhtml > temp

          mv temp beerhtml

        done


rm html_$j

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

name=$(cat examp | sed 's/ /+/g' | tr '\n' '+' | sed 's/.$//' | sed 's/?//g' | sed 's/&/%26/' | sed 's/:/%3A/' | sed 's/#/%23/' |  sed 's/\[/%5B/' | sed 's/\]/%5D/' )
namenoslash=$(echo $name | sed 's/\///')

findit=0

if [ -s cacheuntapped/$namenoslash ]
then
   findit=$((findit+1))
   cat bar examp | sed 's/,//' | sed 's/#//' | tr "\n" "," >> ratings."$j"
   tail -1 cacheuntapped/$namenoslash | sed 's/.$//; s/^.//' | tr "\n" "," >> ratings."$j"
   head -1 cacheuntapped/$namenoslash | tr "\n" "," >> ratings."$j"
   sed '4q;d' cacheuntapped/$namenoslash | tr "\n" "," >> ratings."$j"
   head -1 fullexamp | sed 's/.$//' | tr "\n" "," >> ratings."$j" 
   sed '5q;d' cacheuntapped/$namenoslash | sed 's/\(% ABV\)*$//g' | tr "\n" "," >> ratings."$j"
   sed '6q;d' cacheuntapped/$namenoslash | sed 's/ IBU//g'  >> ratings."$j"

elif [ -s cacheweird/$namenoslash ]
then
  findit=$((findit+1))
  cat bar examp | sed 's/,//' | sed 's/#//' | tr "\n" "," >> ratings."$j"
  tail -1 cacheweird/$namenoslash | sed 's/.$//; s/^.//' | tr "\n" "," >> ratings."$j"
  head -1 cacheweird/$namenoslash | tr "\n" "," >> ratings."$j"
  sed '4q;d' cacheweird/$namenoslash | tr "\n" "," >> ratings."$j"
  head -1 fullexamp | sed 's/.$//' | tr "\n" "," >> ratings."$j"
  sed '5q;d' cacheweird/$namenoslash | sed 's/\(% ABV\)*$//g' | tr "\n" "," >> ratings."$j"
  sed '6q;d' cacheweird/$namenoslash | sed 's/ IBU//g'  >> ratings."$j"
else 

url="untappd.com/search?q=$name&type=beer&sort="

echo $url
time wget $url -O wgetsearchr -q

sed '1,/results-container/d' wgetsearchr | sed '/results-add-beer/q' | tr -d "\t" | sed '/^$/d' | sed 's/.*beer-item.*//g' | sed '/<\/div>/d' | sed '/beer-details/d' | sed '/details beer/d' | sed '/img src/d' | sed '/^<\/p>$/d' | sed '/rating small r/d' | sed '/class="abv"/d' | sed '/class="ibu"/d' | sed '/class="rating"/d' | sed 's/<a class="label" href="//' | sed 's/<[^>]*>//g' | sed 's/">//' | sed 's/[[:space:]]*$//g' | sed 's/  / /g' > test

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
   if [ "$(sed -n '7{p;q;}' beercellar/$beerfile)" != "(0)" ];
   then
     cat beercellar/$beerfile > cacheuntapped/$namenoslash
   fi
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
  echo 'SEARCH ERROR' | tr "\n" "," >> ratings."$j"
  echo 'SEARCH ERROR' | tr "\n" "," >> ratings."$j"
  echo 'SEARCH ERROR' | tr "\n" "," >> ratings."$j"
  echo 'SEARCH ERROR' >> ratings."$j"
else
  cat bar examp | sed 's/,//' | sed 's/#//' | tr "\n" "," >> ratings."$j"
  tail -1 beercellar/beer$rightone | sed 's/.$//; s/^.//' | tr "\n" "," >> ratings."$j"
  head -1 beercellar/beer$rightone | tr "\n" "," >> ratings."$j"
  sed '4q;d' beercellar/beer$rightone | tr "\n" "," >> ratings."$j"
  head -1 fullexamp | sed 's/.$//' | tr "\n" "," >> ratings."$j"
  sed '5q;d' beercellar/beer$rightone | sed 's/\(% ABV\)*$//g' | tr "\n" "," >> ratings."$j"
  sed '6q;d' beercellar/beer$rightone | sed 's/ IBU//g'  >> ratings."$j"
fi

fi 

done 

join -i -t',' -o 1.2,1.3,1.4,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9 Bars_Names_Regions ratings.$j > temp2

cat header temp2 > ratings.$j

cp ratings.$j archive/$(date "+%Y-%m-%d") 

else

echo 'too old at:' $j
rm html_$j
rm ratings.$j

fi

done < thesebars

bash comparebars.bash
