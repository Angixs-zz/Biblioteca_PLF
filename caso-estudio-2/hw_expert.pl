:- encoding(utf8).
%% ==================================================================
%%  HW-Expert: Sistema Experto para Configuración de Hardware y
%%  Diagnóstico de Rendimiento
%%  Caso de Estudio 2 - Prolog (probado en SWI-Prolog 9.x)
%%
%%  Uso:   swipl hw_expert.pl
%%         (el MENÚ interactivo arranca solo si hay una terminal; también: ?- menu.)
%%         swipl -g demo -t halt hw_expert.pl     % demo sin abrir el menú
%%         swipl pruebas_hw_expert.pl             % pruebas automatizadas
%%         ?- ayuda.                              % lista de consultas disponibles
%%
%%  Convenciones:
%%   - Precios en pesos mexicanos (MXN), aprox. con tipo de cambio 18.5. Consumos en Watts (TDP / consumo típico).
%%   - Sockets y tipos de RAM son átomos: lga1700, am5, ddr4, ddr5 ...
%%   - Cada registro de memoria_ram es un kit con la capacidad total.
%%   - El cálculo energético y el balance CPU/GPU son heurísticos y
%%     académicos: no sustituyen benchmarks ni la validación del fabricante.
%% ==================================================================

:- use_module(library(aggregate)).
:- use_module(library(lists)).
:- use_module(library(readutil)).


% ============================================================
% 1. procesador(Id, Marca, Modelo, Socket, Cores, Hilos, ConsumoWatts, Precio)
% ============================================================
procesador(1, 'Intel', 'Pentium Gold G7400', lga1700, 2, 4, 46, 1440).
procesador(2, 'Intel', 'Core i3-12100F', lga1700, 4, 8, 58, 1800).
procesador(3, 'Intel', 'Core i3-12100', lga1700, 4, 8, 60, 2340).
procesador(4, 'Intel', 'Core i3-13100', lga1700, 4, 8, 60, 2520).
procesador(5, 'Intel', 'Core i3-14100', lga1700, 4, 8, 60, 2700).
procesador(6, 'Intel', 'Core i5-12400F', lga1700, 6, 12, 65, 2880).
procesador(7, 'Intel', 'Core i5-12400', lga1700, 6, 12, 65, 3330).
procesador(8, 'Intel', 'Core i5-12600K', lga1700, 10, 16, 125, 4500).
procesador(9, 'Intel', 'Core i5-13400F', lga1700, 10, 16, 65, 3960).
procesador(10, 'Intel', 'Core i5-13400', lga1700, 10, 16, 65, 4320).
procesador(11, 'Intel', 'Core i5-13600K', lga1700, 14, 20, 125, 5760).
procesador(12, 'Intel', 'Core i5-14400F', lga1700, 10, 16, 65, 3780).
procesador(13, 'Intel', 'Core i5-14600K', lga1700, 14, 20, 125, 5580).
procesador(14, 'Intel', 'Core i7-12700', lga1700, 12, 20, 65, 5400).
procesador(15, 'Intel', 'Core i7-12700K', lga1700, 12, 20, 125, 5940).
procesador(16, 'Intel', 'Core i7-13700', lga1700, 16, 24, 65, 6840).
procesador(17, 'Intel', 'Core i7-13700K', lga1700, 16, 24, 125, 7200).
procesador(18, 'Intel', 'Core i7-14700', lga1700, 20, 28, 65, 7200).
procesador(19, 'Intel', 'Core i7-14700K', lga1700, 20, 28, 125, 7380).
procesador(20, 'Intel', 'Core i9-12900K', lga1700, 16, 24, 125, 8100).
procesador(21, 'Intel', 'Core i9-13900K', lga1700, 24, 32, 125, 9900).
procesador(22, 'Intel', 'Core i9-14900K', lga1700, 24, 32, 125, 10620).
procesador(23, 'Intel', 'Core i3-10100', lga1200, 4, 8, 65, 1980).
procesador(24, 'Intel', 'Core i5-10400F', lga1200, 6, 12, 65, 2340).
procesador(25, 'Intel', 'Core i5-11400', lga1200, 6, 12, 65, 3060).
procesador(26, 'Intel', 'Core i5-11600K', lga1200, 6, 12, 125, 4140).
procesador(27, 'Intel', 'Core i7-10700K', lga1200, 8, 16, 125, 5400).
procesador(28, 'Intel', 'Core i7-11700K', lga1200, 8, 16, 125, 5940).
procesador(29, 'Intel', 'Core i9-10900K', lga1200, 10, 20, 125, 7200).
procesador(30, 'Intel', 'Core i9-11900K', lga1200, 8, 16, 125, 8100).
procesador(31, 'Intel', 'Core Ultra 5 245K', lga1851, 14, 14, 125, 5580).
procesador(32, 'Intel', 'Core Ultra 7 265K', lga1851, 20, 20, 125, 7200).
procesador(33, 'Intel', 'Core Ultra 9 285K', lga1851, 24, 24, 125, 10800).
procesador(34, 'AMD', 'Ryzen 3 4100', am4, 4, 8, 65, 1620).
procesador(35, 'AMD', 'Ryzen 5 3600', am4, 6, 12, 65, 2160).
procesador(36, 'AMD', 'Ryzen 5 5500', am4, 6, 12, 65, 1980).
procesador(37, 'AMD', 'Ryzen 5 5600', am4, 6, 12, 65, 2340).
procesador(38, 'AMD', 'Ryzen 5 5600X', am4, 6, 12, 65, 2880).
procesador(39, 'AMD', 'Ryzen 7 5700X', am4, 8, 16, 65, 3240).
procesador(40, 'AMD', 'Ryzen 7 5800X', am4, 8, 16, 105, 4140).
procesador(41, 'AMD', 'Ryzen 7 5800X3D', am4, 8, 16, 105, 5940).
procesador(42, 'AMD', 'Ryzen 9 5900X', am4, 12, 24, 105, 5940).
procesador(43, 'AMD', 'Ryzen 9 5950X', am4, 16, 32, 105, 8100).
procesador(44, 'AMD', 'Ryzen 5 7600', am5, 6, 12, 65, 4140).
procesador(45, 'AMD', 'Ryzen 5 7600X', am5, 6, 12, 105, 4500).
procesador(46, 'AMD', 'Ryzen 7 7700', am5, 8, 16, 65, 5760).
procesador(47, 'AMD', 'Ryzen 7 7700X', am5, 8, 16, 105, 6120).
procesador(48, 'AMD', 'Ryzen 7 7800X3D', am5, 8, 16, 120, 8100).
procesador(49, 'AMD', 'Ryzen 9 7900', am5, 12, 24, 65, 7740).
procesador(50, 'AMD', 'Ryzen 9 7900X', am5, 12, 24, 170, 8100).
procesador(51, 'AMD', 'Ryzen 9 7950X', am5, 16, 32, 170, 10800).
procesador(52, 'AMD', 'Ryzen 9 7950X3D', am5, 16, 32, 120, 11700).
procesador(53, 'AMD', 'Ryzen 5 8600G', am5, 6, 12, 65, 4140).
procesador(54, 'AMD', 'Ryzen 7 8700G', am5, 8, 16, 65, 5940).
procesador(55, 'AMD', 'Ryzen 5 9600X', am5, 6, 12, 65, 5040).
procesador(56, 'AMD', 'Ryzen 7 9700X', am5, 8, 16, 65, 6480).
procesador(57, 'AMD', 'Ryzen 9 9900X', am5, 12, 24, 120, 7920).
procesador(58, 'AMD', 'Ryzen 9 9950X', am5, 16, 32, 170, 10440).
procesador(59, 'AMD', 'Ryzen 7 9800X3D', am5, 8, 16, 120, 8640).

