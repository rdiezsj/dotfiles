---
name: librarium-terra-notes
description: Crea, investiga, reescribe, clasifica y mantiene notas Markdown para la bóveda Obsidian Librarium_Terra. Úsala cuando el usuario pida crear una nota de Obsidian, convertir una conversación, texto o documento en una nota reutilizable, documentar un procedimiento, generar una checklist, referencia, decisión, proyecto, reunión, receta, viaje o investigación, clasificar una nota en Librarium_Terra o actualizar una nota existente de la bóveda.
metadata:
  version: "1.0"
---

# Librarium Terra — Notas

Genera y mantiene notas Markdown homogéneas, duraderas y listas para usar en la bóveda Obsidian `Librarium_Terra`.

Escribe en español salvo que el usuario solicite otro idioma.

## Modos de funcionamiento

Determina qué modo está disponible antes de generar la nota.

### Modo A — Bóveda local disponible

Usa este modo cuando el entorno de trabajo actual tenga acceso directo al sistema de archivos de la bóveda `Librarium_Terra`.

Antes de clasificar o escribir:

1. Inspecciona la estructura real de la bóveda relevante para la solicitud.
2. Busca notas existentes con el mismo propósito o uno estrechamente relacionado.
3. Prefiere una carpeta existente adecuada antes de crear una nueva.
4. Usa nombres de notas existentes conocidos al crear `[[wikilinks]]`.
5. Si el usuario solicita crear o actualizar la nota y existe acceso de escritura, escribe directamente el archivo `.md` en la carpeta seleccionada de la bóveda.
6. No modifiques notas, carpetas, adjuntos, metadatos o formato que no estén relacionados con la solicitud.
7. Nunca elimines, muevas, renombres ni sobrescribas una nota existente salvo que el usuario lo solicite explícitamente.
8. Si una nota existente se solapa de forma sustancial con la solicitada, informa del solapamiento y prefiere actualizarla cuando eso coincida con la intención del usuario.

La bóveda local real es la fuente de verdad para comprobar la existencia actual de carpetas y notas.

### Modo B — Bóveda local no disponible

Usa este modo cuando no sea posible inspeccionar directamente la bóveda.

Consulta `references/Librarium_Terra - Estructura y normas.md` como referencia base para la estructura, clasificación y convenciones de nombres.

Crea un archivo UTF-8 `.md` y adjúntalo para descarga. No afirmes que una carpeta recomendada existe actualmente salvo que aparezca en la referencia incluida.

## Política de evolución de la bóveda

La estructura de la bóveda puede evolucionar.

Al seleccionar una ubicación:

1. Reutiliza una carpeta existente siempre que represente adecuadamente el propósito duradero de la nota.
2. No crees una carpeta nueva únicamente para almacenar una sola nota.
3. Una carpeta nueva solo está justificada cuando representa una categoría reutilizable que previsiblemente contendrá varias notas relacionadas o un proyecto/contenedor duradero.
4. En modo local, crea una carpeta nueva solo cuando:
   - exista acceso de escritura;
   - esté claramente justificada según la regla anterior;
   - su carpeta padre sea inequívoca.
5. En modo externo, no simules que una carpeta propuesta existe. Si se justifica una nueva carpeta, indícala explícitamente como propuesta.
6. Si la clasificación sigue siendo realmente dudosa, usa `00_INBOX/`.

## Clasificación principal

Clasifica según el propósito principal de la nota:

1. Familia o vida personal → `10_FAMILIA/`.
2. Hogar, compras domésticas, vehículos, proveedores o HomeLab real → `20_HOGAR/`.
3. Finanzas personales, impuestos, seguros, hipoteca o vivienda → `30_FINANZAS/`.
4. Empleador, cliente, proyecto, reunión o entregable laboral específico → `40_TRABAJO/`.
5. Ocio, cultura, viajes, gastronomía, deporte o juegos → `50_AFICIONES/`.
6. Conocimiento reutilizable e independiente de una organización o proyecto concreto → `60_CONOCIMIENTO/`.
7. Material cerrado, histórico u obsoleto destinado explícitamente a archivo → `90_ARCHIVO/`.
8. Clasificación dudosa o pendiente → `00_INBOX/`.

Para notas híbridas, elige la carpeta correspondiente al uso principal. Representa relaciones secundarias mediante etiquetas o `[[wikilinks]]` conocidos.

