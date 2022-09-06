#include "planete.h"
#include "mammifere.h"
#include <vector>
#include <random>
#include <algorithm>

using namespace std;


Planete::Planete(const unsigned int cpt) {
	random_device rd;
    mt19937 gen(rd());
	uniform_int_distribution<> choice(0, 1);
	uniform_int_distribution<> aBaleine(1, 80);
	uniform_int_distribution<> aRatel(1, 24);
	uniform_int_distribution<> wBaleine(3000, 170000);
	uniform_int_distribution<> wRatel(2, 12);
	for(unsigned int i=0; i<cpt; i++) {
		Mammifere* m;
		if(choice(gen)) {
			m = new Baleine(aBaleine(gen), wBaleine(gen));
		} else {
			m = new Ratel(aRatel(gen), wRatel(gen));
		}
		habitants.push_back(m);
	}
}


int Planete::population() const {
	return habitants.size();
}

double Planete::ageMoyen() const { // We could use std::accumulate but it's C++ 20
	int total = 0;
	for(int i=0; i<habitants.size(); i++) {
		total += habitants[i]->getAge();
	}
	return (double)total / (double)(habitants.size());
}

#include <iostream>
#include <typeinfo>

double Planete::poidsMoyenBaleine() const {
	int total = 0;
	int cpt_baleines = 0;
	for(int i=0; i<habitants.size(); i++) {
		if(dynamic_cast<Baleine*>(habitants[i]) != nullptr) {
			cpt_baleines++;
			total += habitants[i]->getWeight();
		}
	}
	return (double)total / (double)cpt_baleines;
}

void Planete::tueLeDoyen() {
	auto it = max(habitants.begin(), habitants.end(), 
		[](auto m1, auto m2){return (*m1)->getAge() < (*m2)->getAge();}
	);
	cout << typeid(it).name() << endl;
	cout << typeid(*it).name() << endl;
	if(it != habitants.end()) {
		delete *it;
		habitants.erase(it);
	}
}


Planete::~Planete() {
	for(int i=0; i<habitants.size(); i++) {
		delete habitants[i]; // habitants[i] = nullptr;
	}
	
}

