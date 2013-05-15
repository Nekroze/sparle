
.PHONY: all test

all:

test: bin/unittests.dll
	@echo "<<<<Executing Unit Tests"
	nunit-console -nologo -result=bin/TestResults.xml -labels $<

bin/unittests.dll: test/functional.boo src/functional.boo
	@echo "<<<<Compiling Unit Tests"
	booc -r:nunit.framework -o:$@ $^

clean:
	@echo "<<<<Removing Binaries"
	rm -rf bin/*
