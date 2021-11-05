TARGET =proyecto
all:	${TARGET}

${TARGET}: ${TARGET}_parser.o ${TARGET}_lexer.o main.o
	g++ -g -o $@ $^

main.o: main.cpp
	g++ -g -c -o $@ $<

${TARGET}_lexer.o:	${TARGET}_lexer.cpp
	g++ -g -c -o $@ $<

${TARGET}_lexer.cpp:	lexer.l
	flex -i -o $@ $<

${TARGET}_parser.cpp: parser.y
	bison --defines=tokens.h -o $@ $<

${TARGET}_parser.o: ${TARGET}_parser.cpp
	g++ -g -c -o $@ $<

clean:
	rm -f *.o
	rm -f ${TARGET}_lexer.cpp
	rm -f ${TARGET}_parser.cpp
	rm -f ${TARGET}
	rm -f tokens.h
