# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_BRANCH="/"
ESVN_SUB_PROJECT="OLD"
inherit enlightenment

DESCRIPTION="Enlightenment File Daemon"

IUSE="samba curl bzip2 taglib debug"

DEPEND="dev-libs/ecore
	dev-libs/eet
	media-libs/evas
	dev-libs/efreet
	dev-libs/ecore
	dev-libs/libxml2
	>=dev-db/sqlite-3
	media-libs/libextractor
	taglib? ( media-libs/taglib )
	bzip2? ( app-arch/bzip2 )
	curl? ( net-misc/curl )
	samba? ( net-fs/samba )"

RDEPEND="${DEPEND}"

src_prepare() {
	mv debian/changelog debian/changelog.in

	enlightenment_src_prepare
}

src_configure() {
	export MY_ECONF="
		$(use_enable samba)
		--enable-plugin-extractor
	"

	enlightenment_src_configure
}
