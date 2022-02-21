#! /bin/sh

echo "Generating test databases"

echo "Compiling files"
javac *.java

echo "Setting CLASSPATH"
export CLASSPATH=.:$CLASSPATH
echo $CLASSPATH

echo "Press a key to continue..."
read a
echo "Generating the file database.sql"
java DBgenerator 1000000
echo "DBgenerator Done"

echo "Press a key to continue..."
read a
echo "Generating the file database1.sql"
java DBgenerator1  1000000
echo "DBgenerator1 Done"

echo "Press a key to continue..."
read a
