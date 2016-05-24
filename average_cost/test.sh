#!/bin/bash

cat sample_in | ./mapper.py | sort -k 1 | ./reducer.py
