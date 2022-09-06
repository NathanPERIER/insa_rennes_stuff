#include <iostream>
#include "planete.h"

using std::cout;
using std::endl;

using cuint = const unsigned int;

int main() {
	cuint size = 10;
	Planete p(size);
	cout << "Planete de " << p.population() << " habitants" << endl;
	cout << "Age moyen : " << p.ageMoyen() << endl;
	cout << "Poids moyen des baleines :" << p.poidsMoyenBaleine() << " kg" << endl;
	for (uint i = 0; i < 3; ++i) {
		p.tueLeDoyen();
		cout << "Planete de " << p.population() << " habitants" << endl;
	}
}

