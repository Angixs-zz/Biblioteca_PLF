/*
   Sistema experto de recomendacion de libros (SWI-Prolog).
   Seis conjuntos principales (al menos 50 hechos en cada uno):
   estudiante/2, preferencia/6, libro/7, autor/2,
   libro_autor/2 y recomendacion_guardada/3.
   Cuatro catalogos pequenos: nivel/2, genero/2, tema/2, formato/2.
   Las personas, sus perfiles y recomendaciones guardadas son datos de ejemplo.
   libro(Id, Titulo, Genero, Nivel, Tema, Formato, Editorial).
   El formato es un dato de ejemplo para el ejercicio, no disponibilidad real.
   La editorial depende de la edicion; pendiente_de_verificar no es un nombre editorial.
*/

:- encoding(utf8).

% La primera columna es la clave usada por libros y preferencias.
nivel(basico, 'Básico').
nivel(intermedio, 'Intermedio').
nivel(avanzado, 'Avanzado').

genero(divulgacion, 'Divulgación').
genero(ensayo, 'Ensayo').
genero(manual, 'Manual').
genero(novela, 'Novela').

tema(matematicas, 'Matemáticas').
tema(tecnologia, 'Tecnología').
tema(fisica, 'Física').
tema(biologia, 'Biología').
tema(historia, 'Historia').
tema(literatura, 'Literatura').
tema(filosofia, 'Filosofía').
tema(economia, 'Economía').
tema(psicologia, 'Psicología').
tema(arte, 'Arte').
tema(guerra, 'Guerra y conflictos').

formato(fisico, 'Físico').
formato(digital, 'Digital').

% Matematicas
libro(1, 'El hombre que calculaba', divulgacion, basico, matematicas, fisico, pendiente_de_verificar).
libro(2, 'El diablo de los numeros', divulgacion, basico, matematicas, digital, pendiente_de_verificar).
libro(3, 'Una breve historia de las matematicas', divulgacion, intermedio, matematicas, fisico, pendiente_de_verificar).
libro(4, 'El placer de la x', divulgacion, basico, matematicas, digital, pendiente_de_verificar).
libro(5, 'Como no equivocarse', ensayo, intermedio, matematicas, fisico, pendiente_de_verificar).

% Tecnologia
libro(6, 'Clean Code', manual, intermedio, tecnologia, fisico, pendiente_de_verificar).
libro(7, 'The Pragmatic Programmer', manual, intermedio, tecnologia, digital, pendiente_de_verificar).
libro(8, 'Code', divulgacion, basico, tecnologia, fisico, pendiente_de_verificar).
libro(9, 'Algorithms', manual, avanzado, tecnologia, digital, pendiente_de_verificar).
libro(10, 'La cuarta revolucion industrial', ensayo, basico, tecnologia, fisico, pendiente_de_verificar).

% Fisica
libro(11, 'Breve historia del tiempo', divulgacion, basico, fisica, fisico, pendiente_de_verificar).
libro(12, 'Siete breves lecciones de fisica', divulgacion, basico, fisica, digital, pendiente_de_verificar).
libro(13, 'El universo en una cascara de nuez', divulgacion, intermedio, fisica, fisico, pendiente_de_verificar).
libro(14, 'El tejido del cosmos', divulgacion, intermedio, fisica, digital, pendiente_de_verificar).
libro(15, 'Fisica universitaria', manual, avanzado, fisica, fisico, pendiente_de_verificar).

% Biologia
libro(16, 'El gen egoista', divulgacion, intermedio, biologia, fisico, pendiente_de_verificar).
libro(17, 'El origen de las especies', ensayo, avanzado, biologia, digital, pendiente_de_verificar).
libro(18, 'La vida maravillosa', divulgacion, intermedio, biologia, fisico, pendiente_de_verificar).
libro(19, 'La doble helice', divulgacion, basico, biologia, digital, pendiente_de_verificar).
libro(20, 'Biologia', manual, avanzado, biologia, fisico, pendiente_de_verificar).

% Historia
libro(21, 'Sapiens', divulgacion, basico, historia, fisico, pendiente_de_verificar).
libro(22, 'Armas, germenes y acero', ensayo, intermedio, historia, digital, pendiente_de_verificar).
libro(23, 'Historia del siglo XX', ensayo, avanzado, historia, fisico, pendiente_de_verificar).
libro(24, 'El mundo de ayer', ensayo, intermedio, historia, digital, pendiente_de_verificar).
libro(25, 'La guerra que salvo mi vida', novela, basico, guerra, fisico, pendiente_de_verificar).

