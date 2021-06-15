:- module(proylcc, [put/8, revelarCelda/8, grillaSolucion/1, generarTableroSolucion/4]).
:- use_module(library(lists)).

:-dynamic grillaSolucion/1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% replace(?X, +XIndex, +Y, +Xs, -XsY)
%
% XsY es el resultado de reemplazar la ocurrencia de X en la posición XIndex de Xs por Y.

replace(X, 0, Y, [X|Xs], [Y|Xs]).

replace(X, XIndex, Y, [Xi|Xs], [Xi|XsY]):-
    XIndex > 0,
    XIndexS is XIndex - 1,
    replace(X, XIndexS, Y, Xs, XsY).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% put(+Contenido, +Pos, +PistasFilas, +PistasColumnas, +Grilla, -GrillaRes, -FilaSat, -ColSat).
%
% Métodos creados y modificados por nosotros

put(Contenido, [RowN, ColN], PistasFilas, PistasColumnas, Grilla, NewGrilla, FilaSat, ColSat):-
	% NewGrilla es el resultado de reemplazar la fila Row en la posición RowN de Grilla
	% (RowN-ésima fila de Grilla), por una fila nueva NewRow.
	
	replace(Row, RowN, NewRow, Grilla, NewGrilla),

	% NewRow es el resultado de reemplazar la celda Cell en la posición ColN de Row por _,
	% siempre y cuando Cell coincida con Contenido (Cell se instancia en la llamada al replace/5).
	% En caso contrario (;)
	% NewRow es el resultado de reemplazar lo que se que haya (_Cell) en la posición ColN de Row por Conenido.	 
	
	(replace(Cell, ColN, _, Row, NewRow),
	Cell == Contenido 
		;
	replace(_Cell, ColN, Contenido, Row, NewRow)),

	recuperar_pistas(RowN, PistasFilas, PF),
	recuperar_pistas(ColN, PistasColumnas, PC),
	verificar_pistas_filas(PF, RowN, NewGrilla, FilaSat),
	verificar_pistas_columnas(PC, ColN, NewGrilla, ColSat).

/**
 * Dada una lista de listas de pistas, devuelve la lista de pista correspondiente
 * a la posición pasada por parámetro
 * @param {Pos} Posición (o índice) donde se encuentra la lista de pistas buscada
 * @param {Pistas} Lista de listas de pistas
 * @param {E} Lista de pista buscada
 */
% recuperar_pistas(+Pos, +Pistas, -E)
recuperar_pistas(0, [P | _Ps], P).
recuperar_pistas(Pos, [_P | Ps], E) :-
	Posaux is Pos - 1,
	recuperar_pistas(Posaux, Ps, E).

/**
 * Verifica si se satisfacen las pistas de una fila dada
 * @param {PistasFilas} Lista que contiene las pistas que debe satisfacer la fila
 * @param {RowN} Número de la fila a verificar (0...length(Grilla))
 * @param {Grilla} Grilla a validar
 * @param {FilaSat} Retorna 1 si se satisfacen las pistas, nada en caso contrario
 */
% verificar_pistas_filas(+PistasFilas, +RowN, +NewGrilla, -FilaSat)
verificar_pistas_filas([PF | PFs], 0, [ [F | Fila] | _Grilla ], FilaSat) :-
	F == "#",
	PFaux is PF - 1,
	rafaga([PFaux | PFs], Fila, FilaSat).
verificar_pistas_filas([0 | _PFs], 0, [ [F | _Fila] | _Grilla ], 0) :- 
	F == "#".
verificar_pistas_filas(PistasFilas, 0, [ [_ | Fila] | _Grilla ], FilaSat) :-
	%F \= "#",
	no_rafaga(PistasFilas, Fila, FilaSat).

verificar_pistas_filas(PistasFilas, RowN, [_Fila | Grilla], FilaSat) :-
	RowNaux is RowN - 1,
	verificar_pistas_filas(PistasFilas, RowNaux, Grilla, FilaSat). 

