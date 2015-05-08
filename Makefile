TEST_FILES = $(wildcard tests/test_*.py)
TESTS = $(subst .py,,$(subst /,.,$(TEST_FILES)))
VERSION = $(shell cat setup.py | grep version | sed -e "s/version=//" -e "s/'//g" -e "s/,//" -e 's/^[ \t]*//')

all.PHONY: nosetests_2_3

nosetests_2_3:
	@echo "Running python2 tests"
	@python2.7 `which nosetests`
	@echo "Running python3 tests"
	@python3 `which nosetests`

install:
	@echo "Creating distribution package for version $(VERSION)"
	@echo "-----------------------------------------------"
	python setup.py sdist
	@echo "Installing package using pip"
	@echo "----------------------------"
	pip install --upgrade dist/Pulla-$(VERSION).tar.gz

coverage:
	@coverage run  --include='*powerclone*' `which nosetests`
	@coverage report

test:
	@- $(foreach TEST,$(TESTS), \
		echo === Running test: $(TEST); \
		python -m $(TEST) $(PYFLAGS); \
		)

test2:
	@- $(foreach TEST,$(TESTS), \
		echo === Running python2 test: $(TEST); \
		python2 -m $(TEST) $(PYFLAGS); \
		)
test3:
	@- $(foreach TEST,$(TESTS), \
		echo === Running python3 test: $(TEST); \
		python3 -m $(TEST) $(PYFLAGS); \
		)
