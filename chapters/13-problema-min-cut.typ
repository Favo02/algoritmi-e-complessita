#import "../imports.typ": *

= Problema Min Cut (taglio minimo) [NPOc]

#informalmente[
  Dividere i vertici di un grafo in due insiemi disgiunti non vuoti.
  L'obiettivo è minimizzare il numero di lati da "tagliare" per ottenere la divisione.

  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Lati normali (neri)
      line((0.1, 0.95), (1.9, 0.95), stroke: black) // 1-2
      line((2.05, 0.9), (2.95, -0.9), stroke: black) // 2-4
      line((-0.9, -1.1), (0.9, -2.4), stroke: black) // 3-5
      line((0.1, 0.9), (2.9, -0.9), stroke: black) // 1-4

      // Lati del taglio (rossi)
      line((-0.05, 0.9), (-0.9, -0.9), stroke: red) // 1-3
      line((1.95, 0.9), (-0.9, -0.9), stroke: red) // 2-3
      line((2.9, -1.1), (1.1, -2.4), stroke: red) // 4-5

      // Vertici del grafo
      circle((0, 1), radius: 0.12, fill: white, stroke: black)
      content((-0.35, 1), text(size: 10pt)[$1$])

      circle((2, 1), radius: 0.12, fill: white, stroke: black)
      content((2.35, 1), text(size: 10pt)[$2$])

      circle((-1, -1), radius: 0.12, fill: white, stroke: black)
      content((-1.35, -1), text(size: 10pt)[$3$])

      circle((3, -1), radius: 0.12, fill: white, stroke: black)
      content((3.35, -1), text(size: 10pt)[$4$])

      circle((1, -2.5), radius: 0.12, fill: white, stroke: black)
      content((1, -2.9), text(size: 10pt)[$5$])

      // Linea tratteggiata blu per indicare il taglio
      line((-1.5, 0.5), (3.5, -2), stroke: (paint: blue, thickness: 2pt, dash: "dashed"))
    }),
    caption: [
      Esempio di taglio. La linea $mb("blu")$ separa i vertici in due insiemi, i lati in $mr("rosso")$ costituiscono il taglio.
    ],
  )
]

Formalmente:
- *$I_Pi$*: $G = (V, E)$ grafo non orientato, con $n = |V|$ vertici e $m = |E|$ lati.
- *$"Amm"_Pi$*: insieme di vertici $S$ che costituisce uno dei due insiemi disgiunti di vertici (non può comprendere tutti i vertici e non può essere vuoto). Il suo complemento è l'altro insieme di vertici:
  $ S subset.eq V, quad S != emptyset, quad S != V $
- *$C_Pi$*: numero dei lati che rientrano nel taglio, ovvero i lati con un'estremità $in S$ e l'altra $in S^c$:
  $ |E_S|, quad E_S = {e in E quad "t.c." quad e inter S != emptyset, quad e inter S^c != emptyset } $
- *$t_Pi$* = $min$

