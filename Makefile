# Basic Makefile

UUID = fedora-update@julio641742
BASE_MODULES = extension.js LICENCE.txt metadata.json prefs.js prefs.xml stylesheet.css utils.js org.freedesktop.policykit.pkexec.fedora-update.policy
TOLOCALIZE = extension.js
MSGSRC = $(wildcard po/*.po)
INSTALLBASE = ~/.local/share/gnome-shell/extensions
INSTALLNAME = fedora-update@julio641742

# The command line passed variable VERSION is used to set the version string 
# in the metadata and in the generated zip-file. If no VERSION is passed, the
# current commit SHA1 is used as version number in the metadata while the
# generated zip file has no string attached.
ifdef VERSION
	VSTRING = _v$(VERSION)
else
	VERSION = $(shell git rev-parse HEAD)
	VSTRING =
endif

all: extension

clean:
	rm -f ./schemas/gschemas.compiled

extension: ./schemas/gschemas.compiled $(MSGSRC:.po=.mo)

./schemas/gschemas.compiled: ./schemas/org.gnome.shell.extensions.fedora-update.gschema.xml
	glib-compile-schemas ./schemas/

potfile: ./po/fedoraupdate.pot

mergepo: potfile
	for l in $(MSGSRC); do \
		msgmerge -U $$l ./po/fedoraupdate.pot; \
	done;

./po/fedoraupdate.pot: $(TOLOCALIZE) prefs.xml
	mkdir -p po
	xgettext -k_ -kN_ -o po/fedoraupdate.pot --package-name "Fedora Update" $(TOLOCALIZE)
	intltool-extract --type=gettext/glade prefs.xml
	xgettext -k_ -kN_ --join-existing -o po/fedoraupdate.pot prefs.xml.h

./po/%.mo: ./po/%.po
	msgfmt -c $< -o $@

install: install-local

install-local: _build
	mkdir -p $(INSTALLBASE)/$(INSTALLNAME)/tmp
	cp -r $(INSTALLBASE)/$(INSTALLNAME)/tmp ./_build/.
	rm -rf $(INSTALLBASE)/$(INSTALLNAME)
	mkdir -p $(INSTALLBASE)/$(INSTALLNAME)
	cp -r ./_build/* $(INSTALLBASE)/$(INSTALLNAME)/
	-rm -fR _build
	echo done

zip-file: _build
	cd _build ; \
	zip -qr "$(UUID)$(VSTRING).zip" .
	mv _build/$(UUID)$(VSTRING).zip ./
	-rm -fR _build

_build: all
	-rm -fR ./_build
	mkdir -p _build
	cp $(BASE_MODULES) _build
	mkdir -p _build/icons
	cp icons/*.svg _build/icons/
	mkdir -p _build/schemas
	cp schemas/*.xml _build/schemas/
	cp schemas/gschemas.compiled _build/schemas/
	mkdir -p _build/locale
	for l in $(MSGSRC:.po=.mo) ; do \
		lf=_build/locale/`basename $$l .mo`; \
		mkdir -p $$lf; \
		mkdir -p $$lf/LC_MESSAGES; \
		cp $$l $$lf/LC_MESSAGES/fedoraupdate.mo; \
	done;
	sed -i 's/"version": -1/"version": "$(VERSION)"/'  _build/metadata.json;
