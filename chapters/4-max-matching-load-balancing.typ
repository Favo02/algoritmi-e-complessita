#import "../imports.typ": *

= Problema Max Matching [PO]

#informalmente[
  Chiamato anche problema dei matrimoni, dato un *grafo* non orientato dove:
  - *Vertici*: rappresentano delle persone
  - *Lati*: relazione di piacimento (supponiamo sia sempre corrisposto)

  Rispettando le relazioni di piacimento, vogliamo trovare il maggior numero di coppie da far sposare (sono ammesse solo relazioni monogame).

  #nota[
    Useremo termini non formali come _"coppia"_ che fanno riferimento a questa interpretazione del problema.
  ]
]

Formalmente, possiamo definire il problema Max Matching come segue:
- $I_Pi = G(V, E)$: grafo non orientato
- $"Sol"_("amm") = M subset.eq E$: un *matching*, ovvero un sottoinsieme di lati tale che ogni vertice è collegato ad al massimo un lato del matching _(ovvero un insieme di coppie sposate)_: $ forall x in V, "al massimo un lato di" M "è incidente su" x $
- $C_Pi = |M|$: numero di coppie
- $t_Pi = max$

Inoltre saranno utili le seguenti definizioni:
- Lato *libero*: non fa parte del Matching
- Lato *occupato*: fa parte del Matching
- Vertice *esposto*: se su di esso incidono solo lati liberi _(persona non ancora sposata)_

#teorema("Teorema")[
  *$"Max Matching" in "PO"$*
]

== Variante Max Bi-Matching

#attenzione[
  La soluzione presentata è valida solo per *grafi bipartiti* $G(V_1 union V_2, E)$.
  Ovvero grafi in cui esistono due tipi di vertici che si possono relazionare solamente con il tipo opposto _(uomini e donne, tutte relazioni etero)_.
  Questa variante prende il nome di *Max Bi-Matching*.

  #nota[
    Prendiamo in considerazione questa variante per semplicità, anche il problema Max Matching senza questa restrizione fa parte della classe PO.
  ]
]

/ Cammino aumentante: sequenza di lati che alterna *lati liberi* e *lati occupati* dove il primo e l'ultimo vertice sono *esposti*. Dato che il primo e l'ultimo vertice sono esposti, allora è sempre presente $1$ lato libero in più rispetto a quelli occupati.

/ Switch: inversione dei lati liberi e occupati all'interno di un cammino aumentante. Questa operazione fa sempre *guadagnare* un lato al matching (dato che i lati liberi erano più di quelli occupati).

#teorema("Proprietà 1")[
  Data una soluzione ammissibile $M$, se *esiste un cammino aumentante* allora la soluzione $M$ non è massima: potremmo effettuare uno switch e guadagnare un matrimonio.
]

