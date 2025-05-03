FROM python:3-slim@sha256:60248ff36cf701fcb6729c085a879d81e4603f7f507345742dc82d4b38d16784

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]