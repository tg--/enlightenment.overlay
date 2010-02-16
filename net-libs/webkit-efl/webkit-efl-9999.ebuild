# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_REPO_URI="git://gitorious.org/webkit-efl/webkit-efl.git"
inherit autotools git flag-o-matic

DESCRIPTION="Open source web browser engine"
HOMEPAGE="http://codeposts.blogspot.com"

LICENSE="LGPL-2 LGPL-2.1 BSD"
SLOT="0"
IUSE="coverage debug gstreamer sqlite svg xslt"

RDEPEND=">=media-libs/evas-9999
	>=dev-libs/ecore-9999
	>=media-libs/edje-9999
	>=x11-libs/cairo-1.6.4
	>=media-libs/fontconfig-2.4.2
	media-libs/freetype
	dev-libs/libxml2
	sqlite? ( >=dev-db/sqlite-3 )
	gstreamer? (
		    >=media-libs/gst-plugins-base-0.10
		)
	soup? ( >=net-libs/libsoup-2.23.1 )
	xslt? ( >=dev-libs/libxslt-1.1.7 )
	pango? ( >=x11-libs/pango-1.0 )
	dev-libs/icu
	!net-libs/webkit-gtk
	"

DEPEND="${RDEPEND}
	dev-util/gperf
	dev-util/pkgconfig
	virtual/perl-Text-Balanced"

webkit_die() {
	eerror "webkit-efl currently very fragle when it comes to USE-flags"
	eerror "Last known working combination:"
	eerror
	eerror "svg -gstreamer +xslt +sqlite coverage ?debug"
	eerror "'-' means - must be disabled, '+' means - must be enabled"
	eerror "'?' means - state unknown. Other flags doesn't affect package buildability"

	die "Consider re-emerging with flags specified above"
}

src_unpack() {
	ewarn
	ewarn "webkit-efl have BIG repo - ~650 Mb, so hit Ctrl+C now if you have less than 1.5 Mbit link"
	ewarn
	ebeep 5

	git_src_unpack

	cd "${S}"
}

src_prepare() {
	AT_M4DIR="autotools"

	eautoreconf
}

src_configure() {
	econf \
		--with-port=efl \
		--disable-web-workers \
		$(use_enable sqlite database) \
		$(use_enable sqlite icon-database) \
		$(use_enable sqlite dom-storage) \
		$(use_enable sqlite offline-web-applications) \
		$(use_enable svg) \
		$(use_enable debug) \
		$(use_enable xslt) \
		$(use_enable coverage) \
		$(use_enable gstreamer video) \
		${myconf} \
		|| webkit_die die "configure failed"
}

src_compile() {
	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	emake -f GNUmakefile || webkit_die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || webkit_die "Install failed"
}