% ============================================================
% 2. placa_madre(Id, Modelo, Socket, TipoRAM, SlotsRAM, ConsumoWatts, Precio)
% ============================================================
placa_madre(1, 'ASUS PRIME H610M-K D4', lga1700, ddr4, 2, 25, 1530).
placa_madre(2, 'Gigabyte B660M DS3H DDR4', lga1700, ddr4, 4, 30, 2070).
placa_madre(3, 'MSI PRO B660M-A DDR4', lga1700, ddr4, 4, 30, 2250).
placa_madre(4, 'ASUS TUF B760M-PLUS D4', lga1700, ddr4, 4, 35, 2880).
placa_madre(5, 'MSI MAG B760M Mortar DDR4', lga1700, ddr4, 4, 35, 2970).
placa_madre(6, 'Gigabyte Z690 UD DDR4', lga1700, ddr4, 4, 40, 3420).
placa_madre(7, 'ASRock Z790 Pro RS D4', lga1700, ddr4, 4, 45, 3600).
placa_madre(8, 'ASUS PRIME Z790-P D4', lga1700, ddr4, 4, 45, 3780).
placa_madre(9, 'MSI MAG Z790 Tomahawk DDR4', lga1700, ddr4, 4, 50, 4500).
placa_madre(10, 'ASUS PRIME B760M-A WIFI', lga1700, ddr5, 4, 35, 3060).
placa_madre(11, 'MSI PRO B760M-P DDR5', lga1700, ddr5, 2, 35, 2340).
placa_madre(12, 'Gigabyte B760 Gaming X AX', lga1700, ddr5, 4, 35, 3150).
placa_madre(13, 'ASRock B760 Pro RS', lga1700, ddr5, 4, 35, 2700).
placa_madre(14, 'ASUS TUF GAMING Z790-PLUS WIFI', lga1700, ddr5, 4, 50, 5220).
placa_madre(15, 'MSI MPG Z790 Carbon WIFI', lga1700, ddr5, 4, 55, 7200).
placa_madre(16, 'Gigabyte Z790 AORUS Elite AX', lga1700, ddr5, 4, 50, 4680).
placa_madre(17, 'ASUS ROG STRIX Z790-E GAMING', lga1700, ddr5, 4, 60, 8640).
placa_madre(18, 'ASUS ROG MAXIMUS Z790 HERO', lga1700, ddr5, 4, 60, 11340).
placa_madre(19, 'ASRock Z790 Taichi', lga1700, ddr5, 4, 60, 9000).
placa_madre(20, 'ASUS PRIME H410M-E', lga1200, ddr4, 2, 25, 1260).
placa_madre(21, 'Gigabyte H510M H', lga1200, ddr4, 2, 25, 1350).
placa_madre(22, 'MSI B460M-A PRO', lga1200, ddr4, 2, 30, 1530).
placa_madre(23, 'ASUS PRIME B560M-A', lga1200, ddr4, 4, 30, 1980).
placa_madre(24, 'Gigabyte B560M DS3H', lga1200, ddr4, 4, 30, 1890).
placa_madre(25, 'MSI MAG B560M Mortar', lga1200, ddr4, 4, 35, 2520).
placa_madre(26, 'ASUS TUF GAMING Z490-PLUS', lga1200, ddr4, 4, 40, 3240).
placa_madre(27, 'Gigabyte Z590 UD AC', lga1200, ddr4, 4, 40, 3060).
placa_madre(28, 'MSI MPG Z590 Gaming Plus', lga1200, ddr4, 4, 45, 3420).
placa_madre(29, 'ASUS ROG STRIX Z590-E GAMING', lga1200, ddr4, 4, 50, 5400).
placa_madre(30, 'ASUS PRIME A320M-K', am4, ddr4, 2, 20, 1080).
placa_madre(31, 'MSI A520M-A PRO', am4, ddr4, 4, 25, 1260).
placa_madre(32, 'Gigabyte A520M DS3H', am4, ddr4, 4, 25, 1350).
placa_madre(33, 'ASRock B450M Pro4', am4, ddr4, 4, 25, 1530).
placa_madre(34, 'MSI B450 TOMAHAWK MAX II', am4, ddr4, 4, 25, 1980).
placa_madre(35, 'ASUS TUF B450-PLUS GAMING', am4, ddr4, 4, 25, 2070).
placa_madre(36, 'Gigabyte B550M DS3H', am4, ddr4, 4, 30, 1800).
placa_madre(37, 'MSI MAG B550-A PRO', am4, ddr4, 4, 30, 2250).
placa_madre(38, 'ASUS TUF GAMING B550-PLUS', am4, ddr4, 4, 35, 2880).
placa_madre(39, 'Gigabyte B550 AORUS Elite', am4, ddr4, 4, 35, 2700).
placa_madre(40, 'MSI MAG B550 Tomahawk', am4, ddr4, 4, 35, 3060).
placa_madre(41, 'ASUS ROG STRIX B550-F GAMING', am4, ddr4, 4, 40, 3420).
placa_madre(42, 'Gigabyte X570 AORUS Elite', am4, ddr4, 4, 45, 3600).
placa_madre(43, 'MSI MPG X570 Gaming Plus', am4, ddr4, 4, 45, 3420).
placa_madre(44, 'ASUS ROG CROSSHAIR VIII Hero', am4, ddr4, 4, 55, 6840).
placa_madre(45, 'ASUS PRIME A620M-K', am5, ddr5, 2, 25, 1800).
placa_madre(46, 'MSI PRO A620M-E', am5, ddr5, 2, 25, 1710).
placa_madre(47, 'Gigabyte A620M S2H', am5, ddr5, 2, 25, 1800).
placa_madre(48, 'ASRock A620M Pro RS', am5, ddr5, 4, 25, 1980).
placa_madre(49, 'MSI MAG B650 Tomahawk WIFI', am5, ddr5, 4, 35, 3960).
placa_madre(50, 'ASUS TUF GAMING B650-PLUS WIFI', am5, ddr5, 4, 35, 3780).
placa_madre(51, 'Gigabyte B650 AORUS Elite AX', am5, ddr5, 4, 40, 4140).
placa_madre(52, 'ASRock B650E PG Riptide', am5, ddr5, 4, 40, 3600).
placa_madre(53, 'ASUS ROG STRIX B650E-F GAMING', am5, ddr5, 4, 45, 5400).
placa_madre(54, 'MSI MPG X670E Carbon WIFI', am5, ddr5, 4, 55, 8640).
placa_madre(55, 'ASUS ROG CROSSHAIR X670E Hero', am5, ddr5, 4, 60, 12600).
placa_madre(56, 'Gigabyte X670E AORUS Master', am5, ddr5, 4, 60, 9000).
placa_madre(57, 'ASUS ProArt X670E-CREATOR WIFI', am5, ddr5, 4, 60, 8640).
placa_madre(58, 'MSI MAG X870 Tomahawk WIFI', am5, ddr5, 4, 50, 5940).
placa_madre(59, 'ASUS ROG STRIX X870E-E GAMING', am5, ddr5, 4, 65, 9000).
placa_madre(60, 'Gigabyte X870 AORUS Elite WIFI7', am5, ddr5, 4, 50, 4680).
placa_madre(61, 'ASUS PRIME Z890-P', lga1851, ddr5, 4, 50, 5400).
placa_madre(62, 'MSI PRO Z890-P WIFI', lga1851, ddr5, 4, 50, 5040).
placa_madre(63, 'Gigabyte Z890 AORUS Elite WIFI7', lga1851, ddr5, 4, 55, 6480).
placa_madre(64, 'ASUS ROG STRIX Z890-E GAMING', lga1851, ddr5, 4, 65, 9360).

% ============================================================
% 3. memoria_ram(Id, Marca, Tipo, CapacidadGB, VelocidadMHz, Precio)
%    (cada registro representa un kit completo de la capacidad indicada)
% ============================================================
memoria_ram(1, 'Kingston', ddr4, 8, 3200, 450).
memoria_ram(2, 'Kingston', ddr4, 16, 3200, 756).
memoria_ram(3, 'Kingston', ddr4, 32, 3200, 1440).
memoria_ram(4, 'Kingston', ddr4, 16, 3600, 900).
memoria_ram(5, 'Corsair', ddr4, 16, 3200, 864).
memoria_ram(6, 'Corsair', ddr4, 32, 3200, 1620).
memoria_ram(7, 'Corsair', ddr4, 32, 3600, 1800).
memoria_ram(8, 'Corsair', ddr4, 64, 3600, 3420).
memoria_ram(9, 'Corsair', ddr4, 16, 3600, 990).
memoria_ram(10, 'G.Skill', ddr4, 16, 3200, 810).
memoria_ram(11, 'G.Skill', ddr4, 16, 3600, 936).
memoria_ram(12, 'G.Skill', ddr4, 32, 3600, 1710).
memoria_ram(13, 'G.Skill', ddr4, 64, 3600, 3330).
memoria_ram(14, 'G.Skill', ddr4, 8, 2666, 396).
memoria_ram(15, 'Crucial', ddr4, 8, 2666, 360).
memoria_ram(16, 'Crucial', ddr4, 16, 3200, 720).
memoria_ram(17, 'Crucial', ddr4, 32, 3200, 1404).
memoria_ram(18, 'Crucial', ddr4, 64, 3200, 3060).
memoria_ram(19, 'TeamGroup', ddr4, 8, 3200, 432).
memoria_ram(20, 'TeamGroup', ddr4, 16, 3200, 738).
memoria_ram(21, 'TeamGroup', ddr4, 32, 3200, 1476).
memoria_ram(22, 'TeamGroup', ddr4, 32, 3600, 1656).
memoria_ram(23, 'Patriot', ddr4, 8, 2666, 378).
memoria_ram(24, 'Patriot', ddr4, 16, 3200, 774).
memoria_ram(25, 'Patriot', ddr4, 16, 3600, 882).
memoria_ram(26, 'Patriot', ddr4, 32, 3200, 1512).
memoria_ram(27, 'Kingston', ddr5, 16, 4800, 990).
memoria_ram(28, 'Kingston', ddr5, 16, 5600, 1116).
memoria_ram(29, 'Kingston', ddr5, 32, 5200, 1800).
memoria_ram(30, 'Kingston', ddr5, 32, 6000, 2070).
memoria_ram(31, 'Kingston', ddr5, 64, 5600, 3780).
memoria_ram(32, 'Corsair', ddr5, 16, 5600, 1170).
memoria_ram(33, 'Corsair', ddr5, 32, 5600, 1890).
memoria_ram(34, 'Corsair', ddr5, 32, 6000, 2250).
memoria_ram(35, 'Corsair', ddr5, 32, 6400, 2520).
memoria_ram(36, 'Corsair', ddr5, 64, 6000, 4140).
memoria_ram(37, 'Corsair', ddr5, 96, 6000, 5760).
memoria_ram(38, 'G.Skill', ddr5, 16, 6000, 1296).
memoria_ram(39, 'G.Skill', ddr5, 32, 6000, 2124).
memoria_ram(40, 'G.Skill', ddr5, 32, 6400, 2430).
memoria_ram(41, 'G.Skill', ddr5, 32, 7200, 3060).
memoria_ram(42, 'G.Skill', ddr5, 64, 6400, 4230).
memoria_ram(43, 'G.Skill', ddr5, 96, 6800, 6120).
memoria_ram(44, 'Crucial', ddr5, 16, 4800, 936).
memoria_ram(45, 'Crucial', ddr5, 32, 5600, 1764).
memoria_ram(46, 'Crucial', ddr5, 64, 5600, 3600).
memoria_ram(47, 'TeamGroup', ddr5, 16, 5600, 1134).
memoria_ram(48, 'TeamGroup', ddr5, 32, 6000, 2016).
memoria_ram(49, 'TeamGroup', ddr5, 64, 6000, 3870).
memoria_ram(50, 'Patriot', ddr5, 16, 5600, 1080).
memoria_ram(51, 'Patriot', ddr5, 32, 6000, 1980).
memoria_ram(52, 'Patriot', ddr5, 48, 6000, 3420).

