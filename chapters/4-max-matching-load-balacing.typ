#import "../imports.typ": *

== Problema del Max-Matching

Chiamato anche problema dei matrimoni.

#informalmente[
 Dato un grafo non orientato dove: 
 - *Vertici*: Rappresentato delle persone
 - *Lati*: Relazione di piacimento (supponiamo sia sempre corrisposto)

 In base alle relazioni di piacimento, vogliamo trovare il maggior numero di coppie da far sposare (sono ammesse solo relazioni monogame). 
]

Formalmente, possiamo definire il problema Max-Matching come segue: 
- *$I_Pi$* = Grafo non orientato *$G(V,E)$*
- *$"Sol"_("amm")$* = *$ M subset.eq E "t.c" forall x in V "al massimo un lato di" M "è incidente su" x$*. Ovvero un sottoinsieme di lati tale che ogni vertice partecia al massimo ad una coppia. 
- *$C_Pi$* = $|M|$, numero di coppie.
- *$t_Pi = max$* 

#attenzione[
  La soluzione presentata è *valida solo per grafi bipartiti*. Ovvero grafi in cui esistono solamente due tipi di vertici che si possono solamente relazionare con il tipo opposto (uomini $<->$ donne). Questa variante prende il nome di *Max Bi-Matching*.
]

#teorema("Teorema")[
  *$"Max Matching" in "PO"$*
]

Inoltre saranno utili le seguenti definizioni: 
- *Lato libero* = non fa parte del Matching
- *Lato occupato* = fa parte del Matching
- *Vertice esposto* = se su di esso incidono solo lati liberi (persona non ancora sposata)

=== Cammino Aumentante

#informalmente[
  Un cammino aumentate è una *sequenza di vertici che alterna lati liberi e lati occupati dove il primo e l'ultimo vertice sono esposti*. 
]

In un cammino aumentante è sempre presente $1$ lato libero in più rispetto a quelli occupati. Di conseguenza effettuando un operazione di *switching* (i lati liberi diventano occupati e viceversa) *guadagniamo sempre un matrimonio*.

#teorema("Proprietà 1")[
  Data una soluzione ammissibile $M$, *se esiste un cammino aumentante allora la soluzione $M$ non è massima*, potremmo effettuare uno switch e guadagnare un matrimonio.
]

#teorema("Proprietà 2")[
  *Una soluzione ammissibile $M$ non è massima se esiste un cammino aumentante*. Un matching è massimo sse non c'è un cammino aumentante.
]

