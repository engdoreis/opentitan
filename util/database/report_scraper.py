

import logging
import time
import pandas as pd
from datetime import datetime
import requests
import re
from typing import List, Any, Dict, Generator

class ReportScraper:
    def __init__(self, cfg):
        self.logger = logging.getLogger("rdc_cdc_scraper")
        self.logger.setLevel(logging.DEBUG)
        fh = logging.FileHandler('/tmp/logs/rdc_cdc_scraper.log')
        fh.setLevel(logging.DEBUG)
        self.logger.addHandler(fh)

        self.cfg = cfg
        self.pages = self.download_reports_pages(self.cfg.base_url)
        self.test_list = None

    def get_reports_links(self, html):
        return re.findall('\d{4}.\d{2}.\d{2}_\d{2}.\d{2}.\d{2}/report.html', html)

    def get_report_datetime(self, html):
        return datetime.strptime(re.findall('\w+ (\w+ \d+ \d+ \d+:\d+:\d+) UTC', html)[0], '%B %d %Y %H:%M:%S')

    def get_commit(self, html):
        res = re.search('GitHub Revision:.*<code>([a-fA-F0-9]+)<\/code>', html)
        return res.group(1) if res else 0

    def get_branch(self, html):
        res = re.search('Branch: ([\w_-]+)', html)
        return res.group(1) if res else 0

    def get_tool(self, html):
        res = re.search('Tool: ([\w_-]+)', html)
        return res.group(1) if res else 0

    def download_reports_pages(self, base_url):
        home_url = base_url + 'latest/report.html'
        pages = []
        while len(pages) < self.cfg.max_reports:
            r = requests.get(home_url)
            pages.append({'url' : home_url, 'html' : r.text})
            # Read the links for old reports.
            previous_reports = self.get_reports_links(r.text)
            self.logger.debug(previous_reports)
            # Donwload the page for each of the old reports.
            for rep in previous_reports:
                url = base_url + rep
                pages.append({'url' : url, 'html' : requests.get(url).text})
            # Set the last of the previous reports as the new home page.
            home_url = base_url + previous_reports[-1]
        return pages[0:self.cfg.max_reports] 

    def parse_report(self) -> Generator[dict, None, None]:
        for page in self.pages:
            html = page['html']
            self.logger.debug(self.pages)
            data = pd.read_html(html, decimal='.')[0].to_dict(orient = 'records')[0]
            data['day'] = self.get_report_datetime(html).strftime("%Y-%m-%dT%H:%M:%S")
            data['commit'] = self.get_commit(html)
            data['branch'] = self.get_branch(html)
            data['tool'] = self.get_tool(html)
            yield data

if __name__ == "__main__":
    class Config:
        max_reports = 5                        # The amount of older reports should be processed.
        base_url = 'https://reports.opentitan.org/hw/top_earlgrey/rdc/'

    r = ReportScraper(Config())
    for line in r.parse_report():
        print(line)
    