% ============================================================
% 4. tarjeta_grafica(Id, Marca, Modelo, VRAM_GB, ConsumoWatts, PCIeVersion, Precio)
% ============================================================
tarjeta_grafica(1, 'NVIDIA', 'GeForce GT 1030', 2, 30, 3.0, 1440).
tarjeta_grafica(2, 'NVIDIA', 'GeForce GTX 1650', 4, 75, 3.0, 2700).
tarjeta_grafica(3, 'NVIDIA', 'GeForce GTX 1660 Super', 6, 125, 3.0, 3600).
tarjeta_grafica(4, 'NVIDIA', 'GeForce RTX 2060', 6, 160, 3.0, 3960).
tarjeta_grafica(5, 'NVIDIA', 'GeForce RTX 2070 Super', 8, 215, 3.0, 5400).
tarjeta_grafica(6, 'NVIDIA', 'GeForce RTX 2080 Ti', 11, 250, 3.0, 9000).
tarjeta_grafica(7, 'NVIDIA', 'GeForce RTX 3050', 8, 130, 4.0, 4140).
tarjeta_grafica(8, 'NVIDIA', 'GeForce RTX 3060', 12, 170, 4.0, 5400).
tarjeta_grafica(9, 'NVIDIA', 'GeForce RTX 3060 Ti', 8, 200, 4.0, 6300).
tarjeta_grafica(10, 'NVIDIA', 'GeForce RTX 3070', 8, 220, 4.0, 7200).
tarjeta_grafica(11, 'NVIDIA', 'GeForce RTX 3080', 10, 320, 4.0, 9900).
tarjeta_grafica(12, 'NVIDIA', 'GeForce RTX 3080 Ti', 12, 350, 4.0, 12600).
tarjeta_grafica(13, 'NVIDIA', 'GeForce RTX 3090', 24, 350, 4.0, 16200).
tarjeta_grafica(14, 'NVIDIA', 'GeForce RTX 4060', 8, 115, 4.0, 5400).
tarjeta_grafica(15, 'NVIDIA', 'GeForce RTX 4060 Ti 8GB', 8, 160, 4.0, 7200).
tarjeta_grafica(16, 'NVIDIA', 'GeForce RTX 4060 Ti (VRAM ampliada)', 16, 165, 4.0, 8100).
tarjeta_grafica(17, 'NVIDIA', 'GeForce RTX 4070', 12, 200, 4.0, 9900).
tarjeta_grafica(18, 'NVIDIA', 'GeForce RTX 4070 Super', 12, 220, 4.0, 10800).
tarjeta_grafica(19, 'NVIDIA', 'GeForce RTX 4070 Ti', 12, 285, 4.0, 13500).
tarjeta_grafica(20, 'NVIDIA', 'GeForce RTX 4070 Ti Super', 16, 285, 4.0, 14400).
tarjeta_grafica(21, 'NVIDIA', 'GeForce RTX 4080', 16, 320, 4.0, 18000).
tarjeta_grafica(22, 'NVIDIA', 'GeForce RTX 4080 Super', 16, 320, 4.0, 18000).
tarjeta_grafica(23, 'NVIDIA', 'GeForce RTX 4090', 24, 450, 4.0, 30600).
tarjeta_grafica(24, 'NVIDIA', 'GeForce RTX 5060', 8, 145, 5.0, 5400).
tarjeta_grafica(25, 'NVIDIA', 'GeForce RTX 5060 Ti', 16, 180, 5.0, 7740).
tarjeta_grafica(26, 'NVIDIA', 'GeForce RTX 5070', 12, 250, 5.0, 9900).
tarjeta_grafica(27, 'NVIDIA', 'GeForce RTX 5070 Ti', 16, 300, 5.0, 13500).
tarjeta_grafica(28, 'NVIDIA', 'GeForce RTX 5080', 16, 360, 5.0, 18000).
tarjeta_grafica(29, 'NVIDIA', 'GeForce RTX 5090', 32, 575, 5.0, 36000).
tarjeta_grafica(30, 'AMD', 'Radeon RX 6500 XT', 4, 107, 4.0, 2700).
tarjeta_grafica(31, 'AMD', 'Radeon RX 6600', 8, 132, 4.0, 3780).
tarjeta_grafica(32, 'AMD', 'Radeon RX 6650 XT', 8, 180, 4.0, 4320).
tarjeta_grafica(33, 'AMD', 'Radeon RX 6700 XT', 12, 230, 4.0, 5940).
tarjeta_grafica(34, 'AMD', 'Radeon RX 6750 XT', 12, 250, 4.0, 6480).
tarjeta_grafica(35, 'AMD', 'Radeon RX 6800', 16, 250, 4.0, 7560).
tarjeta_grafica(36, 'AMD', 'Radeon RX 6800 XT', 16, 300, 4.0, 9000).
tarjeta_grafica(37, 'AMD', 'Radeon RX 6900 XT', 16, 300, 4.0, 10800).
tarjeta_grafica(38, 'AMD', 'Radeon RX 7600', 8, 165, 4.0, 4680).
tarjeta_grafica(39, 'AMD', 'Radeon RX 7600 XT', 16, 190, 4.0, 5760).
tarjeta_grafica(40, 'AMD', 'Radeon RX 7700 XT', 12, 245, 4.0, 7200).
tarjeta_grafica(41, 'AMD', 'Radeon RX 7800 XT', 16, 263, 4.0, 9000).
tarjeta_grafica(42, 'AMD', 'Radeon RX 7900 GRE', 16, 260, 4.0, 9900).
tarjeta_grafica(43, 'AMD', 'Radeon RX 7900 XT', 20, 315, 4.0, 12600).
tarjeta_grafica(44, 'AMD', 'Radeon RX 7900 XTX', 24, 355, 4.0, 16200).
tarjeta_grafica(45, 'AMD', 'Radeon RX 9060 XT', 16, 160, 5.0, 6300).
tarjeta_grafica(46, 'AMD', 'Radeon RX 9070', 16, 220, 5.0, 9900).
tarjeta_grafica(47, 'AMD', 'Radeon RX 9070 XT', 16, 304, 5.0, 10800).
tarjeta_grafica(48, 'Intel', 'Arc A380', 6, 75, 4.0, 2160).
tarjeta_grafica(49, 'Intel', 'Arc A580', 8, 185, 4.0, 3240).
tarjeta_grafica(50, 'Intel', 'Arc A750', 8, 225, 4.0, 3600).
tarjeta_grafica(51, 'Intel', 'Arc A770', 16, 225, 4.0, 5400).
tarjeta_grafica(52, 'Intel', 'Arc B570', 10, 150, 4.0, 3960).
tarjeta_grafica(53, 'Intel', 'Arc B580', 12, 190, 4.0, 4500).

