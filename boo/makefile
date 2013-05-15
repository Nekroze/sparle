##################################################
#Build Variables
##################################################
SOURCES=src/functional.boo src/sparlist.boo
BOOC=booc

##################################################
#Testing and Documentation Variables
##################################################
TESTS=test/functional.boo test/sparlist.boo
TESTER=@nunit-console -nologo -noresult -labels
BOOUNIT=booc -r:nunit.framework

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
.PHONY: all test clean

all: bin/sparle.dll

bin/sparle.dll: $(SOURCES)
	$(E_GREEN)"::::Compiling SPARLE Library"$(E_END)
	@mkdir -p bin
	$(BOOC) -o:$@ $^

test: bin/unittests.dll
	$(E_GREEN)"::::Executing Unit Tests"$(E_END)
	$(TESTER) $<

bin/unittests.dll: $(TESTS) $(SOURCES)
	$(E_BLUE)"::::Compiling Unit Tests"$(E_END)
	@mkdir -p bin
	$(BOOUNIT) -o:$@ $^

clean:
	$(E_RED)"::::Removing Binaries"$(E_END)
	rm -rf bin
