FROM --platform=linux/amd64 node:20-bookworm-slim
LABEL maintainer="Takashi Makimoto <mackie@beehive-dev.com>"

SHELL [ "/bin/bash", "-c" ]
WORKDIR /root

ARG BAT_VER=0.24.0
ARG DELTA_VER=0.17.0
ARG EZA_VER=0.18.13
ARG FD_VER=9.0.0
ARG FZF_VER=0.51.0
ARG GHQ_VER=1.6.1
ARG GITHUB_CLI_VER=2.49.0
ARG HEXYL_VER=0.14.0
ARG LAZYGIT_VER=0.41.0
ARG NEOVIM_VER=0.9.5
ARG RIPGREP_VER=14.1.0
ARG STARSHIP_VER=1.18.2

ENV \
  TERM=xterm-256color \
  PATH="/root/.local/bin:/opt/nvim-linux64/bin:$PATH" \
  LANGUAGE=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8

COPY "${PWD}/conf.d/bat/" /root/.config/bat/
COPY "${PWD}/conf.d/btop/" /root/.config/btop/
COPY "${PWD}/conf.d/lazygit/" /root/.config/lazygit/
COPY "${PWD}/conf.d/nvim/" /root/.config/nvim/
COPY "${PWD}/conf.d/zsh/" /root/.config/zsh/
COPY "${PWD}/conf.d/.zshenv" /root/.zshenv
COPY "${PWD}/bin/*" /root/.local/bin/

RUN \
  mkdir -p .cache/zsh .local/share/zsh .local/state Projects && \
  apt-get -y update && \
  DEBIAN_FRONTEND=nointeractive apt-get -y install \
  btop \
  curl \
  file \
  gcc \
  git \
  git-lfs \
  gnupg \
  jq \
  locales \
  make \
  openssl \
  rsync \
  tree \
  unzip \
  wget \
  zsh && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen en_US.UTF-8 && \
  DEBIAN_FRONTEND=nointeractive dpkg-reconfigure locales && \
  /usr/sbin/update-locale LANG=en_US.UTF-8 && \
  curl -L \
  -O https://github.com/sharkdp/bat/releases/download/v${BAT_VER}/bat-musl_${BAT_VER}_amd64.deb \
  -O https://github.com/dandavison/delta/releases/download/${DELTA_VER}/git-delta-musl_${DELTA_VER}_amd64.deb \
  -O https://github.com/eza-community/eza/releases/download/v${EZA_VER}/eza_x86_64-unknown-linux-musl.tar.gz \
  -O https://github.com/sharkdp/fd/releases/download/v${FD_VER}/fd-musl_${FD_VER}_amd64.deb \
  -O https://github.com/junegunn/fzf/releases/download/${FZF_VER}/fzf-${FZF_VER}-linux_amd64.tar.gz \
  -O https://github.com/x-motemen/ghq/releases/download/v${GHQ_VER}/ghq_linux_amd64.zip \
  -O https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VER}/gh_${GITHUB_CLI_VER}_linux_amd64.deb \
  -O https://github.com/sharkdp/hexyl/releases/download/v${HEXYL_VER}/hexyl-musl_${HEXYL_VER}_amd64.deb \
  -O https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz \
  -O https://github.com/neovim/neovim/releases/download/v${NEOVIM_VER}/nvim-linux64.tar.gz \
  -O https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VER}/ripgrep-${RIPGREP_VER}-x86_64-unknown-linux-musl.tar.gz \
  -O https://github.com/starship/starship/releases/download/v${STARSHIP_VER}/starship-x86_64-unknown-linux-musl.tar.gz \
  -o /usr/local/bin/fzf-tmux https://raw.githubusercontent.com/junegunn/fzf/master/bin/fzf-tmux && \
  dpkg -i \
  bat-musl_${BAT_VER}_amd64.deb \
  git-delta-musl_${DELTA_VER}_amd64.deb \
  fd-musl_${FD_VER}_amd64.deb \
  gh_${GITHUB_CLI_VER}_linux_amd64.deb \
  hexyl-musl_${HEXYL_VER}_amd64.deb && \
  unzip -j -d /usr/local/bin ghq_linux_amd64.zip ghq_linux_amd64/ghq && \
  tar xzvf eza_x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin && \
  tar xzvf fzf-${FZF_VER}-linux_amd64.tar.gz -C /usr/local/bin && \
  tar xzvf lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz -O lazygit > /usr/local/bin/lazygit && \
  tar xzvf nvim-linux64.tar.gz -C /opt && \
  tar xzvf ripgrep-${RIPGREP_VER}-x86_64-unknown-linux-musl.tar.gz -O ripgrep-${RIPGREP_VER}-x86_64-unknown-linux-musl/rg > /usr/local/bin/rg && \
  tar xzvf starship-x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin && \
  rm -f *.deb *.tar.gz *.zip && \
  chown root:root /usr/local/bin/* && \
  chmod +x /usr/local/bin/* && \
  curl https://mise.run | sh

RUN \
  chown -R root:root /root/.config && \
  bat cache --build && \
  nvim --headless "+Lazy! sync" +qa && \
  curl -fsSL --create-dirs -o /root/.local/share/zsh/zim/zimfw.zsh https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh

SHELL [ "/usr/bin/zsh", "-c" ]
ENV ZIM_HOME=/root/.local/share/zsh/zim

RUN \
  source "${ZIM_HOME}/zimfw.zsh" init -q && \
  source "${ZIM_HOME}/init.zsh"

WORKDIR /root/Projects

CMD [ "/usr/bin/zsh", "--login" ]
