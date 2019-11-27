import requests
import pandas as pd
from io import StringIO, BytesIO
from lxml import etree as et

API_KEY = '<GREATSCHOOLS.ORG API KEY GOES HERE>'

def generate_file(name, response):
    d = {}
    df = pd.DataFrame()
    tree = et.fromstring(response.content)
    for child in tree:
        for children in child:
            d[str(children.tag)] = str(children.text)
        df = df.append(d, ignore_index=True)
    df.to_csv(name + '.csv', sep=',')

if __name__ == "__main__":
    elem_url = 'http://api.greatschools.org/schools/DC/Washington/public/elementary-schools?limit=-1&key={}'.format(API_KEY)
    middle_url = 'http://api.greatschools.org/schools/DC/Washington/public/middle-schools?limit=-1&key={}'.format(API_KEY)
    high_url = 'http://api.greatschools.org/schools/DC/Washington/public/high-schools?limit=-1&key={}'.format(API_KEY)

    elem_schools = requests.get(elem_url)
    middle_schools = requests.get(middle_url)
    high_schools = requests.get(high_url)

    generate_file('elementary', elem_schools)
    generate_file('middle', middle_schools)
    generate_file('high', high_schools)
