FROM python:3.6-alpine

ENV FLASK_APP=flasky.py
ENV FLASK_CONFIG=production

RUN adduser -D flasky
USER flasky

WORKDIR /home/flasky

COPY requirements requirements
RUN python -m venv venv
RUN venv/bin/pip install -r requirements/docker.txt

COPY app app
COPY migrations migrations
COPY flasky.py config.py boot.sh ./

COPY app app
COPY migrations migrations
COPY flasky.py config.py boot.sh ./

# ---- ADD THESE TWO LINES ----
# 1. Convert Windows line endings (CRLF) to Unix (LF)
RUN sed -i 's/\r$//' ./boot.sh
# 2. Grant execute permissions to the script
RUN chmod +x ./boot.sh

# run-time configuration
EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
