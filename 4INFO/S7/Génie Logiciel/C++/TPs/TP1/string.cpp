#include "string.h"  // our custom string
#include <string>    // C++ string object
#include <string.h>  // c-strings manipulation (strlen, ...)
#include <iostream>
#include <algorithm>

using namespace mystring;


void string::setContent(const char* s) {
	_size = strlen(s);
	_chars = new char[_size];
	if(_size > 0) {
		std::copy(s, s + _size, _chars);
	}
}

void string::setContent(const string& s) {
	_size = s._size;
	_chars = new char[_size];
	if(_size > 0) {
		std::copy(s._chars, s._chars + _size, _chars);
	}
}

void string::setContent(const std::string& s) {
	setContent(s.c_str());
}

void string::deleteContent() {
	delete _chars;
}


string::string(const char* s) {
	setContent(s);
}

string::string(const string& s) {
	setContent(s);
}

string::string(string&& s) {
	_size = s._size;
	_chars = s._chars;
	s._chars = NULL;
}

string::string(const std::string& s) {
	setContent(s);
}


string& string::operator=(const string& s) {
	deleteContent();
	setContent(s);
	return *this;
}

string& string::operator+=(const string& s) {
	char* str = new char[_size + s._size];
	std::copy(_chars, _chars + _size, str);
	std::copy(s._chars, s._chars + s._size, str + _size);
	_size += s._size;
    deleteContent();
	_chars = str;
	return *this;
}


string string::substr(const int begin, const int len) const {
	int actual_len = std::min(std::max(_size - 1 - begin, 0), len);
	if(actual_len == 0) {
		return string();
	}
	char* str = new char[actual_len + 1];
	std::copy(_chars + begin, _chars + begin + actual_len, str);
	str[actual_len] = '\0';
	string res = string(str);
	delete str;
	return res;
}

uint string::find(const string& s) const {
	int res = 0;
	int i, j;
	while(res < _size) {
		i = res;
		for(j = 0; j < s._size && i < _size && _chars[i] == s._chars[j]; j++) {
			i++;
		}
		if(j == s._size) {
			return res;
		}
		res = i+1;
	}
	return _size + 1;
}


const char* string::begin() const {
	return _chars;
}

const char* string::end() const {
	return _chars + _size;
}


char string::operator[](const unsigned int i) const {
	if(i >= _size) {
		return 0;
	}
	return _chars[i];
}

bool string::operator==(const string& s) const {
	if(_size != s._size) {
		return false;
	}
	for(int i=0; i < _size; i++) {
		if(_chars[i] != s._chars[i]) {
			return false;
		}
	}
	return true;
}

bool string::operator>(const string& s) const {
	int size = (_size < s._size) ? _size : s._size;
	for(int i=0; i < size; i++) {
		if(_chars[i] < s._chars[i]) {
			return false;
		} else if(_chars[i] > s._chars[i]) {
			return true;
		}
	}
	return (_size > s._size);
}

bool string::operator<(const string& s) const {
	int size = (_size < s._size) ? _size : s._size;
	for(int i=0; i < size; i++) {
		if(_chars[i] > s._chars[i]) {
			return false;
		} else if(_chars[i] < s._chars[i]) {
			return true;
		}
	}
	return (_size < s._size);
}


string::~string() {
	deleteContent();
}

