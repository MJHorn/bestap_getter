um=$1
setting=$2

ls ratings.* > barlist

python comparetaps.py

cut -c 9- meanresults | cut -c 9- meanresults | sort -k2 -n -r | column -t > Meansorted

sort -t$'\t' -k4 -nr bestlist  > Top_Beers

mv Top_10 Top_10_old

head -10 Top_Beers > Top_10

diff Top_10_old Top_10 | grep ">" > In
diff Top_10_old Top_10 | grep "<" > Out

awk -F '\t' '$5 != "nan" { print $0 }' bestlist | sort -t$'\t' -k5 -nr > Some_Taps

awk -F $'\t' '{ if ( $5 != "nan" ) { print $0; } }' Some_Taps | sed 's/beerdeluxehawthorn/Beer Deluxe Hawthorn/g' | sed 's/beerdeluxe/Beer Deluxe/g' | sed 's/beermash/Beermash/g' | sed 's/belgianbeercafemelbourne/Belgian Beer Cafe/g' | sed 's/boatrockerbarrelroom/Boatrocker Barrel Room/g' | sed 's/boilermakerhouse/Boilermaker House/g' | sed 's/brotherburgerandthemarvellousbrewsouthyarra/Brother Burger South Yarra/g' | sed 's/brotherburgerandthemarvellousbrew/Brother Burger/g' | sed 's/carwyncellars/Carwyn Cellars/g' | sed 's/eastofeverything/East of Everything/g' | sed "s/forestershall/Forester's Hall/g" | sed 's/foxinthecorn/Fox in the Corn/g' | sed 's/grapeandgrain/Grape and Grain/g' | sed 's/littlehop/Little Hop/g' | sed 's/moondogbrewery/Moon Dog Brewery/g' | sed 's/sunmothcanteenbar/Sun Moth Canteen/g' | sed 's/thealehouseproject/The Alehouse Project/g' | sed 's/thecatfish/The Catfish/g' | sed 's/thegertrudehotel/The Gertrude Hotel/g' | sed 's/thelocaltaphousestk/The Local Taphouse/g' | sed 's/theroyston/The Royston/g' | sed 's/trubru/TRUBRU/g' | sed 's/twobirdsbrewing/Two Birds Brewing/g' | sed 's/tworow/Two Row/g' | sed 's/upinsmoke/Up In Smoke/g' | sed 's/theterminushotel/The Terminus Hotel/g' | sed 's/youngbloodsdiner/Young Bloods Diner/g' | sed 's/villagemelbourne/Village Melbourne/g' | sed 's/tsububar/Tsubu Bar/g' | sed 's/thewoodlandshotel/The Woodlands Hotel/g' > temp

cat temp | sed 's/img\/default-label.png/https:\/\/untappd.akamaized.net\/site\/beer_logos\/beer-4499_dc04a_sm.jpeg/g' > Some_Taps

head -10 Some_Taps | column -t -s '	'
