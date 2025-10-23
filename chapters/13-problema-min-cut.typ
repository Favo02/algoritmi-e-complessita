#import "../imports.typ": *

= Problema Min Cut (taglio minimo) [NPOc]

#informalmente[
  Il problema consiste nel dividere i vertici di un grafo in due insiemi disgiunti(non vuoti). L'obbiettivo è minimizzare i lati da "tagliare" per ottenere la divisione.

  #esempio([
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Vertici del grafo
      circle((0, 1), radius: 0.15, fill: white, stroke: black)
      content((-0.4, 1), text(size: 10pt)[$1$])

      circle((2, 1), radius: 0.15, fill: white, stroke: black)
      content((2.4, 1), text(size: 10pt)[$2$])

      circle((-1, -1), radius: 0.15, fill: white, stroke: black)
      content((-1.4, -1), text(size: 10pt)[$3$])

      circle((3, -1), radius: 0.15, fill: white, stroke: black)
      content((3.4, -1), text(size: 10pt)[$4$])

      circle((1, -2.5), radius: 0.15, fill: white, stroke: black)
      content((1, -3), text(size: 10pt)[$5$])

      // Archi normali (neri spessi)
      line((0.1, 0.9), (1.9, 0.9), stroke: 2pt + black)         // 1-2
      line((0.1, 0.85), (-0.9, -0.85), stroke: 2pt + red)     // 1-3
      line((1.9, 0.85), (2.9, -0.85), stroke: 2pt + black)      // 2-4
      line((-0.85, -1.1), (0.85, -2.4), stroke: 2pt + black)    // 3-5
      line((2.85, -1.1), (1.15, -2.4), stroke: 2pt + red)     // 4-5

      // Archi del taglio (attraversano la linea blu tratteggiata)
      line((0.1, 0.8), (2.9, -0.8), stroke: 2pt + black)        // 1-4
      line((1.9, 0.8), (-0.9, -0.8), stroke: 2pt + red)       // 2-3
      // Linea tratteggiata blu per indicare il taglio (diagonale)
      line((-1.5, 0.5), (3.5, -2), stroke: (paint: blue, thickness: 2pt, dash: "dashed"))
      
    }),
    caption: [
      Esempio di taglio. La linea $mb("blu")$ separa i vertici in due insiemi, gli archi in $mr("rosso")$ costituiscono il taglio.
    ]
    )
  ])
]

Formalizzazione del problema: 
- *$I_Pi$*: $G = (V,E)$ grafo non orientato

- *$"Amm"_Pi$*: insieme di vertici che non comprende tutti i vertici e diverso dall'insieme vuoto 
$ S subset.eq V, quad emptyset != S != V $

- *$C_Pi$*: il numero dei lati che rientrano nel taglio, ovvero i lati con un estremità $in S$ e l'altra $in.not S$
$ | E_S |, quad E_S = {e in E "t.c." e inter S != emptyset, quad e inter S^c != emptyset } $

- *$t_pi$* = $min$

