FROM python:3-slim@sha256:8f3aba466a471c0ab903dbd7cb979abd4bda370b04789d25440cc90372b50e04

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]