

[Informedashboard.docx](https://github.com/user-attachments/files/28594269/Informedashboard.docx)





Dashboard Analítico para el Mundial de Fútbol FIFA 2026:
Análisis Estadístico de Selecciones y Jugadores basado en Datos Históricos

Ricardo Gabriel Castro Abad

Máster en Análisis de Datos
Tutores: Joan Gasull y Xavier González

2026

Resumen
El presente trabajo propone el diseño y desarrollo de un dashboard analítico interactivo para el análisis estadístico de las 48 selecciones del Mundial FIFA 2026. Construido sobre Power BI con base de datos MySQL y datos obtenidos mediante web scraping de Sofascore, permite explorar el rendimiento histórico de equipos y jugadores en los últimos cuatro años. El dashboard incluye tres módulos: fixture y grupos del torneo, análisis de equipo y análisis individual de jugadores. Los resultados identifican patrones ofensivos y defensivos diferenciados, correlaciones entre métricas de construcción de juego y efectividad ofensiva, y perfiles estadísticos de jugadores. 

Introducción
El fútbol moderno ha experimentado una transformación en su aproximación al análisis del juego, siendo la estadística un elemento central en la preparación táctica de los equipos de élite. En el contexto del Mundial FIFA 2026, con 48 selecciones participantes, la capacidad de analizar rápidamente el perfil estadístico de un rival puede representar una ventaja competitiva significativa. Sin embargo, las herramientas de análisis profesional suelen estar reservadas a organizaciones con grandes presupuestos. Este proyecto propone una solución accesible, construida con herramientas de código abierto y datos públicos, que permita analizar cualquiera de los 48 equipos participantes y sus jugadores a partir de datos reales de los últimos cuatro años. La herramienta está orientada tanto a analistas especializados como a aficionados, e incluye vínculos directos a Sofascore (2022-2026) para ampliar la información disponible.

Metodología

Fuentes de datos

Los datos provienen de Sofascore (2022-2026), obtenidos mediante web scraping en Python. Se recopilaron estadísticas de partidos, métricas individuales de jugadores, mapas de calor y coordenadas de tiros del período 2022-2026. El proceso de extracción fue técnicamente complejo: la plataforma aplica mecanismos de protección que pueden interrumpir la recolección sin advertencia, generando registros incompletos que requirieron validación y limpieza iterativa. No todas las métricas de Sofascore son accesibles gratuitamente, lo que limitó el alcance de algunas visualizaciones.

Arquitectura del sistema

El sistema se estructura en tres capas. La capa de almacenamiento comprende una base de datos MySQL con 11 tablas principales (partidos, stats_jugador, stats_partido, alineaciones, dim_jugadores, selecciones, fixture_mundial, estadios_mundial, base_camps_mundial, fotos_jugadores, heatmap_jugador) y ocho vistas SQL optimizadas (v_mapa_tiros, v_heatmap_jugador, v_analisis_ataque, v_analisis_defensa, v_correlacion_partidos, v_pairplot_jugadores, v_top_jugadores, v_mapa_mundial). La capa de procesamiento incluye scripts Python con pandas, numpy, scipy, matplotlib y seaborn para ETL y análisis estadístico. La capa de visualización es Microsoft Power BI con medidas DAX, visualizaciones Python embebidas, Vega-Lite mediante Deneb para gráficos interactivos y HTML personalizado para tarjetas de jugadores. La base contiene ~2.098 partidos, 48 selecciones y datos de más de 100 equipos nacionales.



Estructura del dashboard
El dashboard se organiza en tres páginas. La primera presenta los grupos del torneo con acceso directo al análisis de cada equipo. La segunda página analiza cualquiera de las 48 selecciones mediante KPIs de rendimiento, scatter plots con regresión lineal, matrices de correlación, comparativas entre primer y segundo tiempo, heatmap de posicionamiento colectivo y análisis textual basado en reglas condicionales sobre los indicadores calculados. La tercera ofrece análisis individual de jugadores con 16 estadísticas promediadas, mapa de tiros georreferenciado, heatmap individual con suavizado gaussiano y pairplots multivariantes por posición 
Técnicas de análisis
Se aplicaron correlación de Pearson entre métricas de partido, regresión lineal simple para tendencias entre variables (pases-tiros, tiros-goles), boxplots por posición para comparar perfiles estadísticos, scatter matrix para análisis multivariante ofensivo y defensivo, suavizado gaussiano  para mapas de calor, y adaptaciones específicas para superar las limitaciones de interactividad de los visuals Python en Power BI.

Resultados
Análisis de equipo
El módulo de análisis de equipo permite visualizar el perfil estadístico completo de cualquier selección. La correlación entre pases precisos y tiros totales presenta valores moderados-altos  en equipos de posesión, mientras que en equipos más directos esta relación es más débil. La correlación entre tiros recibidos y goles encajados permite identificar la solidez defensiva. La comparación entre primer y segundo tiempo revela si un equipo mantiene la intensidad a lo largo del partido o presenta caídas en la segunda parte. La matriz de correlación entre ocho variables de partido (posesión, pases, tiros, grandes ocasiones, duelos, recuperaciones, entradas al tercio rival y goles) muestra patrones diferenciados por estilo de juego y confederación.

Análisis de jugadores
El módulo individual ofrece un perfil con 16 estadísticas promediadas por partido: métricas ofensivas (goles, asistencias, tiros totales, tiros a puerta, pases totales, pases precisos, pases clave), defensivas (recuperaciones, intercepciones, entradas, despejes) y físicas (duelos ganados, duelos aéreos, faltas recibidas, faltas cometidas). Los mapas de calor muestran las zonas de mayor presencia de cada jugador, normalizadas según condición de local o visitante. Los pairplots comparan simultáneamente todos los jugadores del equipo en cuatro dimensiones ofensivas o defensivas, con codificación de color por posición.
Discusión
Los resultados demuestran la viabilidad de construir herramientas de análisis futbolístico de calidad con datos públicos y herramientas de acceso libre. El dashboard proporciona una visión estructurada del perfil estadístico de cualquier selección, útil para la preparación de partidos y la identificación de rivales potenciales en las fases eliminatorias (Pappalardo et al., 2019). La inclusión de vínculos a Sofascore (2022-2026) amplía la información disponible. Las principales limitaciones son la cobertura desigual entre confederaciones, la ausencia de métricas avanzadas como Expected Goals o redes de pases entre jugadores, y las restricciones de interactividad de los visuals Python en Power BI, que requirieron el uso de Vega-Lite como alternativa. Desde la perspectiva empresarial, el trabajo demuestra cómo la analítica deportiva puede democratizarse; una versión con datos de pago como StatsBomb u Opta permitiría insights más precisos para entornos profesionales (Anthropic, 2024; OpenAI, 2024).

Conclusión

Este proyecto ha demostrado la viabilidad de construir un sistema de análisis estadístico de fútbol completo y accesible para las 48 selecciones del Mundial FIFA 2026. El dashboard integra Python, MySQL, Power BI, DAX, Vega-Lite y HTML para ofrecer una experiencia de análisis intuitiva, cubriendo desde el perfil colectivo hasta el detalle individual de cada jugador. El proceso de extracción de datos constituyó un desafío técnico relevante: la obtención de grandes volúmenes de información de plataformas con mecanismos de protección requiere scripts robustos, manejo de errores silenciosos y validación continua, aspectos frecuentemente subestimados que consumieron una parte significativa del tiempo del proyecto. De cara al futuro, la incorporación de fuentes de datos de pago permitiría añadir métricas avanzadas actualmente no disponibles, y la integración de un módulo predictivo basado en simulaciones Monte Carlo complementaría el análisis descriptivo con proyecciones probabilísticas. El trabajo sienta las bases de una plataforma analítica escalable y de código abierto para el análisis de fútbol internacional.

Referencias
Sofascore. Estadísticas de partidos y jugadores de selecciones nacionales [Base de datos]. Sofascore. https://www.sofascore.com

Objetivo Analista. (2023-2024). Análisis de datos en fútbol con Python [Canal de YouTube]. https://www.youtube.com/objetivoanalista

LanusStats.  Visualización de datos de fútbol con Python [Canal de YouTube]. https://www.youtube.com/LanusStats

OpenAI. ChatGPT (versión GPT-4o) [Modelo de inteligencia artificial]. OpenAI. https://www.openai.com

Anthropic. Claude (versión claude-sonnet-4) [Modelo de inteligencia artificial]. Anthropic. https://www.anthropic.com





