[![GitHub release](https://img.shields.io/github/release/UnitVectorY-Labs/adk-docker-base.svg)](https://github.com/UnitVectorY-Labs/adk-docker-base/releases/latest) [![License](https://img.shields.io/badge/license-MIT-blue)](https://opensource.org/licenses/MIT) [![Active](https://img.shields.io/badge/Status-Active-green)](https://guide.unitvectorylabs.com/bestpractices/status/#active)

# adk-docker-base

Docker image based on python docker image with [Google Agent Development Kit](https://github.com/google/adk-python) (ADK) pre-installed for streamlined AI agent development.

## What does this image do?

This image is a **base image** for building your own AI agents using the ADK, all it is doing is providing a base image with the ADK pre-installed. It is not meant to be run directly, but rather to be extended in your own agent project for rapid development.

-  **Base**: `python:3.12`
-  **Workdir**: `/app`  
-  **Deps**: copies in `requirements.txt` (pins version of `google-adk` matching the version of this image)  

---

## Using This Image

You won’t run `adk-docker-base` by itself. Instead, **extend** it in your own agent project with your ADK Python code. If you need to install any extra dependencies, you can do so in your own Dockerfile which means using this immage is probably not a good idea. The intent of this image here is to allow for rapid iteration of ADK based agents off of a common Docker base image.

### Project Layout

Follow the ADK quickstart structure:

```
├── Dockerfile
└── my_agent/
    ├── __init__.py
    ├── agent.py
    └── .env
```

### Example `my_agent/__init__.py`

```python
from . import agent
```

### Example `my_agent/agent.py`

```python
from google.adk.agents import Agent

def echo_tool(text_to_echo: str) -> dict:
    """Echoes the provided text back.

    Args:
        text_to_echo (str): The text to echo.

    Returns:
        dict: status and the echoed content.
    """
    return {"status": "success", "report": f"Echo: {text_to_echo}"}

root_agent = Agent(
    name="echo_agent",
    model="gemini-2.0-flash",  # Assuming a model, adjust if needed
    description="An agent that echoes back the user's input.",
    instruction="Echo back whatever the user says.",
    tools=[
        echo_tool
    ],
)
```

### Example `Dockerfile`

If you are actually going to use this image somewhere, don't actually stick with `latest`, specify an actual version so it is consistent.

```
FROM ghcr.io/unitvectory-labs/adk-docker-base:latest

WORKDIR /app

COPY my_agent/ ./my_agent/

EXPOSE 8000

# Run the Web UI for ADK
CMD ["adk", "web", "--host", "0.0.0.0", "--port", "8000"]
```

### Build & Run

```
podman build -t adk-example-agent .
podman run --rm -p 8000:8000 --name adk-example-agent adk-example-agent
```