% ============================================================
% 5. fuente_poder(Id, Marca, Modelo, PotenciaWatts, Certificacion, Precio)
% ============================================================
fuente_poder(1, 'Corsair', 'CV450', 450, bronze, 900).
fuente_poder(2, 'Corsair', 'CV550', 550, bronze, 990).
fuente_poder(3, 'Corsair', 'CV650', 650, bronze, 1170).
fuente_poder(4, 'Corsair', 'CX550', 550, bronze, 1170).
fuente_poder(5, 'Corsair', 'CX650', 650, bronze, 1350).
fuente_poder(6, 'Corsair', 'CX750', 750, bronze, 1530).
fuente_poder(7, 'Corsair', 'RM650e', 650, gold, 1710).
fuente_poder(8, 'Corsair', 'RM750e', 750, gold, 1980).
fuente_poder(9, 'Corsair', 'RM850e', 850, gold, 2340).
fuente_poder(10, 'Corsair', 'RM1000e', 1000, gold, 2880).
fuente_poder(11, 'Corsair', 'RM1200e', 1200, gold, 3600).
fuente_poder(12, 'Corsair', 'HX1000', 1000, platinum, 4140).
fuente_poder(13, 'Corsair', 'HX1200', 1200, platinum, 4680).
fuente_poder(14, 'Corsair', 'SF750', 750, platinum, 3060).
fuente_poder(15, 'EVGA', '500 W1', 500, white, 720).
fuente_poder(16, 'EVGA', '600 W1', 600, white, 810).
fuente_poder(17, 'EVGA', '600 BR', 600, bronze, 990).
fuente_poder(18, 'EVGA', '700 BR', 700, bronze, 1170).
fuente_poder(19, 'EVGA', '750 GQ', 750, gold, 1800).
fuente_poder(20, 'EVGA', '850 GQ', 850, gold, 2160).
fuente_poder(21, 'EVGA', 'SuperNOVA 750 G6', 750, gold, 2160).
fuente_poder(22, 'EVGA', 'SuperNOVA 850 G6', 850, gold, 2520).
fuente_poder(23, 'EVGA', 'SuperNOVA 1000 G6', 1000, gold, 3240).
fuente_poder(24, 'EVGA', 'SuperNOVA 1300 G+', 1300, gold, 4680).
fuente_poder(25, 'Seasonic', 'Core GM-550', 550, gold, 1440).
fuente_poder(26, 'Seasonic', 'Focus GX-650', 650, gold, 1890).
fuente_poder(27, 'Seasonic', 'Focus GX-750', 750, gold, 2160).
fuente_poder(28, 'Seasonic', 'Focus GX-850', 850, gold, 2520).
fuente_poder(29, 'Seasonic', 'Focus GX-1000', 1000, gold, 3240).
fuente_poder(30, 'Seasonic', 'Prime PX-1300', 1300, platinum, 5940).
fuente_poder(31, 'Seasonic', 'Prime TX-1000', 1000, titanium, 6660).
fuente_poder(32, 'Cooler Master', 'MWE 550 Bronze V2', 550, bronze, 990).
fuente_poder(33, 'Cooler Master', 'MWE 650 Bronze V2', 650, bronze, 1170).
fuente_poder(34, 'Cooler Master', 'MWE 750 Bronze V2', 750, bronze, 1440).
fuente_poder(35, 'Cooler Master', 'MWE Gold 750 V2', 750, gold, 1800).
fuente_poder(36, 'Cooler Master', 'MWE Gold 850 V2', 850, gold, 2160).
fuente_poder(37, 'Cooler Master', 'V850 Gold V2', 850, gold, 2430).
fuente_poder(38, 'Cooler Master', 'V1000 Gold V2', 1000, gold, 3150).
fuente_poder(39, 'Cooler Master', 'V1300 Platinum', 1300, platinum, 5400).
fuente_poder(40, 'Thermaltake', 'Smart 500W', 500, white, 810).
fuente_poder(41, 'Thermaltake', 'Smart BM2 650W', 650, bronze, 1170).
fuente_poder(42, 'Thermaltake', 'Toughpower GF1 650W', 650, gold, 1620).
fuente_poder(43, 'Thermaltake', 'Toughpower GF1 750W', 750, gold, 1890).
fuente_poder(44, 'Thermaltake', 'Toughpower GF1 850W', 850, gold, 2250).
fuente_poder(45, 'Thermaltake', 'Toughpower GF3 1000W', 1000, gold, 3420).
fuente_poder(46, 'be quiet!', 'Pure Power 12 M 550W', 550, gold, 1620).
fuente_poder(47, 'be quiet!', 'Pure Power 12 M 750W', 750, gold, 2160).
fuente_poder(48, 'be quiet!', 'Straight Power 12 850W', 850, platinum, 3600).
fuente_poder(49, 'be quiet!', 'Dark Power 13 1000W', 1000, titanium, 5760).
fuente_poder(50, 'MSI', 'MAG A550BN', 550, bronze, 990).
fuente_poder(51, 'MSI', 'MAG A650BN', 650, bronze, 1170).
fuente_poder(52, 'MSI', 'MAG A750GL', 750, gold, 1890).
fuente_poder(53, 'MSI', 'MPG A850G PCIE5', 850, gold, 2700).
fuente_poder(54, 'MSI', 'MPG A1000G PCIE5', 1000, gold, 3330).
fuente_poder(55, 'Gigabyte', 'P550B', 550, bronze, 1080).
fuente_poder(56, 'Gigabyte', 'P750GM', 750, gold, 1980).
fuente_poder(57, 'Gigabyte', 'UD1000GM PG5', 1000, gold, 3060).

% ==================================================================
%  PREDICADOS AUXILIARES (acceso a precios y especificaciones)
% ==================================================================
precio_cpu(Id, P)  :- procesador(Id, _, _, _, _, _, _, P).
precio_mb(Id, P)   :- placa_madre(Id, _, _, _, _, _, P).
precio_ram(Id, P)  :- memoria_ram(Id, _, _, _, _, P).
precio_gpu(Id, P)  :- tarjeta_grafica(Id, _, _, _, _, _, P).
precio_psu(Id, P)  :- fuente_poder(Id, _, _, _, _, P).

precio_total(Cpu, Mb, Ram, Gpu, Psu, Total) :-
    precio_cpu(Cpu, A), precio_mb(Mb, B), precio_ram(Ram, C),
    precio_gpu(Gpu, D), precio_psu(Psu, E),
    Total is A + B + C + D + E.

% ==================================================================
%  REGLA 1: Validación de compatibilidad física y de arquitectura
%  CPU, placa madre y RAM son compatibles si y solo si:
%    1) Socket(CPU) == Socket(Placa)
%    2) TipoRAM(Placa) == Tipo(RAM)
%  (la unificación de la variable Socket / TipoRAM exige igualdad exacta)
% ==================================================================
compatibles(IdCpu, IdMb, IdRam) :-
    procesador(IdCpu, _, _, Socket, _, _, _, _),
    placa_madre(IdMb, _, Socket, TipoRAM, _, _, _),
    memoria_ram(IdRam, _, TipoRAM, _, _, _).

% Diagnóstico explicativo: indica por qué NO son compatibles.
incompatibilidad(IdCpu, IdMb, _, Motivo) :-
    procesador(IdCpu, _, _, SCpu, _, _, _, _),
    placa_madre(IdMb, _, SMb, _, _, _, _),
    SCpu \== SMb,
    format(atom(Motivo),
           'Socket incompatible: el procesador usa ~w y la placa usa ~w',
           [SCpu, SMb]).
incompatibilidad(_, IdMb, IdRam, Motivo) :-
    placa_madre(IdMb, _, _, TMb, _, _, _),
    memoria_ram(IdRam, _, TRam, _, _, _),
    TMb \== TRam,
    format(atom(Motivo),
           'Memoria incompatible: la placa soporta ~w y la RAM es ~w',
           [TMb, TRam]).

% Alcance real de la Regla 1. Los hechos de la práctica no incluyen
% chipset, versión de BIOS, capacidad máxima, número de módulos ni
% conectores, por lo que no es honesto afirmar compatibilidad física total.
advertencia_compatibilidad_fisica(
    'La validación cubre socket y tipo de RAM (DDR4/DDR5). No verifica versión de BIOS, chipset, capacidad máxima, número de módulos, velocidad soportada, conectores de la fuente, PCIe ni dimensiones físicas; confirma esos datos con el fabricante.').

% ==================================================================
%  REGLA 2: Evaluación de balance y seguridad energética
%    1) Consumo total = W(CPU) + W(Placa) + W(GPU)
%    2) Consumo con margen = Consumo total * 1.25
%    3) Potencia de la fuente >= Consumo con margen
% ==================================================================
consumo_total(IdCpu, IdMb, IdGpu, Total) :-
    procesador(IdCpu, _, _, _, _, _, WCpu, _),
    placa_madre(IdMb, _, _, _, _, WMb, _),
    tarjeta_grafica(IdGpu, _, _, _, WGpu, _, _),
    Total is WCpu + WMb + WGpu.

consumo_con_margen(IdCpu, IdMb, IdGpu, Requerido) :-
    consumo_total(IdCpu, IdMb, IdGpu, Total),
    Requerido is Total * 1.25.

fuente_suficiente(IdCpu, IdMb, IdGpu, IdPsu) :-
    consumo_con_margen(IdCpu, IdMb, IdGpu, Requerido),
    fuente_poder(IdPsu, _, _, Potencia, _, _),
    Potencia >= Requerido.

% Advertencias que NO cambian el resultado de la Regla 2, pero evitan
% presentar el cálculo simplificado como una garantía absoluta.
% El caso límite Potencia = Requerido sí se acepta (>=), tal como pide
% la regla; aquí solo se informa cuando la holgura es pequeña.
advertencias_energeticas(IdCpu, IdMb, IdGpu, IdPsu, Advertencias) :-
    consumo_con_margen(IdCpu, IdMb, IdGpu, Requerido),
    fuente_poder(IdPsu, _, _, Potencia, Certificacion, _),
    tarjeta_grafica(IdGpu, _, _, _, WattsGpu, _, _),
    findall(A, advertencia_energetica(Requerido, Potencia, Certificacion, WattsGpu, A),
            Advertencias).

advertencia_energetica(Requerido, Potencia, _, _,
        Mensaje) :-
    Potencia >= Requerido,
    Potencia < Requerido * 1.10,
    Holgura is Potencia - Requerido,
    format(atom(Mensaje),
           'Holgura energética menor al 10% (~1f W sobre ~1f W requeridos); conviene una fuente de mayor capacidad.',
           [Holgura, Requerido]).
advertencia_energetica(_, _, Certificacion, WattsGpu,
        Mensaje) :-
    WattsGpu >= 250,
    memberchk(Certificacion, [white, bronze]),
    format(atom(Mensaje),
           'GPU de ~w W con fuente 80+ ~w: revisa calidad, protecciones y conectores; el cálculo no modela picos transitorios.',
           [WattsGpu, Certificacion]).
advertencia_energetica(_, _, _, _,
    'El cálculo solo suma CPU + placa + GPU; no incluye RAM, almacenamiento, ventiladores, bomba de refrigeración ni picos transitorios.').

