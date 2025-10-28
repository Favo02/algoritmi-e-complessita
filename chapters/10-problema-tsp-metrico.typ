#import "../imports.typ": *

= Problema Travelling Salesman (Commesso Viaggiatore) Metrico (TSP Metrico)

#nota[
  Si rimanda alla sezione #link-section(<grafi>) per le definizioni necessarie (clique, cammino/circuito Hamiltoniano/Euleriano).
]

== Problema TSP [NPOc]

- *$I_Pi$*:
  - $G(V, E)$: grafo non orientato
  - $chevron.l delta_e chevron.r_(e in E) in bb(Q)^+$: pesi dei lati
- *$"Amm"_Pi$*: circuito Hamiltoniano $pi in G$ (tocca esattamente una volta ogni vertice del grafo), oppure $bot$ (se non esiste)
- *$C_Pi$*: peso del circuito Hamiltoniano:
  $ delta = sum_(e in pi) delta_e $
- *$t_Pi$* = $min$

#teorema("Teorema")[
  *$ "TSP" in "NPOc" $*
]

== Problema TSP Metrico [NPOc]

Vedremo una versione del problema che lavora in uno spazio metrico, aggiungendo dei vincoli sul grafo $G(V,E)$:
+ $G$ è una *clique*
+ $delta_e$ è una *metrica*, cioè vale la disuguaglianza triangolare $delta_{x,y} + delta_{y,z} >= delta_{x,z}$

#attenzione[
  Senza la seconda limitazione, sarebbe possibile trasformare qualsiasi grafo in una cricca: basterebbe aggiungere tutti i lati mancanti con un costo enorme, in modo che non vengano mai scelti dall'algoritmo.

  #esempio[
    #figure(
      cetz.canvas({
        import cetz.draw: *

        // Vertici del grafo
        circle((0, 0), radius: 0.15, fill: white, stroke: black)
        content((-0.5, 0), text(size: 10pt)[$v_1$])

        circle((2, 0), radius: 0.15, fill: white, stroke: black)
        content((2.5, 0), text(size: 10pt)[$v_2$])

        circle((1, 1.5), radius: 0.15, fill: white, stroke: black)
        content((1.5, 1.5), text(size: 10pt)[$v_3$])

        circle((1, -1.5), radius: 0.15, fill: white, stroke: black)
        content((1.5, -1.5), text(size: 10pt)[$v_4$])

        // Archi con prezzature corrette
        line((0, 0), (2, 0), stroke: 1pt + red)
        content((0.7, 0.25), text(size: 9pt, fill: red)[$17$])

        line((0, 0), (1, 1.5), stroke: 1pt + black)
        content((0.3, 0.8), text(size: 9pt, fill: black)[$4$])

        line((2, 0), (1, 1.5), stroke: 1pt + black)
        content((1.7, 0.8), text(size: 9pt, fill: black)[$1$])

        line((1, 1.4), (1.0, -1.4), stroke: 1pt + black)
        content((0.8, -0.5), text(size: 9pt, fill: black)[$5$])

        line((1, -1.5), (2.0, 0.0), stroke: 1pt + black)
        content((1.7, -0.8), text(size: 9pt, fill: black)[$6$])

        line((1, -1.5), (0.0, 0.0), stroke: 1pt + red)
        content((0.3, -1.0), text(size: 9pt, fill: red)[$17$])
      }),
      caption: [
        Gli archi di colore $mr("rosso")$ sono fittizzi, aggiunti al grafo originale (non clique) per renderlo cricca.\
        Il costo è calcolato come la somma di tutti gli archi $+1$.
      ],
    )
  ]
  L'algoritmo non li sceglierà mai, in quanto vuole trovare il circuito minimo. Se l'algoritmo scegliesse dei lati fittizi nella soluzione prodotta, allora il grafo di partenza non conteneva un circuito Hamiltoniano.
]

#teorema("Teorema")[
  *$ "TSP Metrico" in "NPOc" $*
]

== Algoritmo di Christofides per TSP metrico [$3/2$-APX]

