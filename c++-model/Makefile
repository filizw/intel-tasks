# Makefile

SHELL        := /bin/tcsh
ROOT_DIR     := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

TOP_DIR     = ${ROOT_DIR}/..

ACT_INC_DIR = $(TOP_DIR)/libs/ac_types/include

TGT_SRC_DIR = .
TGT_INC_DIR = .
TGT_OUT     = .

INCS += -I${ACT_INC_DIR}

LIBS  =

DEFS  =

#EFS    += -DEN_DEBUG       # enable printing of debug information

# Gnu C compiler:
CC       = gcc
CFLAGS   = -std=c++17 -fPIC -Wall

# Gnu C++ compiler:
CXX      = g++
CXXFLAGS = -std=c++17 -fPIC -Wall

DEBUG = 0
ifeq ($(DEBUG),1)
CXXFLAGS += -g -ggdb3 -O0 -fno-inline
else
CXXFLAGS += -O3
endif

# Disable all cout by default:
DBG_ALL = 0
DBG_OUT = 0
DBG_TST = 0

ifeq ($(DBG_ALL),1)
DBG_OUT = 1
DBG_TST = 1
endif

ifeq ($(DBG_OUT),1)
DEFS += -DDBG_OUT=1
endif

ifeq ($(DBG_TST),1)
DEFS += -DDBG_TST=1
endif

# Error out on implicit promotions to double type:
# CXXFLAGS += -Werror=double-promotion

TGT_HPP  = Quadra.hpp
TGT_CPP  = Quadra.cpp QuadraTb.cpp
TGT_OBJ_ = $(patsubst %.cpp, %.o, $(TGT_CPP))
TGT_OBJ  = $(patsubst %, $(TGT_OUT)/%, $(TGT_OBJ_))

OBJECTS  = $(TGT_OBJ)

TGT_EXE  = QuadraTb

.PHONY: all
all: $(OBJECTS) $(TGT_EXE)

.PHONY: show_obj
show_obj:
	@echo 'Showing objects ...'
	@$(foreach i, $(OBJECTS), echo "    $(i)";)

$(TGT_OUT)/%.o: $(TGT_SRC_DIR)/%.cpp $(TGT_HPP) Makefile
	@echo 'Compiling ...'
	$(CXX) $(CXXFLAGS) $(DEFS) $(INCS) -o $@ -c $<

$(TGT_OUT)/$(TGT_EXE): $(OBJECTS)
	@echo 'Linking ...'
	$(CXX) $(CXXFLAGS) -o $(TGT_EXE) $(OBJECTS) $(LIBS)

.PHONY: run
run: $(TGT_EXE)
	@echo 'Running $(TGT_EXE) ...'
	@/usr/bin/time --format='Ran for %e seconds.' ./$(TGT_EXE)

.PHONY: clean
clean:
	@echo 'Cleaning ...'
	rm -f $(OBJECTS) $(TGT_EXE)