#teorema("Proprietà")[
  Il taglio minimo ha dimensione $<=$ del vertice $v$ con grado $d$ minimo del grafo.

  #esempio([
  Il taglio può anche essere più piccolo.  
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Prima clique (sinistra) - sfondo ovale
  
      content((-2, 0), text(size: 12pt, weight: "bold")[Clique 1])

      // Vertici della prima clique
      circle((-2.8, 0.3), radius: 0.08, fill: black, stroke: black)
      circle((-2.8, -0.3), radius: 0.08, fill: black, stroke: black)
      circle((-1.2, 0.3), radius: 0.08, fill: black, stroke: black)
      circle((-1.2, -0.3), radius: 0.08, fill: black, stroke: black)
      circle((-2, 0.5), radius: 0.08, fill: black, stroke: black)
      circle((-2, -0.5), radius: 0.08, fill: black, stroke: black)

      // Seconda clique (destra) - sfondo ovale
      content((2, 0), text(size: 12pt, weight: "bold")[Clique 2])

      // Vertici della seconda clique
      circle((2.8, 0.3), radius: 0.08, fill: black, stroke: black)
      circle((2.8, -0.3), radius: 0.08, fill: black, stroke: black)
      circle((1.2, 0.3), radius: 0.08, fill: black, stroke: black)
      circle((1.2, -0.3), radius: 0.08, fill: black, stroke: black)
      circle((2, 0.5), radius: 0.08, fill: black, stroke: black)
      circle((2, -0.5), radius: 0.08, fill: black, stroke: black)

      // Bridge che collega le due clique (arco rosso spesso)
      line((-0.8, 0), (0.8, 0), stroke: 3pt + red)
      content((0, 0.4), text(size: 11pt, fill: red, weight: "bold")[Bridge])
    }),
    caption: [
      il taglio minimo è rappresentato dal taglio del $mr("bridge")$
    ]
  )
])
  #dimostrazione[
    Basta tagliare tutti gli archi del vertice $v$ di grado $d$ minimo, isolando di conseguenza il vertice $v$.
  ]
]<taglio-minimo-grado>

== Contrazione di un Lato

*Contrarre* un grafo $G$ su un lato $e$, indicato con *$G arrow.b e$*, significa togliere il lato $e$ dal grafo condensando in un unico vertice gli estremi del lato $e$.

#esempio([
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== GRAFO ORIGINALE (sinistra) =====
      content((-4, 3.0), text(size: 11pt, weight: "bold")[Grafo originale $G$])
      
      // Vertici grafo originale
      circle((-6, 1), radius: 0.12, fill: white, stroke: black)
      content((-6.4, 1), text(size: 10pt)[$A$])

      circle((-4.5, 1), radius: 0.12, fill: white, stroke: black)
      content((-4.5, 1.4), text(size: 10pt)[$U$])

      circle((-3, 1), radius: 0.12, fill: white, stroke: black)
      content((-3, 1.4), text(size: 10pt)[$V$])

      circle((-3.75, 1.8), radius: 0.12, fill: white, stroke: black)
      content((-3.75, 2.2), text(size: 10pt)[$D$])

      circle((-2.2, 0.3), radius: 0.12, fill: white, stroke: black)
      content((-2.2, 0.7), text(size: 10pt)[$B$])

      circle((-1.5, -0.5), radius: 0.12, fill: white, stroke: black)
      content((-1.5, -0.9), text(size: 10pt)[$C$])

      // Archi grafo originale
      line((-5.88, 1), (-4.62, 1), stroke: 2pt + black)          // A-U
      line((-4.38, 1), (-3.12, 1), stroke: 3pt + red)            // U-V (da contrarre)
      line((-4.4, 1.1), (-3.85, 1.7), stroke: 2pt + black)       // U-D
      line((-3.65, 1.7), (-3.1, 1.1), stroke: 2pt + black)       // D-V
      line((-2.9, 0.9), (-2.3, 0.4), stroke: 2pt + black)        // V-B
      line((-2.1, 0.2), (-1.6, -0.4), stroke: 2pt + black)       // B-C

      content((-3.75, 0.5), text(size: 9pt, fill: red)[Lato da contrarre])
      content((-3.75, 0.1), text(size: 9pt, fill: red)[$e = (U,V)$])

      // ===== FRECCIA DI TRASFORMAZIONE =====
      line((-0.8, 1), (0.8, 1), stroke: 2pt + black)
      line((0.6, 1.2), (0.8, 1), stroke: 2pt + black)
      line((0.6, 0.8), (0.8, 1), stroke: 2pt + black)
      content((0, 1.5), text(size: 10pt)[$G ↓ e$])

      // ===== GRAFO CONTRATTO (destra) =====
      content((4, 3.0), text(size: 11pt, weight: "bold")[Grafo contratto $G ↓ e$])

      // Vertici grafo contratto
      circle((2, 1), radius: 0.12, fill: white, stroke: black)
      content((1.6, 1), text(size: 10pt)[$A$])

      circle((3.75, 1), radius: 0.12, fill: white, stroke: black)
      content((3.75, 0.5), text(size: 10pt)[$U ∪ V$])

      circle((3.75, 1.8), radius: 0.12, fill: white, stroke: black)
      content((3.75, 2.2), text(size: 10pt)[$D$])

      circle((5.3, 0.3), radius: 0.12, fill: white, stroke: black)
      content((5.3, 0.7), text(size: 10pt)[$B$])

      circle((6, -0.5), radius: 0.12, fill: white, stroke: black)
      content((6, -0.9), text(size: 10pt)[$C$])

      // Archi grafo contratto
      line((2.12, 1), (3.63, 1), stroke: 2pt + black)            // A-(U∪V)
      line((3.75, 1.68), (3.75, 1.12), stroke: 2pt + black)      // D-(U∪V)
      line((3.85, 0.9), (5.2, 0.4), stroke: 2pt + black)         // (U∪V)-B
      line((5.2, 0.2), (5.9, -0.4), stroke: 2pt + black)         // B-C

      // Self-loop per archi multipli D-(U∪V)
        line((3.75, 1.68), (3.5, 1.02), stroke: 2pt + black)     
    }),
    caption: [
      Esempio di contrazione del lato $mr(e = {U,V})$. Nel grafo contratto, i vertici $U$ e $V$ vengono uniti in un unico vertice $U ∪ V$, preservando tutti i collegamenti. Il self-loop rappresenta gli archi multipli che si creano dalla contrazione.
    ]
  )
])

