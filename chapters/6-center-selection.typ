#import "../imports.typ": *

= Problema Center Selection (Selezione dei centri) [NPOc]

#informalmente[
  Date delle _città_ (insieme di punti), vogliamo costruire dei _centri_, in modo da minimizzare la distanza massima da un punto al proprio _centro più vicino_.

  Il numero di centri deve rispettare un certo _budget_ $k$ a disposizione.
]

Alla base del problema vi è la definizione di *spazio metrico*, dati:
- $Omega$, insieme di punti
- $d: Omega times Omega -> bb(R)$, funzione di distanza che associa ad ogni coppia di punti una distanza

Lo spazio dei punti $Omega$ si dice spazio metrico sse $forall x,y,z in Omega$, valgono le *proprietà*:
1. $d(x,y) >= 0$ e $d(x,y) = d(y,x)$: distanza non negativa e simmetria
2. $d(x,y) = 0 space <==> space x=y$: identità
3. $d(x,z) + d(z,y) >= d(x,y)$, *disuguaglianza triangolare*, ovvero la distanza percorsa per andare da $x$ a $y$ passando per un punto intermedio $z$ è sicuramente maggiore o uguale rispetto alla via diretta

#esempio[
  Lo spazio euclideo $n$-dimensionale $(R^n,d)$ è uno spazio metrico, dove $d$ è la distanza Euclidea:
  $ d(x,y) = sqrt(sum_(i=1)^n (x_i-y_i)^2) $

  Anche lo spazio di Manhattan $(bb(N)^n, d_"man")$ è uno spazio metrico, con $d$:
  $ d_("man")(x,y) = sum_(i=1)^n |x_i-y_i| $
]

Possiamo ora definire il problema *Center Selection*:
- $I_Pi$:
  - _$(Omega, d)$: spazio metrico (questo input è spesso sottointeso)_
  - $S subset.eq Omega$: insieme dei punti sullo spazio metrico
  - $k in bb(N)^+$: budget da rispettare
- $"Amm"_(Pi): C subset.eq S "t.c." |C| <= k$: sottoinsieme di punti (i centri) che rispettano il budget.
- Funzione obiettovo: la distanza massima tra un punto e il proprio *centro di riferimento* (il centro più vicino). Formalmente:
  - definita la distanza tra un punto e il centro più vicino:
  $ rho(x, C) = min_(c in C) d(x,c), quad forall x in S $
  - fissiamo la funzione obiettivo come il massimo di queste distanze:
  $ rho(C) = max_(x in S) rho(x, c) = "raggio di copertura di" C $
