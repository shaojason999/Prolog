input_edge(0).
input_edge(E) :- E>0, write('Node A: '), read(A), write('Node B: '), read(B), assertz(edge(A,B)), assertz(edge(B,A)), E1 is E-1, input_edge(E1).

path(A,A,_).
path(A,B,M) :- edge(A,B); edge(A,C), not(visited(C,M)), assertz(visited(C,M)), path(C,B,M).

start_check_edge(A,B,M) :- assertz(visited(A,M)), path(A,B,M), write('Yes'), nl; write('No'), nl.

queries(0).
queries(M) :- M>0, write('Node A: '), read(A), write('Node B: '), read(B), start_check_edge(A,B,M), M1 is M-1, queries(M1).

:- write('Nodes: '), read(N), write('Edges: '), read(E), write('Set edges: '), nl, input_edge(E), write('Queries: '), read(M), queries(M), halt.
