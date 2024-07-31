FROM python:3.6-alpine


LABEL maintainer="MODESTE DOLUMIN NGUEYEP" email="modestengueyep1@gmail.com"

WORKDIR /opt

COPY app.py /opt/app.py
COPY images /opt/images
COPY templates /opt/templates
COPY static /opt/static
COPY requirements.txt /opt/requirements.txt
RUN pip install -r requirements.txt

COPY . .

#ARG ODOO_URL
#ARG PGADMIN_URL

ENV ODOO_URL=https://www.odoo.com/
ENV PGADMIN_URL=https://www.pgadmin.org/

EXPOSE 8080

CMD ["python", "app.py"]



