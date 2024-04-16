[![Build Status](https://travis-ci.org/wo-ist-markt/wo-ist-markt-berlin-update-reminder.svg?branch=master)](https://travis-ci.org/wo-ist-markt/wo-ist-markt-berlin-update-reminder)

# Wo ist Markt? Berlin update reminder

A maintenance script for the [Wo ist Markt? project][wo-ist-markt-github]
to automatically check if the market data for Berlin is still available and whether it has changed.


## Project description

First, the site checks whether the market data for Berlin is still available.
That is, whether daten.berlin.de as well as its GeoJSON endpoint are still available.

Second, the script compares two time stamps with each other. 
One is extracted from the [market data website][berlin-market-data-website] 
of the Berlin data portal. The `Aktualisiert:` date is picked here.
The other is parsed from the [Berlin market data JSON file][wo-ist-markt-berlin-json] 
which is rendered at the Wo ist Markt? website. The file contains a `title` property which 
contains the relevant date.

On [Travis CI][travis-ci-website] a CRON job is configured to regularly
execute the script. The build job fails if the time stamps differ.

Travis CI is further configured to send Slack messages to the
[#wo-ist-markt-ci channel][wo-ist-markt-ci-slack].


[berlin-market-data-website]: https://daten.berlin.de/datensaetze/berliner-und-brandenburger-wochen-und-tr%C3%B6delm%C3%A4rkte
[travis-ci-website]: https://travis-ci.org
[wo-ist-markt-ci-slack]: https://openknowledgegermany.slack.com/messages/wo-ist-markt-ci/
[wo-ist-markt-berlin-json]: https://wo-ist-markt.de/cities/berlin.json
[wo-ist-markt-github]: https://github.com/wo-ist-markt/wo-ist-markt.github.io
