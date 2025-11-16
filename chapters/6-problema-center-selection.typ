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
- *$I_Pi$*:
  - _$(Omega, d)$: spazio metrico (questo input è spesso sottointeso)_
  - $S subset.eq Omega$: insieme dei punti sullo spazio metrico
  - $k in bb(N)^+$: budget da rispettare
- *$"Amm"_(Pi)$*: $C subset.eq S "t.c." |C| <= k$: sottoinsieme di punti (i centri) che rispettano il budget.
- *Funzione obiettivo*: la distanza massima tra un punto e il proprio *centro di riferimento* (il centro più vicino). Formalmente:
  - definita la distanza tra un punto e il centro più vicino:
  $ rho(x, C) = min_(c in C) d(x,c), quad forall x in S $
  - fissiamo la funzione obiettivo come il massimo di queste distanze:
  $ rho(C) = max_(x in S) rho(x, C) = "raggio di copertura di" C $
- *$t_Pi = min$*

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
  caption: [Esempio di selezione dei centri con $k=3$. Ogni centro $c_i$ ha un raggio di copertura $rho = r_i$ che rappresenta la distanza esatta dal centro al punto più lontano nella sua area di copertura.\ L'output di questa istanza del problema è $rho(C) = 1.62$.],
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
  Per arrivare ad un algoritmo per CenterSelection, andremo a presentare una variante semplificata, ovvero l'algoritmo CenterSelectionPlus.

  Questa versione presenta un input in più: $r in bb(R)^+$, il *raggio di copertura*.

  #informalmente[
    Questo input $r$ è un _suggerimento_ che andremo ad usare per selezionare i centri, ma che non avremo a disposizione nell'algoritmo generale.
  ]
]

