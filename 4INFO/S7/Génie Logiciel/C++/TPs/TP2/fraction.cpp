#include "fraction.h"

#include <iostream>

int gcd(int a, int b) {
	std::cout << a << " " << b << std::endl;
	if(!a) {
		return b;
	}
    if(!b) {
    	return a;
	}
    if(a == b) {
        return a;
	}
    if(a > b) {
        return gcd(a-b, b);
	}
    return gcd(a, b-a);
}

void Fraction::assign(int n, int d) {
	if(!d) {
		throw new DivisionByZero("Tried to assign a fraction with a null denominator");
	}
	int pgcd = gcd((n >= 0) ? n : -1*n, d);
	num = n / pgcd;
	den = d / pgcd;
}

Fraction::Fraction(int n, int d) {
	assign(n, d);
}

Fraction::Fraction(const Fraction& f) {
	num = f.num;
	den = f.den;
}


Fraction& Fraction::operator=(const Fraction& f) {
	num = f.num;
	den = f.den;
	return *this;
}


Fraction Fraction::operator+(const Fraction& f) const {
	Fraction res(
		num * f.den + den * f.num,
		den * f.den
	);
	return res;
}

Fraction Fraction::operator-(const Fraction& f) const {
	Fraction res(
		num * f.den - den * f.num,
		den * f.den
	);
	return res;
}

Fraction Fraction::operator*(const Fraction& f) const {
	Fraction res(
		num * f.num,
		den * f.den
	);
	return res;
}

Fraction Fraction::operator/(const Fraction& f) const {
	if(!f.num) {
		throw new DivisionByZero("Attempt to divide by a null fraction");
	}
	Fraction res(
		num * f.den,
		den * f.num
	);
	return res;
}


double Fraction::eval() const {
	return (double) num / (double) den;
}

std::ostream& operator<<(std::ostream& out, const Fraction& f) {
	return out << f.num << "/" << f.den;
}

std::istream& operator>>(std::istream& in, Fraction& f) {
	int n, d;
	in >> n >> d;
	f.assign(n, d);
	return in;
}


// ===================================================


DivisionByZero::DivisionByZero(const char* message) {
	msg = message;
}

const char* DivisionByZero::what() const throw() {
	return msg;
}

