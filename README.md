[![Build Status](https://travis-ci.org/wo-ist-markt/wo-ist-markt-berlin-update-reminder.svg?branch=master)](https://travis-ci.org/wo-ist-markt/wo-ist-markt-berlin-update-reminder)

# Wo ist Markt? Berlin update reminder

A maintenance script for the [Wo ist Markt? project][wo-ist-markt-github]
to automatically check if the market data for Berlin is still available and whether it has changed.

## Description

The script checks the [API][berlin-market-data-api] behind the [data register][berlin-market-data-website].

1. Checks the HTTP 200 status of all URLs.
2. Compares the updated at dates of both the data register and the [GeoJSON file][wo-ist-markt-berlin-json] at
   wo-ist-markt.de.
3. On [Travis CI][travis-ci-website] a CRON job is configured to regularly execute the script. The build job fails if
   the dates differ or other errors occur.

Travis CI is further configured to send Slack messages to the [#wo-ist-markt-ci channel][wo-ist-markt-ci-slack].


[berlin-market-data-api]: https://datenregister.berlin.de/api/3/action/package_show?id=simple_search_wwwberlindesenwebservicemaerktefestewochentroedelmaerkte
[berlin-market-data-website]: https://daten.berlin.de/datensaetze/simple_search_wwwberlindesenwebservicemaerktefestewochentroedelmaerkte
[travis-ci-website]: https://travis-ci.org
[wo-ist-markt-ci-slack]: https://openknowledgegermany.slack.com/messages/wo-ist-markt-ci/
[wo-ist-markt-berlin-json]: https://wo-ist-markt.de/cities/berlin.json
[wo-ist-markt-github]: https://github.com/wo-ist-markt/wo-ist-markt.github.io
