#!/usr/bin/env bash
set -ex

if [[ "$1" == "enter" ]]; then
    enter="-it --entrypoint=bash"
fi

GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD | sed "s/\//-/g")
GIT_TAG=$(git describe --tags --exact-match 2> /dev/null || true)
GIT_TAG="${GIT_TAG:-$GIT_BRANCH}"

# generate and build dockerfile
docker build --tag image_pipenv --file test/Dockerfile test/
docker run --rm \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume "$(pwd):/$(pwd)" \
    --workdir "$(pwd)" \
    --env PIPENV_CACHE_DIR="$(pwd)/.pipenv" \
    --env GIT_TAG="${GIT_TAG}" \
    --env PY_COLORS=1 \
    ${enter} image_pipenv
