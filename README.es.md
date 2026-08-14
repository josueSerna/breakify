<h1 align="start">Breakify</h1>

<p align="start">
  <strong>Un toolkit de layout responsivo para Flutter.</strong>
</p>

<p align="start">
  Construye interfaces responsivas usando breakpoints, valores responsivos,
  interpolación fluida y widgets adaptativos.
</p>

<p align="center">
  <a href="https://pub.dev/packages/breakify">
    <img src="https://img.shields.io/pub/v/breakify.svg" alt="Pub Version">
  </a>
  <a href="https://github.com/josueSerna/breakify">
    <img src="https://img.shields.io/github/stars/josueSerna/breakify?style=social" alt="GitHub Stars">
  </a>
  <a href="https://pub.dev/packages/breakify">
    <img src="https://img.shields.io/pub/likes/breakify" alt="Pub Likes">
  </a>
  <a href="https://pub.dev/packages/breakify">
    <img src="https://img.shields.io/pub/points/breakify" alt="Pub Points">
  </a>
  <a href="https://github.com/josueSerna/breakify/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT">
  </a>
  <img src="https://img.shields.io/badge/flutter-%3E%3D3.0.0-02569B?logo=flutter" alt="Flutter SDK">
</p>

<p align="center">
  <img src="assets/breakify_banner.jpeg" width="400" alt="Breakify">
</p>



  <p align="center">
    <img src="assets/breakify.gif" width="600" alt="Demo de Breakify redimensionando en vivo">
  </p>
---

## Tabla de Contenidos

