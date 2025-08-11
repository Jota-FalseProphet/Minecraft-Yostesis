# Minecraft-Yostesis

Servidor de **Minecraft** basado en **PaperMC**, configurado en un servidor Ubuntu con dominio personalizado.

Este repositorio documenta los pasos y archivos necesarios para instalar y configurar un servidor de Minecraft con PaperMC, usando Java 21 y con gestión de dominio.

---

## Requisitos previos

- Servidor con **Ubuntu 22.04/24.04** o superior.
- **Java 21** instalado.
- Acceso por **SSH** al servidor.
- Un dominio propio (opcional, para acceso con nombre en vez de IP).
- Git instalado para clonar este repositorio.

---

## Instalación

### 1 Instalar dependencias necesarias
```bash
sudo apt update
sudo apt install -y jq curl screen
```

---

### 2 Crear carpeta del servidor
```bash
sudo mkdir -p /opt/minecraft/paper
sudo chown -R "$USER":"$USER" /opt/minecraft
cd /opt/minecraft/paper
```

---

### 3 Descargar PaperMC
```bash
curl -s https://api.papermc.io/v2/projects/paper | jq
# Reemplazar VERSION y BUILD según lo más reciente
curl -o server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/##/downloads/paper-1.21.1-##.jar
```

---

### 4 Primera ejecución
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

### 5 Configurar propiedades del servidor
En `server.properties` puedes cambiar:
- `motd` → Mensaje del servidor
- `server-port` → Puerto (por defecto 25565)
- `online-mode` → true/false (para autenticación de Mojang)
- `level-name` → Nombre del mundo

---

### 6 Ejecutar en segundo plano con Screen
```bash
screen -S minecraft java -Xms2G -Xmx4G -jar server.jar --nogui
```
Para salir de la sesión sin apagar el servidor:
```
CTRL + A + D
```
Para volver:
```bash
screen -r minecraft
```

---

## EXTRA -- Configuración de dominio (opcional)
Si quieres usar un dominio como `mc.tudominio.com`, añade un registro **A** en el panel DNS de tu dominio apuntando a la IP pública de tu servidor.  

Ejemplo:
| Tipo | Nombre | Valor (IP)      | TTL  |
|------|--------|-----------------|------|
| A    | mc     | 123.123.123.123 | 3600 |

---

## Archivos del repositorio

- `server.properties` → Configuración principal del servidor.
- `README.md` → Esta guía.
- Otros archivos generados por PaperMC.

---

## Ejemplo de uso
1. Clona el repositorio:
```bash
git clone https://github.com/Jota-FalseProphet/Minecraft-Yostesis.git
cd Minecraft-Yostesis
```
2. Sube los archivos al servidor.
3. Inicia el servidor con:
```bash
screen -S minecraft java -Xms2G -Xmx4G -jar server.jar --nogui
```

---

## Licencia
Este proyecto es de uso libre para fines educativos y de prueba. No incluye archivos con propiedad intelectual de Mojang. 
