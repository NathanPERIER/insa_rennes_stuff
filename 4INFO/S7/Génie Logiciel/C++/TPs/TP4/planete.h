#ifndef PLANETE_H_INCLUDED
#define PLANETE_H_INCLUDED

#include <vector>
#include "mammifere.h"

class Planete {

	public :
		Planete(const unsigned int cpt);

		int population() const;
		double ageMoyen() const;
		double poidsMoyenBaleine() const;

		void tueLeDoyen();

		~Planete();
	
	private :
		std::vector<Mammifere*> habitants;

};

#endif