Usa las reglas detalladas y ejemplos del documento de referencia o, en modo local, la estructura real de la bóveda.

## Flujo de trabajo

Sigue esta secuencia:

1. **Comprender**
   - Identifica el propósito duradero de la nota solicitada.
   - Separa hechos aportados por el usuario, hechos verificados externamente, supuestos, recomendaciones y decisiones.

2. **Inspeccionar el contexto**
   - En modo local, inspecciona las carpetas relevantes y busca notas que puedan solaparse.
   - En modo externo, consulta la referencia incluida de la bóveda.

3. **Clasificar**
   - Elige el área principal y la carpeta más específica adecuada.
   - Prefiere carpetas existentes.
   - Aplica la política de evolución de la bóveda si puede estar justificada una nueva carpeta.

4. **Elegir el tipo de nota**
   Usa exactamente un valor principal de:
   `guia`, `referencia`, `procedimiento`, `proyecto`, `decision`, `receta`,
   `viaje`, `checklist`, `investigacion`, `reunion`, `registro`.

5. **Elegir el nombre de archivo**
   - Conocimiento permanente: sin fecha.
   - Eventos, viajes, reuniones, decisiones fechadas o registros: `YYYY-MM-DD Título.md`.
   - Evita títulos genéricos como `Notas`, `Apuntes`, `Información`, `Varios` o `Guía`.
   - Conserva nombres de productos, servicios, proyectos y terminología técnica.
   - Usa exactamente el nombre seleccionado al crear el archivo.

6. **Investigar cuando sea necesario**
   - No inventes datos, comandos, versiones, enlaces, precios, fechas ni fuentes.
   - Para hechos actuales, técnicos o verificables externamente, investiga con fuentes fiables cuando proceda y las herramientas estén disponibles.
   - Si no puede verificarse información material, indica la incertidumbre en lugar de rellenar huecos.
   - Cuando la información sea sensible al tiempo, incluye la fecha de comprobación en la nota.

7. **Redactar**
   - La nota debe poder entenderse sin acceso a la conversación que la originó.
   - Elimina texto conversacional y duplicaciones.
   - Conserva con exactitud comandos, rutas, identificadores, versiones, URL, claves de configuración y código suministrados por el usuario salvo que se corrijan explícitamente.
   - Explica los supuestos y el riesgo destructivo antes de comandos que puedan provocar pérdida de datos o impacto en servicios.

8. **Validar**
   Ejecuta todas las comprobaciones de la sección `Validación`.

9. **Entregar**
   Sigue las reglas de entrega correspondientes al modo activo.

## Seguridad y privacidad

No expongas secretos, credenciales, tokens, claves API, claves privadas, cookies de sesión, tokens de acceso ni datos personales innecesarios.

Sustituye valores sensibles por marcadores como:

- `<TOKEN>`
- `<API_KEY>`
- `<ACCOUNT_ID>`
- `<PASSWORD>`
- `<URL_INTERNA>`
- `<IP_PRIVADA>` cuando la dirección exacta no sea necesaria

No copies secretos del material de origen a la nota generada únicamente porque aparezcan en dicho material.

## Frontmatter obligatorio

Todas las notas generadas empiezan exactamente con estas claves y en este orden:

```yaml
---
estado: borrador
creado: YYYY-MM-DD
actualizado: YYYY-MM-DD
tipo: []
aliases: []
tags: []
---
```

Reglas:

- Sustituye las fechas por la fecha local actual fiable. Si no está disponible, usa `pendiente`.
- Usa `estado: estable` solo para contenido explícitamente revisado o definitivo.
- `tipo` contiene exactamente un tipo principal de nota.
- Añade entre 0 y 4 aliases útiles sin repetir el título.
- Añade entre 2 y 6 tags en minúscula y kebab-case.
- No uses `nota`, `obsidian` ni `conocimiento` como tags.
- No incluyas la ruta de la bóveda en el frontmatter.

## Contenido de la nota

Después del frontmatter:

1. Usa exactamente un título H1.
2. Añade inmediatamente un callout `summary` de entre 1 y 3 frases.
3. Añade únicamente secciones H2/H3 útiles.
4. No dejes encabezados vacíos.
5. Crea `[[wikilinks]]` únicamente hacia notas cuyo nombre exacto sea conocido.
6. Usa:
   - `> [!warning]` para información pendiente o no verificada.
   - `> [!tip]` para acciones propuestas o recomendaciones.

