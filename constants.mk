GHDLC=ghdl
VCDFILE=../out.vcd
FLAGS=--warn-error --workdir=../
TB_OPTION=--assert-level=error
MODULES=
TESTS=
OBJS=$(addsuffix .o, ${MODULES})
TESTBENCHES=$(addsuffix _tb, ${TESTS})
