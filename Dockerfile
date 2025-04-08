FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY src/ /app/src/

ENV PYTHONPATH=/app/src

# Use Gunicorn to serve the Flask app
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "src.app:app"]