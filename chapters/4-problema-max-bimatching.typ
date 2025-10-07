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
- $"Amm"_Pi = M subset.eq E$: un *matching*, ovvero un sottoinsieme di lati tale che ogni vertice è collegato ad al massimo un lato del matching _(ovvero un insieme di coppie sposate)_: $ forall x in V, "al massimo un lato di" M "è incidente su" x $
- $C_Pi = |M|$: numero di coppie
- $t_Pi = max$

Inoltre saranno utili le seguenti definizioni:
- Lato *libero*: non fa parte del Matching
- Lato *occupato*: fa parte del Matching
- Vertice *esposto*: se su di esso incidono solo lati liberi _(persona non ancora sposata)_

#teorema("Teorema")[
  *$ "Max Matching" in "PO" $*
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
      Non è detto che $M' subset M$, $M'$ e $M$ possono essere differenti
    ]

    Consideriamo la differenza simmetrica $Delta$, ovvero i lati in esattamente uno dei due matching (non in entrambi):
    $ X = M space Delta space M' = (M \\ M') union (M' \\ M) = (M union M') \\ (M inter M') $

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
      $X$ contiene più elementi $in M'$ che $in M$, in quanto abbiamo supposto che $|M'| > |M|$.
    ]

    #teorema("Osservazione 2")[
      Ogni vertice ha al *massimo* $2$ lati di $X$ *incidenti*, altrimenti non sarebbero matching.

      Dato un vertice $v$ e due lati $l_1 in M\\M'$ e $l_2 in M'\\M$, possiamo trovarci nella seguente situazione:

      #{
        set align(center)
        cetz.canvas({
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
      }

      Ogni singolo matching $M$ e $M'$ può avere un solo lato connesso al vertice $v$ e quelli in comune sono stati scartati, di conseguenza ogni vertice ha $0, 1$ lati di $M$ e $0, 1$ lati di $M'$, quindi al massimo $2$ lati incidenti.
    ]

    #teorema("Osservazione 3")[
      Conseguenza dell'osservazione 2: nel grafo ristretto a $X$, i vertici possono avere solo *grado* $0,1,2$.

      Quindi ogni vertice:
      - è isolato (grado 0)
      - è l'estremo di un cammino (grado 1)
      - è all'interno di un cammino o ciclo (grado 2)
    ]

    #teorema("Osservazione 4")[
      I vertici isolati possono essere ignorati (dato che ovviamente non intaccano i lati).

      Ogni ciclo deve essere formato da un numero *pari* di lati, altrimenti ci sarebbero due lati *consecutivi* appartenenti allo stesso matching, assurdo. In ogni ciclo ci sono lo stesso numero di lati $in M \\ M'$ e $in M' \\ M$.

      #{
        set align(center)
        cetz.canvas({
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
      }

      Di conseguenza devono esistere dei *cammini di dimensione dispari*, altrimenti sarebbe impossibile soddisfare $|M'| > |M|$.
    ]

    #teorema("Osservazione 5")[
      Conseguenza dell'osservazione 4: ci deve essere almeno un *cammino con più lati* di $M' \\ M$ rispetto ai lati di $M \\ M'$.
      Tale cammino deve iniziare e terminate con lati $in M'\\M$ (in quanto $|M'|>|M|$), dove i vertici iniziale e finale devono essere *esposti* in $M$:

      #{
        set align(center)
        cetz.canvas({
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
      }

      Il cammino così descritto rispecchia esattamente la definizione di *cammino aumentante* $qed$.
    ]
  ]
]

=== Algoritmo Max Bi-Matching