#teorema("Proprietà")[
  Il taglio minimo ha dimensione $<=$ del grado del vertice con grado minimo del grafo.

  #dimostrazione[
    Basta tagliare tutti i lati incidenti sul vertice $v$ di grado minimo, isolando di conseguenza il vertice $v$.
  ]

  #esempio[
    Il taglio può essere più piccolo.

    #figure(
      cetz.canvas({
        import cetz.draw: *

        // Bridge che collega le due clique (lato rosso)
        line((-1.5, 0.5), (1.5, 0.5), stroke: red)

        // lato interni prima clique (tutti i vertici connessi tra loro)
        line((-3, 0.5), (-1.5, 0.5), stroke: blue)
        line((-3, 0.5), (-3, -0.5), stroke: blue)
        line((-3, 0.5), (-1.5, -0.5), stroke: blue)
        line((-1.5, 0.5), (-3, -0.5), stroke: black)
        line((-1.5, 0.5), (-1.5, -0.5), stroke: black)
        line((-3, -0.5), (-1.5, -0.5), stroke: black)

        // Vertici
        circle((-3, 0.5), radius: 0.12, fill: white, stroke: black)
        circle((-1.5, 0.5), radius: 0.12, fill: white, stroke: black)
        circle((-3, -0.5), radius: 0.12, fill: white, stroke: black)
        circle((-1.5, -0.5), radius: 0.12, fill: white, stroke: black)

        // lato interni seconda clique (tutti i vertici connessi tra loro)
        line((1.5, 0.5), (3, 0.5), stroke: black)
        line((1.5, 0.5), (1.5, -0.5), stroke: black)
        line((1.5, 0.5), (3, -0.5), stroke: black)
        line((3, 0.5), (1.5, -0.5), stroke: black)
        line((3, 0.5), (3, -0.5), stroke: black)
        line((1.5, -0.5), (3, -0.5), stroke: black)

        // Vertici
        circle((1.5, 0.5), radius: 0.12, fill: white, stroke: black)
        circle((3, 0.5), radius: 0.12, fill: white, stroke: black)
        circle((1.5, -0.5), radius: 0.12, fill: white, stroke: black)
        circle((3, -0.5), radius: 0.12, fill: white, stroke: black)
      }),
      caption: [
        Il taglio minimo $= mr(1)$ consiste nel tagliare solo il bridge (lato rosso).\
        Mentre per isolare il vertice di grado minimo bisogna appunto tagliare $mb(3)$ lati (blu).
      ],
    )
  ]

] <min-cut-taglio-minimo-grado>

== Contrazione di un Lato

Contrarre un grafo $G$ su un lato $e$, indicato con *$G arrow.b e$*, significa rimuovere il lato $e$ dal grafo, condensando in un unico vertice gli estremi del lato $e$.
Questi nuovi vertici diventano delle classi di equivalenza tra più vertici.

#nota[
  È possibile che una contrazione possa generare dei *multigrafi*.
  Questo evento avviene quando esiste un vertice connesso ad entrambe le estremità del lato contratto.
]

#esempio[
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== GRAFO ORIGINALE (sinistra) =====
      content((-4, 2.7), text(size: 11pt, weight: "bold")[Grafo originale $G$])

      // Lati grafo originale
      line((-5.88, 1), (-4.62, 1), stroke: black) // A-U
      line((-4.38, 1), (-3.12, 1), stroke: red) // U-V (da contrarre)
      line((-4.4, 1.1), (-3.85, 1.7), stroke: black) // U-D
      line((-3.65, 1.7), (-3.1, 1.1), stroke: black) // D-V
      line((-2.9, 0.9), (-2.3, 0.4), stroke: black) // V-B
      line((-4.5, 0.88), (-4.5, 0.2), stroke: black) // U-C

      // Vertici grafo originale
      circle((-6, 1), radius: 0.12, fill: white, stroke: black)
      content((-6.4, 1), text(size: 10pt)[$A$])

      circle((-4.5, 1), radius: 0.12, fill: white, stroke: black)
      content((-4.5, 1.4), text(size: 10pt)[$mr(U)$])

      circle((-3, 1), radius: 0.12, fill: white, stroke: black)
      content((-3, 1.4), text(size: 10pt)[$mr(V)$])

      circle((-3.75, 1.8), radius: 0.12, fill: white, stroke: black)
      content((-3.75, 2.2), text(size: 10pt)[$D$])

      circle((-2.2, 0.3), radius: 0.12, fill: white, stroke: black)
      content((-2.2, 0.7), text(size: 10pt)[$B$])

      circle((-4.5, 0.2), radius: 0.12, fill: white, stroke: black)
      content((-4.5, -0.2), text(size: 10pt)[$C$])

      // ===== FRECCIA DI TRASFORMAZIONE =====
      content((-0.1, 1.3), text(size: 10pt)[$G arrow.b e$])
      content((0, 1), text(size: 25pt)[$-->$])

      // ===== GRAFO CONTRATTO (destra) =====
      content((4, 2.7), text(size: 11pt, weight: "bold")[Grafo contratto $G arrow.b e$])

      // Lati grafo contratto
      line((2.12, 1), (3.63, 1), stroke: black) // A-(UV)
      bezier((3.75, 1.68), (3.75, 1.12), (3.55, 1.4)) // D-(UV) primo lato
      bezier((3.75, 1.68), (3.75, 1.12), (3.95, 1.4)) // D-(UV) secondo lato
      line((3.8, 1), (5.18, 0.3), stroke: black) // (UV)-B
      line((3.75, 0.88), (3.75, 0), stroke: black) // (UV)-C

      // Vertici grafo contratto
      circle((2, 1), radius: 0.12, fill: white, stroke: black)
      content((1.6, 1), text(size: 10pt)[$A$])

      circle((3.75, 1), radius: 0.12, fill: white, stroke: black)
      content((4.5, 1.15), text(size: 10pt)[$mr(U = V)$])

      circle((3.75, 1.8), radius: 0.12, fill: white, stroke: black)
      content((3.75, 2.2), text(size: 10pt)[$D$])

      circle((5.3, 0.25), radius: 0.12, fill: white, stroke: black)
      content((5.3, 0.65), text(size: 10pt)[$B$])

      circle((3.75, 0), radius: 0.12, fill: white, stroke: black)
      content((3.75, -0.4), text(size: 10pt)[$C$])
    }),
    caption: [
      Esempio di contrazione del lato $mr(e = {U comma V})$.
      Nel grafo contratto, i vertici $U$ e $V$ vengono uniti in un unico vertice $U = V$.
      I lati tra $D$ e i vertici $U$ e $V$ diventano lati multipli tra $D$ e $U V$.
    ],
  )
]

