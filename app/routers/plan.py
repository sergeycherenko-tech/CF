from fastapi import APIRouter
from typing import Optional, List, Dict
router = APIRouter(prefix="/plan", tags=["plan"])
@router.get("")
def list_plan(from_: Optional[str] = None, to: Optional[str] = None) -> List[Dict]: return []
@router.post("")
def create_plan(item: Dict) -> Dict: return item
@router.patch("/{id}")
def update_plan(id: str, item: Dict) -> Dict: return {"id": id, **item}
@router.delete("/{id}", status_code=204)
def delete_plan(id: str): return
