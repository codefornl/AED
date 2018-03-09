#!/bin/bash
KEY=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhcHBfaWQiOiI0MXdXRDhHenVMMHJITHAyIiwiaXNWb2x1bnRlZXIiOmZhbHNlLCJleHAiOjE1MjA1ODUzMjl9.gjzLjKDRuanxtVZUJ0b1lomppJXYfI8SefWSeoOx6yE

rm -Rf geodata
rm -Rf sourcedata
mkdir geodata
mkdir sourcedata
for ((i=1;i<=240;i++)); do

curl -o sourcedata/aed$i.json 'https://api-rcr-aed.appdisco.afrogleap.com/v3/aeds?page='"$i"'' -H 'Host: api-rcr-aed.appdisco.afrogleap.com' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0' -H 'Accept: application/json' -H 'Accept-Language: nl,en-US;q=0.7,en;q=0.3' --compressed -H 'Referer: https://aed.rodekruis.nl/' -H 'content-type: application/json' -H 'authorization: Bearer '"$KEY"'' -H 'origin: https://aed.rodekruis.nl' -H 'Connection: keep-alive' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache'
done

node transform.js

#ogr2ogr -nlt POINT -skipfailures ./geodata/aed.shp ./geodata/aed.geojson OGRGeoJSON
ogr2ogr -f SQLite ./geodata/aed.sqlite ./geodata/aed.geojson -dsco SPATIALITE=YES