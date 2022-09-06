#ifndef MAMMIFERE_H_INCLUDED
#define MAMMIFERE_H_INCLUDED

#include <string>

enum class ModeDepl {MARCHER, VOLER, NAGER};


class Mammifere {
	
	public :
		Mammifere(int a, int w);

		int getAge() const;
		int getWeight() const;
		virtual ModeDepl getDepl() const;

		virtual std::string crier() const = 0;

	private :
		int age;
		int weight;

};

inline int Mammifere::getAge() const {return age;}

inline int Mammifere::getWeight() const {return weight;}

inline ModeDepl Mammifere::getDepl() const {return ModeDepl::MARCHER;}


class Baleine : public Mammifere {

	public :
		Baleine(int a, int w);
		
		virtual ModeDepl getDepl() const;

		std::string crier() const override;

};

inline ModeDepl Baleine::getDepl() const {return ModeDepl::NAGER;}


class Ratel : public Mammifere {

	public :
		Ratel(int a, int w);
		
		std::string crier() const override;

};

#endif
