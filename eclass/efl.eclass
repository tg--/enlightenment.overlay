# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author: vapier@gentoo.org
# Modified: barbieri@profusion.mobi
# Modified: NightNord@gmail.com
# Modified: gentoo.sera@bluewin.ch
# Modified: mike@zentific.com

# @ECLASS: efl.eclass
# @MAINTAINER:
# barbieri@profusion.mobi
# mike@zentific.com
# @BLURB: Provides common code for EFL package based ebuilds.
# @DESCRIPTION:
# Exports ebuild phase functions: src_unpack src_prepare src_configure
#   src_compile src_install src_test
#
# Reqires EAPI 2 or later.
#
# @CODE
# E_STATE's:
#   release      [default]
#
#   snap
#
#   live         $PV has a 9999 marker
#       S        $WORKDIR/$E_S_APPEND
#
# Overrides:
#    S           EURI_STATE
# @CODE

# The elass expects the ebuilds to use EAPI 2 or later, so make sure this is
# the case.

case "${EAPI}" in
	2|3|4) ;;
	*) die "EAPI 2 or later required";;
esac

inherit eutils libtool flag-o-matic

# @ECLASS-VARIABLE: E_NO_VISIBILITY
# @DESCRIPTION:
# if defined, the package does not support -fvisibility=hidden

# @ECLASS-VARIABLE: E_NO_DISABLE_STATIC
# @DESCRIPTION:
# if defined, do not append --disable-static

# Python support:
# @ECLASS-VARIABLE: E_PYTHON
# @DESCRIPTION:
# if defined, the package is Python/distutils

# @ECLASS-VARIABLE: E_CYTHON
# @DESCRIPTION:
# if defined, the package is Cython bindings (implies E_PYTHON)

# @ECLASS-VARIABLE: E_PKG_IUSE
# @DESCRIPTION:
# Use EFL_PKG_IUSE instead of IUSE for doc, examples, nls and test so that the
# eclass can automagically add the needed dependencies and or perform the
# required actions.
IUSE="${E_PKG_IUSE}"

# @ECLASS-VARIABLE: E_LIVE_SERVER_DEFAULT_SVN
# @DESCRIPTION:
# Default svn repository to use.
E_LIVE_SERVER_DEFAULT_SVN="http://svn.enlightenment.org/svn/e/trunk"

E_STATE="release"

if [[ ${PV/9999} != ${PV} ]] ; then
	E_STATE="live"

	# TODO live is not a permitted token according to pms.
	# Switch to the mechanism to denote live packages once decided upon and
	# available.
	PROPERTIES="live"

	: ${WANT_AUTOTOOLS:=yes}

# @ECLASS-VARIABLE: E_EXTERNAL
# @DESCRIPTION:
# If defined, efl.eclass will not automatically inherit subversion and do any
# magic for it
	if [[ -z "${E_EXTERNAL}" ]]; then
# @ECLASS-VARIABLE: E_LIVE_OFFLINE
# @DESCRIPTION:
# Use ESCM_OFFLINE="yes" only for enlightenment packages. Usefull if you want to
# have manual control over subversion revisions
		[[ -n ${E_LIVE_OFFLINE} ]] && ESCM_OFFLINE="yes"

# @ECLASS-VARIABLE: E_LIVE_SERVER
# @DESCRIPTION:
# Use another server than the default svn repo
		: ${E_LIVE_SERVER:=${E_LIVE_SERVER_DEFAULT_SVN}}

# @ECLASS-VARIABLE: ESVN_URI_APPEND
# @DESCRIPTION:
# This is addition to final default svn repo path, namely package name
		ESVN_URI_APPEND=${ESVN_URI_APPEND:-${PN}}

# @ECLASS-VARIABLE: ESVN_SUB_PROJECT
# @DESCRIPTION:
# Sub-group into svn.enlightenment.org repository trunk
		ESVN_URI_APPEND=${ESVN_URI_APPEND:-${PN}}

		ESVN_PROJECT="enlightenment/${ESVN_SUB_PROJECT}"
		ESVN_REPO_URI="${E_LIVE_SERVER}/${ESVN_SUB_PROJECT}/${ESVN_URI_APPEND}"

		S="${WORKDIR}/${ESVN_URI_APPEND}"

		inherit subversion
	fi
fi

if [[ ! -z "${E_CYTHON}" ]]; then
	E_PYTHON="yes"
fi

if [[ ! -z "${E_PYTHON}" ]]; then
	WANT_AUTOTOOLS="no"
	WANT_AUTOCONF="no"
	WANT_AUTOMAKE="no"

	E_NO_VISIBILITY="yes"

	NEED_PYTHON="2.4"

	inherit python distutils
fi

if [[ ${WANT_AUTOTOOLS} == "yes" ]] ; then
	: ${WANT_AUTOCONF:=${E_WANT_AUTOCONF:-latest}}
	: ${WANT_AUTOMAKE:=${E_WANT_AUTOMAKE:-latest}}

	inherit autotools
fi

HOMEPAGE="http://www.enlightenment.org/"

LICENSE="BSD"
SLOT="0"

DEPEND="${DEPEND} dev-util/pkgconfig"

if has nls "${IUSE}"; then
	DEPEND="${DEPEND} nls? ( sys-devel/gettext )"
fi

if has doc "${IUSE}"; then
	DEPEND="${DEPEND} doc? ( app-doc/doxygen )"
fi

if [[ -z "${E_PYTHON}" ]] && has test "${IUSE}"; then
	DEPEND="${DEPEND} test? ( dev-libs/check )"
fi

if [[ ! -z "${E_CYTHON}" ]]; then
	DEPEND="${DEPEND} >=dev-python/cython-0.12.1"