- $t_Pi = min$

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Define centers and points
    let centers = ((2, 2.5), (4, 2.5), (3, 4))
    let colors = (red, blue, green)

    // Define points and their assignments to centers
    let points_assignments = (
      ((1.2, 1.8), 0), // Point assigned to center 1
      ((1.5, 3.2), 0), // Point assigned to center 1
      ((5.5, 1.9), 1), // Point assigned to center 2
      ((4.5, 3.1), 1), // Point assigned to center 2
      ((2.8, 4.6), 2), // Point assigned to center 3
      ((3.5, 3.5), 2), // Point assigned to center 3
    )

    // Calculate actual radius for each center (distance to farthest assigned point)
    let radii = ()
    for (i, center) in centers.enumerate() {
      let max_dist = 0
      for (point, assignment) in points_assignments {
        if assignment == i {
          let dist = calc.sqrt(calc.pow(point.at(0) - center.at(0), 2) + calc.pow(point.at(1) - center.at(1), 2))
          max_dist = calc.max(max_dist, dist)
        }
      }
      radii.push(max_dist)
    }

    // Draw circles representing the actual coverage radius of each center
    for (i, center) in centers.enumerate() {
      circle(center, radius: radii.at(i), stroke: colors.at(i).darken(20%), fill: colors.at(i).transparentize(85%))
    }

    // Draw centers
    for (i, center) in centers.enumerate() {
      circle(center, radius: 0.12, fill: colors.at(i), stroke: none)
      content((center.at(0), center.at(1) - 0.3), anchor: "north", [$c_#(i + 1)$], fill: colors.at(i))
      // Add radius labels with actual calculated values
      content((center.at(0) + radii.at(i) * 0.5, center.at(1) + radii.at(i) * 0.5), anchor: "east", text(
        size: 0.8em,
        fill: colors.at(i).darken(30%),
        [$r_#(i + 1) = #calc.round(radii.at(i), digits: 2)$],
      ))
    }

    // Draw points
    for (point, assignment) in points_assignments {
      circle(point, radius: 0.06, fill: black)
    }

    // Draw dashed lines from points to their assigned centers
    for (point, assignment) in points_assignments {
      line(point, centers.at(assignment), stroke: (dash: "dashed", paint: black, thickness: 0.6pt))
    }
  }),
  caption: [Esempio di selezione dei centri con $k=3$. Ogni centro $c_i$ ha un raggio di copertura $rho = r_i$ che rappresenta la distanza esatta dal centro al punto più lontano nella sua area di copertura.\ L'output di questa istanza del problema è $1.62$.],
)

#nota[
  Questo problema è strettamente legato al concetto di *partizione di Voronoi*, ovvero una partizione del piano in insiemi disgiunti che fanno riferimento allo *stesso centro*.
  Ogni insieme prende il nome di *cella di Voronoi*.

  Il numero di partizioni dello spazio corrisponde al numero di centri inseriti $k$.

  #figure(
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // Define centers
      let centers = ((1.5, 1.5), (3.5, 1.5), (2.5, 3.5))
      let colors = (red, blue, green)

      // Draw bounding rectangle
      rect((0, 0), (5, 4.5), stroke: black, fill: none)

      // Draw Voronoi cells (simplified polygonal regions)
      // Cell 1 (red center)
      line((0, 0), (2.5, 0), (2.5, 2.5), (0, 3), (0, 0), fill: red.transparentize(80%), stroke: red)

      // Cell 2 (blue center)
      line((2.5, 0), (5, 0), (5, 2.8), (3.8, 2.8), (2.5, 2.5), (2.5, 0), fill: blue.transparentize(80%), stroke: blue)

      // Cell 3 (green center)
      line(
        (0, 3),
        (2.5, 2.5),
        (3.8, 2.8),
        (5, 2.8),
        (5, 4.5),
        (0, 4.5),
        (0, 3),
        fill: green.transparentize(80%),
        stroke: green,
      )

      // Draw centers
      for (i, center) in centers.enumerate() {
        circle(center, radius: 0.12, fill: colors.at(i), stroke: none)
        content(center, anchor: "south", [$c_#(i + 1)$], padding: 0.15)
      }

      // Draw some example points
      let points = ((0.8, 1.2), (3.8, 1.0), (1.8, 3.8), (4.2, 3.2))
      for point in points {
        circle(point, radius: 0.06, fill: black)
      }

      // Draw dashed lines from points to their nearest centers
      line((0.8, 1.2), (1.5, 1.5), stroke: (dash: "dashed", paint: black, thickness: 0.6pt))
      line((3.8, 1.0), (3.5, 1.5), stroke: (dash: "dashed", paint: black, thickness: 0.6pt))
      line((1.8, 3.8), (2.5, 3.5), stroke: (dash: "dashed", paint: black, thickness: 0.6pt))
      line((4.2, 3.2), (2.5, 3.5), stroke: (dash: "dashed", paint: black, thickness: 0.6pt))
    }),
    caption: [Esempio di una partizione di Voronoi con 3 centri.],
  )
]

#teorema("Teorema")[
  *$ "CenterSelection" in "NPOc" $*
]

== Algoritmo CenterSelectionPlus

#attenzione[
  Per arrivare ad un algoritmo per CenterSelection, andremo a presentare una variante semplificata, ovvero l'algorimto CenterSelectionPlus.

  Questa versione presenta un input in più: $r in bb(R)^+$, il *raggio di copertura*.

  #informalmente[
    Questo input $r$ è un _suggerimento_ che andremo ad usare per selezionare i centri, ma che non avremo a disposizione nell'algoritmo generale.
  ]
]