#pseudocode(
  [*Input*: $G(V, E =binom(V, 2)), chevron.l delta_e chevron.r_(e in E)$],
  [$T <-$ #link(<tsp-minimum-spanning-tree>)[Minimum spanning tree#super[1]] su $G$],
  [$D <-$ insieme dei vertici di grado dispari in $T$ #emph("// " + $|D|$ + " è pari per " + link(<tsp-handshaking-lemma>)[handshaking lemma#super[2]])],
  [$M <-$ #link(<tsp-minimum-weight-perfect-matching>)[Minimum-weight perfect matching#super[3]] su $D$],
  [$tilde(pi) <-$ Circuito Euleriano su $M union T$ #emph("// la sua esistenza è garantita da " + link(<tsp-esistenza-circuito-euleriano>)[esistenza circuito Euleriano#super[4]])],
  [$pi <- tilde(pi)$, #link(<tsp-cortocircuitazione>)[Shortcircuit#super[5]] ],
)

L'algoritmo sfrutta le seguenti componenti:

- *Minimum Spanning Tree*#super[1]: <tsp-minimum-spanning-tree>
  dato un grafo pesato, uno spanning tree è una scelta di lati che forma un albero (quindi aciclico) e tocca tutti i vertici.
  Tra tutti gli spanning tree possibili, viene scelto quello di peso (somma degli archi) minimo.\
  Tale problema è risolvibile in tempo polinomiale ($in "PO"$) utilizzando l'#link("https://en.wikipedia.org/wiki/Kruskal's_algorithm")[algoritmo di _Kruskal_].

- *Handshaking Lemma*#super[2]: <tsp-handshaking-lemma>

  #informalmente[
    Se un gruppo di persone si stringono tra di loro (in maniera arbitraria) la mano, il numero di persone che ha stretto un numero dispari di mani è pari.

    Le persone sono rappresentate come i vertici e le strette di mano come i lati di un grafo.
  ]

  #teorema("Lemma")[
    In ogni grafo non orientato, il numero di vertici di grado dispari è pari.

    #dimostrazione[
      Dato un grafo $G=(V,E)$:
      $ sum_(x in V) d(x) & = 2m $
      dove $d(x), x in V$ è il grado di un vertice e $m$ è il numero di lati del grafo.

      Sommando il grado di ogni vertice del grafo, allora ogni lato viene contato $2$ volte (una per ognuna delle sue estremità), ottenendo $2m$.

      Dato che questo numero è pari, allora può essere scomposto in componenti pari e componenti dispari:
      - i vertici di grado *pari* possono essere ignorati, dato che la somma di una qualsiasi quantità di numeri pari rimane sempre pari
      - i vertici di grado *dispari* devono per forza essere in quantità pari, dato che solo sommando un numero pari di numeri dispari si ottiene un risultato pari
    ]
  ]

  #nota[
    Questo genere di risultati, ovvero inferire dei risultati (come pattern che si ripetono) partendo solo da una struttura di una determinata dimensione viene chiamata #link("https://en.wikipedia.org/wiki/Ramsey_theory")[*Teoria di Ramsey*].
  ]

- *Minimum-Weight Perfect Matching*#super[3]: <tsp-minimum-weight-perfect-matching>
  dato un grafo pesato con un numero di vertici pari, un perfect matching è una scelta di lati che fa sposare tutti (da cui perfect) i vertici, ovvero ogni vertice è incidente esattamente a un lato del matching.
  Tra tutti i matching possibili, viene scelto quello di peso (somma dei lati) minore.\
  Tale problema è risolvibile in tempo polinomiale ($in "PO"$) utilizzando l'#link("https://en.wikipedia.org/wiki/Blossom_algorithm")[algoritmo di _Edmonds_].

