FROM python:3-slim@sha256:f3614d98f38b0525d670f287b0474385952e28eb43016655dd003d0e28cf8652

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]