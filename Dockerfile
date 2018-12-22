FROM python:2.7-alpine

WORKDIR /app

ADD requirements.txt /app/
RUN pip install -r /app/requirements.txt

ADD . /app

EXPOSE 80
CMD ["python", "app.py"]
