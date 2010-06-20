$(call PKG_INIT_BIN, 1.3.41)
$(PKG)_SOURCE:=$(pkg)_$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=http://archive.apache.org/dist/httpd
$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/$(pkg)_$($(PKG)_VERSION)
$(PKG)_BINARY:=$($(PKG)_DIR)/src/apache
$(PKG)_TARGET_BINARY:=$($(PKG)_TARGET_DIR)/apache-1.3.41/bin/apache
$(PKG)_SOURCE_MD5:=f7f00b635243f03a787ca9f4d4c85651

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_APACHE_STATIC

$(PKG)_CONFIGURE_DEFOPTS := n
$(PKG)_CONFIGURE_ENV += CC="$(TARGET_CC)"
$(PKG)_CONFIGURE_ENV += LD_SHLIB="$(TARGET_CC)"
$(PKG)_CONFIGURE_ENV += CFLAGS="$(TARGET_CFLAGS)"
$(PKG)_CONFIGURE_ENV += LDFLAGS="$(if $(FREETZ_PACKAGE_APACHE_STATIC),-static)"
$(PKG)_CONFIGURE_ENV += EXTRA_LIBS="-ldl"
$(PKG)_CONFIGURE_OPTIONS += --target=apache
$(PKG)_CONFIGURE_OPTIONS += --prefix=/apache-1.3.41/
$(PKG)_CONFIGURE_OPTIONS += --enable-module=most
$(PKG)_CONFIGURE_OPTIONS += --enable-shared=max

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(APACHE_DIR)

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(SUBMAKE1) -C $(APACHE_DIR) install \
		root="$(FREETZ_BASE_DIR)/$(APACHE_TARGET_DIR)"
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $(APACHE_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(APACHE_DIR) clean
	$(RM) $(APACHE_FREETZ_CONFIG_FILE)

$(pkg)-uninstall:
	$(RM) $(APACHE_TARGET_BINARY)

$(PKG_FINISH)
