#ifndef CLASS_H_INCLUDED
#define CLASS_H_INCLUDED

#include <iostream>
#include <string>


class MyClass {
	
	public :
		MyClass();
		MyClass(const MyClass& cl);
		MyClass(const std::string& str);

		MyClass& operator=(const MyClass& cl);

		friend std::ostream& operator<<(std::ostream& out, const MyClass& cl) {
			return out << cl.name;
		}

		~MyClass();
	
	private :
		std::string name;
};


#endif
