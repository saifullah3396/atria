# Use an official Python runtime as a parent image
FROM python:3.12-slim-bookworm

# The installer requires curl (and certificates) to download the release archive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates git libpq-dev gcc ffmpeg libsm6 libxext6  -y

# Download the latest installer
ADD https://astral.sh/uv/install.sh /uv-installer.sh

# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin/:$PATH"

# Change the working directory to the `app` directory
WORKDIR /app

# Install uv
# Ref: https://docs.astral.sh/uv/guides/integration/docker/#installing-uv
COPY --from=ghcr.io/astral-sh/uv:0.6.12 /uv /uvx /bin/

# Place executables in the environment at the front of the path
# Ref: https://docs.astral.sh/uv/guides/integration/docker/#using-the-environment
ENV PATH="/app/.venv/bin:$PATH"

# # Compile bytecode to speed up the startup time
# # Ref: https://docs.astral.sh/uv/guides/integration/docker/#compiling-bytecode
# ENV UV_COMPILE_BYTECODE=1

# # uv Cache
# # Ref: https://docs.astral.sh/uv/guides/integration/docker/#caching
# ENV UV_LINK_MODE=copy

# Copy the project dependencies into the image
COPY ./atria_cli/src/ /app/atria_cli/src/
COPY ./atria_core/src/ /app/atria_core/src/
COPY ./atria_datasets/src/ /app/atria_datasets/src/
COPY ./atria_hub/src/ /app/atria_hub/src/
COPY ./atria_insights/src/ /app/atria_insights/src/
COPY ./atria_metrics/src/ /app/atria_metrics/src/
COPY ./atria_ml/src/ /app/atria_ml/src/
COPY ./atria_models/src/ /app/atria_models/src/
COPY ./atria_registry/src/ /app/atria_registry/src/

# must be copied before 
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=./atriax_agents/uv.lock,target=uv.lock \
    --mount=type=bind,source=./atriax_agents/pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --group evaluation

COPY ./atriax_agents /app/atriax_agents
COPY ./services/evaluator_agent /app/services/evaluator_agent

WORKDIR /app/atriax_agents

# Sync the project
# Ref: https://docs.astral.sh/uv/guides/integration/docker/#intermediate-layers
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --group evaluation

# Set the default command
# Ref: https://fastapi.tiangolo.com/deployment/docker/
ENV PYTHONPATH=/app/atria_cli/src:\
/app/atria_core/src:\
/app/atria_datasets/src:\
/app/atria_hub/src:\
/app/atria_insights/src:\
/app/atria_metrics/src:\
/app/atria_ml/src:\
/app/atria_models/src:\
/app/atria_registry/src:\
/app/atriax_agents/src

CMD ["python", "/app/services/evaluator_agent/main.py"]