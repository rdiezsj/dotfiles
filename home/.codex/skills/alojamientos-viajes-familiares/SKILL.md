---
name: alojamientos-viajes-familiares
description: 'Activa esta Skill automáticamente siempre que el usuario pida buscar, comparar, elegir o recomendar alojamiento para un viaje, escapada o vacaciones: apartamentos, hoteles, aparthoteles, casas, resorts u otros alojamientos. Debe valorar simultáneamente ubicación respecto a puntos de interés, restaurantes adecuados para celíacos, playa cuando sea relevante, capacidad real para toda la familia, piscina en meses cálidos, calidad estética, disponibilidad y precio total para las fechas y número de huéspedes indicados. No debe asumir destino, fechas, personas ni preferencias materiales si faltan.'
---

# Alojamientos para viajes familiares

Investiga y recomienda alojamientos para viajes familiares, optimizando simultáneamente ubicación, comodidad, seguridad alimentaria, preferencias y precio real.

Escribe en español salvo que el usuario solicite otro idioma.

## Activación automática

Activa esta Skill automáticamente ante solicitudes como:

- “Búscame alojamiento en...”
- “Dónde nos recomiendas dormir.”
- “Qué zona es mejor para alojarse.”
- “Búscame un apartamento.”
- “Qué hotel elegirías.”
- “Compara estos alojamientos.”
- “Dónde dormir cerca de la playa.”
- “Busca algo bien situado.”
- “Necesito alojamiento para las fechas...”
- “Qué zona nos conviene para este viaje.”
- “Búscame algo con piscina.”
- “Quiero alojarme cerca de restaurantes sin gluten.”

También debe activarse cuando otra Skill de viaje necesite decidir la zona base o seleccionar alojamiento.

No exijas una invocación manual con `@` cuando la intención sea clara.

## Datos necesarios antes de buscar

No des por supuesto datos que puedan cambiar significativamente la recomendación.

Antes de hacer una búsqueda concreta, comprueba si conoces:

- destino o zona;
- fechas exactas;
- número de adultos;
- número y edades aproximadas de los niños;
- tipo de viaje o idea principal;
- transporte disponible.

Pregunta también, cuando sea relevante:

- presupuesto máximo o rango deseado;
- apartamento u hotel;
- piscina;
- cercanía a playa;
- necesidad de parking;
- desayuno;
- cocina;
- ascensor;
- aire acondicionado;
- accesibilidad;
- cancelación gratuita;
- otras limitaciones o preferencias.

No conviertas las preguntas iniciales en un formulario innecesario.

Pregunta únicamente por los datos que realmente cambien el resultado.

## Preferencias familiares por defecto

Cuando el usuario no indique otra cosa y el contexto confirme que se trata del grupo familiar habitual:

- 2 adultos.
- 2 niños, aproximadamente de 4 y 11 años.
- Una persona adulta necesita dieta estrictamente sin gluten por celiaquía.

Estas preferencias solo son valores por defecto de contexto y deben sustituirse por los datos específicos del viaje.

## Prioridades de selección

Aplica este orden general:

1. Capacidad real y adecuada para todos los viajeros.
2. Buena ubicación respecto al propósito del viaje.
3. Seguridad y conveniencia alimentaria para celiaquía.
4. Relación calidad/precio real para las fechas.
5. Preferencia por apartamento cuando haya buenas opciones.
6. Calidad, comodidad y atractivo del alojamiento.
7. Piscina en meses cálidos, cuando aporte valor.
8. Servicios adicionales útiles.

La prioridad exacta puede cambiar si el usuario lo indica.

## Preferencia por apartamentos

Prefiere apartamentos frente a hoteles cuando:

- estén bien situados;
- tengan buenas valoraciones y condiciones;
- el precio sea competitivo;
- permitan alojar cómodamente a toda la familia;
- aporten ventajas reales como cocina, espacio o habitaciones separadas.

La cocina es especialmente útil cuando viaja una persona celíaca, pero no debe compensar una mala ubicación o un alojamiento claramente inferior.

No descartes hoteles si ofrecen una opción mejor.

## Requisitos para hoteles

Cuando recomiendes un hotel:

- comprueba que la habitación o configuración admite realmente a todos los viajeros;
- no asumas que una habitación estándar permite 2 adultos + 2 niños;
- comprueba camas, sofá cama, habitaciones familiares o habitaciones comunicadas cuando proceda;
- compara el precio total necesario para alojar al grupo completo.

No presentes como válida una tarifa que solo cubra parte de la familia.

## Ubicación

No valores un alojamiento solo por estar “en el centro”.

Analiza la ubicación en función de:

- principales puntos de interés;
- rutas previstas;
- restaurantes adecuados para celíacos;
- transporte;
- aparcamiento;
- accesos;
- ruido o tranquilidad cuando sea relevante;
- facilidad para volver al alojamiento durante el día;
- seguridad y comodidad familiar.

Cuando haya varias zonas posibles, compáralas antes de buscar alojamientos concretos.

Si está disponible `planificador-viajes-familiares`, utiliza su contexto o conclusiones sobre zonas y puntos de interés cuando sean relevantes.

## Restauración y celiaquía

Cuando viaje una persona celíaca:

- valora la proximidad a restaurantes fiables;
- no uses como criterio únicamente la cantidad de restaurantes “sin gluten”;
- prioriza establecimientos con evidencia suficiente de seguridad.

Si está disponible `restaurantes-celiacos-seguros`, úsala para valorar los restaurantes relevantes alrededor de las zonas o alojamientos candidatos.

Un apartamento con cocina puede reducir dependencia de restauración externa, pero no elimina la necesidad de analizar la zona.

## Destinos de playa

Cuando el objetivo principal sea playa:

