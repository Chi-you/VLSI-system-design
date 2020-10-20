// generate the result of the signed data
#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <cstdint>
#include <bitset>
#include <iomanip>
#define M 16
using namespace std;
int binAdd (bitset < M >, bitset < M >, int, int);
int main(){
    fstream File, File2, File3, File4;
    stringstream ss;
    string line, line1;
    uint16_t tmp;
    vector<uint16_t> numbers_A;
    vector<uint16_t> numbers_B;
    int x;
    File.open("result.txt", ios::out);
    File2.open("A.txt", ios::in);
    File3.open("B.txt", ios::in);
    File4.open("ctrl.txt", ios::in);
    while(getline(File2, line, '\n')){
        ss << std::hex << line;
        ss >> tmp;
        ss.clear();
        numbers_A.push_back(tmp);
    }
    while(getline(File3, line1, '\n')){
        ss << std::hex << line1;
        ss >> tmp;
        ss.clear();
        numbers_B.push_back(tmp);
    }
    
    // (ctrl) ? A-B : A+B; 
    int i = 0, bsign;
    bitset<16> a_, b_;
    bitset<20> result;
    while(File4>>x){
        a_=numbers_A.at(i);
        b_=numbers_B.at(i);
        bsign = b_[15];
        bitset<20> a = binAdd(numbers_A.at(i), (~numbers_B.at(i)+1), bsign, x);
        bitset<20> b = binAdd(numbers_A.at(i), numbers_B.at(i), bsign, x);
        (x) ? result = a : result = b;
        File<< setfill('0') << setw(5) << uppercase <<hex<<result.to_ulong()<<endl;
        i++;
    }

    File.close();
    File2.close();
    File3.close();
    File4.close();
}

int binAdd (bitset < M > atemp, bitset < M > btemp, int b, int x){
    bitset < 18 > ctemp;
    for (int i = 0; i <= M; i++)
        ctemp[i] = 0;
    int carry = 0;
    for (int i = 0; i < M; i++) {
        if (atemp[i] + btemp[i] == 0){ 
            if (carry == 0)
                ctemp[i] = 0;
            else {
                ctemp[i] = 1;
                carry = 0;
            }
        }
        else if (atemp[i] + btemp[i] == 1){
            if (carry == 0)
                ctemp[i] = 1;
            else{
                ctemp[i] = 0;
                carry = 1;
            }
        }
        else{ // atemp + btemp = 2
            if (carry == 0){
                ctemp[i] = 0;
                carry = 1;
            }
            else{
                ctemp[i] = 1;
                carry = 1;
            }
        }
    }
    ctemp[M] = carry;
    ctemp[M+1] = ((x && atemp[15] && (b == 0) && (ctemp[15]==0)) || (x && (atemp[15] == 0) && b && ctemp[15]) || ((x == 0) && (atemp[15] == 0) && (b == 0) && ctemp[15]) || ((x == 0) && atemp[15] && b && (ctemp[15]==0))) ? 1: 0;
    return ctemp.to_ulong ();
}
