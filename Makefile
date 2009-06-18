
WWW_FOLDER=html

# ALL
.PHONY: all
all:

# install
.PHONY: install
install: all
	mkdir -p ${DESTDIR}/var/www/dbedia
	cp -r ${WWW_FOLDER}/* ${DESTDIR}/var/www/dbedia/
	perl -MJSON::XS -le 'print JSON::XS->new->encode({ build_time => time() });' > ${DESTDIR}/var/www/dbedia/build.json
	mkdir -p ${DESTDIR}/etc/dbedia/sites-available
	cp etc/default ${DESTDIR}/etc/dbedia/sites-available/

# create debian package
.PHONY: deb
deb:
	debuild -b -us -uc --lintian-opts --no-lintian

# CLEAN
.PHONY: clean distclean
clean:

distclean:
