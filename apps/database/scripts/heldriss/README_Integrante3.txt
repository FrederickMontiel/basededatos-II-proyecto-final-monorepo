INTEGRANTE 3 - OPORTUNIDADES
Proyecto Final Base de Datos II
Empresa: Innovacion, S.A.
Base de datos: InnovacionCRM

Contenido de la entrega:

1. 01_funciones_oportunidades.sql
Contiene las funciones para calcular el monto ponderado y obtener el porcentaje de avance segun la etapa seleccionada.

2. 02_procedimientos_oportunidades.sql
Contiene los procedimientos almacenados para crear, actualizar, cambiar etapa y cerrar oportunidades.

3. 03_triggers_oportunidades.sql
Contiene los triggers que validan que una oportunidad solo pueda cerrarse como ganada o perdida si esta al 100%, y que exige comentario obligatorio al cerrar una oportunidad.

4. 04_validaciones_y_pruebas.sql
Contiene datos de prueba y ejecuciones para demostrar el funcionamiento de las funciones, procedimientos, triggers y validaciones.

Orden de ejecucion:

1. Ejecutar primero el script principal del grupo: DB _ INNOVA.sql
2. Ejecutar 01_funciones_oportunidades.sql
3. Ejecutar 02_procedimientos_oportunidades.sql
4. Ejecutar 03_triggers_oportunidades.sql
5. Ejecutar 04_validaciones_y_pruebas.sql

Resultado esperado:

El sistema permite crear una oportunidad, calcular automaticamente su porcentaje de avance y monto ponderado, cambiar la etapa de la oportunidad y cerrarla como ganada o perdida solamente cuando alcanza el 100%.

Tambien valida que el cierre tenga comentario obligatorio y que el porcentaje de avance corresponda a la etapa seleccionada.