#teorema("Proprietà")[
  Ogni lato di un grafo contratto corrisponde a un lato del grafo originale.

  Gli unici lati persi sono i _self-loop_, ovvero i lati che iniziano e finiscono nei vertici contratti (ovvero il lato contratto stesso o i suoi lati paralleli del multigrafo).
] <min-cut-lati-persi-contrazione>

== Algoritmo di Karger

#pseudocode(
  [*If* $G$ non è connesso *then*],
  indent(
    [*Output* una qualunque componente connessa],
    [*Stop*],
  ),
  [*While* $|V| > 2$ *do*],
  indent(
    [$e <- "lato casuale di" G$ #emph("// scelta non deterministica")],
    [$G <- G arrow.b e$ #emph("// contrazione")],
  ),
  [*Output* la classe di equivalenza di una delle due estremità #emph("// ovvero tutti i vertici che sono stati \"compressi\" in quel vertice")],
)

#nota[
  Ad ogni contrazione, i due vertici compressi si uniscono nella stessa classe di equivalenza.
  Dato che ci fermiamo ad esattamente due vertici rimanenti, allora avremo due classi di equivalenza.
]

#esempio[
  Esecuzione dell'algoritmo di Karger su un grafo semplice con 5 vertici.

  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== ITERAZIONE 0: Grafo originale =====
      content((-4, 5), text(size: 11pt, weight: "bold")[Iterazione 0: Grafo originale])

      // Lati grafo originale - evidenzio il lato che verrà contratto
      line((-5.5, 3.5), (-4, 3.5), stroke: (paint: red, thickness: 1.5pt)) // A-B (da contrarre)
      line((-4, 3.5), (-2.5, 3.5), stroke: black) // B-C
      line((-2.5, 3.5), (-2.5, 2), stroke: black) // C-D
      line((-4, 3.5), (-2.5, 2), stroke: black) // B-D
      line((-5.5, 3.5), (-5.5, 2), stroke: black) // A-E
      line((-5.5, 2), (-2.5, 2), stroke: black) // E-D

      // Vertici grafo originale
      circle((-5.5, 3.5), radius: 0.12, fill: white, stroke: black)
      content((-5.5, 3.9), text(size: 10pt)[$A$])

      circle((-4, 3.5), radius: 0.12, fill: white, stroke: black)
      content((-4, 3.9), text(size: 10pt)[$B$])

      circle((-2.5, 3.5), radius: 0.12, fill: white, stroke: black)
      content((-2.5, 3.9), text(size: 10pt)[$C$])

      circle((-2.5, 2), radius: 0.12, fill: white, stroke: black)
      content((-2.5, 1.6), text(size: 10pt)[$D$])

      circle((-5.5, 2), radius: 0.12, fill: white, stroke: black)
      content((-5.5, 1.6), text(size: 10pt)[$E$])

      // ===== ITERAZIONE 1: Dopo contrazione A-B =====
      content((-4, 0.5), text(size: 11pt, weight: "bold")[Iterazione 1: $mr(A"-"B)$ contratto])

      // Lati - evidenzio il prossimo lato da contrarre
      line((-4.75, -1), (-3, -1), stroke: (paint: red, thickness: 1.5pt)) // AB-C (da contrarre)
      line((-3, -1), (-3, -2.5), stroke: black) // C-D
      line((-4.75, -1), (-3, -2.5), stroke: black) // AB-D
      line((-4.75, -1), (-4.75, -2.5), stroke: black) // AB-E
      line((-4.75, -2.5), (-3, -2.5), stroke: black) // E-D

      // Vertici
      circle((-4.75, -1), radius: 0.12, fill: white, stroke: black)
      content((-5.4, -1), text(size: 10pt)[$A B$])

      circle((-3, -1), radius: 0.12, fill: white, stroke: black)
      content((-3, -0.6), text(size: 10pt)[$C$])

      circle((-3, -2.5), radius: 0.12, fill: white, stroke: black)
      content((-3, -2.9), text(size: 10pt)[$D$])

      circle((-4.75, -2.5), radius: 0.12, fill: white, stroke: black)
      content((-4.75, -2.9), text(size: 10pt)[$E$])

      // ===== ITERAZIONE 2: Dopo contrazione AB-C =====
      content((-4, -4), text(size: 11pt, weight: "bold")[Iterazione 2: $mr(A B"-"C)$ contratto])

      // Lati - evidenzio i prossimi lati da contrarre (due lati multipli ABC-D)
      bezier((-5, -5.5), (-3, -5.5), (-4, -5.2), stroke: 1.5pt + red) // ABC-D lato 1 (da contrarre)
      bezier((-5, -5.5), (-3, -5.5), (-4, -5.8), stroke: black) // ABC-D lato 2
      line((-3, -5.5), (-3, -7), stroke: black) // D-E
      line((-3, -7), (-5, -5.5), stroke: black) // E-ABC

      // Vertici
      circle((-5, -5.5), radius: 0.12, fill: white, stroke: black)
      content((-5.7, -5.5), text(size: 10pt)[$A B C$])

      circle((-3, -5.5), radius: 0.12, fill: white, stroke: black)
      content((-3, -5.1), text(size: 10pt)[$D$])

      circle((-3, -7), radius: 0.12, fill: white, stroke: black)
      content((-3, -7.4), text(size: 10pt)[$E$])

      // ===== ITERAZIONE 3: Dopo contrazione ABC-D =====
      content((-4, -8.5), text(size: 11pt, weight: "bold")[Iterazione 3: $mr(A B C"-"D)$ contratto])

      // Lati con multipli tra ABCD e E - evidenzio i lati da contrarre
      bezier((-5, -10), (-3, -10), (-4, -9.7), stroke: black) // ABCD-E lato 1
      bezier((-5, -10), (-3, -10), (-4, -10.3), stroke: 1.5pt + red) // ABCD-E lato 2 (da contrarre)

      // Vertici
      circle((-5, -10), radius: 0.12, fill: white, stroke: black)
      content((-5.8, -10), text(size: 10pt)[$A B C D$])

      circle((-3, -10), radius: 0.12, fill: white, stroke: black)
      content((-2.6, -10), text(size: 10pt)[$E$])

      // ===== RISULTATO FINALE =====
      content((-4, -12), text(size: 11pt, weight: "bold")[Risultato finale (2 vertici)])

      // Due lati multipli tra i due super-vertici
      bezier((-5, -13.5), (-3, -13.5), (-4, -13.2)) // lato superiore
      bezier((-5, -13.5), (-3, -13.5), (-4, -13.8)) // lato inferiore

      // Vertici finali
      circle((-5, -13.5), radius: 0.12, fill: white, stroke: black)
      content((-5.8, -13.5), text(size: 10pt)[$A B C D$])

      circle((-3, -13.5), radius: 0.12, fill: white, stroke: black)
      content((-2.6, -13.5), text(size: 10pt)[$E$])
    }),
    caption: [
      #v(1em)
      Esecuzione dell'algoritmo di Karger. A ogni iterazione viene evidenziato in $mr("rosso")$ il lato casuale che verrà contratto.
      Il taglio finale ha dimensione $2$, corrispondente ai due lati multipli tra i super-vertici finali.
      In questo caso, il taglio trovato è ottimo (non garantito).
    ],
  )
]

