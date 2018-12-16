include constants.mk
SUBDIRS=general pkg controller component

.PHONY: all clean open

all:
	list='$(SUBDIRS)'; for subdir in $$list; do \
	$(MAKE) -C $$subdir || exit 1;\
	echo "$$subdir directory done";\
	done

clean:
	rm -f work-obj93.cf *.o *.vcd
open:
	open out.vcd