#pseudocode(
  [input $<- G=(V_1 union V_2, E)$],
  [$M <- emptyset$ #emph("// Matching vuoto")],
  [*While* true],
  indent(
    [$pi <- "FindAugmenting"(M)$ #emph("// Funzione che cerca un cammino aumentante")],
    [*If* $pi = "null"$ *then* #emph("// Non ci sono più cammini aumentanti, M è massimo")],
    indent(
      [*Output*$(M)$],
      [*Stop*],
    ),
    [*Else*],
    indent(
      [$M <- "Switch"(M, pi)$ #emph("// Guadagno un matching in più")],
    ),
  ),
  [*End*],
)

/ Funzione FindAugmenting: dato un certo matching $M$, la funzione cerca di trovare un cammino aumentante, utilizzando una *BFS modificata*:
  #nota[
    *BFS* (breadth-first search): visita in ampiezza.
    Dato un vertice iniziale vengono aggiunti i vicini ad una coda.
    Man mano si ripete il procedimento per ogni vertice estratto dalla coda.

    La funzione visita prima tutti i vertici a distanza $1$ da quello iniziale, poi a distanza $2$ e così via.
  ]
  - la visita parte da un vertice $u in V_1$ *esposto*
  - primo passo: vengono visitati i vertici adiacenti a $u$ non esposti, seguendo i lati *liberi* ($in.not M$)
  - passo successivo: partendo da tutti i vertici non esposti, si seguono i lati *occupati* ($in M$)
  - si continua *alternando* lati liberi ($in.not M$) e occupati ($in M$)
  - la visita *termina* quando viene visitato un vertice $d in V_2$ *esposto*: trovato un *cammino aumentante*

  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Level 0: Starting exposed vertex
      circle((0, 0), radius: 0.1, fill: green)
      content((-0.5, 0), [$u_1$])

      // Level 1: Free edges to multiple non-exposed vertices
      let level1_positions = ((-3, -2), (-1, -2), (1, -2), (3, -2))
      for (i, pos) in level1_positions.enumerate() {
        circle(pos, radius: 0.1, fill: black)
        content((pos.at(0) - 0.4, pos.at(1)), [$d_#(i + 1)$])
        line((0, 0), pos, stroke: (paint: blue, thickness: 2pt, dash: "dashed"))
      }

      // Level 2: Matched edges back to vertices in V1
      let level2_positions = ((-4, -4), (-2, -4), (-1, -4), (0, -4), (1, -4), (2, -4), (4, -4))
      for (i, pos) in level2_positions.enumerate() {
        circle(pos, radius: 0.1, fill: if i == 3 or i == 5 { black } else { black })
        content((pos.at(0) - 0.4, pos.at(1)), [$u_#(i + 2)$])

        // Connect level 1 to level 2 with matched edges
        if i < 2 { line(level1_positions.at(0), pos, stroke: (paint: red, thickness: 2pt)) } else if (
          i >= 2 and i < 4
        ) { line(level1_positions.at(1), pos, stroke: (paint: red, thickness: 2pt)) } else if i >= 4 and i < 6 {
          line(level1_positions.at(2), pos, stroke: (paint: red, thickness: 2pt))
        } else { line(level1_positions.at(3), pos, stroke: (paint: red, thickness: 2pt)) }
      }

      // Level 3: Free edges from exposed vertices to final exposed vertices
      let level3_positions = ((-1, -6), (1, -6), (3, -6))
      for (i, pos) in level3_positions.enumerate() {
        circle(pos, radius: 0.1, fill: green)
        content((pos.at(0), pos.at(1) - 0.4), [$d_#(i + 5)$])
        if i == 0 {
          line(level2_positions.at(3), pos, stroke: (paint: blue, thickness: 2pt, dash: "dashed"))
        } else if i == 1 {
          line(level2_positions.at(5), pos, stroke: (paint: blue, thickness: 2pt, dash: "dashed"))
        } else {
          line(level2_positions.at(5), pos, stroke: (paint: blue, thickness: 2pt, dash: "dashed"))
        }
      }

      // Highlight one correct augmenting path
      line((0, 0), (-1, -2), stroke: 4pt + green.transparentize(70%))
      line((-1, -2), (0, -4), stroke: 4pt + green.transparentize(70%))
      line((0, -4), (-1, -6), stroke: 4pt + green.transparentize(70%))
    }),
    caption: [
      Visita effettuata dalla BFS modificata per cammino aumentante.\
      Lati blu: $in.not M$, rossi: $in M$.\
      Vertici neri: occupati, verdi: esposti.
    ],
  )

  #informalmente[
    La BFS modificata prova tutti i cammini alternati a partire da un vertice esposto.
    Appena incontra un vertice esposto, allora esiste un cammino aumentante.
  ]

/ Complessità funzione FindAugmenting: la BFS modificata ha una complessità di $O(|V| + |E|)$.

/ Complessità algoritmo Max Bi-Matching: il miglior matching possibile fa _sposare_ tutti i vertici, ovvero $(|V|) / 2$ lati. Ad ogni iterazione, eseguendo FindAugmenting, viene aggiunto un lato. Di conseguenza, nel caso peggiore la funzione viene eseguita $O(|V|)$ volte, con complessità totale $O(|V| dot (|V| + |E|))$, polinomiale.

== Problema Perfect Bi-Matching [P]

Si tratta di un problema di *decisione*, dato un grafo determinare se esiste un matching che coinvolge *tutti* i vertici.

#teorema("Corollario")[
  *$ "Perfect Matching" in P $*

  #dimostrazione[
    Basta utilizzare l'algoritmo che risolve Max Bi-Matching (che risolve il problema in tempo polinomale) e verificare se $|M| = "numero di vertici"/2$.
  ]
]
