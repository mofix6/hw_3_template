FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PORT=8000
ENV GREETING="Hello, Docker!"
ENV STORAGE=sqlite
ENV DATA_FILE=/data/counter.db

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/app.py .

RUN mkdir -p /data

EXPOSE 8000

CMD ["python", "app.py"]
