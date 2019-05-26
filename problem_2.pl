node(0) :- true.
node(N) :- N > 0, write("Ancestor: "), read(A), write("Child: "), read(B), assertz(parent(A,B)), N1 is N-1, node(N1).

ancestor(A,B,ANS_NUM) :- A =:= B, assertz(ans(ANS_NUM,A)); parent(N,A), ancestor(N,B,ANS_NUM).

co_ancestor(A,B,ANS_NUM) :- ancestor(A,B,ANS_NUM); parent(N,B), co_ancestor(A,N,ANS_NUM).

find(0) :- true.
find(ANS_NUM) :- ANS_NUM > 0, write("Node 1: "), read(A), write("Node 2: "), read(B),not(co_ancestor(A,B,ANS_NUM)), assertz(ans(ANS_NUM,-1)), false; ANS_NUM1 is ANS_NUM-1, find(ANS_NUM1).

print(0) :- true.
print(N) :- ans(N,X), write("LCA: "), write(X) ,nl, N1 is N-1, print(N1).

main :- write("Node number( =edge number+1): "), read(N), N1 is N-1, node(N1), write("Number of queries: "), read(M), find(M), nl, write("Ans:"), nl, print(M), halt.

:- initialization(main).
