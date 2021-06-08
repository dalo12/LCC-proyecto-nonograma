% resolver_fila(+Pistas, +N_Fila, +Grilla, +Modo, -Res)
/**
 * Dada una grilla, resuelve una fila acorde a las pistas y la retorna en Res
 * @param Pistas Lista con las pistas
 * @param N_Fila Número de fila a resolver (0..lenght(grilla))
 * @param Grilla Grilla donde se encuentra la fila a resolver
 * @param Modo Modo de inserción de la recursión anterior. Puede ser 'rafaga' o 'no_rafaga'
 * @return Res Fila resuelta
 */
resolver_fila([0], 0, [[] | _Grilla], rafaga, []).
resolver_fila([], 0, [[] | _Grilla], no_rafaga, []).
resolver_fila(Pistas, N_Fila, [_G | Grilla], no_rafaga, Res) :-
    N_Fila > 0,
    N_Fila_Aux is N_Fila - 1,
    resolver_fila(Pistas, N_Fila_Aux, Grilla, no_rafaga, Res).
resolver_fila(Pistas, 0, [[F | Fila] | Grilla], no_rafaga, ["X" | Res]) :-
   % F \== [], % verificar si el código sigue andando sin esta línea. De ser así, borrarla
    F \== "#",
    resolver_fila(Pistas, 0, [Fila | Grilla], no_rafaga, Res).
resolver_fila([P | Pistas], 0, [[F | Fila] | Grilla], no_rafaga, ["#" | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_fila([P_Aux | Pistas], 0, [Fila | Grilla], rafaga, Res).
resolver_fila([P | Pistas], 0, [[F | Fila] | Grilla], rafaga, ["#" | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_fila([P_Aux | Pistas], 0, [Fila | Grilla], rafaga, Res).
resolver_fila([0 | Pistas], 0, [ [F | Fila] | Grilla], rafaga, ["X" | Res]) :-
    F \== "#",
    resolver_fila(Pistas, 0, [Fila | Grilla], no_rafaga, Res).

% resolver_columna(+Pistas, +N_Col, +Index, +Grilla, +Modo, -Res)
/**
 * Dada una grilla, resuelve una columna acorde a las pistas y la retorna en Res
 * @param Pistas Lista con las pistas
 * @param N_Col Número de columna a resolver (0..lenght(grilla[0]))
 * @param Index Índice que indica cual columna de la fila es la actual (0..N_Col)
 * @param Grilla Grilla donde se encuentra la columna a resolver
 * @param Modo Modo de inserción de la recursión anterior. Puede ser 'rafaga' o 'no_rafaga'
 * @return Res Columna resuelta
 */
resolver_columna([0], _N_Col, _Index, [], rafaga, []).
resolver_columna([], _N_Col, _Index, [], no_rafaga, []).
resolver_columna(Pistas, N_Col, Index, [[_F | Fila] | Grilla], no_rafaga, Res) :-
    N_Col > Index,
    Index_aux is Index + 1,
    resolver_columna(Pistas, N_Col, Index_aux, [Fila | Grilla], no_rafaga, Res).
resolver_columna(Pistas, N_Col, Index, [[_F | Fila] | Grilla], rafaga, Res) :-
    N_Col > Index,
    Index_aux is Index + 1,
    resolver_columna(Pistas, N_Col, Index_aux, [Fila | Grilla], rafaga, Res).
resolver_columna(Pistas, N_Col, N_Col, [[F | _Fila] | Grilla], no_rafaga, [["X"] | Res]) :-
    F \== "#",
    resolver_columna(Pistas, N_Col, 0, Grilla, no_rafaga, Res).
resolver_columna([P | Pistas], N_Col, N_Col, [[F | _Fila] | Grilla], no_rafaga, [["#"] | Res]) :-
    P > 0,
    P_Aux is P - 1,
    F \== "X",
    resolver_columna([P_Aux | Pistas], N_Col, 0, Grilla, rafaga, Res).
resolver_columna([P | Pistas], N_Col, N_Col, [[F | _Fila] | Grilla], rafaga, [["#"] | Res]) :-
    F \== "X",
    P > 0,
    P_Aux is P - 1,
    resolver_columna([P_Aux | Pistas], N_Col, 0, Grilla, rafaga, Res).
resolver_columna([0 | Pistas], N_Col, N_Col, [[F | _Fila] | Grilla], rafaga, [["X"] | Res]) :-
    F \== "#",
    resolver_columna(Pistas, N_Col, 0, Grilla, no_rafaga, Res).