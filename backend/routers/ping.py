from fastapi import APIRouter, Request
from fastapi.responses import JSONResponse


router = APIRouter(
    prefix='/ping',
    tags=['ping'],
)  # Initialize the router

@router.get('', response_model=None)
async def ping_router(request: Request) -> JSONResponse:
    """
    Get QR Code URL
    :return: JSONResponse
        1. status code: 200, status: True, message: Fetch Successful, reason: '', Data=QR Code URL
        2. status code: 500, status: False, message: Fetch Failed, reason: 'Error message'
    """
    status_code, content = 200, "hello"  # Fetch QR Code URL from service
    return JSONResponse(status_code=status_code, content=content)  # Return the response
