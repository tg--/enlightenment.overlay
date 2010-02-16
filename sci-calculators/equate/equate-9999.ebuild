# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_BRANCH="/"
ESVN_SUB_PROJECT="OLD/MISC"
inherit enlightenment

DESCRIPTION="simple themeable calculator built off of ewl"
HOMEPAGE="http://andy.elcock.org/Software/Equate/"

IUSE=""

DEPEND=">=x11-libs/ewl-0.0.4
	>=dev-libs/ecore-0.9.9"

RDEPEND="${DEPEND}"
