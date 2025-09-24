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
- *$C_Pi$* = $|M|$
- *$t_Pi = max$* 

#attenzione[
  La soluzione presentata è *valida solo per grafi bipartiti*. Ovvero grafi in cui esistono solamente due tipi di vertici che si possono solamente relazionare con il tipo opposto (uomini $<->$ donne). La versione che vedremo è più semplice e prende il nome di *Max Bi-Matching*,
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

  Effettuo la differenza simmetrica $Delta$:
  $ X = M Delta M^'
  = (M / M^') union (M' / M) $
  Ovvero $X$ contiene tutto ciò che non c'è in $M^' sect M$.
  #nota[
    Non è detto che $M^' subset M$, $M^'$ e $M$ possono essere differenti 
  ]

  #teorema("Osservazione 1")[
    *$X$ contiene più elementi di $M^'$ che di $M$*, in quanto abbiamo supposto che $|M^'| > M$.

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
    Come conseguenza dell'osservazione2, *se guardo solo i lati di $X$, i vertici hanno solo grado $0,1,2$*.

    La situazione peggiore è quando ho un ciclo: 
    //TODO: fare disegno del ciclo di punti

    Tuttavia, *se ci sono cicli sono fatti da un numero pari di punti*: metà $in M^'/M$ e metà $in M/M^'$. 
  ]

  #teorema("Osservazione 4")[
    Per l'osservazione1 è possibile affermare che *non ci sono solo cicli*. Dato che un ciclo brucia lo stesso numero di lati per $M$ e $M^'$ *ci deve essere almeno un cammino*, in quanto $|M^'| > |M|$. 
  ]
    
  #teorema("Osservazione 5")[
    Ci deve essere kkkkkkk
  ]




]