- *Esistenza Circuito Euleriano su $M union T$*#super[4]: <tsp-esistenza-circuito-euleriano>

  #teorema("Teorema")[
    Un multigrafo ammette un circuito Euleriano se e solo se è connesso e tutti i suoi vertici hanno grado *pari*.

    #dimostrazione[
      #attenzione[
        Questa non è una _dimostrazione_, ma solo una _costruzione_ del senso $<==$ dell'implicazione, ovvero come costruire un circuito Euleriano dato un multigrafo connesso con tutti i vertici di grado pari.
      ]

      Dato un multigrafo non orientato con tutti i vertici di grado pari:
      - si può partire da un vertice qualsiasi $a$
      - seguire un qualsiasi arco non ancora visitato
      - se si torna su un vertice già visitato $b$ (quindi sono stati usati $3$ dei suoi lati incidenti, in questo esempio $mb(1\, 2\, 4)$), esso ha per forza almeno un ulteriore lato (#mb(5)) dato che deve essere di grado pari
      - si continua così fino a quando i lati non si esauriscono (in questo caso si è per forza sul vertice iniziale)

      #figure(
        cetz.canvas({
          import cetz.draw: *

          // Vertices
          circle((0, 2), radius: 0.15, fill: white, stroke: black)
          content((-0.4, 2), text(size: 10pt)[$a$])

          circle((2, 3), radius: 0.15, fill: white, stroke: black)
          content((2, 3.4), text(size: 10pt)[$b$])

          circle((4, 3), radius: 0.15, fill: white, stroke: black)
          content((4.4, 3), text(size: 10pt)[$c$])

          circle((4, 1), radius: 0.15, fill: white, stroke: black)
          content((4.4, 1), text(size: 10pt)[$d$])

          circle((2, 0), radius: 0.15, fill: white, stroke: black)
          content((2, -0.4), text(size: 10pt)[$e$])

          // Path edges with numbering
          line((0.15, 2.05), (1.85, 2.95), mark: (end: ">"))
          content((1, 2.7), text(size: 9pt, fill: blue)[$1$])

          line((2.15, 3), (3.85, 3), mark: (end: ">"))
          content((3, 3.3), text(size: 9pt, fill: blue)[$2$])

          line((4, 2.85), (4, 1.15), mark: (end: ">"))
          content((4.3, 2), text(size: 9pt, fill: blue)[$3$])

          line((3.85, 1.05), (2.15, 2.95), mark: (end: ">"))
          content((3, 1.8), text(size: 9pt, fill: blue)[$4$])

          line((2, 2.85), (2, 0.15), mark: (end: ">"))
          content((2.3, 1.5), text(size: 9pt, fill: blue)[$5$])

          line((1.85, 0.05), (0.15, 1.95), mark: (end: ">"))
          content((0.8, 0.8), text(size: 9pt, fill: blue)[$6$])
        }),
        caption: [Esempio di circuito Euleriano che visita il vertice $b$ più volte prima di tornare al punto di partenza $a$.],
      )
    ]
  ] <tsp-metrico-teorema-circuito-euleriano-grado-pari>

  $M union T$ è un multigrafo dato che $M$ (il matching) e $T$ (l'albero di copertura) possono contenere dei lati in comune.
  Questo multigrafo ha tutti i vertici di grado *pari*:
  - tutti i vertici $in T \\ M$ avevano già grado pari (altrimenti sarebbero $in D$ e quindi nel matching $M$)
  - tutti i vertici $in T inter M$ avevano grado dispari in $T$, a cui è stato aggiunto un lato dal matching $M$ (per sposarli), rendendoli pari
  Quindi, per #link-teorema(<tsp-metrico-teorema-circuito-euleriano-grado-pari>), esiste un circuito Euleriano sul multigrafo $M union T$.

- *Cortocircuitazione*#super[5]: <tsp-cortocircuitazione>
  un circuito Euleriano passa una sola volta da tutti i lati, ma potrebbe passare più volte da alcuni vertici (come ad esempio mostrato nella dimostrazione di #link-teorema(<tsp-metrico-teorema-circuito-euleriano-grado-pari>)).
  Per ottenere un circuito Hamiltoniano possiamo sfruttare la cortocircuitazione, ovvero saltare direttamente al vertice successivo a quello già incontrato.
  Questa cosa è possibile perché il grafo è una *clique* e perché vale la *disuguaglianza triangolare* (migliorando quindi il peso finale).

  #esempio([
    #figure(
      cetz.canvas({
        import cetz.draw: *

        // Vertici
        circle((0, 2), radius: 0.15, fill: white, stroke: black)
        content((-0.4, 2), text(size: 10pt)[$a$])

        circle((2, 3), radius: 0.15, fill: white, stroke: black)
        content((2, 3.4), text(size: 10pt)[$b$])

        circle((4, 3), radius: 0.15, fill: white, stroke: black)
        content((4.4, 3), text(size: 10pt)[$c$])

        circle((4, 1), radius: 0.15, fill: white, stroke: black)
        content((4.4, 1), text(size: 10pt)[$d$])

        circle((2, 0), radius: 0.15, fill: white, stroke: black)
        content((2, -0.4), text(size: 10pt)[$e$])

        // Archi aggiunti per rendere il grafo una clique (grigio chiaro)
        line((0.15, 1.93), (3.85, 2.93), stroke: (paint: gray.lighten(50%), thickness: 0.5pt))
        line((0.15, 1.93), (3.85, 1.07), stroke: (paint: gray.lighten(50%), thickness: 0.5pt))
        line((4, 2.85), (2.15, 0.15), stroke: (paint: gray.lighten(50%), thickness: 0.5pt))

        // Circuito Euleriano (archi neri solidi)
        line((0.15, 2.05), (1.85, 2.95), mark: (end: ">"), stroke: black)
        content((1, 2.7), text(size: 9pt)[$mb(1)$])

        line((2.15, 3), (3.85, 3), mark: (end: ">"), stroke: black)
        content((3, 3.3), text(size: 9pt)[$mb(2)$])

        line((4, 2.85), (4, 1.15), mark: (end: ">"), stroke: black)
        content((4.3, 2), text(size: 9pt)[$mb(3)$])

        line((3.85, 1.05), (2.15, 2.95), mark: (end: ">"), stroke: (paint: red, dash: "dashed"))
        content((3, 1.8), text(size: 9pt)[$mb(4)$])

        line((2, 2.85), (2, 0.15), mark: (end: ">"), stroke: (paint: red, dash: "dashed"))
        content((2.3, 1.5), text(size: 9pt)[$mb(5)$])

        // Shortcut: d -> e diretto (arco verde)
        line((3.85, 0.93), (2.15, 0.05), mark: (end: ">"), stroke: green)
        content((3.3, 0.4), text(size: 9pt, fill: green)[$<= 9$])

        // e -> a (continua normalmente)
        line((1.85, 0.05), (0.15, 1.95), mark: (end: ">"), stroke: black)
        content((0.8, 0.8), text(size: 9pt)[$mb(6)$])
      }),
      caption: [
        Esempio di cortocircuitazione: il circuito Euleriano visita $b$ due volte.
        Invece di seguire $d -> b -> e$ ($mb(4)$ e $mb(5)$), si sfrutta l'arco diretto $mg(d -> e)$ (che esiste dato che è una clique) per ottenere un circuito Hamiltoniano.
        Per disuguaglianza triangolare, questo arco è di peso $<= 9$.
      ],
    )
  ])