#pseudocode(
  [input $<- S subset.eq Omega$, $k in bb(N)^+, r in bb(R)^+$],
  [$C <- emptyset$],
  [*While* $S eq.not emptyset$ *do*],
  indent(
    [$hat(s) <-$ take any $in S$ #emph("// selezionare punto a caso")],
    [$C <- C union {hat(s)}$ #emph("// diventa un centro")],
    [remove from $S$ all $x "t.c." d(x,hat(s))<=2r$ #emph("// rimuovere tutti i punti che stanno in un raggio " + $2r$ + " da " + $hat(s)$)],
  ),
  [*If* $|C| > k$ *then* #emph("// troppi centri, budget sforato")],
  indent([*Output* "impossibile"]),
  [*Else*],
  indent([*Output* $C$]),
)

#nota[
  Il comportamento dell'algoritmo è influenzato dalla scelta del *parametro $r$*:
  - se $r$ è *grande*, l'algoritmo produce quasi sicuramente una *soluzione* che rispetta il budget (ad ogni passo cancello tanti punti dato che il raggio è molto grosso)
  - se $r$ è *piccolo*, l'algoritmo trova delle soluzioni migliori (raggio più piccolo) ma che potrebbero *sforare* il budget a disposizione (dato che meno punti verranno coperti), rendendole non ammissibili
]

#attenzione[
  L'algoritmo di $"CenterSelectionPlus"$ gode della proprietà di *arbitrarietà*: in alcuni punti può effettuare delle *scelte casuali* (ad esempio non viene specificato come vengono scelti i punti $hat(s)$).

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
    Se viene emesso un output, allora è sicuramente ammissibile (dato che viene emesso solo se $|C| <= k$).
  ]

  #dimostrazione[
    Se la soluzione è ammissibile, allora $forall s in S$, $s$ deve essere stato cancellato, quindi esiste un centro $overline(s)$ nel raggio $2r$:
    $ forall s in S, quad exists overline(s) in C quad "t.c." quad d(s,overline(s))<=2r $
    Quindi il raggio di copertura di ogni centro è $<= 2r$:
    $
              rho(C) & <= 2r \
      rho(C) / rho^* & <= (2r) / rho^* space qed
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
    Supponiamo di conoscere il valore di $rho^*$ e di eseguire l'algoritmo $"CenterSelectionPlus"$ con $r >= rho^*$.

    #teorema("Osservazione 1")[
      Sia $mb(s')$ un punto che nella soluzione ottima si rivolge allo stesso centro $mg(hat(c)^*)$ a cui si rivolge $mr(overline(s))$.
      Quando viene selezionato $mr(overline(s))$, viene cancellato anche $mb(s')$ _(ovviamente a meno che non fosse già stato cancellato)_.

      In altre parole, quando viene selezionato un *qualsiasi* punto che si rivolge allo stesso centro ottimo $mg(hat(c)^*)$, vengono cancellati almeno tutti i punti che appartenevano alla stessa cella di Voronoi di $mg(hat(c)^*)$.

      #dimostrazione()[
        Usando la disuguaglianza triangolare:
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
          line(points.at(1), (points.at(1).at(0) + r - 0.1, points.at(1).at(1) + 0.7), stroke: green)
          content((points.at(1).at(0) + r / 2, points.at(1).at(1) + 0.5), anchor: "south", text(
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
    - ad ogni iterazione viene cancellata un'*intera cella di Voronoi* della soluzione ottima, a prescindere che il centro scelto sia quello ottimo o meno
    - siccome nella soluzione ottima $C^*$ ci sono *al massimo* $k$ celle di Voronoi, dopo $k$ iterazioni non ci sono più punti in $S$
    - $|C| <= k$, output ammissibile
  ]
]

Comportamento dell'algoritmo $"CenterSelectionPlus"$ al variare di $r$:
- *$r>=rho^*$*: otteniamo una soluzione $(2r)/rho^*"-approssimata"$, con un $r$ _troppo_ grande l'approssimazione peggiora
- *$r=rho^*$*: otteniamo una $2"-approssimazione"$
- *$(rho^*)/2 < r < rho^*$*: l'algoritmo potrebbe emettere un'ottima approssimazione, ma potrebbe anche non emettere una soluzione (o meglio, trovarne una non ammissibile)
- *$r < (rho^*)/2$*: l'algoritmo *non* emette soluzione, altrimenti otterremmo una soluzione migliore dell'ottimo (impossibile): $(2r)/rho^* < (2((rho^*)/2))/rho^* <= 1$

#informalmente[
  Più $r$ è piccolo, migliore sarà l'approssimazione. Se $r$ scende sotto $rho^*$ l'algoritmo potrebbe non emettere soluzione (ma in caso la emetta sarebbe molto buona).
  Se $r$ scende ulteriormente sotto $rho^* / 2$, allora è impossibile che emetta soluzione.
]

== Algoritmo GreedyCenterSelection [$2$-APX]

#pseudocode(
  [input $<- S subset.eq Omega, k in bb(N)^+$],
  [*If* $|S| <= k$ *then* #emph("// budget abbastanza grande da rendere ogni punto un centro, " + $rho = 0$)],
  indent(
    [*Output* $S$],
    [*Stop*],
  ),
  [$overline(s) <-$ choose any $in S$ #emph("// scelta arbitraria")],
  [$C <- union {overline(s)}$],
  [*While* $|C| < k$ *do*],
  indent(
    [select $overline(s)$ maximizing $d(s,C)$ #emph("// scegliere il punto " + $overline(s)$ + " più distante da tutti i centri")],
    [$C <- union {overline(s)}$ #emph("// farlo diventare centro")],
  ),
  [*Output* $C$],
)

#nota()[
  L'algoritmo appena presentato è *molto simile* a $"CenterSelectionPlus"$.

  La differenza principale è che $"Plus"$ cancella i punti nel raggio, $"Greedy"$ no.
  Si può riformulare $"Plus"$ facendo in modo che non cancelli, ma semplicemente scelga il prossimo centro fuori dal raggio dei centri già esistenti.

  Ora la differenza si riduce a:
  - $"Plus"$: seleziona il prossimo centro come _abbastanza lontano_ dai centri già selezionati
  - $"Greedy"$: seleziona il prossimo centro come _il più lontano_ dai centri già selezionati
]

#teorema("Proprietà")[
  L'esecuzione di $"GreedyCenterSelection"$ è una delle *possibili esecuzioni* di $"CenterSelectionPlus"$, quando $r = rho^*$.

  #dimostrazione()[
    Supponiamo di modificare $"CenterSelectionPlus"$ nel seguente modo:
    #grid(
      columns: (1fr, 1fr),
      gutter: 16pt,
      [
        #align(center)[*CenterSelectionPlus V1*]
        #pseudocode(
          [input $<- S subset.eq Omega$, $k in bb(N)^+, r in bb(R^+)$],
          [$C <- emptyset$],
          [*While* $S eq.not emptyset$ *do*],
          indent(
            [$overline(s) <-$ take any $in S$ ],
            [$C <- C union {overline(s)}$],
            [remove from $S$ all $x "t.c." d(x,overline(s))<=2r$],
          ),
          [*If* $|C| > k$ *then*],
          indent([*Output* "impossibile"]),
          [*Else*],
          indent([*Output* $C$]),
        )
      ],
      [
        #align(center)[*CenterSelectionPlus V2*]
        #pseudocode(
          [input $<- S subset.eq Omega, k in bb(N)^+, mr(r = rho^*)$],
          [$C <- emptyset$],
          [*While* $mr(exists s quad d(s,C) > 2r)$ *do*],
          indent(
            [$mr(overline(s)) <-$ take any $mr(in S)$ that $mr(limits(max)_(s in S) d(overline(s),C))$],
            [$C <- C union {overline(s)}$],
          ),
          [*If* $|C| > k$ *then*],
          indent(
            [*Output* "impossibile"],
          ),
          [*Else*],
          indent(
            [*Output* $C$],
          ),
        )
      ],
    )
    // TODO: questa dimostrazione funziona, ma non mi sembra molto formale

    L'idea è quella di *ridurre l'arbitrarietà* dell'algoritmo V1.

    Al posto di scegliere come punto $overline(s)$ un *qualsiasi punto* fuori dal raggio $2r$ del centro, andiamo a scegliere il *più distante* in assoluto ($limits(max)_(s in S) d(overline(s),C)$).
    In caso di parità di distanza viene scelto il più piccolo lessicograficamente.

    Per *assurdo* suppongo che i due algoritmi selezionino due punti diversi $overline(s)^' != overline(s)^''$:
    - *V1* seleziona $overline(s)^'$
    - *V2* seleziona $overline(s)^''$

    Siccome *V2* seleziona il punto $overline(s)^''$ come il *più distante* in assoluto, è per forza più lontano di $overline(s)^'$.
    Siccome *V1* seleziona il punto $overline(s)^'$ scartando quelli già coperti, il punto è per forza $> 2r$:
    $ d(overline(s)^'',C) >= d(overline(s)^', C) > 2r $

    Di conseguenza anche $overline(s)^''$ sarebbe sceglibile da *V1*, senza violare nessun vincolo.

    Viceversa, affinchè *V2* scelga $overline(s)^'$, deve per forza essere il caso: $ d(overline(s)^'',C) = d(overline(s)^', C) $

    Di conseguenza, l'unico modo per cui i due algoritmi scelgano dei punti diversi è a parità di distanza:
    $ d(overline(s)^',C) = d(overline(s)^'',C) $

    Ma dato che a parità di distanza i due algorimti scelgono il primo punto in ordine lessicografico, vuol dire che hanno scelto lo stesso punto. $overline(s)^'$ e $overline(s)^''$ sono uguali.

    Ma dato che aveamo supposto $overline(s)^'!=overline(s)^''$, questo è un assurdo. La versione 2 (*V2*) dell'algoritmo non è altro che la versione $"Greedy"$, $qed$.

    #informalmente[
      Abbiamo dimostrato che ogni possibile esecuzione dell'algoritmo $"Greedy"$ è anche una possibile esecuzione di $"Plus"$ (a cui è stata tolta l'arbitrarietà):
      $ "Greedy" subset.eq "Plus" $
      Di conseguenza tutte le proprietà di $"Plus"$ valgono anche per l'algoritmo $"Greedy"$.
    ]
  ]
] <greedy-center-selection-esecuzione-center-selection-plus>

