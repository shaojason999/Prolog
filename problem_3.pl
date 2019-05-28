self_edge(0).
self_edge(N) :- N>0, assertz(edge(N,N)), N1 is N-1, self_edge(N1).

input_edge(0).
input_edge(E) :- E>0, write('Node A: '), read(A), write('Node B: '), read(B), assertz(edge(A,B)), assertz(edge(B,A)), E1 is E-1, input_edge(E1).

check_edge(A,B) :- edge(A,B); edge(A,C), C > A, check_edge(C,B).
start_check_edge(A,B) :- check_edge(A,B), write('Yes'), nl; write('No'), nl.

queries(0).
queries(M) :- M>0, write('Node A: '), read(A), write('Node B: '), read(B), start_check_edge(A,B), M1 is M-1, queries(M1).

:- write('Nodes: '), read(N), self_edge(N), write('Edges: '), read(E), write('Set edges: '), nl, input_edge(E), write('Queries: '), read(M), queries(M), halt.
