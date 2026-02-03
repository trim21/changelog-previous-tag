FROM python:3-slim@sha256:1a3c6dbfd2173971abba880c3cc2ec4643690901f6ad6742d0827bae6cefc925

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]