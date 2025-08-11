# Minecraft-Yostesis

Servidor de **Minecraft** basado en **PaperMC**, configurado en un servidor Ubuntu con dominio personalizado.

Este repositorio documenta los pasos y archivos necesarios para instalar y configurar un servidor de Minecraft con PaperMC, usando Java 21, optimizaciones de arranque y ejecución en segundo plano con **systemd** + **screen**.

---

## Requisitos previos

- Servidor con **Ubuntu 22.04/24.04** o superior.
- **Java 21** instalado.
- Acceso por **SSH** al servidor.
- Un dominio propio (opcional, para acceso con nombre en vez de IP).
- Git instalado para clonar este repositorio.

---

## Instalación

### 1) Instalar dependencias necesarias
```bash
sudo apt update
sudo apt install -y jq curl screen
```

---

### 2) Crear carpeta del servidor
```bash
sudo mkdir -p /opt/minecraft/paper
sudo chown -R "$USER":"$USER" /opt/minecraft
cd /opt/minecraft/paper
```

---

### 3) Descargar PaperMC
```bash
curl -s https://api.papermc.io/v2/projects/paper | jq
# Reemplazar VERSION y BUILD según lo más reciente
curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/##/downloads/paper-1.21.1-##.jar
```

---

### 4) Primera ejecución
```bash
java -Xms2G -Xmx4G -jar server.jar --nogui
```
Esto generará los archivos de configuración iniciales.  
Edita el archivo `eula.txt` y acepta la licencia de Minecraft:

```bash
nano eula.txt
# Cambiar eula=false por eula=true
```

---

### 5) Configurar propiedades del servidor
En `server.properties` puedes cambiar:
- `motd` → Mensaje del servidor
- `server-port` → Puerto (por defecto 25565)
- `online-mode` → true/false (para autenticación de Mojang)
- `level-name` → Nombre del mundo

---

## Ejecución en segundo plano con systemd + screen

Creamos un servicio **systemd** para manejar el servidor con `screen` y parámetros de optimización.

1. Crear archivo de servicio:
```bash
sudo nano /etc/systemd/system/minecraft.service
```

2. Pegar el contenido:
```ini
[Unit]
Description=Minecraft Paper Server (con screen)
After=network.target
Wants=network-online.target

[Service]
WorkingDirectory=/opt/minecraft/paper
User=yotesis
Group=yotesis

Environment="JAVA_ARGS=-Xms4G -Xmx6G -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:+ParallelRefProcEnabled -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
Environment="SCREENDIR=/opt/minecraft/.screen"

ExecStartPre=/bin/mkdir -p /opt/minecraft/.screen
ExecStartPre=/bin/chown -R yotesis:yotesis /opt/minecraft/.screen
ExecStart=/usr/bin/screen -DmS minecraft /usr/bin/java $JAVA_ARGS -jar server.jar --nogui
ExecStop=/usr/bin/screen -S minecraft -p 0 -X stuff "stop$(printf \\r)"
ExecStop=/bin/sleep 2
ExecStop=/usr/bin/screen -S minecraft -X quit

Restart=on-failure
RestartSec=10
SuccessExitStatus=0 143
Nice=5

[Install]
WantedBy=multi-user.target
```

3. Activar el servicio:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now minecraft
```

4. Ver estado:
```bash
sudo systemctl status minecraft --no-pager
```

5. Adjuntarte a la consola del server:
```bash
sudo -u yotesis env SCREENDIR=/opt/minecraft/.screen screen -r minecraft
```
Para salir sin parar el server: `CTRL + A`, luego `D`.

---

## EXTRA — Configuración de dominio (opcional)
Si quieres usar un dominio como `mc.tudominio.com`, añade un registro **A** en el panel DNS de tu dominio apuntando a la IP pública de tu servidor.

Ejemplo:
| Tipo | Nombre | Valor (IP)        | TTL  |
|------|--------|-------------------|------|
| A    | mc     | 123.123.123.123   | 3600 |

---

## Archivos del repositorio

- `server.properties` → Configuración principal del servidor.
- `minecraft.service` → Servicio systemd para ejecución en segundo plano.
- `README.md` → Esta guía.

---

## Ejemplo rápido de uso
```bash
git clone https://github.com/Jota-FalseProphet/Minecraft-Yostesis.git
cd Minecraft-Yostesis
sudo cp minecraft.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now minecraft
```

---

## Licencia
Este proyecto es de uso libre para fines educativos y de prueba. No incluye archivos con propiedad intelectual de Mojang.
