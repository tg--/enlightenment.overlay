# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

E_PKG_IUSE="nls"

ESVN_SUB_PROJECT="E-MODULES-EXTRA"
ESVN_URI_APPEND="${PN#e_modules-}"
inherit efl

DESCRIPTION="Gadget to display the current uptime of the system"

IUSE=""

DEPEND="x11-wm/enlightenment:0.17
	>=dev-libs/efl-9999"

RDEPEND="${DEPEND}"