% Literatura
libro(26, 'El principito', novela, basico, literatura, fisico, pendiente_de_verificar).
libro(27, 'Cien anos de soledad', novela, intermedio, literatura, digital, pendiente_de_verificar).
libro(28, 'Don Quijote de la Mancha', novela, avanzado, literatura, fisico, pendiente_de_verificar).
libro(29, 'La metamorfosis', novela, intermedio, literatura, digital, pendiente_de_verificar).
libro(30, 'La sombra del viento', novela, avanzado, literatura, fisico, pendiente_de_verificar).

% Filosofia
libro(31, 'El mundo de Sofia', novela, basico, filosofia, fisico, pendiente_de_verificar).
libro(32, 'Meditaciones', ensayo, intermedio, filosofia, digital, pendiente_de_verificar).
libro(33, 'El mito de Sisifo', ensayo, avanzado, filosofia, fisico, pendiente_de_verificar).
libro(34, 'Etica para Amador', divulgacion, basico, filosofia, digital, pendiente_de_verificar).
libro(35, 'La republica', ensayo, avanzado, filosofia, fisico, pendiente_de_verificar).

% Economia
libro(36, 'Freakonomics', divulgacion, basico, economia, fisico, pendiente_de_verificar).
libro(37, 'El economista camuflado', divulgacion, basico, economia, digital, pendiente_de_verificar).
libro(38, 'El capital en el siglo XXI', ensayo, avanzado, economia, fisico, pendiente_de_verificar).
libro(39, 'Economia', manual, intermedio, economia, digital, pendiente_de_verificar).
libro(40, 'La riqueza de las naciones', ensayo, avanzado, economia, fisico, pendiente_de_verificar).

% Psicologia
libro(41, 'Pensar rapido, pensar despacio', divulgacion, intermedio, psicologia, fisico, pendiente_de_verificar).
libro(42, 'El hombre en busca de sentido', ensayo, basico, psicologia, digital, pendiente_de_verificar).
libro(43, 'El error de Descartes', divulgacion, avanzado, psicologia, fisico, pendiente_de_verificar).
libro(44, 'Inteligencia emocional', divulgacion, basico, psicologia, digital, pendiente_de_verificar).
libro(45, 'El arte de amar', ensayo, intermedio, psicologia, fisico, pendiente_de_verificar).

% Arte
libro(46, 'La historia del arte', divulgacion, basico, arte, fisico, pendiente_de_verificar).
libro(47, 'Modos de ver', ensayo, intermedio, arte, digital, pendiente_de_verificar).
libro(48, 'El arte a traves de los tiempos', manual, avanzado, arte, fisico, pendiente_de_verificar).
libro(49, 'Sobre la fotografia', ensayo, avanzado, arte, digital, pendiente_de_verificar).
libro(50, 'El sentido del arte', ensayo, intermedio, arte, fisico, pendiente_de_verificar).

% autor(IdAutor, Nombre). Hawking aparece en dos libros; seis obras tienen dos autores.
autor(1, 'Malba Tahan').
autor(2, 'Hans Magnus Enzensberger').
autor(3, 'Ian Stewart').
autor(4, 'Steven Strogatz').
autor(5, 'Jordan Ellenberg').
autor(6, 'Robert C. Martin').
autor(7, 'Andrew Hunt').
autor(8, 'Charles Petzold').
autor(9, 'Robert Sedgewick').
autor(10, 'Klaus Schwab').
autor(11, 'Stephen Hawking').
autor(12, 'Carlo Rovelli').
autor(14, 'Brian Greene').
autor(15, 'Hugh D. Young').
autor(16, 'Richard Dawkins').
autor(17, 'Charles Darwin').
autor(18, 'Stephen Jay Gould').
autor(19, 'James D. Watson').
autor(20, 'Neil A. Campbell').
autor(21, 'Yuval Noah Harari').
autor(22, 'Jared Diamond').
autor(23, 'Eric Hobsbawm').
autor(24, 'Stefan Zweig').
autor(25, 'Kimberly Brubaker Bradley').
autor(26, 'Antoine de Saint-Exupery').
autor(27, 'Gabriel Garcia Marquez').
autor(28, 'Miguel de Cervantes').
autor(29, 'Franz Kafka').
autor(30, 'Carlos Ruiz Zafon').
autor(31, 'Jostein Gaarder').
autor(32, 'Marco Aurelio').
autor(33, 'Albert Camus').
autor(34, 'Fernando Savater').
autor(35, 'Platon').
autor(36, 'Steven D. Levitt').
autor(37, 'Tim Harford').
autor(38, 'Thomas Piketty').
autor(39, 'Paul A. Samuelson').
autor(40, 'Adam Smith').
autor(41, 'Daniel Kahneman').
autor(42, 'Viktor E. Frankl').
autor(43, 'Antonio Damasio').
autor(44, 'Daniel Goleman').
autor(45, 'Erich Fromm').
autor(46, 'E. H. Gombrich').
autor(47, 'John Berger').
autor(48, 'Helen Gardner').
autor(49, 'Susan Sontag').
autor(50, 'Herbert Read').
autor(51, 'David Thomas').
autor(52, 'Kevin Wayne').
autor(53, 'Roger A. Freedman').
autor(54, 'Jane B. Reece').
autor(55, 'Stephen J. Dubner').
autor(56, 'William D. Nordhaus').