% ==================================================================
%  REGLA 3: Diagnóstico de cuellos de botella
%  Criterio académico obligatorio:
%    GPU con VRAM >= 16 GB y CPU con < 8 núcleos => cuello de botella.
%  Criterio heurístico adicional para configuraciones equilibradas:
%    VRAM >= 16 -> CPU >= 8 núcleos
%    VRAM >=  8 -> CPU >= 6 núcleos
%    VRAM <   8 -> CPU >= 4 núcleos
%  No es un ranking de rendimiento ni sustituye benchmarks reales.
% ==================================================================
gpu_gama_alta(IdGpu) :-
    tarjeta_grafica(IdGpu, _, _, VRAM, _, _, _),
    VRAM >= 16.

cpu_gama_alta(IdCpu) :-
    procesador(IdCpu, _, _, _, Cores, _, _, _),
    Cores >= 8.

cuello_botella(IdCpu, IdGpu, Mensaje) :-
    gpu_gama_alta(IdGpu),
    procesador(IdCpu, _, _, _, Cores, _, _, _),
    Cores < 8,
    Mensaje = 'El procesador limitará el desempeño de la tarjeta gráfica en tareas pesadas'.

% Mínimo de núcleos que la heurística considera coherente para cada
% nivel de VRAM. Es una regla de proporción, no una medición de FPS.
minimo_nucleos_equilibrio(VRAM, 8) :- VRAM >= 16, !.
minimo_nucleos_equilibrio(VRAM, 6) :- VRAM >=  8, !.
minimo_nucleos_equilibrio(_, 4).

equilibrio_ok(Cores, VRAM) :-
    minimo_nucleos_equilibrio(VRAM, Minimos),
    Cores >= Minimos.

configuracion_equilibrada(IdCpu, IdGpu) :-
    procesador(IdCpu, _, _, _, Cores, _, _, _),
    tarjeta_grafica(IdGpu, _, _, VRAM, _, _, _),
    equilibrio_ok(Cores, VRAM).

% Tres resultados posibles y mutuamente excluyentes:
%   cuello_botella(Mensaje)  -> se activó el criterio obligatorio
%   equilibrada              -> la heurística de núcleos/VRAM lo considera coherente
%   no_concluyente(Mensaje)  -> no se puede afirmar ninguna de las dos cosas
diagnostico_balance(IdCpu, IdGpu, cuello_botella(Mensaje)) :-
    cuello_botella(IdCpu, IdGpu, Mensaje), !.
diagnostico_balance(IdCpu, IdGpu, equilibrada) :-
    configuracion_equilibrada(IdCpu, IdGpu), !.
diagnostico_balance(IdCpu, IdGpu, no_concluyente(Mensaje)) :-
    procesador(IdCpu, _, _, _, Cores, _, _, _),
    tarjeta_grafica(IdGpu, _, _, VRAM, _, _, _),
    \+ cuello_botella(IdCpu, IdGpu, _),
    \+ configuracion_equilibrada(IdCpu, IdGpu),
    format(atom(Mensaje),
           'resultado no concluyente: GPU de ~w GB de VRAM con CPU de ~w núcleos; la heurística no permite afirmar equilibrio ni se activa el umbral obligatorio de cuello de botella.',
           [VRAM, Cores]).

% ------------------------------------------------------------------
%  Perfiles de uso (carga de trabajo): requisitos mínimos y pesos.
%  perfil_minimo(Perfil, MinNucleos, MinRAM_GB, MinVRAM_GB)
%  perfil_peso(Perfil, PesoCPU, PesoRAM, PesoGPU)
% ------------------------------------------------------------------
perfil_minimo(gaming,       6, 16,  8).
perfil_minimo(ia,           8, 32, 16).
perfil_minimo(renderizado,  8, 32, 12).
perfil_minimo(servidor_web, 8, 32,  0).
perfil_minimo(desarrollo,   6, 16,  0).

perfil_peso(gaming,       2, 1, 4).
perfil_peso(ia,           2, 2, 5).
perfil_peso(renderizado,  4, 2, 4).
perfil_peso(servidor_web, 5, 4, 0).
perfil_peso(desarrollo,   4, 3, 1).

% Alertas según la carga de trabajo asignada.
alerta_perfil(Perfil, IdCpu, _, _, Msg) :-
    perfil_minimo(Perfil, MinC, _, _),
    procesador(IdCpu, _, _, _, Cores, _, _, _), Cores < MinC,
    format(atom(Msg), 'CPU con ~w núcleos: insuficiente para ~w (mínimo ~w)',
           [Cores, Perfil, MinC]).
alerta_perfil(Perfil, _, IdRam, _, Msg) :-
    perfil_minimo(Perfil, _, MinR, _),
    memoria_ram(IdRam, _, _, Cap, _, _), Cap < MinR,
    format(atom(Msg), 'RAM de ~w GB: insuficiente para ~w (mínimo ~w GB)',
           [Cap, Perfil, MinR]).
alerta_perfil(Perfil, _, _, IdGpu, Msg) :-
    perfil_minimo(Perfil, _, _, MinV),
    tarjeta_grafica(IdGpu, _, _, VRAM, _, _, _), VRAM < MinV,
    format(atom(Msg), 'GPU con ~w GB de VRAM: insuficiente para ~w (mínimo ~w GB)',
           [VRAM, Perfil, MinV]).

cumple_perfil(Perfil, IdCpu, IdRam, IdGpu) :-
    perfil_minimo(Perfil, MinC, MinR, MinV),
    procesador(IdCpu, _, _, _, Cores, _, _, _), Cores >= MinC,
    memoria_ram(IdRam, _, _, Cap, _, _),        Cap >= MinR,
    tarjeta_grafica(IdGpu, _, _, VRAM, _, _, _), VRAM >= MinV.

% Topes de aprovechamiento por perfil: más allá de estos valores el
% perfil ya no obtiene beneficio (ej. un videojuego no usa 96 GB de RAM).
% perfil_tope(Perfil, MaxNucleosUtiles, MaxRAM_GBUtil)
perfil_tope(gaming,        8,  32).
perfil_tope(ia,           16, 128).
perfil_tope(renderizado,  32, 128).
perfil_tope(servidor_web, 32, 128).
perfil_tope(desarrollo,   12,  32).

% Tope de VRAM que la heurística considera aprovechable por perfil.
% perfil_tope_gpu(Perfil, MaxVRAM_GBUtil)
perfil_tope_gpu(gaming,       16).
perfil_tope_gpu(ia,           24).
perfil_tope_gpu(renderizado,  24).
perfil_tope_gpu(servidor_web,  8).
perfil_tope_gpu(desarrollo,    8).

% Puntaje heurístico de rendimiento (para elegir "la mejor" configuración).
% No es un benchmark. Solo usa datos disponibles en los hechos:
%   - CPU: núcleos e hilos, con rendimientos decrecientes.
%   - RAM: capacidad y velocidad, con topes por perfil.
%   - GPU: VRAM aprovechable por perfil. El precio solo desempata de forma
%     mínima; el consumo NO se usa como si fuera rendimiento.
% Un precio o un consumo altos no garantizan mejor desempeño.
puntaje(Perfil, IdCpu, IdRam, IdGpu, Puntaje) :-
    procesador(IdCpu, _, _, _, Cores, Hilos, _, _),
    memoria_ram(IdRam, _, _, Cap, Vel, _),
    tarjeta_grafica(IdGpu, _, _, VRAM, _, _, PrecioG),
    puntaje_componentes(Perfil, Cores, Hilos, Cap, Vel, VRAM, PrecioG, Puntaje).

% Variante que recibe los datos ya leídos por candidato/10, para no
% volver a recorrer los hechos de CPU, RAM y GPU en cada combinación.
puntaje_componentes(Perfil, Cores, Hilos, Cap, Vel, VRAM, PrecioG, Puntaje) :-
    perfil_peso(Perfil, WC, WR, WG),
    perfil_tope(Perfil, TopeC, TopeR),
    perfil_tope_gpu(Perfil, TopeV),
    CoresU is min(Cores, TopeC),
    HilosU is min(Hilos, 2 * TopeC),
    CapU   is min(Cap, TopeR),
    VelU   is min(Vel, 6400),
    CpuS is 4 * sqrt(CoresU) + sqrt(HilosU),     % rendimientos decrecientes
    RamS is 2 * sqrt(CapU) + VelU / 1000,
    GpuS is min(VRAM, TopeV) + PrecioG / 1000000, % VRAM útil + desempate mínimo
    Puntaje is WC * CpuS + WR * RamS + WG * GpuS.

% ==================================================================
%  REGLA 4: Recomendación y ensamble automático por presupuesto
%  Un equipo (CPU, Placa, RAM, GPU, Fuente) se recomienda si:
%    1) compatibles(CPU, Placa, RAM)            [Regla 1]
%    2) fuente_suficiente(CPU, Placa, GPU, PSU) [Regla 2]
%    3) suma de precios <= Presupuesto
%  (se poda por precio parcial para que la búsqueda sea rápida)
% ==================================================================
configuracion_valida(Cpu, Mb, Ram, Gpu, Psu) :-
    compatibles(Cpu, Mb, Ram),
    fuente_suficiente(Cpu, Mb, Gpu, Psu).

recomendar(Presupuesto, Cpu, Mb, Ram, Gpu, Psu, Total) :-
    compatibles(Cpu, Mb, Ram),
    precio_cpu(Cpu, PC), precio_mb(Mb, PM), precio_ram(Ram, PR),
    Base is PC + PM + PR, Base =< Presupuesto,
    precio_gpu(Gpu, PG),
    ConGpu is Base + PG, ConGpu =< Presupuesto,
    fuente_suficiente(Cpu, Mb, Gpu, Psu),
    precio_psu(Psu, PP),
    Total is ConGpu + PP, Total =< Presupuesto.

