hanoi(N) :- go(N, 1, 2, 3).

go(0, _, _, _) :- !.
go(N, FROM, TO, BY) :-
    NN is N - 1,
    go(NN, FROM, BY, TO),
    p(N, FROM, TO),
    go(NN, BY, TO, FROM).


p(N, FROM, TO) :-
    write(N),
    write('->'),
    write([FROM,TO]), nl.
