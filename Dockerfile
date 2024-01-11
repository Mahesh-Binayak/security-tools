FROM python:3.9

ARG SOURCE
ARG COMMIT_HASH
ARG COMMIT_ID
ARG BUILD_TIME
LABEL source=${SOURCE}
LABEL commit_hash=${COMMIT_HASH}
LABEL commit_id=${COMMIT_ID}
LABEL build_time=${BUILD_TIME}

ARG container_user=mosip
ARG container_user_group=mosip
ARG container_user_uid=1001
ARG container_user_gid=1001

# Create user group
RUN groupadd -r ${container_user_group}

# Create user with specific ID
RUN useradd -u ${container_user_uid} -r -g ${container_user_group} -s /bin/bash -m -d /home/${container_user} ${container_user}

WORKDIR /home/${container_user}
USER ${container_user}

ENV MYDIR=`pwd`
ENV DATE="$(date --utc +%FT%T.%3NZ)"
ENV ENABLE_INSECURE=false
ENV MODULE=

ENV s3-host=
ENV s3-region=
ENV s3-user-key=
ENV s3-user-secret=
ENV s3-bucket-name=

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY mosipvaluefinder.py .
CMD ["python", "mosipvaluefinder.py"]