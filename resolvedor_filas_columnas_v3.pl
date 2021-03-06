%
% resolver_orden(+PistasFilas, +PistasColumnas, +Grilla, -Solucion)
%
/**
 * Dada una grilla y sus pistas, resuelve el nonograma de manera eficiente, resolviendo
 * cada línea acorde a su prioridad definida por su cantidad de restricciones (es decir,
 * la cantidad de celdas necesarias para satisfacerla) comenzando por la que tiene
 * mayor cantidad de restricciones y continuando en orden lineal hasta la que tiene
 * menor cantidad de restricciones
 * @param PistasFilas Lista de listas de enteros que representan las pistas de las
 * filas del nonograma
 * @param PistasColumnas Lista de listas de enteros que representan las pistas de
 * las columnas del nonograma
 * @param Grilla Grilla que representa el nonograma
 * @param Solucion Nonograma resuelto (en forma de grilla como Grilla)
 */
resolver_orden(PistasFilas, PistasColumnas, Grilla, Solucion) :-
    calcular_prioridad(PistasFilas, PrioridadFilas),
    calcular_prioridad(PistasColumnas, PrioridadColumnas),
    longitud(PistasFilas, LongFilas),
    longitud(PistasColumnas, LongColumnas),
    resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla, 0, 0, LongFilas, LongColumnas, fila, Solucion).

%
% resolver_orden_aux(+PistasFilas, +PistasColumnas, +PrioridadFilas, +PrioridadColumnas, +Grilla, +Indice_Fila, +Indice_Columna, +Maxima_Fila, +Maxima_Columna +Modo, -Solucion)
% Modo puede ser 'fila' o 'columna'
%
% Debe ser invocado de la siguiente manera
% resolver_orden_aux([lista de listas de enteros], [lista de listas de enteros], [lista de enteros], [lista de enteros], [[grilla]], 0, 0, fila, R)
%
/**
 * Resuelve un nonograma de acuerdo a sus pistas en orden de mayor restricciones a menor restricciones
 * @param PistasFilas Pistas de las filas del nonograma
 * @param PistasColumnas Pistas de las columnas del nonograma
 * @param PrioridadFilas Lista con enteros que representan el orden en el que deben ser resueltas
 * las filas
 * @param PrioridadColumnas Lista con enteros que representan el orden en el que deben ser resueltas
 * las columnas
 * @param Grilla Grilla que representa al nonograma que debe ser resuelto
 * @param Index_F Número de la fila que debe ser resuelta (corresponde a su prioridad, no su índice real)
 * @param Index_C Número de la columna que debe ser resuelta (corresponde a su prioridad, no su índice real)
 * @param Max_F Número de filas a resolver (0..length(grilla])-1)
 * @param Max_C Número de columnas a resolver (0..length(grilla[0])-1)
 * @param Modo Modo de resolución. Puede ser 'fila' o 'columna'
 * @param Solucion Grilla que corresponde al nonograma resuelto
 */
resolver_orden_aux(_PistasFilas, _PistasColumnas, _PrioridadFilas, _PrioridadColumnas, Grilla, Max_F, Max_C, Max_F, Max_C, _Modo, Grilla) :-
    !.
resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla, Index_F, Index_C, Max_F, Max_C, fila, Solucion) :-
    recuperar_indice(PrioridadFilas, Index_F, N_Pista),
    recuperar_elemento(PistasFilas, N_Pista, PF),
    resolver_fila(PF, N_Pista, Grilla, Grilla_Parcial),
    Index_F_Aux is Index_F + 1,
    resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla_Parcial, Index_F_Aux, Index_C, Max_F, Max_C, columna, Solucion).
resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla, Index_F, Index_C, Max_F, Max_C, columna, Solucion) :-
    recuperar_indice(PrioridadColumnas, Index_C, N_Pista),
    recuperar_elemento(PistasColumnas, N_Pista, PC),
    resolver_columna(PC, N_Pista, Grilla, Grilla_Parcial),
    Index_C_Aux is Index_C + 1,
    resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla_Parcial, Index_F, Index_C_Aux, Max_F, Max_C, fila, Solucion).
resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla, Max_F, Index_C, Max_F, Max_C, fila, Solucion) :-
    resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla, Max_F, Index_C, Max_F, Max_C, columna, Solucion).
resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla, Index_F, Max_C, Max_F, Max_C, columna, Solucion) :-
    resolver_orden_aux(PistasFilas, PistasColumnas, PrioridadFilas, PrioridadColumnas, Grilla, Index_F, Max_C, Max_F, Max_C, fila, Solucion).


%
% recuperar_elemento(+Lista, +Indice, -Elemento)
%
/**
 * Dado un índice, devuelve el elemento que ocupa esa posición en la lista dada
 * @param Lista Lista a recorrer
 * @param Index Índice donde se encuentra el elemento
 * @param Res Elemento que ocupa la posición Index en la lista Lista
 */
recuperar_elemento([L | _Lista], 0, L).
recuperar_elemento([_L | Lista], Index, Res) :-
    Index_aux is Index - 1,
    recuperar_elemento(Lista, Index_aux, Res).

%
% recuperar_indice(+Lista, +E, -Index)
%
/**
 * Dado un elemento y una lista, devuelve la posición (índice) que ocupa ese elemento en la lista
 * @param Lista Lista a recorrer
 * @param E Elemento a buscar
 * @param Index Índice correspondiente a la posición que ocupa el elemento E en la lista Lista
 */
recuperar_indice([L | _Lista], L, 0).
recuperar_indice([_L | Lista], E, Index) :-
    recuperar_indice(Lista, E, Index_aux),
    Index is Index_aux + 1.
%
% calcular_prioridad(+Lista, -Res)
%
/**
 * Dada una lista de pistas, calcula en qué orden deben ser resueltas si se resuelve
 * en orden de prioridad desde las pistas con mayor cantidad de restricciones hasta
 * las pistas con menor cantidad de restricciones (es decir, que necesitan menor
 * cantidad de celdas para ser satisfechas)
 * @param Lista Lista de pistas (lista de listas de enteros)
 * @param Res Lista que indica el orden en el que se deben resolver las pistas
 */
calcular_prioridad(Lista, Res) :-
    calcular_restricciones(Lista, Restricciones),
    ordenar(Restricciones, Res).
%
% calcular_restricciones/2
% calcular_restricciones(+Pistas, -Suma)
%
% Debe ser invocado de la siguiente manera:
% calcular_restricciones([[lista de naturales], ...], R)
%
/**
 * Dada una lista de pistas, calcula la cantidad mínima de celdas que ocuparía la 
 * solución de cada una
 * @param Pistas Lista de listas de naturales que representan las pistas de las celdas
 * @param Suma Suma resultante que indica la cantidad mínima de celdas que ocuparía la
 * solución de las pistas
 */ 
calcular_restricciones([], []).
calcular_restricciones([P | Pistas], [Suma | Res]) :-
    sumar_pistas(P, Suma),
    calcular_restricciones(Pistas, Res).

%
% sumar_pistas/2
% sumar_pistas(+Pistas, -Suma)
%
% Debe ser invocado de la siguiente manera:
% sumar_pistas([lista de naturales], R)
%
/**
 * Dada una pista, retorna la cantidad mínima de celdas que ocuparía su solución
 * @param Pistas Lista de naturales que representa las pistas
 * @param Suma Suma resultante que indica la cantidad mínima de celdas que ocuparía
 * la solución de las pistas
 */ 
sumar_pistas([], 0).
sumar_pistas([P | Pistas], Suma) :-
    Pistas \== [],
    sumar_pistas(Pistas, Suma_aux),
    Suma is Suma_aux + P + 1, % sumo 1 por cada espacio vacío
    !. % para que no me genere más respuestas de las necesarias.
       % por ej. para [1,1] me retornaba 3 y luego 2. Con este cut evito eso
sumar_pistas([P | Pistas], Suma) :-
    sumar_pistas(Pistas, Suma_aux),
    Suma is Suma_aux + P.

%
% ordenar(+Lista, -R)
%
% Ejemplo
% ?- ordenar([1,2,3], R).
% R = [2,1,0].
%
/**
 * Dada una lista, devuelve el orden en el que debe ser recorrida de mayor a menor
 * @param Lista Lista a examinar
 * @param R Lista que contiene el orden en el que debe ser recorrida la lista Lista
 * recorriéndola de mayor a menor
 */
