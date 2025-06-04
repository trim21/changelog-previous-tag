FROM python:3-slim@sha256:56a11364ffe0fee3bd60af6d6d5209eba8a99c2c16dc4c7c5861dc06261503cc

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]