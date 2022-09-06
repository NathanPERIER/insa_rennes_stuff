#ifndef STRING_H_INCLUDED
#define STRING_H_INCLUDED

#include <string>
#include <iostream>

namespace mystring {
	
	class string {
		public :
			string(const char* s = "");
			string(const string& s);
			string(string&& s);
			string(const std::string& s);
			
			int size() const;
			
			string substr(const int begin, const int len) const;
			uint find(const string& s) const;
			
			const char* begin() const;
			const char* end() const;

			string& operator=(const string& s);
			string& operator+=(const string& s);
			char operator[](const unsigned int i) const;
			bool operator==(const string& s) const;
			bool operator<(const string& s) const;
			bool operator>(const string& s) const;
			
			friend std::ostream& operator<<(std::ostream& out, const string& s) {
				for(int i=0; i < s._size; i++) {
					out << s._chars[i];
				}
				return out;
			}

			friend std::istream& operator>>(std::istream& in, string& s) {
				std::string buf;
				in >> buf;
				s.setContent(buf);
				return in;
			}

			~string();

		private :
			char* _chars;
			int _size;

			void setContent(const char* s);
			void setContent(const string& s);
			void setContent(const std::string& s);
			void deleteContent();
	};
	
	inline int string::size() const { return _size; }
	
}


#endif
