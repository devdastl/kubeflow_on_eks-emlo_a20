FROM python:3.10.13-slim-bullseye

RUN export DEBIAN_FRONTEND=noninteractive \
  && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip

RUN pip install \
  torch==2.1.0+cpu \
  torchvision==0.16.0+cpu \
  --extra-index-url https://download.pytorch.org/whl/cpu \
  && rm -rf /root/.cache/pip

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt && rm -f requirements.txt

ENV PYTHONPATH /workspace

WORKDIR /workspace

COPY . .

RUN sed -i 's/pl.Trainer.from_argparse_args(parser)/pl.Trainer(**trainer_args)/' /usr/local/lib/python3.10/site-packages/pytorch_kfp_components/components/trainer/executor.py

RUN sed -i 's/trainer.test(model)/trainer.test(model, data_module)/' /usr/local/lib/python3.10/site-packages/pytorch_kfp_components/components/trainer/executor.py


ENTRYPOINT /bin/bash
