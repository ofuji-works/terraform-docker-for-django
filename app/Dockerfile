FROM python:3

ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
ADD healthcheck.sh /code/
RUN pip install -r requirements.txt
ADD . /code
ENTRYPOINT ["tail", "-f", "/dev/null"]
