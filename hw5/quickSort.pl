quickSort([]).
quickSort(List):-
    go(List, SORTED),
    write(SORTED).

go([],[]).
go([PV|T], S):-
    divide(PV,T, L, R),
    p(PV, L, R),
    go(L, LSORTED), go(R, RSORTED),
    p2(LSORTED, PV, RSORTED),
    merge(LSORTED, [PV|RSORTED], S).

divide(_,[],[],[]).
divide(PV,[H|T],[H|L],R):-
    H=<PV,divide(PV,T,L,R).
divide(PV,[H|T],L,[H|R]):-
    H>PV,divide(PV,T,L,R).

p(_,[],[]).
p(PV, L, R):-
    write('divide='), write(PV), write('|'), write(L), write(R), nl.
p2([],PV,[]):-
    write('merge:'),write([PV]), nl.
p2(L, PV, R):-
    write('merge:'), write(L), write([PV]), write(R), nl.
