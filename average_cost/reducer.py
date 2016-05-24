#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys

total_cost = 0.0
total_num = 0

for line in sys.stdin:
    lines = line.strip().split('\t')
    if len(lines) != 2:
        continue
    total_cost += float(lines[0])
    total_num += int(lines[1])

if total_num != 0:
    print "average_cost=%s" % (total_cost/total_num)
