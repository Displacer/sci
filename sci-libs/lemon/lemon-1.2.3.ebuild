# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="C++ template STATIC library of efficient implementations of common data structures and algorithms"
HOMEPAGE="https://lemon.cs.elte.hu/trac/lemon/"
SRC_URI="http://lemon.cs.elte.hu/pub/sources/lemon-"${PV}".tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="
		sci-mathematics/glpk"
DEPEND="${RDEPEND}
	doc? (
		app-text/ghostscript-gpl
		dev-lang/python )
	test? ( dev-util/valgrind )"

src_prepare(){
	if use test; then
		MYOPTS="--enable-valgrind"
	else
		MYOPTS=""
	fi
	econf ${MYOPTS}
}

# a dynamic library can be built using
# cmake -DBUILD_SHARED_LIBS=TRUE ..