#pseudocode(
  [Input: $S subset.eq Omega$, $k in bb(N)^+, r in bb(R^+)$],
  [$C <- emptyset$],
  [*While* $S eq.not emptyset$],
  indent(
    [$hat(s) <-$ take any $in S$ #emph("// selezionare punto a caso")],
    [$C <- C union {hat(s)}$ #emph("// diventa un centro")],
    [remove from $S$ all $x "t.c." d(x,hat(s))<=2r$ #emph("// rimuovere tutti i punti che stanno in un raggio " + $2r$ + " da " + $hat(s)$)],
  ),
  [*If* $|C| > k$ *then* #emph("// troppi centri, budget sforato")],
  indent([*Output* "impossibile"]),
  [*Else*],
  indent([*Output* $C$]),
  [*End*],
)

#nota[
  Il comportamento dell'algoritmo è influenzato dalla scelta del *parametro $r$*:
  - se $r$ è *grande*, l'algoritmo produce quasi sicuramente una *soluzione* che rispetta il budget (ad ogni passo cancello tanti punti dato che il raggio è molto grosso)
  - se $r$ è *piccolo*, l'algorimto trova delle soluzioni migliori (raggio più piccolo) ma che potrebbero *sforare* il budget a disposizione (dato che meno punti verranno coperti), rendendole non ammissibili
]

#attenzione[
  L'algorimto di $"CenterSelectionPlus"$ gode della proprietà di *arbitrarietà*: in alcuni punti può effettuare delle *scelte casuali* (ad esempio non viene specificato come vengono scelti i punti $hat(s)$).

  Quando si implementa un algoritmo arbitrario, bisogna prendere delle _decisioni_ in questi punti di arbitrarietà.

  Le analisi dell'algoritmo vengono fatte *indipendentemente* dalle scelte arbitrarie effettuate.
]

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Define radius parameter r
    let r = 1.1

    // Define optimal centers positioned to cover all points with radius r
    let optimal_centers = ((2.0, 2.8), (4.2, 2.2))

    // Define centers selected by the algorithm (non-optimal positions)
    let centers = ((1.5, 3.2), (4.8, 1.8))
    let colors = (red, blue)

    // All points in the space - positioned to be covered by optimal centers
    let all_points = (
      (1.2, 2.2), // covered by optimal center 1
      (2.8, 2.5), // covered by optimal center 1
      (1.8, 3.7), // covered by optimal center 1
      (2.6, 1.9), // covered by optimal center 1
      (3.5, 1.8), // covered by optimal center 2
      (4.9, 2.8), // covered by optimal center 2
      (4.5, 1.2), // covered by optimal center 2
      (3.7, 3.0), // covered by optimal center 2
    )

    // Points that get removed (within 2r of algorithm centers)
    let removed_points = (
      (1.2, 2.2),
      (2.8, 2.5),
      (1.8, 3.7),
      (4.9, 2.8),
      (4.5, 1.2),
      (3.7, 3.0),
    )

    // Draw optimal solution coverage (r radius) for comparison
    for (i, opt_center) in optimal_centers.enumerate() {
      circle(
        opt_center,
        radius: r,
        stroke: (paint: green, thickness: 0.8pt),
        fill: green.transparentize(95%),
      )
      circle(opt_center, radius: 0.08, fill: green, stroke: none)
      content((opt_center.at(0), opt_center.at(1) + 0.2), anchor: "south", text(
        size: 0.6em,
        fill: green,
        [$c^*_#(i + 1)$],
      ))
    }

    // Draw 2r circles around each algorithm center (removal zones)
    for (i, center) in centers.enumerate() {
      circle(
        center,
        radius: 2 * r,
        stroke: (paint: colors.at(i), dash: "dashed", thickness: 1.5pt),
        fill: colors.at(i).transparentize(90%),
      )

      // Label the radius
      content((center.at(0) + 1.3 * r, center.at(1) + 1.3 * r), anchor: "west", text(
        size: 0.7em,
        fill: colors.at(i).darken(30%),
        [$2r$],
      ))
    }

    // Draw algorithm centers
    for (i, center) in centers.enumerate() {
      circle(center, radius: 0.12, fill: colors.at(i), stroke: none)
      content((center.at(0), center.at(1) - 0.25), anchor: "north", text(fill: colors.at(i), [$hat(s)_#(i + 1)$]))
    }

    // Draw removed points (grayed out)
    for point in removed_points {
      circle(point, radius: 0.06, fill: black, stroke: none)

      // Draw dashed line to nearest algorithm center
      let min_dist = 999
      let nearest_center = centers.at(0)
      for center in centers {
        let dist = calc.sqrt(calc.pow(point.at(0) - center.at(0), 2) + calc.pow(point.at(1) - center.at(1), 2))
        if dist < min_dist {
          min_dist = dist
          nearest_center = center
        }
      }
      line(point, nearest_center, stroke: (dash: "dashed", paint: black, thickness: 0.6pt))
    }
  }),
  caption: [
    Esempio di esecuzione di CenterSelectionPlus con $k=2$. \
    I cerchi #text(fill: green)[verdi] mostrano i centri ottimi $c^*_i$ che, con raggio $r$, coprono tutti i punti. \
    I centri $hat(s)_i$ (#text(fill: red)[rosso]/#text(fill: blue)[blu]) sono scelti dall'algoritmo in posizioni non ottimali, nonostante ciò, grazie all'utilizzo di raggio $2r$, coprono tutti i punti.
  ],
)

#teorema("Teorema")[
  Se l'algoritmo $"CenterSelectionPlus"$ emette un output, esso è una $(2r)/rho^*"-approssimazione"$ per $"CenterSelection"$.

  #nota[
    Se viene emesso un ouput, allora è sicuramente ammissibile (dato che viene emesso solo se $|C| < k$).
  ]

  #dimostrazione[
    Se la soluzione è ammissibile, allora $forall s in S$, $s$ deve essere stato cancellato, quindi esiste un centro $overline(s)$ nel raggio $2r$:
    $ forall s in S, quad exists overline(s) in C quad "t.c." quad d(s,overline(s))<=2r $
    Quindi il raggio di copertura di ogni centro è $<= 2r$:
    $
            rho(C) & <= 2r \
      rho(C) / p^* & <= (2r) / p^* space qed
    $

    #nota[
      Si può osservare come il tasso di approssimazione *decresce* al decrescere di $r$, tuttavia $r$ non può essere ridotto all'infinito.
    ]
  ]
]

