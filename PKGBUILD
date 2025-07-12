# Maintainer: mvtab <mvtabilitas@protonmail.com>
pkgname="aurx"
pkgver="1.0.0"
pkgrel=1
pkgdesc="A simple bash script for easily managing AUR installs."
arch=("x86_64")
url="https://github.com/mvtab/aurx"
license=("GPL-3.0-only")
depends=("curl>=7.68.0" "git" "grep" "jq" "sed")
source=("aurx")
sha256sums=("d527e1ed90e7b5132e038ef1c9ebd176c19675ca948256ef896558e4436ba6a6")

package() {
	install -Dm755 "${srcdir}/aurx" "${pkgdir}/usr/bin/aurx"
	echo "[i] For bash completion you can: 'source <(aurx completion bash)'"
}

