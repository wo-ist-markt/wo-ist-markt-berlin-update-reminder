#!/bin/sh
MARKT_LAST_CHANGE=$(wget -q -O- https://wo-ist-markt.de/cities/berlin.json | sed -n 's/.*aktualisiert am \(.*\)",/\1/p')
BERLIN_LAST_CHANGE=$(wget -q -O- https://daten.berlin.de/datensaetze/wochen-und-tr%C3%B6delm%C3%A4rkte-0 | sed -n '/.*Aktualisiert.*/,$p' | sed -e '/.*end.*/,$d' | sed -n 's/.*<span .*>\(.*\)<\/span.*/\1/p')

exit 1;
echo "Test";
if [[ "$MARKT_LAST_CHANGE" != "$BERLIN_LAST_CHANGE" ]]; then
  echo "Dates don't match!"
  echo "daten.berlin.de: $MARKT_LAST_CHANGE"
  echo "wo-ist-markt.de: $BERLIN_LAST_CHANGE"
  exit 1;
fi
