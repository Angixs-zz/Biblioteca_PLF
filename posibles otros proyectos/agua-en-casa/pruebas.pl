:- use_module(library(plunit)).
:- use_module(library(debug)).
:- use_module(library(lists)).
:- use_module(agua).
:- begin_tests(agua).
test(escenario_realizable) :- escenario(8,10,6,1,30,A-D), assertion(A=:=2400), assertion(D=:=1440).
test(aumento_no_es_ahorro) :- ahorro(100,120,L,P), assertion(L=:= -20), assertion(P=:= -20).
test(cero_sin_division) :- ahorro(0,0,0,sin_base).
test(rechazar_negativos,[fail]) :- consumo(-1,3,1,_).
test(mayor_entre_actividades) :- mayor_consumo([ducha-80,trastes-60,manos-24],ducha-80).
:- end_tests(agua).
