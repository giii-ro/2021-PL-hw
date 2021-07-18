nQueen(N):-
     findall(Tmp,queens(N, Tmp),Cand),
     write('n='), write(N), nl,
     len(Cand,L), write('# of answer='), write(L), nl,
     write(Cand).

queens(N, Qs):-
     numlist(1, N, Li),
     queens(Li, [], Qs).

queens(CandQueens, CurQueens, Qs) :-
     select(Picked, CandQueens, NewCandQueens),
     \+isdiagonal(Picked, CurQueens),
     queens(NewCandQueens, [Picked|CurQueens], Qs).

queens([], Qs, Qs).

isdiagonal(X, Xs) :- isdiagonal(X, 1, Xs).

isdiagonal(X, N, [Y|_]) :- X is Y + N; X is Y - N.
isdiagonal(X, N, [_|Ys]) :-
     N1 is N + 1,
     isdiagonal(X, N1, Ys).

len([], Len):-
     Len is 0.

len([_|Y], Len):-
     len(Y, L),
     Len is L + 1.