=== Analisi dell'approssimazione

#teorema("Lemma")[
  Sia $T$ uno spanning tree minimo per un grafo, il suo peso (somma del peso dei lati selezionati) è minore o uguale della soluzione ottima $delta^*$ (lunghezza del circuito Hamiltoniano più corto):
  $ delta(T) <= delta^* $

  #dimostrazione[
    Sia $pi^*$ un circuito Hamiltoniano ottimo per TSP.

    Togliendo un lato da $pi^*$, otteniamo un grafo aciclico che copre tutti i vertici, ovvero uno spanning tree $T'$.
    Per definizione, $T$ è il più piccolo tra tutti gli alberi ricoprenti.

    $
      forall e in pi^*, quad delta^* quad >= quad underbrace(delta^* - delta_e, delta(T')) quad >= quad delta(T) space qed
    $
  ]
] <tsp-lemma-1-spanning>

#teorema("Lemma")[
  Dati:
  - $T$: minimum spannig tree su un grafo $G$
  - $D$: insieme dei vertici di grado dispari di $T$
  - $M$: minimum weight perfect matching su $D$

  Allora il peso del matching $M$ dei vertici di grado dispari è al massimo la metà della soluzione ottima $delta^*$:
  $ delta(M) <= 1/2 delta^* $

  #dimostrazione[
    Prendiamo il circuito Hamiltoniano ottimo $pi^*$, questo circuito passa per forza da tutti i vertici di $D$.
    Possiamo cortocircuitare tutti questi vertici e ottenere un circuito $mb(overline(pi)^*)$. Questo circuito tocca tutti i vertici (neri) che vogliamo far sposare nel matching $M$.

    #figure(
      cetz.canvas({
        import cetz.draw: *

        // Posizioni dei 9 vertici
        let positions = (
          (0, 2), // v1
          (1.5, 2.8), // v2
          (3, 2.8), // v3
          (4.5, 2), // v4
          (4.5, 0.5), // v5
          (3, -0.3), // v6
          (1.5, -0.3), // v7
          (0, 0.5), // v8
        )

        // Circuito Hamiltoniano principale (nero)
        let hamiltonian = (
          (0, 1),
          (1, 2),
          (2, 3),
          (3, 4),
          (4, 5),
          (5, 6),
          (6, 7),
          (7, 0),
        )

        for edge in hamiltonian {
          let p1 = positions.at(edge.at(0))
          let p2 = positions.at(edge.at(1))
          line(p1, p2, stroke: 1pt + black)
        }

        // Circuito secondario su 4 vertici (rosso)
        // Seleziono v2, v4, v6, v7 (indici 1, 3, 5, 6)
        let secondary = ((1, 3), (3, 5), (5, 6), (6, 1))

        for edge in secondary {
          let p1 = positions.at(edge.at(0))
          let p2 = positions.at(edge.at(1))
          line(p1, p2, stroke: (paint: blue, thickness: 2pt, dash: "dashed"))
        }

        // Vertici del circuito secondario (neri)
        let secondary_vertices = (1, 3, 5, 6)

        // Disegno i vertici
        for (i, pos) in positions.enumerate() {
          let fill_color = if i in secondary_vertices { black } else { white }
          circle(pos, radius: 0.15, fill: fill_color, stroke: black)
          content((pos.at(0) + 0.3, pos.at(1) - 0.3), text(size: 10pt)[$v_#(i + 1)$])
        }
      }),
      caption: [
        Il circuito Hamiltoniano principale (nero) collega tutti i vertici,
        mentre il circuito $mb("blu")$ collega i vertici di grado dispari in $T$ (riempiti di nero).

        #nota[
          Il grafo disegnato è semplificato, ovviamente i vertici neri hanno ulteriori archi incidenti, che li rendono di grado dispari sull'albero (non disegnato).
        ]
      ],
    )

    Dato che il circuito $mb(overline(pi)^*)$ è ottenuto #link(<tsp-cortocircuitazione>)[cortocircuitando] $pi^*$, allora grazie alla disuguaglianza triangolare è sicuramente più corto:
    $ delta(overline(pi)^*) <= delta(pi^*) $

    I vertici riempiti di nero vanno sposati da un matching perfetto.
    Due modi per ottenere ciò sono alternare gli archi di $mb(overline(pi)^*)$, generando i matching $mr(M_1)$ e $mg(M_2)$.

    #figure(
      cetz.canvas({
        import cetz.draw: *

        // Posizioni dei vertici
        let positions = (
          (0, 2), // v1
          (1.5, 2.8), // v2
          (3, 2.8), // v3
          (4.5, 2), // v4
          (4.5, 0.5), // v5
          (3, -0.3), // v6
          (1.5, -0.3), // v7
          (0, 0.5), // v8
        )

        // Circuito principale (nero)
        let hamiltonian = (
          (0, 1),
          (1, 2),
          (2, 3),
          (3, 4),
          (4, 5),
          (5, 6),
          (6, 7),
          (7, 0),
        )

        for edge in hamiltonian {
          let p1 = positions.at(edge.at(0))
          let p2 = positions.at(edge.at(1))
          line(p1, p2, stroke: 1pt + black)
        }

        // Circuito secondario su vertici neri (blu tratteggiato)
        let secondary = ((1, 3), (3, 5), (5, 6), (6, 1))

        for edge in secondary {
          let p1 = positions.at(edge.at(0))
          let p2 = positions.at(edge.at(1))
          line(p1, p2, stroke: (paint: blue, thickness: 2pt, dash: "dashed"))
        }

        // Matching M1 (rosso)
        let m1_edges = ((1, 3), (5, 6))
        for edge in m1_edges {
          let p1 = positions.at(edge.at(0))
          let p2 = positions.at(edge.at(1))
          line(p1, p2, stroke: (paint: red.transparentize(50%), thickness: 3pt))
        }

        // Matching M2 (verde)
        let m2_edges = ((3, 5), (6, 1))
        for edge in m2_edges {
          let p1 = positions.at(edge.at(0))
          let p2 = positions.at(edge.at(1))
          line(p1, p2, stroke: (paint: green.transparentize(50%), thickness: 3pt))
        }

        // Vertici del circuito secondario (neri)
        let secondary_vertices = (1, 3, 5, 6)

        for (i, pos) in positions.enumerate() {
          let fill_color = if i in secondary_vertices { black } else { white }
          circle(pos, radius: 0.15, fill: fill_color, stroke: black)
          content((pos.at(0) + 0.3, pos.at(1) - 0.3), text(size: 10pt)[$v_#(i + 1)$])
        }
      }),
      caption: [
        I matching $mr(M_1)$ e $mg(M_2)$ ottenuti alternando gli archi del circuito $mb(overline(pi)^*)$.
      ],
    )

    I due matching $mr(M_1)$ e $mg(M_2)$ sono, quindi, più corti della soluzione ottima $delta^*$:
    $ delta^* quad >= quad delta(mb(overline(pi)^*)) quad = quad delta(mr(M_1)) + delta(mg(M_2)) $

    Ma il matching $M$ è il *minimum* perfect matching, quindi è per forza corto almeno quanto $mr(M_1)$ e $mg(M_2)$:
    $
      delta(mr(M_1)) quad >= quad delta(M) \
      delta(mg(M_2)) quad >= quad delta(M)
    $

    Unendo tutti i pezzi:
    $
      delta^* quad >= quad delta(mr(M_1)) & + delta(mg(M_2)) quad >= quad 2 delta(M) space \
                             delta^* quad & >= quad 2 delta(M) \
                            delta(M) quad & <= quad 1/2 delta^* space qed
    $
  ]
] <tsp-lemma-2-multigrafo>