=== Correttezza dell'algoritmo

Sia:
- *$S^*$* la scelta di vertici che dà luogo al taglio più piccolo possibile
- *$k^*$* la dimensione del taglio minimo:
  $
    k^* = |E_(S^*)|, quad E_(S^*) = {e in E space "t.c." space e inter S^* != emptyset, space e inter S^*^c != emptyset }
  $
- *$G_i$* il grafo prima dell'$i$-esima contrazione

#teorema("Osservazione")[
  Il numero di vertici del grafo $G_i$ è:
  $ |V_(G_i)| quad = quad n_(G_i) quad = quad n-i+1 $

  #dimostrazione[
    Ad ogni contrazione uniamo due vertici, quindi il numero di vertici viene ridotto di $1$ ad ogni iterazione.
    Dato che siamo prima ($+1$) dell'$i$-esima iterazione e il grafo originale aveva $n$ vertici, allora abbiamo $n-i+1$ vertici. $qed$
  ]
]

#teorema("Osservazione")[
  Ogni taglio di $G_i$ corrisponde a un taglio di $G$ della stessa dimensione.
  Quindi il vertice di grado minimo di $G_i$ ha grado almeno grande quanto il taglio ottimo $k^*$.

  #dimostrazione[
    Prendendo un qualsiasi grafo, un suo taglio è un insieme di lati.
    Ma questi lati corrispondono perfettamente a dei lati del grafo originale.

    Gli unici lati persi dalla contrazione, per #link-teorema(<min-cut-lati-persi-contrazione>), sono lati che iniziano e finiscono su vertici che fanno parte della stessa partizione, ovvero che non sono interessati dal taglio.

    Di conseguenza qualsiasi taglio di $G_i$ corrisponde a un taglio di $G$ della stessa dimensione.
    Quindi continua a valere #link-teorema(<min-cut-taglio-minimo-grado>):
    $
      min_v d_(G_i)(v) quad >= quad k^*_(G_i) quad = quad k^*_G quad = quad k^* space qed
    $
  ]
] <min-cut-oss-2>

