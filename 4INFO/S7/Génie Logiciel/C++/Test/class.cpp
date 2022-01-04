#include "class.h"

#include <iostream>
#include <string>

using std::cout;
using std::endl;
using std::string;


MyClass::MyClass() {
	cout << "Empty constructor called" << endl;
	name = "empty";
}

MyClass::MyClass(const MyClass& cl) {
	cout << "Copy constructor called with object \"" << cl << '"' << endl;
	name = cl.name + " - Copy";
}

MyClass::MyClass(const string& str) {
	cout << "Constructor of object \"" << str << '"' << endl;
	name = str;
}


MyClass& MyClass::operator=(const MyClass& cl) {
	cout << "Affectation operator called with object \""  << cl << '"' << endl;
	name = cl.name + "'";
	return *this;
}


MyClass::~MyClass() {
	cout << "Destructor called for object \"" << *this << '"' << endl;
}

