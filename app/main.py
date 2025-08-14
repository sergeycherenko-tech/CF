from fastapi import FastAPI
from .routers import healthz, imports, transactions, rules, plan, reports
from .services.db import init_db

app = FastAPI(title="CF MVP", version="1.0.0")

@app.on_event("startup")
def on_startup():
    init_db()

app.include_router(healthz.router)
app.include_router(imports.router)
app.include_router(transactions.router)
app.include_router(rules.router)
app.include_router(plan.router)
app.include_router(reports.router)
