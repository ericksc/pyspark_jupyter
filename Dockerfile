FROM spark:latest
LABEL authors="erick"

USER root

# Set environment variables
ENV VIRTUAL_ENV=/opt/venv

# Install system dependencies and create a virtual environment
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3-venv \
    && python3 -m venv $VIRTUAL_ENV \
    && $VIRTUAL_ENV/bin/pip install --upgrade pip setuptools wheel \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Make sure scripts from the virtual environment are used by default
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

WORKDIR /opt

# Copy application code to the container
COPY requirements.txt /opt/

# Install Python dependencies
RUN pip install -r requirements.txt


EXPOSE 8888

COPY entry-point.sh /opt/
RUN chmod a+x ./entry-point.sh
#jupyter lab --ip 0.0.0.0 --port 8888
ENTRYPOINT ["./entry-point.sh"]
