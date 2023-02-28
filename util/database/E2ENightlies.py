

import json
import re
import logging
from tqdm import tqdm
from typing import List, Any, Dict, Generator
from OTDatabase import OTSqliteDB

class E2ENightlies:
    def __init__(self, db:OTSqliteDB):
        self.logger = logging.getLogger("E2E_Nightly")
        self.logger.setLevel(logging.DEBUG)
        fh = logging.FileHandler('/tmp/logs/e2e_nightly_db.log')
        fh.setLevel(logging.DEBUG)
        self.logger.addHandler(fh)
    
        self.db = db
        self.re = re.compile(r'([\d-]+).*?//sw/device[\w/-]+:(\w+)\s+.*?(PASSED|FAILED|TIMEOUT).*?in\s([\d.]+)s')
        self.table_name = "e2e_tests"
        self.db.execute(f"""CREATE TABLE IF NOT EXISTS {self.table_name}
                            ( day TEXT NOT NULL,
                              git_revision TEXT,
                              test TEXT NOT NULL,
                              runtime_s FLOAT,
                              state TEXT,
                              UNIQUE(day, test) ON CONFLICT REPLACE )""")
    def run(self, path:str):
        json_data = dict()
        with open(path, "r") as f:
            json_data = json.loads(f.read())

        for git_revision, job in tqdm(self.get_jobs(json_data), "e2e Tests "):
            for date, name, result, time in self.get_logs(job):
                insert_query = f"""INSERT INTO {self.table_name} VALUES ('{date}', '{git_revision}', '{name}',
                                         '{time}', '{result}')"""
                self.logger.debug(insert_query)
                self.db.execute(insert_query)
        self.db.commit()

    def get_logs(self, json_data:dict) -> Generator[str, None, None]:
        for log in json_data["logs"]:
            res = self.re.search(log)
            if res:
                yield (res[1],res[2],res[3],res[4])

    def get_jobs(self, json_data:dict) -> Generator[dict, None, None]:
        for item in json_data:
            jobs = list(filter(lambda x: x["name"] == "ROM E2E Tests",item["timelines"][-1]["jobs"]))
            yield item["commit"][:10], jobs[0]