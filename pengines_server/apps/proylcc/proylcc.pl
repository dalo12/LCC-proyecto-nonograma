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

% verificar_pistas_filas(+PistasFilas, +RowN, +NewGrilla, -FilaSat)
verificar_pistas_filas(PistasFilas, 0, [Fila | _Grilla], FilaSat) :- 
	contar_contenido_fila(PistasFilas, Fila, FilaSat).
verificar_pistas_filas(PistasFilas, RowN, [Fila | Grilla], FilaSat) :-
	RowNAux is RwN - 1,
	verificar_pistas_filas(PistasFilas, RowNAux, Grilla, FilaSat).

% contar_contenido_fila(+Pistas, +Fila, -FilaSat)
contar_contenido_fila([], [], 1).
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

/*
	TODO: Es una aproximación, pero falla en el caso de
	?- verificar_pistas_filas([3], 0, [["X","#","#","X","#"]], FilaSat).
	FilaSat = 1.

	Ahí debería fallar, pero no lo hace
	En el resto de los casos anda bien.
	Mentira, me detecta _ == "#" -> true. No sé por qué

*/

% verificar_pistas_columnas(+PistasColumnas, +ColN, +NewGrilla, -ColSat)
verificar_pistas_columnas(PistasColumnas, ColN, NewGrilla, 1).
