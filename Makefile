SRCS = $(wildcard *.moon)

PROGS = $(patsubst %.moon,%.lua,$(SRCS))

SUBDIRS = views static

all: $(PROGS) $(SUBDIRS)

%.lua: %.moon
	moonc -o $@ $<

$(SUBDIRS):
	$(MAKE) -C $@ $<

clean:
	rm -f *.lua
	$(foreach DIR, $(SUBDIRS), $(MAKE) -C $(DIR) $@;)

.PHONY: all $(SUBDIRS)