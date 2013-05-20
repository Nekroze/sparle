##################################################
#Build Variables
##################################################
SOURCES=src/*.boo
PLATFORM=anycpu
BOOC=booc -platform:$(PLATFORM)

##################################################
#Testing and Documentation Variables
##################################################
TESTS=test/*.boo
TESTER=@nunit-console -nologo -noresult -labels
BOOUNIT=booc -r:nunit.framework -platform:$(PLATFORM)

##################################################
#Color output
##################################################
E_BLACK=@echo "\033[0;30;49m"
E_RED=@echo "\033[0;31;49m"
E_GREEN=@echo "\033[0;32;49m"
E_YELLOW=@echo "\033[1;33;49m"
E_BLUE=@echo "\033[0;34;49m"
E_MAGENTA=@echo "\033[0;35;49m"
E_CYAN=@echo "\033[0;36;49m"
E_WHITE=@echo "\033[0;37;49m"
E_END="\033[0m"

##################################################
#Targets
##################################################
.PHONY: all test compile-tests clean mono-aot

all: bin/sparle.dll

nix-aot: bin/sparle.dll.so

bin/sparle.dll.so: bin/sparle.dll
	$(E_GREEN)"::::Ahead Of Time Compiling SPARLE Library with mono"$(E_END)
	mono --aot -O=all $<

bin/sparle.dll: $(SOURCES)
	$(E_GREEN)"::::Compiling SPARLE Library"$(E_END)
	@mkdir -p bin
	$(BOOC) -o:$@ $^

test: bin/unittests.dll
	$(E_GREEN)"::::Executing Unit Tests"$(E_END)
	$(TESTER) $<

compile-tests: bin/unittests.dll

bin/unittests.dll: $(TESTS) $(SOURCES)
	$(E_BLUE)"::::Compiling Unit Tests"$(E_END)
	@mkdir -p bin
	$(BOOUNIT) -o:$@ $^

clean:
	$(E_RED)"::::Removing Binaries"$(E_END)
	rm -rf bin
