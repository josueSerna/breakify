<h1 align="start">Breakify</h1>

<p align="start">
  <a href="https://pub.dev/packages/breakify">
    <img src="https://img.shields.io/pub/v/breakify.svg" alt="Pub Version">
  </a>
  <a href="https://github.com/josueSerna/breakify">
    <img src="https://img.shields.io/github/stars/josueSerna/breakify?style=social" alt="GitHub Stars">
  </a>
</p>

<p align="center">
  <img src="assets/breakify_banner.jpeg" width="180" alt="Logo de Breakify">
</p>



<p align="start">
Un conjunto de herramientas para crear interfaces responsivas en Flutter.
</p>

<p align="start">
Breakify te ayuda a construir aplicaciones adaptables utilizando breakpoints,
valores responsivos y widgets adaptativos sin llenar tu código de comprobaciones
del tamaño de la pantalla.
</p>

<p align="start">
Diseñado para funcionar en aplicaciones móviles, tabletas, escritorio y Flutter Web.
</p>

<p align="center">
  <img src="assets/breakify.gif" alt="Breakify Responsive Demo">
</p>

<p align="start">
  <i>
    Demo grabada en Flutter Web para facilitar la visualización del responsive.
    Breakify también funciona en aplicaciones móviles y tablets
</p>
---

## Características

* Breakpoints responsivos.
* Valores responsivos con herencia automática.
* Valores fluidos con interpolación suave.
* Layouts adaptativos entre `Row` y `Column`.
* Contenedores responsivos.
* Grillas responsivas.
* Listas responsivas.
* Mostrar u ocultar widgets según el breakpoint.
* Banner de depuración para visualizar el breakpoint actual.
* Ligero y sin dependencias externas.

---

# Instalación

Agrega Breakify a tu archivo `pubspec.yaml`.

```yaml
dependencies:
  breakify: ^0.1.0
```

Después importa el paquete.

```dart
import 'package:breakify/breakify.dart';
```

---

# Primeros pasos

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

Esto hará que toda la información responsiva esté disponible para los widgets hijos.

---

# Breakpoints predeterminados

Breakify incluye cinco breakpoints por defecto.

| Breakpoint | Ancho mínimo |
| ---------- | -----------: |
| sm         |          640 |
| md         |          768 |
| lg         |         1024 |
| xl         |         1280 |
| xxl        |         1536 |

También puedes definir tus propios breakpoints.

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

---

# Valores responsivos

En lugar de comprobar manualmente el ancho de la pantalla, simplemente define cómo debe comportarse un valor.

```dart
const columns = BreakifyValue(
  sm: 1,
  md: 2,
  lg: 4,
);

final value = context.resolve(columns);
```

Los breakpoints que no se definan heredarán automáticamente el valor del breakpoint anterior.

Por ejemplo:

| Breakpoint | Valor |
| ---------- | ----: |
| sm         |     1 |
| md         |     2 |
| lg         |     4 |
| xl         |     4 |
| xxl        |     4 |

---

# Valores fluidos

¿Necesitas que un valor cambie de forma progresiva en lugar de hacerlo de golpe?

Utiliza `BreakifyFluidValue`.

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

En lugar de cambiar bruscamente entre un breakpoint y otro, Breakify interpola automáticamente el valor.

---

# Extensiones de BuildContext

Breakify añade varias extensiones útiles sobre `BuildContext`.

```dart
context.breakpoint
```

Obtiene el breakpoint actual.

```dart
context.breakifyWidth
```

Obtiene el ancho actual.

```dart
context.resolve(value)
```

Resuelve cualquier objeto que implemente `BreakifyResolvable`.

---

# Widgets

## BreakifyAdaptiveLayout

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

## BreakifyGrid

Grilla responsiva con un número de columnas configurable.

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

---

## BreakifyListView

Lista responsiva con separación configurable entre elementos.

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

---

## BreakifyContainer

Centra el contenido y limita su ancho máximo.

```dart
BreakifyContainer(
  maxWidth: const BreakifyValue(
    sm: 1200,
  ),
  child: content,
)
```

---

## BreakifyVisibility

Muestra u oculta widgets según el breakpoint actual.

```dart
BreakifyVisibility(
  minBreakpoint: BreakifyBreakpoint.lg,
  child: Sidebar(),
)
```

También puedes mostrar un widget únicamente en breakpoints específicos.

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

## BreakifyBuilder

Construye widgets utilizando el breakpoint actual.

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

## BreakifyDebugBanner

Muestra el breakpoint actual durante el desarrollo.

```dart
BreakifyDebugBanner(
  child: MyApp(),
)
```

---

# ¿Por qué Breakify?

Sin Breakify, normalmente es necesario comprobar el tamaño de la pantalla en distintos lugares de la interfaz.

```dart
if (MediaQuery.sizeOf(context).width >= 1024) {
  ...
}
```

o utilizar widgets como

```dart
LayoutBuilder(
  builder: ...
)
```

Con Breakify simplemente describes cómo debe comportarse tu interfaz.

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

Breakify se encarga de toda la lógica responsiva para que tus widgets sean más limpios, fáciles de mantener y reutilizables.

---

# Ejemplo

Encontrarás una aplicación de ejemplo completa en la carpeta example.

Ejecútala en Flutter Web:

```bash
flutter run -d chrome
```

O ejecútala en cualquier dispositivo conectado (Android, iOS, escritorio o el emulador predeterminado):

```bash
flutter run
```

---

# Licencia

Este proyecto está distribuido bajo la licencia MIT.
