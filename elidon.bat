cd ./Assembler
javac project/*.java
java project.Runner
cd ..
sbt "run %~1"
