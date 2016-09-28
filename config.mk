# Makefile configurations common for the subdirectories

BIN_DIR = /usr/bin
SBIN_DIR = /usr/sbin

ifeq ($(shell uname -m),x86_64)
LIB_DIR = /usr/lib64/uml
else
LIB_DIR = /usr/lib/uml
endif

CFLAGS = -g -Wall
LDFLAGS =
export BIN_DIR LIB_DIR CFLAGS LDFLAGS


ifndef TOPLEVELMAKEFILE

SRCS ?= $(wildcard *.c)
OBJS ?= $(SRCS:.c=.o)

all:: $(BIN) $(LIB)

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) -o $(BIN) $(OBJS) $(LIBS) $(LDFLAGS)

$(LIB): $(OBJS)
	$(AR) r $@ $<

clean::
	rm -f $(OBJS) $(LIB) $(BIN)

install:: $(BIN) $(LIB)
ifndef SKIP_INSTALL
ifneq ($(BIN),)
	install -D -s $(BIN) $(DESTDIR)$(BIN_DIR)/$(BIN)
endif
ifneq ($(LIB),)
	install -D -s $(LIB) $(DESTDIR)$(LIB_DIR)/$(LIB)
endif
endif #SKIP_INSTALL

endif #TOPLEVELMAKEFILE