% libro_autor(IdLibro, IdAutor): tabla puente para la relacion N:M.
libro_autor(1, 1).
libro_autor(2, 2).
libro_autor(3, 3).
libro_autor(4, 4).
libro_autor(5, 5).
libro_autor(6, 6).
libro_autor(7, 7).
libro_autor(7, 51).
libro_autor(8, 8).
libro_autor(9, 9).
libro_autor(9, 52).
libro_autor(10, 10).
libro_autor(11, 11).
libro_autor(12, 12).
libro_autor(13, 11).
libro_autor(14, 14).
libro_autor(15, 15).
libro_autor(15, 53).
libro_autor(16, 16).
libro_autor(17, 17).
libro_autor(18, 18).
libro_autor(19, 19).
libro_autor(20, 20).
libro_autor(20, 54).
libro_autor(21, 21).
libro_autor(22, 22).
libro_autor(23, 23).
libro_autor(24, 24).
libro_autor(25, 25).
libro_autor(26, 26).
libro_autor(27, 27).
libro_autor(28, 28).
libro_autor(29, 29).
libro_autor(30, 30).
libro_autor(31, 31).
libro_autor(32, 32).
libro_autor(33, 33).
libro_autor(34, 34).
libro_autor(35, 35).
libro_autor(36, 36).
libro_autor(36, 55).
libro_autor(37, 37).
libro_autor(38, 38).
libro_autor(39, 39).
libro_autor(39, 56).
libro_autor(40, 40).
libro_autor(41, 41).
libro_autor(42, 42).
libro_autor(43, 43).
libro_autor(44, 44).
libro_autor(45, 45).
libro_autor(46, 46).
libro_autor(47, 47).
libro_autor(48, 48).
libro_autor(49, 49).
libro_autor(50, 50).

% Vista de los autores de un libro (los nombres no se duplican en libro/7).
autores_libro(IdLibro, Nombres) :-
    libro(IdLibro, _, _, _, _, _, _),
    findall(Nombre, (libro_autor(IdLibro, IdAutor), autor(IdAutor, Nombre)), Nombres).

% Estudiantes ficticios: estudiante(IdEstudiante, Nombre).
estudiante(1, 'Estudiante 01').
estudiante(2, 'Estudiante 02').
estudiante(3, 'Estudiante 03').
estudiante(4, 'Estudiante 04').
estudiante(5, 'Estudiante 05').
estudiante(6, 'Estudiante 06').
estudiante(7, 'Estudiante 07').
estudiante(8, 'Estudiante 08').
estudiante(9, 'Estudiante 09').
estudiante(10, 'Estudiante 10').
estudiante(11, 'Estudiante 11').
estudiante(12, 'Estudiante 12').
estudiante(13, 'Estudiante 13').
estudiante(14, 'Estudiante 14').
estudiante(15, 'Estudiante 15').
estudiante(16, 'Estudiante 16').
estudiante(17, 'Estudiante 17').
estudiante(18, 'Estudiante 18').
estudiante(19, 'Estudiante 19').
estudiante(20, 'Estudiante 20').
estudiante(21, 'Estudiante 21').
estudiante(22, 'Estudiante 22').
estudiante(23, 'Estudiante 23').
estudiante(24, 'Estudiante 24').
estudiante(25, 'Estudiante 25').
estudiante(26, 'Estudiante 26').
estudiante(27, 'Estudiante 27').
estudiante(28, 'Estudiante 28').
estudiante(29, 'Estudiante 29').
estudiante(30, 'Estudiante 30').
estudiante(31, 'Estudiante 31').
estudiante(32, 'Estudiante 32').
estudiante(33, 'Estudiante 33').
estudiante(34, 'Estudiante 34').
estudiante(35, 'Estudiante 35').
estudiante(36, 'Estudiante 36').
estudiante(37, 'Estudiante 37').
estudiante(38, 'Estudiante 38').
estudiante(39, 'Estudiante 39').
estudiante(40, 'Estudiante 40').
estudiante(41, 'Estudiante 41').
estudiante(42, 'Estudiante 42').
estudiante(43, 'Estudiante 43').
estudiante(44, 'Estudiante 44').
estudiante(45, 'Estudiante 45').
estudiante(46, 'Estudiante 46').
estudiante(47, 'Estudiante 47').
estudiante(48, 'Estudiante 48').
estudiante(49, 'Estudiante 49').
estudiante(50, 'Estudiante 50').

