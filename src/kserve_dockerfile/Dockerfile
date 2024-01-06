FROM python:3.10.13-slim-bullseye

COPY requirements.txt .
RUN python3 -m pip install -r \
    requirements.txt --quiet --no-cache-dir \
    && rm -f requirements.txt

WORKDIR /app
COPY kservedeployer.py /app

ENTRYPOINT ["python"]
CMD ["kservedeployer.py"]
