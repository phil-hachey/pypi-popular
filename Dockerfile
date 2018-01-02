FROM python:2.7

RUN mkdir /var/app
WORKDIR /var/app

COPY setup.py /var/app/
COPY requirements.txt /var/app/requirements.txt

RUN python setup.py install

COPY pypi_popular /var/app/pypi_popular

ENV PYTHONPATH .

CMD ["python", "/var/app/pypi_popular/api/app.py"]
