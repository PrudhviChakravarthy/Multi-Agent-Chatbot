from pydantic import BaseModel, conint

class AskQuestionSchema(BaseModel):
    question : str 
    max_tokens : conint(ge=100)
    model_name : str 
