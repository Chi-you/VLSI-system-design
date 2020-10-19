result.txt: A.txt B.txt ctrl.txt
	g++ generateans.cpp -o a 
	./a
A.txt: data.txt
	g++ randomdata.cpp -o a 
	./a
data.txt: 
	g++ generatedata.cpp -o a
	./a