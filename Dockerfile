FROM python:3-slim@sha256:5f55cdf0c5d9dc1a415637a5ccc4a9e18663ad203673173b8cda8f8dcacef689

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]