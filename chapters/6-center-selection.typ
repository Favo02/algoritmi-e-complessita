#import "../imports.typ": *

== Problema CenterSelection (Selezione dei centri)

#informalmente[
  Dato un territorio (insieme di punti), vogliamo capire dove costruire dei centri, rispettando un certo budget $k$ a disposizione. \
  In base a dove i centri vengono collocati si creano dei bacini di utenza (celle di Voronoi), ovvero l'insieme di punti più vicino ad un certo centro rispetto a tutti gli altri. \ 
  L'obbiettivo del problema è minimizzare il tempo che la persona più lontana da un centro impiega per raggiungerlo.   
]

Alla base del problema vi è la definizione di *spazio metrico*. In particolare, dati : 
- *$Omega$, insieme di punti*
- *funzione di distanza $d: Omega times Omega -> bb(R)$*, la quale associa ad ogni coppia di punti una distanza
Lo spazio dei punti *$Omega$ si dice spazio metrico sse $forall x,y,z in Omega$*, valgono:
1. *$d(x,y) >= 0$ e $d(x,y)=d(y,x)$*
2. *$d(x,y)=0 "sse" x=y$*
3. *Disuguaglianza triangolare $d(x,z) + d(z,y) >= d(x,y)$*, ovvero la distanza percorsa per andare da $x$ a $y$ passando per un punto intermedio $z$ è sicuramente maggiore rispetto alla via diretta.  

#esempio()[
  Lo spazio euclideo $n$-dimensionale $(R^n,d)$ è uno spazio metrico. Dove $d$ è la distanza Euclidea: 
  $ d(x,y) = sqrt(sum_(i=1)^n (x_i-y_i)^2) $
  Si possono usare anche differenti distanze, come quella di Churchill: 
  $ d_"hill"(x,y)=max_(i=1)^n (x_i-y_i) $
]

//TODO Esempio di spazio di Vornoi

Dato uno *spazio di Vornoi*, ogni volta che andiamo a posizionare un centro esso viene partizionato. Ogni partizione prende il *nome di cella di Vornoi*: parte di piano dove tutti i punti facentene parte fanno riferimento allo stesso centro. 

#nota[
  Il numero di partizioni dello spazio che vengono a crearsi corrisponde al numero di centri inseriti.
]

Possiamo ora definire il *problema di CenterSelection*:
- Input: 
  - *$(Omega, d)$*, spazio metrico
  - *$S subset.eq Omega$*, punti dello spazio metrico
  - *$k in bb(N)^+$*, budget da rispettare

- *$"Amm"_(Pi)(x): C subset.eq S quad t.c |C| <= k $*, ovvero un sottoinsieme di punti (i centri) che rispettano il budget. 
- Definita: 
  *$ forall s in S rho(x,C) = min_(c in C) d(x,c) $*
  ovvero la distanza che un cittadino della cella $x$ impiega per ranggiungere un centro $C$ fissato.\
  La *funzione obbiettivo* è: 
  *$ rho(C) = max_(x in S) rho(x,c)  $*
  dove *$rho(C)$ è il raggio di copertura di $C$*
- *$t_Pi = max$*