#teorema("Teorema")[
  L'algoritmo di Christofides è una *$3/2$-approssimazione* per il TSP metrico.

  #dimostrazione[
    Il multigrafo $T union M$ contiene un circuito Euleriano $pi_"Euler"$ (per  #link-teorema(<tsp-metrico-teorema-circuito-euleriano-grado-pari>)).
    È possibile cortocircuitarlo per ottenere un circuito Hamiltoniano $pi$ (che è più corto di $pi_"Euler"$):
    $
      delta(pi) quad & <= quad delta(pi_"Euler") \
      delta(pi) quad & <= quad delta(T) + delta(M) \
      delta(pi) quad & <= quad underbrace(delta^*, #link-teorema(<tsp-lemma-1-spanning>)) + underbrace(1/2 delta^*, #link-teorema(<tsp-lemma-2-multigrafo>)) \
      delta(pi) quad &<= quad 3/2 delta^* space qed
    $
  ]
]

=== Strettezza dell'analisi

Per dimostrare che l'analisi proposta è stretta, costruiamo un grafo per cui l'algoritmo genera una soluzione che è esattamente una $3/2$ volte l'ottimo.

Per un qualsiasi $0 < epsilon < 1$, costruiamo la clique $G$ con un numero $n$ di vertici *pari*:
- ogni vertice tra $1$ e $n-1$ è connesso al successivo da un #text(fill: red)[arco di peso $1$]
  $ forall i in [1, n), quad (v_i, v_(i+1)) in E, quad delta((v_i, v_(i+1))) = mr(1) $
