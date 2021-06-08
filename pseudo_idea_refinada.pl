% resolver_fila(+Pistas, +N_Fila, +Grilla, +Modo, -Res)
/**
 * Dada una grilla, resuelve una fila acorde a las pistas y la retorna en Res
 * @param Pistas Lista con las pistas
 * @param N_Fila Número de fila a resolver (0..lenght(grilla))
 * @param Grilla Grilla donde se encuentra la fila a resolver
 * @param Modo Modo de inserción de la recursión anterior. Puede ser 'rafaga' o 'no_rafaga'
 * @return Res Fila solucionada
 */
%resolver_fila([0], 0, [[] | _Grilla], no_rafaga, []).
resolver_fila([0], 0, [[] | _Grilla], rafaga, []).
resolver_fila([], 0, [[] | _Grilla], no_rafaga, []).
resolver_fila(Pistas, N_Fila, [_G | Grilla], no_rafaga, Res) :-
    N_Fila > 0,
    N_Fila_Aux is N_Fila - 1,
    resolver_fila(Pistas, N_Fila_Aux, Grilla, no_rafaga, Res).
resolver_fila(Pistas, 0, [[F | Fila] | Grilla], no_rafaga, ["X" | Res]) :-
    F \== [],
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