#teorema("Osservazione")[
  Sommando i gradi di tutti i vertici di $G_i$, per #link-teorema(<min-cut-oss-2>), ognuno è $>= k^*$:
  $
                        mr(sum_(v in V_(G_i)) d_(G_i)(v)) quad & >= quad k^* underbrace((n-i+1), "num vertici" G_i) \
    underbrace(mr(2 m_(G_i)), "ogni lato lo conto"\ 2 "volte") & >= quad k^* (n-i+1) \
                                                  m_(G_i) quad & >= quad (k^* (n-i+1))/2
  $
] <min-cut-oss-3>

Sia *$xi_i$* l'evento: "$"all'"i"-esima iterazione non si è contratto un lato di" E_(S^*)$".

#informalmente[
  $xi_i$ rappresenta la casistica in cui *nessun lato* della *soluzione ottima* è stato contratto all'$i$-esima iterazione.
  I lati della soluzione ottima vanno *preservati* per poter effettuare il taglio ottimo.
  Di conseguenza, l'evento $xi_i$ rappresenta una scelta casuale _fortunata_.
]

#teorema("Lemma")[
  La probabilità che all'$i$-esima iterazione nessun lato della soluzione ottima $E_(S^*)$ sia stato tagliato, condizionata al fatto che non sia successo prima, è:
  $ P[xi_i | xi_1, ..., xi_(i-1)] >= (n-i-1)/(n-i+1) $

  #dimostrazione[
    Invertiamo l'evento usando il complementare:
    $
      P[xi_i | xi_1, ..., xi_(i-1)] = 1 - P[not xi_i | xi_1, ..., xi_(i-1)]
    $

    La probabilità di contrarre un lato del taglio minimo è data dal rapporto:
    - casi favorevoli (tagliare un lato ottimo): $mb(k^*)$ lati nel taglio minimo
    - casi totali: $mr(m_(G_i))$ lati del grafo all'$i$-esima iterazione

    $ P[not xi_i | xi_1, ..., xi_(i-1)] = mb(k^*)/mr(m_(G_i)) $

    Per #link-teorema(<min-cut-oss-3>):

    $
      1 - mb(k^*)/mr(m_(G_i)) quad & >= quad 1 - (mb(k^*) dot mr(2))/mr(k^* (n-i+1)) \
                                   & = quad 1- 2/(n-i+1) \
                                   & = quad (n-i+1-2)/(n-i+1) \
                                   & = quad (n-i-1)/(n-i+1) space qed
    $
  ]
] <min-cut-lemma-p>

