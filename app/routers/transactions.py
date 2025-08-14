from fastapi import APIRouter, Query
from typing import Optional, List, Dict
router = APIRouter(prefix="/transactions", tags=["transactions"])
@router.get("")
def list_transactions(from_: Optional[str] = Query(None, alias="from"), to: Optional[str] = None) -> List[Dict]:
    return []
@router.patch("/{id}")
def update_transaction(id: str, payload: Dict):
    return {"id": id, **payload}
