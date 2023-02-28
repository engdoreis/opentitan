
import json
import requests
import logging
from typing import List, Any, Dict, Generator
from OTDatabase import OTSqliteDB

class DVRegressions:
    def __init__(self, db:OTSqliteDB):
        self.logger = logging.getLogger("DVRegressions")
        self.logger.setLevel(logging.DEBUG)
        fh = logging.FileHandler('/tmp/logs/dv_regressions_db.log')
        fh.setLevel(logging.DEBUG)
        self.logger.addHandler(fh)
    
        self.db = db
        self.tests_table_name = 'dv_tests'
        self.failures_table_name = 'dv_tests_failures'
        sql_create_table = """CREATE TABLE IF NOT EXISTS {}
                              ( day TEXT NOT NULL,
                                git_revision TEXT,
                                tool TEXT,
                                block TEXT,
                                testpoint TEXT,
                                stage TEXT,
                                test TEXT NOT NULL,
                                max_runtime_s INTEGER,
                                simulated_time_us INTEGER,
                                total_runs INTEGER,
                                passing_runs INTEGER,
                                pass_rate INTEGER,
                                UNIQUE(day, testpoint, test) ON CONFLICT REPLACE)"""


        sql_create_failures_table = """CREATE TABLE IF NOT EXISTS {} 
                                       ( day TEXT,
                                         block TEXT,
                                         test TEXT,
                                         identifier TEXT,
                                         seed integer,
                                         failure_message TEXT,
                                         UNIQUE(day, seed) ON CONFLICT REPLACE)"""

        self.db.execute(sql_create_table.format(self.tests_table_name ))
        self.db.execute(sql_create_failures_table.format(self.failures_table_name))

    def run(self, home_url:str):
        reports = [ 'latest' ]
        for report in reports:
            r = requests.get(home_url.format(report))
            if r.status_code != 200:
                continue
            self.logger.debug(home_url.format(report))
            json_data = json.loads(r.text)

            # Insert new data into Tests table.
            for insert_generator in self.process_testpoints(json_data['results']['testpoints']):
                insert_query:str = insert_generator(self.tests_table_name, json_data['report_timestamp'], json_data['git_revision'][:10], json_data['tool'], json_data['block_name'])
                self.logger.debug(insert_query)
                self.db.execute(insert_query)

            # Insert new data into Failures table.
            for insert_generator in self.process_failures_bukets(json_data['results']['failure_buckets']):
                insert_query:str = insert_generator(self.failures_table_name, json_data['report_timestamp'], json_data['block_name'])
                self.logger.debug(insert_query)
                self.db.execute(insert_query)

        self.db.commit()

    def process_testpoints(self, test_points:dict) -> Generator[str, None, None]:
        for tp in test_points:
            for t in tp['tests']:
                yield lambda table, date, git_revision, tool, block: \
                    f"""INSERT INTO {table} VALUES ('{date}', '{git_revision}', '{tool}',
                     '{block}', '{tp['name']}', '{tp['stage']}', '{t['name']}', '{t['max_runtime_s']}',
                     '{t['simulated_time_us']}', '{t['total_runs']}', '{t['passing_runs']}', '{t['pass_rate']}')"""


    def process_failures_bukets(self, bukets:dict) -> Generator[str, None, None]:
        for buket in bukets:
            for failing_test in buket['failing_tests']:
                for failing_run in failing_test['failing_runs']:
                    identifier:str = buket['identifier'].replace("'", '"')
                    failure_message:str =failing_run['failure_message']['text'].replace("'", '"')
                    yield lambda table, date, block: \
                        f"""INSERT INTO {table} VALUES ('{date}', '{block}', '{failing_test['name']}', '{identifier}', '{failing_run['seed']}', '{failure_message}')"""