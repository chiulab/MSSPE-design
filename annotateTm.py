#!/usr/bin/python
#
# annotates FASTA file with the Tm
#
#Usage:
# ./annotateTm.py fastaFile outputFile
#
# Charles Chiu
# 7/5/17

import sys

usage = "annotateTm.py <fastaFile> <outputFile>"
if len(sys.argv) != 3:
    print usage
    sys.exit(0)

fastaFile = sys.argv[1]
outputFile = sys.argv[2]

records = open(fastaFile,"r")
outputFile = open(outputFile, "w")

with open(fastaFile) as f:
    lines = f.readlines()
    
current = 0
while current < len(lines):
    header = lines[current]
    sequence = lines[current+1].strip("\n")
    gc_count = sequence.count('G') + sequence.count('C')
    at_count = sequence.count('A') + sequence.count('T')
    gc_percent = float(float(gc_count) / float(len(sequence)))
    tm = 64.9 + 41 * (gc_count-16.4)/(gc_count+at_count)
    # calculation of Tm from sequence
    outputFile.write(header.strip("\n") + "_GC_" + "%0.2f" % gc_percent + "_Tm_" + "%0.2f" % tm + "\n")
    outputFile.write(str(sequence) + "\n")
    current += 2

outputFile.close()
