# -*- Mode: Makefile -*-
#
# Makefile for Toggle Website Colors (Global)
#

FILES = manifest.json \
        background.js \
        iconupdater.js \
        options.html \
        options.js \
        resetshortcuts.js \
        $(wildcard _locales/*/messages.json) \
        $(wildcard icons/*.svg)

ADDON = einkmode-firefox

VERSION = $(shell sed -n  's/^  "version": "\([^"]\+\).*/\1/p' manifest.json)

ANDROIDDEVICE = $(shell adb devices | cut -s -d$$'\t' -f1 | head -n1)

trunk: $(ADDON)-trunk.xpi native

release: $(ADDON)-$(VERSION).xpi native

%.xpi: $(FILES) icons/$(ADDON)-light.svg
	@zip -9 - $^ > $@

native:
	go build

icons/$(ADDON)-light.svg: icons/$(ADDON).svg
	@sed 's/:#0c0c0d/:#f9f9fa/g' $^ > $@

clean:
	rm -f $(ADDON)-*.xpi
	rm -f icons/$(ADDON)-light.svg

# Starts local debug session
run: icons/$(ADDON)-light.svg
	web-ext run --pref=devtools.browserconsole.contentMessages=true --bc

# Starts debug session on connected Android device
arun:
	@if [ -z "$(ANDROIDDEVICE)" ]; then \
	  echo "No android devices found!"; \
	else \
	  web-ext run --target=firefox-android --android-device="$(ANDROIDDEVICE)"; \
	fi
