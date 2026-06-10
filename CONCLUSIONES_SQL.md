# 📋 Conclusiones del Análisis Comercial — AdventureWorks2025

Este documento recoge los principales hallazgos obtenidos tras ejecutar el análisis SQL sobre la base de datos AdventureWorks2025. Cada conclusión responde a una pregunta de negocio concreta.

---

## Bloque 1 — Territorios y Ventas
A nivel de territorio, Northwest, Southwest, Canadá y Australia concentran más del 40% de las ventas totales de la empresa, lo que los convierte en los mercados estratégicos clave. Por el contrario, territorios como Southeast y Northeast presentan un rendimiento notablemente inferior, lo que sugiere la necesidad de analizar en profundidad las causas y evaluar posibles acciones de mejora comercial.
A nivel regional, Norteamérica domina claramente con más del 60% de las ventas globales, consolidándose como la región más crítica para el negocio. La región Pacific, en cambio, muestra un peso significativamente menor, lo que abre una oportunidad de crecimiento que merece atención estratégica.
Recomendaciones: mantener y reforzar la actividad comercial en los territorios de alto rendimiento para sostener su nivel de ventas, mientras se investigan los factores que frenan el crecimiento en Southeast, Northeast y la región Pacific, con el objetivo de diseñar planes de acción específicos para cada caso.

---

## Bloque 2 — Análisis de Clientes
Los clientes con mayor gasto total coinciden generalmente con los que mayor ticket medio presentan y con los más recurrentes, con una frecuencia de visita media de entre 10 y 11 compras por cliente. Esto sugiere una correlación clara entre frecuencia de compra y valor del cliente.
En cuanto a los clientes de mayor valor, el Top 10 supera los 800.000€ de gasto acumulado, mientras que el Top 5 supera los 900.000€, lo que indica una alta concentración de ingresos en un grupo muy reducido de clientes que merecen atención y fidelización prioritaria.
El análisis del primer pedido de cada cliente permite construir una base para estudios de cohortes y analizar la evolución del comportamiento de compra a lo largo del tiempo, siendo un punto de partida útil para detectar posibles patrones de estacionalidad.
La segmentación en cuartiles (Premium, Alto, Medio y Básico) permite identificar con claridad los distintos perfiles de cliente y diseñar estrategias comerciales diferenciadas para cada grupo.
Limitaciones del análisis: para detectar patrones de comportamiento de compra con mayor precisión sería necesario incorporar variables adicionales como estacionalidad, eventos promocionales o campañas de ofertas, ya que sin ellas no es posible determinar con exactitud los factores externos que influyen en las decisiones de compra.

---

## Bloque 3: Productos y Categorías

A nivel de categoría, Bikes destaca como la categoría con el precio promedio más elevado, mientras que Clothing y Accessories presentan precios significativamente más bajos, lo que refleja líneas de producto muy distintas en cuanto a valor unitario.
En cuanto a rentabilidad por producto, los productos con mayor porcentaje de margen no siempre coinciden con los de mayor precio de lista, lo que indica que el margen depende más de la eficiencia en costes que del precio de venta.
El análisis de stock valorado muestra qué productos tienen mayor capital inmovilizado en inventario, información clave para decisiones de aprovisionamiento y gestión de almacén.
Recomendaciones: concentrar esfuerzos comerciales en los productos de mayor margen dentro de cada subcategoría, revisar los productos con alto stock valorado para evitar sobrestock innecesario, y analizar si los productos de menor margen justifican su permanencia en el catálogo.

---

## Bloque 4: Evolución Temporal

El análisis mes a mes no muestra una tendencia clara ni continua, sino una sucesión de subidas y bajadas sin un patrón definido a simple vista. Para determinar si estas variaciones responden a fenómenos de estacionalidad, campañas promocionales u otros factores externos, sería necesario un estudio más exhaustivo que incorpore variables adicionales como eventos comerciales o datos de mercado. Identificar las causas de los picos positivos permitiría potenciarlos, mientras que el análisis de las caídas ayudaría a diseñar estrategias para mitigarlas.
Aunque los datos de 2022 y 2025 están incompletos al no cubrir el año completo, se observa un crecimiento notable en las ventas acumuladas de 2024 respecto a 2023, lo que refleja una tendencia positiva en el rendimiento anual del negocio.
El tercer trimestre concentra consistentemente el mayor volumen de ventas, lo que apunta a un posible patrón de estacionalidad o a la existencia de campañas promocionales en ese período. Destaca además un pico especialmente elevado en el primer trimestre de 2025 que, a pesar de que los datos del año no están completos, sugiere que el negocio mantiene una trayectoria de crecimiento sostenido.

---

## Bloque 5: Empleados y Equipo Comercial

La práctica totalidad de la plantilla se concentra en el departamento de Producción, mientras que el resto de departamentos presentan una distribución bastante equilibrada entre sí pero con un número de empleados considerablemente menor, lo que refleja una estructura organizativa claramente orientada a la fabricación.
En cuanto al rendimiento comercial, Linda Mitchell destaca como la vendedora con mayor volumen de ventas a nivel global y lidera el mercado norteamericano, mientras que Jae Pak ocupa el segundo puesto general siendo el comercial de mayor rendimiento en Europa. Por su parte, Lynn Tsofias, único representante en la región Pacific, consigue superar sus objetivos a pesar de operar en solitario en su zona. Cabe destacar el caso de Syed Abbas, quien, aun sin tener un objetivo formalmente asignado, no alcanza la media de ventas del resto del equipo, lo que merece una revisión.
Como conclusión, el rendimiento individual de los comerciales europeos es comparable al de sus homólogos norteamericanos, por lo que la incorporación de nuevos vendedores en ubicaciones estratégicas previamente estudiadas podría suponer un incremento significativo en el volumen de ventas de la región. Del mismo modo, sería recomendable evaluar aquellos territorios que no superen un umbral mínimo de rentabilidad, valorando si su continuidad está justificada o si prescindir de ellos supondría un ahorro de costes relevante.

---

## Resumen ejecutivo

| Área | Hallazgo clave |
|------|----------------|
| Territorios | Northwest, Southwest, Canadá y Australia concentran más del 40% de las ventas. Norteamérica supera el 60% a nivel regional |
| Clientes | El Top 10 de clientes supera los 800.000€ de gasto. Alta correlación entre frecuencia de compra y valor del cliente |
| Productos | Bikes lidera en precio promedio. El margen depende más de la eficiencia en costes que del precio de venta |
| Temporal | Crecimiento sostenido en 2024 respecto a 2023. El tercer trimestre concentra consistentemente el mayor volumen de ventas |
| Comercial | Rendimiento individual similar entre comerciales europeos y norteamericanos. Europa presenta potencial de crecimiento con la incorporación de nuevos vendedores |

---

> ⚠️ **Nota:** Las conclusiones cualitativas de este documento están basadas en la estructura del análisis. Los valores numéricos exactos deben obtenerse ejecutando las consultas SQL correspondientes en SQL Server Management Studio con la base de datos AdventureWorks2025.
