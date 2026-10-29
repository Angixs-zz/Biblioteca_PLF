# Cuentas Claras — Reparto de gastos comunes

**Alternativa para proyecto de PLF en parejas: Miguel Ángel Hernández Pérez y Yareli.**

Compañeros de vivienda, familias o equipos pueden introducir cuánto pagó cada persona en gastos comunes. El programa calcula la parte que corresponde a cada una y propone transferencias para saldar las diferencias. Su utilidad social es facilitar acuerdos claros y evitar errores al repartir gastos.

## Uso

Desde esta carpeta, con SWI-Prolog instalado:

```bash
swipl -q -s cuentas.pl -g cuentas:menu -t halt
```

Menú: 1 introducir los gastos de 2 a 20 personas; 2 demostración; 3 ayuda; 0 salir. Cada persona recibe un identificador según el orden de entrada. Introduce importes en centavos enteros: $125.50 se escribe `12550`.

Ejemplo ficticio: Ana pagó $300, Luis $100 y Sol $200. El gasto común es $600 y a cada uno le corresponde $200. El programa propone que Luis pague $100 a Ana; Sol ya está a mano.

## Lógica del proyecto

- La entrada es una lista de hechos temporales `Persona-Centavos`.
- `valido/1` comprueba personas únicas e importes enteros no negativos.
- `reparto/2` suma lo pagado y deduce cuánto recibe o aporta cada persona.
- `balances/4` distribuye la cuota y los centavos sobrantes por orden de entrada.
- `transferencias/2` relaciona deudores y acreedores.
- `saldar/3` resuelve las transferencias por recursión, conservando exactamente el dinero.

Consulta: `cuentas:transferencias([ana-30000,luis-10000,sol-20000],Pagos).`

Pruebas: `swipl -q -s pruebas.pl -g run_tests -t halt`.

Todas las personas comparten todos los gastos por igual. Cada aporte representa dinero ya gastado en bienes o servicios comunes; no debe incluir ahorros, depósitos ni gastos individuales. Las transferencias se muestran como propuesta y no se ejecutan. El programa no guarda los datos. El equipo puede repartirse interfaz y ejemplos, por un lado, y reglas de reparto y pruebas, por el otro.

## Verificación de esta versión

7 pruebas automáticas correctas con SWI-Prolog 9.0.4. Se verificó además un recorrido completo del menú con entrada simulada y salida correcta.
