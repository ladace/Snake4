all : $(patsubst %.moon,%.lua,$(wildcard *.moon)) run

run :
	@love .
	
%.lua: %*.moon
	@moonc $<

.PHONY: all, run
