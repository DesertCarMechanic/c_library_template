
LIB_NAME = template_lib
SRC_DIR = src
SRC_FILES = foo.c
FULL_SRC_FILES = $(patsubst %.c,$(SRC_DIR)/%.c, $(SRC_FILES))

HEADER_FILES = foo.h

COBJECTS = $(patsubst %.c, %.o, $(SRC_FILES))

PACKAGES ?=
PKGCONFIG = pkg-config
COMPILER_FLAGS = -std=c99 -Wall
CFLAGS = $(if $(PACKAGES), $(shell $(PKGCONFIG) --cflags $(PACKAGES)),)
LIBS = $(if $(PACKAGES), $(shell $(PKGCONFIG) --libs $(PACKAGES)),)
INSTALL_DIR = /usr/lib
INCLUDE_DIR = /usr/include/$(LIB_NAME)

TEST_NAME = compiled_test_suite
TEST_DIR = tests
TEST_FILE_PREFIX = test
MAIN_TEST_FILE = $(TEST_DIR)/main.c
TEST_FILES = \
	foo.c
FULL_TEST_FILES = $(patsubst %.c,$(TEST_DIR)/$(TEST_FILE_PREFIX)_%.c, $(TEST_FILES))
TEST_SEED = $(shell date +"%s")
TEST_SEED_MACRO_NAME = TEST_SEED

all: compile library
debug: compile_debug library

compile: $(FULL_SRC_FILES)
	$(CC) -fpic -c $(COMPILER_FLAGS) $(CFLAGS) $(LIBS) $(FULL_SRC_FILES)

library: $(COBJECTS)
	$(CC) -shared $(COBJECTS) -o lib$(LIB_NAME).so 

strip: lib$(LIB_NAME).so
	strip --strip-debug lib$(LIB_NAME).so

compile_debug: $(FULL_SRC_FILES)
	$(CC) -fpic -c --verbose -g $(COMPILER_FLAGS) $(CFLAGS) $(LIBS) $(FULL_SRC_FILES)

test: $(FULL_SRC_FILES) $(MAIN_TEST_FILE) $(FULL_TEST_FILES)
	$(CC) \
		-D$(TEST_SEED_MACRO_NAME)=$(TEST_SEED) \
		$(FULL_SRC_FILES) \
		$(FULL_TEST_FILES) \
		$(MAIN_TEST_FILE) \
		$(COMPILER_FLAGS) \
		$(CFLAGS) \
		$(LIBS) \
		-o $(TEST_NAME)

install: lib$(LIB_NAME).so $(patsubst %.h, $(SRC_DIR)/%.h, $(HEADER_FILES))
	chmod 755 lib$(LIB_NAME).so
	cp lib$(LIB_NAME).so $(INSTALL_DIR)
	mkdir -p $(INCLUDE_DIR)
	for header in $(HEADER_FILES); do \
		cp $(SRC_DIR)/$$header $(INCLUDE_DIR); \
	done
	ldconfig -n $(INSTALL_DIR)

uninstall:
	$(RM) $(INSTALL_DIR)/lib$(LIB_NAME).so
	for header in $(HEADER_FILES); do \
		$(RM) $(INCLUDE_DIR)/$$header; \
	done
	rmdir $(INCLUDE_DIR)

clean:
	$(RM) *.o *.so core* $(TEST_NAME)

.PHONY: all clean
