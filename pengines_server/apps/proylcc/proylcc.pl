:- module(proylcc, [put/8, revelarCelda/7]).
:- use_module(proylcc:init).

:-use_module(library(lists)).


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
* PREDICADO PARA REVELAR EL VALOR DE LA CELDA
* ========================================================================================================
*/

/*
* Predicado revelarCelda/7
* Busca el elemento de la grilla solucion de la posicion [Fila, Columna] y actualiza el tablero empleando put/8
*/
revelarCelda(Grilla, [RowN, ColN], PistasFilas, PistasColumnas, NewGrilla, FilaSat, ColSat):-
    init:grillaSolucion(GrillaSolucion),
    buscarFila(GrillaSolucion, RowN, ListaFila),
    buscarElemento(ListaFila, ColN, Contenido),
    put(Contenido, [RowN, ColN], PistasFilas, PistasColumnas, Grilla, NewGrilla, FilaSat, ColSat),!.

/*
* Busca la fila del elemento.
*/
buscarFila([[F|Fila]|_], 0, [F|Fila]):-!.
buscarFila([[_F|_Fila]|Grilla], PosFila, ListaFila):-
    Pos is PosFila-1,
    buscarFila(Grilla, Pos, ListaFila).


/*
* Busca el elemento de la posicion indicada por Columna y lo retorna.
*/
buscarElemento([X|_], 0, X):-!.
buscarElemento([_X|Y], Columna, Elemento):-
    Col is Columna-1,
    buscarElemento(Y, Col, Elemento).