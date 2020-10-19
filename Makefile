OUT = out
MAKEROOT = ./makeroot.sh

ROOTS = appstore alpine
ROOT_TARS = $(ROOTS:%=$(OUT)/%.tar.gz)

.PHONY: all
all: $(OUT) $(ROOT_TARS)

$(OUT):
	mkdir -p $@
.PHONY: clean
clean:
	rm -rf $(OUT)

define download-root
$$(OUT)/$(notdir $(1)):
	curl -L -o $$@ $(1)
endef

define make-root
$$(OUT)/$(1).tar.gz: $$(MAKEROOT) $(1).sh $$(OUT)/$(2).tar.gz
	$$(MAKEROOT) $$@ $$(OUT)/$(2).tar.gz $(1).sh
endef

$(eval $(call download-root,http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86/alpine-minirootfs-3.12.0-x86.tar.gz))
$(eval $(call make-root,alpine,alpine-minirootfs-3.12.0-x86))
$(eval $(call make-root,appstore,alpine-minirootfs-3.12.0-x86))
