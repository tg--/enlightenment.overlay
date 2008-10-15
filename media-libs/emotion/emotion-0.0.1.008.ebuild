# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/emotion/emotion-9999.ebuild,v 1.6 2006/02/14 00:32:25 vapier Exp $

inherit enlightenment

SRC_URI="http://download.enlightenment.org/snapshots/2007-08-26/${P}.tar.gz"

DESCRIPTION="video libraries for e17"

IUSE="gstreamer xine"

DEPEND=">=x11-libs/evas-0.9.9.041
	>=media-libs/edje-0.5.0.041
	>=x11-libs/ecore-0.9.9.041
	xine? ( >=media-libs/xine-lib-1.1.1 )
	!gstreamer? ( !xine? ( >=media-libs/xine-lib-1.1.1 ) )
	gstreamer? ( 
		=media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-good-0.10*
		=media-plugins/gst-plugins-ffmpeg-0.10*
	)"

src_compile() {
	if ! use xine && ! use gstreamer ; then
		export MY_ECONF="--enable-xine --disable-gstreamer"
	else
		export MY_ECONF="
			$(use_enable xine) \
			$(use_enable gstreamer) \
		"
	fi

	if use gstreamer ; then
		addpredict "/root/.gconfd"
		addpredict "/root/.gconf"
	fi

	enlightenment_src_compile
}
