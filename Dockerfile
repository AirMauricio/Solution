FROM python:3.8

WORKDIR /solution
COPY requirements.txt /solution/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /solution/requirements.txt

COPY . /solution

CMD bash -c "while true; do sleep 1; done"