#teorema("Corollario")[
  *$ "GreedyCenterSelection" in 2"-APX" $*
]

=== Tecnica della Simulazione

#nota[
  La dimostrazione appena mostrata (#link-teorema(<greedy-center-selection-esecuzione-center-selection-plus>)) utilizza la *tecnica della simulazione* (o tecnica della *restrizione/rilassamento*), che merita un approfondimento.
]

Se tra due algoritmi esistono delle tracce di esecuzione (ovvero delle _esecuzioni_) in comune, allora, per quelle tracce valgono le _proprietà_ di entrambi gli algoritmi contemporaneamente.

#attenzione[
  Le proprietà valgono solo per le tracce in comune, non sempre!
]

Nel caso in cui tutte le possibili esecuzioni di un algoritmo $A$ siano anche possibili tracce di $A'$, allora tutte le proprietà di $A'$ valgono anche per $A$.
Questo è il caso della dimostrazione precedente, dove $"Greedy" subset.eq "Plus"$.

#informalmente[
  Quasi sempre si dimostra che un algoritmo che compie scelte deterministiche sia una possibile esecuzione (una _sola_ traccia per input) di un algoritmo con scelte arbitrarie (_molteplici_ tracce per input). Ancora, esattamente come il caso precedente.
]

== Dominating Set [NPc] <dominating-set>

