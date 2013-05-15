
.PHONY: all test

all:

test: bin/unittests.dll
	nunit-console -labels $<

bin/unittests.dll: test/functional.boo src/functional.boo
	booc -r:nunit.framework -o:$@ $^
