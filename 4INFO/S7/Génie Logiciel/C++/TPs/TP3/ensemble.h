#ifndef ENSEMBLE_H_INCLUDED
#define ENSEMBLE_H_INCLUDED

#include <iostream>
#include <set>
#include <algorithm>

using uint = unsigned int;
using cuint = const unsigned int;


// template<typename T> class Ensemble;
// template<typename T> std::ostream& operator<<(std::ostream& out, const Ensemble<T>& e);
// template<typename T> std::istream& operator>>(std::istream& in, Ensemble<T>& e);

template<class T> class Ensemble {
	
	public :
		void clear() {
			data.clear();
		}
		
		void add(const T& t) {
			data.insert(t);
		}

		Ensemble<T> operator+(const Ensemble<T>& e) const {
			Ensemble<T> res;
			auto it = std::insert_iterator<std::set<T>>(res.data, res.data.begin());
			std::set_union(
				data.begin(), 
				data.end(),
				e.data.begin(),
				e.data.end(),
				it
			);
			return res;
		}

		Ensemble<T> operator-(const Ensemble<T>& e) const {
			Ensemble<T> res;
			auto it = std::insert_iterator<std::set<T>>(res.data, res.data.begin());
			std::set_difference(
				data.begin(), 
				data.end(),
				e.data.begin(),
				e.data.end(),
				it
			);
			return res;
		}
		
		Ensemble<T> operator*(const Ensemble<T>& e) const {
			Ensemble<T> res;
			auto it = std::insert_iterator<std::set<T>>(res.data, res.data.begin());
			std::set_intersection(
				data.begin(), 
				data.end(),
				e.data.begin(),
				e.data.end(),
				it
			);
			return res;
		}
		
		Ensemble<T> operator/(const Ensemble<T>& e) const {
			Ensemble<T> res;
			auto it = std::insert_iterator<std::set<T>>(res.data, res.data.begin());
			std::set_symmetric_difference(
				data.begin(), 
				data.end(),
				e.data.begin(),
				e.data.end(),
				it
			);
			return res;
		}

		// friend std::ostream& operator<< <> (std::ostream& out, const Ensemble<T>& e);
		// friend std::istream& operator>> <> (std::istream& in, Ensemble<T>& e);
		
		friend std::ostream& operator<<(std::ostream& out, const Ensemble<T>& e) {
			for(auto it = e.data.begin(); it != e.data.end(); ++it) {
				out << *it << " ";
			}
			return out;
		}

		friend std::istream& operator>>(std::istream& in, Ensemble<T>& e) {
			T t;
			while(!in.eof()) {
				in >> t;
				e.data.insert(t);
			}
			return in;
		}

	private :
		std::set<T> data;

};

#endif
