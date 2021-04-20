# -*- coding: utf-8 -*-
"""
Created on Sat Mar 20 10:42:53 2021

@author: samar
"""
import os
dirname = os.path.dirname(__file__)
os.system("""forfiles /s /m *.v /c "cmd /c echo @relpath" > input1.txt""")
with open(os.path.join(dirname,"input1.txt"), 'r') as f, open(os.path.join(dirname, "FileList.txt"), 'w') as fo:
    for line in f:
        fo.write(line.replace('"', '').replace("'", ""))
        
        
os.system("iverilog -o proc -c FileList.txt");

os.system("iverilog -o proc -c FileList.txt -s Wrapper_tb");

os.system('iverilog -o proc -c FileList.txt -s Wrapper_tb -P Wrapper_tb.FILE=\\"lw_sw\\"');

os.system("vvp proc");