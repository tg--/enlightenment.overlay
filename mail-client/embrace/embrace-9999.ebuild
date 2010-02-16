# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_BRANCH="/"
ESVN_SUB_PROJECT="OLD/MISC"
inherit enlightenment

DESCRIPTION="mail-checker which is based on the EFL"

IUSE="ssl mbox maildir imap"

DEPEND="
	dev-db/edb
	>=dev-libs/ecore-0.9.9
	>=media-libs/evas-0.9.9
	>=media-libs/edje-0.5.0
	>=x11-libs/esmart-0.9.0
	ssl? ( dev-libs/openssl )
"

RDEPEND="${DEPEND}"

src_compile() {
	export MY_ECONF="
		$(use_enable ssl) \
		$(use_with mbox) \
		$(use_with maildir) \
		--with-pop \
		$(use_with imap) \
	"
	enlightenment_src_compile
}
