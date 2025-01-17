import re
import sys
from datetime import datetime, date

import requests

BERLIN_DE_API_URL = "https://datenregister.berlin.de/api/3/action/package_show?id=simple_search_wwwberlindesenwebservicemaerktefestewochentroedelmaerkte"
BERLIN_DE_WEBSITE_URL = "https://daten.berlin.de/datensaetze/simple_search_wwwberlindesenwebservicemaerktefestewochentroedelmaerkte"
WO_IST_MARKT_DE_WEBSITE_URL = "https://wo-ist-markt.de/cities/berlin.json"


def check_url_status(url: str) -> bool:
    response = requests.get(url)
    return response.status_code == 200


def get_geojson_url(data: dict) -> str:
    for resource in data['result']['resources']:
        if resource['format'] == "GeoJSON":
            return resource['url']
    return ""


def load_data(url: str) -> dict:
    response = requests.get(url)
    return response.json()


def get_berlin_de_updated_at(data: dict) -> date:
    updated_at = data['result']['date_updated']
    return parse_date(updated_at, '%Y-%m-%d')


def get_wo_ist_markt_de_updated_at(data: dict) -> date:
    title = data['metadata']['data_source']['title']
    return get_date(title)


def get_date(title: str) -> date:
    date_str = re.search(r'\d{2}\.\d{2}\.\d{4}', title).group()
    return parse_date(date_str, '%d.%m.%Y')


def parse_date(date_str: str, format_str: str) -> date:
    return datetime.strptime(date_str, format_str).date()


def print_url_http_status(url: str, alias: str):
    if check_url_status(url):
        print(f"👍 {alias} returns HTTP 200.")
    else:
        print(f"⚠️ {alias} does not return HTTP 200.")


# Data source
berlin_de_data = load_data(BERLIN_DE_API_URL)
berlin_de_geojson_url = get_geojson_url(berlin_de_data)
berlin_de_updated_at = get_berlin_de_updated_at(berlin_de_data)

# Target website
wo_ist_markt_de_data = load_data(WO_IST_MARKT_DE_WEBSITE_URL)
wo_ist_markt_de_updated_at = get_wo_ist_markt_de_updated_at(wo_ist_markt_de_data)

# HTTP status check
print_url_http_status(BERLIN_DE_API_URL, "datenregister.berlin.de")
print_url_http_status(BERLIN_DE_WEBSITE_URL, "daten.berlin.de")
print_url_http_status(WO_IST_MARKT_DE_WEBSITE_URL, "wo-ist-markt.de")
print_url_http_status(berlin_de_geojson_url, "GeoJSON URL")

print("")

if berlin_de_updated_at == wo_ist_markt_de_updated_at:
    print("✅ The dates do match.")
else:
    print(f"⚠️ Error: The dates do not match.", )
    print(f"{berlin_de_updated_at} (berlin.de)", )
    print(f"{wo_ist_markt_de_updated_at} (wo-ist-markt.de)", )
    sys.exit(1)
