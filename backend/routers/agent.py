from fastapi import APIRouter, Request
from fastapi.responses import JSONResponse

## Custom imports
from schemas.agent import (
    AskQuestionSchema)
from services.agent import (
    ask_agent_service
)

router = APIRouter(
    prefix='/agent',
    tags=['agent'],
)  # Initialize the router


@router.post('', response_model=None)
async def ask_agent(request: Request, chat : AskQuestionSchema) -> JSONResponse:
    """
    Get QR Code URL
    :return: JSONResponse
        1. status code: 200, status: True, message: models that are in the ollama list
        2. status code: 500, status: False, message: Fetch Failed, reason: 'Error message'
    """
    status_code, content = await ask_agent_service(chat)
    return JSONResponse(status_code=status_code, content=content)  # Return the response