#nota[
  Per dimostrare il teorema #link-teorema(<teorema-inapprossimabilita-centerselection>),
  abbiamo bisogno di introdurre il problema di decisone *Dominating Set*.
]

#informalmente[
  Ogni vertice del grafo deve essere _dominato_, ovvero _adiacente_ ad un vertice selezionato.
  Se riusciamo a dominare il grafo selezionando un numero di vertici $<= k$ (budget), allora il problema risponde "si".
]

- *$I_Pi$*:
  - $G(V,E)$: grafo non orientato
  - $k in bb(N)^+$: budget
- *$"Sol"_Pi$* = $exists space D subset.eq V "t.c." |D| <= k$: esiste un insieme di al massimo $k$ vertici che rispetta la seguente proprietà: per ogni vertice, esso #text(fill: red)[è dominante], oppure è #text(fill: blue)[connesso ad un vertice dominante]:
$ quad forall x in V, space mr(x in D) space or space mb(exists (x, d) in E\, d in D) $

#figure(
  cetz.canvas(length: 1cm, {
    import cetz.draw: *

    // Define vertices positions
    let vertices = (
      (1, 2), // v1
      (3, 3), // v2
      (5, 2), // v3
      (2, 1), // v4
      (4, 1), // v5
      (3, 0.5), // v6
    )

    // Define edges
    let edges = (
      (0, 1), // v1-v2
      (1, 2), // v2-v3
      (0, 3), // v1-v4
      (3, 4), // v4-v5
      (2, 4), // v3-v5
      (4, 5), // v5-v6
    )

    // Draw edges
    for edge in edges {
      line(vertices.at(edge.at(0)), vertices.at(edge.at(1)), stroke: (paint: black, thickness: 1pt))
    }

    // Define dominating set (indices of vertices in the dominating set)
    let dominating_set = (1, 4) // v2 and v5

    // Draw vertices
    for (i, vertex) in vertices.enumerate() {
      if i in dominating_set {
        // Dominating vertices (red)
        circle(vertex, radius: 0.15, fill: red, stroke: (paint: red.darken(20%), thickness: 1.5pt))
      } else {
        // Non-dominating vertices (light blue)
        circle(vertex, radius: 0.12, fill: blue.lighten(60%), stroke: (paint: blue, thickness: 1pt))
      }

      // Labels
      content((vertex.at(0), vertex.at(1) + 0.3), anchor: "center", text(
        size: 0.8em,
        fill: black,
        weight: "bold",
        [$v_#(i + 1)$],
      ))
    }

    // Draw dotted lines from non-dominating vertices to their dominators
    let domination_connections = (
      (0, 1), // v1 dominated by v2
      (2, 1), // v3 dominated by v2
      (3, 4), // v4 dominated by v5
      (5, 4), // v6 dominated by v5
    )

    for connection in domination_connections {
      line(
        vertices.at(connection.at(0)),
        vertices.at(connection.at(1)),
        stroke: (dash: "dotted", paint: red.darken(20%), thickness: 2pt),
      )
    }
  }),
  caption: [
    Esempio di Dominating Set con $k=2$.
    I vertici #text(fill: red)[rossi] ($v_2, v_5$) formano l'insieme dominante.
    Ogni vertice #text(fill: blue.lighten(40%))[blu] è adiacente ad almeno un vertice dominante, come mostrato dalle linee tratteggiate.
  ],
)

