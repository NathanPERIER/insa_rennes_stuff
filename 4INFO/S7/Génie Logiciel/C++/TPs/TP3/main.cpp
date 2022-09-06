//=======================================================================
// main.cpp
//=======================================================================

#include "ensemble.h"
#include <fstream>
#include <random>
#include <iostream>
#include <numeric>
#include <chrono>
#include <limits>
#include <string>
#include <sstream>
//using implementation1::Ensemble;


//=======================================================================
// Méthode   : 	class Timer
// But       : 	permet de compter et d'afficher le temps d'execution d'une partie du code
// Paramètres: 	-
//=======================================================================


class Timer {
	std::chrono::steady_clock::time_point start;
	std::chrono::steady_clock::time_point end;
public:
	Timer() :start(std::chrono::steady_clock::now()) {};
	Timer& set_end() { end = std::chrono::steady_clock::now(); return *this; }
	void set_start() { start = std::chrono::steady_clock::now(); };
	std::string time_elapsed(const unsigned int divide = 1) const {
		const unsigned int s = std::max(divide, static_cast<unsigned int>(1));
		std::chrono::milliseconds total(std::chrono::duration_cast<std::chrono::seconds>(end - start));
		total /= s;
		std::chrono::hours   hh = std::chrono::duration_cast<std::chrono::hours>(total);
		total -= hh;
		std::chrono::minutes mm = std::chrono::duration_cast<std::chrono::minutes>(total);
		total -= mm;
		std::chrono::seconds ss = std::chrono::duration_cast<std::chrono::seconds>(total);
		total -= ss;
		std::chrono::milliseconds ms = std::chrono::duration_cast<std::chrono::milliseconds>(total);

		std::ostringstream out;
		if (hh > std::chrono::hours(0))
			out << hh.count() << "h ";
		if (mm > std::chrono::minutes(0))
			out << mm.count() << "m ";
		if (ss > std::chrono::seconds(0))
			out << ss.count() << "s";
		else
			out << ms.count() << "ms";
		return out.str();
	}
};


//=======================================================================
// Méthode   : 	fonction generate
// But       : 	permet de remplir aléatoirement un ensemble d'entier positif
// Paramètres: 	l'ensemble puis la taille désirée
//=======================================================================

void generate(Ensemble<uint>& contain,cuint size) {
	std::random_device rd;
	std::default_random_engine gen(rd());
	std::uniform_int_distribution<uint> dist(std::numeric_limits<uint>::min(), std::numeric_limits<uint>::max());
	contain.clear();
	for (uint i = 0; i < size; ++i)
		contain.add(dist(gen));
}


/*
void compareImplementations() {
	constexpr uint size = 50000;
	Timer t1, t2;
	implementation1::Ensemble<uint> e1, e2;
	generate(e1,size);
	generate(e2,size);
	implementation2::Ensemble<uint> e11(e1);
	implementation2::Ensemble<uint> e22(e2);

	implementation1::Ensemble<uint> res1;
	implementation2::Ensemble<uint> res2;
	std::cout << "----Union" << endl;
	t1.set_start(); res1 = (e1 + e2);  std::cout << "imp1:" << t1.set_end().time_elapsed() << endl;
	t2.set_start(); res2 = (e11 + e22); std::cout << "imp2:" << t2.set_end().time_elapsed() << endl;
	std::cout << (res2 == res1) << endl;
	std::cout << "----Intersection" << endl;
	t1.set_start(); res1 = (e1 - e2);  std::cout << "imp1:" << t1.set_end().time_elapsed() << endl;
	t2.set_start(); res2 = (e11 - e22); std::cout << "imp2:" << t2.set_end().time_elapsed() << endl;
	std::cout << (res2 == res1) << endl;
	std::cout << "----Soustraction" << endl;
	t1.set_start(); res1 = (e1 * e2);  std::cout << "imp1:" << t1.set_end().time_elapsed() << endl;
	t2.set_start(); res2 = (e11 * e22); std::cout << "imp2:" << t2.set_end().time_elapsed() << endl;
	std::cout << (res2 == res1) << endl;
	std::cout << "----Difference" << endl;
	t1.set_start(); res1 = (e1 / e2);  std::cout << "imp1:" << t1.set_end().time_elapsed() << endl;
	t2.set_start(); res2 = (e11 / e22); std::cout << "imp2:" << t2.set_end().time_elapsed() << endl;
	std::cout << (res2 == res1) << endl;

}
*/

//=======================================================================
// Méthode   : 	Ensemble<int> lire(char* fname)
// But       : 	Lecture d'un ensemble dans un fichier texte
// Paramètres: 	fname	:
// Retour    : 	Ensemble<int>
//=======================================================================
Ensemble<uint> lire(const std::string& fname) {
	Ensemble<uint> res;
	// Ouverture du fichier contenant l'ensemble
	std::ifstream input(fname);

	if (!input) {
		std::cerr  << "Erreur de lecture de " << fname << std::endl;
	}
	else {
		input >> res;
		std::cout << "Contenu du fichier \"" << fname << "\" = " << res << std::endl;
	}

	// Fermeture du fichier (mais sinon il se fermera tout seul à la fin de la function car le destructeur de res sera appelé)
	input.close();

	return res;
}


void batch_test(cuint nb) {
	Ensemble<uint> e1, e2, e3;
	Timer t;
	std::cout << nb << " items" << std::endl;
	e1.clear(); generate(e1, nb);
	e2.clear(); generate(e2, nb);
	t.set_start();
	std::cout << "Union" << std::endl;
	e3 = e1 + e2;
	std::cout << "Intersection" << std::endl;
	e3 = e1 * e2;
	std::cout << "Subtraction" << std::endl;
	e3 = e1 - e2;
	std::cout << "Symmetric subtraction" << std::endl;
	e3 = e1 / e2;
	t.set_end();
	std::cout << "Duration : " << t.time_elapsed() << std::endl;
	std::cout << std::endl;
}


//=======================================================================
// Méthode   : 	void main()
// But       : 	Programme principal de test
// Paramètres: 	-
//=======================================================================
int main(int argc, char*argv[]) {

	
	// Lecture des ensembles
	Ensemble<uint> e1 = lire("test1.txt");
	Ensemble<uint> e2 = lire("test2.txt");

	// Opérations sur les ensembles
	std::cout << "Union        :: " << (e1 + e2) << std::endl;
	std::cout << "Intersection :: " << (e1 * e2)<< std::endl;
	std::cout << "Soustraction :: " << (e1 - e2)<< std::endl;
	std::cout << "Difference   :: "   << (e1 / e2)<< std::endl;
	std::cout << std::endl;

	batch_test(10000);
	batch_test(100000);

	// compareImplementations();
	
	return 0;
}
