FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ /app/src/


ENV PYTHONPATH=/app/src

# Enhanced logging configuration for Gunicorn
CMD ["gunicorn", "--log-level=debug", "--access-logfile=-", "--error-logfile=-", "--access-logformat='%(h)s %(l)s %(u)s %(t)s \"%(r)s\" %(s)s %(b)s \"%(f)s\" \"%(a)s\" %(L)s'", "-w", "1", "-b", "0.0.0.0:5000", "src.app:app"]