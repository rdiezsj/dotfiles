# Librarium Terra — Estructura y normas

Este documento contiene el contexto estable de la bóveda `Librarium_Terra`. Debe usarse para recomendar una única carpeta existente y para aplicar convenciones homogéneas al generar notas.

## Estructura de carpetas

```text
00_INBOX/
00_INBOX/Clippings/

10_FAMILIA/
10_FAMILIA/Documentacion/
10_FAMILIA/Documentacion/Ana/
10_FAMILIA/Documentacion/Leo/
10_FAMILIA/Documentacion/Martin/
10_FAMILIA/Documentacion/Raul/
10_FAMILIA/Educacion/
10_FAMILIA/Educacion/Campamentos/
10_FAMILIA/Educacion/Colegio Leo/
10_FAMILIA/Educacion/Colegio Martin/
10_FAMILIA/Educacion/Extraescolares/
10_FAMILIA/Eventos/
10_FAMILIA/Familia Ext/
10_FAMILIA/Ideas de Regalos/
10_FAMILIA/Niños/
10_FAMILIA/Niños/Leo/
10_FAMILIA/Niños/Martin/
10_FAMILIA/Pareja/
10_FAMILIA/Pareja/Terapia de Pareja/
10_FAMILIA/Salud/

20_HOGAR/
20_HOGAR/Coches 🚗/
20_HOGAR/Compras/
20_HOGAR/HomeLab/
20_HOGAR/HomeLab/Infraestructura/
20_HOGAR/HomeLab/Infraestructura/Laboratorio DevOps/
20_HOGAR/HomeLab/Operaciones/
20_HOGAR/HomeLab/Redes/
20_HOGAR/HomeLab/Servicios/
20_HOGAR/Proveedores/
20_HOGAR/Recreo Industrial/

30_FINANZAS/
30_FINANZAS/Impuestos/
30_FINANZAS/Inversiones/
30_FINANZAS/Seguros/
30_FINANZAS/Vivienda/
30_FINANZAS/Vivienda/Cambio de hipoteca a ING/

40_TRABAJO/
40_TRABAJO/Nextail/
40_TRABAJO/Nextail/Autoescalado horizontal de mso-app/
40_TRABAJO/Nextail/Autoescalado horizontal de mso-app 1/
40_TRABAJO/Nextail/ERTE Nextail 2023/
40_TRABAJO/Nextail/Seguimiento ERE de Nextail 🔥/
40_TRABAJO/ParadigmaDigital/
40_TRABAJO/ParadigmaDigital/Proyectos/
40_TRABAJO/ParadigmaDigital/Proyectos/O2 Assessment/
40_TRABAJO/ParadigmaDigital/Proyectos/O2 Assessment/docs/
40_TRABAJO/ParadigmaDigital/Proyectos/O2 Assessment/Entrevistas/
40_TRABAJO/ParadigmaDigital/Proyectos/O2 Assessment/Prepracion del Assessment/
40_TRABAJO/ParadigmaDigital/Proyectos/Proy AFB (AllFunds Bank)/
40_TRABAJO/ParadigmaDigital/Proyectos/Proy AFB (AllFunds Bank)/onboarding/
40_TRABAJO/ParadigmaDigital/Proyectos/Proy AVINOR/
40_TRABAJO/ParadigmaDigital/Proyectos/Proy DPLT/
40_TRABAJO/ParadigmaDigital/Proyectos/Proy DPLT/Handover ELK/
40_TRABAJO/ParadigmaDigital/Proyectos/Proy Vitio/

50_AFICIONES/
50_AFICIONES/Cultura/
50_AFICIONES/Cultura/Libros/
50_AFICIONES/Cultura/Musica/
50_AFICIONES/Cultura/Peliculas/
50_AFICIONES/Cultura/Reflexiones/
50_AFICIONES/Entradas a Eventos/
50_AFICIONES/Fitness 💪🏻/
50_AFICIONES/Gaming 🎮/
50_AFICIONES/Gaming 🎮/D&D Junior/
50_AFICIONES/Gaming 🎮/D&D Simplificado/
50_AFICIONES/Gaming 🎮/Warhammer 40K/
50_AFICIONES/Gaming 🎮/Warhammer 40K simplificado/
50_AFICIONES/Gastronomia/
50_AFICIONES/Gastronomia/Quesos/
50_AFICIONES/Gastronomia/Recetas/
50_AFICIONES/Gastronomia/Restaurantes/
50_AFICIONES/Gastronomia/Vinos/
50_AFICIONES/Semana Santa/
50_AFICIONES/Viajes/
50_AFICIONES/Viajes/2025-07-25 Viaje a Oporto/
50_AFICIONES/Viajes/Escapada a Madrid 2026-12-18/
50_AFICIONES/Viajes/Portugal/

60_CONOCIMIENTO/
60_CONOCIMIENTO/Desarrollo/
60_CONOCIMIENTO/Desarrollo/Python/
60_CONOCIMIENTO/IA/
60_CONOCIMIENTO/IA/Agentes/
60_CONOCIMIENTO/IA/Herramientas/
60_CONOCIMIENTO/IA/Prompts/
60_CONOCIMIENTO/Infraestructura/
60_CONOCIMIENTO/Infraestructura/Almacenamiento/
60_CONOCIMIENTO/Infraestructura/Cloud/
60_CONOCIMIENTO/Infraestructura/Contenedores/
60_CONOCIMIENTO/Infraestructura/Formacion/
60_CONOCIMIENTO/Infraestructura/Git/
60_CONOCIMIENTO/Infraestructura/Gitlab/
60_CONOCIMIENTO/Infraestructura/Kubernetes/
60_CONOCIMIENTO/Infraestructura/Linux/
60_CONOCIMIENTO/Infraestructura/Windows/
60_CONOCIMIENTO/Observabilidad/
60_CONOCIMIENTO/Productividad/
60_CONOCIMIENTO/Productividad/40 Preguntas anuales/
60_CONOCIMIENTO/Referencias/
60_CONOCIMIENTO/Referencias/Apple/
60_CONOCIMIENTO/Referencias/Manuales Lego/
60_CONOCIMIENTO/Referencias/TV/

90_ARCHIVO/
_assets/
Evernote-por-reorganizar/
```

