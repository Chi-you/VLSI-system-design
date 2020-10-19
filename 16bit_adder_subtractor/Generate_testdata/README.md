# Generate the testing data for 16 bit subtractor/adder 
### To test the verilog code, 
### I write some C++ code to get the testing data randomly 
### and then get the correct result of the data
### Step

1. Use generatedata.cpp to generate the HEX number from 0 ~ 65536(2^16-1) and save it to data.txt
2. Use randomdata.cpp to randomly get some testing data from data.txt and save it to A.txt, B.txt, ctrl.txt
3. Use generateans.cpp to get the correct answer from the A.txt, B.txt, ctrl.txt and save it to result.txt
**Type "make" command to quickly get the data you want**  