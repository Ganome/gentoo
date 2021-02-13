# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2 toolchain-funcs

DESCRIPTION="A collection of special mathematical functions"
HOMEPAGE="https://julialang.org"
SRC_URI="https://github.com/JuliaLang/openspecfun/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="sci-libs/openlibm"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-static-libs.patch )

src_prepare() {
	default
	sed -i "s:/lib:/$(get_libdir):" Make.inc || die
}

src_compile() {
	emake prefix="${EPREFIX}/usr" USE_OPENLIBM=1 FC="$(tc-getFC)"
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" install
	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
