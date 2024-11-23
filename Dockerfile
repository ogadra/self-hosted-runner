FROM ubuntu:22.04
ENV RUNNER_ALLOW_RUNASROOT=true
WORKDIR /actions-runner

COPY check_version.sh ./check_version.sh
COPY get_token.sh ./get_token.sh

RUN apt-get update && \
    apt-get install -y curl jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN VERSION=$(bash ./check_version.sh) && \
    echo "Build with version $VERSION" && \
    curl -o "actions-runner-linux-x64-$VERSION.tar.gz" -L \
    "https://github.com/actions/runner/releases/download/v$VERSION/actions-runner-linux-x64-$VERSION.tar.gz" && \
    tar xzf "./actions-runner-linux-x64-$VERSION.tar.gz" && \
    bash ./bin/installdependencies.sh && \
    rm "./actions-runner-linux-x64-$VERSION.tar.gz" ./bin/installdependencies.sh ./check_version.sh

ARG GITHUB_TOKEN GITHUB_USER_NAME GITHUB_REPOSITORY_NAME RUNNER_GROUP NAME
ENV URL https://api.github.com/repos/$GITHUB_USER_NAME/$GITHUB_REPOSITORY_NAME/actions/runners/registration-token

RUN TOKEN=$(bash ./get_token.sh $URL $GITHUB_TOKEN) && ./config.sh \
        --url https://github.com/${GITHUB_USER_NAME}/${GITHUB_REPOSITORY_NAME} \
        --token ${TOKEN} \
        --runnergroup ${RUNNER_GROUP} \
        --name ${NAME} \
        --unattended
RUN rm ./get_token.sh
