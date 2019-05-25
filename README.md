# Prolog

## Problem 1
Goldbach conjecture: 任一大於2的偶數都可以分成兩個質數相加，且可能有多組解

#### 思路
1. 輸入N，透過測試(2, N-2)是否都是prime，如果都是，則印出。接著，繼續測試下一組(3, N-3)，直到(N/2, N-N/2)
    * 無論是否為true，都繼續測試下一組的方法下面會講

#### 程式碼說明
1. find(N,N1) :-
    * 呼叫sep()試試看 N 是不是由 N1 以及 N-N1 兩個prime組成
    * 無論true of false，都繼續呼叫find(N,N2)，尋找下一組解，其中N2 is N1+1 且 N2 =< N/2
    * 綜合上述兩點 程式碼為(中間用;表示or)
        ```
        find(N,N1) :- sep(N,N1); N2 is N1+1, N2 =< N/2, find(N,N2).
        ```
    * 但是因為如果sep(N,N1)為true的話，後面就不會執行，因此一定要讓sep(N,N1)為false，方法後面會講

2. sep(N,N1) :-
    * 檢查 N1 及 N2 is N-N1 為prime，如果都是，則output
    * 上面find()有講到，一定要讓sep()為false，因此程式碼最後要加上 false
        ```
        sep(N,N1) :- N2 is N-N1, prime(N1), prime(N2), write('Outpu    t: '), write(N1), write(' '), write(N2), nl, false.
        ```

3. prime(N) :-
    * 透過呼叫div(N,Z)來檢查是否為prime
    ```
    prime(2) :- true.
    prime(N) :- N > 2, Z is N-1, div(N,Z).
    ```

4. div(X,Y) :-
    * 試試看是否從 X%Y 到 X%2 都不是0，如果為true，則為prime
    ```
    div(X,2) :- 0 < mod(X,2).
    div(X,Y) :- Y > 2, 0 < mod(X,Y), Z is Y-1, div(X,Z).
    ```





### 其他說明
1. Prolog中的;表示or，用法類似於C的if else，如果前面不成立，才會執行後面，比如problem 1的
    ```
    find(N,N1) :- sep(N,N1); N2 is N1+1, N2 =< N/2, find(N,N2).
    ```
