#!/usr/bin/env bash

docker run  -v /ar/log/jenkins -p 8080:8080 -p 50000:50000 --privileged --name jenkins -d yanxinjie/jenkins