% preferencia(IdPreferencia, IdEstudiante, Tema, Genero, Nivel, Formato).
% Una persona puede tener varias preferencias; los 50 ejemplos tienen una cada uno.
preferencia(1, 1, matematicas, divulgacion, basico, cualquiera).
preferencia(2, 2, matematicas, ensayo, intermedio, fisico).
preferencia(3, 3, matematicas, cualquiera, basico, digital).
preferencia(4, 4, matematicas, divulgacion, intermedio, cualquiera).
preferencia(5, 5, matematicas, cualquiera, cualquiera, fisico).
preferencia(6, 6, tecnologia, manual, intermedio, fisico).
preferencia(7, 7, tecnologia, divulgacion, basico, digital).
preferencia(8, 8, tecnologia, manual, avanzado, digital).
preferencia(9, 9, tecnologia, ensayo, basico, cualquiera).
preferencia(10, 10, tecnologia, cualquiera, intermedio, cualquiera).
preferencia(11, 11, fisica, divulgacion, basico, cualquiera).
preferencia(12, 12, fisica, manual, avanzado, fisico).
preferencia(13, 13, fisica, divulgacion, intermedio, digital).
preferencia(14, 14, fisica, cualquiera, basico, digital).
preferencia(15, 15, fisica, cualquiera, avanzado, cualquiera).
preferencia(16, 16, biologia, divulgacion, basico, digital).
preferencia(17, 17, biologia, ensayo, avanzado, cualquiera).
preferencia(18, 18, biologia, manual, avanzado, fisico).
preferencia(19, 19, biologia, divulgacion, intermedio, fisico).
preferencia(20, 20, biologia, cualquiera, intermedio, digital).
preferencia(21, 21, historia, divulgacion, basico, fisico).
preferencia(22, 22, historia, ensayo, avanzado, fisico).
preferencia(23, 23, historia, ensayo, intermedio, digital).
preferencia(24, 24, historia, cualquiera, basico, cualquiera).
preferencia(25, 25, historia, divulgacion, intermedio, digital).
preferencia(26, 26, literatura, novela, basico, fisico).
preferencia(27, 27, literatura, novela, intermedio, digital).
preferencia(28, 28, literatura, novela, avanzado, fisico).
preferencia(29, 29, literatura, cualquiera, intermedio, fisico).
preferencia(30, 30, literatura, cualquiera, basico, digital).
preferencia(31, 31, filosofia, novela, basico, fisico).
preferencia(32, 32, filosofia, ensayo, avanzado, fisico).
preferencia(33, 33, filosofia, divulgacion, basico, digital).
preferencia(34, 34, filosofia, ensayo, intermedio, digital).
preferencia(35, 35, filosofia, cualquiera, avanzado, cualquiera).
preferencia(36, 36, economia, divulgacion, basico, digital).
preferencia(37, 37, economia, ensayo, avanzado, fisico).
preferencia(38, 38, economia, manual, intermedio, digital).
preferencia(39, 39, economia, divulgacion, basico, fisico).
preferencia(40, 40, economia, cualquiera, avanzado, digital).
preferencia(41, 41, psicologia, divulgacion, basico, digital).
preferencia(42, 42, psicologia, ensayo, intermedio, fisico).
preferencia(43, 43, psicologia, divulgacion, avanzado, fisico).
preferencia(44, 44, psicologia, ensayo, basico, digital).
preferencia(45, 45, psicologia, cualquiera, intermedio, cualquiera).
preferencia(46, 46, arte, divulgacion, basico, fisico).
preferencia(47, 47, arte, ensayo, avanzado, digital).
preferencia(48, 48, arte, manual, avanzado, fisico).
preferencia(49, 49, arte, ensayo, intermedio, digital).
preferencia(50, 50, arte, cualquiera, intermedio, fisico).

