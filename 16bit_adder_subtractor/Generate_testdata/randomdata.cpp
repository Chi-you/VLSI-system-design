// generate the testing data
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <vector>
#include <string>
#include <ctime>
using namespace std;
int main(){
    fstream File, File2, File3, File4;
    vector<string> lines;
    string line;
    srand(time(NULL));
    File.open("data.txt", ios::in);
    File2.open("A.txt", ios::out);
    File3.open("B.txt", ios::out);
    File4.open("ctrl.txt", ios::out);
    int total_lines=0;
    while(getline(File,line)) {
        total_lines++; 
        lines.push_back(line);  
    }
    int random_number = 0, random_number1 = 0, ctrl = 0;
    for(int i = 0; i < 10000; i++){
        random_number = rand() % total_lines;
        File2 << uppercase << lines[random_number] << endl; 
    }
    for(int i = 0; i < 10000; i++){
        random_number1 = rand() % total_lines;
        File3 << uppercase << lines[random_number1] << endl;
    }
    for(int i = 0; i < 10000; i++){
        ctrl = rand() % 2;
        File4 << ctrl << endl;
    }
    File.close();
    File2.close();
    File3.close();
    File4.close();
    
    
}