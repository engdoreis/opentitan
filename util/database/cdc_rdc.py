import json
import re
import sys
import logging
from datetime import datetime
from tqdm import tqdm
from typing import List, Any, Dict, Generator
from OTDatabase import OTSqliteDB
from report_scraper import ReportScraper

class CdcRdcResults:
    def __init__(self, db:OTSqliteDB):
        self.logger = logging.getLogger("rdc_cdc")
        self.logger.setLevel(logging.DEBUG)
        fh = logging.FileHandler('/tmp/logs/rdc_cdc.log')
        fh.setLevel(logging.DEBUG)
        self.logger.addHandler(fh)

        

        self.db = db
        self.re = re.compile(r'([\d-]+).*?//sw/device[\w/-]+:(\w+)\s+.*?(PASSED|FAILED|TIMEOUT).*?in\s([\d.]+)s')
        self.cdc_table = "cdc_results"
        self.rdc_table = "rdc_results"
        self.db.execute(f"""CREATE TABLE IF NOT EXISTS {self.cdc_table}
                            ( day TEXT NOT NULL,
                              git_revision TEXT,
                              branch TEXT,
                              tool TEXT,
                              build_mode TEXT NOT NULL,
                              flow_warnings INTEGER NOT NULL,
                              flow_errors INTEGER NOT NULL,
                              sdc_reviews INTEGER NOT NULL,
                              sdc_warnings INTEGER NOT NULL,
                              sdc_errors INTEGER NOT NULL,
                              setup_reviews INTEGER NOT NULL,
                              setup_warnings INTEGER NOT NULL,
                              setup_errors INTEGER NOT NULL,
                              cdc_reviews INTEGER NOT NULL,
                              cdc_warnings INTEGER NOT NULL,
                              cdc_errors INTEGER NOT NULL,
                              UNIQUE(day) ON CONFLICT REPLACE )""")
        
        self.db.execute(f"""CREATE TABLE IF NOT EXISTS {self.rdc_table}
                            ( day TEXT NOT NULL,
                              git_revision TEXT,
                              branch TEXT,
                              tool TEXT,
                              build_mode TEXT NOT NULL,
                              flow_warnings INTEGER NOT NULL,
                              flow_errors INTEGER NOT NULL,
                              sdc_reviews INTEGER NOT NULL,
                              sdc_warnings INTEGER NOT NULL,
                              sdc_errors INTEGER NOT NULL,
                              setup_reviews INTEGER NOT NULL,
                              setup_warnings INTEGER NOT NULL,
                              setup_errors INTEGER NOT NULL,
                              rdc_reviews INTEGER NOT NULL,
                              rdc_warnings INTEGER NOT NULL,
                              rdc_errors INTEGER NOT NULL,
                              UNIQUE(day) ON CONFLICT REPLACE )""")
    def run(self, days:int):
        class Config:
            max_reports = 10                        # The amount of older reports should be processed.
            base_url = 'https://reports.opentitan.org/hw/top_earlgrey/rdc/'
        cfg = Config()
        cfg.max_reports = days
        self.report_scraper = ReportScraper(cfg)

        for data in tqdm(self.report_scraper.parse_report(), desc="RDC results "):
            insert_query = f"""INSERT INTO {self.rdc_table} VALUES ("{data['day']}", "{data['commit']}", "{data['branch']}", "{data['tool']}",
                              "{data['Build Mode']}"   ,"{data['Flow Warnings']}" ,  "{data['Flow Errors']}",
                              "{data['SDC Reviews']}"  ,"{data['SDC Warnings']}"  , "{data['SDC Erros']}",
                              "{data['Setup Reviews']}","{data['Setup Warnings']}", "{data['Setup Errors']}",
                              "{data['RDC Reviews']}"  ,"{data['RDC Warnings']}"  , "{data['RDC Erros']}")"""
            self.logger.debug(insert_query)
            self.db.execute(insert_query)

        self.db.commit()

        cfg.base_url = 'https://reports.opentitan.org/hw/top_earlgrey/cdc/'
        self.report_scraper = ReportScraper(cfg)

        for data in tqdm(self.report_scraper.parse_report(), desc="CDC results "):
            insert_query = f"""INSERT INTO {self.cdc_table} VALUES ("{data['day']}", "{data['commit']}", "{data['branch']}", "{data['tool']}",
                              "{data['Build Mode']}"   ,"{data['Flow Warnings']}" ,  "{data['Flow Errors']}",
                              "{data['SDC Reviews']}"  ,"{data['SDC Warnings']}"  , "{data['SDC Erros']}",
                              "{data['Setup Reviews']}","{data['Setup Warnings']}", "{data['Setup Errors']}",
                              "{data['CDC Reviews']}"  ,"{data['CDC Warnings']}"  , "{data['CDC Errors']}")"""
            self.logger.debug(insert_query)
            self.db.execute(insert_query)

        self.db.commit()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"""Usage: {sys.argv[0]} <path/to/database.db> <days>""")
        exit(0)

    database = OTSqliteDB(sys.argv[1])
    CdcRdcResults(database).run(int(sys.argv[2]))