% recomendacion_guardada(IdRecomendacion, IdPreferencia, IdLibro).
% Historial de ejemplo: se almacena la primera sugerencia del ranking por perfil.
recomendacion_guardada(1, 1, 1).
recomendacion_guardada(2, 2, 5).
recomendacion_guardada(3, 3, 2).
recomendacion_guardada(4, 4, 3).
recomendacion_guardada(5, 5, 1).
recomendacion_guardada(6, 6, 6).
recomendacion_guardada(7, 7, 8).
recomendacion_guardada(8, 8, 9).
recomendacion_guardada(9, 9, 10).
recomendacion_guardada(10, 10, 6).
recomendacion_guardada(11, 11, 11).
recomendacion_guardada(12, 12, 15).
recomendacion_guardada(13, 13, 14).
recomendacion_guardada(14, 14, 12).
recomendacion_guardada(15, 15, 15).
recomendacion_guardada(16, 16, 19).
recomendacion_guardada(17, 17, 17).
recomendacion_guardada(18, 18, 20).
recomendacion_guardada(19, 19, 16).
recomendacion_guardada(20, 20, 16).
recomendacion_guardada(21, 21, 21).
recomendacion_guardada(22, 22, 23).
recomendacion_guardada(23, 23, 22).
recomendacion_guardada(24, 24, 21).
recomendacion_guardada(25, 25, 22).
recomendacion_guardada(26, 26, 26).
recomendacion_guardada(27, 27, 27).
recomendacion_guardada(28, 28, 28).
recomendacion_guardada(29, 29, 27).
recomendacion_guardada(30, 30, 26).
recomendacion_guardada(31, 31, 31).
recomendacion_guardada(32, 32, 33).
recomendacion_guardada(33, 33, 34).
recomendacion_guardada(34, 34, 32).
recomendacion_guardada(35, 35, 33).
recomendacion_guardada(36, 36, 37).
recomendacion_guardada(37, 37, 38).
recomendacion_guardada(38, 38, 39).
recomendacion_guardada(39, 39, 36).
recomendacion_guardada(40, 40, 38).
recomendacion_guardada(41, 41, 44).
recomendacion_guardada(42, 42, 45).
recomendacion_guardada(43, 43, 43).
recomendacion_guardada(44, 44, 42).
recomendacion_guardada(45, 45, 41).
recomendacion_guardada(46, 46, 46).
recomendacion_guardada(47, 47, 49).
recomendacion_guardada(48, 48, 48).
recomendacion_guardada(49, 49, 47).
recomendacion_guardada(50, 50, 50).

/*
   Perfil: pref(Tema, Genero, Nivel, Formato).
   Tema es obligatorio; en los otros campos cualquiera significa sin preferencia.
   Ejemplo: recomendaciones(pref(matematicas, cualquiera, basico, cualquiera), R).
   R contiene recomendacion(Id, Titulo, Autores, Puntos, Motivos).
*/

opcion(cualquiera, _, 0, []).
opcion(Valor, ValorLibro, 1, [Etiqueta]) :-
    Valor \== cualquiera,
    Valor == ValorLibro,
    etiqueta(Valor, Etiqueta).
opcion(Valor, ValorLibro, 0, []) :-
    Valor \== cualquiera,
    Valor \== ValorLibro.

etiqueta(Valor, Valor).

% Un libro se encuentra por su tema principal o por temas secundarios documentados.
tema_de_libro(Id, Tema, 2, [Tema]) :-
    libro(Id, _, _, _, Tema, _, _).
tema_de_libro(23, guerra, 1, [tema_secundario(guerra)]). % Historia del siglo XX
tema_de_libro(24, guerra, 1, [tema_secundario(guerra)]). % El mundo de ayer: Primera Guerra Mundial
tema_de_libro(25, literatura, 1, [tema_secundario(literatura)]). % Novela historica

% Regla experta: la divulgacion de nivel intermedio puede servir como
% alternativa introductoria al nivel basico, pero puntua menos que el basico.
adecuacion_nivel(cualquiera, _, _, 0, []) :- !.
adecuacion_nivel(Nivel, Nivel, _, 2, [nivel_exacto(Nivel)]) :- !.
adecuacion_nivel(basico, intermedio, divulgacion, 1,
                 [nivel_intermedio_accesible_por_divulgacion]) :- !.
adecuacion_nivel(_, _, _, 0, []).

% El tema sigue siendo obligatorio; nunca se infiere guerra de toda la historia.
recomendar(pref(Tema, Genero, Nivel, Formato), Id, Puntos, Motivos) :-
    nonvar(Tema),
    tema(Tema, _),
    opcion_catalogo(genero, Genero),
    opcion_catalogo(nivel, Nivel),
    opcion_catalogo(formato, Formato),
    tema_de_libro(Id, Tema, PT, MT),
    libro(Id, _, GeneroLibro, NivelLibro, _, FormatoLibro, _),
    opcion(Genero, GeneroLibro, PG, MG),
    adecuacion_nivel(Nivel, NivelLibro, GeneroLibro, PN, MN),
    opcion(Formato, FormatoLibro, PF, MF),
    Puntos is PT + PG + PN + PF,
    append([MT, MG, MN, MF], Motivos).

