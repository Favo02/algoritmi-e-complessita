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
  dove *$rho(C)$ è il raggio di copertura di $C$*, l'obbiettivo è dunque *mininimizzare $rho(C)$*
- *$t_Pi = min$*

#teorema("Teorema")[
  *$"CenterSelection" in "NPO-c"$*
]

=== Algoritmo CenterSelectionPlus

#informalmente[
  Per descrivere il problema di CenterSelection, andremo ad utilizzare una sua variante semplificata, ovvero CenterSelectionPlus. \
  Questa versione presenta un input in più: $r in bb(R)^+$. Utilizzato come raggio.
]

*Algoritmo $"CenterSelectionPlus"$*:

#import "@preview/lovelace:0.3.0": *
#pseudocode(
  [Input: $S subset.eq Omega$, $k in bb(N)^+, r in bb(R^+)$],
  [$C <- emptyset$],
  [*while* $S eq.not emptyset$],
  indent(
    [$hat(s) <- $ take any $hat(s) in S$],
    [$C <- C union {hat(s)}$],
    [remove from $S$ all $x "t.c" d(x,hat(s))<=2r$],
    [#emph("rimuove tutti i punti che stanno in un raggio " + $2r$ +" da "+$hat(s)$)],
    [*if* $|C| > k$],
    indent(
      [*output* "impossibile"]
    ),
    [*else*],
    indent(
      [*output* $C$]
    ),
    [*end*]
  )
)

//Todo Mettere un esempio

#nota[
  il comportamento dell'algoritmo è influenzato in base alla scelta del *parametro $r$*:
  - se *$r$ è molto grande*, *l'algoritmo produce quasi sicuramente una soluzione* che rispetta il budget (ad ogni passo cancello tanti punti)
  - se *$r$ è molto piccolo*, *l'algorimto trova delle soluzioni migliori ma che potrebbero sforare il budget* a disposizione, rendendole non ammissibili.  
]

#nota[
  L'algorimto di *$"CenterSelectionPuls"$ gode della proprietà di arbitrarietà*, in alcuni punti può effettuare delle scelte "casuali" (ad esempio non viene specificato come viene scelto il primo punto $hat(s)$).\
  Quando si implementa un algoritmo arbitrario, bisonga deciderne il comportamento. \
  
  Le analisi dell'algorimto vengono fatte indipendentemente dalle scelte arbitrarie effettuate. 
]

//TODO da sistemare
#figure(
  caption: [Esempio di esecuzione di CenterSelectionPlus con $k=2$ e $r$ fissato.],
  box(width: 200pt, height: 160pt, stroke: 0.5pt)[
    // Centri (in rosso)
    #place(top + left, dx: 70pt, dy: 80pt, circle(radius: 3pt, fill: red))
    #place(top + left, dx: 130pt, dy: 90pt, circle(radius: 3pt, fill: red))
    
    // Cerchi di raggio 2r centrati sui punti rossi
    #place(top + left, dx: 20pt, dy: 30pt, circle(radius: 50pt, stroke: red))
    #place(top + left, dx: 80pt, dy: 40pt, circle(radius: 50pt, stroke: red))

    // Punti normali
    #place(top + left, dx: 40pt, dy: 70pt, circle(radius: 2pt))
    #place(top + left, dx: 90pt, dy: 40pt, circle(radius: 2pt))
    #place(top + left, dx: 150pt, dy: 60pt, circle(radius: 2pt))
    #place(top + left, dx: 160pt, dy: 120pt, circle(radius: 2pt))
    #place(top + left, dx: 30pt, dy: 130pt, circle(radius: 2pt))
    #place(top + left, dx: 120pt, dy: 130pt, circle(radius: 2pt))

    // Collegamenti corretti ai centri più vicini
    #place(top + left, dx: 40pt, dy: 70pt, line(stroke: (dash: "dashed"), length: 35pt, angle: 20deg))
    #place(top + left, dx: 90pt, dy: 40pt, line(stroke: (dash: "dashed"), length: 45pt, angle: 110deg))
    #place(top + left, dx: 150pt, dy: 60pt, line(stroke: (dash: "dashed"), length: 35pt, angle: 120deg))
    #place(top + left, dx: 160pt, dy: 120pt, line(stroke: (dash: "dashed"), length: 35pt, angle: 225deg))
    #place(top + left, dx: 120pt, dy: 130pt, line(stroke: (dash: "dashed"), length: 35pt, angle: 290deg))

    // Etichette dei centri
    #place(top + left, dx: 65pt, dy: 90pt, text(fill: red, [c#sub[1]]))
    #place(top + left, dx: 125pt, dy: 100pt, text(fill: red, [c#sub[2]]))
  ]
)

