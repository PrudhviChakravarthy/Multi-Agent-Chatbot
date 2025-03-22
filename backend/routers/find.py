from fastapi import APIRouter, Request
from fastapi.responses import JSONResponse


from services.find import (
    ollama_models
)

router = APIRouter(
    prefix='/find',
    tags=['find'],
)  # Initialize the router

@router.get('', response_model=None)
async def find_models(request: Request) -> JSONResponse:
    """
    Get QR Code URL
    :return: JSONResponse
        1. status code: 200, status: True, message: models that are in the ollama list
        2. status code: 500, status: False, message: Fetch Failed, reason: 'Error message'
    """
    status_code, content = await ollama_models()
    return JSONResponse(status_code=status_code, content=content)  # Return the response