#teorema("Teorema")[
  *$ "DominatingSet" in "NPc" $*
] <dominating-set-npc>

== Inapprosimabilità di Center Selection

#teorema("Teorema")[
  Se $P != "NP"$, per *nessun* $alpha<2$ esiste un algoritmo polinomiale che $alpha$-approssima Center Selection.

  Di conseguenza, l'algoritmo $"GreedyCenterSelection"$ mostrato in precedenza fornisce l'approssimazione migliore possibile.

  #dimostrazione[
    Per dimostrarlo ci ricondurremo a #link-section(<dominating-set>).

    Per *assurdo* supponiamo che esista un algoritmo $A$ per $"CenterSelection"$ che in tempo polinomiale fornisca una $alpha$-approssimazione, con $alpha < 2$.

    Possiamo usare $A$ per decidere DominatingSet in tempo *polinomiale*.
    Per fare ciò dobbiamo _trasformare_ gli input di DominatingSet (grafo) in input di CenterSelection (spazio metrico).

    Dato il grafo $G(V,E)$, definiamo uno spazio metrico $(Omega, d)$ come:
    - Spazio dei punti: $Omega = S = V$
    - Funzione distanza $d$:
      $
        d(u,v) = cases(
          0 "se" u = v,
          1 "se" (u, v) in E,
          2 "se" (u, v) in.not E
        )
      $
    - Valgono le proprietà dello spazio metrico di $d$:
      - $d(u,v) >= 0$: non assegniamo mai distanze negative
      - $d(u,v) = d(v,u)$: il grafo $G$ è non orientato
      - $d(u,v) = 0 <==> u = v$: assegniamo $0$ proprio in caso $u = v$
      - proprietà triangolare: $mr(1 or 2) <= mb(2 or 3 or 4)$
        $
          forall space v, u, w, quad underbrace(d(u,v), "vale" mr(1 or 2))<= underbrace(underbrace(d(u,w), "vale" 1 or 2) + underbrace(d(w,v), "vale" 1 or 2), "vale" mb(2 or 3 or 4))
        $

    #figure(
      cetz.canvas(length: 1cm, {
        import cetz.draw: *

        // Original graph G
        group({
          content((2.5, 4.5), anchor: "center", text(weight: "bold", size: 1em, "Grafo G"))

          // Define vertices positions for the graph - more interesting layout
          let vertices = (
            (1, 3), // v1
            (3, 4), // v2
            (4, 2.5), // v3
            (2, 1.5), // v4
            (0.5, 2), // v5
          )

          // Define edges in the graph - creating a more connected graph
          let edges = (
            (0, 1), // v1-v2
            (1, 2), // v2-v3
            (0, 4), // v1-v5
            (3, 4), // v4-v5
            (2, 3), // v3-v4
            (1, 3),
          )

          // Draw edges
          for edge in edges {
            line(vertices.at(edge.at(0)), vertices.at(edge.at(1)), stroke: (paint: black, thickness: 1.5pt))
          }

          // Draw vertices
          for (i, vertex) in vertices.enumerate() {
            circle(vertex, radius: 0.15, fill: white, stroke: (paint: black, thickness: 1.5pt))
          }
        })

        // Arrow
        content((6, 2.75), anchor: "center", text(size: 1.5em, [$arrow.r$]))

        // Metric space representation
        group({
          content((9.5, 4.5), anchor: "center", text(weight: "bold", size: 1em, "Spazio Metrico"))

          // Same vertices positions but shifted
          let metric_vertices = (
            (7.5, 3), // v1
            (9.5, 4), // v2
            (10.5, 2.5), // v3
            (8.5, 1.5), // v4
            (7, 2), // v5
          )

          // Define which pairs are adjacent (distance 1) based on edges
          let adjacent_pairs = (
            (0, 1),
            (1, 2),
            (0, 4),
            (3, 4),
            (2, 3),
            (1, 3),
          )

          // Draw connections for all vertex pairs
          for i in range(5) {
            for j in range(i + 1, 5) {
              let v1 = metric_vertices.at(i)
              let v2 = metric_vertices.at(j)
              let midpoint = ((v1.at(0) + v2.at(0)) / 2, (v1.at(1) + v2.at(1)) / 2)

              // Check if this pair is adjacent
              let is_adjacent = (i, j) in adjacent_pairs or (j, i) in adjacent_pairs

              if is_adjacent {
                // Adjacent vertices - solid green line with distance 1
                line(v1, v2, stroke: (paint: green, thickness: 1.5pt))
                content(midpoint, anchor: "north-west", text(size: 0.7em, fill: green.darken(30%), weight: "bold", [1]))
              } else {
                // Non-adjacent vertices - dashed red line with distance 2
                line(v1, v2, stroke: (paint: red, dash: "dashed", thickness: 1pt))
                content(midpoint, anchor: "south-west", text(size: 0.7em, fill: red.darken(30%), weight: "bold", [2]))
              }
            }
          }

          // Draw vertices on top
          for (i, vertex) in metric_vertices.enumerate() {
            circle(vertex, radius: 0.15, fill: white, stroke: (paint: black, thickness: 1.5pt))
          }
        })
      }),
      caption: [
        Trasformazione di un grafo $G(V,E)$ nel corrispondente spazio metrico $(Omega, d)$.
        La distanza è $mg(1)$ tra vertici adiacenti e $mr(2)$ tra vertici non adiacenti.
      ],
    )

    Ora possiamo trasformare il grafo in uno spazio metrico ed eseguire l'algoritmo $A$ con input $V$ e $k$, che restituisce un insieme di centri $C$.
    Questa soluzione ha rapporto di approssimazione: $ 1 <= mr(rho(C)) / rho^* <= alpha $

    Per come è definito lo spazio metrico, la distanza *massima* tra due punti qualsiasi è $2$, di conseguenza il raggio di copertura della soluzione ottima $rho^*$ sarà 1 o 2: $ rho^*(V, k) in {1,2} $

    In particolare, se $rho^* = 1$, allora per ogni punto $x in V$, esiste un centro selezionato a distanza $1$, rendendolo un *dominating set*:
    $
      mb(rho^*)(V, k) = 1 space & <==> space exists space C subset.eq V, space |C| <= k, space forall x in V, space d(x, C) <= 1 \
      & <==> C "è un Dominating Set"
    $

    Mettendo insieme i pezzi, sappiamo quanto può valere la soluzione ottima $mb(rho^*)$ e sappiamo quanto può valere l'approssimazione che abbiamo trovato $mr(rho(C))$:

    #grid(
      columns: (1fr, 1fr),
      align: center,
      [
        $
          rho^* = 1 \
          1 <= mr(rho(C)) / mb(1) <= alpha \
          1 <= rho(C) <= alpha
        $
        Quindi $C$ *è* un dominating set.
      ],
      [
        $
          rho^* = 2 \
          1 <= mr(rho(C)) / mb(2) <= alpha \
          2 <= rho(C) <= 2 alpha
        $
        Quindi $C$ *NON* è un dominating set.
      ],
    )

    Quindi ci basta eseguire l'algoritmo $A$ che ($alpha < 2$)-approssima Center Selection per ottenere un $rho(C)$.
    *Osservando* questo $rho(C)$ possiamo capire in quale *intervallo è compreso* e quindi capire se $C$ è un dominating set o meno, *decidendo* il problema in tempo polinomiale.

    Ma questa cosa *è assurda* dato che *$"Dominating" in "NPc"$* (#link-teorema(<dominating-set-npc>)), $qed$.

    #attenzione[
      Questi due casi sono disgiunti dato che $alpha < 2$ per ipotesi.
      In caso $alpha >= 2$, i due intervalli si sovrappongono, rendendo impossibile intuire la soluzione ottima $rho^*$.
    ]
  ]
] <teorema-inapprossimabilita-centerselection>
