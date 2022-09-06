#ifndef FRACTION_H_INCLUDED
#define FRACTION_H_INCLUDED


#include <iostream>
#include <exception>

class Fraction {
	
	public:
		Fraction(int n=0, int d=1);
		Fraction(const Fraction& f);
		
		Fraction& operator=(const Fraction& f);

		Fraction operator+(const Fraction& f) const;
		Fraction operator-(const Fraction& f) const;
		Fraction operator*(const Fraction& f) const;
		Fraction operator/(const Fraction& f) const;

		double eval() const;

		friend std::ostream& operator<<(std::ostream& out, const Fraction& f);
		friend std::istream& operator>>(std::istream& in, Fraction& f);

	private:
		int num;
		int den;
		void assign(int n, int d);

};

std::ostream& operator<<(std::ostream& out, const Fraction& f);
std::istream& operator>>(std::istream& in, Fraction& f);

class DivisionByZero: public std::exception {
	
	public:
		DivisionByZero(const char* message);
		const char* what() const throw();

	private:
		const char* msg;

};



#endif
