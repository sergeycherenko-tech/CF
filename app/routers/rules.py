from fastapi import APIRouter
from typing import Dict, List
router = APIRouter(prefix="/rules", tags=["rules"])
@router.get("")
def list_rules() -> List[Dict]: return []
@router.post("")
def create_rule(rule: Dict) -> Dict: return rule
@router.put("/{id}")
def update_rule(id: str, rule: Dict) -> Dict: return {"id": id, **rule}
@router.delete("/{id}", status_code=204)
def delete_rule(id: str): return
@router.post("/apply")
def apply_rules(import_batch_id: str) -> Dict: return {"updated": 0}
