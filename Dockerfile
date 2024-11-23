FROM ubuntu:22.04
ENV RUNNER_ALLOW_RUNASROOT=true
WORKDIR /actions-runner

COPY check.sh ./check.sh

RUN apt-get update && \
    apt-get install -y curl jq

RUN VERSION=$(bash ./check.sh) && \
    echo "Build with version $VERSION" && \
    curl -o "actions-runner-linux-x64-$VERSION.tar.gz" -L \
    "https://github.com/actions/runner/releases/download/v$VERSION/actions-runner-linux-x64-$VERSION.tar.gz" && \
    # tar xzf "./actions-runner-linux-x64-$VERSION.tar.gz"
    tar xzf "./actions-runner-linux-x64-$VERSION.tar.gz" && \
    bash ./bin/installdependencies.sh

ARG TOKEN GITHUB_USER_NAME GITHUB_REPOSITORY_NAME RUNNER_GROUP NAME

RUN ./config.sh \
        --url https://github.com/${GITHUB_USER_NAME}/${GITHUB_REPOSITORY_NAME} \
        --token ${TOKEN} \
        --runnergroup ${RUNNER_GROUP} \
        --name ${NAME} \
        --unattended
