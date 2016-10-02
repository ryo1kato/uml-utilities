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


# default is to use all source(objs) files for the binary,
# if there's only one name defined in BIN/LIB
ifeq ($(words $(BIN) $(LIB)),1)
  $(BIN): $(OBJS)
else
  $(foreach tgt,$(BIN),\
    $(eval $(tgt): $(OBJS_$(tgt))))
endif

$(BIN):
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS) $(LDFLAGS)


$(LIB): $(OBJS)
	$(AR) r $@ $<



clean::
	rm -f $(OBJS) $(LIB) $(BIN) $(foreach bin,$(BIN) $(LIB),$(OBJS_$(bin)))


install:: $(BIN) $(LIB) $(SCRIPT)
ifndef SKIP_INSTALL
ifneq ($(BIN),)
	set -e; $(foreach bin,$(BIN),\
	  install -D $(INSTALL_OPTS_$(BIN)) -s $(bin) $(DESTDIR)$(BIN_DIR)/$(bin);)
endif
ifneq ($(LIB),)
	install -D $(INSTALL_OPTS_$(LIB)) -s $(LIB) $(DESTDIR)$(LIB_DIR)/$(LIB)
endif
ifneq ($(SCRIPT),)
	install -D $(INSTALL_OPTS_$(SCRIPT)) $(SCRIPT) $(DESTDIR)$(BIN_DIR)/$(SCRIPT)
endif
endif #SKIP_INSTALL


endif #TOPLEVELMAKEFILE


.PHONY: all clean install
