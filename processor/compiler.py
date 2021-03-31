# -*- coding: utf-8 -*-
"""
Created on Sat Mar 20 10:42:53 2021

@author: samar
"""
import os

path = "C:\\Users\\samar\\Desktop\\Semester 6\\ECE350Labs\\finalProject\\processor\\"
os.system("cd " +path);
os.system("""forfiles /s /m *.v /c "cmd /c echo @relpath" > input1.txt""")
with open(path +"input1.txt", 'r') as f, open(path + "FileList.txt", 'w') as fo:
    for line in f:
        fo.write(line.replace('"', '').replace("'", ""))
        
        
os.system("iverilog -o proc -c FileList.txt");

os.system("iverilog -o proc -c FileList.txt -s Wrapper_tb");

os.system('iverilog -o proc -c FileList.txt -s Wrapper_tb -P Wrapper_tb.FILE=\\"lw_sw\\"');

os.system("vvp proc");