#teorema("Teorema")[
  *Se l'algoritmo $"CenterSelectionPlus"$ emette un output, esso è una $(2r)/rho^*-"approssimazione"$ per $"CenterSelection"$*
]

#dimostrazione()[
  Seguendo l'algoritmo ogni punto $s in S$, viene cancellato dall'insieme dei punti se: 
  $ 
    "fissato" s in S,quad exists hat(s)in C "t.c" d(s,hat(s))<=2r \
    #emph("dato che "+ $s$ +" si trova dentro al raggio " +$rho(hat(s))$)\
    arrow underbrace(rho(C), d(s,hat(s))) <= 2r \
     rho(C)/rho^* <= (2r) / p^* quad qed
  $
  #nota()[
    Si può osservare come *il tasso di approssimazione decresce al valore di $r$*, tuttavia $r$ non può essere ridotto all'infinito.
  ]
]

#teorema("Teorema")[
  *Se $r>=rho^*$, $"CenterSelectionPlus"$ emmete sicuramente un output*.
]
#dimostrazione()[
  Sia $C^*$ una soluzione ottima, ovvero *$rho(C^*) = rho^*$*. Supponiamo ora di conoscere il valore di $rho^*$ e di eseguire l'algorimto $"CenterSelectionPlus"$ con *$r>=p^*$*. 
  
  Quando un punto $hat(s) in S$, viene aggiunto all'insieme dei centri, ci troviamo nella seguente situazione: 

  #figure(
    caption: [#mb("Blue raggio") = $rho^*$, #mr("Red raggio") = $r>=rho^*$],
    box(width: 200pt, height: 160pt, stroke: 0.5pt)[
      
      //Punto hat(s)
      #place(top + left, dx: 80pt, dy: 80pt, circle(radius: 3pt, fill: red))
      #place(top + left, dx: 75pt, dy: 90pt, text(fill: red, [$hat(s)$]))

      //Punto hat(C)
      #place(top + left, dx: 110pt, dy: 80pt, circle(radius: 3pt, fill: blue))
      #place(top + left, dx: 105pt, dy: 90pt, text(fill: blue, [$hat(c)$]))

      //Punto S^'
      #place(top + left, dx: 110pt, dy: 50pt, circle(radius: 3pt, fill: blue))
      #place(top + left, dx: 102pt, dy: 45pt, text(fill: blue, [$s^'$]))

      //punto S
      #place(top + left, dx: 30pt, dy: 50pt, circle(radius: 3pt, fill: red))
      #place(top + left, dx: 30pt, dy: 59pt, text(fill: red, [$s$]))

       #place(top + left, dx: 45pt, dy: 72pt, text(fill: black, [$<=2r$]))

      //Cerchio
      #place(top + left, dx: 45pt, dy: 30pt, circle(radius: 50pt, stroke: blue))
      #place(top + left, dx: 10pt, dy: 4pt, circle(radius: 75pt, stroke: red))

      //collegamenti 
      #place(top + left, dx: 85pt, dy: 83pt, line(stroke: (dash: "dashed"), length: 25pt, angle: 1deg))
      #place(top + left, dx: 110pt, dy: 83pt, line(stroke: (dash: "dashed"), length: 25pt, angle: 280deg))
      #place(top + left, dx: 35pt, dy: 55pt, line(length: 50pt, angle: 29deg))
    ]
  )


]
