GHDLC=ghdl
FLAGS=--warn-error --workdir=../
TB_OPTION=--assert-level=error
VCDFILE=out.vcd
MODULES=
TESTS=
OBJS=$(addsuffix .o, ${MODULES})
TESTBENCHES=$(addsuffix _tb, ${TESTS})