opcion_catalogo(_, cualquiera).
opcion_catalogo(Catalogo, Valor) :-
    Valor \== cualquiera,
    call(Catalogo, Valor, _).

% Coincidencia estricta: el nivel inferido NO cuenta como exacto.
coincidencia_total(Perfil, Id) :-
    Perfil = pref(_, Genero, Nivel, Formato),
    recomendar(Perfil, Id, _, _),
    libro(Id, _, GeneroLibro, NivelLibro, _, FormatoLibro, _),
    opcion_estricta(Genero, GeneroLibro),
    opcion_estricta(Nivel, NivelLibro),
    opcion_estricta(Formato, FormatoLibro).

opcion_estricta(cualquiera, _).
opcion_estricta(Valor, Valor).

% Lista ordenada por puntos descendentes e ID ascendente para desempatar.
recomendaciones(Perfil, Resultados) :-
    findall((Negativos-Id)-recomendacion(Id, Titulo, Autores, Puntos, Motivos),
            (recomendar(Perfil, Id, Puntos, Motivos),
             libro(Id, Titulo, _, _, _, _, _),
             autores_libro(Id, Autores),
             Negativos is -Puntos),
            Pares),
    keysort(Pares, Ordenados),
    findall(Resultado, member(_-Resultado, Ordenados), Resultados).

% El estudiante puede tener varias preferencias, cada una con su propio ID.
perfil_estudiante(IdEstudiante, pref(Tema, Genero, Nivel, Formato)) :-
    estudiante(IdEstudiante, _),
    preferencia(_, IdEstudiante, Tema, Genero, Nivel, Formato).

perfil_preferencia(IdPreferencia, pref(Tema, Genero, Nivel, Formato)) :-
    preferencia(IdPreferencia, IdEstudiante, Tema, Genero, Nivel, Formato),
    estudiante(IdEstudiante, _).

recomienda_a(IdEstudiante, IdLibro, Puntos) :-
    perfil_estudiante(IdEstudiante, Perfil),
    recomendar(Perfil, IdLibro, Puntos, _).

recomendaciones_estudiante(IdEstudiante, Resultados) :-
    perfil_estudiante(IdEstudiante, Perfil),
    recomendaciones(Perfil, Resultados).

% Consulta del historial: puntaje y motivos se calculan con las reglas actuales.
detalle_recomendacion(IdRecomendacion, IdEstudiante, IdLibro, Puntos, Motivos) :-
    recomendacion_guardada(IdRecomendacion, IdPreferencia, IdLibro),
    preferencia(IdPreferencia, IdEstudiante, _, _, _, _),
    perfil_preferencia(IdPreferencia, Perfil),
    recomendar(Perfil, IdLibro, Puntos, Motivos).

% Interfaz de consola: se puede consultar sin registro o usar datos guardados.
iniciar :-
    writeln('=== Recomendador de libros ==='),
    writeln('Escribe los valores sin tildes; deja en blanco los filtros opcionales.'),
    menu.

menu :-
    nl,
    writeln('1. Nueva consulta (sin registrarse)'),
    writeln('2. Recomendar a un estudiante registrado'),
    writeln('3. Ver historial de un estudiante'),
    writeln('4. Buscar mediante una frase'),
    writeln('0. Salir'),
    pedir('Elige una opcion: ', ['1', '2', '3', '4', '0'], obligatorio, Opcion),
    ( (Opcion == '0' ; Opcion == salir) -> true
    ; Opcion == '1' -> consulta_rapida, menu
    ; Opcion == '2' -> consulta_registrada, menu
    ; Opcion == '3' -> historial_estudiante, menu
    ; Opcion == '4' -> consulta_por_frase, menu
    ).

consulta_rapida :-
    writeln('Elige tus filtros (Enter para omitir cada uno):'),
    pedir_catalogo('¿Que nivel prefieres?', nivel, opcional, Nivel),
    pedir_catalogo('¿Que genero prefieres?', genero, opcional, Genero),
    pedir_catalogo('¿Que formato prefieres?', formato, opcional, Formato),
    pedir_catalogo('¿Que quieres aprender?', tema, tema, Tema),
    ( Tema == salir -> true
    ; recomendaciones(pref(Tema, Genero, Nivel, Formato), Resultados),
      mostrar(Resultados)
    ).

pedir_catalogo(Pregunta, Catalogo, Tipo, Respuesta) :-
    findall(Clave, call(Catalogo, Clave, _), Validos),
    atomic_list_concat(Validos, ', ', Opciones),
    ( Tipo == opcional ->
        format(atom(Mensaje), '~w (~w; Enter = cualquiera): ', [Pregunta, Opciones]),
        pedir(Mensaje, Validos, opcional, Respuesta)
    ; format(atom(Mensaje), '~w (~w): ', [Pregunta, Opciones]),
      pedir_tema(Mensaje, Validos, Respuesta)
    ).