ordenar(Lista, R) :-
    mayor(Lista, M),
    longitud(Lista, Long),
    ordenar_aux(Lista, M, 0, Long, Lista, R).

%
% ordenar_aux(+Lista1, +Mayor, +Indice, +Longitud, +Lista2, -Res)
% Lista2 debe ser de la misma longitud que Lista1. En general, Lista1 = Lista2
%
% Debe ser invocada de la siguiente manera:
% ordenar_aux([lista de enteros], n_entero, 0, m_entero, [lista de enteros], R).
%
/**
 * Dada una lista, devuelve el orden en el que debe ser recorrida con respecto a Mayor
 * @param Lista Lista a examinar
 * @param Mayor Número mayor de la lista
 * @param Indice Próximo índice a agregar en la lista Orden
 * @param Longitud Longitud de la lista Lista
 * @param Orden Lista que indica el orden en el que debe ser recorrida la lista
 * Lista hasta una iteración anterior
 * @param Res Lista resultante que indica en qué orden debe ser recorrida la lista
 * acorde al número Mayor actual
 */
ordenar_aux(_Lista, _Mayor, Indice, Indice, Orden, Orden) :-
    !. % sino genera el mismo resultado infinitamente
ordenar_aux(Lista, Mayor, Indice, Longitud, Orden, Res) :-
    etiquetar_mayor(Lista, Mayor, Indice, Indice_R, Orden, R),
    Mayor_aux is Mayor - 1,
    ordenar_aux(Lista, Mayor_aux, Indice_R, Longitud, R, Res).

%
% etiquetar_mayor(+Lista, +Mayor, +Indice, -Indice_R, +Orden, -Res)
%
/**
 * Dada una lista de enteros y el número mayor de entre la lista de enteros,
 * etiqueta en qué posiciones de la lista aparece ese número. Las posiciones
 * ocupadas por un número menor a mayor, las etiqueta con 100. Las posiciones
 * ocupadas por un número mayor a mayor, las deja con su etiqueta actual.
 * @param Lista Lista de enteros a examinar
 * @param Mayor Número mayor de la lista Lista
 * @param Indice Índice con el que etiquetar a la posición
 * @return Indice_R Último índice ocupado incrementado en 1
 * @param Orden Lista de etiquetas que indican el orden de los elementos hasta
 * el momento de la llamada a la función actual
 * @return Res Lista resultante etiquetando las posiciones en la que aparece el
 * entero Mayor
 */
etiquetar_mayor([], _Mayor, Indice, Indice, [], []).
etiquetar_mayor([L | Lista], Mayor, Indice, Indice_R, [_O | Orden], [Indice | Res]) :-
    L == Mayor,
    Index_aux is Indice + 1,
    etiquetar_mayor(Lista, Mayor, Index_aux, Indice_R, Orden, Res).
etiquetar_mayor([L | Lista], Mayor, Indice, Indice_R, [_O | Orden], [100 | Res]) :-
    L < Mayor,
    etiquetar_mayor(Lista, Mayor, Indice, Indice_R, Orden, Res).
etiquetar_mayor([L | Lista], Mayor, Indice, Indice_R, [O | Orden], [O | Res]) :-
    L > Mayor,
    etiquetar_mayor(Lista, Mayor, Indice, Indice_R, Orden, Res).

%
% mayor(+Lista, -M)
%
/**
 * Dada una lista de enteros, retorna cuál es su mayor
 * @param Lista Lista de enteros
 * @param M Mayor de entre la lista dada
 */
mayor([L], L).
mayor([L | Lista], L) :-
    mayor(Lista, M),
    L > M.
mayor([L | Lista], M) :-
    mayor(Lista, M),
    L =< M.

%
% longitud(+Lista, -Res)
%
/**
 * Dada una lista, devuelve su longitud
 * @param Lista Lista a la que calcularle su longitud
 * @param Res Longitud de la lista
 */