## Reglas detalladas de ubicación

- `10_FAMILIA`: información de personas, educación, actividades, eventos familiares, pareja y salud.
- `20_HOGAR/HomeLab/Infraestructura`: hardware y base del laboratorio doméstico.
- `20_HOGAR/HomeLab/Operaciones`: procedimientos operativos, mantenimiento y runbooks del HomeLab.
- `20_HOGAR/HomeLab/Redes`: topología, VPN, DNS, Wi-Fi, segmentación y conectividad doméstica.
- `20_HOGAR/HomeLab/Servicios`: aplicaciones y servicios autoalojados, como Jellyfin, backups o automatizaciones.
- `40_TRABAJO`: información específica de empresas, clientes y proyectos concretos.
- `60_CONOCIMIENTO`: conocimiento reutilizable sin dependencia de una organización o proyecto.
- `90_ARCHIVO`: solo para información cerrada o histórica.
- `_assets`: no es una ubicación de notas; es solo para recursos adjuntos.

## Convención de nombres de archivo

- Conocimiento permanente: sin fecha. Ejemplo: `saml2aws - Uso y configuración.md`.
- Eventos, viajes, reuniones, decisiones fechadas o registros: `YYYY-MM-DD Título.md`.
- Evitar títulos genéricos: `Notas`, `Apuntes`, `Información`, `Varios` o `Guía`.
- Mantener nombres de producto, servicio, proyecto y terminología técnica.
- No crear subdirectorios para una única nota.

## Ejemplos de clasificación

| Tema                                | Carpeta                                                     |
| ----------------------------------- | ----------------------------------------------------------- |
| Uso genérico de saml2aws con SSO    | `60_CONOCIMIENTO/Infraestructura/Cloud/`                    |
| Runbook del MCP de O2               | `40_TRABAJO/ParadigmaDigital/Proyectos/O2 Assessment/docs/` |
| Configuración doméstica de Jellyfin | `20_HOGAR/HomeLab/Servicios/Jellyfin`                       |
| Restaurante sin gluten en León      | `50_AFICIONES/Gastronomia/Restaurantes/`                    |
| Comparativa de cambio de hipoteca   | `30_FINANZAS/Vivienda/`                                     |
| Reunión familiar sin clasificar     | `00_INBOX/`                                                 |
| Guía general de Git rebase          | `60_CONOCIMIENTO/Infraestructura/Git/`                      |

## Plantilla base de nota técnica

```markdown
---
estado: borrador
creado: YYYY-MM-DD
actualizado: YYYY-MM-DD
tipo: [guia]
aliases: []
tags: []
---

# Título

> [!summary]
> Resumen breve, concreto y orientado al uso.

## Contexto

## Requisitos

## Instalación

## Configuración

## Operación

## Comandos de referencia

## Problemas frecuentes

## Fuentes
```

La plantilla se adapta al tipo de nota: no conservar secciones vacías ni forzar apartados técnicos cuando el tema no lo requiera.
