# My CUI based Development Environment on Docker

Docker 上で動作する、自分用にカスタマイズした CUI ベースの開発環境一式です。普段は TypeScript を使うことが多く、その開発が出来れば十分なので、最低限の構成なっています。必要であれば [mise](https://github.com/jdx/mise) をインストールしてあるので、都度インストールして使用することにしています。

## 起動方法

```sh
docker pull mackie376/cde:latest
docker run -it --rm -e TZ=Asia/Tokyo cde:latest
```

## インストールされているパッケージ

- btop
- curl
- file
- gcc
- git
- git-lfs
- gnupg
- jq
- locales
- make
- openssl
- rsync
- tree
- unzip
- wget
- zsh

## 手動でインストールしているツール

- bat@0.24.0
- delta@0.17.0
- eza@0.18.13
- fd@9.0.0
- fzf@0.50.0
- ghq@1.6.1
- gh@2.48.0
- hexyl@0.14.0
- lazygit@0.41.0
- neovim@0.9.5
- ripgrep@14.1.0
- starship@1.18.2
- mise
