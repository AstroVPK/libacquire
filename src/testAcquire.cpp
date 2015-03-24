#include <iostream>
#include <string>
#include "Acquire.hpp"

using namespace std;

int main() {
	string inPath;
	AcquireDirectory(cout,cin,"Path to directory: ","Input not understood. Try again!\n",inPath);
	cout << "From testAcquire: " << inPath << endl;
	}