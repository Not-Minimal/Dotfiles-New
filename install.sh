#!/bin/bash

<<<<<<< HEAD
# Respaldadno la configuración actual de Neovim
mv ~/.config/nvim ~/.config/nvim_backup_$(date +%s)

=======
>>>>>>> 215a13f (Add zsh-autosuggestions as a submodule)
echo "Creando symlink para Neovim (LazyVim)..."

# Borra configuración actual si existe
rm -rf ~/.config/nvim

# Crea symlink desde el repo
ln -s ~/Development/Dotfiles/nvim ~/.config/nvim

echo "¡Listo! Ejecuta nvim para que LazyVim se encargue de instalar plugins."
