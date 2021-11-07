#!/bin/bash

# Usage: http POST :8080/echo msg==hello foo=bar

echo "restarting container mysql8"

docker container restart mysql8
