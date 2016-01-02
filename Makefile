SRCS = $(wildcard *.moon)

PROGS = $(patsubst %.moon,%.lua,$(SRCS))

SUBDIRS = views static

all: $(PROGS) $(SUBDIRS)

%.lua: %.moon
	moonc -o $@ $<

$(SUBDIRS):
	$(MAKE) -C $@ $<

clean:
	$(foreach PROG, $(PROGS), rm -f $(PROG);)
	$(foreach DIR, $(SUBDIRS), $(MAKE) -C $(DIR) $@;)

.PHONY: all $(SUBDIRS)