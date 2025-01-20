FROM python:3.9

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app 

COPY hw_ingest.py hw_ingest.py

ENTRYPOINT [ "python", "hw_ingest.py" ]