#dimostrazione()[
  Sia $M^'$ un matching più grande di $M$ t.c $|M^'| > |M|$

  Consideriamo la differenza simmetrica $Delta$:
  $ X = M Delta M^'
  = (M / M^') union (M' / M) $
  Ovvero $X$ contiene tutto ciò che non c'è in $M^' sect M$.
  #nota[
    Non è detto che $M^' subset M$, $M^'$ e $M$ possono essere differenti 
  ]

  #teorema("Osservazione 1")[
    *$X$ contiene più elementi di $M^'$ che di $M$*, in quanto abbiamo supposto che $|M^'| > |M|$.

  ]

  #let draw-point-with-label(x, y, label) = {
      place(dx: x, dy: y)[
        #circle(radius: 3.0pt, fill: black)
      ]
      place(dx: x, dy: y - 15pt)[
        #text(label)
      ]
  }


  #teorema("Osservazione 2")[
    *Ogni vertice ha al massimo $2$ lati di $X$ incidenti*, altrimenti non sarebbe un matching.

    Dato un vertice $v$ e due lati $l_1 in M/M^'$ e $l_2 in M^'/M$, possiamo trovarci nella seguente situazione: 

    #box(width: 100pt, height: 25pt)[
      #place(dx: 0pt, dy: 10pt)[
        #line(start: (100pt, 0pt), end: (200pt, 0pt), stroke: 1.5pt + black)
      ]

      #draw-point-with-label(100pt, 10pt, "")
      // Secondo punto (al centro) con etichetta "v"
      #draw-point-with-label(150pt, 10pt, "v")
      // Terzo punto (a destra)
      #draw-point-with-label(200pt, 10pt, "")
      // Etichetta L1 per il segmento di linea a sinistra
      #place(dx: 105pt, dy: 20pt)[
        #text($L_1 in M/M^'$)
      ]
      #place(dx: 155pt, dy: 20pt)[
        #text($L_2 in M^'/M$)
      ]
    ]

    \ Se $L_2 in M/M^'$ non sarebbe soddisfatta la condizione di matching, avrei una bigamia.  
  ]

  #teorema("Osservazione 3")[
    Una conseguenza dell'osservazione 2 e che *guardando solo i lati di $X$, i vertici possono avere solo grado $0,1,2$*.

    La situazione peggiore è quando ho un ciclo: 
    //TODO: fare disegno del ciclo di punti

    Tuttavia, *se sono presenti dei cicli sono costituiti da un numero pari di punti*: metà $in M^'/M$ e metà $in M/M^'$. 
  ]

  #teorema("Osservazione 4")[
    Per l'osservazione 1 è possibile affermare che all'interno del grafo *non vi sono solo cicli*. Dato che un ciclo brucia lo stesso numero di lati per $M$ e $M^'$ *ci deve essere almeno un cammino*, in quanto $|M^'| > |M|$. 
  ]
    
  #teorema("Osservazione 5")[
    Una conseguenza dell'osservazione 4 è che *ci deve essere almeno un cammino con più lati di $M^'/M$ rispetto ai lati di $M/M^'$*. Tale cammino deve iniziare e terminate con lati $in M^'/M$ (in quanto $|M^'|>|M|$), dove i vertici iniziale e finale devono essere esposti in $M$: 

    #box(width: 500pt, height: 40pt)[
      #place(dx: 0pt, dy: 10pt)[
        #line(start: (100pt, 0pt), end: (150pt, 0pt), stroke: 1.0pt + red)
        #line(start: (150pt, -12pt), end: (200pt, -12pt), stroke: 1.0pt + black)
        #line(start: (200pt, -24pt), end: (250pt, -25pt), stroke: 1.0pt + red)
        #line(start: (250pt, -38pt), end: (300pt, -38pt), stroke: 1.0pt + black)
        #line(start: (300pt, -50pt), end: (350pt, -50pt), stroke: 1.0pt + red)
      ]

      #draw-point-with-label(100pt, 10pt, "ini")
      #draw-point-with-label(150pt, 10pt, "")
      #draw-point-with-label(200pt, 10pt, "")
      #draw-point-with-label(250pt, 10pt, "")
      #draw-point-with-label(300pt, 10pt, "")
      #draw-point-with-label(350pt, 10pt, "fin")
 
      #place(dx: 105pt, dy: 20pt)[
        #text($L_1 in M^'/M$)
      ]
      #place(dx: 155pt, dy: 20pt)[
        #text($L_2 in M/M^'$)
      ]
      #place(dx: 210pt, dy: 20pt)[
        #text($L_3 in M^'/M$)
      ]
      #place(dx: 255pt, dy: 20pt)[
        #text($L_4 in M/M^'$)
      ]
      #place(dx: 300pt, dy: 20pt)[
        #text($L_5 in M^'/M$)
      ]
    ]

    Il cammino così descritto rispecchia esattamente *la definizione di cammino aumentante*.
  ]

]

=== Algoritmo Max Bi-Matching
#pseudocode(
  [input $<-$ $G=(V_1 union V_2, E)$],
  [$M <- emptyset$ #emph("Matching vuoto")],
  [*While* true],
  indent(
    [$Pi <- "FindAugmenting"(M)$],
    [#emph("Funzione che cerca un cammino aumentante")],
    [*If* $Pi = perp$ *then*],
    indent(
      [*Output*$(M)$],
      [#emph("Non ci sono più cammini aumentanti M è massimo")],
      [*Stop*]
    ),
    [*Else*],
    indent(
      [$M <- "Switch"(M, Pi)$],
      [#emph("Guadagno un matching in più")]
    ),
  ),
  [*End*]
)

==== Analisi della funzione FindAugmenting
La funzione FindAugmenting dato un certo matching $M$ cerca di trovare un cammino aumentante,
 utilizzando una *BFS Modificata*:
- La *visita parte* da un *vertice $v in V_1$ esposto* (o $v in V_2$)
- Dato un vertice $v$ vengono *visitati alternamente i lati adiacenti $in M$ e che $in.not M$*
- La *visita termina* quando viene *visitato un vertice $v in V_2$ esposto*. Significa che è stato trovato un cammino aumentante

#informalmente[
  La BFS modifica prova tutti i cammini alternati a partire da un vertice esposto.
]

#nota[
  *BFS* = Visita in ampiezza. Dato un vertice iniziale vengono aggiunti i vicini ad una coda. Man mano si visitano i nodi presenti nella coda elliminandoli da essa.  
]

*Complessità della funzione*: La *BFS* ha una complessità di *$O(m)$* (con $m$ numero di lati). Nel caso di una clique la complessità è $O((n/2)^2)$ (tutti i vertici connessi tra di loro)

==== Complessità Max-BiMatching

*Complessità dell'algoritmio*: Il matching $M$ più grande è al massimo il numero lati, *il ciclo for viene eseguito $O(n)$ volte*. Di conseguenza la *complessità totale è $O(n*m)$*, $O(n^3)$ nel caso di clique. 

== Problema del Perfect Matching

Si tratta di un *problema di decisone*.

#informalmente[
  Dato un grafo vogliamo determinare se esiste un matching che coinvolge tutti i vertici (non ci possono essere single).
]

