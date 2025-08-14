from fastapi import APIRouter, Response, Query
from typing import Optional
router = APIRouter(prefix="/reports", tags=["reports"])
@router.get("/cf")
def cf_report(mode: str = "fact", from_: Optional[str] = Query(None, alias="from"), to: Optional[str] = None):
    return {"mode": mode, "header": [], "detail": []}
@router.get("/cf/export.xlsx")
def cf_export(mode: str = "fact", from_: Optional[str] = Query(None, alias="from"), to: Optional[str] = None):
    return Response(content=b"", media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
