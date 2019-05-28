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
    
#### 執行結果
```
$ swipl -q -s problem_1.pl 
Input: 4.
Output: 2 2

$ swipl -q -s problem_1.pl 
Input: 100.
Output: 3 97
Output: 11 89
Output: 17 83
Output: 29 71
Output: 41 59
Output: 47 53
```

## Problem 2
給你一棵樹，尋找任兩點的LCA(Lowest common ancestor)  

#### 思路
1. 先輸入tree的連結狀況
2. 任兩點a,b的ancestor的搜尋方式為b先不變，尋找看看a的所有祖先中有沒有b，如果有，則結束，如果沒有，則把b的變成b的祖先b1，再讓a從頭往上搜尋一次，一直下去，直到b的祖先都搜尋完畢才回傳fail
    * fail用-1表示
    * 概念類似於C的兩個for loop
3. 如此可以找到LCA
4. 把多個答案透過rule儲存: ans(M,"答案") 到 ans(1,"答案")
5. 為了方便程式實作，答案是從ans(M,)儲存到ans(1,)，印出時，也是從M輸出到1

#### 程式碼說明
這個程式設計成全部輸入完畢，才一次全部輸出結果，這雖然比一個結果一個結果輸出難實作，但還是試試看這種方式
1. node(N) :-
    * 為建構tree用的函式，很簡單，不贅述
    * 其中，assertz()是創造rule用
    ```
    node(0) :- true.
    node(N) :- N > 0, write("Ancestor: "), read(A), write("Child: "), read(B), assertz(parent(A,B)), N1 is N-1, node(N1).
    ```
    
以下的ANS_NUM是為了把答案儲存在ans(ANS_NUM, ) rule中，但是Prolog沒有像是C的global variable，因此把ANS_NUM當作參數傳進去

2. find(ANS_NUM) :-
    * 尋找第M-ANS_NUM+1個query的答案
    * 呼叫co_ancestor()來尋找，如果沒找到，則把答案設為-1儲存在ans(,) rule
    * 接著，無論是否成功，都要繼續尋找下一個(ANS_NUM-1)的query的答案，因此加入一個false，這樣才會執行; 會面的程式碼
    ```
    find(0) :- true.
    find(ANS_NUM) :- ANS_NUM > 0, write("Node 1: "), read(A), write("Node 2: "), read(B),not(co_ancestor(A,B,ANS_NUM)), assertz(ans(ANS_NUM,-1)), false; ANS_NUM1 is ANS_NUM-1, find(ANS_NUM1).
    ```
    * 從main呼叫find()時，一定為true，因為find()的分號後面最後會走到find(0)，為true

3. co_ancestor(A,B,ANS_NUM) :-
    * 呼叫ancestor(A,B,ANS_NUM)來把A的祖先往上全部找過一次，看當中有沒有B
    * 如果沒有B，則尋找B的上一個祖先N，然後目標變成co_ancestor(A,N,ANS_NUM)
    ```
    co_ancestor(A,B,ANS_NUM) :- ancestor(A,B,ANS_NUM); parent(N,B), co_ancestor(A,N,ANS_NUM).
    ```
    
4. ancestor(A,B,ANS_NUM)
    * 如果A=B，表示找到co_ancestor，呼叫assertz把答案儲存在ans規則中
    * 如果不等於，則往A的祖先繼續上去找(B一直都不變)
    ```
    ancestor(A,B,ANS_NUM) :- A =:= B, assertz(ans(ANS_NUM,A)); parent(N,A), ancestor(N,B,ANS_NUM).
    ```

5. print(N) :-
    * 把答案從ANS_NUM到1印出來
    ```
    print(0) :- true.
    print(N) :- ans(N,X), write("LCA: "), write(X) ,nl, N1 is N-1, print(N1).
    ```


#### 執行結果
* 先輸入要N個node，再輸入N-1條rule (ancestor, child)
* 接著輸入要M條query (node1, node2)，尋找這兩個node的lowest common ancestor
* 等全部輸入完畢後，結果一次輸出
```
$ swipl -q -s problem_2.pl 
Node number( =edge number+1): 6.
Ancestor: |: 1.
Child: |: 2.
Ancestor: |: 2.
Child: |: 3.
Ancestor: |: 1.
Child: |: 4.
Ancestor: |: 4.
Child: |: 5.
Ancestor: |: 4.
Child: |: 6.
Number of queries: |: 3.
Node 1: |: 3.
Node 2: |: 4.
Node 1: |: 5.
Node 2: |: 6.
Node 1: |: 1.
Node 2: |: 2.

Ans:
LCA: 1
LCA: 4
LCA: 1
```

## Problem 3
給你一張無向圖，問你任兩點間是否相通  

#### 思路
1. 透過prolog的特性，自己會去尋找相通的edge
2. 如果A<->C, C<->B都有通，則A<->B也有通
3. 避免無線輪迴，拜訪過的節點要記錄

