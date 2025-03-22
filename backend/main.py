from fastapi import FastAPI

from routers.ping import router as ping_router
from routers.find import router as find_router
from routers.agent import router as agent_router

app = FastAPI(
    title="Agentic bot",
    description="This is the bot that use langchain to to talk with ollama models"
)


app.include_router(ping_router)
app.include_router(find_router)
app.include_router(agent_router)