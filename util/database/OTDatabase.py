import sqlite3
    
class OTDatabase:
    def __init__(self, path:str):
        pass
    def connect(self) -> bool:
        pass
    def execute(self, query:str) -> bool:
        pass
    def commit(self) -> bool:
        pass


class OTSqliteDB(OTDatabase):
    conn = None
    def __init__(self, path:str):
        super().__init__(path)
        self.path = path
        self.connect()

    def connect(self) -> bool:
        self.conn = sqlite3.connect(self.path)
        return True

    def execute(self, query:str) -> bool:
        c = self.conn.cursor()
        c.execute(query)
        return True
    
    def commit(self) -> bool:
        self.conn.commit()
        return True

class OTBigQueryDB(OTDatabase):
    def __init__(self, path:str):
        super.__init__()
    def connect(self) -> bool:
        return False
    def execute(self, query:str) -> bool:
        return False
    def commit(self) -> bool:
        return False