#### 程式碼說明
1. input_edge(N) :-
    * 讀取輸入的edge
    * 因為是無向圖，所以edge(A,B)跟edge(B,A)都要加入
    ```
    input_edge(0).
    input_edge(E) :- E>0, write('Node A: '), read(A), write('Node B: '), read(B), assertz(edge(A,B)), assertz(edge(B,A)), E1 is E-1, input_edge(E1).
    ```

2. queries(M) :-
    * 呼叫start_check_edge(A,B,M)來執行一次query
        * M是表示第M次query，當作參數船進去是為了記錄拜訪過的節點
    ```
    queries(0).
    queries(M) :- M>0, write('Node A: '), read(A), write('Node B: '), read(B), start_check_edge(A,B,M), M1 is M-1, queries(M1).
    ```
    
3. start_check_edge(A,B,M) :-
    * 輸出結果yes or no
    * 呼叫path尋找A, B是否相通
    * 呼叫path之前要先記錄A已經拜訪過了
        * visited(A,M)表示第M次的query已經拜訪過A了
        * visited是避免因為cycle而無限迴圈
    ``` 
    start_check_edge(A,B,M) :- assertz(visited(A,M)), path(A,B,M), write('Yes'), nl; write('No'), nl.
    ```
    
4. path(A,B,M) :-
    * 尋找A,B是否相通
    * 如果edge(A,B)表示直接相通，則一定是true
    * 如果沒有直接相通，則透過edge(A,C)，尋找與A直接相通的C點，然後去看path(C,B)是否有相通
        * 開始path(C,B)搜尋之前，先把C加入visited

    ```
    path(A,A,_).
    path(A,B,M) :- edge(A,B); edge(A,C), not(visited(C,M)), assertz(visited(C,M)), path(C,B,M).
    ```

#### 執行結果
1. 先輸入有幾個node(其實用不到)，題目也沒要求要檢查
2. 輸入有N個edge
3. 開始輸入E組(A,B)
4. 輸入要M個queries
5. 輸入M組(A,B)

```
$ swipl -q -s problem_3.pl
Nodes: 6.
Edges: |: 6.
Set edges: 
Node A: |: 1.
Node B: |: 2.
Node A: |: 2.
Node B: |: 3.
Node A: |: 3.
Node B: |: 1.
Node A: |: 4.
Node B: |: 5.
Node A: |: 5.
Node B: |: 6.
Node A: |: 6.
Node B: |: 4.
Queries: |: 2.
Node A: |: 1.
Node B: |: 3.
Yes
Node A: |: 1.
Node B: |: 5.
No
```

#### 其他說明
* 這個problem我換了兩個方法來寫  
    1. 直接寫 :- 來開始，而不是main與initialization(main)來開始
    2. queries(0). 表達true，而不是用queries(0) :- true. 來表達

* 小bug(其實也不完全算bug啦)
    * 沒有檢查是否輸入超過N個node
    * 如果沒有輸入過node是可以到達自己的
    
## 工具使用
善用trace: 可以知道Prolog整個運行流程，很有幫助  
* 把problem1的main最後的halt拿掉後就可以在$ swipl後繼續使用rule測試
    * ?- find(10,2)
* 按enter繼續
```
$ swipl -q -s problem_1.pl 
Input: 4.
Output: 2 2
?- trace.
true.

[trace]  ?- find(10,2).
   Call: (7) find(10, 2) ? creep
   Call: (8) sep(10, 2) ? creep
   Call: (9) _G1597 is 10-2 ? creep
   Exit: (9) 8 is 10-2 ? creep
   Call: (9) prime(2) ? 
.
.
.
```
    
## 小筆記
### 規則
1. 要求得的變數一定是英文大寫或底線_開頭
2. 規則須寫在.pl檔，利用$ swipl 執行時，只能求答案，無法增加規則

### 語言介紹
來源: [從X到Prolog](https://www.ithome.com.tw/voice/110557)
1. 規則不是函數，規則不會有回傳值，但是可以透過規則中的變數，讓Prolog去找出變數的值
2. 規則設定: 如果右邊成立，則左邊就成立
    ```
    1. avg2(N1, N2, AVG) :- AVG is (N1 + N2) / 2
    2. path(M, N) :- edge(M, S1), edge(S1, S2), edge(S2, N).
    ```
3. Prolog看起來就像是宣告式風格
    * 合一(Unification)與歸結(Resolution)交給Prolog自己去完成(尋找變數的值的過程)
    * 如何進行運算的部分交給Prolog，不必去寫
    * 撰寫Prolog時，多半是在進行事實與規則的宣告，然而，解釋器(interpreter)本身是命令式的
4. 觀點不同: write()的顯示只是副作用，主要是true
    ```
    avg2(N1, N2, AVG) :- AVG is (N1 + N2) / 2, write(AVG)
    ```
    * 如果AVG is (N1 + N2) / 2成立且write(AVG)成立，則avg2(N1, N2, AVG)才會成立
5. Prolog中的;表示or，用法類似於C的if else，如果前面不成立，才會執行後面，比如problem 1的
    ```
    find(N,N1) :- sep(N,N1); N2 is N1+1, N2 =< N/2, find(N,N2).
    ```
