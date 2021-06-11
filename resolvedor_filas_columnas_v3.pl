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
    append([F], Cabeza, Cabeza_aux),
    resolver_columna(Pistas, N_Col, Index_aux, [Fila | Grilla], Cabeza_aux, no_rafaga, Res).
resolver_columna(Pistas, N_Col, Index, [[F | Fila] | Grilla], Cabeza, rafaga, Res) :-
    N_Col > Index,
    Index_aux is Index + 1,
    append([F], Cabeza, Cabeza_aux),
    resolver_columna(Pistas, N_Col, Index_aux, [Fila | Grilla], Cabeza_aux, rafaga, Res).
resolver_columna(Pistas, N_Col, N_Col, [[F | Fila] | Grilla], Cabeza, no_rafaga, [R | Res]) :-
    F \== "#",
    resolver_columna(Pistas, N_Col, 0, Grilla, [], no_rafaga, Res),
    append(["X"], Fila, Raux),
    append(Cabeza, Raux, R).
resolver_columna([P | Pistas], N_Col, N_Col, [[F | Fila] | Grilla], Cabeza, no_rafaga, [R | Res]) :-
    P > 0,
    P_Aux is P - 1,
    F \== "X",
    resolver_columna([P_Aux | Pistas], N_Col, 0, Grilla, [], rafaga, Res),
    append(["#"], Fila, Raux),
    append(Cabeza, Raux, R).
resolver_columna([P | Pistas], N_Col, N_Col, [[F | Fila] | Grilla], Cabeza, rafaga, [R | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_columna([P_Aux | Pistas], N_Col, 0, Grilla, [], rafaga, Res),
    append(["#"], Fila, Raux),
    append(Cabeza, Raux, R).
resolver_columna([0 | Pistas], N_Col, N_Col, [[F | Fila] | Grilla], Cabeza, rafaga, [R | Res]) :-
    F \== "#",
    resolver_columna(Pistas, N_Col, 0, Grilla, [], no_rafaga, Res),
    append(["X"], Fila, Raux),
    append(Cabeza, Raux, R).