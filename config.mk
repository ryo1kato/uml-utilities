# Makefile configurations common for the subdirectories

BIN_DIR  := /usr/bin
SBIN_DIR := /usr/sbin

ifeq ($(shell uname -m),x86_64)
LIB_DIR  := /usr/lib64/uml
else
LIB_DIR  := /usr/lib/uml
endif

CFLAGS   := -g -Wall
LDFLAGS  :=
export BIN_DIR LIB_DIR CFLAGS LDFLAGS

TUNTAP := $(shell [ -e /usr/include/linux/if_tun.h ] && echo -DTUNTAP)


#############################################################################
##
## Only for subdirectories
##
ifndef TOPLEVELMAKEFILE

override CFLAGS += $(TUNTAP)
SRCS ?= $(wildcard *.c)
ifeq ($(TUNTAP),)
SRCS := $(filter-out $(SRCS_TUNTAP),$(SRCS))
endif
OBJS ?= $(sort $(SRCS:.c=.o))

all:: $(BIN) $(LIB)

$(BIN): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS) $(LDFLAGS)

$(LIB): $(OBJS)
	$(AR) r $@ $<

clean::
	rm -f $(OBJS) $(LIB) $(BIN)

install:: $(BIN) $(LIB)
ifndef SKIP_INSTALL
ifneq ($(BIN),)
	install -D $(INSTALL_OPTS_$(BIN)) -s $(BIN) $(DESTDIR)$(BIN_DIR)/$(BIN)
endif
ifneq ($(LIB),)
	install -D $(INSTALL_OPTS_$(LIB)) -s $(LIB) $(DESTDIR)$(LIB_DIR)/$(LIB)
endif
endif #SKIP_INSTALL


endif #TOPLEVELMAKEFILE
