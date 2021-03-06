CPPC = icpc

IDIR = include/
SRCDIR = src
ODIR = src/obj
BOOSTLIB = -lboost_system -lboost_filesystem -lboost_system
#BOOSTLIB = ~/Documents/Research/code/trunk/Boost/boost_1_57_0/

VERFLAGS = -gxx-name=g++-4.8 -std=c++11 -g -Wall

#CPPFLAGS = -std=c++11 -O3 -xHost -ip -parallel -funroll-loops -fno-alias -fno-fnalias -fargument-noalias

#CPPFLAGS = -std=c++11 -O3 -xHost -ip -parallel -funroll-loops -fno-alias -fno-fnalias -fargument-noalias -no-ansi-alias

CPPFLAGS = -O3 -ip -parallel -funroll-loops -fno-alias -fno-fnalias -fargument-noalias -fstrict-aliasing -ansi-alias -fno-stack-protector-all
#-opt-streaming-stores always

OFFLOAD_FLAGS =
#OFFLOAD_FLAGS = -offload=optional

#MKL Flags.
MKLFLAGS = -DMKL_ILP64 -I$(MKLROOT)/include
#-mkl=sequential
#-offload-attribute-target=mic
#MKLFLAGS = -DMKL_ILP64 -I$(MKLROOT)/include -offload-option,mic,compiler,"$(MKLROOT)/lib/mic/libmkl_intel_ilp64.a $(MKLROOT)/lib/mic/libmkl_intel_thread.a $(MKLROOT)/lib/mic/libmkl_core.a" -offload-attribute-target=mic

#MKL link line. 
#MKLLINKLINE = -lpthread -lm
#MKLLINKLINE = -Wl,--start-group  $(MKLROOT)/lib/intel64/libmkl_intel_ilp64.a $(MKLROOT)/lib/intel64/libmkl_intel_thread.a $(MKLROOT)/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm
MKL_LIBS=-L$(MKLROOT)/lib/intel64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -lpthread -lm
MKL_MIC_LIBS=-L$(MKLROOT)/lib/mic -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core

NLOPTLIBS = -lnlopt
OMPFLAGS = -openmp -openmp-simd

REPORTFLAG = -qopt-report-phase=vec -qopt-report-file=stdout -openmp-report=0
#-guide
# -opt-report-phase=offload

#FPFLAGS = -fp-model strict -fp-model extended -fimf-arch-consistency=true -fimf-precision=high -no-fma 
# enable <name> floating point model variation
#     except[-]  - enable/disable floating point semantics
#     extended   - enables intermediates in 80-bit precision
#     fast       - allows value-unsafe optimizations
#     precise    - allows value-safe optimizations
#     source     - enables intermediates in source precision
#     strict     - enables -fp-model precise -fp-model except and disables floating point multiply add

_DEPENDENCIES = Acquire.hpp
#PRH.hpp DLAPACKE.hpp
DEPENDENCIES = $(patsubst %,$(IDIR)/%,$(_DEPENDENCIES))

_OBJECTS = Acquire.o
# PRH.o DLAPACKE.o
OBJECTS = $(patsubst %,$(ODIR)/%,$(_OBJECTS))

EXEC = testAcquire
EXT = .cpp

all: $(EXEC)
# $(EXEC3)

$(EXEC): $(OBJECTS) $(patsub %,$(EXEC)%,$(EXT))
	$(CPPC) $(VERFLAGS) -xHost $(CPPFLAGS) $(FPFLAG) -I $(IDIR) $(REPORTFLAG) $^ $(SRCDIR)/$(EXEC)$(EXT) -Bstatic $(BOOSTLIB) -o $@

$(ODIR)/%.o: $(SRCDIR)/%.cpp $(DEPENDENCIES)
	$(CPPC) -c $(VERFLAGS) -xHost $(CPPFLAGS) $(FPFLAGS) $(OMPFLAGS) -I $(IDIR) $< -o $@

install: $(EXEC)
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/include/usrlibs"
	mkdir /usr/include/usrlibs
	cp $(EXEC) /usr/include/usrlibs/$(EXEC)

.PHONY: clean
.PHONY: cleanExec
clean:
	rm -f $(ODIR)/*.o *~ $(EXEC) $(SRCDIR)/*~ $(IDIR)*~