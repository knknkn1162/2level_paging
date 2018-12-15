include constants.mk
SUBDIRS=general pkg component

.PHONY: all clean open

all:
	list='$(SUBDIRS)'; for subdir in $$list; do \
	$(MAKE) -C $$subdir || exit 1;\
	done

clean:
	rm -f work-obj93.cf *.o *.vcd
open:
	open out.vcd
