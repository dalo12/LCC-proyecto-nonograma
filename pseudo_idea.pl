/*
    ESTA PSEUDO IDEA FUE DEPRECADA
    EN SU LUGAR CONSULTAR EL ARCHIVO 'pseudo_idea_refinada.pl'
    Pseudo idea de cómo resolver las filas.
    En una matriz de 5x5 (por ejemplo)
    Anda bien en los casos:
        - Si la pista es [5] retorna [#, #, #, #, #]
        - Si pista es [3, 1] retorna [#, #, #, X, #]
    No funciona en los casos de que la separación entre "#" sea de más de 1 "X"
    No funciona si la línea debe empezar en "X"
*/

% resolver_fila(+Pistas, +N_Fila, +Grilla, -Res)
/**
 * Dada una grilla, resuelve una fila acorde a las pistas y la retorna en Res
 * @param Pistas Lista con las pistas
 * @param N_Fila Número de fila a resolver (0..lenght(grilla))
 * @param Grilla Grilla donde se encuentra la fila a resolver
 * @return Res Fila solucionada
 */
resolver_fila(Pistas, N_Fila, [_G | Grilla], Res) :-
    N_Fila > 0,
    N_Fila_Aux is N_Fila - 1,
    resolver_fila(Pistas, N_Fila_Aux, Grilla, Res).
resolver_fila([], 0, [ [] | Grilla], []).
resolver_fila([0], 0, [ [] | Grilla], []).
resolver_fila([], 0, [ [F | Fila] | Grilla], ["X" | Res]) :-
    resolver_fila([], 0, [Fila | Grilla], Res).
resolver_fila([P | Pistas], 0, [[F | Fila] | Grilla], ["#" | Res]) :-
    P > 0,
    F \= "X", % es decir, F="#" ó F="_"
    P_Aux is P - 1,
    resolver_fila([P_Aux | Pistas], 0, [Fila | Grilla], Res).
resolver_fila([0 | Pistas], 0, [[F | Fila] | Grilla], ["X" | Res]) :-
    F \= "#", % es decir, F="X" ó F="_"
    resolver_fila(Pistas, 0, [Fila | Grilla], Res).

