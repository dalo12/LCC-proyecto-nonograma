
:- module(init, [ init/3 , grillaSolucion/1]).

:-dynamic grillaSolucion/1.

/*
init(
[[3], [1,2], [4], [5], [5]],	% PistasFilas

[[2], [5], [1,3], [5], [4]], 	% PistasColumnas

[["X", _ , _ , _ , _ ], 		
 ["X", _ ,"X", _ , _ ],
 ["X", _ , _ , _ , _ ],		% Grilla
 ["#","#","#", _ , _ ],
 [ _ , _ ,"#","#","#"]
]
).

init(
    [[1], [3], [1,1], [3], [5]],	% PistasFilas

    [[1], [4], [2,2], [4], [1]], 	% PistasColumnas

    [
    [ _ , _ , _ , _ , _ ], 		
    [ _ , _ , _ , _ , _ ],
    [ _ , _ , _ , _ , _ ],		% Grilla
    [ _ , _ , _ , _ , _ ],
    [ _ , _ , _ , _ , _ ]
    ]
).
*/

init(PistasFilas, PistasColumnas, Grilla):-
    PistasFilas = [[6], [3,1], [1,2], [2,3], [6], [4], [5], [2,4], [2,4,1], [3,6]],	% PistasFilas
    PistasColumnas = [[1], [1,3,3], [2,7], [2,3], [2,7], [1,8], [5,4], [3], [1], [2]], 	% PistasColumnas
    Grilla = [
                ["X", _ , _ , _ , _ , _ , _ , _ ,"X", _ ], 		
                ["X", _ , _ , _ , _ , _ , _ ,"X", _ , _ ],
                ["X", _ ,"X", _ ,"X", _ , _ , _ ,"X", _ ],
                ["X", _ , _ ,"X", _ , _ , _ ,"X","X", _ ],
                ["X", _ , _ , _ , _ , _ , _ , _ , _ ,"X"],		% Grilla
                ["X", _ , _ , _ , _ , _ ,"X", _ , _ , _ ],
                ["X","X", _ , _ , _ , _ , _ , _ ,"X", _ ],
                [ _ , _ , _ , _ , _ , _ , _ , _ ,"X","X"],
                [ _ , _ , _ ,"X", _ , _ , _ , _ ,"X", _ ],
                [ _ , _ , _ , _ , _ , _ , _ , _ , _ , _ ]
            ],
    obtenerTableroSolucion(PistasFilas, PistasColumnas, GrillaSolucion),
    assert(grillaSolucion(GrillaSolucion)). %almacena en el programa la grilla solucion

obtenerTableroSolucion(_PistasFilas, _PistasColumnas, Grilla):-
    %Reemplazar por predicado para obtener grilla solucion
    Grilla = [
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 		
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ], 
        ["X", "X" , "X" , "X" , "X" , "X" , "X" , "X" ,"X", "X" ]
    ].