#teorema("Teorema")[
  L'algoritmo di Karger trova il *taglio minimo* con probabilità $>= 1/binom(n, 2) = 2/(n(n-1))$.

  #dimostrazione[
    Vogliamo dimostrare che durante l'esecuzione dell'algoritmo *non* vengano toccati i lati del taglio minimo:
    $
      P[xi_1 inter xi_2 inter ... inter xi_(n-2)] & underbrace(=, #link(<chain-rule>)[chain rule]) P[xi_1] dot P[xi_2 | xi_1] dot P[xi_3 | xi_1, xi_2] dots.c \
      & underbrace(>=, #link-teorema(<min-cut-lemma-p>)) (n-2)/n dot (n-3)/(n-1) dot ... dot 1/3 \
      & quad = quad (limits(product)_(i=1)^(n-2)i)/(limits(product)_(i=3)^n i) \
      & quad = quad (n-2)! / (mr(n!)/(2)) \
      & quad = quad (2 (n-2)!)/(mr((n-2)!(n-1)n)) \
      & quad = quad 2/(n(n-1)) \
      & quad = quad 1/binom(n, 2) space qed
    $
  ]

  #nota[
    L'algoritmo produce l'ottimo con una certa probabilità.

    Tuttavia, se l'algoritmo non trova la soluzione ottima, *non sappiamo* di quanto essa sia *distante dall'ottimo*.
  ]
]

#attenzione[
  La probabilità trovata è *molto piccola* (decresce in modo quadratico al crescere di $n$), di conseguenza l'algoritmo trova raramente l'ottimo.

  Possiamo però *iterare l'algoritmo*, in modo da far *crescere* la *probabilità* di trovare l'ottimo.
  Tra tutte le iterazioni prendiamo la soluzione migliore (minima).
]

#teorema("Corollario")[
  Eseguendo Karger $(binom(n, 2) ln n)$ volte, otteniamo il taglio minimo con probabilità $>= 1 - 1/n$.

  #dimostrazione[
    Ad ogni iterazione, la probabilità che l'algoritmo *non* trovi l'ottimo è:
    $ <= 1 - 1/binom(n, 2) $

    Eseguendo l'algoritmo $(binom(n, 2) ln n)$ volte indipendentemente, la probabilità che *tutte* le esecuzioni falliscano a trovare l'ottimo è:
    $
      <= (1 - 1/binom(n, 2))^(binom(n, 2) ln n)
    $

    Sfruttando la $mb("proprietà")$:
    $ mb(forall x >= 1\, quad 1/4 <= (1-1/x)^x <= 1/e) $

    Con $x = binom(n, 2)$:
    $
      <= (1 - 1/binom(n, 2))^(binom(n, 2) ln n) <= quad (1/e)^(ln n) quad <= quad 1/n
    $

    Siccome abbiamo calcolato un limite superiore alla probabilità che l'algoritmo *non* trova l'ottimo, la probabilità che *almeno una* esecuzione trovi l'ottimo è:
    $ >= 1-1/n space qed $
  ]
]

#informalmente[
  Perché l'algoritmo viene eseguito questo numero specifico di volte (polinomiale)?

  Perché in questo modo abbiamo una funzione di *probabilità* che *tende a $1$* per $n -> infinity$, quindi per $n$ grandi è quasi certo che l'algoritmo trovi l'ottimo.
]
