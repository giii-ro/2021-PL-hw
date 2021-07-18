adj(1,2,6). adj(2,1,6). adj(1,3,3). adj(3,1,3). adj(2,3,2). adj(3,2,2).
adj(2,4,5). adj(4,2,5). adj(3,4,3). adj(4,3,3). adj(3,5,4). adj(5,3,4).
adj(4,5,2). adj(5,4,2). adj(4,6,3). adj(6,4,3). adj(5,6,5). adj(6,5,5).

connected(U,V,L) :- adj(U,V,L) ; adj(V,U,L).

path(U, V, Path, Len) :-
    go(U, V, [U], Q, Len),
    reverse(Q, Path).

go(U, V, P, [V|P], L) :- connected(U, V, L).
go(U, V, Vis, Path, L) :-
    connected(U, By, Curdist),
    By =\= V,
    \+member(By, Vis),
    go(By, V, [By|Vis], Path, Bydist),
    L is Curdist + Bydist.

min(X, Y, X):- X =< Y.
min(X, Y, Y):- X > Y.

findMin([[_|L]|T], Mn) :-
    Tmp is L,
    findMin(T, Tmp, Mn).

findMin([], Mn, Mn).
findMin([[_|L]|T], PrevMn, Mn):-
    Val is L,
    min(PrevMn, Val, CurMn),
    findMin(T, CurMn, Mn).

findMinPath([],_, _).
findMinPath([[H|L]|T], Mn, P) :-
    Val is L,
    Val =:= Mn -> write(H), nl, findMinPath(T, Mn, [H|P]); findMinPath(T, Mn, P).

sp(U,V) :-
    setof([P,L],path(U,V,P,L),Allpathœ),
    findMin(Allpath, Mn),
    findMinPath(Allpath, Mn, P),
    write(Mn).

