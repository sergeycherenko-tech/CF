import os
from sqlalchemy import create_engine, text

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://cf:cfpass@localhost:5432/cfdb")
engine = create_engine(DATABASE_URL, pool_pre_ping=True)

def init_db():
    schema_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "schema_postgres.sql")
    if os.path.exists(schema_path):
        with open(schema_path, "r", encoding="utf-8") as f:
            ddl = f.read()
        with engine.begin() as conn:
            for stmt in ddl.split(";"):
                s = stmt.strip()
                if s:
                    conn.execute(text(s))