#teorema("Proprietà 2")[
  Se il matching $M$ non è massimo (quindi *non* è la soluzione *ottima*), allora *esiste* un cammino aumentante.
  E viceversa, se $M$ è la soluzione ottima, allora non esiste un cammino aumentante.

  #dimostrazione[
    Sia $M'$ un matching più grande di $M$: $|M'| > |M|$

    #attenzione[
      Non è detto che $M^' subset M$, $M^'$ e $M$ possono essere differenti
    ]

    Consideriamo la differenza simmetrica $Delta$, ovvero i lati che non sono in nessuno dei due matching:
    $ X = M space Delta space M^' = (M \\ M^') union (M' \\ M) = (M union M') \\ (M inter M') $

    #figure(
      cetz.canvas({
        import cetz-venn: *
        import cetz.draw: *

        venn2(name: "venn", a-fill: blue.transparentize(50%), b-fill: blue.transparentize(50%))
        content("venn.a", [$M$])
        content("venn.b", [$M'$])
      }),
      caption: [Differenza simmetrica $X = M space Delta space M'$],
    )

    #teorema("Osservazione 1")[
      $X$ contiene più elementi $in M'$ che $in M$, in quanto abbiamo supposto che $|M^'| > |M|$.
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
      Ogni vertice ha al *massimo* $2$ lati di $X$ *incidenti*, altrimenti non sarebbero matching.

      Dato un vertice $v$ e due lati $l_1 in M\\M^'$ e $l_2 in M^'\\M$, possiamo trovarci nella seguente situazione:

      #align(center)[
        #cetz.canvas({
          import cetz.draw: *

          // Draw three points
          circle((0, 0), radius: 0.08, fill: black)
          circle((2, 0), radius: 0.08, fill: black)
          circle((4, 0), radius: 0.08, fill: black)

          // Draw lines between points
          line((0, 0), (2, 0), stroke: 2pt + red)
          line((2, 0), (4, 0), stroke: 2pt + blue)

          // Add vertex label
          content((2, -0.5), [$v$])

          // Add line labels
          content((0.7, 0.4), [$l_1 in M\\M'$], fill: white)
          content((3.3, 0.4), [$l_2 in M'\\M$], fill: white)
        })
      ]

      Ogni singolo matching $M$ e $M'$ può avere un solo lato connesso al vertice $v$ e quelli in comune sono stati scartati, di conseguenza ogni vertice ha $0, 1$ lati di $M$ e $0, 1$ lati di $M'$, quindi al massimo $2$ lati incidenti.
    ]

    #teorema("Osservazione 3")[
      Conseguenza dell'osservazione 2: nel grafo ristretto a $X$, i vertici possono avere solo *grado* $0,1,2$.

      Quindi ogni vertice:
      - è isolato (grado 0)
      - è l'estremo di un cammino (grado 1)
      - è all'interno di un cammino o ciclo (grado 2)
      // TODO: disegno
    ]

    #teorema("Osservazione 4")[
      I vertici isolati possono essere ignorati (dato che ovviamente non intaccano i lati).

      Ogni ciclo deve essere formato da un numero *pari* di lati, altrimenti ci sarebbero due lati *consecutivi* appartenenti allo stesso matching, assurdo. In ogni ciclo ci sono lo stesso numero di lati $in M \\ M'$ e $in M' \\ M$.

      #align(center)[
        #cetz.canvas({
          import cetz.draw: *

          // Draw cycle with 6 vertices
          let points = (
            (0, 2),
            (1.732, 1),
            (1.732, -1),
            (0, -2),
            (-1.732, -1),
            (-1.732, 1),
          )

          // Draw vertices
          for pt in points {
            circle(pt, radius: 0.08, fill: black)
          }

          // Draw alternating edges forming a cycle
          line((0, 2), (1.732, 1), stroke: 2pt + red)
          line((1.732, 1), (1.732, -1), stroke: 2pt + blue)
          line((1.732, -1), (0, -2), stroke: 2pt + red)
          line((0, -2), (-1.732, -1), stroke: 2pt + blue)
          line((-1.732, -1), (-1.732, 1), stroke: 2pt + red)
          line((-1.732, 1), (0, 2), stroke: 2pt + blue)

          // Add labels with better positioning to avoid overlaps
          content((2, 1.6), [$l_1 in M'\\M$], fill: white)
          content((2.5, 0), [$l_2 in M\\M'$], fill: white)
          content((2, -1.6), [$l_3 in M'\\M$], fill: white)
          content((-2, -1.6), [$l_4 in M\\M'$], fill: white)
          content((-2.5, 0), [$l_5 in M'\\M$], fill: white)
          content((-2, 1.6), [$l_6 in M\\M'$], fill: white)
        })
      ]

      Di conseguenza devono esistere dei *cammini di dimensione dispari*, altrimenti sarebbe impossibile soddisfare $|M^'| > |M|$.
    ]

    #teorema("Osservazione 5")[
      Conseguenza dell'osservazione 4: ci deve essere almeno un *cammino con più lati* di $M' \\ M$ rispetto ai lati di $M \\ M'$.
      Tale cammino deve iniziare e terminate con lati $in M'\\M$ (in quanto $|M'|>|M|$), dove i vertici iniziale e finale devono essere *esposti* in $M$:

      #align(center)[
        #cetz.canvas({
          import cetz.draw: *

          // Draw points (vertices)
          let points = ((0, 0), (2, 0), (4, 0), (6, 0), (8, 0), (10, 0))
          for (i, pt) in points.enumerate() {
            circle(pt, radius: 0.08, fill: black)
          }

          // Draw alternating edges
          line((0, 0), (2, 0), stroke: 2pt + red)
          line((2, 0), (4, 0), stroke: 2pt + blue)
          line((4, 0), (6, 0), stroke: 2pt + red)
          line((6, 0), (8, 0), stroke: 2pt + blue)
          line((8, 0), (10, 0), stroke: 2pt + red)

          // Add edge labels
          content((1, 0.5), [$l_1 in M'\\M$], fill: white)
          content((3, -0.5), [$l_2 in M\\M'$], fill: white)
          content((5, 0.5), [$l_3 in M'\\M$], fill: white)
          content((7, -0.5), [$l_4 in M\\M'$], fill: white)
          content((9, 0.5), [$l_5 in M'\\M$], fill: white)
        })
      ]

      Il cammino così descritto rispecchia esattamente la definizione di *cammino aumentante* $qed$.
    ]
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
      [*Stop*],
    ),
    [*Else*],
    indent(
      [$M <- "Switch"(M, Pi)$],
      [#emph("Guadagno un matching in più")],
    ),
  ),
  [*End*],
)

==== Analisi della funzione FindAugmenting
La funzione FindAugmenting dato un certo matching $M$ cerca di trovare un cammino aumentante, utilizzando una *BFS Modificata*:
- La *visita parte* da un *vertice $v in V_1$ esposto* (o $v in V_2$)
- Dato un vertice $v$ vengono *visitati alternamente i lati adiacenti $in M$ e che $in.not M$*
- La *visita termina* quando viene *visitato un vertice $v in V_2$ esposto*. Significa che è stato trovato un cammino aumentante

#informalmente[
  La BFS modifica prova tutti i cammini alternati a partire da un vertice esposto.
]

#nota[
  *BFS* = Visita in ampiezza. Dato un vertice iniziale vengono aggiunti i vicini ad una coda. Man mano si visitano i nodi presenti nella coda eliminandoli da essa.
]

*Complessità della funzione*: La *BFS* ha una complessità di *$O(m)$* (con $m$ numero di lati). Nel caso di una clique la complessità è $O((n/2)^2)$ (tutti i vertici connessi tra di loro)

==== Complessità Max-BiMatching

*Complessità dell'algoritmo*: Il matching $M$ più grande è al massimo il numero lati, *il ciclo for viene eseguito $O(n)$ volte*. Di conseguenza la *complessità totale è $O(n*m)$*, $O(n^3)$ nel caso di clique.

== Problema del Perfect Matching

Si tratta di un *problema di decisone*.

#informalmente[
  Dato un grafo vogliamo determinare se esiste un matching che coinvolge tutti i vertici (non ci possono essere single).
]

#teorema("Crollario")[
  *Perfect Matching $in P$*\
  *Basta utilizzare il problema di Max-Matching* $in "PO"$ e verificare se $|M| = "numero di vertici"$.
]

= Problema di load balancing online

#informalmente[
  Dato un numero di macchine fissato e un numero di task (di durata nota), vogliamo andare ad assegnare i task alle macchine, in modo tale che *il tempo impiegato dalla macchina più carica sia il minore possibile*. \
  Vogliamo dunque evitare di avere macchine in uno stato di idle prolungato. \
  Inoltre la *versione dell'algoritmo presentata è online*, ovvero il numero di task non è noto a priori, possono essere inserite man mano.
]
- Input:
  - *$m in bb(N)^+$*, numero di macchine
  - *$n in bb(N)^+$*, numero di task
  - *$t_0, t_1, ..., t_(n-1) in bb(N)^+$*, $t_i$ è la *durata dell'i-esimo task*
- $"Sol"_("amm")(x)$: *$underbrace((A_0, A_1, ..., A_(m-1)), "partizione") subset.eq underbrace(n, {0, dots, n-1})$*, ovvero una partizione degli indici dei task nelle varie macchine
- *$C_(Pi)(x)$*: $ underbrace(L_i = sum_(j in A_i) t_j, "Carico della macchina i"), quad L = max_(i in m)(L_i) = "span della soluzione" $
$L$ è il carico della macchina con più lavoro.
- *$t_Pi$*: $min$

#nota[
  *La soluzione ottima assegnerebbe ad ogni macchina lo stesso carico*:
  $L = 1/m * sum_(i=0)^(n-1) t_i$
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
    [$hat(i)<- underbrace("argmin", i in m) L_i$],
    [#emph($hat(i)$ + " " + "è l'indice della macchina più scarica")],
    [$A_hat(i)<-A_hat(i) union {j}$],
    [$L_hat(i)<-L_hat(i)+t_j$],
  ),
  [*End*],
)

#esempio[
  $m = 3, n = 8, t = [3, 1, 3, 1, 1, 4, 5, 1]$

  - $"macchina" 0$: $[3, 4]$ = $"tempo" 7$
  - $"macchina" 1$: $[1, 1, 1, 5]$ =  $"tempo" 8$
  - $"macchina" 2$: $[3, 1]$ = $"tempo" 4$
  $ L = 8 $

  La soluzione seguendo l'algoritmo non è ottima
]

=== Complessità di Greedy LoadBalancing

L'algoritmo proposto è polinomiale: *$O(m log n)$*, utilizzando un heap

=== Greedy LoadBalancing *$in 2-"APX"$*

#teorema("Teorema")[
  *Greedy LoadBalancing è un algoritmo $2$-Approssimanto*
]

#dimostrazione()[
  #teorema("Osservazione 1")[
    $ L^*>=1/m sum_(j in n)t_j $
    Lo span (soluzione ottima) è almeno la media tra i task / il numero di macchine. In questo modo nessuna macchina sarà mai scarica -> basso periodo di inattività.
  ]
  #dimostrazione()[
    Se sommo i carici di ogni macchina, ottengo la somma di tutti i task:
    *$ sum_(i in m) L_i^* = sum_(j in n) t_j $*
    Applicando il principio di *pidgeon holding*, almeno una macchina $i$ avrà un carico $L_i^* >= 1/m sum_(i in n) t_j$, di conseguenza la soluzione ottima:
    *$ L^* = underbracket(max, i in n) L_i^* >= 1/m sum_(j in n) t_j $*

    #informalmente[
      Il *principio di pidgeon holding* (o anche detto problema delle camicie e cassetti) afferma che se ci sono $7$ camicie e $5$ cassetti, almeno un cassetto contiene $2$ camicie.
    ]
  ]

  #teorema("Osservazione 2")[
    *$ L^*>= underparen(max, j in n) t_j $*
    La dimostrazione è ovvia: il task più lungo deve per forza essere assegnato ad una macchina.
  ]

  Supponiamo di eseguire ora l'algorimto Greedy LoadBalancing. L'output è una *soluzione $L$* (non ottima):
  *$ L = max L_hat(i), hat(i) "macchina più carica" $*
  Consideriamo ora *l'ultimo task assegnato $t_hat(j)$* alla macchina $hat(i)$.\
  Cosa Rappresentata *$L_hat(i) - t_hat(j)$* ? é il carico che aveva la macchina più scarica $hat(i)$ prima dell'assegnazione del carico $t_hat(j)$:
  *$ L_hat(i) - t_hat(j) <= L_i^' <= L_i forall i in m $*

  Dove $L^'$ è il carico delle altra macchine all'assegnamento del task $t_hat(j)$ (più cariche di $L_hat(i)-t_hat(j)$).\
  Moltiplichiamo per $m$:

  *$ m(L_hat(i)-t_hat(j)) <= sum_(i in m) L_i = sum_(j in n) t_j $*

  Dividendo per $m$:

  *$ L_hat(i)-t_hat(j) <= 1/m sum_(j in n)t_j <= underbrace(L^*, "oss 1") $*

  Possiamo riscrivere la soluzone trovata $L$ (non ottima) come:
  *$ L = underbrace(L_hat(i), max L_i) = underbrace(L_hat(i) - t_hat(j), <= L^*) + underbrace(t_hat(j), <= L^*) <= 2L^* $*
  Di conseguenza considerando il rapporto di approsimazione:
  *$ L/L^* <= 2 $*

  #informalmente()[
    La dimostrazione utilizza i seguenti concetti:
    - La dimostrazione utilizza proprietà dell'ottimo, ma senza sapere come questo ottimo viene costruito. Le osservazioni fatte valgono per una qualunque soluzione, al posto di $L^*$ si poteva usare $forall L$.
    - Ragionando sull'algoritmo:
      - Cosa rende l'algoritmo pessimo?
        - l'assegnazione dell'ultimo task
        - cosa succede quando si assegna l'ultimo task?
  ]
]

