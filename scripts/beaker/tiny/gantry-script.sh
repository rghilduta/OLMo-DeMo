#!/usr/bin/env bash

set -ex

NUM_NODES=4
TASK_NAME=tiny-olmo-20M-rms-norm-adam-eps-1e-8

gantry run \
  --workspace ai2/OLMo-training \
  --task-name ${TASK_NAME} \
  --description "Tiny OLMo runs" \
  --priority urgent \
  --preemptible \
  --beaker-image shanea/olmo-torch2.2-gantry \
  --cluster ai2/pluto-cirrascale \
  --gpus 8 \
  --replicas "${NUM_NODES}" \
  --leader-selection \
  --host-networking \
  --budget ai2/oe-training \
  --no-nfs \
  --propagate-failure \
  --synchronized-start-timeout 30m \
  --env LOG_FILTER_TYPE=local_rank0_only \
  --env OMP_NUM_THREADS=8 \
  --env OLMO_TASK=model \
  --env-secret WANDB_API_KEY=ANANYA_WANDB_API_KEY \
  --env-secret AWS_ACCESS_KEY_ID=ANANYA_AWS_ACCESS_KEY_ID \
  --env-secret AWS_SECRET_ACCESS_KEY=ANANYA_AWS_SECRET_ACCESS_KEY \
  --shared-memory 10GiB \
  --venv base \
  --yes \
  --timeout=-1 \
  -- /bin/bash -c "scripts/beaker/tiny/torchrun-script.sh \$BEAKER_LEADER_REPLICA_HOSTNAME ${NUM_NODES} ${TASK_NAME}"