FROM archlinux/archlinux AS one-stage

RUN useradd -m archlinux \
	&& passwd -d archlinux \
	&& pacman -Syu --noconfirm \
	&& pacman -S --noconfirm binutils debugedit fakeroot gcc git jq make sudo \
	&& echo "archlinux ALL=(ALL) ALL" \
	| tee /etc/sudoers.d/archlinux

RUN git clone https://github.com/mvtab/aurx \
	&& cp ./aurx/aurx /usr/bin/aurx \
	&& echo 'source <(aurx completion bash)' \
	| tee -a /home/archlinux/.bashrc \
	&& rm -rf ./aurx

WORKDIR /home/archlinux
USER archlinux

CMD ["aurx","--help"]

