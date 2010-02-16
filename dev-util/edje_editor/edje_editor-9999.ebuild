# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit enlightenment

DESCRIPTION="edje editor based on etk"

IUSE=""

DEPEND=">=dev-libs/ecore-0.9.9.037
	>=x11-libs/etk-0.1.0.002
	>=media-libs/edje-0.5.0
	>=media-libs/evas-0.9.9"

RDEPEND="${DEPEND}"
