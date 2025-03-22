from ollama import ListResponse , list


async def ollama_models():
    """
    This funtion returns the models that are avaialble in the ollama
    
    """
    response : ListResponse = list()
    content = {}
    for model in response.models:
        content[model.model] = {
            "model_name": model.model,
            "size": f'{(model.size.real / 1024 / 1024):.2f}MB',
            "format" : model.details.format,
            "family" : model.details.family,
            "parameter_size" : model.details.parameter_size
        }
    return 200, {
        "status":True,
        "content":content
    }