A questo punto potremo chiederci se la dimostrazione proposta è la "migliore possibile".

#informalmente[
  Ci stiamo chiedendo se la dimostrazione proposta in precedenza è precisa oppure è lasca. Ci sono due alternative:
  - Si trova un caso in cui la soluzione prodotta dall'algorimto è $2$ volte l'ottimo
  - Si migliora la dimostazione ($1.8$-APX ad esempio).
]

#teorema("Teorema")[
  $forall epsilon > 0, exists x in I_Pi$ su cui Greedy LoadBalancing produce una soluzione:
  *$ L-epsilon <= L / L^* <= 2 $*

  #informalmente[
    Gli input occupano tutto lo spazio delle soluzioni:
    - alcuni vanno bene e producono una soluzione $L-epsilon$
    - altri vanno male e producono una $2$-approsimazione
  ]
]

#dimostrazione()[
  Dati:
  - *$m$* un intero *$m > 1/epsilon$* *numero macchine*
  - *$n = m(m - 1) + 1$* numero task
  - *$t_0, ... t_(n-2) = 1$* tutti i task tranne l'ultimo, *$m(m-1)$* task
  - *$t_(n-1) = m$* l'ultimo task

  Come si comporta l'algoritmo:
  - assegnaimo i task da 1 alla prima macchina libera
  - assegnaimo il carico da $1$ ad ogni macchina
  - ripetiamo questa cosa  $m-1$ volte, quindi ogni macchina ha $m-1$ tempo
  - arriva l'ultimo task, la assegnaimo alla prima macchina, che ha $m-1 + m$ tempo

  #informalmente[
    L'algoritmo non sa che arriva la task grande, quindi distribuisce equalmente quelli da 1. Se lo sapesse lascerebbe una macchina vuota e gli assegnerebbe alla fine $m$. In questo csao tutte le macchine arriverebbero alla fine con carico $m$ (le prime $m-1$ con $m -1 + 1$ task da 1, l'ultima con solo il carico da $m$). Questa è la soluzione ottima dato che è la media.
  ]

  $ L/L^* = (2 m -1) / m = 2 - 1/m >= 2-epsilon space qed $

  #informalmente[
    Questa dimostrazione ci ha anche mostrato i punti deboli dell'algorimto.
  ]
]

