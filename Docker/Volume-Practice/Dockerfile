FROM python:3.11-alpine

WORKDIR /app

COPY app.py .

# Create data directory for volume
RUN mkdir -p /app/data

CMD ["python", "app.py"]
