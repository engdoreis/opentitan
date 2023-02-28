

import json
import re
import sys
import logging
from datetime import datetime
from tqdm import tqdm
from typing import List, Any, Dict, Generator
from OTDatabase import OTSqliteDB

class MasterCI:
    def __init__(self, db:OTSqliteDB):
        self.logger = logging.getLogger("ci_master")
        self.logger.setLevel(logging.DEBUG)
        fh = logging.FileHandler('/tmp/logs/ci_master_db.log')
        fh.setLevel(logging.DEBUG)
        self.logger.addHandler(fh)

        self.db = db
        self.re = re.compile(r'([\d-]+).*?//sw/device[\w/-]+:(\w+)\s+.*?(PASSED|FAILED|TIMEOUT).*?in\s([\d.]+)s')
        self.tests_table = "ci_master_tests"
        self.jobs_table = "ci_master_jobs"
        self.db.execute(f"""CREATE TABLE IF NOT EXISTS {self.tests_table}
                            ( day TEXT NOT NULL,
                              git_revision TEXT,
                              name TEXT NOT NULL,
                              job TEXT NOT NULL,
                              runtime_s FLOAT,
                              status TEXT,
                              pipeline_id INTEGER,
                              pipeline_name TEXT,
                              branch TEXT,
                              UNIQUE(day, name) ON CONFLICT REPLACE )""")
        
        self.db.execute(f"""CREATE TABLE IF NOT EXISTS {self.jobs_table}
                            ( day TEXT NOT NULL,
                              start_time INTEGER NOT NULL,
                              end_time INTEGER NOT NULL,
                              git_revision TEXT,
                              name TEXT NOT NULL,
                              status TEXT,
                              pipeline_id INTEGER,
                              pipeline_name TEXT,
                              branch TEXT,
                              UNIQUE(start_time, name) ON CONFLICT REPLACE )""")
    def run(self, path:str):
        json_data = dict()
        with open(path, "r") as f:
            json_data = json.loads(f.read())

        for day_data in json_data:
            self.commit = day_data["commit"][:10]
            self.branch = day_data["branch"]
            self.id = day_data["id"]
            self.name = day_data["pipeline"]
            self.parse_day(day_data["timelines"][-1])
    
    def parse_day(self, day_data: dict):
        date = datetime.fromtimestamp(day_data["start"]/1000)

        for job in tqdm(day_data["jobs"], desc="CI Master jobs "):
            insert_query = f"""INSERT INTO {self.jobs_table} VALUES ("{date}", "{job["start"]}", "{job["finish"]}",
                                          "{self.commit}", "{job["name"]}", "{job["result"]}", "{self.id}", "{self.name}", "{self.branch}")"""
            self.logger.debug(insert_query)
            self.db.execute(insert_query)

        for job in tqdm(day_data["jobs"], desc="CI Master tests"):
            for (timestamp, name, result, runtime) in self.get_logs(job):
                insert_query = f"""INSERT INTO {self.tests_table} VALUES ('{date}', '{self.commit}', '{name}',
                                '{job["name"]}', '{runtime}', '{result}', "{self.id}", "{self.name}", "{self.branch}")"""
                self.logger.debug(insert_query)
                self.db.execute(insert_query)

        self.db.commit()

    def get_logs(self, json_data:dict) -> Generator[str, None, None]:
        for log in json_data["logs"]:
            log = (log[:200] + '..') if len(log) > 200 else log
            res = self.re.search(log)
            if res:
                yield (res[1],res[2],res[3],res[4])

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print(f"""Usage: {sys.argv[0]} <path/to/database.db> <path/to/log.json>""")
        exit(0)

    database = OTSqliteDB(sys.argv[1])
    MasterCI(database).run(sys.argv[2])