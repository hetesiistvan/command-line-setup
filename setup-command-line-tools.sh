#!/bin/bash

set -euo pipefail

start_directory=

main() {
	start_directory=$(pwd)

	setup_bash
	setup_vim
	setup_nvim
	setup_tmux

	cat <<- EOF
	################################################################################
	#### Manual steps, please read those instructions carefully!
	################################################################################
	EOF

	print_tmux_manual_instructions
}

setup_bash() {
	cat <<- EOF
	################################################################################
	#### Setting up common Bash settings
	################################################################################
	EOF

	cp bash_common_settings ~/

	local source_instruction source_segment
	source_instruction=". ~/bash_common_settings"
	source_segment="\n## Sourcing commonly used Bash settings\n${source_instruction}\n"

	if ! grep -q "${source_instruction}" ~/.bashrc; then
		echo -e "${source_segment}" >> ~/.bashrc
	fi

	if [[ $(uname -s) == "Darwin" ]]; then
		if ! grep -q "${source_instruction}" ~/.bash_profile; then
			echo -e "${source_segment}" >> ~/.bash_profile
		fi
	fi

	echo -e "#### Done ✅\n"
}

setup_vim() {
	cat <<- EOF
	################################################################################
	#### Setting up vim
	################################################################################
	EOF

	# Placing config to it's place
	cp ./.vimrc ~/.vimrc
	mkdir -p ~/.vim

	# Pathogen installation
	mkdir -p ~/.vim/autoload
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

	# Fetching plugin repositories
	git_clone_or_update ~/.vim/bundle/vim-colors-solarized https://github.com/altercation/vim-colors-solarized.git
	git_clone_or_update ~/.vim/pack/airblade/start/vim-gutter https://github.com/airblade/vim-gitgutter.git
	git_clone_or_update ~/.vim/pack/git-plugins/start/ale https://github.com/dense-analysis/ale.git
	git_clone_or_update ~/.vim/pack/dist/start/vim-airline https://github.com/vim-airline/vim-airline

	# Plugin initialisation
	vim -u NONE -c "helptags ~/.vim/pack/airblade/start/vim-gitgutter/doc" -c q
	vim -u NONE -c "helptags ~/.vim/pack/dist/start/vim-airline/doc" -c q

	echo -e "#### Done ✅\n"
}

setup_nvim() {
	cat <<- EOF
	################################################################################
	#### Setting up nvim
	################################################################################
	EOF

	# Setting up configuration folder
	local nvim_config_folder
	nvim_config_folder="~/.config/nvim"
	mkdir -p "${nvim_config_folder}"

	# Placing nvim configuration to the config folder
	cp "${start_directory}/init.vim" "${nvim_config_folder}/"

	# Installing vim-plug
	curl -sfLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
               https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

	# Installing JetBrains Mono Nerd font
	if [[ $(uname -s) == "Darwin" ]]; then
		brew tap homebrew/cask-fonts
		brew install --cask font-jetbrains-mono
		brew install --cask font-jetbrains-mono-nerd-font
	else
		echo "Here goes the Linux part"
	fi

	nvim -u NONE -c "PlugInstall" -c "helptags vim-gitgutter/doc" -c q

	echo -e "#### Done ✅\n"
}

setup_tmux() {
	cat <<- EOF
	################################################################################
	#### Setting up tmux
	################################################################################
	EOF

	cd "${start_directory}"

	# Placing config to it's place
	cp ./.tmux.conf ~/.tmux.conf
	mkdir -p ~/.tmux

	# Ensuring that the plugins directory is located at the right place
	local mount_line tmux_home_plugins
	tmux_home_plugins=~/.tmux/plugins
	if mount_line=$(mount | grep -E '/home' 2>/dev/null); then
		if [[ ${mount_line} =~ noexec ]]; then
			# Plugin directory needs to be reside outside the home directory since plugins can not be executed from there
			local tmux_plugin_directory
			tmux_plugin_directory=/opt/devtools/${USER}/tmux/plugins

			if [[ ! -d "${tmux_plugin_directory}" ]]; then
				sudo mkdir -p "${tmux_plugin_directory}"
				sudo chown -R "${USER}":users "$(dirname "${tmux_plugin_directory}")"
			fi

			if [[ -d "${tmux_home_plugins}" && ! -h "${tmux_home_plugins}" ]]; then
				# Relocate already existing stuff (just for the case if something was already existing)
				if [[ -n $(ls -1 "${tmux_home_plugins}") ]]; then
					mv "${tmux_home_plugins}"/* "${tmux_plugin_directory}/"
				fi

				rmdir "${tmux_home_plugins}"
			fi

			if [[ ! -h "${tmux_home_plugins}" ]]; then
				(cd ~/.tmux; ln -s "${tmux_plugin_directory}" plugins)
			fi
		else
			if [[ ! -d "${tmux_home_plugins}" ]]; then
				mkdir -p "${tmux_home_plugins}"
			fi
		fi
	fi

	# Fetching plugin repositories
	git_clone_or_update "${tmux_home_plugins}/tpm" https://github.com/tmux-plugins/tpm

	echo -e "#### Done ✅\n"
}

print_tmux_manual_instructions() {
	cat <<- EOF
	# type this in terminal if tmux is already running
	tmux source ~/.tmux.conf
	# install the plugins:
	# - press prefix + I (capital i, as in Install) to fetch the plugin.
	EOF
}

git_clone_or_update() {
	local target_directory git_repository
	target_directory="${1:-}"
	git_repository="${2:-}"

	if [[ -d "${target_directory}" ]]; then
		cd "${target_directory}"
		git pull
	else
		git clone "${git_repository}" "${target_directory}"
	fi
}

main
