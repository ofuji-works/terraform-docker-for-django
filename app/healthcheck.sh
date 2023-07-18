#!/bin/sh

set -x

max_attempts=10
attempt_num=0

while [ $attempt_num -lt $max_attempts ]; do
    python manage.py migrate
    result=$?
    if [ $result -eq 0 ]; then
        python manage.py runserver 0.0.0.0:8000
        break
    fi
    sleep $attempt_num
    attempt_num=$((attempt_num + 1))
done
