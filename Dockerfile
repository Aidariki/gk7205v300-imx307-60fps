FROM alpine:3.20

RUN apk add --no-cache     python3     py3-pip     py3-yaml     bash     curl     jq

WORKDIR /app
COPY . /app

RUN python3 -m venv /opt/venv &&     /opt/venv/bin/pip install --no-cache-dir yamllint

ENV PATH="/opt/venv/bin:$PATH"

CMD ["bash", "test/run_tests.sh"]