longitud([], 0).
longitud([_L | Lista], Res) :-
    longitud(Lista, R),
    Res is R + 1.

/**
 * Dada una grilla, la resuelve
 * @param PistasFilas Lista con listas de pistas de las filas de la grilla
 * @param PistasColumnas Lista con listas de pistas de las columnas de la grilla
 * @param Fila Número de fila actual que se intenta resolver
 * @param Col Número de columna que se intenta resolver 
 * @param Modo Modo de resolución. Puede ser fila o columna
 * @param Res Grilla resultante luego de resolverla.
*/
resolver([], [], Grilla, _Fila, _Col, _Modo, Grilla).
resolver([PF | PistasFilas], PistasColumnas, Grilla, Fila, Col, fila, Res) :-
    resolver_fila(PF, Fila, Grilla, R),
    Fila_aux is Fila + 1,
    resolver(PistasFilas, PistasColumnas, R, Fila_aux, Col, columna, Res).
resolver(PistasFilas, [PC | PistasColumnas], Grilla, Fila, Col, columna, Res) :-
    resolver_columna(PC, Col, Grilla, R),
    Col_aux is Col + 1,
    resolver(PistasFilas, PistasColumnas, R, Fila, Col_aux, fila, Res).
resolver(PistasFilas, [], Grilla, Fila, Col, columna, Res) :-
    resolver(PistasFilas, [], Grilla, Fila, Col, fila, Res).
resolver([], PistasColumnas, Grilla, Fila, Col, fila, Res) :- 
    resolver([], PistasColumnas, Grilla, Fila, Col, columna, Res).

% 
% resolver_fila/4
% resolver_fila(+PistasFila, +N_Fila, +Grilla, -Res)
%
% Deber ser invocado de la siguiente manera
% resolver_fila([lista de naturales], n_natural, [[grilla]], R)
%
/**
 * Wrapper de resolver_filas_aux/4
 * Dada una lista de números naturales como pistas, un número de fila y una grilla,
 * devuelve la grilla resultante con la fila resuelta
 * @param PistasFila Lista de números naturales que indican las pistas de la fila
 * correspondiente
 * @param N_Fila Número de la fila a resolver (0..length(grilla))
 * @param Grilla Grilla a resolver
 * @param Res Grilla resultante con la fila resuelta
 */ 
resolver_fila(PistasFila, N_Fila, [G | Grilla], [G | Res]) :-
    N_Fila > 0,
    N_Fila_Aux is N_Fila - 1,
    resolver_fila(PistasFila, N_Fila_Aux, Grilla, Res).
resolver_fila(PistasFila, 0, [G | Grilla], [Res | Grilla]) :-
    resolver_fila_aux(PistasFila, G, no_rafaga, Res).

%    
% resolver_fila_aux/4
% resolver_fila_aux(+Pistas, +Fila, +Modo, -Res)
%
% Debe ser invocado de la siguiente manera
% resolver_fila_aux([lista de naturales], [Fila], no_rafaga, R).
%
/**
 * Dada una fila, la resuelve acorde a las pistas y la retorna en Res
 * @param Pistas Lista con las pistas
 * @param Fila Fila que se intenta resolver
 * @param Modo Modo de inserción de la recursión anterior. Puede ser 'rafaga' o 'no_rafaga'
 * @return Res Fila resuelta
 */
resolver_fila_aux([0], [], rafaga, []).
resolver_fila_aux([], [], no_rafaga, []).
resolver_fila_aux(Pistas, [F | Fila], no_rafaga, ["X" | Res]) :-
    % F \== [], % verificar si el código sigue andando sin esta línea. De ser así, borrarla
    F \== "#",
    resolver_fila_aux(Pistas, Fila, no_rafaga, Res).