- ogni vertice tra $1$ e $n-2$ è connesso a due vertici dopo da un #text(fill: blue)[arco di peso $1 + epsilon$]
  $ forall i in [1, n-1), quad (v_i, v_(i+2)) in E, quad delta((v_i, v_(i+2))) = mb(1 + epsilon) $
- tutti i lati mancanti per rendere $G$ una clique, di #text(fill: green)[peso cammino minimo tra i due vertici] (in modo da mantenere la disuguaglianza triangolare)
  $ forall i, j in [1, n], quad (v_i, v_j) in E, quad delta((v_i, v_j)) = mg("cammino minimo") $

Per qualunque $epsilon$ compreso fra $0 < epsilon < 1$, la clique è metrica:
$ underbrace(d(v_1,v_2), 1) + underbrace(d(v_2,v_3), "1") <= underbrace(d(v_1,v_3), 1+epsilon) $

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Archi peso 1 (rosso)
    line((0.15, 0), (1.35, 0), stroke: 2pt + red)
    content((0.75, 0.2), text(size: 9pt, fill: red)[$1$])

    line((1.65, 0), (2.85, 0), stroke: 2pt + red)
    content((2.25, 0.2), text(size: 9pt, fill: red)[$1$])

    line((3.15, 0), (4.35, 0), stroke: 2pt + red)
    content((3.75, 0.2), text(size: 9pt, fill: red)[$1$])

    line((6.65, 0), (7.85, 0), stroke: 2pt + red)
    content((7.25, 0.2), text(size: 9pt, fill: red)[$1$])

    // Archi peso 1+epsilon (blu)
    bezier((0.1, 0.1), (2.9, 0.1), (1.5, 0.8), stroke: 2pt + blue.transparentize(50%))
    content((1.5, 0.7), text(size: 9pt, fill: blue)[$1+epsilon$])

    bezier((1.6, 0.1), (4.4, 0.1), (3, 0.8), stroke: 2pt + blue.transparentize(50%))
    content((3, 0.7), text(size: 9pt, fill: blue)[$1+epsilon$])

    // Archi cammino minimo (verde)
    bezier((0, -0.15), (8, -0.15), (4, -1.5), stroke: 2pt + green.transparentize(50%))
    content((4, -1), text(size: 9pt, fill: green)[cammino minimo])

    bezier((0.1, -0.1), (6.4, -0.1), (3.25, -1.2), stroke: 2pt + green.transparentize(50%))

    bezier((1.6, -0.1), (7.9, -0.1), (4.75, -1.2), stroke: 2pt + green.transparentize(50%))

    // Vertici
    circle((0, 0), radius: 0.15, fill: white, stroke: black)
    content((0, -0.4), text(size: 10pt)[$v_1$])

    circle((1.5, 0), radius: 0.15, fill: white, stroke: black)
    content((1.5, -0.4), text(size: 10pt)[$v_2$])

    circle((3, 0), radius: 0.15, fill: white, stroke: black)
    content((3, -0.4), text(size: 10pt)[$v_3$])

    circle((4.5, 0), radius: 0.15, fill: white, stroke: black)
    content((4.5, -0.4), text(size: 10pt)[$v_4$])

    content((5.5, 0), text(size: 10pt)[$dots.c$])

    circle((6.5, 0), radius: 0.15, fill: white, stroke: black)
    content((6.5, -0.4), text(size: 10pt)[$v_(n-1)$])

    circle((8, 0), radius: 0.15, fill: white, stroke: black)
    content((8, -0.4), text(size: 10pt)[$v_n$])
  }),
  caption: [
    Esempio _parziale_ della clique $G$ con $n$ pari. Gli archi $mr("rossi")$ hanno peso $mr(1)$, gli archi $mb("blu")$ hanno peso $mb(1+epsilon)$, e gli archi $mg("verdi")$ hanno peso uguale al $mg("cammino minimo")$ tra i vertici.
  ],
)

Eseguiamo ora l'algoritmo di Christofides su $G$:

- $mo(T) <- "MST"(G)$: cammino che connette ogni vertice al successivo (solo lati con peso $1$)
  - costo di $mo(T = 1 (n-1))$

- $D <- {v_1, v_n}$: gli unici vertici di grado dispari in $T$ sono $v_1$ e $v_n$ (grado $1$)

