:- module(proylcc,
	[  
		put/8
	]).

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
/* Métodos creados y modificados por nosotros */

put(Contenido, [RowN, ColN], PistasFilas, PistasColumnas, Grilla, NewGrilla, FilaSat, ColSat):-
	% NewGrilla es el resultado de reemplazar la fila Row en la posición RowN de Grilla
	% (RowN-ésima fila de Grilla), por una fila nueva NewRow.
	
	replace(Row, RowN, NewRow, Grilla, NewGrilla),

	verificar_pistas_filas(PistasFilas, RowN, NewGrilla, FilaSat),
	verificar_pistas_columnas(PistasColumnas, ColN, NewGrilla, ColSat),

	% NewRow es el resultado de reemplazar la celda Cell en la posición ColN de Row por _,
	% siempre y cuando Cell coincida con Contenido (Cell se instancia en la llamada al replace/5).
	% En caso contrario (;)
	% NewRow es el resultado de reemplazar lo que se que haya (_Cell) en la posición ColN de Row por Conenido.	 
	
	(replace(Cell, ColN, _, Row, NewRow),
	Cell == Contenido 
		;
	replace(_Cell, ColN, Contenido, Row, NewRow)).

/**
 * Verifica si se satisfacen las pistas de una fila dada
 * param {PistasFilas} Lista que contiene las pistas que debe satisfacer la fila
 * param {RowN} Número de la fila a verificar (0...length(Grilla))
 * param {Grilla} Grilla a validar
 * param {FilaSat} Retorna 1 si se satisfacen las pistas, nada en caso contrario
 * */
% verificar_pistas_filas(+PistasFilas, +RowN, +NewGrilla, -FilaSat)
verificar_pistas_filas(PistasFilas, 0, [ [F | Fila] | _Grilla], FilaSat) :-
	F = "#",
	rafaga(PistasFilas, [F | Fila], FilaSat).

verificar_pistas_filas(PistasFilas, 0, [ [F | Fila] | _Grilla], FilaSat) :-
	F \= "#",
	no_rafaga(PistasFilas, [F | Fila], FilaSat).

verificar_pistas_filas(PistasFilas, RowN, [_Fila | Grilla], FilaSat) :-
	RowNaux is RowN - 1,
	verificar_pistas_filas(PistasFilas, RowNaux, Grilla, FilaSat). 

/**
 * Verifica una ráfaga de "#" se corresponde con su pista
 * param {PistasFilas} Lista con las pistas de la fila
 * param {Fila} Lista que representa la fila a verificar si se cumplen las pistas
 * param {FilaSat} Devuelve 1 si se satisfacen las pistas, nada en caso contrario
 * */
% rafaga(+PistasFilas, +Fila, -FilaSat)
rafaga([0], [], 1).
rafaga([PF | PFs], ["#" | Fila], FilaSat) :- 
	PF > 0,
	PFaux is PF - 1,
	rafaga([PFaux | PFs], Fila, FilaSat).

rafaga([PF | PFs], [F | Fila], FilaSat) :- 
	F \= "#",
	PF =< 0,
	no_rafaga(PFs, [F | Fila], FilaSat).

/**
 * Verifica que una ráfaga de "X" se corresponde con su pista
 * param {PistasFilas} Lista con las pistas de la fila
 * param {Fila} Lista que representa la fila a verificar si se cumplen las pistas
 * param {FilaSat} Devuelve 1 si se satisfacen las pistas, nada en caso contrario
 * */
% no_rafaga(+PistasFilas, +Fila, -FilaSat)
no_rafaga([], [], 1).
no_rafaga(PF, [F | Fila], FilaSat) :- 
	F \= "#",
	no_rafaga(PF, Fila, FilaSat).
no_rafaga(PF, [F | Fila], FilaSat) :-
	F = "#",
	rafaga(PF, [F | Fila], FilaSat).

/**
 * Verifica si se satisfacen las pistas de una columna dada
 * param {PistasColumnas} Lista que contiene las pistas que debe satisfacer la columna
 * param {ColN} Número de la columna a verificar (0...length(Grilla[0]))
 * param {Grilla} Grilla a validar
 * param {ColSat} Retorna 1 si se satisfacen las pistas, nada en caso contrario
 * */
% verificar_pistas_columnas(+PistasColumnas, +ColN, +NewGrilla, -ColSat)
verificar_pistas_columnas(PistasColumnas, ColN, Grilla, ColSat) :-
	recuperar_columna(ColN, Grilla, Columna), 
	verificar_pistas_filas(PistasColumnas, 0, [Columna], ColSat).

/**
 * Método auxiliar recuperar_columna
 * Devuelve en una lista la columna deseada
 * param {ColN} Número de columna a buscar
 * param {Grilla} Grilla que contiene la columna buscada
 * param {Columna} Lista que contiene a la columna buscada
 * */
% recuperar_columna(+ColN, +Grilla, -Columna).
recuperar_columna(_ColN, [], []).
recuperar_columna(ColN, [G | Grilla], [E | Columna]) :-
	recuperar_elemento(ColN, G, E),
	recuperar_columna(ColN, Grilla, Columna).

/**
 * Método auxiliar recuperar_elemento
 * Devuelve un elemento en un índice dado de una lista
 * param {ColN} Índice donde se encuentra el elemento (0..length(Fila))
 * param {Fila} Lista donde buscar el elemento
 * param {E} Devuelve el elemento buscado
 * */
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
% V1: No anda, pero lo dejo por las dudas
% verificar_pistas_filas(+PistasFilas, +RowN, +NewGrilla, -FilaSat)
/* verificar_pistas_filas(PistasFilas, 0, [Fila | _Grilla], FilaSat) :- 
	contar_contenido_fila(PistasFilas, Fila, FilaSat).
verificar_pistas_filas(PistasFilas, RowN, [Fila | Grilla], FilaSat) :-
	RowNAux is RwN - 1,
	verificar_pistas_filas(PistasFilas, RowNAux, Grilla, FilaSat).
*/
% contar_contenido_fila(+Pistas, +Fila, -FilaSat)
/*contar_contenido_fila([], [], 1).
contar_contenido_fila([P | Pistas], [F | Fila], FilaSat) :-
	F = "#",
	Paux is P - 1,
	Paux > 0,
	contar_contenido_fila([Paux | Pistas], Fila, FilaSat).
contar_contenido_fila([P | Pistas], [F | Fila], FilaSat) :-
	F = "#",
	Paux is P - 1,
	Paux =< 0,
	contar_contenido_fila(Pistas, Fila, FilaSat).
contar_contenido_fila(Pistas, [F | Fila], FilaSat) :-
	F \= "#",
	contar_contenido_fila(Pistas, Fila, FilaSat).
*/
/*
	TODO: Es una aproximación, pero falla en el caso de
	?- verificar_pistas_filas([3], 0, [["X","#","#","X","#"]], FilaSat).
	FilaSat = 1.

	Ahí debería fallar, pero no lo hace
	En el resto de los casos anda bien.
	Mentira, me detecta _ == "#" -> true. No sé por qué

*/
/*
 verificar_pistas_columnas(+PistasColumnas, +ColN, +NewGrilla, -ColSat)
verificar_pistas_columnas(PistasColumnas, ColN, NewGrilla, 1).
*/