% La pregunta guiada tambien aprovecha el analizador lexico.
pedir_tema(Mensaje, Validos, Tema) :-
    repeat,
    write(Mensaje), flush_output,
    read_line_to_string(user_input, Entrada),
    ( Entrada == end_of_file -> Tema = salir
    ; normalize_space(string(Limpia), Entrada),
      string_lower(Limpia, Minuscula),
      ( Minuscula == "salir" -> Tema = salir
      ; analizar_frase(Limpia, pref(Valor, _, _, _)),
        memberchk(Valor, Validos) ->
          Tema = Valor,
          tema(Tema, Nombre),
          format('Tema identificado: ~w~n', [Nombre])
      ; writeln('No pude identificar un unico tema; prueba con uno de la lista.'), fail
      )
    ), !.

consulta_por_frase :-
    writeln('Ejemplo: necesito libros basicos digitales que hablen sobre la guerra.'),
    write('Escribe tu busqueda: '), flush_output,
    read_line_to_string(user_input, Entrada),
    ( Entrada == end_of_file -> true
    ; analizar_frase(Entrada, Perfil) ->
        format('Preferencias identificadas: ~w~n', [Perfil]),
        recomendaciones(Perfil, Resultados),
        mostrar(Resultados)
    ; writeln('No pude identificar un tema unico o hay filtros contradictorios.'),
      writeln('Incluye un solo tema y, como maximo, un nivel, genero y formato.')
    ).

/*
   Analizador lexico sencillo: no comprende la gramatica de la oracion.
   Normaliza mayusculas, tildes y signos; despues busca palabras del catalogo.
*/
analizar_frase(Texto, pref(Tema, Genero, Nivel, Formato)) :-
    palabras_normalizadas(Texto, Palabras),
    valor_en_frase(tema, Palabras, obligatorio, Tema),
    valor_en_frase(genero, Palabras, opcional, Genero),
    valor_en_frase(nivel, Palabras, opcional, Nivel),
    valor_en_frase(formato, Palabras, opcional, Formato).

palabras_normalizadas(Texto, Palabras) :-
    string_lower(Texto, Minusculas),
    string_codes(Minusculas, Codigos),
    maplist(normalizar_codigo, Codigos, Normalizados),
    string_codes(SinTildes, Normalizados),
    split_string(SinTildes, " ", " \t\n", Palabras).

normalizar_codigo(225, 97) :- !.
normalizar_codigo(233, 101) :- !.
normalizar_codigo(237, 105) :- !.
normalizar_codigo(243, 111) :- !.
normalizar_codigo(250, 117) :- !.
normalizar_codigo(252, 117) :- !.
normalizar_codigo(Codigo, 32) :-
    memberchk(Codigo, [44, 46, 59, 58, 33, 63, 191, 161, 40, 41, 91, 93, 123, 125, 34, 39, 45]), !.
normalizar_codigo(Codigo, Codigo).

valor_en_frase(Catalogo, Palabras, Tipo, Valor) :-
    findall(Encontrado,
            (member(Palabra, Palabras), alias_catalogo(Catalogo, Palabra, Encontrado)),
            Repetidos),
    sort(Repetidos, Valores),
    valor_unico(Tipo, Valores, Valor).

valor_unico(obligatorio, [Valor], Valor).
valor_unico(opcional, [], cualquiera).
valor_unico(opcional, [Valor], Valor).

alias_catalogo(Catalogo, Palabra, Valor) :-
    call(Catalogo, Valor, _),
    atom_string(Valor, Palabra).

% Sinonimos controlados; agregar vocabulario nuevo mantiene la regla visible.
alias_catalogo(tema, "conflicto", guerra).
alias_catalogo(tema, "conflictos", guerra).
alias_catalogo(tema, "belico", guerra).
alias_catalogo(tema, "belicos", guerra).
alias_catalogo(genero, "divulgativo", divulgacion).
alias_catalogo(genero, "divulgativos", divulgacion).
alias_catalogo(genero, "ensayos", ensayo).
alias_catalogo(genero, "manuales", manual).
alias_catalogo(genero, "novelas", novela).
alias_catalogo(nivel, "basicos", basico).
alias_catalogo(nivel, "principiante", basico).
alias_catalogo(nivel, "principiantes", basico).
alias_catalogo(nivel, "intermedios", intermedio).
alias_catalogo(nivel, "medio", intermedio).
alias_catalogo(nivel, "avanzados", avanzado).
alias_catalogo(nivel, "experto", avanzado).
alias_catalogo(nivel, "expertos", avanzado).
alias_catalogo(formato, "ebook", digital).
alias_catalogo(formato, "electronico", digital).
alias_catalogo(formato, "electronicos", digital).
alias_catalogo(formato, "digitales", digital).
alias_catalogo(formato, "impreso", fisico).
alias_catalogo(formato, "impresos", fisico).
alias_catalogo(formato, "fisicos", fisico).

