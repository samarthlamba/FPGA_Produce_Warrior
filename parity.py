# -*- coding: utf-8 -*-
"""
Created on Tue Apr 13 19:37:12 2021

@author: samar
"""

one = [1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37];
two = [2,3,6,7,10,11,14,15,18,19,22,23,26,27,30,31,34,35, 38];
four = [4,5,6,7,12,13,14,15,20,21,22,23,28,29,30,31,36,37,38];
eight = [8,9,10,11,12,13,14,15,24,25,26,27,28,29,30,31,32];
sixteen = [16, 17, 18,19,20,21,22,23,24,25,26,27,28,29,30,31];
thirtytwo = [32,
 33,
 34,
 35,
 36,
 37,
 38,
 39,
 40,
 41,
 42,
 43,
 44,
 45,
 46,
 47,
 48,
 49,
 50,
 51,
 52,
 53,
 54,
 55,
 56,
 57,
 58,
 59,
 60,
 61,
 62,
 63];
areaToAdd = [0,1,3,7,15, 31]
combinedVals = [one, two, four, eight, sixteen, thirtytwo];

def shiftAdd(input1, position):
    if position != 0:
        ans = input1[0:position] + "?" + input1[position:]
        return ans;
    else:
        return "?" + input1;

def value(input1, includeIn0Index):
    combined = input1;
    include = includeIn0Index;
    if(include >= 0):
        combined = shiftAdd(combined, 0);
    if (include >= 1):
        combined =  shiftAdd(combined, 1);
    if (include >= 2):
        combined = shiftAdd(combined, 3);
    if (include >= 3):
        combined = shiftAdd(combined, 7);
    if (include >= 4):
        combined = shiftAdd(combined, 15);
    if (include >= 5):
        combined = shiftAdd(combined, 31);
    options = combinedVals[0:include+1];
    #print(combined)
    currentVal = 0;
    for k in options:
        total = 0;
        for values in k:
            if(values <= len(combined)):
         
                if(combined[values-1] == '1'):
                    total = total+1;
        
        #print(k)
        print(total)
        if(total%2 != 0):
           # print(areaToAdd[currentVal]);
            combined = combined[0:areaToAdd[currentVal]] + "1" + combined[areaToAdd[currentVal]+1:];
        else:
            #print(areaToAdd[currentVal]);
            combined = combined[0:areaToAdd[currentVal]] + "0" + combined[areaToAdd[currentVal]+1:];
        currentVal = currentVal +1
        
    if(combined.count('1')%2 != 0):
        print("add SECDED bit of 1")
    else:
        print("add SECDED bit of 0")
    return combined;

def wrong(input1, include):
    combined = input1
    options = combinedVals[0:include+1];
    #print(combined)
    ans = "";
    currentVal = 0;
    for k in options:
        total = 0;
        for values in k:
            if(values <= len(combined)):
         
                if(combined[values-1] == '1'):
                    total = total+1;
        
        #print(k)
        #print(total)
        if(total%2 != 0):
           # print(areaToAdd[currentVal]);
            print("current Val (0 index): " + str(currentVal) + " = 1")
            ans = ans + "1"
        else:
            #print(areaToAdd[currentVal]);
            print("current Val (0 index): " + str(currentVal) + " = 0")
            ans = ans + "0"
        currentVal = currentVal +1
    if('1' not in ans):
        print("CORRECT codeword");
    print((ans[::-1]))
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            