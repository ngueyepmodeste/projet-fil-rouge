FROM python:3.6-alpine

WORKDIR /opt

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

ARG ODOO_URL
ARG PGADMIN_URL

ENV ODOO_URL=$ODOO_URL
ENV PGADMIN_URL=$PGADMIN_URL

EXPOSE 8080

CMD ["python", "app.py"]
