# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit webapp eutils perl-module

DESCRIPTION="EST assembly+annotation: a perl-based analysis pipeline including php-based web interface"
HOMEPAGE="http://cichlid.umd.edu/est2uni/download.php"
SRC_URI="http://cichlid.umd.edu/est2uni/est2uni_0.27.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/lucy
	sci-biology/cap3-bin
	sci-biology/estscan
	sci-biology/hmmer
	sci-biology/phred
	sci-biology/seqclean
	sci-biology/repeatmasker
	sci-biology/tgicl
	sci-biology/ncbi-tools
	sci-biology/bioperl
	sci-biology/exonerate
	perl-gcpan/go-perl
	www-servers/apache
	dev-db/mysql
	<dev-lang/php-5.3"

S="${WORKDIR}"/est2uni

src_compile(){
	"$(tc-getCC)" external_software/sputnik/sputnik.c -o external_software/sputnik/sputnik
}

src_install(){
	dobin external_software/sputnik/sputnik || die
	mkdir -p "${D}"/opt/est2uni || die
	mv perl "${D}"/opt/est2uni || die
	doenvd "${FILESDIR}"/est2uni || die

	mkdir -p "${D}"/usr/share/webapps/"${PN}"/"${PV}"/htdocs
	cp -r php/* "${D}"/usr/share/webapps/"${PN}"/"${PV}"/htdocs || die

	mkdir -p "${D}"/usr/share/"${PN}" || die
	mv test_data "${D}"/usr/share/"${PN}" || die
	perl-module_src_install || die

	webapp_src_preinst
	webapp_postinst_txt en "${S}"/README
	webapp_src_install

	einfo "Please follow the pipeline installation and web configuration docs at"
	einfo "http://cichlid.umd.edu/est2uni/install.php"
	einfo "BEWARE the software is not maintained anymore by upstream but I do not"
	einfo "know any better available (replaced by ngs_backbone which has no web"
	einfo "interface yet). Consider using latest svn checkout instead of 0.27"
	einfo "release from 2007 or so."
	einfo "Possible fixes and stuff to read:"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-January/000069.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-March/000103.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-March/000101.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-April/000135.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-April/000131.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-February/000070.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-April/000129.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-April/000128.html"
	einfo "https://listas.upv.es/pipermail/est2uni/2008-May/000139.html"
	einfo ""
	einfo "Current code is at http://bioinf.comav.upv.es/git///?p=est2uni;a=summary"
}

pkg_postinst(){
	webapp_pkg_postinst || die "webapp_pkg_postinst failed"
}
