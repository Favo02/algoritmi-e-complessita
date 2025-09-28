#import "../imports.typ": *

== Problema CenterSelection (Selezione dei centri)

#informalmente[
  Dato un territorio (insieme di punti), vogliamo capire dove costruire dei centri, rispettando un certo budget $k$ a disposizione. \
  In base a dove i centri vengono collocati si creano dei bacini di utenza (celle di Vornoi), ovvero l'insieme di punti più vicino ad un certo centro rispetto a tutti gli altri. \ 
  L'obbiettivo del problema è minimizzare il tempo che la persona più lontanta da un centro impiega per raggiungerlo.   
]

Alla base del problema vi è la definizione di *spaziometrico*. In particolare, dati : 
- *$Omega$, insieme di punti*
- *funzione di distanza $d: Omega times Omega -> bb(R)$*, la quale associa ad ogni coppia di punti una distanza
Lo spazio dei punti *$Omega$ si dice spaziometrico sse $forall x,y,z in Omega$*, valgono:
1. *$d(x,y) >= 0$ e $d(x,y)=d(y,x)$*
2. *$d(x,y)=0 "sse" x=y$*
3. *Disuguaglianza triangolare $d(x,z) + d(z,y) >= d(x,y)$*, ovvero la distanza percorsa per andare da $x$ a $y$ passando per un punto intermedio $z$ è sicuramente maggiore rispetto alla via diretta.  

#esempio()[
  Lo spazio euclideo $n$-dimensionale $(R^n,d)$ è uno spaziometrico. Dove $d$ è la distanza Euclidea: 
  $ d(x,y) = sqrt(sum_(i=1)^n (x_i-y_i)^2) $
  Si possono usare anche differenti distanze, come quella di Churchill: 
  $ d_"hill"(x,y)=max_(i=1)^n (x_i-y_i) $


]