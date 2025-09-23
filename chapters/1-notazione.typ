#import "../imports.typ": *

= Notazione

== Insiemi numerici

/ $bb(N)$: Numeri naturali con zero
/ $bb(Z)$: Numeri relativi (numeri interi sia positivi che negativi)
/ $bb(Q)$: Numeri razionali (frazioni)
/ $bb(R)$: Numeri reali

#nota[
  Tutti gli insiemi prevedono anche il loro sottoinsieme _strettamente_ positivo: $bb(N^+), bb(Z^+), bb(Q^+), bb(R^+)$
]

== Monoide libero

/ $Sigma$: alfabeto, insieme finito non vuoto di simboli
/ $Sigma^*$: monoide libero su $Sigma$, ovvero l'insieme delle stringhe valide sull'alfabeto $Sigma$
/ $epsilon$: parola vuota
/ $w in Sigma^*$: parola o stringa (sequenza di simboli) sull'alfabeto $Sigma$
/ $|w|$: lunghezza della parola $w$

#esempio[
  $Sigma = { a, b, c }$

  $Sigma^* = { epsilon, a, b, c, a a, a b, a c, b a, b b, b c, c a, c b, c c, ... }$

  $w in Sigma^*, quad w_i = "carattere" in Sigma, quad w = w_0, w_1, ..., w_(|w|-1)$
]

== Potenze di insiemi

/ $A, B$: insiemi
/ $A^B$: insieme delle funzioni da $B$ (dominio) ad $A$ (codominio):
$ A^B = { f | f : B -> A } $

#nota[
  L'idea della notazione è sapere immediatamente quante sono queste funzioni. Assumendo che $A$ e $B$ siano finiti, allora esistono $|A|^(|B|)$ funzioni da $B$ ad $A$.

  #esempio[
    Dati $A = {a, b, c}$ e $B = {0,1}$, quante funzioni esistono da $A$ a $B$?
    Per ogni elemento del dominio ($A$), posso scegliere ogni elemento del codominio ($B$), quindi $2 dot 2 dot 2 = 2^3 = |B|^(|A|)$.
  ]
]

== Insiemi

Se $k in bb(N)$, allora usiamo lo stesso simbolo $k$ per definire tutto l'insieme $k = {0, 1, ..., k-1}$.

#informalmente[
  Usiamo lo stesso simbolo sia per il numero singolo che per l'insieme. Bisogna capire a seconda del contesto.
]

Possiamo quindi scrivere:
- $0 = emptyset$
- $1 = {0}$ (insieme che contiene un qualsiasi singolo elemento)
- $2 = {0,1}$ alfabeto binario


#esempio[
  Sia $A$ un insieme, possiamo scrivere:
  - $A^2 = {(a, b) | a, b in A} subset.eq A times A$: "normalmente" è l'insieme delle coppie di $A$
  - $A^2 = {f | f: 2 -> A}$: con la notazione appena introdotta, $2$ è insieme, quindi, usando la notazione potenze di insiemi, è l'insieme delle funzioni da $2 = {0, 1}$ ad $A$
  - $2^A = { f | f : A -> 2 } tilde.equiv P(A)$: insieme dei sottoinsiemi di $A$. Ogni sottoinsieme può essere rappresentato da una funzione binaria ($A -> 2$) che decide se un elemento appartiene al sottoinsieme. Di conseguenza l'insieme di tutte le funzioni binarie da $A$ non è altro che l'insieme delle parti di $A$

  #nota[
    Siano $A$ e $B$ due insiemi, $P(A) = {B | B subset.eq A}$. Ovvero tutti i possibili sottoinsiemi dell'insieme A, compresi $emptyset$ e $A$ stesso, detto insieme delle parti.
    La cardinalità dell'insieme delle parti di $A$ è $2^(|A|)$, per questo la notazione $2^"insieme"$.
  ]
]

== Linguaggi

Utilizzando la notazione di insieme appena introdotta, possiamo descrivere:
- $2^* =$ alfabeto delle stringhe binarie, ovvero il "linguaggio completo"
- $2^2^* = { X | X "è un linguaggio" }$: insieme dei sottoinsiemi di stringhe binarie, ovvero i linguaggi definiti sull'alfabeto $Sigma = {0, 1}$.

#esempio[
  Alcuni esempi di linguaggio:
  - $A = emptyset$: linguaggio vuoto, dice sempre di no
  - $B = 2^*$: linguaggio tutto vero
  - $C = {0,10,1010,dots,"x"0}$: insieme delle stringhe binarie che terminano per $0$
  - $D = {x | x "è la rappresentazione binaria di un numero primo"}$

  Si può dire che i linguaggi $A,B,C,D subset.eq 2^*$ o $A,B,C,D in 2^2^*$.
]

== Grafi

/ Grafo NON orientato: vertici e lati $G(V, E)$
/ Grafo orientato: nodi e archi $G(V, E)$
/ Grafo bipartito: i nodi sono divisi in due insiemi disgiunti $G(V_1 union V_2, E)$
/ Cammino: sequenza di nodi distinti connessi da archi (non ripetuti)

== Varie

/ Ottimo: indichiamo l'ottimo con $*$, $y^*$ è la soluzione ottima, $c^*$ è il valore assunto dalla funzione obiettivo sull'output ottimo