- [¿Qué es Breakify?](#qué-es-breakify)
- [¿Por qué Breakify?](#por-qué-breakify)
- [Características](#características)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Inicio Rápido](#inicio-rápido)
- [Breakpoints por Defecto](#breakpoints-por-defecto)
- [Valores Responsivos](#valores-responsivos)
- [Valores Fluidos](#valores-fluidos)
- [Extensiones de BuildContext](#extensiones-de-buildcontext)
- [Widgets](#widgets)
  - [BreakifyAdaptiveLayout](#breakifyadaptivelayout)
  - [BreakifyGrid](#breakifygrid)
  - [BreakifyListView](#breakifylistview)
  - [BreakifyContainer](#breakifycontainer)
  - [BreakifyVisibility](#breakifyvisibility)
  - [BreakifyBuilder](#breakifybuilder)
  - [BreakifyDebugBanner](#breakifydebugbanner)
- [Vista Previa Responsiva](#vista-previa-responsiva)
- [App de Ejemplo](#app-de-ejemplo)
- [Contribuir](#contribuir)
- [Licencia](#licencia)
- [Autor](#autor)

---

## ¿Qué es Breakify?

Breakify es un toolkit de layout responsivo ligero para Flutter, diseñado para facilitar la construcción y el mantenimiento de UIs responsivas.

En vez de revisar repetidamente las dimensiones de pantalla en tus widgets:

```dart
if (MediaQuery.sizeOf(context).width >= 1024) {
  // ...
}
```

Breakify te permite describir **cómo debe comportarse un valor o un layout** según el tamaño de pantalla, y se encarga de resolverlo por ti.

---

## ¿Por qué Breakify?

Sin Breakify, los layouts responsivos suelen requerir revisar manualmente el tamaño de pantalla en cada widget:

```dart
if (MediaQuery.sizeOf(context).width >= 1024) {
  ...
}
```

o recurrir a un `LayoutBuilder` cada vez:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    // ...
  },
)
```

Con Breakify, la misma lógica se vuelve declarativa:

```dart
BreakifyAdaptiveLayout(
  breakpoint: BreakifyBreakpoint.lg,
  spacing: const BreakifyFluidValue(
    sm: 12,
    lg: 24,
  ),
  children: [
    LeftPanel(),
    RightPanel(),
  ],
)
```

| Sin Breakify | Con Breakify |
|---|---|
| Chequeos de tamaño de pantalla dispersos en los widgets | Lógica responsiva centralizada en un solo valor |
| Boilerplate manual de `LayoutBuilder` en cada widget | Widgets adaptativos incluidos |
| Saltos abruptos entre breakpoints | Interpolación fluida opcional |
| Fácil olvidar el caso de algún breakpoint | Fallback automático al valor definido más cercano |

La lógica responsiva se mantiene centralizada, haciendo tus widgets más fáciles de leer, mantener y reutilizar.

---

## Características

* Breakpoints responsivos
* Valores fluidos con interpolación suave
* Layouts adaptativos de fila/columna
* Contenedores responsivos
* Grids responsivos (incluyendo scroll horizontal y filas de igual altura)
* Listas responsivas (verticales y horizontales)
* Visibilidad condicional según breakpoint
* Banner de breakpoint para desarrollo

---

## Requisitos

* Dart SDK `>=3.0.0`
* Flutter SDK `>=3.0.0`

---

## Instalación

Agrega Breakify a tu `pubspec.yaml`.

```yaml
dependencies:
  breakify: ^0.1.1
```

Luego importa el paquete.

```dart
import 'package:breakify/breakify.dart';
```

---

## Inicio Rápido

Envuelve tu aplicación con `BreakifyScope`.

```dart
void main() {
  runApp(
    BreakifyScope(
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
```

Esto hace que la información responsiva esté disponible en todo el árbol de widgets.

---

## Breakpoints por Defecto

Breakify incluye cinco breakpoints responsivos por defecto.

| Breakpoint | Ancho mínimo |
| ---------- | ------------: |
| sm         |           640 |
| md         |           768 |
| lg         |          1024 |
| xl         |          1280 |
| xxl        |          1536 |

También puedes proveer tu propia configuración de breakpoints.

```dart
const breakpoints = BreakifyBreakpoints(
  sm: 500,
  md: 700,
  lg: 900,
  xl: 1200,
  xxl: 1600,
);
```

```dart
BreakifyScope(
  breakpoints: breakpoints,
  child: MyApp(),
)
```

> **Nota:** todos los anchos de breakpoint mostrados en este README —
> incluyendo la [Vista Previa Responsiva](#vista-previa-responsiva) más
> abajo — usan estos valores por defecto. Como los breakpoints son
> totalmente personalizables, tu propia app puede cambiar de layout en
> anchos diferentes.

---

## Valores Responsivos

En vez de revisar manualmente el ancho de pantalla, define cómo debe comportarse un valor.

```dart
const columns = BreakifyValue(
  sm: 1,
  md: 2,
  lg: 4,
);

final value = context.resolve(columns);
```

Los breakpoints no definidos heredan automáticamente el valor anterior más cercano.

Por ejemplo:

| Breakpoint | Valor |
| ---------- | ----: |
| sm         |     1 |
| md         |     2 |
| lg         |     4 |
| xl         |     4 |
| xxl        |     4 |

---

## Valores Fluidos

¿Necesitas que los valores escalen suavemente en vez de cambiar de forma abrupta?

Usa `BreakifyFluidValue`.

```dart
const spacing = BreakifyFluidValue(
  sm: 8,
  md: 16,
  lg: 24,
);

Container(
  padding: EdgeInsets.all(
    context.resolve(spacing),
  ),
)
```

En vez de saltar de un valor a otro, Breakify interpola entre breakpoints.

---

## Extensiones de BuildContext

Breakify provee extensiones útiles para acceder a la información responsiva.

```dart
context.breakpoint
```

Retorna el breakpoint actual.

```dart
context.breakifyWidth
```

Retorna el ancho actual.

```dart
context.resolve(value)
```

Resuelve cualquier `BreakifyResolvable`.

---

## Widgets

### BreakifyAdaptiveLayout

Cambia automáticamente entre un `Column` y un `Row`.

```dart
BreakifyAdaptiveLayout(
  breakpoint: BreakifyBreakpoint.lg,
  spacing: const BreakifyValue(
    sm: 12,
    lg: 24,
  ),
  children: [
    Sidebar(),
    Content(),
  ],
)
```

---

### BreakifyGrid

Grid responsivo con columnas, espaciado y aspect ratio configurables.

```dart
BreakifyGrid(
  columns: const BreakifyValue(
    sm: 2,
    md: 3,
    lg: 4,
  ),
  spacing: const BreakifyFluidValue(
    sm: 8,
    lg: 20,
  ),
  children: products,
)
```

También soporta:

* **Scroll horizontal** — configura `scrollDirection: Axis.horizontal`
  para desplazarse hacia los lados en vez de verticalmente. En este modo,
  `columns` controla el número de filas en vez de columnas, y
  `childAspectRatio` se sigue expresando como ancho / alto.
* **Filas de igual altura** — configura `equalHeight: true` para que
  todos los ítems de una fila igualen la altura del ítem más alto de esa
  fila. Útil para grids con ítems de altura intrínseca variable.
  Actualmente solo soportado con `Axis.vertical`.

```dart
BreakifyGrid(
  columns: const BreakifyValue(sm: 1, md: 2, lg: 3),
  scrollDirection: Axis.horizontal,
  spacing: const BreakifyFluidValue(sm: 8, lg: 20),
  children: cards,
)
```

---

### BreakifyListView

Lista responsiva con espaciado y separadores configurables.

```dart
BreakifyListView(
  spacing: const BreakifyValue(
    sm: 8,
    lg: 16,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

Soporta un widget `separator` personalizado (que reemplaza el espaciado por
defecto) y `scrollDirection: Axis.horizontal` para listas horizontales.

---

### BreakifyContainer

Centra el contenido limitando su ancho máximo.

```dart
BreakifyContainer(
  maxWidth: const BreakifyValue(
    sm: 1200,
  ),
  child: content,
)
```

---

### BreakifyVisibility

Muestra u oculta widgets según el breakpoint actual.

```dart
BreakifyVisibility(
  minBreakpoint: BreakifyBreakpoint.lg,
  child: Sidebar(),
)
```

O muestra solo en breakpoints específicos.

```dart
BreakifyVisibility.only(
  visibleIn: {
    BreakifyBreakpoint.sm,
    BreakifyBreakpoint.xl,
  },
  child: Logo(),
)
```

---

### BreakifyBuilder

Construye widgets según el breakpoint actual.

```dart
BreakifyBuilder(
  builder: (context, breakpoint, constraints) {
    return Text(
      breakpoint.name,
    );
  },
)
```

---

### BreakifyDebugBanner

Muestra el breakpoint actual durante el desarrollo.

```dart
BreakifyDebugBanner(
  child: MyApp(),
)
```

---

## Vista Previa Responsiva

Las capturas de abajo fueron tomadas de la app en [`/example`](example),
redimensionada en cada breakpoint.

> Estas capturas usan los anchos de breakpoint **por defecto** de Breakify
> (ver la tabla de [Breakpoints por Defecto](#breakpoints-por-defecto) más
> arriba). Los breakpoints son totalmente personalizables mediante
> `BreakifyBreakpoints`, así que una app con valores personalizados
> cambiará de layout en anchos distintos — lo que se mantiene consistente
> es el *comportamiento* (cuántas columnas, cómo se adapta el layout), no
> el valor exacto en píxeles.

<table align="center">
  <tr>
    <td align="center">
      <img src="assets/breakpoint_sm.png" width="160" alt="Vista previa breakpoint sm"><br>
      <sub><b>sm</b> · teléfono</sub>
    </td>
    <td align="center">
      <img src="assets/breakpoint_md.png" width="160" alt="Vista previa breakpoint md"><br>
      <sub><b>md</b> · teléfono grande / tablet pequeña</sub>
    </td>
    <td align="center">
      <img src="assets/breakpoint_lg.png" width="160" alt="Vista previa breakpoint lg"><br>
      <sub><b>lg</b> · tablet / laptop pequeña</sub>
    </td>
    <td align="center">
      <img src="assets/breakpoint_xl.png" width="160" alt="Vista previa breakpoint xl"><br>
      <sub><b>xl</b> · laptop / escritorio</sub>
    </td>
    <td align="center">
      <img src="assets/breakpoint_xxl.png" width="160" alt="Vista previa breakpoint xxl"><br>
      <sub><b>xxl</b> · escritorio grande</sub>
    </td>
  </tr>
</table>

<!--
  Cómo regenerar estas capturas:
  1. Corre la app de ejemplo: flutter run -d chrome
  2. Redimensiona la ventana del navegador a cada ancho de breakpoint
     por defecto (640, 768, 1024, 1280, 1536) — o un ancho representativo
     justo por encima de cada uno.
  3. Toma una captura y guárdala como assets/preview_<breakpoint>.png
-->

---

## App de Ejemplo

Una aplicación de ejemplo completa está disponible en la carpeta [`example`](example).

Ejecuta el ejemplo en Flutter Web:

```bash
flutter run -d chrome
```

O ejecútalo en cualquier dispositivo conectado (Android, iOS, escritorio, o el emulador por defecto):

```bash
flutter run
```

---

## Contribuir

¡Las contribuciones, issues y solicitudes de features son bienvenidas!

1. Haz un fork del repositorio
2. Crea una rama de feature (`git checkout -b feature/mi-feature`)
3. Haz commit de tus cambios
4. Abre un pull request

Si estás proponiendo un cambio grande, por favor abre primero un issue para discutir qué te gustaría cambiar.

---

## Licencia

Este proyecto está licenciado bajo la Licencia MIT.

## Autor

Desarrollado y mantenido por Josue Serna.

GitHub: https://github.com/josueSerna