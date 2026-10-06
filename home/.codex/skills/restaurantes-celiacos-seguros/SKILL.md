---
name: restaurantes-celiacos-seguros
description: Activa esta Skill automáticamente siempre que el usuario pregunte dónde comer o beber siendo celíaco, pida restaurantes, bares, cafeterías, tapas, pintxos, desayunos, comidas o cenas sin gluten, solicite valorar la seguridad de un establecimiento para celiaquía, busque alternativas seguras cerca de una ruta o alojamiento, o cualquier planificación de viaje necesite elegir sitios fiables para una persona celíaca. Debe distinguir siempre entre tener opciones sin gluten y ser realmente seguro frente a contaminación cruzada.
---

# Restaurantes seguros para celíacos

Investiga establecimientos de restauración priorizando la seguridad de una persona con celiaquía.

Escribe en español salvo que el usuario solicite otro idioma.

## Activación automática

Activa esta Skill automáticamente aunque el usuario no mencione literalmente “celiaquía”.

Considérala relevante ante expresiones como:

- “restaurantes sin gluten”
- “sitios para celíacos”
- “dónde puedo comer”
- “algún sitio seguro para comer”
- “tapas sin gluten”
- “pintxos sin gluten”
- “desayunar sin gluten”
- “comer cerca del hotel”
- “cenar cerca de la ruta”
- “¿es seguro este restaurante?”
- “tiene opciones sin gluten, ¿me puedo fiar?”
- “búscame dos sitios, uno barato y otro mejor”

Si el contexto de la conversación ya indica que viaja una persona celíaca, activa esta Skill también ante peticiones genéricas de restaurantes, comidas o cenas aunque el nuevo mensaje no repita la restricción.

Cuando otra Skill, especialmente `planificador-viajes-familiares`, necesite seleccionar restauración para una persona celíaca, considera esta Skill aplicable automáticamente.

No exijas una invocación manual con `@` cuando la intención encaje claramente.

## Principio fundamental

No confundas:

- disponer de platos u opciones “sin gluten”;
- disponer de procedimientos suficientemente seguros para una persona celíaca.

La presencia de opciones sin gluten no demuestra ausencia de contaminación cruzada.

Nunca califiques un establecimiento como seguro sin evidencias suficientes.

## Información a investigar

Cuando sea posible, comprueba:

- si el establecimiento es 100 % sin gluten;
- certificaciones o acuerdos con asociaciones;
- protocolos específicos para celiaquía;
- formación o procedimientos del personal;
- manipulación separada;
- superficies y utensilios;
- freidoras separadas;
- hornos o zonas de preparación;
- carta específica;
- gestión de contaminación cruzada;
- experiencias recientes de personas celíacas;
- horario real;
- estado abierto/cerrado;
- dirección;
- precio aproximado;
- necesidad de reserva.

Para tapas, pintxos, aperitivos, buffet y similares aplica exactamente los mismos criterios.

## Prioridad de fuentes

Prioriza, en este orden:

1. asociaciones de celíacos y entidades especializadas reconocidas;
2. establecimiento 100 % sin gluten;
3. documentación oficial del establecimiento o carta oficial;
4. plataformas especializadas en celiaquía;
5. experiencias recientes y detalladas de personas celíacas;
6. Google Maps, TripAdvisor, Reddit u otras reseñas.

Una reseña que únicamente diga “tienen opciones sin gluten” no permite concluir que el establecimiento sea seguro.

Las reseñas son evidencia auxiliar y deben interpretarse críticamente.

## Clasificación

Utiliza estas categorías solo cuando exista información suficiente:

### 🟢 MUY FIABLE

Aplicable cuando existe evidencia fuerte, por ejemplo:

- establecimiento 100 % sin gluten;
- certificación relevante;
- recomendación de asociación;
- protocolos de seguridad claramente documentados.

### 🟢 FIABLE

Aplicable cuando:

- existen procedimientos específicos para celíacos;
- las prácticas contra contaminación cruzada están razonablemente documentadas;
- hay evidencias recientes y consistentes.

### 🟡 PRECAUCIÓN

Aplicable cuando:

- existen opciones sin gluten;
- faltan datos sobre contaminación cruzada;
- la información es antigua, vaga o contradictoria;
- ciertas prácticas pueden implicar riesgo.

No presentes esta categoría como “seguro”.

### 🔴 NO RECOMENDADO

Aplicable cuando:

- no existen garantías suficientes;
- existe contaminación cruzada probable;
- las prácticas descritas son incompatibles con una dieta celíaca estricta;
- existen evidencias recientes de problemas relevantes.

## Flujo de investigación

1. **Identificar**
   - establecimiento o zona;
   - fecha/día cuando sea relevante;
   - tipo de comida;
   - restricciones adicionales si existen.

2. **Buscar evidencia fuerte**
   - asociaciones;
   - web oficial;
   - carta;
   - protocolos;
   - certificaciones.

3. **Contrastar**
   - plataformas especializadas;
   - experiencias recientes;
   - reseñas detalladas.

4. **Evaluar contaminación cruzada**
   No asumas seguridad por disponer de carta sin gluten.

5. **Comprobar logística**
   - horario;
   - ubicación;
   - precio aproximado;
   - reserva;
   - estado actual.

6. **Clasificar**
   Asigna nivel únicamente según la evidencia disponible.

7. **Explicar**
   Resume por qué recibe esa clasificación y qué incertidumbre permanece.

## Recomendaciones

Cuando el usuario solicite opciones en una zona:

- ofrece preferentemente 2 alternativas adecuadas;
- intenta cubrir distinto rango de precio;
- prioriza seguridad frente a popularidad;
- evita desplazamientos largos salvo que aporten una mejora clara de seguridad;
- no incluyas establecimientos dudosos simplemente para completar una lista.

Cuando ninguna opción pueda considerarse suficientemente fiable, dilo explícitamente.

## Formato recomendado

Para cada establecimiento:

```text
### 🍴 Nombre

**Fiabilidad celíaca:** 🟢 Muy fiable / 🟢 Fiable / 🟡 Precaución / 🔴 No recomendado

**Motivo:** síntesis breve de las evidencias.

**Seguridad:** información relevante sobre contaminación cruzada, cocina, freidoras, utensilios o protocolos.

**Ubicación:** dirección o relación con la zona solicitada.

**Horario:** horario comprobado cuando sea relevante.

**Precio:** aproximado cuando pueda verificarse.

**Reserva:** imprescindible / recomendable / opcional.

**A confirmar:** solo si existe alguna incertidumbre importante.
```

## Discrepancias

Si las fuentes se contradicen:

1. señala la discrepancia;
2. prioriza asociaciones, documentación oficial y evidencias recientes;
3. reduce el nivel de confianza si la contradicción afecta a la seguridad;
4. recomienda confirmar directamente con el establecimiento cuando sea necesario.

## Fuentes

Cita siempre las fuentes relevantes que sustentan la evaluación de seguridad.

No inventes fuentes, protocolos, certificaciones ni experiencias.

## Seguridad

La seguridad de una persona celíaca tiene prioridad sobre:

- precio;
- cercanía;
- popularidad;
- valoración media;
- conveniencia turística.