consulta_registrada :-
    pedir_estudiante(IdEstudiante),
    estudiante(IdEstudiante, Nombre),
    format('Recomendaciones para ~w:~n', [Nombre]),
    forall(preferencia(IdPreferencia, IdEstudiante, _, _, _, _),
           (perfil_preferencia(IdPreferencia, Perfil),
            format('Preferencia ~d: ~w~n', [IdPreferencia, Perfil]),
            recomendaciones(Perfil, Resultados),
            mostrar(Resultados))).

historial_estudiante :-
    pedir_estudiante(IdEstudiante),
    estudiante(IdEstudiante, Nombre),
    format('Historial de ~w:~n', [Nombre]),
    findall(registro(IdRec, Titulo, Puntos, Motivos),
            (detalle_recomendacion(IdRec, IdEstudiante, IdLibro, Puntos, Motivos),
             libro(IdLibro, Titulo, _, _, _, _, _)),
            Historial),
    ( Historial == [] -> writeln('Todavia no hay recomendaciones guardadas.')
    ; forall(member(registro(IdRec, Titulo, Puntos, Motivos), Historial),
             (texto_motivos(Motivos, Explicacion),
              format('Registro ~d: ~w | puntuacion: ~d | ~w~n',
                     [IdRec, Titulo, Puntos, Explicacion])))
    ).

pedir_estudiante(IdEstudiante) :-
    repeat,
    write('ID del estudiante (1 a 50): '), flush_output,
    read_line_to_string(user_input, Texto),
    ( Texto == end_of_file -> !, fail
    ; catch(number_string(Valor, Texto), _, fail),
      integer(Valor), estudiante(Valor, _) -> IdEstudiante = Valor, !
    ; writeln('Estudiante no encontrado; prueba de nuevo.'), fail
    ).

pedir(Mensaje, Validos, Tipo, Respuesta) :-
    repeat,
    write(Mensaje), flush_output,
    read_line_to_string(user_input, Entrada),
    ( Entrada == end_of_file -> Respuesta = salir
    ; normalize_space(string(Limpia), Entrada),
      string_lower(Limpia, Minuscula),
      atom_string(Valor, Minuscula),
      ( Tipo == obligatorio, Valor == salir -> Respuesta = salir
      ; Tipo == opcional, Valor == '' -> Respuesta = cualquiera
      ; memberchk(Valor, Validos) -> Respuesta = Valor
      ; writeln('Valor no valido; prueba de nuevo.'), fail
      )
    ), !.

mostrar([]) :- writeln('No se encontraron libros para ese tema.').
mostrar(Resultados) :-
    Resultados \== [],
    nl, writeln('Recomendaciones (ordenadas por coincidencias):'),
    forall(member(recomendacion(Id, Titulo, Autores, Puntos, Motivos), Resultados),
           (atomic_list_concat(Autores, ', ', Nombres),
            texto_motivos(Motivos, Explicacion),
            format('~d. ~w - ~w | puntuacion: ~d | ~w~n',
                   [Id, Titulo, Nombres, Puntos, Explicacion]))),
    nl.

texto_motivos(Motivos, Explicacion) :-
    maplist(descripcion_motivo, Motivos, Descripciones),
    atomic_list_concat(Descripciones, '; ', Explicacion).

descripcion_motivo(tema_secundario(Tema), Texto) :-
    tema(Tema, Nombre),
    format(atom(Texto), 'tema relacionado: ~w', [Nombre]).
descripcion_motivo(nivel_exacto(Nivel), Texto) :-
    nivel(Nivel, Nombre),
    format(atom(Texto), 'nivel exacto: ~w', [Nombre]).
descripcion_motivo(nivel_intermedio_accesible_por_divulgacion,
                   'alternativa de divulgacion intermedia para comenzar').
descripcion_motivo(Valor, Texto) :-
    ( tema(Valor, Nombre) -> Etiqueta = tema
    ; genero(Valor, Nombre) -> Etiqueta = genero
    ; formato(Valor, Nombre) -> Etiqueta = formato
    ),
    format(atom(Texto), '~w: ~w', [Etiqueta, Nombre]).
