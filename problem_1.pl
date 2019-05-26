div(X,2) :- 0 < mod(X,2).
div(X,Y) :- Y > 2, 0 < mod(X,Y), Z is Y-1, div(X,Z).
prime(2) :- true.
prime(N) :- N > 2, Z is N-1, div(N,Z).

sep(N,N1) :- N2 is N-N1, prime(N1), prime(N2), write('Output: '), write(N1), write(' '), write(N2), nl, false.

find(N,N1) :- sep(N,N1); N2 is N1+1, N2 =< N/2, find(N,N2).

main :- write('Input: '), read(N), find(N,2), halt; halt.

:- initialization(main).
