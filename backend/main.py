from fastapi import FastAPI

from routers.ping import router

app = FastAPI()


app.include_router(router)