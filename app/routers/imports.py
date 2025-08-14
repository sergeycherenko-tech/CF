from fastapi import APIRouter, UploadFile, File
router = APIRouter(prefix="/imports", tags=["imports"])
@router.post("")
async def create_import(file: UploadFile = File(...)):
    # TODO: parse and insert rows into DB
    return {"import_batch_id": "00000000-0000-0000-0000-000000000000"}
@router.get("/{id}")
def get_import(id: str):
    return {"id": id, "status": "processing"}