#nota[
  é possibile che una contrazione possa generare dei *multigrafi*. Questo evento avviene quando esiste un vertice connesso ad entrambe le estremità del lato che stiamo contraendo.
]

== Algoritmo di Karger

#pseudocode(
  [*If* $G$ non è connesso],
  indent(
    [emphetti una qualunque componente connessa],
    [*Stop*]
  ),
  [*While* $|V|>2$],
  indent(
    [$e<- "lato random di" G$ #emph("// scelta non deterministica")],
    [$G <- G arrow.b e$]
  ),
  [*Output* la classe di equivalenza di una delle due estremità]
)

#nota[
  Ad ogni contrazione, i due vertici compressi si uniscono nella stessa classe di equivalenza.\
  Dato che ci fermiamo ad esattamente due nodi rimanenti, allora avremo due classi di equivalenza.
]

#attenzione()[
  L'algoritmo produce l'ottimo con una certa probabilità.\
  Tuttavia se l'algoritmo non trova la *soluzione* ottima, *non sappiamo* di quanto essa è *distante dall'ottimo*.
]

=== Correttezza dell'algoritmo
Sia:
- *$S^*$* la scelta di vertici che da luogo al taglio più piccolo possibile
- *$k^*$* la dimensione del taglio minimo:
  $ k^* = |E_(S^*)| "dove" E_(S^*) = {e | e inter S^* != emptyset, e inter S^*^C != emptyset }  $
- *$G_i$* il grafo prima dell'$i-"esima"$ contrazione ($G_1, G_2, ...$)

#teorema("Osservazione")[
  Il numero di nodi del del grafo $G_i$ è:
  $ |V_{G_i}| = n_G_i = n-i+1 $

  #dimostrazione[
    Ad ogni cotnrazione uniamo due nodi, il numero di nodi viene ridotto di $1$ ad ogni iterazione $qed$.
  ]
]

#teorema("Osservazione")[
  Ogni taglio di $G_i$ corrisponde ad un taglio di $G$ della stessa dimensione $==>$ grado minimo di $G_i >= k^*$

  #dimostrazione[
    Sia $C_i$ il taglio minimo per $G_i$ e $d(G_i)$ il vertice con il grado minimo. Per #link-teorema(<taglio-minimo-grado>): 
    $ C_i <= min d(G_i) $
    Siccome ogni taglio di $G_i$ è anche un taglio di $G$, i tagli minimi coincidono:  
    $ 
      C &<= G_i \
      G_i &>= C = k^* quad qed
    $
  ]
]

