#include <iostream>
#include <string>
#include "class.h"

using std::cout;
using std::endl;


void function1(MyClass cl) {
	cout << "Begin fuction" << endl;
	MyClass cl1 = cl;
}

MyClass function2(MyClass& cl) {
	cout << "Begin fuction" << endl;
	return cl;
}

MyClass& function3(MyClass& cl) {
	cout << "Begin fuction" << endl;
	return cl;
}


int main(int agrc, char** argv) {
	
	MyClass cl1;
	MyClass cl2("instance");
	MyClass cl3(cl2);
	MyClass* cl4 = new MyClass("pointed");
	
	cout << endl << "function1" << endl;
	function1(cl1);

	cout << endl << "function2" << endl;
	cl1 = function2(cl2);
	
	cout << endl << "function3" << endl;
	cl3 = function3(cl2);

	cout << endl;
	delete cl4;

	return 0;
}

