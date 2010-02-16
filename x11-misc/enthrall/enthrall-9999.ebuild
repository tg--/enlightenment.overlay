# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_SUB_PROJECT="MISC"

inherit enlightenment

DESCRIPTION="Enthrall - screen capture application, built on Ecore and Imlib2"

IUSE=""

DEPEND=">=media-video/ffmpeg-9999
	>=dev-libs/ecore-9999
	>=media-libs/imlib2-9999"

RDEPEND="${DEPEND}"
