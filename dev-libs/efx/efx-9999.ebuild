# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
E_PKG_IUSE="doc"
EFL_USE_GIT="yes"
EFL_GIT_REPO_CATEGORY="devs/discomfitor"

inherit efl

DESCRIPTION="A library for 2D effects"

IUSE="+test-gui"

DEPEND="
	>=dev-libs/efl-9999
"

DEPEND="${RDEPEND}"

src_configure() {
	export MY_ECONF="
		$(use_enable test-gui tests)
	"
efl_src_configure
}
