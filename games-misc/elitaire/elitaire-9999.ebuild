# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="2"

inherit enlightenment games

DESCRIPTION="EFL based solitaire game"
HOMEPAGE="http://www.mowem.de/elitaire"

IUSE=""

DEPEND="x11-libs/ewl
	media-libs/edje
	dev-libs/eet
	media-libs/evas
	dev-libs/ecore
	x11-libs/esmart"

RDEPEND="${DEPEND}"

pkg_setup() {
	games_pkg_setup
}

src_unpack() {
	# explicially call enlightenment_src_unpack to prevent any
	# misunderstand by portage
	enlightenment_src_unpack
}

src_compile() {
	export MY_ECONF="
		--with-scores-group=${GAMES_GROUP}
		--with-scores-user=${GAMES_USER}
	"
	MY_ECONF="${MY_ECONF} --localstatedir=${GAMES_STATEDIR}"
	enlightenment_src_compile
}
