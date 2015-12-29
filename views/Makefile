SRCS = $(wildcard *.moon)

PROGS = $(patsubst %.moon,%.lua,$(SRCS))

all: $(PROGS)

%.lua: %.moon
	moonc -o $@ $<

clean: 
	rm -f *.lua