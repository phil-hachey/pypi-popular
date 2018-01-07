FROM python:2.7

RUN mkdir /var/app
WORKDIR /var/app

COPY requirements.txt /var/app/requirements.txt
RUN pip install -r /var/app/requirements.txt

COPY pypi_popular /var/app/pypi_popular

ENV PYTHONPATH .

CMD ["python", "/var/app/pypi_popular/api/app.py"]
