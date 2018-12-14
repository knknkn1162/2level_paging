test: $(OBJS) $(TESTBENCHES)

%_tb:
	$(GHDLC) -r ${FLAGS} ${F}_tb --vcd=${VCDFILE} ${TB_OPTION}

%: %.o
	$(GHDLC) -e $(FLAGS) $@
%.o: %.vhdl
	$(GHDLC) -a $(FLAGS) $<
