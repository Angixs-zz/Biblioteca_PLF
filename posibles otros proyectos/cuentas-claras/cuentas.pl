:- encoding(utf8).
:- module(cuentas, [menu/0, reparto/2, transferencias/2]).
:- use_module(library(readutil)).
:- use_module(library(lists)).
:- use_module(library(apply)).

% Cada par Persona-Centavos indica gastos comunes ya pagados por esa persona.
% Todo el gasto se comparte entre todas las personas, en partes iguales.
% Se reparte el residuo de centavos en el orden de entrada.
valido(Pares) :-
    Pares = [_|_],
    forall(member(P-C,Pares), (atom(P), integer(C), C >= 0)),
    findall(P, member(P-_,Pares), Nombres), sort(Nombres, Unicos),
    length(Nombres,N), length(Unicos,N).
reparto(Pares, Balances) :-
    valido(Pares), pairs_values_local(Pares, Cantidades), sum_list(Cantidades,Total),
    length(Pares,N), Base is Total // N, Residuo is Total mod N,
    balances(Pares, Base, Residuo, Balances).
pairs_values_local([], []).
pairs_values_local([_-C|Ps], [C|Cs]) :- pairs_values_local(Ps,Cs).
balances([], _, _, []).
balances([P-C|Ps], Base, R, [P-B|Bs]) :-
    (R > 0 -> Cuota is Base+1, R2 is R-1 ; Cuota=Base, R2=0),
    B is C-Cuota, balances(Ps,Base,R2,Bs).

% Positivo = debe recibir. Negativo = debe aportar. Siempre suman cero.
transferencias(Pares, Pagos) :-
    reparto(Pares, B),
    findall(P-C, (member(P-V,B), V<0, C is -V), Deudores),
    findall(P-V, (member(P-V,B), V>0), Acreedores),
    saldar(Deudores,Acreedores,Pagos).
saldar([], [], []).
saldar([D-M|Ds], [A-N|As], [pago(D,A,C)|Pagos]) :-
    C is min(M,N), R is M-C, S is N-C,
    (R =:= 0 -> DD=Ds ; DD=[D-R|Ds]),
    (S =:= 0 -> AA=As ; AA=[A-S|As]),
    saldar(DD,AA,Pagos).

entero(Texto, Min, Max, N) :-
    repeat, format('~w ', [Texto]), read_line_to_string(user_input,S),
    (S == end_of_file -> throw(fin)
    ; catch(number_string(V,S),_,fail), integer(V), between(Min,Max,V) -> N=V, !
    ; writeln('Escribe un entero dentro del rango indicado.'), fail).
leer_aportes(I,N,[]) :- I>N, !.
leer_aportes(I,N,[Persona-C|Ps]) :-
    format(atom(Persona),'persona_~d',[I]),
    format('~w: ',[Persona]),
    entero('Gasto comun pagado en CENTAVOS (0-100000000):',0,100000000,C),
    J is I+1, leer_aportes(J,N,Ps).
mostrar(Pares) :-
    reparto(Pares, B), transferencias(Pares, Pagos),
    writeln('Saldos (positivo recibe; negativo aporta):'),
    forall(member(P-C,B), (Pesos is C/100, format('~w: $~2f~n',[P,Pesos]))),
    (Pagos=[] -> writeln('Ya estan a mano.')
    ; forall(member(pago(D,A,C),Pagos),
        (Pesos is C/100, format('~w paga $~2f a ~w.~n',[D,Pesos,A])))).
accion(1) :- entero('Numero de personas (2-20):',2,20,N),
             leer_aportes(1,N,Pares), mostrar(Pares).
accion(2) :-
    writeln('Ejemplo ficticio: Ana pago $300, Luis $100 y Sol $200 de gastos comunes.'),
    mostrar([ana-30000,luis-10000,sol-20000]).
accion(3) :-
    writeln('Solo introduce gastos comunes ya pagados; toda persona comparte todo el gasto.'),
    writeln('Ejemplo: $125.50 se escribe 12550 centavos. No escribas un punto decimal.'),
    writeln('Los centavos sobrantes se asignan en orden de entrada.'),
    writeln('Las transferencias son propuestas; el programa no envia dinero ni guarda datos.').
menu :- catch(bucle,fin,true).
bucle :-
    writeln('=== CUENTAS CLARAS ==='),
    writeln('1. Repartir gastos  2. Demostracion  3. Ayuda  0. Salir'),
    entero('Opcion (0-3):',0,3,O),
    (O=:=0 -> true ; accion(O), bucle).
