#!/usr/bin/env python

import re
import sys

fixfile_reg = re.compile(r'.*fix$')

with open(sys.argv[1],"r") as f_in:
    ind = sys.argv[2]
    nf = sys.argv[3]
    f = open("submit-solve-" + ind + ".cmd","w")
    f.write("universe = vanilla\n")
    f.write("executable = marsd\n")
    f.write("should_transfer_files = YES\n")
    f.write("when_to_transfer_output = ON_EXIT\n")
    f.write("request_memory = 1GB\n")
    f.write("log = condor.log\n")
    f.write("notification = never\n")

    for i in f_in:
        i=i.strip()
        name = i.replace(".fix","")
        f.write("output = " + name + ".out\n")
        f.write("error = " + name + ".err\n")
        f.write("transfer_input_files = generators_MARSD" + nf + "," + i + ",params-marsd-" + nf + ".txt,basicProblem_" + nf + ".mps\n")
        f.write("arguments = params-marsd-" + nf + ".txt " + i + "\n")
        f.write("queue\n\n")
        print("Name = " + name)

f.close()  
    
    
