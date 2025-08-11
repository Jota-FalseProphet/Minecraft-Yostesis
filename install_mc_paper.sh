#!/bin/bash
#
# Script de instalación y configuración básica de un servidor de Minecraft Paper
# Autor: Jota (Jota-FalseProphet)
# Descripción:
#   Este script automatiza la descarga de la última versión de Paper,
#   la aceptación del EULA, y deja el servidor listo para arrancar.
#
# Uso:
#   chmod +x install_mc_paper.sh
#   ./install_mc_paper.sh

# Configuración inicial
MC_DIR="/opt/minecraft/paper"
MEM_MIN="2G"
MEM_MAX="4G"

# Crear carpeta de instalación
sudo mkdir -p "$MC_DIR"
sudo chown -R "$USER":"$USER" "$MC_DIR"
cd "$MC_DIR" || exit 1

# Instalar dependencias necesarias
sudo apt update
sudo apt install -y jq curl screen

# Descargar Paper
echo "Obteniendo la última versión de Paper..."
LATEST_VER=$(curl -s https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/$LATEST_VER | jq -r '.builds[-1]')
echo "Descargando Paper $LATEST_VER build $LATEST_BUILD..."
curl -L -o server.jar \
  https://api.papermc.io/v2/projects/paper/versions/$LATEST_VER/builds/$LATEST_BUILD/downloads/paper-$LATEST_VER-$LATEST_BUILD.jar

# Aceptar EULA
echo "Aceptando EULA..."
echo "eula=true" > eula.txt

# Arranque inicial
echo "Arrancando servidor por primera vez..."
screen -S mc java -Xms$MEM_MIN -Xmx$MEM_MAX -jar server.jar --nogui

echo "Servidor Paper instalado en $MC_DIR"
echo "Usa 'screen -r mc' para volver a la consola si cierras la sesión."