#teorema("Osservazione")[
  Sommiamo i gradi di $G_i$
  $
    mr(sum_(v in V_G_i) d_(G_i)(v)) >= k^* (n-i+1) \
    mr(2 m_G_i) >= k^* (n-i+1) \
    m_G_i >= (k^* (n-i+1))/2
  $

  #dimostrazione[
    Sommando il grado di ogni vertice, stiamo praticamnete contanto ogni lato due volte (roba in rosso).

    Per il >= sfruttate le scorse due proprietà.
  ]
]

Sia $xi_i$ l'evento all'$i$-esima contrazione non si è contratto un lato di $E_S^*$.

#informalmente[
  $xi_i$: non abbiamo tagliato nessun lato che andava preservato, ci è andata bene col lato casuale.
]

#teorema("Lemma")[
  Probabilità che non tagliamo un lato che ci serve all'$i$-esima iterazione, posto che non lo abbiamo fatto prima:
  $ P[xi_i | xi_1, ..., xi_(i-1)] >= (n-i-1)/(n-i+1) $

  #dimostrazione[
    $
      P[xi_i | xi_1, ..., xi_(i-1)] & = 1- P[not xi_i | xi_1, ..., xi_(i-1)] \
                                    & = 1 - (k^*)/m_G_i
    $
    $k^*$: casi favorevoli
    $m_G_i$: casi possibilie

    Per osservazione 3:
    $
      >= 1 - (k^* 2)/(k^*(n-i+1)) \
      = (n-i+1-2)/(n-i+1) \
      = (n-i-1)/(n-i+1) space qed
    $
  ]
]

#teorema("Teorema")[
  L'algoritmo di Karger trova il taglio minimo con probabbilità $>= 1/binom(n, 2)$.

  #dimostrazione[
    Vogliamo dimostrare:
    $ P[xi_1 inter x_2 inter ... inter xi_(n-2)] $

    Attraverso la regola della catena (=) e usando il Lemma1 (>=):
    $
      & = P[xi_1] dot P[xi_2 | xi_1] dot P[xi_3 | xi_1, xi_2] \
      & >= (n-2)/n dot (n-3)/(n-1) dot ... dot 1/3 \
      & = (limits(product)_(i=1)^(n-2)i)/(limits(product)_(i=3)^n i) \
      & = (1dot 2)/(n ( n-1)) = 1/binom(n, 2) space qed
    $
  ]
]

#attenzione[
  Questa proprietà è molto piccola, quindi non molto buona.

  Possiamo però iterare questo algoritmo, in modo da far crescere la probabilitò.
  Tra tutte le iterazioni prendiamo quella migliore (minima).
]

#teorema("Corollario")[
  Eseguendo Karger $binom(n, 2) ln n$ volte, otteniamo il taglio minimo con probabilità $>= 1 - 1/n$.

  #dimostrazione[
    Ogni volta, la probabilità di NON trovare l'ottimo è
    $ <= 1 - 1/binom(n, 2) $

    Quindi, eseguendo l'algoritmo $binom(n, 2) ln n$ volte, diventa:
    $ <= (1 - 1/binom(n, 2))^(binom(n, 2) ln n) $

    Dato che sempre vale la proprietà:
    $ forall x >= 1, quad 1/4 <= (1-1/x)^x <= 1/e $

    Allora:
    $ <= (1 - 1/binom(n, 2))^(binom(n, 2) ln n) $
  ]
]

#informalmente[
  Perchè abbiamo eseguito l'algoritmo quel numero di volte?

  Perchè così abbiamo una funzione di probabilità che tende a $1$ per $n -> infinity$, quindi è quasi certo che trovi l'ottimo
]