#teorema("Crollario")[
  *Perfect Matching $in P$*\
  *Basta utilizzare il problema di Max-Matching* $in "PO"$ e verificare se $|M| = "numero di vertici"$.
]

== Problema di load balancing online

#informalmente[
  Dato un numero di macchine fissato e un numero di task (di durata nota), vogliamo andare ad assegnare i task alle macchine, in modo tale che *il tempo impiegato dalla macchina più carica sia il minore possibile*. \
  Vogliamo dunque evitare di avere macchine in uno stato di idle prolungato. \
  Inoltre la *versione dell'algoritmo presentata è online*, ovvero il numero di task non è noto a priori, possono essere inserite man mano. 
]
- Input:
  - *$m in bb(N)^+$*, numero di macchine
  - *$n in bb(N)^+$*, numero di task
  - *$t_0, t_1, ..., t_(n-1) in bb(N)^+$*, $t_i$ è la *durata dell'i-esimo task*
- $"Sol"_("amm")(x)$: *$underbrace((A_0, A_1, ..., A_(m-1)), "partizione") subset.eq underbrace(n,{0, dots, n-1}) $*, ovvero una partizione degli indici dei task nelle varie macchine
- *$C_(Pi)(x)$*: $ underbrace(L_i = sum_(j in A_i) t_j,"Carico della macchina i"), quad L = max_(i in m)(L_i) = "span della soluzione" $
$L$ è il carico della macchina con più lavoro. 
- *$t_Pi$*: $min$

#nota[
  *La soluzione ottima assegnerebbe ad ogni macchina lo stesso carico*:
  $ L = 1/m * sum_(i=0)^(n-1) t_i$  
]

//TODO: Fare il disegno forse
#esempio[
  $m = 3, n = 8, t = [3, 1, 3, 1, 1, 4, 5, 1]$

  - $"macchina" 0$: $[5, 1]$ = $6$ tempo
  - $"macchina" 1$: $[3, 3, 1]$ = $7$ tempo
  - $"macchina" 2$: $[1, 4, 1]$ = $6$ tempo
  $ L = 7 $
  Soluzione ottima (se le task fossero perfettamente divisibili): $ceil(19 / 3) = 7$, quindi questa soluzione (fatta intuitivamente) è quella ottima.
]

#teorema("Teorema")[
  *$"LoadBalancing" in "NPOc"$*
]

#pagebreak()

=== Greedy LoadBalancing [2-APX]

#pseudocode(
  [$A_i <- emptyset quad forall i in m$],
  [$L_i <- 0 quad forall i in m$],
  [*For* $j=0,1,2 dots, n-1$],
  indent(
    [$hat(i)<- underbrace("argmin",i in m) L_i$],
    [#emph($hat(i)$ + " " + "è l'indice della macchina più scarica")],
    [$A_hat(i)<-A_hat(i) union {j}$],
    [$L_hat(i)<-L_hat(i)+t_j$]
  ),
  [*End*],
)

#esempio[
  $m = 3, n = 8, t = [3, 1, 3, 1, 1, 4, 5, 1]$

  - $"macchina" 0$: $[3, 4]$ = $"tempo" 7$
  - $"macchina" 1$: $[1, 1, 1, 5]$ =  $"tempo" 8$
  - $"macchina" 2$: $[3, 1]$ = $"tempo" 4$
  $ L = 8 $

  La soluzione seguendo l'algorimto non è ottima
]

=== Complessità di Greedy LoadBalancing

L'algoritmo proposto è polinomiale: *$O(m log n)$*, utilizzando un heap