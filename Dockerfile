FROM python:3-slim@sha256:44513520b81338d2d12499a59874220b05988819067a2cbac4545750a68e4b2b

COPY requiremenets.txt /app/requiremenets.txt

RUN pip install -r /app/requiremenets.txt

COPY main.py /app/main.py

ENTRYPOINT ["python", "/app/main.py"]