#teorema("Teorema")[
  Se $r >= rho^*$, $"CenterSelectionPlus"$ *emette* sicuramente un output.

  #dimostrazione[
    Sia $C^*$ una soluzione ottima, ovvero $rho(C^*) = rho^*$, il minor *raggio di copertura* possibile.
    Supponiamo di conoscere il valore di $rho^*$ e di eseguire l'algorimto $"CenterSelectionPlus"$ con $r >= p^*$.

    #teorema("Osservazione 1")[
      Sia $mb(s')$ un punto che nella soluzione ottima si rivolge allo stesso centro $mg(hat(c)^*)$ a cui si rivolge $mr(overline(s))$.
      Quando viene selezionato $mr(overline(s))$, viene cancellato anche $mb(s')$ _(ovviamente a meno che non fosse già stato cancellato)_.

      In altre parole, quando viene selezionato un *qualsiasi* punto che si rivolge allo stesso centro ottimo $mg(hat(c)^*)$, vengono cancellati almeno tutti i punti che appartenevano alla stessa cella di Voronoi di $mg(hat(c)^*)$.

      #dimostrazione()[
        Usando la disuguaglianza tringolare:
        $
          d(mb(s'), mr(overline(s))) <= underbrace(d(mb(s'), mg(hat(c)^*)), <= rho^*) + underbrace(d(mr(overline(s)), mg(hat(c)^*)), <=rho^*) <= 2rho^*
        $

        Ma per ipotesi $r >= rho^*$, di conseguenza:
        $ 2rho^* >= 2r space qed $
      ]

      #figure(
        cetz.canvas(length: 0.6cm, {
          import cetz.draw: *

          // Define the three equidistant points
          let points = ((1, 2), (3, 2), (5, 2))
          let r = 2

          // Circle coverages (r and 2r radius)
          circle(points.at(0), radius: 2 * r, stroke: (paint: red, dash: "dashed"), fill: red.transparentize(90%))
          circle(points.at(1), radius: r, stroke: green, fill: green.transparentize(85%))

          // Show radius r
          line(points.at(1), (points.at(1).at(0) + r, points.at(1).at(1)), stroke: green)
          content((points.at(1).at(0) + r / 2, points.at(1).at(1) + 0.15), anchor: "south", text(
            fill: green,
            size: 1em,
            [$r$],
          ))

          // Show radius 2r
          line(points.at(0), (points.at(0).at(0) + 1.72 * r, points.at(0).at(1) + 2), stroke: red)
          content((points.at(0).at(0) + r, points.at(0).at(1) + 1.8), anchor: "north", text(
            fill: red,
            size: 1em,
            [$2r$],
          ))

          // Points
          circle(points.at(1), radius: 0.10, fill: green, stroke: none)
          circle(points.at(0), radius: 0.10, fill: red, stroke: none)
          circle(points.at(2), radius: 0.10, fill: blue, stroke: none)

          // Labels
          content((points.at(1).at(0) - 0.5, points.at(1).at(1)), anchor: "center", text(fill: green, [$c^*$]))
          content((points.at(0).at(0) - 0.5, points.at(0).at(1)), anchor: "center", text(fill: red, [$overline(s)$]))
          content((points.at(2).at(0) + 0.25, points.at(1).at(1)), anchor: "west", text(fill: blue, [$s'$]))
        }),
        caption: [
          Esempio di una cella di Voronoi.
          Scegliendo il centro ottimo $mg(c^*)$, tutti i punti sarebbero coperti con raggio $mg(r)$.
          Scegliendo qualsiasi altro punto della cella, ad esempio $mr(overline(s))$, con raggio doppio $mr(2r)$, vengono ugualmente coperti tutti i punti.
        ],
      )
    ]

    Riassumendo i passi:
    - ad ogni iterazione viene cancellata un *intera cella di Voronoi* della soluzione ottima, a prescindere che il centro scelto sia quello ottimo o meno
    - siccome nella soluzione ottima $C^*$ ci sono *al massimo* $k$ celle di Voronoi, dopo $k$ iterazione non ci sono più punti in $S$
    - $|C| <= k$, output ammissibile
  ]
]