resolver_fila_aux([P | Pistas], [F | Fila], no_rafaga, ["#" | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_fila_aux([P_Aux | Pistas], Fila, rafaga, Res).
resolver_fila_aux([P | Pistas], [F | Fila], rafaga, ["#" | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_fila_aux([P_Aux | Pistas], Fila, rafaga, Res).
resolver_fila_aux([0 | Pistas], [F | Fila], rafaga, ["X" | Res]) :-
    F \== "#",
    resolver_fila_aux(Pistas, Fila, no_rafaga, Res).

%
% resolver_columna/4
% resolver_columna(+PistasColumna, +N_Col, +Grilla, -Res)
%
% Debe ser invocado de la siguiente manera
% resolver_columna([lista de naturales], natural, [[grilla]], R)
%
/**
 * Wrapper de resolver_columna/7
 * Dada una lista de naturales como pistas, un número de columna y una grilla,
 * devuelve la grilla resultante con la columna resuelta
 * @param PistasColumna Lista de números naturales que indican las pistas de la
 * columna correspondiente
 * @param N_Col Número de la columna a resolver (0..length(grilla[0]))
 * @param Grilla Grilla a resolver
 * @param Res Grilla resultante con la columna resuelta
 */
resolver_columna(PistasColumna, N_Col, Grilla, Res) :-
    resolver_columna(PistasColumna, N_Col, 0, Grilla, [], no_rafaga, Res).

%
% resolver_columna/7
% resolver_columna(+Pistas, +N_Col, +Index, +Grilla, +Cabeza, +Modo, -Res)
%
% Debe ser invocado con
% resolver_columna([lista de naturales], n_natural, 0, [[grilla]], [], no_rafaga, R).
%
/**
 * Dada una grilla, resuelve una columna acorde a las pistas y la retorna en Res
 * @param Pistas Lista con las pistas
 * @param N_Col Número de columna a resolver (0..lenght(grilla[0]))
 * @param Index Índice que indica cual columna de la fila es la actual (0..N_Col)
 * @param Grilla Grilla donde se encuentra la columna a resolver
 * @param Cabeza Comienzo de la fila a la que pertenece la columna. Son los elementos en las posiciones 0..N_Col-1
 * @param Modo Modo de inserción de la recursión anterior. Puede ser 'rafaga' o 'no_rafaga'
 * @return Res Grilla con la columna resuelta
 */
resolver_columna([0], _N_Col, _Index, [], _Cabeza, rafaga, []).
resolver_columna([], _N_Col, _Index, [], _Cabeza, no_rafaga, []).
resolver_columna(Pistas, N_Col, Index, [[F | Fila] | Grilla], Cabeza, no_rafaga, Res) :-
    N_Col > Index,
    Index_aux is Index + 1,
    append(Cabeza, [F], Cabeza_aux),
    resolver_columna(Pistas, N_Col, Index_aux, [Fila | Grilla], Cabeza_aux, no_rafaga, Res).
resolver_columna(Pistas, N_Col, Index, [[F | Fila] | Grilla], Cabeza, rafaga, Res) :-
    N_Col > Index,
    Index_aux is Index + 1,
    append(Cabeza, [F], Cabeza_aux),
    resolver_columna(Pistas, N_Col, Index_aux, [Fila | Grilla], Cabeza_aux, rafaga, Res).
resolver_columna(Pistas, N_Col, N_Col, [[F | Fila] | Grilla], Cabeza, no_rafaga, [R | Res]) :-
    F \== "#",
    resolver_columna(Pistas, N_Col, 0, Grilla, [], no_rafaga, Res),
    append(Cabeza, ["X" | Fila], R).
resolver_columna([P | Pistas], N_Col, N_Col, [[F | Fila] | Grilla], Cabeza, no_rafaga, [R | Res]) :-
    P > 0,
    P_Aux is P - 1,
    F \== "X",
    resolver_columna([P_Aux | Pistas], N_Col, 0, Grilla, [], rafaga, Res),
    append(Cabeza, ["#" | Fila], R).
resolver_columna([P | Pistas], N_Col, N_Col, [[F | Fila] | Grilla], Cabeza, rafaga, [R | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_columna([P_Aux | Pistas], N_Col, 0, Grilla, [], rafaga, Res),
    append(Cabeza, ["#" | Fila], R).
resolver_columna([0 | Pistas], N_Col, N_Col, [[F | Fila] | Grilla], Cabeza, rafaga, [R | Res]) :-
    F \== "#",
    resolver_columna(Pistas, N_Col, 0, Grilla, [], no_rafaga, Res),
    append(Cabeza, ["X" | Fila], R).