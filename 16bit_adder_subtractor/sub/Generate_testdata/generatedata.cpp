#include <iostream>
#include <fstream>
#include <iomanip>
using namespace std;

int main(){
    fstream File;
    File.open("data.txt", ios::out);
    for(int i = 0; i < 65536; i++){
        File<< setfill('0') << setw(4) << uppercase << hex << i << endl;
    }
}
