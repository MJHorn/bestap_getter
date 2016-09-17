um=$1
setting=$2

ls ratings.* > barlist

python comparetaps.py

#cut -c 9- meanresults | cut -c 9- meanresults | sort -k2 -n -r | column -t > Meansorted

mv Some_Taps Some_Taps_old

awk -F '\t' '$6 != "nan" { print $0 }' bestlist | sed 's/\tnan/\t0/g' | sort -t$'\t' -k6 -nr > temp

cat temp | sed 's/img\/default-label.png/https:\/\/untappd.akamaized.net\/site\/beer_logos\/beer-Trappist-Westvleteren-12.jpg/g' > Some_Taps

#awk -F '\t' '{print $1", " $4", "$5}' Some_Taps_old > oldtaps
#awk -F '\t' '{print $1", " $4", "$5}' Some_Taps > newtaps

#sort oldtaps > old2
#sort newtaps > new2

#diff old3 new3 | grep ">" | cut -c 3- > In2
#diff old3 new3 | grep "<" | cut -c 3- > Out2

python inoutup.py

head -10 Some_Taps | column -t -s '	'

cd /home/BesTap/my_taps_app/

bash updatesite.bash
