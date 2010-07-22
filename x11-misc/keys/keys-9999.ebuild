# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

E_PKG_IUSE="doc nls"

PYTHON_DEPEND="*:2.4"
ESVN_SUB_PROJECT="PROTO"
inherit efl python distutils

DESCRIPTION="An On screen keyboard written in Python-EFL"

IUSE=""

DEPEND="dev-libs/ecore
	media-libs/evas
	media-libs/edje
	dev-python/virtkey"

RDEPEND="${DEPEND}"

src_unpack() {
	efl_src_unpack
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
}