% Fuente suficiente más barata para una combinación CPU/Placa/GPU.
% Se memoriza (tabling) por potencia requerida redondeada hacia arriba:
% Potencia >= Req  <=>  Potencia >= ceiling(Req)  (las potencias son enteras).
:- table psu_para_watts/3.
psu_para_watts(WReq, Psu, Precio) :-
    aggregate_all(min(P, Id),
                  ( fuente_poder(Id, _, _, Pot, _, P), Pot >= WReq ),
                  min(Precio, Psu)).

psu_mas_barata(Cpu, Mb, Gpu, Psu, Precio) :-
    consumo_con_margen(Cpu, Mb, Gpu, Req),
    WReq is ceiling(Req),
    psu_para_watts(WReq, Psu, Precio),
    fuente_suficiente(Cpu, Mb, Gpu, Psu).        % verificación Regla 2

% ==================================================================
%  FILTROS DE PREFERENCIA DEL USUARIO (menú de recomendación)
%  filtros(MarcaCPU, MarcaGPU, TipoRAM, MinNucleos, MinRAM_GB, MinVRAM_GB)
%  Los tres primeros aceptan 'cualquiera' como comodín.
% ==================================================================
filtro_ok(cualquiera, _) :- !.
filtro_ok(X, X).

filtros_por_defecto(Perfil, filtros(cualquiera, cualquiera, cualquiera, MinC, MinR, MinV)) :-
    perfil_minimo(Perfil, MinC, MinR, MinV).

% Candidato que cumple perfil/filtros, sin cuello de botella y dentro del presupuesto.
% Regla 1 se aplica unificando Socket y TipoRAM directamente, sin volver
% a consultar los hechos; es equivalente a compatibles/3.
% La fuente se obtiene de psu_para_watts/3, que ya garantiza Pot >= Req
% (Regla 2) y elige la de menor precio para esa potencia requerida.
candidato(Perfil, Presupuesto, filtros(FCpu, FGpu, FRam, MinC, MinR, MinV),
          Cpu, Mb, Ram, Gpu, Psu, Total, Puntaje) :-
    procesador(Cpu, MarcaC, _, Socket, Cores, Hilos, WCpu, PC),
    filtro_ok(FCpu, MarcaC), Cores >= MinC, PC =< Presupuesto,
    placa_madre(Mb, _, Socket, TipoMb, _, WMb, PM),   % Regla 1: socket
    filtro_ok(FRam, TipoMb),
    P2 is PC + PM, P2 =< Presupuesto,
    memoria_ram(Ram, _, TipoMb, Cap, Vel, PR),         % Regla 1: tipo de RAM
    Cap >= MinR,
    P3 is P2 + PR, P3 =< Presupuesto,
    tarjeta_grafica(Gpu, MarcaG, _, VRAM, WGpu, _, PG),
    filtro_ok(FGpu, MarcaG), VRAM >= MinV,
    P4 is P3 + PG, P4 =< Presupuesto,
    equilibrio_ok(Cores, VRAM),                       % Regla 3 (incluye el umbral obligatorio)
    Requerido is (WCpu + WMb + WGpu) * 1.25,          % Regla 2
    WReq is ceiling(Requerido),
    psu_para_watts(WReq, Psu, PP),
    Total is P4 + PP, Total =< Presupuesto,
    puntaje_componentes(Perfil, Cores, Hilos, Cap, Vel, VRAM, PG, Puntaje).

% Mejor configuración (máximo puntaje) para perfil, presupuesto y filtros.
% El desempate resta un costo total muy pequeño: así, entre dos equipos
% con el mismo puntaje heurístico, se prefiere el más económico. No
% convierte el precio en una medida de rendimiento.
mejor_configuracion(Perfil, Presupuesto, Filtros, config(Cpu, Mb, Ram, Gpu, Psu, Total)) :-
    aggregate_all(max(SA, c(C, M, R, G, F, T)),
                  ( candidato(Perfil, Presupuesto, Filtros, C, M, R, G, F, T, S),
                    SA is S - T / 1000000
                  ),
                  max(_, c(Cpu, Mb, Ram, Gpu, Psu, Total))).

mejor_configuracion(Perfil, Presupuesto, Config) :-
    filtros_por_defecto(Perfil, Filtros),
    mejor_configuracion(Perfil, Presupuesto, Filtros, Config).

% ==================================================================
%  DIAGNÓSTICO COMPLETO DE UNA CONFIGURACIÓN DADA
% ==================================================================
imprimir_balance(cuello_botella(Mensaje)) :-
    format('[ALERTA] ~w.~n', [Mensaje]).
imprimir_balance(equilibrada) :-
    writeln('[OK]   Balance: configuración equilibrada según la heurística de núcleos/VRAM (no sustituye benchmarks reales).').
imprimir_balance(no_concluyente(Mensaje)) :-
    format('[INFO] Balance: ~w~n', [Mensaje]).

diagnosticar(Cpu, Mb, Ram, Gpu, Psu, Perfil) :-
    format('~n=== DIAGNÓSTICO (perfil: ~w) ===~n', [Perfil]),
    % Regla 1
    ( compatibles(Cpu, Mb, Ram)
    -> writeln('[OK]   Compatibilidad: socket y tipo de RAM correctos.')
    ;  forall(incompatibilidad(Cpu, Mb, Ram, M), format('[FALLA] ~w~n', [M])) ),
    advertencia_compatibilidad_fisica(AdvertenciaFisica),
    format('[INFO] ~w~n', [AdvertenciaFisica]),
    % Regla 2
    consumo_total(Cpu, Mb, Gpu, Total),
    consumo_con_margen(Cpu, Mb, Gpu, Req),
    fuente_poder(Psu, _, _, Pot, _, _),
    ( fuente_suficiente(Cpu, Mb, Gpu, Psu)
    -> format('[OK]   Energía: consumo ~w W (+25% = ~1f W) <= fuente de ~w W.~n', [Total, Req, Pot])
    ;  format('[FALLA] Energía: se requieren ~1f W (consumo ~w W + 25%) y la fuente es de ~w W.~n', [Req, Total, Pot]) ),
    advertencias_energeticas(Cpu, Mb, Gpu, Psu, AdvertenciasEnergia),
    forall(member(A, AdvertenciasEnergia), format('[INFO] ~w~n', [A])),
    % Regla 3
    diagnostico_balance(Cpu, Gpu, EstadoBalance),
    imprimir_balance(EstadoBalance),
    writeln('[INFO] El balance CPU/GPU es heurístico y no sustituye benchmarks reales.'),
    % Perfil
    findall(A, alerta_perfil(Perfil, Cpu, Ram, Gpu, A), Alertas),
    ( Alertas == []
    -> format('[OK]   Cumple los requisitos mínimos del perfil ~w.~n', [Perfil])
    ;  forall(member(A, Alertas), format('[ALERTA] ~w~n', [A])) ).


% ==================================================================
%  SALIDA / REPORTES  (precios en pesos mexicanos, MXN)
% ==================================================================
imprimir_configuracion(config(Cpu, Mb, Ram, Gpu, Psu, Total)) :-
    procesador(Cpu, MaC, MoC, Sock, Co, Hi, _, PC),
    placa_madre(Mb, MoM, _, TRam, _, _, PM),
    memoria_ram(Ram, MaR, _, Cap, Vel, PR),
    tarjeta_grafica(Gpu, MaG, MoG, VRAM, _, Pcie, PG),
    fuente_poder(Psu, MaP, MoP, Pot, Cert, PP),
    format('  CPU    : ~w ~w (~w, ~wN/~wH)  $~D~n', [MaC, MoC, Sock, Co, Hi, PC]),
    format('  Placa  : ~w (~w, ~w)  $~D~n', [MoM, Sock, TRam, PM]),
    format('  RAM    : ~w ~w ~wGB ~wMHz  $~D~n', [MaR, TRam, Cap, Vel, PR]),
    format('  GPU    : ~w ~w, ~wGB VRAM (PCIe ~w)  $~D~n', [MaG, MoG, VRAM, Pcie, PG]),
    format('  Fuente : ~w ~w ~wW 80+ ~w  $~D~n', [MaP, MoP, Pot, Cert, PP]),
    format('  TOTAL  : $~D MXN~n', [Total]).

recomendar_perfil(Perfil, Presupuesto) :-
    filtros_por_defecto(Perfil, F),
    recomendar_con_filtros(Perfil, Presupuesto, F).

recomendar_con_filtros(Perfil, Presupuesto, Filtros) :-
    (   mejor_configuracion(Perfil, Presupuesto, Filtros, Cfg)
    ->  format('~nMejor equipo para ~w con presupuesto de $~D MXN:~n', [Perfil, Presupuesto]),
        imprimir_configuracion(Cfg),
        Cfg = config(C, M, R, G, P, _),
        diagnosticar(C, M, R, G, P, Perfil)
    ;   format('~nNo existe una configuración válida para ~w con $~D MXN y esas preferencias.~n',
               [Perfil, Presupuesto]),
        writeln('Posibles causas: presupuesto insuficiente, filtros de marca demasiado estrictos,'),
        writeln('tipo de RAM incompatible con la plataforma elegida o mínimos muy altos.'),
        writeln('Sugerencia: aumenta el presupuesto o relaja las preferencias.')
    ).

