rm ratings.slowbeer

cat header > ratings.slowbeer

wget -q http://www.slowbeer.com.au/ -O slowhtml

grep 'taplist_widget-3' slowhtml | sed $'s/<li>/\\\n/g' | tail -4 | sed $'s/<\/strong>/ /g' | sed -n '/^$/!{s/<[^>]*>//g;p;}' | sed 's/%.*//g' | sed 's/&#038;/%26/g' > slowbeers

len=$(wc -l slowbeers | awk '{print $1}')

for n in $(seq 1 $len)
do

  sed -n "$n{p;q;}" slowbeers | awk -F'/t' '{print $1}' | tr -s ' \011' '\012' > beerwords

  nwords=$(wc -l beerwords | awk '{print $1}')

  foundit=0

  x=1

  while [ $foundit == 0 ]
  do

    name=$(tac beerwords | tail -n +$x | tac | tr '\n' '+' | sed 's/.$//')

    url="untappd.com/search?q=$name&type=beer&sort="

    echo $url
    wget $url -O wgetsearchr -q

    sed '1,/results-container/d' wgetsearchr | sed '/results-add-beer/q' | tr -d "\t" | sed '/^$/d' | sed 's/.*beer-item.*//g' | sed '/<\/div>/d' | sed '/beer-details/d' | sed '/details beer/d' | sed 's/<img src="//g' | sed '/^<\/p>$/d' | sed '/rating small r/d' | sed '/class="abv"/d' | sed '/class="ibu"/d' | sed '/class="rating"/d' | sed 's/<a class="label" href="//' | sed 's/<[^>]*>//g' | sed 's/">//' | sed 's/[[:space:]]*$//g' | sed 's/.*find any beers matching.*//g' | sed 's/.*Please double check.*//g' > test

    rm beercellar/beer*

    awk '!a[$0]++ {of="beercellar/beer" ++fc; print $0 >> of ; close(of)}' RS= ORS="\n" test

    num=$(echo $(find beercellar/ -maxdepth 1 -type f | wc -l))

    echo $num

    if [ $num == 1 ]
    then
      foundit=1
    elif [ $num -gt 1 ]
    then
      b=0
      k=1
      namehere=$(echo $name | sed 's/Brewing//g')
      while [ $b == 0 ]
      do
        thisbeer=$(echo $(sed '4q;d' beercellar/beer$k) $(sed '3q;d' beercellar/beer$k) | sed  's/Brewing //g' | sed 's/ /+/g' )
        echo $thisbeer
        if [ $thisbeer == $namehere ]
        then
          b=1
          echo 'match'
          mv beercellar/beer$k beercellar/beer1
          foundit=1
        elif [ $k == $num ]
        then
          b=3
          foundit=4
        else
          k=$((k + 1))
        fi
      done
    elif [ "$x" -gt "$nwords" ]
    then
      foundit=2
      echo 'moving on' 
    else
      x=$((x + 1))
      echo 'try again'
    fi

  done

  if [ $foundit == 1 ]
  then
    echo 'Slow Beer,East,VIC' | tr "\n" "," >> ratings.slowbeer
    sed '4q;d' beercellar/beer1 | tr "\n" "," >> ratings.slowbeer
    sed '3q;d' beercellar/beer1 | tr "\n" "," >> ratings.slowbeer
    tail -1 beercellar/beer1 | sed 's/.$//; s/^.//' | tr "\n" "," >> ratings.slowbeer
    head -1 beercellar/beer1 | tr "\n" "," >> ratings.slowbeer
    sed '5q;d' beercellar/beer1 | tr "\n" "," >> ratings.slowbeer
    sed '2q;d' beercellar/beer1 | tr "\n" "," >> ratings.slowbeer
    sed '6q;d' beercellar/beer1 | sed 's/\(% ABV\)*$//g' | tr "\n" "," >> ratings.slowbeer
    sed '7q;d' beercellar/beer1 | sed 's/ IBU//g' >> ratings.slowbeer
  fi

done