- $mm(M) <- "MWPM"(D)$: minimum-weight perfect matching tra soli due vertici è semplicemente l'arco che li collega, di peso uguale al cammino minimo tra $v_1$ e $v_n$, calcolato come:
  - archi alternati da $v_1 ~> v_3$, $v_3 ~> v_5$, ..., $v_(n-3) ~> v_(n-1)$ (ciascuno di costo $1+epsilon$)
  - arco di costo $1$ che collega $v_(n-1)$ a $v_n$
  - costo di $mm(M = (1+epsilon) n/2 + 1)$

- Unendo $mo(T) union mm(M)$ otteniamo un circuito Hamiltoniano (non c'è bisogno di cortocircuitazione), esso ha costo:
$
  delta & = mm((1+epsilon)n/2+ 1) + mo((n-1)) \
  delta & = n/2 + epsilon n/2 cancel(+1) + n cancel(-1) \
  delta & = 3/2 n + epsilon n/2
$

#figure(
  cetz.canvas({
    import cetz.draw: *

    // MST T (arancione) - archi peso 1
    line((0.15, 0), (1.35, 0), stroke: 3pt + orange)
    line((1.65, 0), (2.85, 0), stroke: 3pt + orange)
    line((3.15, 0), (4.35, 0), stroke: 3pt + orange)
    line((6.65, 0), (7.85, 0), stroke: 3pt + orange)

    // Matching M (marrone) - arco curvo da v1 a vn
    bezier((0, -0.1), (8, -0.1), (4, -1.5), stroke: 3pt + maroon)
    content((4, -1.2), text(size: 9pt, fill: maroon)[$(1+epsilon)n/2 + 1$])

    // Vertici
    circle((0, 0), radius: 0.15, fill: white, stroke: black)
    content((0, -0.4), text(size: 10pt)[$v_1$])

    circle((1.5, 0), radius: 0.15, fill: white, stroke: black)
    content((1.5, -0.4), text(size: 10pt)[$v_2$])

    circle((3, 0), radius: 0.15, fill: white, stroke: black)
    content((3, -0.4), text(size: 10pt)[$v_3$])

    circle((4.5, 0), radius: 0.15, fill: white, stroke: black)
    content((4.5, -0.4), text(size: 10pt)[$v_4$])

    content((5.5, 0), text(size: 10pt)[$dots.c$])

    circle((6.5, 0), radius: 0.15, fill: white, stroke: black)
    content((6.5, -0.4), text(size: 10pt)[$v_(n-1)$])

    circle((8, 0), radius: 0.15, fill: white, stroke: black)
    content((8, -0.4), text(size: 10pt)[$v_n$])
  }),
  caption: [
    Circuito Hamiltoniano prodotto dall'algoritmo di Christofides.
    Gli archi $mo("arancioni")$ rappresentano il MST $mo(T)$,
    mentre l'arco $mm("marrone")$ rappresenta il matching $mm(M)$ tra $v_1$ e $v_n$.
  ],
)

Tuttavia il circuito Hamiltoniano ottimo $delta^*$ è formato da:
- archi alternati da $mp(v_1 ~> v_3)$, $mp(v_3 ~> v_5)$, ..., $mp(v_(n-3) ~> v_(n-1))$
- usare un arco di costo $1$ per raggiungere $v_n$: $mp(v_(n-1) ~> v_n)$
- tornare indietro sfruttando ancora gli archi alternati $mr(v_n ~> v_(n-2))$, $mr(v_(n-2) ~> v_(n-4))$, ..., $mr(v_(4) ~> v_2)$
- usare un arco di costo $1$ per raggiungere $v_1$: $mr(v_2 ~> v_1)$

$
  delta^* & = mp((1+epsilon)n/2 +1) + mr((1+epsilon)n/2 +1) \
  delta^* & = (1+epsilon)n/2 + (1+epsilon)n/2 + 2 \
  delta^* & = (1+epsilon)n + 2
