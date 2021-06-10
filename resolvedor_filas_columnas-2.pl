%
% resolver_fila(+Pistas, +N_Fila, +Grilla, +Resto, +Modo, -Res)
%
% Debe ser invocado con
% resolver_fila([lista], numero, [[grilla]], _, no_rafaga, R).
%
/**
 * Dada una grilla, resuelve una fila acorde a las pistas y la retorna en Res
 * @param Pistas Lista con las pistas
 * @param N_Fila Número de fila a resolver (0..lenght(grilla))
 * @param Grilla Grilla donde se encuentra la fila a resolver
 * @param Resto La parte restante de la grilla que no forma parte de la fila
 * @param Modo Modo de inserción de la recursión anterior. Puede ser 'rafaga' o 'no_rafaga'
 * @return Res Grilla con la fila resuelta
 */
resolver_fila([0], 0, [[] | Grilla], Grilla, rafaga, []).
resolver_fila([], 0, [[] | Grilla], Grilla, no_rafaga, []).
resolver_fila(Pistas, N_Fila, [G | Grilla], _Resto, no_rafaga, [G | R]) :-
    N_Fila > 0,
    N_Fila_Aux is N_Fila - 1,
    resolver_fila(Pistas, N_Fila_Aux, Grilla, Resto, no_rafaga,  Res),
    append([Res], Resto, R).
resolver_fila(Pistas, 0, [[F | Fila] | Grilla], Resto, no_rafaga, ["X" | Res]) :-
   % F \== [], % verificar si el código sigue andando sin esta línea. De ser así, borrarla
    F \== "#",
    resolver_fila(Pistas, 0, [Fila | Grilla], Resto, no_rafaga, Res).
resolver_fila([P | Pistas], 0, [[F | Fila] | Grilla], Resto, no_rafaga, ["#" | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_fila([P_Aux | Pistas], 0, [Fila | Grilla], Resto, rafaga, Res).
resolver_fila([P | Pistas], 0, [[F | Fila] | Grilla], Resto, rafaga, ["#" | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_fila([P_Aux | Pistas], 0, [Fila | Grilla], Resto, rafaga, Res).
resolver_fila([0 | Pistas], 0, [ [F | Fila] | Grilla], Resto, rafaga, ["X" | Res]) :-
    F \== "#",
    resolver_fila(Pistas, 0, [Fila | Grilla], Resto, no_rafaga, Res).

%
% resolver_columna(+Pistas, +N_Col, +Index, +Grilla, +Cabeza, +Modo, -Res)
%
% Debe ser invocado con
% resolver_columna([lista], numero, 0, [[grilla]], [], no_rafaga, R).
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