# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit efl

DESCRIPTION="Exquisite - EFL based psplash replacement"
IUSE=""

DEPEND="=dev-libs/efl-9999"

RDEPEND="${DEPEND}"

src_install() {
	    dodoc README AUTHORS

	    insinto "/usr/share/doc/${PF}/examples"
	    doins -r demo/run-demo.sh
	    emake DESTDIR="${D}" install
}
