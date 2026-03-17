FROM python:3-slim@sha256:35f442c69294267a391b05d9526b6a330986ad9b008152a2e24257a1f98a8dc0

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]