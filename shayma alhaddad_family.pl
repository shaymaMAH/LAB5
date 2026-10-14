% ARTI 303 - Lab 5 - Task 1 : Arab family tree (same shape as the Simpsons figure)
% parent(Parent, Child)  ->  parent(abdullah, mohammed) = Abdullah is a parent of Mohammed

% ---------------- Facts ----------------
male(abdullah).  male(khalid).  male(hamad).  male(mohammed).  male(ali).

female(maryam).  female(jawaher). female(huda).  female(hanan).
female(sara).    female(noura).   female(reem).  female(layla).

parent(abdullah, hamad).
parent(abdullah, mohammed).  parent(maryam, mohammed).
parent(khalid, huda).        parent(jawaher, huda).
parent(khalid, hanan).       parent(jawaher, hanan).
parent(khalid, sara).        parent(jawaher, sara).
parent(mohammed, ali).       parent(huda, ali).
parent(mohammed, noura).     parent(huda, noura).
parent(mohammed, reem).      parent(huda, reem).
parent(sara, layla).

% ---------------- Rules ----------------
father(F, C)  :- parent(F, C), male(F).
mother(M, C)  :- parent(M, C), female(M).

son(S, P)      :- parent(P, S), male(S).
daughter(D, P) :- parent(P, D), female(D).

% sibling: X and Y share a parent. The \+ part keeps only the first shared
% parent, so full siblings (same father AND mother) are reported once only.
sibling(X, Y) :-
    parent(P, X), parent(P, Y), X \= Y,
    \+ ( parent(Q, X), parent(Q, Y), Q @< P ).

brother(B, X) :- sibling(B, X), male(B).
sister(S, X)  :- sibling(S, X), female(S).

grandfather(G, C) :- parent(G, P), parent(P, C), male(G).

aunt(A, C)  :- parent(P, C), sister(A, P).
uncle(U, C) :- parent(P, C), brother(U, P).

cousin(X, Y) :- parent(P1, X), parent(P2, Y), sibling(P1, P2).

% recursive rule: base case + recursive case
ancestor(A, D) :- parent(A, D).
ancestor(A, D) :- parent(A, P), ancestor(P, D).

% ---------------- Test queries and answers (SWI-Prolog) ----------------
% ?- father(F, ali).                F = mohammed.
% ?- father(abdullah, X).           X = hamad ; X = mohammed.
% ?- mother(M, noura).              M = huda.
% ?- mother(huda, X).               X = ali ; X = noura ; X = reem.
% ?- son(S, mohammed).              S = ali.
% ?- son(ali, P).                   P = mohammed ; P = huda.
% ?- daughter(D, huda).             D = noura ; D = reem.
% ?- daughter(layla, P).            P = sara.
% ?- brother(B, noura).             B = ali.
% ?- brother(hamad, X).             X = mohammed.
% ?- sister(S, ali).                S = noura ; S = reem.
% ?- sister(hanan, X).              X = huda ; X = sara.
% ?- grandfather(G, ali).           G = abdullah ; G = khalid.
% ?- grandfather(khalid, X).        X = ali ; X = noura ; X = reem ; X = layla.
% ?- aunt(A, ali).                  A = hanan ; A = sara.
% ?- aunt(A, layla).                A = huda ; A = hanan.
% ?- uncle(U, ali).                 U = hamad.
% ?- uncle(hamad, X).               X = ali ; X = noura ; X = reem.
% ?- cousin(C, layla).              C = ali ; C = noura ; C = reem.
% ?- cousin(ali, Y).                Y = layla.
% ?- ancestor(A, ali).              A = mohammed ; A = huda ; A = abdullah ; A = maryam ; A = khalid ; A = jawaher.
% ?- ancestor(abdullah, D).         D = hamad ; D = mohammed ; D = ali ; D = noura ; D = reem.
