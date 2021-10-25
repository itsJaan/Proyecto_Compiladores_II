TARGET = lexer
all:	${TARGET}

${TARGET}: ${TARGET}_lexer.o main.o
	g++ -o $@ $<

main.o: main.cpp
	g++ -g -c -o $@ $<

${TARGET}_lexer.o:	${TARGET}_lexer.cpp
	g++ -g -c -o $@ $<

${TARGET}_lexer.cpp:	${TARGET}.l
	flex -i -o $@ $<

clean:
	rm -f *.o
	rm -f ${TARGET}_lexer.cpp
	rm -f ${TARGET}