fi

if [[ ! -z "${E_PYTHON}" ]]; then
	DEPEND="${DEPEND} >=dev-python/setuptools-0.6_rc9"
fi

if [[ -z "${E_NO_VISIBILITY}" ]] && [[ $(gcc-major-version) -ge 4 ]]; then
	# FIXME: This IS hack. It should be enabled by configures, not by ebuilds.
	# Portage will be unhappy with this line

	append-flags -fvisibility=hidden
fi

# @FUNCTION: efl_warning_msg
# @USAGE:
# @DESCRIPTION:
# print server used and what to do if things go haywire
efl_warning_msg() {
	if [[ -n ${E_LIVE_SERVER} ]] ; then
		einfo "Using user server for live sources: ${E_LIVE_SERVER}"
	fi

	if [[ ${E_STATE} == "live" ]] ; then
		eerror "This is a LIVE SOURCES ebuild."
		eerror "That means there are NO promises it will work."
	fi
}

# @FUNCTION: efl_die
# @USAGE:
# @DESCRIPTION:
# calls efl_warning_msg and then die
efl_die() {
	efl_warning_msg
	die "$@"$'\n'"!!! SEND BUG REPORTS TO enlightenment@gentoo.org NOT THE E TEAM"
}

# @FUNCTION: efl_src_test
# @USAGE:
# @DESCRIPTION:
# calls emake check on non python packages with test in EFL_PKG_IUSE
efl_src_test() {
	emake -j1 check || die "Make check failed. see above for details"
}

# @FUNCTION: gettext_modify
# @USAGE:
# @DESCRIPTION:
# the stupid gettextize script prevents non-interactive mode, so we hax it
gettext_modify() {
	if has nls "${IUSE}" && use nls; then
		cp $(type -P gettextize) "${T}"/ || die "could not copy gettextize"
		sed -i \
			-e 's:read dummy < /dev/tty::' \
			"${T}"/gettextize
	fi
}

# @FUNCTION: efl_src_unpack
# @USAGE:
# @DESCRIPTION:
# calls subversion_src_unpack for live packages otherwise default_src_unpack
efl_src_unpack() {
	if [[ "${E_STATE}" == "live" ]] ; then
		subversion_src_unpack
	else
		default_src_unpack
	fi
}

# @FUNCTION: efl_src_prepare
# @USAGE:
# @DESCRIPTION:
# Applys the gettext_modifiy hack and runs the autotools stuff.
efl_src_prepare() {
	gettext_modify

	[[ -s gendoc ]] && chmod a+rx gendoc

	[[ -z "${E_PYTHON}" ]] || return;

	if [[ -e configure.ac || -e configure.in ]] && [[ "${WANT_AUTOTOOLS}" == "yes" ]]; then
		if [[ "${E_STATE}" == "live" ]] && [[ -z "${E_EXTERNAL}" ]]; then
			export SVN_REPO_PATH="${ESVN_WC_PATH}"
		fi

		AM_OPTS="--foreign"

		local macro_regex='^[[:space:]]*AM_GNU_GETTEXT_VERSION'

		if has nls "${IUSE}" && use nls; then
			local x=

			for x in configure.{ac,in}; do
				if [[ -r ${x} ]] && grep -qE "${macro_regex}" ${x}; then
					eautopoint -f
					break;
				fi
			done
		fi

		eautoreconf
	fi

	epunt_cxx
}

# @FUNCTION: efl_src_configure
# @USAGE:
# @DESCRIPTION:
# efl's default src_configure
efl_src_configure() {
	[[ -z "${E_PYTHON}" ]] || return;

	if [[ -x ${ECONF_SOURCE:-.}/configure ]]; then
		has nls "${IUSE}" && MY_ECONF="${MY_ECONF} $(use_enable nls)"
		has doc "${IUSE}" && MY_ECONF="${MY_ECONF} $(use_enable doc)"

		[[ -z "${E_NO_DISABLE_STATIC}" ]] && MY_ECONF="${MY_ECONF} --disable-static"

		econf ${MY_ECONF} || efl_die "configure failed"
	fi
}

# @FUNCTION: efl_src_compile
# @USAGE:
# @DESCRIPTION:
# efl's default src_compile
efl_src_compile() {
	if [[ -z "${E_PYTHON}" ]]; then
		emake || efl_die "emake failed"
	else
		distutils_src_compile
	fi

	if has doc "${IUSE}" && use doc; then
		if [[ -x ./gendoc ]]; then
			./gendoc || efl_die "gendoc failed"
		elif [[ -z "${E_PYTHON}" ]]; then
			emake doc || efl_die "emake doc failed"
		fi
	fi
}

# @FUNCTION: efl_src_install
# @USAGE:
# @DESCRIPTION:
# efl's default src_install
efl_src_install() {
	if [[ -z "${E_PYTHON}" ]]; then
		emake install DESTDIR="${D}" || efl_die

		find "${D}" -name '*.la' -delete

		local doc
		for doc in AUTHORS ChangeLog NEWS README TODO ${EDOCS}; do
			[[ -f ${doc} ]] && dodoc ${doc}
		done
	else
		distutils_src_install

		if has examples "${IUSE}" && use examples; then
			insinto /usr/share/doc/${PF}
			doins -r examples
		fi
	fi

	if has doc "${IUSE}" && use doc && [[ -d doc ]]; then
		if [[ -d doc/html ]]; then
			dohtml -r doc/html/*
		else
			dohtml -r doc/*
		fi
	fi

	find "${D}" -name .svn -type d -exec rm -rf '{}' \; 2>/dev/null
}

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install src_test
