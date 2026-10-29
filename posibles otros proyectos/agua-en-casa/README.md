# Agua en Casa — Calculador de consumo y ahorro

**Alternativa para proyecto de PLF en parejas: Miguel Ángel Hernández Pérez y Yareli.**

Una familia puede medir cuánto agua utiliza una actividad y comparar el efecto de reducir su duración. Ayuda a tomar decisiones con cantidades comprensibles: litros diarios y litros durante el periodo elegido. Puede emplearse en viviendas o en actividades escolares de cuidado del agua.

## Uso

Desde esta carpeta, con SWI-Prolog instalado:

```bash
swipl -q -s agua.pl -g agua:menu -t halt
```

Menú: 1 comparar una rutina propia; 2 ver demostración; 3 ayuda; 0 salir. Introduce caudal en litros por minuto, duración actual y propuesta, usos diarios totales y días a comparar. Para medir el caudal, divide los litros recogidos entre los minutos transcurridos. Los datos solo permanecen durante la consulta.

Ejemplo ficticio: 8 L/min, de 10 a 6 minutos, un uso diario y 30 días produce 2400 L antes y 1440 L después: diferencia de 960 L, equivalente al 40 % del consumo inicial. Si aumentas la duración, la diferencia es negativa; si el consumo inicial es cero, el porcentaje se marca sin base.

## Lógica del proyecto

- `actividad/4`: tres actividades ficticias para la demostración.
- `consumo/4`: relaciona caudal, minutos y frecuencia; calcula litros diarios.
- `escenario/6`: proyecta los dos consumos durante los días indicados.
- `ahorro/4`: deduce diferencia y porcentaje sin dividir por cero.
- `mayor_consumo/2`: identifica la actividad de mayor consumo entre las cantidades comparadas; en empate elige por orden del nombre.

Consulta: `agua:escenario(8,10,6,1,30,Resultado).`

Pruebas: `swipl -q -s pruebas.pl -g run_tests -t halt`.

El resultado corresponde únicamente a la actividad introducida, con caudal y frecuencia constantes. Los ejemplos no son promedios oficiales; no se calculan tarifas ni se asegura un ahorro real si los hábitos o el caudal cambian. El equipo puede repartirse la captura y el menú, por un lado, y las reglas y la validación, por el otro.

## Verificación de esta versión

5 pruebas automáticas correctas con SWI-Prolog 9.0.4. Se verificó además un recorrido completo del menú con entrada simulada y salida correcta.
