#include <iostream>
#include "fraction.h"

using namespace std;

int main(int argc, char** argv) {
	
	Fraction f, f1, f2;

	try {
		cout << "Enter f1 > "; cin >> f1;
		cout << "f1 = " << f1 << " = " << f1.eval() << endl;
		cout << "Enter f2 > "; cin >> f2;
		cout << "f2 = " << f2 << " = " << f2.eval() << endl;
		cout << endl;

		cout << "f1 + f2 = " << (f = f1+f2) << " = " << f.eval() << endl;
		cout << "f1 - f2 = " << (f = f1-f2) << " = " << f.eval() << endl;
		cout << "f1 * f2 = " << (f = f1*f2) << " = " << f.eval() << endl;
		cout << "f1 / f2 = " << (f = f1/f2) << " = " << f.eval() << endl;
	
	} catch(DivisionByZero* e) {
		cout << e->what() << endl;
	}

	return 0;
}
