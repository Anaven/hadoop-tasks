#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import re

if __name__=="__main__":
    total_cost = 0.0
    total_num = 0
    rc = re.compile("request_time=(\d+\.\d+)")
    for line in sys.stdin:
        rst = rc.findall(line)
        if len(rst) != 1:
           continue
        total_cost += float(rst[0])
        total_num += 1
    print "%s\t%s" % (total_cost, total_num)
