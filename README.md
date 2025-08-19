# Gestor de Tareas Flutter

Aplicación de gestión de tareas desarrollada en **Flutter** utilizando **Riverpod** para la gestión de estado y **SharedPreferences** para persistencia local.

---

## Funcionalidades Principales

- **Gestión de tareas**
  - Crear nuevas tareas con título obligatorio y descripción opcional.
  - Editar tareas existentes.
  - Eliminar tareas.
  - Marcar tareas como **Completadas** o **Fallidas**.
- **Estados de tarea**
  - `Pending` (Pendiente)
  - `Completed` (Completada)
  - `Failed` (Fallida)
- **Razones de falla**
  - Timeout, Error, Canceled, Custom (para otros casos)
- **Filtros por estado** mediante chips y tabs.
- **Estadísticas rápidas**: contador de tareas pendientes, completadas y fallidas.
- **Persistencia local** usando `SharedPreferences`.
- **Modo oscuro** soportado (`ThemeMode.system`).

---

## Decisiones importantes de desarrollo

1. **Gestión de estado**
   - Se eligió **Riverpod 2.x** con `StateNotifier` para separar lógica de negocio y UI, facilitando escalabilidad y testeo.
2. **Persistencia**
   - Persistencia local implementada con **SharedPreferences**, serializando tareas a JSON.
3. **Modelos y enums**
   - `TaskStatus` enum y `FailReason` enum.
   - `uuid` para IDs únicas de tareas.
4. **UI/UX**
   - Diferentes iconos y colores según el estado.
   - Modal para seleccionar razón de falla.
   - Animaciones eliminadas por estabilidad.

---

## Librerías utilizadas

- **flutter_riverpod**
- **uuid**
- **shared_preferences**
- **flutter/material.dart**

---

## Cómo ejecutar la aplicación

1. Clonar el repositorio:

```bash
git clone <URL_DEL_REPOSITORIO>
cd <NOMBRE_DEL_REPOSITORIO>
```

2. Ejecutar:
```bash
flutter pub get
```
3. Correr la Aplicación:
```bash
flutter run
```

## Preguntas y Respuestas
1. Decisiones de Arquitectura

Pregunta: Cuéntanos cuál fue la decisión técnica más difícil que tomaste durante el desarrollo. ¿Qué alternativas consideraste y qué trade-offs evaluaste antes de tomar tu decisión final?
Respuesta: La decisión más compleja fue elegir la gestión de estado. Consideré usar setState puro, Provider, Bloc y Riverpod. SetState era demasiado simple y poco escalable; Provider funcionaba pero no ofrecía la misma robustez para manejo de Async; Bloc agregaba complejidad para una prueba corta. Finalmente elegí Riverpod por su balance entre escalabilidad, claridad y soporte de Async, lo que permitió integrar la persistencia y preparar la app para futuras mejoras sin sobrecargar el código.

2. Gestión del Tiempo

Pregunta: Si tuvieras 2 horas adicionales de desarrollo, ¿qué funcionalidad o mejora priorizarías implementar?
Respuesta: Implementaría persistencia avanzada con Hive o SQLite y sincronización en la nube, porque permitiría mantener datos entre múltiples dispositivos y garantizar la durabilidad de tareas a largo plazo. Esto agregaría valor real al usuario final al no depender de la sesión local.

3. Escalabilidad

Pregunta: Describe qué cambios arquitectónicos serían necesarios si esta aplicación necesitara sincronizar datos en tiempo real entre múltiples dispositivos, manejar más de 100,000 tareas por usuario, y funcionar offline.
Respuesta:

Migrar persistencia local a Hive o SQLite para manejo eficiente de gran volumen de datos.

Implementar Backend con API REST y WebSockets para sincronización en tiempo real.

Separar completamente la capa de repositorio y servicios para desacoplar almacenamiento local y remoto.

Aplicar paginated loading y filtros en queries para eficiencia.

Uso de caching y sincronización incremental para operaciones offline.

4. Testing

Pregunta: ¿Qué parte del código consideras más crítica para testear?
Respuesta: La lógica del TaskNotifier y del TaskRepository, ya que contienen toda la manipulación de datos y actualización de estado. Priorizaría tests unitarios para métodos addTask, updateTask, deleteTask y loadTasks, y tests de widget para la pantalla de tareas y modales.

5. Mejora de UX

Pregunta: ¿Qué feature adicional consideras que haría la app más útil para el día a día?
Respuesta: Agregar notificaciones y recordatorios por tarea pendiente, así como la posibilidad de agrupar tareas por proyecto o etiqueta. Esto aumentaría la productividad y la organización del usuario.

6. Aprendizaje

Pregunta: ¿Hubo algo que no sabías hacer al inicio de la prueba y tuviste que investigar?
Respuesta: Inicialmente no conocía la integración de SharedPreferences con Riverpod AsyncNotifier para persistencia automática. Investigué la documentación oficial de Flutter y ejemplos en GitHub, y logré implementarlo serializando las tareas a JSON para mantener estado persistente entre sesiones.

## Transparencia sobre el Uso de IA
Uso de IA en el desarrollo
1. Herramientas utilizadas

ChatGPT (OpenAI GPT-5 Mini): Asistencia principal para generación de código, sugerencias de arquitectura y documentación.

Porcentaje aproximado de código generado por IA: ~35% generado con asistencia de IA, ~65% escrito y adaptado por mí.

La mayor parte del código de la UI, integración con Riverpod, persistencia local y testing fue escrito directamente por mí.

2. Casos de uso específicos

Estructura del proyecto y arquitectura: Definición de carpetas, separación de features, providers y repositorios.

Lógica de negocio: Implementación del TaskNotifier y la integración con el TaskRepository en memoria y persistencia con SharedPreferences.

UI y manejo de estado: Creación de la TaskPage, modales de fallas, íconos por estado y filtros de tareas por estado.

Documentación y README: Redacción de decisiones técnicas, preguntas y respuestas, y explicaciones de arquitectura.

Optimización y debugging: Sugerencias sobre cómo mejorar la eficiencia de carga de tareas y uso de AsyncValue con Riverpod.

3. Ejemplos concretos

Patrón Repository:

Pedí a ChatGPT orientación sobre cómo separar la lógica de persistencia en un TaskRepository en memoria y métodos async para simular operaciones reales.

Filtros y estadísticas:

Solicitaba ideas para implementar filtros por estado y mostrar contadores dinámicos de tareas completadas, pendientes y fallidas con Chips.

Persistencia local con SharedPreferences:

La IA me guió sobre cómo serializar y deserializar listas de objetos Task a JSON y almacenarlas automáticamente con Riverpod AsyncNotifier.

4. Reflexión sobre el uso de IA

La IA agregó valor principalmente en la generación de estructuras iniciales, patrones de arquitectura y ejemplos de modales complejos, ahorrando tiempo y evitando errores comunes.

Preferí hacer por mi cuenta la mayor parte de la lógica de negocio, integración de Riverpod y UI, para mantener control total sobre el comportamiento de la app y asegurar consistencia con mis decisiones de diseño.

Validé que el código generado seguía buenas prácticas revisando la consistencia de tipos, la correcta actualización del estado en Riverpod y pruebas locales de la app en tiempo real.

5. Aprendizaje mediante IA

Aprendí a integrar AsyncValue de Riverpod con persistencia local, una técnica que antes no había utilizado de manera práctica.

Comprendí mejor el patrón Repository aplicado en Flutter y cómo desacoplar la UI de la lógica de datos.

Mejoré mis conocimientos sobre gestión de estados complejos y modales de selección dinámica de razones de fallo, incluyendo enums y serialización a JSON.