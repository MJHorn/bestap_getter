import requests

CLIENTID="0C39ABAAF0C8DF5A4CEF450933CD074B9079E519"
CLIENTSECRET="9F9D46BAE6D053BBA0D332E2B3415718EFBF403C"

url = 'https://api.untappd.com/v4/search/beer?q=Brewcult+Hop+Zone+Session+IPA&client_id='+CLIENTID+'&client_secret='+CLIENTSECRET

response = requests.get(url)

if response.status_code == 200:
    print response.json()
    print response.status_code
else:
    print response.status_code

