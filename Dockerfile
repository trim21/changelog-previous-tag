FROM python:3-slim@sha256:0c6bb259d537411417dd3b0052730e237ec0b8bd66aeaf64f1804a142d5c23ae

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]