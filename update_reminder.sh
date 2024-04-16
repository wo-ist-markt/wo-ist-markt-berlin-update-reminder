#!/bin/bash

set -e #exit on error

#Collect errors and fail in the end
GOT_ERROR=false

#get HTTP code from site and exit 1 if and only if it is not 200
function error_on_non_200_http_status_code {
  SITE_NAME=$1
  HEADER=$2
  HTTP_STATUS_CODE=$(echo "$HEADER" | sed -n 's|.*HTTP/... \([0-9]*\).*|\1|p' )
  if [[ "$HTTP_STATUS_CODE" != "200" ]]; then
    echo "$SITE_NAME returned a non 200-code" > /dev/stderr
    echo "$HTTP_STATUS_CODE" > /dev/stderr
    echo "" > /dev/stderr
    GOT_ERROR=true
  fi
}

function check_geojson_api_exists {
  SITE="$1"
  BERLIN_GEOJSON_URL=$(echo "$SITE" | sed -n 's/.*\(https.*all.geojson\).*/\1/p' )
  if [[ "$BERLIN_GEOJSON_URL" == "" ]]; then
    echo "daten.berlin.de: GeoJSON-URL not available!" > /dev/stderr
    echo "" > /dev/stderr
    GOT_ERROR=true
  fi
  echo "$BERLIN_GEOJSON_URL"
}

function error_on_data_update {
  BERLIN_SITE=$1
  BERLIN_LAST_CHANGE=$(echo "$BERLIN_SITE" | sed -n '/.*Aktualisiert.*/,$p' | sed -e '/.*end.*/,$d' | sed -n 's/.*<span .*>\(.*\)<\/span.*/\1/p')

  MARKT_LAST_CHANGE=$(wget -q -O- https://wo-ist-markt.de/cities/berlin.json | sed -n 's/.*aktualisiert am \(.*\)",/\1/p')

  if [[ "$MARKT_LAST_CHANGE" != "$BERLIN_LAST_CHANGE" ]]; then
    echo "Dates don't match!"
    echo "daten.berlin.de: $BERLIN_LAST_CHANGE"
    echo "wo-ist-markt.de: $MARKT_LAST_CHANGE"
    echo "" > /dev/stderr
    GOT_ERROR=true
  fi
}

function get_site_and_header {
  URL="$1"
  wget --server-response -q -O- "$URL" 2>&1 #Headers are on stderr
}

function fail_on_error {
  if [ "$GOT_ERROR" = true ]; then #Yes, one equal sign is correct
    exit 1
  fi
}

function main {
  BERLIN_HEADER_AND_SITE=$( get_site_and_header https://daten.berlin.de/datensaetze/berliner-und-brandenburger-wochen-und-tr%C3%B6delm%C3%A4rkte )

  error_on_non_200_http_status_code "daten.berlin.de" "$BERLIN_HEADER_AND_SITE"

  BERLIN_GEOJSON_URL=$(check_geojson_api_exists "$BERLIN_HEADER_AND_SITE")
  if [[ "$BERLIN_GEOJSON_URL" != "" ]]; then
    BERLIN_GEOJSON_HEADER=$( get_site_and_header "$BERLIN_GEOJSON_URL" )
    error_on_non_200_http_status_code "daten.berlin.de: GeoJSON-API" "$BERLIN_GEOJSON_HEADER"
  fi

  error_on_data_update "$BERLIN_HEADER_AND_SITE"

  fail_on_error
}

main
