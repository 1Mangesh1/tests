ARG PYTHON_VERSION=3.11-slim-bullseye
# Define an alias for the specific python version used in this file.
FROM python:${PYTHON_VERSION} AS python-base

# Python build stage ----------------------------------------------
FROM python-base AS python-build-stage

ARG BUILD_ENVIRONMENT=staging
ARG APP_HOME=/app

# Install apt packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    # dependencies for building Python packages
    build-essential \
    # Dependencies for psycopg2
    libpq-dev \
    # Curl for downloading uv
    curl ca-certificates

# Install uv
ADD https://astral.sh/uv/0.4.4/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.cargo/bin:$PATH"

# Set up virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN uv venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY ./requirements /requirements
RUN uv pip install --no-cache-dir -r /requirements/${BUILD_ENVIRONMENT}.txt \
    && rm -rf /root/.cache/uv


# Python 'run' stage ----------------------------------------------
FROM python-base AS python-run-stage

ARG BUILD_ENVIRONMENT=staging
ARG APP_HOME=/app

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV BUILD_ENV ${BUILD_ENVIRONMENT}

WORKDIR ${APP_HOME}

RUN addgroup --system django \
    && adduser --system --ingroup django django

RUN apt-get update && apt-get install --no-install-recommends -y \
    # Dependencies for psycopg2
    libpq-dev

# Copy virtual environment
ENV VIRTUAL_ENV=/opt/venv
COPY --chown=django:django --from=python-build-stage $VIRTUAL_ENV $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --chown=django:django ./compose/staging/django/entrypoint /entrypoint
COPY --chown=django:django ./compose/staging/django/start /start
COPY --chown=django:django ./compose/staging/django/celery/worker/start /start-celeryworker
COPY --chown=django:django ./compose/staging/django/celery/beat/start /start-celerybeat

# Set up permissions
RUN sed -i 's/\r$//g' /entrypoint \
    && chmod +x /entrypoint \
    && sed -i 's/\r$//g' /start \
    && chmod +x /start \
    && sed -i 's/\r$//g' /start-celeryworker \
    && chmod +x /start-celeryworker \
    && sed -i 's/\r$//g' /start-celerybeat \
    && chmod +x /start-celerybeat

RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*



# Copy application code to WORKDIR
COPY --chown=django:django . ${APP_HOME}

# Make django owner of the WORKDIR directory
RUN chown django:django ${APP_HOME}

USER django

ENTRYPOINT ["/entrypoint"]