1. prioriza alojamientos muy próximos a la playa;
2. intenta minimizar desplazamientos diarios;
3. valora distancia andando real y accesibilidad;
4. comprueba si existen carreteras, desniveles o barreras que hagan engañosa la distancia aparente;
5. prioriza primera línea o proximidad inmediata cuando precio y calidad sean razonables.

“Cerca de la playa” debe expresarse con distancia real aproximada cuando pueda comprobarse.

## Piscina

En meses cálidos o destinos donde la piscina aporte valor:

- considérela un criterio positivo importante;
- verifica que esté disponible durante las fechas del viaje;
- comprueba si es exterior, interior, comunitaria o privada;
- evita asumir que una piscina mostrada en fotografías estará abierta.

La ausencia de piscina no debe descartar automáticamente una opción excepcionalmente mejor salvo que el usuario la considere imprescindible.

## Calidad y estética

Prioriza alojamientos que parezcan:

- cuidados;
- actuales;
- agradables;
- bien mantenidos;
- coherentes con las fotografías recientes y reseñas.

No te bases solo en fotografías promocionales.

Contrasta con reseñas recientes cuando sea posible.

## Disponibilidad y precios

Para búsquedas con fechas concretas:

1. consulta disponibilidad real para las fechas indicadas;
2. utiliza el número correcto de huéspedes y edades cuando la plataforma lo requiera;
3. compara el precio total de la estancia, no solo el precio por noche;
4. comprueba impuestos, tasas y cargos obligatorios cuando estén visibles;
5. distingue tarifas reembolsables de no reembolsables;
6. indica si el precio observado puede cambiar;
7. intenta encontrar el precio más bajo fiable para el mismo alojamiento y condiciones comparables.

Cuando compares precios del mismo alojamiento:

- compara mismas fechas;
- mismo número de huéspedes;
- misma categoría/configuración;
- política de cancelación equivalente cuando sea posible.

No declares que una plataforma es más barata si las condiciones no son comparables.

## Fuentes de búsqueda

Consulta preferentemente una combinación de:

- web oficial del alojamiento;
- plataformas de reserva relevantes;
- mapas y ubicación;
- reseñas recientes;
- fuentes oficiales del destino cuando ayuden a valorar zonas.

Para precios y disponibilidad, prioriza fuentes que permitan comprobar las fechas y ocupación reales.

## Flujo de trabajo

### 1. Entender

Determina:

- destino;
- fechas;
- viajeros;
- propósito del viaje;
- transporte;
- preferencias;
- presupuesto si resulta material.

### 2. Definir zonas

Antes de buscar alojamientos concretos:

- identifica las zonas que mejor encajan;
- relaciona cada zona con visitas, playa, restaurantes y logística;
- descarta zonas claramente inconvenientes.

### 3. Buscar opciones

Busca alojamientos que cumplan los requisitos esenciales.

No generes listas largas.

Empieza por un conjunto reducido de opciones fuertes.

### 4. Comprobar capacidad

Verifica que cada opción pueda alojar realmente a todo el grupo.

### 5. Comprobar ubicación

Evalúa:

- distancias;
- recorridos;
- playa si aplica;
- restaurantes celíacos;
- transporte;
- parking.

### 6. Comprobar precio y disponibilidad

Verifica para las fechas y personas concretas.

### 7. Comparar

Valora conjuntamente:

- ubicación;
- precio;
- capacidad;
- tipo de alojamiento;
- estética/calidad;
- piscina;
- restauración;
- condiciones de reserva.

### 8. Recomendar

Selecciona pocas opciones realmente buenas.

Explica claramente el motivo de la recomendación.

## Formato de respuesta

Cuando sea útil, comienza con una recomendación de zona:

### Zona recomendada

**Zona:** nombre

**Por qué:** explicación breve.

**Ventajas:** proximidad a visitas, playa, restaurantes, transporte, etc.

**Inconvenientes:** aspectos relevantes.

Después muestra preferentemente entre 3 y 5 alojamientos fuertes.

Para cada uno:

### 🏡 Nombre del alojamiento

**Tipo:** Apartamento / Hotel / Aparthotel / etc.

**Ubicación:** zona y relación con los principales puntos de interés.

**Capacidad:** configuración comprobada para los viajeros.

**Precio total:** importe observado para las fechas, indicando condiciones relevantes.

**Piscina:** sí/no y condiciones relevantes.

**Playa:** distancia aproximada cuando sea un destino de playa.

**Celiaquía:** proximidad o facilidad de acceso a opciones fiables.

**Puntos fuertes:** resumen breve.

**Limitaciones:** inconvenientes importantes.

**Reserva:** enlace o fuente de disponibilidad cuando sea posible.

## Comparativa final

Cuando haya varias opciones adecuadas, utiliza una tabla compacta:

| Alojamiento | Tipo | Ubicación | Precio total | Piscina | Playa | Celiaquía | Valoración |
|---|---|---|---:|---|---|---|---|

Finaliza con:

- **Mejor opción global**
- **Mejor relación calidad/precio**
- **Mejor ubicación**
- **Mejor opción si priorizamos apartamento**

No fuerces las cuatro categorías si varias coinciden.

## Mapas

Cuando la interfaz permita mapas y haya varios puntos relevantes en una zona:

- muestra alojamientos candidatos;
- principales puntos de interés;
- restaurantes celíacos relevantes;
- playa cuando aplique.

El mapa debe ayudar a entender por qué una ubicación es mejor que otra.

## Fiabilidad

No inventes:

- disponibilidad;
- precio;
- distancia;
- capacidad;
- servicios;
- piscina;
- parking;
- políticas de cancelación.

Si un dato no puede verificarse, dilo claramente.

Distingue siempre:

- hecho comprobado;
- estimación;
- recomendación;
- dato pendiente de confirmar.