Adapta la estructura al tipo de nota.

### Procedimiento técnico

Usa cuando sea relevante, no de forma mecánica:

- `Contexto`
- `Requisitos`
- `Instalación`
- `Configuración`
- `Operación`
- `Comandos de referencia`
- `Problemas frecuentes`

### Decisión

Prioriza:

- `Contexto`
- `Criterios`
- `Alternativas`
- `Decisión`
- `Consecuencias`
- `Próximos pasos`

Registra por qué se descartaron las alternativas cuando esa información sea conocida.

### Investigación

Prioriza:

- `Conceptos clave`
- `Análisis`
- `Recomendaciones`

### Receta

Prioriza:

- `Ingredientes`
- `Preparación`
- `Variaciones`
- `Conservación`

### Viaje

Prioriza:

- `Datos prácticos`
- `Itinerario`
- `Reservas`
- `Presupuesto`

### Proyecto

Prioriza:

- `Objetivo`
- `Alcance`
- `Estado`
- `Decisiones`
- `Riesgos`
- `Próximos pasos`

### Checklist

Prioriza:

- `Objetivo`
- `Lista de comprobación`
- `Criterios de cierre`

## Fuentes

Añade `## Fuentes` cuando la nota utilice:

- investigación web;
- documentos adjuntos;
- material de referencia externo.

Omite `## Fuentes` únicamente cuando todo el contenido proceda del usuario y no se haya utilizado ninguna fuente externa.

No inventes citas ni referencias.

## Validación

Antes de entregar, verifica:

- que la ubicación coincide con el propósito principal de la nota;
- que se ha preferido una carpeta existente cuando era adecuada;
- que cualquier carpeta nueva o propuesta cumple la política de evolución de la bóveda;
- que no se ha creado una carpeta únicamente para una nota;
- que el nombre del archivo sigue las convenciones de la bóveda;
- que las claves obligatorias del frontmatter existen y están en el orden exacto;
- que `creado` y `actualizado` contienen fechas válidas o `pendiente`;
- que existe exactamente un tipo de nota;
- que el número de aliases está entre 0 y 4;
- que el número de tags está entre 2 y 6;
- que los tags están en minúscula y kebab-case;
- que existe exactamente un H1;
- que el callout `summary` aparece inmediatamente después del H1;
- que no existen encabezados vacíos;
- que todos los wikilinks apuntan a nombres de notas conocidos;
- que no se han inventado afirmaciones no respaldadas;
- que no se han expuesto secretos;
- que existe una sección de fuentes cuando se ha utilizado material externo;
- que el Markdown generado es válido y compatible con Obsidian.

## Entrega

### Modo A — Bóveda local disponible

Cuando el usuario solicite crear, guardar o actualizar la nota y exista acceso de escritura:

1. Escribe la nota completa directamente en la ubicación seleccionada dentro de `Librarium_Terra`.
2. El archivo debe contener exclusivamente la nota Markdown.
3. No generes además una copia descargable salvo que el usuario la solicite.
4. Responde de forma concisa con:
   - la ruta exacta relativa a la bóveda;
   - si la nota fue creada o actualizada;
   - una frase breve justificando la clasificación.

Cuando el usuario solicite únicamente una recomendación o previsualización, no escribas en disco.

### Modo B — Bóveda local no disponible

Para cada nota generada:

1. Determina la carpeta recomendada.
2. Determina el nombre exacto del archivo.
3. Genera un archivo UTF-8 `.md` que contenga exclusivamente la nota completa.
4. Adjunta el archivo para descarga.
5. No pegues el contenido completo de la nota en la conversación salvo petición explícita.

Usa exactamente esta estructura de respuesta:

**Carpeta recomendada:** `ruta/exacta/`
**Nombre de archivo:** `Nombre de archivo.md`
**Criterio:** Una frase breve que justifique la clasificación.
**Descarga:** [Descargar nota](sandbox:/mnt/data/Nombre de archivo.md)

Si se propone una carpeta nueva en lugar de una carpeta cuya existencia esté confirmada, indícalo expresamente en la frase de `Criterio`.

Si no es posible crear archivos porque el entorno carece de herramientas para ello, indícalo claramente y devuelve la nota completa dentro de un bloque de código Markdown.
