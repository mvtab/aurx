FROM archlinux/archlinux AS one-stage
RUN useradd -m archlinux \
	&& passwd -d archlinux \
	&& pacman -Syu --noconfirm \
	&& pacman -S --noconfirm binutils debugedit fakeroot gcc git jq make sudo \
	&& echo "archlinux ALL=(ALL) NOPASSWD: ALL" \
	| tee /etc/sudoers.d/archlinux

USER archlinux
WORKDIR /home/archlinux

RUN git clone https://github.com/mvtab/aurx \
	&& cd ./aurx \
	&& sudo cp ./aurx /usr/bin/aurx \
	&& echo 'source <(aurx completion bash --executable-name aurx)' \
	| tee -a /home/archlinux/.bashrc

CMD ["aurx","-help"]

