# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils multilib

MY_PN="opengltk"
MY_P="${MY_PN}-${PV}"
MGL_EXTRALIBS="${EPREFIX}/usr/$(get_libdir)"
MGL_EXTRAINCLUDE="${EPREFIX}/usr/include"

DESCRIPTION="mgltools plugin -- opengltk"
HOMEPAGE="http://mgltools.scripps.edu"
#SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/mgltools_source_${PV}.tar.gz"

LICENSE="MGLTOOLS MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/tk
	virtual/opengl
	virtual/opengl
	dev-python/numpy"
DEPEND="${RDEPEND}
	dev-lang/swig"

RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-*"
S="${WORKDIR}"/${MY_P}

src_unpack() {
	tcl_ver="$(best_version dev-lang/tcl | cut -d- -f3 | cut -d. -f1,2)"

	tar xzpf "${DISTDIR}"/${A} mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz
	tar xzpf mgltools_source_${PV}/MGLPACKS/${MY_P}.tar.gz
}

src_prepare() {
	find "${S}" -name CVS -type d -exec rm -rf '{}' \; >& /dev/null
	find "${S}" -name LICENSE -type f -exec rm -f '{}' \; >& /dev/null

	sed  \
		-e 's:^.*CVS:#&1:g' \
		-e 's:^.*LICENSE:#&1:g' \
		-i "${S}"/MANIFEST.in

	sed "s:8.4:${tcl_ver}:g" -i setup.py || die
	distutils_src_prepare
}

pkg_postinst() {
	python_mod_optimize ${MY_PN}
}

pkg_postrm() {
	python_mod_cleanup ${MY_PN}
}
