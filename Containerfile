FROM archlinux/archlinux AS one-stage

RUN useradd -m archlinux \
	&& passwd -d archlinux \
	&& pacman -Syu --noconfirm \
	&& pacman -S --noconfirm bash-completion binutils debugedit fakeroot \
		gcc git jq make sudo \
	&& echo "archlinux ALL=(ALL) ALL" \
	| tee /etc/sudoers.d/archlinux

WORKDIR /home/archlinux
USER archlinux

RUN git clone https://github.com/mvtab/aurx \
	&& pushd aurx \
	&& makepkg --noconfirm -sirc \
	&& popd \
	&& rm -rf ./aurx \
	&& echo 'source <(aurx completion bash)' \
		| tee -a /home/archlinux/.bashrc

ENV AURX_TMP_PATH="/home/archlinux/tmp"

CMD ["aurx","--help"]
