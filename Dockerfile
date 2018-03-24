FROM python:3.6-alpine
WORKDIR /usr/local/src/

COPY requirements.txt .
RUN pip install --no-cache -r requirements.txt

COPY . ./

RUN python manage.py collectstatic --no-input

CMD ["gunicorn", "myapp.wsgi"]

