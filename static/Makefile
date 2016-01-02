SCSS = $(wildcard *.scss)

CSS = $(patsubst %.scss,%.css,$(SCSS))

COFFEE = $(wildcard *.coffee)

JS = $(patsubst %.coffee,%.js,$(COFFEE))

all: $(CSS) $(JS)

%.css: %.scss
	sass -q -C --sourcemap=none $< $@

%.js: %.coffee
	coffee -c $< $@

clean: 
	$(foreach FILE, $(CSS), rm -f $(FILE);)
	$(foreach FILE, $(KS), rm -f $(FILE);)