/**
 * Verifica una ráfaga de "#" se corresponde con su pista
 * @param {PistasFilas} Lista con las pistas de la fila
 * @param {Fila} Lista que representa la fila a verificar si se cumplen las pistas
 * @param {FilaSat} Devuelve 1 si se satisfacen las pistas, 0 en caso contrario
 */
% rafaga(+PistasFilas, +Fila, -FilaSat)
rafaga([PF | PFs], [F | Fila], FilaSat) :-
	F == "#",
	PFaux is PF - 1,
	rafaga([PFaux | PFs], Fila, FilaSat).
rafaga([PF | PFs], [_ | Fila], FilaSat) :-
	PF == 0,
	%F \= "#",
	no_rafaga(PFs, Fila, FilaSat).
rafaga([0 | _PFs], [F | _Fila], 0) :- 
	F == "#".
rafaga([0], [], 1).
rafaga([PF | _PFs], [_ | _Fila], 0) :-
	%F \= "#",
	PF \== 0.
rafaga([0 | PFs], [], 0) :-
	PFs \== [].
rafaga([PF | _PFs], [], 0) :-
	PF \== 0.

/**
 * Verifica que una ráfaga de "X" se corresponde con su pista
 * @param {PistasFilas} Lista con las pistas de la fila
 * @param {Fila} Lista que representa la fila a verificar si se cumplen las pistas
 * @param {FilaSat} Devuelve 1 si se satisfacen las pistas, 0 en caso contrario
 */
% no_rafaga(+PistasFilas, +Fila, -FilaSat)
no_rafaga([], [], 1).
no_rafaga([], [F | _Fila], 0) :- 
	F == "#".
no_rafaga([_PF | _PFs], [], 0).
no_rafaga([PF | PFs], [F | Fila], FilaSat) :-
	F == "#",
	PFaux is PF - 1,
	rafaga([PFaux | PFs], Fila, FilaSat).
no_rafaga(PF, [_ | Fila], FilaSat) :-
	%F \= "#",
	no_rafaga(PF, Fila, FilaSat).

/**
 * Verifica si se satisfacen las pistas de una columna dada
 * @param {PistasColumnas} Lista que contiene las pistas que debe satisfacer la columna
 * @param {ColN} Número de la columna a verificar (0...length(Grilla[0]))
 * @param {Grilla} Grilla a validar
 * @param {ColSat} Retorna 1 si se satisfacen las pistas, nada en caso contrario
 */
% verificar_pistas_columnas(+PistasColumnas, +ColN, +NewGrilla, -ColSat)
verificar_pistas_columnas(PistasColumnas, ColN, Grilla, ColSat) :-
	recuperar_columna(ColN, Grilla, Columna), 
	verificar_pistas_filas(PistasColumnas, 0, [Columna], ColSat).

/**
 * Método auxiliar recuperar_columna
 * Devuelve en una lista la columna deseada
 * @param {ColN} Número de columna a buscar
 * @param {Grilla} Grilla que contiene la columna buscada
 * @param {Columna} Lista que contiene a la columna buscada
 */
% recuperar_columna(+ColN, +Grilla, -Columna).
recuperar_columna(_ColN, [], []).
recuperar_columna(ColN, [G | Grilla], [E | Columna]) :-
	recuperar_elemento(ColN, G, E),
	recuperar_columna(ColN, Grilla, Columna).

/**
 * Método auxiliar recuperar_elemento
 * Devuelve un elemento en un índice dado de una lista
 * @param {ColN} Índice donde se encuentra el elemento (0..length(Fila))
 * @param {Fila} Lista donde buscar el elemento
 * @param {E} Devuelve el elemento buscado
 */
% recuperar_elemento(+ColN, +Fila, -E).
recuperar_elemento(0, [F | _Fila], F).
recuperar_elemento(ColN, [_F | Fila], E) :-
	ColNaux is ColN - 1,
	recuperar_elemento(ColNaux, Fila, E).


