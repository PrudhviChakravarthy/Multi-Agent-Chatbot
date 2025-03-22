from langgraph.graph import START, StateGraph , END
from langgraph.graph.message import add_messages
from langchain_ollama import ChatOllama
from langchain_core.messages import AIMessage
from ollama import list
from typing import Annotated
from typing_extensions import TypedDict

from schemas.agent import AskQuestionSchema
from models.agent import StateManager

main_graph = StateGraph(StateManager)


async def ask_agent_service(chat: AskQuestionSchema):
    try:
        if chat.model_name  not in [model.model for model in (list()).models]:
            return 500, "no model named found in ollama "
        messages = [
        (
            "system",
            "You are an assistant that helps the user to answer the questions",
        ),
        ("human", chat.question),
        ]
        llm = ChatOllama(model = chat.model_name)
        response = llm.invoke(messages).content
        return 200 , {"status":True, "content":response}
    except Exception as error:
        return 500, {"status":False, "reason":error}

async def get_flow_image():
    """
    Get the image of the flow with the langgraph
    """
    return True