Comportamento dell'algoritmo $"CenterSelectionPlus"$ al variare di $r$:
- *$r>=rho^*$*: otteniamo una soluzione $(2r)/rho^*"-approssimata"$, con un $r$ _troppo_ grande l'approssimazione peggiora
- *$r=rho^*$*: otteniamo una $2"-approssimazione"$
- *$(rho^*)/2 < r < rho^*$*: l'algoritmo potrebbe emettere un ottima approssimazione, ma potrebbe anche non emettere una soluzione (o meglio, trovarne una non ammissibile)
- *$r < (rho^*)/2$*: l'algorimto *non* emette soluzione, altrimenti otteremmo una soluzione migliore dell'ottimo (impossibile): $(2r)/rho^* < (2((rho^*)/2))/rho^* <= 1$

#informalmente[
  Più $r$ è piccolo, migliore sarà l'approssimazione. Se $r$ scendo sotto $rho^*$ l'algoritmo potrebbe non emettere soluzione (ma in caso la emetta sarebbe molto buona).
  Se $r$ scende ulteriormente sotto $rho^* / 2$, allora è impossibile che emetta soluzione.
]

== Algoritmo GreedyCenterSelection

#pseudocode(
  [*input*: $s subset.eq Omega, k in bb(N)^+$],
  [*if* $|S| <= k$],
  indent(
    [*output* $S$],
    [*stop*],
  ),
  [choose any $hat(s) in S$],
  [#emph("scelta arbitraria")],
  [$C <- union {hat(s)}$],
  [*while* $|C| < k$],
  indent(
    [select $hat(s)$ maximizing $d(s,C)$],
    [#emph("scelgo il punto " + $hat(s)$ + " più distante da tutti i centri")],
    [$C <- union {hat(s)}$],
  ),
  [*output* $C$],
  [*end*],
)

#nota()[
  *L'algorimto appena presentato è molto simile a $"GreddyCenterSelectionPlus"$*.\
  Basta non elliminare i punti in $"GreddyCenterSelectionPlus"$, ma semplicemente non considerarli.\
  Inolte differiscono nella logica di selezione dei nuovi centri:
  - $"GreedyCenterSelectionPlus"$= sceglie come nuovi centri i punti che si trovano "abbastanza lontani" dai centri già selezionati
  - $"GreddyCenterSelection"$= seleziona come nuovo centro il punto più distante da tutti gli altri centri già selezionati
]