$

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Archi alternati andata (viola) v1->v3, v3->v5, ..., v(n-1)->vn
    bezier((0.1, 0.1), (2.9, 0.1), (1.5, 0.8), stroke: 2pt + purple)
    content((1.5, 0.7), text(size: 9pt, fill: purple)[$1+epsilon$])

    bezier((3.1, 0.1), (5.9, 0.1), (4.5, 0.8), stroke: 2pt + purple)
    content((4.5, 0.7), text(size: 9pt, fill: purple)[$1+epsilon$])

    line((6.15, 0), (7.35, 0), stroke: 2pt + purple)
    content((6.75, 0.2), text(size: 9pt, fill: purple)[$1$])

    // Archi alternati ritorno (rosso) vn->v(n-2), v(n-2)->v(n-4), ..., v2->v1
    bezier((7.4, -0.1), (4.6, -0.1), (6, -0.8), stroke: 2pt + red)
    content((6, -0.7), text(size: 9pt, fill: red)[$1+epsilon$])

    bezier((4.4, -0.1), (1.6, -0.1), (3, -0.8), stroke: 2pt + red)
    content((3, -0.7), text(size: 9pt, fill: red)[$1+epsilon$])

    line((1.35, 0), (0.15, 0), stroke: 2pt + red)
    content((0.75, -0.2), text(size: 9pt, fill: red)[$1$])

    // Vertici
    circle((0, 0), radius: 0.15, fill: white, stroke: black)
    content((0, -0.4), text(size: 10pt)[$v_1$])

    circle((1.5, 0), radius: 0.15, fill: white, stroke: black)
    content((1.5, -0.4), text(size: 10pt)[$v_2$])

    circle((3, 0), radius: 0.15, fill: white, stroke: black)
    content((3, -0.4), text(size: 10pt)[$v_3$])

    circle((4.5, 0), radius: 0.15, fill: white, stroke: black)
    content((4.5, -0.4), text(size: 10pt)[$v_4$])

    circle((6, 0), radius: 0.15, fill: white, stroke: black)
    content((6, -0.4), text(size: 10pt)[$v_5$])

    circle((7.5, 0), radius: 0.15, fill: white, stroke: black)
    content((7.5, -0.4), text(size: 10pt)[$v_6$])
  }),
  caption: [
    Circuito Hamiltoniano ottimo $delta^*$.
    Gli archi $mp("viola")$ rappresentano il percorso in andata alternato ($mp(v_1 ~> v_3 ~> v_5 ~> v_6)$),
    mentre gli archi $mr("rossi")$ rappresentano il ritorno alternato ($mr(v_6 ~> v_4 ~> v_2 ~> v_1)$).
  ],
)

Consideriamo ora il rapporto di approssimazione:
$ delta/delta^* = (3/2 n + epsilon n/2) / ((1+epsilon)n+2) quad -->_(n->infinity \ epsilon -> 0) quad 3/2 $

Per un $n$ abbastanza grande $n-> infinity$ e per un $epsilon$ abbastanza piccolo $epsilon -> 0$, il rapporto $delta/delta^*$ tende a $3/2$.


#teorema("Teorema")[
  *$3/2$* è il miglior tasso di approssimazione noto per *TSP metrico*.
]

== Inapprossimabilità di TSP

#teorema("Teorema")[
  Non esiste nessun $alpha > 1$ tale che TSP sia $alpha$-approssimabile (nemmeno sulle clique).

  #attenzione[
    Valido per il TSP *non* metrico.
  ]

  #dimostrazione[
    Determinare se un *grafo* ha un *circuito Hamiltoniano* è *$"NPc"$*.

    Supponiamo per assurdo che esista un algoritmo che $alpha$-approssima (per qualche $alpha > 1$) TSP sulle clique.

    Dato un grafo $G = (V, E)$ con $n$ nodi, costruiamo la seguente clique:
    $ overline(G) = (V, binom(V, 2)) $
    $
      overline(delta)_{x, y} = cases(
        1 quad & "se" {x, y} in E,
        ceil(alpha n) + 1 quad & "altrimenti"
      )
    $

    Eseguendo l'algorimto su $overline(G)$, ci verrà restituito un circuito Hamiltoniano $pi$ di costo $overline(delta)$.
    Quindi, per definizione di approssimazione:
    $ overline(delta) <= alpha overline(delta)^* $

    Le soluzioni $overline(delta)^*$ e $overline(delta)$ si dividono in due casi:

    - il grafo originale $G$ *ha* un cammino Hamiltoniano
      - la soluzione _ottima_ su $overline(G)$ usa solo archi del grafo originale, quindi di peso $1$:
        $ overline(delta)^* = 1 dot n $
      - la soluzione _approssimata_ su $overline(G)$ è al massimo $alpha$ volte l'ottimo:
        $ overline(delta) <= alpha n $

    - il grafo originale $G$ *non* ha un cammino Hamiltoniano
      - la soluzione _ottima_ su $overline(G)$ deve usare almeno un arco di costo $ceil(alpha n) + 1$:
        $ overline(delta)^* >= ceil(alpha n) + 1 $
      - la soluzione _approssimata_ su $overline(G)$ deve essere grande almeno quanto l'ottimo:
        $ overline(delta) >= ceil(alpha n) + 1 $

    Di conseguenza, dato che i due intervalli sono *disgiunti*, allora osservando la soluzione approssimata è possibile dedurre l'ottimo, decidendo il problema di decisione:
    $
                overline(delta) <= alpha n quad & "se" G "ha un circuito Hamiltoniano" \
      overline(delta) >= ceil(alpha n) + 1 quad & "se" G "non ha un circuito Hamiltoniano"
    $

    Questa cosa è assurda, dato che il problema di decisione è NPc, quindi non può esistere un algoritmo di approssimazione, $qed$.

    #informalmente[
      Abbiamo costruito un problema di ottimizzazione partendo da quello di decisione, in modo che l'approssimazione cada in uno di due intervalli *disgiunti* che ci permettono di capire qual era l'ottimo.
    ]
  ]
]
