from typing_extensions import TypedDict
from typing import Annotated
from langgraph.graph.message import add_messages

class StateManager(TypedDict):
    """
    To store the all the messages of the user given messages into the State
    """
    messages: Annotated[list, add_messages]
