#include "mammifere.h"
#include <string>

using namespace std;


Mammifere::Mammifere(int a, int w) : age(a), weight(w) {}

// int Mammifere::getAge() const{
//	return age;
// }

// int Mammifere::getWeight() const {
// 	return weight;
// }


Baleine::Baleine(int a, int w) : Mammifere(a, w) {}

string Baleine::crier() const {
	return "Je chaaaaaaaaaaaante";
}


Ratel::Ratel(int a, int w) : Mammifere(a, w) {}

string Ratel::crier() const {
	return "Sniff sniff je renifle";
}