/* BACK UP
put(Contenido, [RowN, ColN], _PistasFilas, _PistasColumnas, Grilla, NewGrilla, 0, 0):-
	% NewGrilla es el resultado de reemplazar la fila Row en la posición RowN de Grilla
	% (RowN-ésima fila de Grilla), por una fila nueva NewRow.
	
	replace(Row, RowN, NewRow, Grilla, NewGrilla),

	% NewRow es el resultado de reemplazar la celda Cell en la posición ColN de Row por _,
	% siempre y cuando Cell coincida con Contenido (Cell se instancia en la llamada al replace/5).
	% En caso contrario (;)
	% NewRow es el resultado de reemplazar lo que se que haya (_Cell) en la posición ColN de Row por Conenido.	 
	
	(replace(Cell, ColN, _, Row, NewRow),
	Cell == Contenido 
		;
	replace(_Cell, ColN, Contenido, Row, NewRow)).
*/


/*
* ========================================================================================================
* PREDICADOS PARA SOLUCIONAR TABLERO
* ========================================================================================================
*/

generarTableroSolucion(PistasFilas, PistasColumnas, Grilla, GrillaSolucion):-
	obtenerTableroSolucion(PistasFilas, PistasColumnas, Grilla, GrillaSolucion),
    assert(grillaSolucion(GrillaSolucion)). %almacena en el programa la grilla solucion


/*
obtenerTableroSolucion(_PistasFilas, _PistasColumnas, _Grilla, Resolucion) :- 
    Resolucion = [
        ["X","X","#","X","X"], 		
        ["X","#","#","#","X"],
        ["X","#","X","#","X"],		% Grilla
        ["X","#","#","#","X"],
        ["#","#","#","#","#"]
    ]
.  
*/
obtenerTableroSolucion(PistasFilas, PistasColumnas, Grilla, Resolucion):-
    resolver(PistasFilas, PistasColumnas, Grilla, 0, 0, fila, Resolucion).

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

/*
* ========================================================================================================
* PREDICADO PARA REVELAR EL VALOR DE LA CELDA
* ========================================================================================================
*/

/*
* Predicado revelarCelda/8
* Busca el elemento de la grilla solucion de la posicion [Fila, Columna] y actualiza el tablero empleando put/8
* Devuelve en ResultadoOp 1 si la operación se realizó sobre una celda sin contenido.
* Devuelve en ResultadoOp 0 si la operación se realizó sobre una celda con contenido ("#" o "X").
*/
revelarCelda(Grilla, [RowN, ColN], _PistasFilas, _PistasColumnas, Grilla, _FilaSat, _ColSat, ResultadoOp):- 
	%Caso donde se revela el valor de una celda no vacía.
    not(celdaVacia(Grilla, [RowN, ColN])),
	ResultadoOp is 0.

revelarCelda(Grilla, [RowN, ColN], PistasFilas, PistasColumnas, NewGrilla, FilaSat, ColSat, ResultadoOp):-
	%Caso donde se revela el valor de una celda vacía.
    celdaVacia(Grilla, [RowN, ColN]),
	%Recupera la grilla solución.
	grillaSolucion(GrillaSolucion),
	%Busca el elemento solucion de la posicion [fila, columna]
    buscarFila(GrillaSolucion, RowN, ListaFila),
    buscarElemento(ListaFila, ColN, Contenido),
	%Revela en la grilla el elemento hallado.
	put(Contenido, [RowN, ColN], PistasFilas, PistasColumnas, Grilla, NewGrilla, FilaSat, ColSat),
	ResultadoOp is 1.

/*
* Comprueba la grilla y verifica si la celda [fila, columna] está vacía.
*/
celdaVacia(Grilla, [RowN, ColN]):-
	buscarFila(Grilla, RowN, ListaFila),
    buscarElemento(ListaFila, ColN, Contenido),
	Contenido="_".


/*
* Busca la fila del elemento.
*/
buscarFila([[F|Fila]|_], 0, [F|Fila]).
buscarFila([[_F|_Fila]|Grilla], PosFila, ListaFila):-
	PosFila>0,
    Pos is PosFila-1,
    buscarFila(Grilla, Pos, ListaFila).


/*
* Busca el elemento de la posicion indicada por Columna y lo retorna.
*/
buscarElemento([X|_], 0, X).
buscarElemento([_X|Y], Columna, Elemento):-
	Columna > 0,
    Col is Columna-1,
    buscarElemento(Y, Col, Elemento).