== SortedGreedyLoadBalancing [3/2-APX]

- Input
- Ordina i task in modo decrescente
- Esegui GreedyLoadBalancing

Questo algoritmo è $O(n log n + n log m)$.

#attenzione[
  Questo algoritmo non è più online, ovvero serve sapere tutte le task prima di iniziare ad assegnare i task.
]

#teorema("Teorema")[
  $ "SortedGreedyLoadBalancing è" 3/2 "-approssimante" $

  #dimostrazione[
    / Caso 1: se ci sono meno task che macchine $n <= m$, funziona esattamente uguale a greedyloadbalancing (senza sorting): assegna ad ogni macchina un task. Troviamo la soluzione ottima, il rapporto è $1$. Il carico finale è la lunghezza del carico più lungo, per osservazione fatta prima questo è l'ottimo. $qed$

    / Caso 2: $n > m$, ci sono più task che macchine.

    / Osservazione 1: $ L^* >= 2 t_m $ La soluzione ottima è almeno due volte il task di indice $m$.
    / Dimostrazione 1: $
        underbrace(t_0 >= t_1 >= ... >= t_m-1 >= t_m, "m+1 task") >= ... \
      $
      Per principio della piccionaia, almeno due task devono essere assegnati alla stessa macchina $i$.
      $ L^* >= L_i^* >= 2 t_m $


    Sia $hat(i)$ la macchina con carico massimo:
    - se ha avuto un solo assegnamento, allora questa è una soluzione ottima. Questo vuol dire che quello che fa questa soluzione è un solo task, quindi non possiamo fare di meglio. $qed$
    - se ha avuto più carichi $>= 2$. Sia $hat(j)$ l'ultimo compilto assegnato a $hat(i)$, già il secondo che le viene assegnato deve essere dopo il carico $m$, quindi deve essere maggiore del carico $m$:
      $
        hat(j) >= m \
        t_hat(j) <= t_m <= 1/2 L^* "per oss1" \
        L = L_hat(i) = ... <= 3/2 L^* \
        L / L^* <= 3/2 space qed
      $
  ]
]

#attenzione[
  Questa dimostrazione non è la migliore possibile. L'algorimto non arriverà mai a generare una soluzione $3/2$ volte più grande dell'ottimo.

  Esiste una dimostrazione di _Graham 1969_ che mostra che è una $4/3$-approssimazione
]

== LoadBancing in [PTAS]

Load Balancing sta in PTAS (dimostrata da _Hochbaum-Shmoys 1988_).

Se $P != N P$, LoadBalancing non può stare in FPTAS.

Quindi loadbalancing cresce in maniera esponenziale all'abbassarsi di $epsilon$.

#dimostrazione[
  Si sa in quanto il problema di decisione è fortemente NP-completo
]