contar_registros :-
    aggregate_all(count, procesador(_,_,_,_,_,_,_,_), A),
    aggregate_all(count, placa_madre(_,_,_,_,_,_,_),   B),
    aggregate_all(count, memoria_ram(_,_,_,_,_,_),     C),
    aggregate_all(count, tarjeta_grafica(_,_,_,_,_,_,_), D),
    aggregate_all(count, fuente_poder(_,_,_,_,_,_),    E),
    Total is A + B + C + D + E,
    format('procesador: ~w | placa_madre: ~w | memoria_ram: ~w | tarjeta_grafica: ~w | fuente_poder: ~w~n',
           [A, B, C, D, E]),
    format('TOTAL: ~w hechos~n', [Total]).

% Búsqueda de Id por modelo (comodidad para consultas y demo).
cpu_id(Modelo, Id)  :- procesador(Id, _, Modelo, _, _, _, _, _), !.
mb_id(Modelo, Id)   :- placa_madre(Id, Modelo, _, _, _, _, _), !.
gpu_id(Modelo, Id)  :- tarjeta_grafica(Id, _, Modelo, _, _, _, _), !.
psu_id(Marca, Modelo, Id) :- fuente_poder(Id, Marca, Modelo, _, _, _), !.
ram_id(Marca, Tipo, Cap, Vel, Id) :- memoria_ram(Id, Marca, Tipo, Cap, Vel, _), !.

% ==================================================================
%  ENTRADA DE DATOS DEL USUARIO (utilidades para el menú)
% ==================================================================
leer_linea(Prompt, Linea) :-
    format('~w', [Prompt]), flush_output,
    read_line_to_string(current_input, L0),
    (   L0 == end_of_file
    ->  nl, writeln('Fin de la entrada. ¡Hasta luego!'), halt
    ;   normalize_space(string(Linea), L0)
    ).

% Validación pura, separada de la lectura, para poder probarla con plunit.
parse_entero(Texto, Min, Max, N) :-
    number_string(N, Texto),
    integer(N),
    N >= Min,
    N =< Max.

% Entero entre Min y Max (repite hasta que sea válido).
leer_entero(Prompt, Min, Max, N) :-
    repeat,
        leer_linea(Prompt, L),
        (   parse_entero(L, Min, Max, N0)
        ->  N = N0, !
        ;   format('  Entrada no válida: escribe un número entre ~w y ~w.~n', [Min, Max]),
            fail
        ).

% Cantidad en pesos: acepta "25000", "25,000", "$25,000".
parse_pesos(Texto, Monto) :-
    string_codes(Texto, Cs),
    exclude(simbolo_moneda, Cs, Limpios),
    string_codes(S, Limpios),
    number_string(N0, S),
    number(N0),
    N0 > 0,
    Monto is round(N0).

leer_pesos(Prompt, Monto) :-
    repeat,
        leer_linea(Prompt, L),
        (   parse_pesos(L, Monto0)
        ->  Monto = Monto0, !
        ;   writeln('  Entrada no válida: escribe una cantidad en pesos, por ejemplo 30000.'),
            fail
        ).

simbolo_moneda(0'$).
simbolo_moneda(0',).
simbolo_moneda(0' ).

% Muestra opciones numeradas y devuelve el valor asociado.
elegir_opcion(Titulo, Opciones, Valor) :-
    format('~n~w~n', [Titulo]),
    length(Opciones, Len),
    forall(nth1(I, Opciones, Et-_), format('  ~w) ~w~n', [I, Et])),
    leer_entero('Elige una opción: ', 1, Len, N),
    nth1(N, Opciones, _-Valor).

% ------------------------------------------------------------------
%  Catálogo (listados y selección de componentes por Id)
% ------------------------------------------------------------------
listar(cpu) :-
    forall(procesador(Id, Ma, Mo, S, C, H, W, P),
           format('~t~w~4|  ~w ~w  [~w, ~wN/~wH, ~wW]  $~D~n', [Id, Ma, Mo, S, C, H, W, P])).
listar(placa) :-
    forall(placa_madre(Id, Mo, S, T, Sl, W, P),
           format('~t~w~4|  ~w  [~w, ~w, ~w slots, ~wW]  $~D~n', [Id, Mo, S, T, Sl, W, P])).
listar(ram) :-
    forall(memoria_ram(Id, Ma, T, Cap, V, P),
           format('~t~w~4|  ~w ~w ~wGB ~wMHz  $~D~n', [Id, Ma, T, Cap, V, P])).
listar(gpu) :-
    forall(tarjeta_grafica(Id, Ma, Mo, VR, W, Pc, P),
           format('~t~w~4|  ~w ~w  [~wGB, ~wW, PCIe ~w]  $~D~n', [Id, Ma, Mo, VR, W, Pc, P])).
listar(fuente) :-
    forall(fuente_poder(Id, Ma, Mo, Pot, Ce, P),
           format('~t~w~4|  ~w ~w  [~wW, 80+ ~w]  $~D~n', [Id, Ma, Mo, Pot, Ce, P])).

total_registros(cpu, N)    :- aggregate_all(count, procesador(_,_,_,_,_,_,_,_), N).
total_registros(placa, N)  :- aggregate_all(count, placa_madre(_,_,_,_,_,_,_), N).
total_registros(ram, N)    :- aggregate_all(count, memoria_ram(_,_,_,_,_,_), N).
total_registros(gpu, N)    :- aggregate_all(count, tarjeta_grafica(_,_,_,_,_,_,_), N).
total_registros(fuente, N) :- aggregate_all(count, fuente_poder(_,_,_,_,_,_), N).

nombre_tipo(cpu, 'procesador').
nombre_tipo(placa, 'placa madre').
nombre_tipo(ram, 'memoria RAM').
nombre_tipo(gpu, 'tarjeta gráfica').
nombre_tipo(fuente, 'fuente de poder').

% Muestra el catálogo y pide el Id (los Id van de 1 a N).
elegir_componente(Tipo, Id) :-
    nombre_tipo(Tipo, Nombre),
    format('~n--- Catálogo: ~w (precios en MXN) ---~n', [Nombre]),
    listar(Tipo),
    total_registros(Tipo, N),
    format(atom(Prompt), 'Escribe el número (ID) de la ~w que elegiste: ', [Nombre]),
    leer_entero(Prompt, 1, N, Id).

pedir_perfil(Perfil) :-
    elegir_opcion('¿Para qué usarás el equipo?',
        [ 'Gaming (videojuegos)'               - gaming,
          'Inteligencia artificial (entrenar)' - ia,
          'Renderizado 3D / edición de video'  - renderizado,
          'Servidor web / bases de datos'      - servidor_web,
          'Desarrollo de software'             - desarrollo ],
        Perfil).

% ==================================================================
%  MENÚ PRINCIPAL
% ==================================================================
menu :-
    repeat,
        nl,
        writeln('=============================================='),
        writeln('   HW-EXPERT - Sistema Experto de Hardware'),
        writeln('=============================================='),
        writeln(' 1) Recomendarme un equipo completo'),
        writeln(' 2) Validar compatibilidad (CPU + Placa + RAM)'),
        writeln(' 3) Verificar si una fuente de poder alcanza'),
        writeln(' 4) Revisar cuello de botella (CPU + GPU)'),
        writeln(' 5) Diagnóstico completo de mi configuración'),
        writeln(' 6) Ver catálogo de componentes'),
        writeln(' 7) Cantidad de registros de cada componente'),
        writeln(' 8) Ver demostración y recomendaciones automáticas'),
        writeln(' 0) Salir'),
        leer_entero('Elige una opción: ', 0, 8, Op),
        ejecutar(Op),
        Op == 0, !.

ejecutar(0) :- !, writeln('¡Hasta luego!').
ejecutar(1) :- !, opcion_recomendar.
ejecutar(2) :- !, opcion_compatibilidad.
ejecutar(3) :- !, opcion_fuente.
ejecutar(4) :- !, opcion_cuello.
ejecutar(5) :- !, opcion_diagnostico.
ejecutar(6) :- !, opcion_catalogo.
ejecutar(7) :- !, contar_registros.
ejecutar(8) :- !, demo.

% --- 1) Recomendación: el sistema va preguntando lo que el cliente quiere
opcion_recomendar :-
    pedir_perfil(Perfil),
    nl,
    leer_pesos('¿Cuál es tu presupuesto máximo en pesos mexicanos? $', Presupuesto),
    elegir_opcion('¿Prefieres alguna marca de procesador?',
        [ 'Intel' - 'Intel', 'AMD' - 'AMD', 'Me da igual' - cualquiera ], MCpu),
    elegir_opcion('¿Prefieres alguna marca de tarjeta gráfica?',
        [ 'NVIDIA' - 'NVIDIA', 'AMD' - 'AMD', 'Intel' - 'Intel', 'Me da igual' - cualquiera ], MGpu),
    elegir_opcion('¿Qué tipo de memoria RAM prefieres?',
        [ 'DDR4 (más económica)' - ddr4, 'DDR5 (más moderna)' - ddr5, 'Me da igual' - cualquiera ], TRam),
    perfil_minimo(Perfil, MinC, MinR, MinV),
    format('~nPara el perfil "~w" el sistema exige como mínimo: ~w núcleos, ~w GB de RAM y ~w GB de VRAM.~n',
           [Perfil, MinC, MinR, MinV]),
    elegir_opcion('¿Quieres cambiar esos mínimos?',
        [ 'No, usar los recomendados' - no, 'Sí, quiero indicar los míos' - si ], Cambiar),
    (   Cambiar == si
    ->  leer_entero('Núcleos mínimos del procesador (0-24): ', 0, 24, C2),
        leer_entero('RAM mínima en GB (0-96): ', 0, 96, R2),
        leer_entero('VRAM mínima de la gráfica en GB (0-32): ', 0, 32, V2),
        Filtros = filtros(MCpu, MGpu, TRam, C2, R2, V2)
    ;   Filtros = filtros(MCpu, MGpu, TRam, MinC, MinR, MinV)
    ),
    writeln('\nBuscando la mejor combinación, un momento...'),
    recomendar_con_filtros(Perfil, Presupuesto, Filtros).

% --- 2) Regla 1
opcion_compatibilidad :-
    elegir_componente(cpu, Cpu),
    elegir_componente(placa, Mb),
    elegir_componente(ram, Ram),
    nl,
    (   compatibles(Cpu, Mb, Ram)
    ->  writeln('[OK] Son compatibles: mismo socket y mismo tipo de memoria RAM.')
    ;   writeln('[NO COMPATIBLES] Motivos:'),
        forall(incompatibilidad(Cpu, Mb, Ram, M), format('  - ~w~n', [M]))
    ),
    advertencia_compatibilidad_fisica(Advertencia),
    format('~n[INFO] ~w~n', [Advertencia]).

% --- 3) Regla 2
opcion_fuente :-
    elegir_componente(cpu, Cpu),
    elegir_componente(placa, Mb),
    elegir_componente(gpu, Gpu),
    elegir_componente(fuente, Psu),
    consumo_total(Cpu, Mb, Gpu, Total),
    consumo_con_margen(Cpu, Mb, Gpu, Req),
    fuente_poder(Psu, _, _, Pot, _, _),
    format('~nConsumo total: ~w W | con 25% de margen: ~1f W | tu fuente: ~w W~n', [Total, Req, Pot]),
    (   fuente_suficiente(Cpu, Mb, Gpu, Psu)
    ->  writeln('[OK] La fuente tiene potencia suficiente según la Regla 2.')
    ;   writeln('[PELIGRO] La fuente NO alcanza según la Regla 2: riesgo de apagones o inestabilidad.'),
        (   psu_mas_barata(Cpu, Mb, Gpu, Rec, Precio)
        ->  fuente_poder(Rec, Ma, Mo, PotR, _, _),
            format('Sugerencia: ~w ~w de ~wW por $~D MXN.~n', [Ma, Mo, PotR, Precio])
        ;   writeln('Ninguna fuente del catálogo alcanza para esta combinación.')
        )
    ),
    advertencias_energeticas(Cpu, Mb, Gpu, Psu, Advertencias),
    forall(member(A, Advertencias), format('[INFO] ~w~n', [A])).

