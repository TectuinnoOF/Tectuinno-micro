# Tectuinno‑micro (Monociclo v5)

**Descripción breve**

Tectuinno‑micro es la implementación monociclo del microcontrolador RISC‑V diseñada para la placa **Gowin Tang Nano 9K**. Este repositorio contiene los fuentes en SystemVerilog, el proyecto Gowin preparado para síntesis y el paquete listo para programar la FPGA. El propósito es educativo y de prototipado rápido: exponer un core RISC‑V junto con periféricos básicos (LEDs, switches, SPI, UART y memoria de datos).

---

## Contenido del repositorio

* `project/` — archivos del proyecto Gowin (.gprj y fuentes HDL).
* `src/` — módulos SystemVerilog (incluye `top.sv`, `decod_4_16.sv`, `riscvsingle.sv`, `imem.sv`, `dmem.sv`, periféricos).
* `examples/` — ejemplos en ensamblador para pruebas (p. ej. `sw_to_leds.asm`, `led_sequence.asm`).
* `bitstream/` — archivos generados (`.gar`, `.fs`) para programación (si aplica).
* `docs/` — documentación auxiliar (pinout, notas de diseño).
* `LICENSE` — licencia del proyecto.

---

## Requisitos

* Gowin IDE (compatible con la familia GW1NR, Tang Nano 9K).
* Placa Gowin Tang Nano 9K (GW1NR‑9C / GW1NR‑9K).
* Cable USB‑JTAG o acceso a programador WiFi si se utiliza el programador inalámbrico del IDE.
* `programmer_cli` (opcional) — incluida en la instalación de Gowin IDE para programación por terminal.

---

## Mapeo de periféricos

| Dirección     | Nombre                    |Uso                                                              |
| ------------: | --------------------------|-----------------------------------------------------------------|
| `0x1000_0000` | reg_led rl1 (p10)         |Permite enviar datos a los pines de un p10                       |
| `0x2000_0000` | SPI spi_0 (STATUS)        |Indica el estado del periférico                                  |
| `0x2000_0001` | SPI spi_0 (SHIFT)         |Envía y recibe datos a través del módulo                         |
| `0x2000_0002` | SPI spi_0 (FREQ)          |Ajusta la velocidad de comunicación                              |
| `0x3000_0000` | dmem dmem(RAM de datos)   |Guarda variables y datos del programa                            |
| `0x4000_0000` | reg_in reg_lec1 (entradas)|Accede a la lectura de datos a partir de botones, switches, etc  |
| `0x5000_0000` | uart_rx ur0 (UART RX)     |Corresponde al buffer de recepción del módulo UART               |
| `0x6000_0000` | reg_led rl2(semáforo)     |Registro especializado para manejar señales luminosas            |
| `0x7000_0000` | reg_led rl3 (m_cd)        |Instancia que permite controlar un motor de corriente directa    |
| `0x8000_0000` | reg_led rl4 (m_pasos)     |Concede operar un motor a pasos                                  |
| `0x9000_0000` | reg_led rl5 (m_servo)     |Controla un servo motor                                          |
| `0xA000_0000` | reg_led rl6 (fpga_leds)   |Activa los leds internos del Tang Nano 9K FPGA                   |

> El decodificador `decod_4_16` toma `DataAdr[31:28]` y genera la señal `cs` de selección de periféricos en `top.sv`.
> Los bits bajos `DataAdr[1:0]` se utilizan dentro de cada periférico para acceder a sus subregistros, diferenciando la función específica que se desea ejecutar (por ejemplo, STATUS, SHIFT o FREQ en el SPI).

---

## Ejemplos de uso rápidos

### Espejo: switches → LEDs

```asm
# Mirror switches to LEDs
# Comments in English for code clarity
ini:
    lui   x2, 0x40000     # x2 = 0x4000_0000 (input port base)
    lui   x3, 0x10000     # x3 = 0x1000_0000 (LED port base)
loop:
    lw    x9, 0(x2)       # read switches
    sw    x9, 0(x3)       # write to LEDs
    jal   x0, loop        # infinite loop
```

Ajusta ejemplos en `examples/` según necesidad (retardos, máscaras, secuencias).

---

## Programación de la FPGA

### Opción A — Desde Gowin IDE (GUI)

1. Abre Gowin IDE.
2. Carga el proyecto (`*.gprj`) o selecciona el archivo `.gar` / `.fs`.
3. Conecta la Tang Nano mediante JTAG/USB.
4. Usa el panel *Programmer* para seleccionar el archivo y ejecutar la programación.

### Opción B — Por terminal (CLI)

Primero, accede a la carpeta donde está instalado Gowin IDE y navega a:

```
.../gowin/programmer/bin/
```

Abre una terminal desde esa ubicación y ejecuta (ejemplo con `sudo`):

```bash
sudo ./programmer_cli --device GW1NR-9C --run 5 --fsFile [ruta del proyecto para el archivo .fs] --cable-index 1
```

* Reemplaza `[ruta del proyecto para el archivo .fs]` por la ruta absoluta del `.fs` o `.gar` a programar.
* Ajusta `--device` si tu placa tiene otro identificador.
* `--run 5` y `--cable-index 1` son valores de ejemplo; modifica según tu flujo y enumeración de cables.

---

## Integración con Tectuinno‑IDE

El IDE de Tectuinno incluye utilidades para editar ensamblador, abrir/guardar `.asm` y programar por WiFi (si el hardware lo soporta). Repositorio del IDE: [https://github.com/TectuinnoOF/Tectuinno-IDE](https://github.com/TectuinnoOF/Tectuinno-IDE)

---

## Notas de diseño

* El core es monociclo para facilitar su comprensión y trazabilidad.
* No se pretende optimización de rendimiento; el objetivo es didáctico y de prototipado.
* Cambios en `decod_4_16` o en el mapeo de direcciones requieren sincronización con ejemplos y documentación.

---

## Contribuciones

1. Haz fork del repositorio.
2. Crea rama (`feature/...` o `fix/...`) y sube commits claros.
3. Abre Pull Request con la descripción del cambio, pruebas y pasos para reproducir.

---

## Contacto

Abre *issues* en el repo para bugs, mejoras o preguntas técnicas. Incluye versión de Gowin IDE y logs de programación cuando reportes problemas.