#teorema("Teorema")[
  *L'esecuzione di $"GreedyCenterSelection"$ è una delle possibili esecuzioni di $"CenterSelectionPlus"$, quando $r = rho^*$*
]
#dimostrazione()[
  Supponiamo di *modificare $"GreedyCenterSelectionPlus"$* nel seguente modo:
  #grid(
    columns: (1fr, 1fr),
    gutter: 16pt,
    [
      #align(center)[*CenterSelectionPlus Algo1*]
      #pseudocode(
        [Input: $S subset.eq Omega, k in bb(N)^+, mr(r = rho^*)$],
        [$C <- emptyset$],
        [*while* $mr(exists s quad d(s,C) > 2r)$],
        indent(
          [$overline(s) <-$ take any $mr(hat(s) in S)$ such that $mr(max_(s in S) d(overline(s),C) > 2r)$],
          [$C <- C union {overline(s)}$],
        ),
        [*if* $|C| > k$],
        indent(
          [*output* "impossibile"],
        ),
        [*else*],
        indent(
          [*output* $C$],
        ),
      )
    ],
    [
      #align(center)[*GreedyCenterSelection Algo2*]
      #pseudocode(
        [Input: $S subset.eq Omega, k in bb(N)^+$],
        [*if* $|S| <= k$],
        indent(
          [*output* $S$],
          [*stop*],
        ),
        [choose any $overline(s) in S$],
        [$C <- {overline(s)}$],
        [*while* $|C| < k$],
        indent(
          [select $overline(s)$ maximizing $d(s,C)$],
          [$C <- C union {overline(s)}$],
        ),
        [*output* $C$],
      )
    ],
  )
  L'idea è quella di *ridurre l'arbitrarietà dell'algorimto $"Algo1"$*.\
  *Scelgo come centro il punto $overline(s) in S$ che massimizza $d(overline(s),C)$*, a parità di distanze scelgo il primo punto in ordine lessicografico.

  Per *assurdo* suppungo che i due algoritmi selezionino due punti *$overline(s)^',overline(s)^'' "t.c" overline(s)^' != overline(s)^''$*:
  - *Algo1* seleziona *$overline(s)^'$*
  - *Algo2* seleziona *$overline(s)^''$*

  Siccome *Algo2* seleziona in punto *$overline(s)^''$* come il più distante in assoluto, è *per forza più lontano di $overline(s)^'$* (il punto *$overline(s)^'>2r$*, siccome è stato selezionato da *Algo1*):
  *$ d(overline(s)^'',C) >= d(overline(s)^', C) > 2r $*

  Di conseguenza anche *$overline(s)^''$ sarebbe sceglibile da Algo1*, senza violare nessun vincolo.\
  Affinchè *Algo1* scelga $overline(s)^'$ invece di $overline(s)^''$, devono essere vere entrambe le condizioni:
  - $d(overline(s)^'', C) "non può essere" > d(overline(s)^',C)$, altrimenti Algo1 avrebbe scelto $overline(s)^''$ (sceglie il punto che massimizza $d(hat(s)^',C)$)
  - $d(overline(s)^'', C) "non può essere" < d(overline(s)^', C)$, perché Algo2 sceglie sempre il massimo

  Di conseguenza, *l'unico modo per cui i due algorimti scelgano dei punti diversi è a parità di distanza*:
  *$ d(overline(s)^',C) = d(overline(s)^'',C) $*
  Ma dato che *a partià di distanza i due algorimti scelgono il primo punto in ordine lessicografico i punti $overline(s)^'$ e $overline(s)^''$ sono uguali*

]