% --- 4) Regla 3
opcion_cuello :-
    elegir_componente(cpu, Cpu),
    elegir_componente(gpu, Gpu),
    nl,
    diagnostico_balance(Cpu, Gpu, Estado),
    imprimir_balance(Estado),
    writeln('[INFO] Este diagnóstico es heurístico y no sustituye benchmarks reales.').

% --- 5) Diagnóstico completo
opcion_diagnostico :-
    pedir_perfil(Perfil),
    elegir_componente(cpu, Cpu),
    elegir_componente(placa, Mb),
    elegir_componente(ram, Ram),
    elegir_componente(gpu, Gpu),
    elegir_componente(fuente, Psu),
    precio_total(Cpu, Mb, Ram, Gpu, Psu, Total),
    diagnosticar(Cpu, Mb, Ram, Gpu, Psu, Perfil),
    format('~nCosto total de la configuración: $~D MXN~n', [Total]).

% --- 6) Catálogo
opcion_catalogo :-
    elegir_opcion('¿Qué componente quieres ver?',
        [ 'Procesadores' - cpu, 'Placas madre' - placa, 'Memorias RAM' - ram,
          'Tarjetas gráficas' - gpu, 'Fuentes de poder' - fuente ], Tipo),
    nombre_tipo(Tipo, Nombre),
    format('~n--- ~w (precios en MXN) ---~n', [Nombre]),
    listar(Tipo).

% ==================================================================
%  DEMO NO INTERACTIVA
% ==================================================================
demo :-
    writeln('##### 0. Tamaño de la base de conocimientos #####'),
    contar_registros,

    writeln('\n##### REGLA 1: compatibilidad #####'),
    cpu_id('Core i5-13400F', C1), mb_id('ASUS PRIME B760M-A WIFI', M1),
    ram_id('Kingston', ddr4, 16, 3200, R4), ram_id('Kingston', ddr5, 16, 5600, R5),
    ( compatibles(C1, M1, R4) -> writeln('i5-13400F + B760M-A (DDR5) + RAM DDR4: compatible')
                              ;  writeln('i5-13400F + B760M-A (DDR5) + RAM DDR4: NO compatible') ),
    ( compatibles(C1, M1, R5) -> writeln('i5-13400F + B760M-A (DDR5) + RAM DDR5: compatible')
                              ;  writeln('i5-13400F + B760M-A (DDR5) + RAM DDR5: NO compatible') ),

    writeln('\n##### REGLA 2: seguridad energética #####'),
    cpu_id('Ryzen 9 7950X', C2), mb_id('MSI MPG X670E Carbon WIFI', M2), gpu_id('GeForce RTX 4090', G2),
    consumo_total(C2, M2, G2, T2), consumo_con_margen(C2, M2, G2, Rq2),
    format('Ryzen 9 7950X + X670E + RTX 4090: ~w W, con margen ~1f W~n', [T2, Rq2]),
    psu_id('Corsair', 'RM750e', P750), psu_id('Corsair', 'RM1000e', P1000),
    ( fuente_suficiente(C2, M2, G2, P750)  -> writeln('Corsair RM750e : suficiente') ; writeln('Corsair RM750e : INSUFICIENTE') ),
    ( fuente_suficiente(C2, M2, G2, P1000) -> writeln('Corsair RM1000e: suficiente') ; writeln('Corsair RM1000e: INSUFICIENTE') ),

    writeln('\n##### REGLA 3: cuellos de botella #####'),
    cpu_id('Ryzen 5 5600', C3), gpu_id('Radeon RX 7900 XTX', G3),
    ( cuello_botella(C3, G3, Msg) -> format('Ryzen 5 5600 + RX 7900 XTX -> ~w~n', [Msg]) ; true ),
    cpu_id('Ryzen 7 7800X3D', C4), gpu_id('GeForce RTX 4080', G4),
    ( configuracion_equilibrada(C4, G4) -> writeln('Ryzen 7 7800X3D + RTX 4080 -> configuración equilibrada') ; true ),

    writeln('\n##### REGLA 4: recomendación por presupuesto (MXN) #####'),
    ( recomendar(18000, Cp, Mb, Rm, Gp, Ps, Tt)
    -> format('Ejemplo de configuración válida (no necesariamente la mejor) con $18,000 MXN:~n'),
       imprimir_configuracion(config(Cp, Mb, Rm, Gp, Ps, Tt))
    ;  writeln('Sin solución') ),
    recomendar_perfil(gaming, 27000),
    recomendar_perfil(servidor_web, 22000).

ayuda :-
    writeln('Consultas disponibles (además del menú: ?- menu.):'),
    writeln('  contar_registros.'),
    writeln('  compatibles(IdCpu, IdMb, IdRam).'),
    writeln('  fuente_suficiente(IdCpu, IdMb, IdGpu, IdPsu).'),
    writeln('  cuello_botella(IdCpu, IdGpu, Mensaje).'),
    writeln('  configuracion_equilibrada(IdCpu, IdGpu).'),
    writeln('  diagnostico_balance(IdCpu, IdGpu, Estado).'),
    writeln('  recomendar(PresupuestoMXN, Cpu, Mb, Ram, Gpu, Psu, Total).'),
    writeln('  recomendar_perfil(gaming|ia|renderizado|servidor_web|desarrollo, PresupuestoMXN).'),
    writeln('  mejor_configuracion(Perfil, PresupuestoMXN, Config).'),
    writeln('  diagnosticar(Cpu, Mb, Ram, Gpu, Psu, Perfil).'),
    writeln('  demo.').

% ------------------------------------------------------------------
%  CARGA, MODO INTERACTIVO Y MODO NO INTERACTIVO
% ------------------------------------------------------------------
% initialization(main, main) solo ejecuta main cuando este archivo es el
% archivo principal. Al cargarlo desde pruebas (ensure_loaded/1) NO se
% abre el menú. Así se puede consultar y probar sin bloquear la terminal.
main :-
    current_prolog_flag(argv, Args),
    (   memberchk('--demo', Args)
    ->  demo, halt
    ;   memberchk('--no-menu', Args)
    ->  writeln('HW-Expert cargado en modo no interactivo. Usa menu. o demo.')
    ;   argv_con_objetivo(Args)
    ->  true
    ;   catch(stream_property(user_input, tty(true)), _, fail)
    ->  menu
    ;   writeln('HW-Expert cargado. No hay terminal interactiva; usa menu. o demo.')
    ).

argv_con_objetivo(Args) :- memberchk('-g', Args), !.
argv_con_objetivo(Args) :- memberchk('--goal', Args), !.
argv_con_objetivo(Args) :- memberchk('-t', Args), !.
argv_con_objetivo(Args) :- memberchk('--toplevel', Args), !.

:- initialization(main, main).

