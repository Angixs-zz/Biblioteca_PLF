:- use_module(library(plunit)).
:- use_module(library(debug)).
:- use_module(library(lists)).
:- use_module(cuentas).
:- begin_tests(cuentas).
test(transferencia_completa) :- transferencias([ana-30000,luis-10000,sol-20000],[pago(luis,ana,10000)]).
test(centavo_residual) :- reparto([a-1,b-0,c-0],[a-0,b-0,c-0]).
test(conserva_total) :- reparto([a-100,b-0,c-0],B), findall(V,member(_-V,B),Vs),sum_list(Vs,0).
test(a_mano) :- transferencias([a-100,b-100],[]).
test(sin_duplicados,[fail]) :- reparto([a-100,a-0],_).
test(rechazar_negativos,[fail]) :- reparto([a-100,b-(-1)],_).
test(saldar_varias_personas) :- transferencias([a-800,b-400,c-0,d-0],[pago(c,a,300),pago(d,a,200),pago(d,b,100)]).
:- end_tests(cuentas).
