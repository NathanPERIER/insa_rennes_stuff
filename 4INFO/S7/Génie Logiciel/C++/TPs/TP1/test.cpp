//=======================================================================
// Nom      : 	test.cpp
//
// But      : 	Programme de test de la classe string
//
// Création : 	18/09/2019
//
// Auteur	:	Christian Raymond
//=======================================================================

#include "string.h"
#include <string>
#include <algorithm>
#include <iostream>
using std::cout;
using std::cin;
using std::endl;
using mystring::string;


string eval(const bool val, const bool obtenu) {
	return (val == obtenu) ? "OK" : "TEST NON REUSSI";
}

int main(int argc, char** argv) {
	//test istream operator>>	
	try {
	string libre, libre2, libre3;
	cout << "Entrez deux strings au clavier : ";
	cin >> libre >> libre2;
	cout << "La string libre  vaut " << '"' << libre << '"' << " de taille : " << libre.size() << endl;
	cout << "La string libre2 vaut " << '"' << libre2 << '"' << " de taille : " << libre2.size() << endl;
	cout << "Entrez à nouveau libre2 : ";
	cin >> libre2;
	cout << "La string libre2 vaut " << '"' << libre2 << '"' << " de taille : " << libre2.size() << endl;
	cout << endl;
	} catch (std::exception & e) {
		std::cerr << e.what() << std::endl;
	}

	//test des constructeurs
	string vide;
	string TPC("TP de C++");
	string tpc("tp de c++");
	string copie_tpc(tpc);
	string *pcopie_tpc=new string("tp de c++");


	cout << "vide = \"" << vide << "\"" << endl;
	cout << "TPC = \"" << TPC << "\"" << endl;
	cout << "tpc = \"" << tpc << "\"" << endl;
	cout << "copie_tpc = \"" << copie_tpc << "\"" << endl;
	cout << "pcopie_tpc = \"" << *pcopie_tpc << "\"" << endl;
	

	//test operator=
	string affectation;
	affectation = TPC;
	cout << affectation << " =? " << TPC << endl;
	cout << endl;

	//test iterateurs
	auto it=std::find(TPC.begin(),TPC.end(),'d');
	if(it!=TPC.end())
		cout<< "d found in position : "<<it-TPC.begin()<<endl;
	cout << endl;

	//test comparateurs
	cout << TPC << " > " << tpc << " doit donner FAUX : " << eval(false,TPC > tpc) << endl;
	cout << TPC << " < " << tpc << " doit donner VRAI : " << eval(true,TPC < tpc) << endl;
	cout << TPC << " == " << TPC << " doit donner VRAI : " << eval(true,TPC == TPC) << endl;
	cout << tpc << " == " << copie_tpc << " doit donner VRAI : " << eval(true,tpc == copie_tpc) << endl;
	cout << TPC << " == " << copie_tpc << " doit donner FAUX : " << eval(false,TPC == copie_tpc) << endl;
	cout << endl;

	//test operator+=
	string cat = "cat";
	cat += "dog";
	cout << cat  << " doit donner 'catdog' : " << eval(true, cat == "catdog") << endl;

	string contenu("trouve moi la dedans toto");
	uint cherche1 = contenu.find("dedans");		
	cout << "sous chaine 'dedans' trouvée à position = " << cherche1 << " : " << eval(true,cherche1==14) << endl;
	uint cherche2 = contenu.find("titi");
	cout << "sous chaine 'titi' pas trouvée = " << cherche2 << " : " << eval(true, cherche2 >= contenu.size()) << endl;
	string cherche3 = contenu.substr(cherche1,4);
	cout << "sous chaine 'deda' = " << cherche3 << " : " << eval(true, cherche3 == "deda") << endl;

	//test constructeur par déplacement
	string vole_tpc(std::move(tpc)); //illustration de la "sémantique de déplacement" vole_tpc s'approprie le contenu de tpc ici qui est consid�r� mort apr�s
	cout << "vole_tpc = \"" << vole_tpc << "\" et tpc doit etre mort" << endl;



	delete pcopie_tpc;
	return 0;
}

