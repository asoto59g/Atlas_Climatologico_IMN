# 🗺️ Atlas Climatológico de Costa Rica - Fixes & Portabilidad

Este repositorio contiene los ajustes necesarios para ejecutar la versión legacy (año 2005) del **Atlas Climatológico de Costa Rica** en sistemas operativos y entornos modernos (como Windows 10/11 y OneDrive).

Actualmente en el siguiente vinculo:

https://www.imn.ac.cr/atlas-climatologico

Originalmente, esta aplicación fue diseñada como un proyector interactivo de Flash Player 8 para ser distribuido y ejecutado de manera clásica desde la raíz de un disco (CD/DVD) a través de un archivo `autorun.inf`.

## ⚠️ Problema Inicial

Al guardar y tratar de ejecutar los archivos del CD dentro de un entorno de almacenamiento moderno, el software presentaba un bug crítico: pantalla en blanco y la inhabilitación del botón «Saltar Intro», dejándolo congelado. Estos problemas eran provocados por tres factores:

1. **Incompatibilidad con rutas web y especiales:** El motor antiguo de Flash Player (2005) falla internamente al intentar referenciar archivos o sus XML de datos de configuración si la ruta absoluta contiene caracteres acentuados (por ejemplo, *Geomática*).
2. **Conflictos con la Nube (OneDrive):** Flash no posee las interfaces para leer el sistema de *Archivos a petición* (Files on Demand) de OneDrive. Si un archivo como el mapa o un `mp3` está marcado como remoto, la aplicación se congela esperando recibirlo localmente.
3. **Restricciones de Sandbox Local y Atributos:** Al respaldar la aplicación desde un medio óptico (CD), en ocasiones los archivos adoptaban propiedades de Solo Lectura. Además, las reglas del motor bloqueaban los scripts locales (*Local File Sandbox Restriction*).

## 🛠️ Soluciones y Cambios Implementados

### 1. Script de Arranque Portátil (`Iniciar_Atlas.bat`)
Se sustituyó por completo la utilización del obsoleto `autorun.inf` con un script `.bat` inteligente, transformando el arranque en "Un clic y listo" (*Standalone*).

### 2. Aislamiento de Entorno (Bypass OneDrive)
El nuevo script de arranque incorpora una "malla de seguridad" que prepara el terreno cada vez que se invoca el programa:
- **Bypass de OneDrive y tildes:** Copia de manera silenciosa rápida el árbol de archivos hacia la raíz predeterminada e inmune: `C:\Atlas_CR_Directo`. Así saca directamente la aplicación del ecosistema de la nube y anula los posibles bugs por caracteres no soportados y rutas excesivamente largas.
- **Limpieza de Atributos Cautivos:** Se agregó un flag que destituye cualquier archivo estancado como "Solo Lectura" (`attrib -R`).
- **Integración con FlashPlayerTrust:** Automatiza la adición y limpieza de pautas del registro interno creando el archivo en `%APPDATA%\Macromedia\Flash Player\#Security\FlashPlayerTrust`, inhabilitando filtros locales perjudiciales para los archivos.

### 3. Bypass de Carga de Media (`atlasInformation.xml`)
Se inspeccionó la raíz del `atlasInformation.xml` y se detectó el enganche al reproductor de la banda sonora inicial. Muchos codecs obsoletos provocan que Flash se asfixie tratando de utilizar componentes del sistema caídos, lo que estropeaba el fotograma de intro e inhabilitaba el botón de siguiente fotograma.

**Cambio aplicado:**
```xml
<!-- Código Legacy -->
<musicPlayer introTrackUrl="musica/Intro.mp3" autoPlay="true" loopList="true" delayIntro="13">

<!-- Código Moderno (Ajustado) -->
<musicPlayer introTrackUrl="" autoPlay="false" loopList="false" delayIntro="0">
```

## 🚀 Instrucciones de Uso (Usuario Final)

Para abrir tu Atlas exitosamente a partir de hoy, en cualquier versión o carpeta de Windows:

1. Conservar los archivos sin importar su directorio principal.
2. Dar doble clic en **`Iniciar_Atlas.bat`**.
3. *Listo.* Automáticamente se levantará el visualizador interactivo brincando al instante las zonas incompatibles.
