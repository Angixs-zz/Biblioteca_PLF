/*
   Sistema experto de recomendacion de libros (SWI-Prolog).
   Seis conjuntos principales (al menos 50 hechos en cada uno):
   estudiante/2, preferencia/6, libro/7, autor/2,
   libro_autor/2 y recomendacion_guardada/3.
   Cuatro catalogos pequenos: nivel/2, genero/2, tema/2, formato/2.
   Las personas, sus perfiles y recomendaciones guardadas son datos de ejemplo.
   libro(Id, Titulo, Genero, Nivel, Tema, Formato, Editorial).
   El formato es un dato de ejemplo para el ejercicio, no disponibilidad real.
   La editorial corresponde a la edicion enlazada en fuentes_editoriales.md.
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
tema(amor, 'Amor y relaciones').

formato(fisico, 'Físico').
formato(digital, 'Digital').

% Matematicas
libro(1, 'El hombre que calculaba', divulgacion, basico, matematicas, fisico, 'RBA Libros').
libro(2, 'El diablo de los numeros', divulgacion, basico, matematicas, digital, 'Siruela').
libro(3, 'Historia de las matematicas', divulgacion, intermedio, matematicas, fisico, 'Editorial Crítica').
libro(4, 'El placer de la x', divulgacion, basico, matematicas, digital, 'Taurus').
libro(5, 'How Not to Be Wrong', ensayo, intermedio, matematicas, fisico, 'Penguin Books').

% Tecnologia
libro(6, 'Clean Code', manual, intermedio, tecnologia, fisico, 'Prentice Hall').
libro(7, 'The Pragmatic Programmer', manual, intermedio, tecnologia, digital, 'Pragmatic Programmer').
libro(8, 'Code', divulgacion, basico, tecnologia, fisico, 'Microsoft Press').
libro(9, 'Algorithms', manual, avanzado, tecnologia, digital, 'Addison-Wesley').
libro(10, 'La cuarta revolucion industrial', ensayo, basico, tecnologia, fisico, 'Debate').

% Fisica
libro(11, 'A Brief History of Time', divulgacion, basico, fisica, fisico, 'Transworld Publishers').
libro(12, 'Siete breves lecciones de fisica', divulgacion, basico, fisica, digital, 'Anagrama').
libro(13, 'El universo en una cascara de nuez', divulgacion, intermedio, fisica, fisico, 'Crítica').
libro(14, 'El tejido del cosmos', divulgacion, intermedio, fisica, digital, 'Crítica').
libro(15, 'Fisica universitaria', manual, avanzado, fisica, fisico, 'Pearson').

% Biologia
libro(16, 'El gen egoista', divulgacion, intermedio, biologia, fisico, 'Salvat').
libro(17, 'El origen de las especies', ensayo, avanzado, biologia, digital, 'Espasa').
libro(18, 'La vida maravillosa', divulgacion, intermedio, biologia, fisico, 'Booket').
libro(19, 'La doble helice', divulgacion, basico, biologia, digital, 'Salvat').
libro(20, 'Campbell Biology', manual, avanzado, biologia, fisico, 'Benjamin Cummings').

% Historia
libro(21, 'Sapiens', divulgacion, basico, historia, fisico, 'Debolsillo').
libro(22, 'Armas, germenes y acero', ensayo, intermedio, historia, digital, 'Debolsillo').
libro(23, 'Historia del siglo XX', ensayo, avanzado, historia, fisico, 'Critica').
libro(24, 'El mundo de ayer', ensayo, intermedio, historia, digital, 'Editorial Claridad').
libro(25, 'La guerra que salvo mi vida', novela, basico, guerra, fisico, 'Turtleback').

% Literatura
libro(26, 'El principito', novela, basico, literatura, fisico, 'Plutón Ediciones').
libro(27, 'Cien anos de soledad', novela, intermedio, literatura, digital, 'Grijalbo Mondadori').
libro(28, 'Don Quixote', novela, avanzado, literatura, fisico, 'Open Road Integrated Media').
libro(29, 'La metamorfosis', novela, intermedio, literatura, digital, 'Editorial Octaedro').
libro(30, 'La sombra del viento', novela, intermedio, literatura, fisico, 'Planeta').

% Filosofia
libro(31, 'El mundo de Sofia', novela, basico, filosofia, fisico, 'Círculo de Lectores').
libro(32, 'Meditaciones', ensayo, intermedio, filosofia, digital, 'La Otra H').
libro(33, 'El mito de Sisifo', ensayo, avanzado, filosofia, fisico, 'Penguin').
libro(34, 'Etica para Amador', divulgacion, basico, filosofia, digital, 'Ariel').
libro(35, 'The Republic', ensayo, avanzado, filosofia, fisico, 'Penguin Classics').

% Economia
libro(36, 'Freakonomics', divulgacion, basico, economia, fisico, 'ZETA BOLSILLO').
libro(37, 'El economista camuflado', divulgacion, basico, economia, digital, 'Ediciones Temas de Hoy').
libro(38, 'El capital en el siglo XXI', ensayo, avanzado, economia, fisico, 'Fondo de Cultura Económica').
libro(39, 'Economics', manual, intermedio, economia, digital, 'McGraw Hill').
libro(40, 'La riqueza de las naciones', ensayo, avanzado, economia, fisico, 'Perfil').

% Psicologia
libro(41, 'Pensar rapido, pensar despacio', divulgacion, intermedio, psicologia, fisico, 'Debate').
libro(42, 'Man\'s Search for Meaning', ensayo, basico, psicologia, digital, 'Beacon Press').
libro(43, 'El error de Descartes', divulgacion, avanzado, psicologia, fisico, 'Booket').
libro(44, 'Inteligencia emocional', divulgacion, basico, psicologia, digital, 'Salvat').
libro(45, 'El arte de amar', ensayo, intermedio, psicologia, fisico, 'Planeta Publishing').

% Arte
libro(46, 'La historia del arte', divulgacion, basico, arte, fisico, 'Círculo de Lectores').
libro(47, 'Modos de ver', ensayo, intermedio, arte, digital, 'Editorial Gustavo Gili').
libro(48, 'Art Through the Ages', manual, avanzado, arte, fisico, 'Harcourt, Brace').
libro(49, 'Sobre la fotografia', ensayo, avanzado, arte, digital, 'Alfaguara').
libro(50, 'The Meaning of Art', ensayo, intermedio, arte, fisico, 'Faber').

% Ampliacion del catalogo: libros 51 a 100.
libro(51, 'El enigma de Fermat', divulgacion, intermedio, matematicas, fisico, 'Booket').
libro(52, 'El hombre anumérico', divulgacion, basico, matematicas, digital, 'Tusquets Editores').
libro(53, 'Alex\'s Adventures in Numberland', divulgacion, basico, matematicas, fisico, 'Bloomsbury UK').
libro(54, 'Como plantear y resolver problemas', manual, intermedio, matematicas, digital, 'Trillas').
libro(55, 'Mathematical Magic Show', divulgacion, intermedio, matematicas, fisico, 'The Mathematical Association of America').

libro(56, 'Python Crash Course', manual, basico, tecnologia, digital, 'No Starch Press').
libro(57, 'Fluent Python', manual, avanzado, tecnologia, fisico, 'O\'Reilly Media').
libro(58, 'Head First Design Patterns', manual, intermedio, tecnologia, digital, 'O\'Reilly Media').
libro(59, 'Refactoring', manual, avanzado, tecnologia, fisico, 'Addison-Wesley Professional').
libro(60, 'Introduction to Algorithms', manual, avanzado, tecnologia, digital, 'MIT Press').

libro(61, 'Seis piezas faciles', divulgacion, basico, fisica, fisico, 'Booket Planeta').
libro(62, 'Physics of the Impossible', divulgacion, basico, fisica, digital, 'Allen Lane').
libro(63, 'Astrofisica para gente con prisas', divulgacion, basico, fisica, fisico, 'Paidós México').
libro(64, 'Warped Passages', divulgacion, intermedio, fisica, digital, 'Harper Perennial').
libro(65, 'Agujeros negros y tiempo curvo', divulgacion, avanzado, fisica, fisico, 'Crítica').

libro(66, 'El gen', divulgacion, intermedio, biologia, fisico, 'Penguin Random House').
libro(67, 'La vida inmortal de Henrietta Lacks', divulgacion, basico, biologia, digital, 'Booket').
libro(68, 'El cuerpo humano', divulgacion, basico, biologia, fisico, 'RBA').
libro(69, 'The Brain: The Story of You', divulgacion, intermedio, biologia, digital, 'Canongate Books').
libro(70, 'La sexta extincion', divulgacion, intermedio, biologia, fisico, 'Critica').

libro(71, 'Sin novedad en el frente', novela, intermedio, guerra, digital, 'Navona Editorial').
libro(72, 'The Guns of August', ensayo, avanzado, guerra, fisico, 'Presidio Press').
libro(73, 'La Segunda Guerra Mundial', ensayo, intermedio, guerra, digital, 'Editorial Pasado y Presente').
libro(74, 'SPQR', divulgacion, intermedio, historia, fisico, 'Booket').
libro(75, 'Biografia del poder', ensayo, avanzado, historia, digital, 'Tusquets Editores').

libro(76, 'Nineteen Eighty-Four', novela, intermedio, literatura, fisico, 'Penguin Books').
libro(77, 'Orgullo y prejuicio', novela, intermedio, literatura, digital, 'ANAYA INFANTIL Y JUVENIL').
libro(78, 'Cronica de una muerte anunciada', novela, intermedio, literatura, fisico, 'Seix Barral').
libro(79, 'Pedro Paramo', novela, intermedio, literatura, digital, 'Fondo de Cultura Económica').
libro(80, 'Rayuela', novela, avanzado, literatura, fisico, 'Casa de las Américas').

libro(81, 'Apologia de Socrates', ensayo, basico, filosofia, digital, 'CreateSpace Independent Publishing Platform').
libro(82, 'The Symposium', ensayo, intermedio, filosofia, fisico, 'Penguin Books').
libro(83, 'El segundo sexo', ensayo, avanzado, filosofia, digital, 'Ediciones Siglo Veinte').
libro(84, 'Asi hablo Zaratustra', ensayo, avanzado, filosofia, fisico, 'El Ateneo').
libro(85, 'El existencialismo es un humanismo', ensayo, intermedio, filosofia, digital, 'Edhasa').

libro(86, 'Economia en una leccion', divulgacion, basico, economia, fisico, 'Unión Editorial').
libro(87, 'Capitalism and Freedom', ensayo, intermedio, economia, digital, 'University of Chicago Press').
libro(88, 'El cisne negro', ensayo, intermedio, economia, fisico, 'Paidós').
libro(89, 'Debt: The First 5,000 Years', ensayo, avanzado, economia, digital, 'Melville House').
libro(90, 'La economia del bien comun', ensayo, avanzado, economia, fisico, 'Taurus').

libro(91, 'El poder de los habitos', divulgacion, basico, psicologia, digital, 'Vergara').
libro(92, 'Influencia', divulgacion, intermedio, psicologia, fisico, 'HarperCollins Publishers').
libro(93, 'The Social Animal', manual, intermedio, psicologia, digital, 'W. H. Freeman').
libro(94, 'La interpretacion de los suenos', ensayo, avanzado, psicologia, fisico, 'Ediciones Portenas').
libro(95, 'Fluir', divulgacion, basico, psicologia, digital, 'Debolsillo').

libro(96, 'El arte moderno', ensayo, avanzado, arte, fisico, 'Akal Ediciones').
libro(97, 'Despues del fin del arte', ensayo, avanzado, arte, digital, 'Ediciones Paidós Ibérica').
libro(98, 'El arte de mirar', divulgacion, basico, arte, fisico, 'Blume').
libro(99, 'La camara lucida', ensayo, intermedio, arte, digital, 'Ediciones Paidós Ibérica').
libro(100, 'Arte y percepcion visual', manual, intermedio, arte, fisico, 'Alianza').

% autor(IdAutor, Nombre). Un autor puede aparecer en varios libros;
% algunas obras tienen dos autores y el libro 60 tiene cuatro.
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
autor(57, 'Simon Singh').
autor(58, 'John Allen Paulos').
autor(59, 'Alex Bellos').
autor(60, 'George Polya').
autor(61, 'Martin Gardner').
autor(62, 'Eric Matthes').
autor(63, 'Luciano Ramalho').
autor(64, 'Eric Freeman').
autor(65, 'Elisabeth Robson').
autor(66, 'Martin Fowler').
autor(67, 'Thomas H. Cormen').
autor(68, 'Charles E. Leiserson').
autor(69, 'Ronald L. Rivest').
autor(70, 'Clifford Stein').
autor(71, 'Richard Feynman').
autor(72, 'Michio Kaku').
autor(73, 'Neil deGrasse Tyson').
autor(74, 'Lisa Randall').
autor(75, 'Kip S. Thorne').
autor(76, 'Siddhartha Mukherjee').
autor(77, 'Rebecca Skloot').
autor(78, 'Bill Bryson').
autor(79, 'David Eagleman').
autor(80, 'Elizabeth Kolbert').
autor(81, 'Erich Maria Remarque').
autor(82, 'Barbara W. Tuchman').
autor(83, 'Antony Beevor').
autor(84, 'Mary Beard').
autor(85, 'Enrique Krauze').
autor(86, 'George Orwell').
autor(87, 'Jane Austen').
autor(88, 'Juan Rulfo').
autor(89, 'Julio Cortazar').
autor(90, 'Simone de Beauvoir').
autor(91, 'Friedrich Nietzsche').
autor(92, 'Jean-Paul Sartre').
autor(93, 'Henry Hazlitt').
autor(94, 'Milton Friedman').
autor(95, 'Nassim Nicholas Taleb').
autor(96, 'David Graeber').
autor(97, 'Jean Tirole').
autor(98, 'Charles Duhigg').
autor(99, 'Robert B. Cialdini').
autor(100, 'Elliot Aronson').
autor(101, 'Sigmund Freud').
autor(102, 'Mihaly Csikszentmihalyi').
autor(103, 'Giulio Carlo Argan').
autor(104, 'Arthur C. Danto').
autor(105, 'Susan Woodford').
autor(106, 'Roland Barthes').
autor(107, 'Rudolf Arnheim').

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
libro_autor(51, 57).
libro_autor(52, 58).
libro_autor(53, 59).
libro_autor(54, 60).
libro_autor(55, 61).
libro_autor(56, 62).
libro_autor(57, 63).
libro_autor(58, 64).
libro_autor(58, 65).
libro_autor(59, 66).
libro_autor(60, 67).
libro_autor(60, 68).
libro_autor(60, 69).
libro_autor(60, 70).
libro_autor(61, 71).
libro_autor(62, 72).
libro_autor(63, 73).
libro_autor(64, 74).
libro_autor(65, 75).
libro_autor(66, 76).
libro_autor(67, 77).
libro_autor(68, 78).
libro_autor(69, 79).
libro_autor(70, 80).
libro_autor(71, 81).
libro_autor(72, 82).
libro_autor(73, 83).
libro_autor(74, 84).
libro_autor(75, 85).
libro_autor(76, 86).
libro_autor(77, 87).
libro_autor(78, 27).
libro_autor(79, 88).
libro_autor(80, 89).
libro_autor(81, 35).
libro_autor(82, 35).
libro_autor(83, 90).
libro_autor(84, 91).
libro_autor(85, 92).
libro_autor(86, 93).
libro_autor(87, 94).
libro_autor(88, 95).
libro_autor(89, 96).
libro_autor(90, 97).
libro_autor(91, 98).
libro_autor(92, 99).
libro_autor(93, 100).
libro_autor(94, 101).
libro_autor(95, 102).
libro_autor(96, 103).
libro_autor(97, 104).
libro_autor(98, 105).
libro_autor(99, 106).
libro_autor(100, 107).

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
recomendacion_guardada(25, 25, 74).
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

% Un libro se recomienda por tema principal o relacion secundaria justificada.
tema_de_libro(Id, Tema, 2, [Tema]) :-
    libro(Id, _, _, _, Tema, _, _).
tema_de_libro(Id, Tema, 1, [tema_secundario(Tema, Justificacion)]) :-
    relacion_tematica(Id, Tema, Justificacion).
% Toda novela tambien pertenece a literatura, sin duplicar su tema principal.
tema_de_libro(Id, literatura, 1,
              [tema_secundario(literatura, 'Es una obra narrativa de ficcion')]) :-
    libro(Id, _, novela, _, TemaPrincipal, _, _),
    TemaPrincipal \== literatura.

% Historia como tema de una novela indica ambientacion historica,
% NO implica que la ficcion constituya una fuente academica de historia.
relacion_tematica(23, guerra, 'Estudia las guerras del siglo XX').
relacion_tematica(24, guerra, 'Incluye la experiencia europea de la Primera Guerra Mundial').
relacion_tematica(25, historia, 'Novela ambientada durante la Segunda Guerra Mundial').
relacion_tematica(71, historia, 'Novela ambientada durante la Primera Guerra Mundial').
relacion_tematica(72, historia, 'Estudio del inicio de la Primera Guerra Mundial').
relacion_tematica(73, historia, 'Analisis de la Segunda Guerra Mundial').
relacion_tematica(77, amor, 'El cortejo y las relaciones son centrales en la trama').
relacion_tematica(27, amor, 'Incluye las relaciones amorosas de varias generaciones').
relacion_tematica(45, amor, 'Estudia el amor desde la psicologia').
relacion_tematica(29, filosofia, 'Explora identidad, alienacion y condicion humana').
relacion_tematica(76, filosofia, 'Plantea preguntas sobre verdad, libertad y poder').

% Niveles de novelas: dificultad de lectura, no dificultad academica.
% Clasificacion humana ORIENTATIVA: lenguaje, narrativa y contexto.
justificacion_dificultad(25, 'Basico: narracion juvenil y vocabulario accesible').
justificacion_dificultad(26, 'Basico: relato breve y claro, aunque tiene simbolismo').
justificacion_dificultad(27, 'Intermedio: generaciones, personajes y saltos temporales').
justificacion_dificultad(28, 'Avanzado: lenguaje historico, referencias culturales y extension').
justificacion_dificultad(29, 'Intermedio: simbolismo y conflicto existencial').
justificacion_dificultad(30, 'Intermedio: tramas y personajes entrelazados').
justificacion_dificultad(31, 'Basico: introduccion narrativa accesible a ideas filosoficas').
justificacion_dificultad(71, 'Intermedio: contexto belico y carga emocional').
justificacion_dificultad(76, 'Intermedio: distopia con contenido politico y simbolico').
justificacion_dificultad(77, 'Intermedio: convenciones sociales y lenguaje de epoca').
justificacion_dificultad(78, 'Intermedio: estructura retrospectiva y multiples testimonios').
justificacion_dificultad(79, 'Intermedio: saltos de tiempo y voces narrativas').
justificacion_dificultad(80, 'Avanzado: estructura experimental y lectura no lineal').

% Regla experta: la divulgacion de nivel intermedio puede servir como
% alternativa introductoria al nivel basico, pero puntua menos que el basico.
adecuacion_nivel(cualquiera, _, _, 0, []) :- !.
adecuacion_nivel(Nivel, Nivel, _, 2, [nivel_exacto(Nivel)]) :- !.
adecuacion_nivel(basico, intermedio, divulgacion, 1,
                 [nivel_intermedio_accesible_por_divulgacion]) :- !.
adecuacion_nivel(_, _, _, 0, []).

% Tema y genero son condiciones estrictas; nivel y formato ordenan alternativas.
recomendar(pref(Tema, Genero, Nivel, Formato), Id, Puntos, Motivos) :-
    nonvar(Tema),
    tema(Tema, _),
    opcion_catalogo(genero, Genero),
    opcion_catalogo(nivel, Nivel),
    opcion_catalogo(formato, Formato),
    tema_de_libro(Id, Tema, PT, MT),
    libro(Id, _, GeneroLibro, NivelLibro, _, FormatoLibro, _),
    opcion_estricta(Genero, GeneroLibro),
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

% Opciones del menu derivadas de libros existentes, no combinaciones inventadas.
generos_disponibles(Generos) :-
    findall(Genero, libro(_, _, Genero, _, _, _, _), Hallados),
    sort(Hallados, Generos).

temas_disponibles(Genero, Temas) :-
    findall(Tema,
            (tema_de_libro(Id, Tema, _, _),
             libro(Id, _, GeneroLibro, _, _, _, _),
             opcion_estricta(Genero, GeneroLibro)), Hallados),
    sort(Hallados, Temas).

niveles_disponibles(Genero, Tema, Niveles) :-
    findall(Nivel,
            (tema_de_libro(Id, Tema, _, _),
             libro(Id, _, GeneroLibro, Nivel, _, _, _),
             opcion_estricta(Genero, GeneroLibro)), Hallados),
    sort(Hallados, Niveles).

formatos_disponibles(Genero, Tema, Nivel, Formatos) :-
    findall(Formato,
            (tema_de_libro(Id, Tema, _, _),
             libro(Id, _, GeneroLibro, NivelLibro, _, Formato, _),
             opcion_estricta(Genero, GeneroLibro),
             opcion_estricta(Nivel, NivelLibro)), Hallados),
    sort(Hallados, Formatos).

% Auditoria de integridad; [] indica que no se detectaron errores.
validar_catalogo(Errores) :-
    findall(Error, problema_catalogo(Error), Hallados),
    sort(Hallados, Errores).

catalogo_valido :-
    validar_catalogo([]).

problema_catalogo(libro_sin_autor(Id)) :-
    libro(Id, _, _, _, _, _, _),
    \+ libro_autor(Id, _).
problema_catalogo(autor_sin_libro(Id)) :-
    autor(Id, _),
    \+ libro_autor(_, Id).
problema_catalogo(libro_invalido(Id)) :-
    libro(Id, _, Genero, Nivel, Tema, Formato, Editorial),
    ( \+ genero(Genero, _)
    ; \+ nivel(Nivel, _)
    ; \+ tema(Tema, _)
    ; \+ formato(Formato, _)
    ; Editorial == ''
    ).
problema_catalogo(libro_id_duplicado(Id)) :-
    libro(Id, _, _, _, _, _, _),
    aggregate_all(count, libro(Id, _, _, _, _, _, _), N),
    N > 1.
problema_catalogo(relacion_autor_huerfana(IdLibro, IdAutor)) :-
    libro_autor(IdLibro, IdAutor),
    ( \+ libro(IdLibro, _, _, _, _, _, _)
    ; \+ autor(IdAutor, _)
    ).
problema_catalogo(relacion_tematica_invalida(IdLibro, Tema)) :-
    relacion_tematica(IdLibro, Tema, _),
    ( \+ libro(IdLibro, _, _, _, _, _, _)
    ; \+ tema(Tema, _)
    ; libro(IdLibro, _, _, _, Tema, _, _)
    ).
problema_catalogo(novela_sin_justificacion(IdLibro)) :-
    libro(IdLibro, _, novela, _, _, _, _),
    \+ justificacion_dificultad(IdLibro, _).
problema_catalogo(justificacion_sin_novela(IdLibro)) :-
    justificacion_dificultad(IdLibro, _),
    \+ libro(IdLibro, _, novela, _, _, _, _).
problema_catalogo(preferencia_invalida(IdPreferencia)) :-
    preferencia(IdPreferencia, IdEstudiante, Tema, Genero, Nivel, Formato),
    ( \+ estudiante(IdEstudiante, _)
    ; \+ tema(Tema, _)
    ; \+ opcion_catalogo(genero, Genero)
    ; \+ opcion_catalogo(nivel, Nivel)
    ; \+ opcion_catalogo(formato, Formato)
    ).
problema_catalogo(preferencia_sin_libros(IdPreferencia)) :-
    perfil_preferencia(IdPreferencia, Perfil),
    \+ recomendar(Perfil, _, _, _).
problema_catalogo(recomendacion_guardada_invalida(IdRecomendacion)) :-
    recomendacion_guardada(IdRecomendacion, IdPreferencia, IdLibro),
    ( \+ perfil_preferencia(IdPreferencia, _)
    ; \+ libro(IdLibro, _, _, _, _, _, _)
    ; ( perfil_preferencia(IdPreferencia, Perfil),
        \+ recomendar(Perfil, IdLibro, _, _) )
    ).

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
    writeln('Puedes usar tildes en las frases; Enter omite preferencias opcionales.'),
    menu.

menu :-
    nl,
    writeln('1. Consulta guiada con filtros contextuales'),
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
    writeln('Las opciones cambian segun el catalogo. Enter omite genero, nivel o formato.'),
    generos_disponibles(Generos),
    pedir_opciones('¿Que genero prefieres?', Generos, opcional, Genero),
    temas_disponibles(Genero, Temas),
    pedir_opciones('¿Que tema quieres leer o aprender?', Temas, tema, Tema),
    ( Tema == salir -> true
    ; niveles_disponibles(Genero, Tema, Niveles),
      writeln('Nivel = dificultad de lectura (tambien para novelas).'),
      pedir_si_hay_variedad('nivel', '¿Que nivel prefieres?', Niveles, Nivel),
      formatos_disponibles(Genero, Tema, Nivel, Formatos),
      pedir_si_hay_variedad('formato', '¿Que formato prefieres?', Formatos, Formato),
      Perfil = pref(Tema, Genero, Nivel, Formato),
      recomendaciones(Perfil, Resultados),
      mostrar(Perfil, Resultados)
    ).

pedir_si_hay_variedad(Nombre, _, [Unico], cualquiera) :-
    format('Solo hay ~w ~w para esta seleccion; omito la pregunta.~n',
           [Nombre, Unico]), !.
pedir_si_hay_variedad(_, Pregunta, Valores, Respuesta) :-
    pedir_opciones(Pregunta, Valores, opcional, Respuesta).

pedir_opciones(Pregunta, Validos, Tipo, Respuesta) :-
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
        ( Resultados == [], Perfil = pref(_, Genero, _, _), Genero \== cualquiera ->
            temas_disponibles(Genero, Temas),
            format('Temas disponibles para ~w: ~w~n', [Genero, Temas])
        ; true ),
        mostrar(Perfil, Resultados)
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
alias_catalogo(tema, "romance", amor).
alias_catalogo(tema, "romantico", amor).
alias_catalogo(tema, "romantica", amor).
alias_catalogo(tema, "romanticos", amor).
alias_catalogo(tema, "romanticas", amor).
alias_catalogo(genero, "divulgativo", divulgacion).
alias_catalogo(genero, "divulgativos", divulgacion).
alias_catalogo(genero, "ensayos", ensayo).
alias_catalogo(genero, "manuales", manual).
alias_catalogo(genero, "novelas", novela).
alias_catalogo(nivel, "basicos", basico).
alias_catalogo(nivel, "basica", basico).
alias_catalogo(nivel, "basicas", basico).
alias_catalogo(nivel, "principiante", basico).
alias_catalogo(nivel, "principiantes", basico).
alias_catalogo(nivel, "intermedios", intermedio).
alias_catalogo(nivel, "intermedia", intermedio).
alias_catalogo(nivel, "intermedias", intermedio).
alias_catalogo(nivel, "medio", intermedio).
alias_catalogo(nivel, "avanzados", avanzado).
alias_catalogo(nivel, "avanzada", avanzado).
alias_catalogo(nivel, "avanzadas", avanzado).
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
             mostrar(Perfil, Resultados))).

historial_estudiante :-
    pedir_estudiante(IdEstudiante),
    estudiante(IdEstudiante, Nombre),
    format('Historial de ~w:~n', [Nombre]),
    findall(registro(IdRec, Titulo, Motivos),
            (detalle_recomendacion(IdRec, IdEstudiante, IdLibro, _, Motivos),
             libro(IdLibro, Titulo, _, _, _, _, _)),
            Historial),
    ( Historial == [] -> writeln('Todavia no hay recomendaciones guardadas.')
    ; forall(member(registro(IdRec, Titulo, Motivos), Historial),
             (texto_motivos(Motivos, Explicacion),
              format('Registro ~d: ~w | ~w~n',
                     [IdRec, Titulo, Explicacion])))
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

mostrar(_, []) :-
    writeln('No hay libros con esa combinacion de genero y tema.'),
    writeln('Prueba otra combinacion en la consulta guiada (opcion 1).').
mostrar(Perfil, Resultados) :-
    Resultados \== [],
    include(exacta(Perfil), Resultados, Exactas),
    exclude(exacta(Perfil), Resultados, Aproximadas),
    nl,
    ( Exactas == [] -> writeln('No hay coincidencias exactas con todos los filtros.')
    ; writeln('=== Coincidencias exactas ==='),
      forall(member(Resultado, Exactas), mostrar_exacta(Resultado))
    ),
    ( Aproximadas == [] -> true
    ; nl, writeln('=== Posibles recomendaciones (no cumplen todos los filtros) ==='),
      forall(member(Resultado, Aproximadas), mostrar_aproximada(Perfil, Resultado))
    ),
    nl.

exacta(Perfil, recomendacion(Id, _, _, _, _)) :-
    coincidencia_total(Perfil, Id).

mostrar_exacta(recomendacion(Id, Titulo, Autores, _, Motivos)) :-
    atomic_list_concat(Autores, ', ', Nombres),
    texto_motivos(Motivos, Explicacion),
    editorial_visible(Id, Editorial),
    format('~d. ~w - ~w | editorial: ~w | ~w~n',
           [Id, Titulo, Nombres, Editorial, Explicacion]).

mostrar_aproximada(Perfil, recomendacion(Id, Titulo, Autores, Puntos, Motivos)) :-
    atomic_list_concat(Autores, ', ', Nombres),
    texto_motivos(Motivos, Explicacion),
    diferencias(Perfil, Id, Faltantes),
    editorial_visible(Id, Editorial),
    format('~d. ~w - ~w | editorial: ~w | cercania: ~d | ~w | difiere en: ~w~n',
           [Id, Titulo, Nombres, Editorial, Puntos, Explicacion, Faltantes]).

editorial_visible(Id, Editorial) :-
    libro(Id, _, _, _, _, _, Dato),
    ( Dato == pendiente_de_verificar -> Editorial = 'por verificar'
    ; Editorial = Dato ).

diferencias(pref(_, _, Nivel, Formato), Id, Texto) :-
    libro(Id, _, _, NivelLibro, _, FormatoLibro, _),
    findall(Diferencia,
            ( (Nivel \== cualquiera, Nivel \== NivelLibro,
               format(atom(Diferencia), 'nivel ~w (pediste ~w)', [NivelLibro, Nivel]))
            ; (Formato \== cualquiera, Formato \== FormatoLibro,
               format(atom(Diferencia), 'formato ~w (pediste ~w)', [FormatoLibro, Formato]))
            ), Faltantes),
    atomic_list_concat(Faltantes, '; ', Texto).

texto_motivos(Motivos, Explicacion) :-
    maplist(descripcion_motivo, Motivos, Descripciones),
    atomic_list_concat(Descripciones, '; ', Explicacion).

descripcion_motivo(tema_secundario(Tema, Justificacion), Texto) :-
    tema(Tema, Nombre),
    format(atom(Texto), 'tema relacionado: ~w (~w)', [Nombre, Justificacion]).
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
