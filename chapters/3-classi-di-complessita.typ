#import "../imports.typ": *

= Classi di Complessità <classi-complessita>

Studiando la complessità strutturale dei problemi, possiamo andare a suddividerli in diverse famiglie, che prendono il nome di classi di complessità.

#informalmente[
  Dati due algoritmi che impiegano $O(n^(1.81))$ e $O(3 n^(1.61))$ per risolvere un problema $Pi$, ai fini del corso sono equiparabili. Ci basterà sapere se il tempo di un algoritmo è:
  - *Polinomiale*
  - *Super-polinomiale*
]

== Problemi di Decisione <problemi-decisione>

Andremo a classificare i problemi di decisione in tre classi: *P*, *NP* e *NP completi*.

=== Classe P <classe-p>

Insieme dei problemi di decisione che ammettono un algoritmo *polinomiale* che li risolve.

Per determinare l'appartenenza (o meno) di un problema a questa classe dobbiamo dimostrare almeno una tra le seguenti condizioni:
- *$Pi in P$*: l'_upper bound_ di $Pi$ deve essere riconducibile ad un polinomio (esiste un algoritmo $A$ che risolve $Pi$ in tempo polinomiale)
- *$Pi in.not P$*: dimostrare che il _lower bound_ di $Pi$ sia superpolinomiale

#esempio[
  Problema dell'ordinamento: l'algoritmo "BubbleSort" risolve il problema di $O(n^2)$, quindi l'upper bound è polinomiale. Di conseguenza *$"Ordinamento" in "P"$*.
]

=== Classe NP <classe-np>

Insieme dei problemi $Pi$ di decisione che ammettono un algoritmo *polinomiale non deterministico* che li risolve.

==== Algoritmo non deterministico <algoritmo-non-deterministico>

Algoritmo che può utilizzare l'istruzione "$X = space ?$", che permette la biforcazione dell'esecuzione:
- primo ramo: assegna $X = 0$
- secondo ramo: assegna $X = 1$

Dato che è un problema di decisione, ogni ramo quando termina, stampa $mb("Si")$ o $mr("No")$. A questo punto tutti i rami vengono messi in `OR`. Se c'è almeno un $mb("Si")$, allora la soluzione del problema di decisione è $mb("Si")$, altrimenti $mr("No")$.

#informalmente[
  - Algoritmo standard: $quad x in 2^* -> A ->$ Si / No
  - Algoritmo non deterministico: $quad x in 2^* -> A ->$ albero di risultati messi in OR
]

Un algoritmo non deterministico è *simulabile* attraverso diverse tecniche (ad esempio eseguendo i singoli rami sequenzialmente), ma potrebbe impiegarci *tempo arbitrariamente alto*. Questo perchè il numero di rami d'esecuzione (la _larghezza_ dell'albero) crescono in maniera esponenziale, nonostante la polinomialità di ogni singolo ramo (l'_altezza_ dell'albero).

#esempio[
  Problema *SAT*: data una formula booleana, decidere se esiste almeno un assegnamento di variabili per il quale la formula risulta vera:

  $ (x_1 or not x_2) and (x_4 or x_5 or x_6) $

  È possibile risolvere SAT utilizzando un algoritmo non deterministico: basta adoperare l'istruzione magica per ogni variabile e valutare la formula. Questo comporterebbe $2^"numero variabili"$ rami, dove ogni ramo ha un altezza polinomiale.

  Possiamo quindi affermare che *$"SAT" in "NP"$*.

  #attenzione[
    Non è stato dimostrato un lower bound super-polinomiale per SAT, di conseguenza sicuramente *$"SAT" in "NP"$*, ma non è noto se *$"SAT" in quest space "P"$*.
  ]
]

=== Problema $"P" eq.quest "NP"$ <problema-p-vs-np>

Possiamo osservare che *$P subset.eq "NP"$*: basta non utilizzare l'istruzione magica negli algoritmi.

Tuttavia non è nota con certezza la natura dell'inclusione, ovvero se $P subset.eq "NP"$ o $P subset "NP"$.

#attenzione[
  Ad oggi l'_ipotesi_ universalmente accettata è che *$P != "NP"$* (assunzione che verrà fatta durante tutto il corso).
]

=== Riduzione in tempo polinomiale <riduzione-tempo-polinomiale>

Siano $Pi_1, Pi_2 subset.eq 2^*$ due problemi di decisione, allora una riduzione polinomiale di $Pi_1$ a $Pi_2$ è una funzione $f$ che *trasforma* in tempo *polinomiale* un'istanza di $Pi_1$ ad un'istanza di $Pi_2$, ottenendo lo stesso risultato:
- $f: 2^* -> 2^*$, calcolabile in tempo polinomiale
- $forall x in 2^*, quad x in Pi_1 <==> f(x) in Pi_2$
e si indica con *$Pi_1 <=_p Pi_2$*.

L'idea è dare un *ordine di difficoltà*. Se posso trasformare un problema $Pi_1$ in un problema $Pi_2$ ed ottenere gli stessi risultati, allora non può essere più difficile di $Pi_2$.

#teorema("Proprietà")[
  Se $Pi_1$ non è più difficile di $Pi_2$ e $Pi_2 in "P"$, allora anche $Pi_1 in "P"$:
  $ Pi_1 <=_p Pi_2, quad Pi_2 in P quad ==> quad Pi_1 in P $
] <teorema-proprieta-riduzione>

#informalmente[
  Se trovo un algoritmo polinomiale per $Pi_2$, lo trovo anche per $Pi_1$, dato che posso trasformare gli input di $Pi_1$ in quelli di $Pi_2$. L'overhead di trasformazione è comunque polinomiale, quindi trascurabile.
]

=== Classe NP-completi (NPc) <classe-np-completi>

Un problema $Pi$ di decisione appartiene a NPc se appartiene alla classe NP ed *ogni* altro problema NP è *riducibile* in tempo polinomiale a $Pi$:
+ $Pi in "NP"$
+ $forall Pi' in "NP", quad Pi' <=_p Pi$

#informalmente[
  I problemi NPc sono i "più difficili" della classe NP, dato che ogni problema può essere ricondotto a loro.
  Sempre per lo stesso motivo, non possono esistere problemi più difficili in NP.

  Risolvendo in tempo polinomiale un problema NPc, verrebbero risolti *tutti* i problemi NP, effettivamente rendendo $P = "NP"$.
]

#teorema("Teorema di Cook")[
  *$ "SAT" in "NPc" $*

  #informalmente[
    La cosa interessante non è che il problema NPc sia SAT, ma che questi problemi "più difficili in assoluto" esistano.
    Tutti i problemi NP-completi sono equivalenti in termini di difficoltà computazionale.
  ]
] <teorema-cook>

#teorema("Corollario Teorema di Cook")[
  $ "SAT" in P quad <==> quad P = "NP" $
  $ "SAT" in.not P quad <==> quad P != "NP" $

  #attenzione[
    - Se si trova una soluzione polinomiale per SAT, allora dimostriamo che *$P = "NP"$*, dato che possiamo ricondurvi ogni altro problema NP
    - Se si trova un lower bound super-polinomiale per SAT, allora dimostriamo che *$P != "NP"$*, dato che non possono esistere problemi più difficili
  ]
] <teorema-corollario-cook>

#figure(
  {
    set text(weight: "bold")
    let stroke_alpha = 150
    let fill_alpha = 50

    let complexity_classes = cetz.canvas({
      import cetz.draw: *

      grid(
        (0, 0),
        (rel: (13, 8)),
        help-lines: true,
      )

      // External box
      rect((0, 0), (rel: (13, 8)), name: "superset")
      content("superset.north-east", [$2^2^*$], anchor: "south-west")

      // Non decidibili
      rect(
        "superset.south-west",
        (rel: (4, 4)),
        stroke: rgb(70, 70, 70, stroke_alpha),
        fill: rgb(70, 70, 70, fill_alpha),
        name: "non_decidibili",
      )
      content("non_decidibili", [Non decidibili])

      // Invisible layout anchor element
      circle("superset", radius: 2, stroke: rgb(255, 0, 255, 0), name: "center_anchor")

      // NP circle
      circle(
        "center_anchor.east",
        radius: 3.5,
        stroke: rgb(255, 0, 0, stroke_alpha),
        fill: rgb(255, 0, 0, fill_alpha),
        name: "NP",
      )
      content("NP.north-west", [NP], anchor: "south-east")

      // P circle
      circle(
        "NP.south",
        anchor: "south",
        radius: 2,
        stroke: rgb(0, 255, 0, stroke_alpha),
        fill: rgb(0, 255, 0, fill_alpha),
        name: "P",
      )
      content("P.north-east", [P], anchor: "south-west")

      // NP complete
      circle(
        "NP.north-west",
        anchor: "north-west",
        radius: 0.8,
        stroke: rgb(0, 0, 255, stroke_alpha),
        fill: rgb(0, 0, 255, fill_alpha),
        name: "NP_complete",
      )
      content("NP_complete.east", [NPc], anchor: "north-west")
      content("NP_complete", text(style: "italic")[#text(20pt)[$dot$] SAT])
    })

    align(center, block(breakable: false, complexity_classes))
  },
  caption: "Classi di complessità per problemi di decisione",
)

== Problemi di Ottimizzazione <problemi-ottimizzazione>

Si tratta di una famiglia speciale di problemi (come quelli di decisione).

Un problema $Pi$ si dice di ottimizzazione se:
- *Input* $I_Pi subset.eq 2^*$
- *Funzione di ammissibilità* $"Amm"_Pi: I_Pi -> 2^2^* \\ {emptyset}$: associa ad ogni input $x$ un insieme non-vuoto di soluzioni ammissibili (supponiamo ce ne sia sempre almeno una, il problema è sempre risolvibile)
- *Funzione obiettivo* $C_Pi : 2^* times 2^* -> bb(R)$: assegna un valore ad ogni coppia di input e output $ C_(Pi)(x, y), quad forall x in I_Pi, quad forall y in "Amm"_(Pi)(x) $
- *Tipo del problema* $t_Pi in { min, max }$: problema di massimizzazione o minimizzazione

L'obiettivo è ottenere un algoritmo $A$ che dato un input $x in I_Pi$, fornisce una soluzione $y^* in "Amm"_(Pi)(x)$, tale che: $ cases(
  C_(Pi)(x, y^*) >= C_(Pi)(x, y')\, quad forall y' in "Amm"_(Pi)(x) quad "se" t_Pi = max,
  C_(Pi)(x, y^*) <= C_(Pi)(x, y')\, quad forall y' in "Amm"_(Pi)(x) quad "se" t_Pi = min
) $

Ovvero vogliamo quindi la soluzione con costo massimo (o minimo) rispetto a tutte le altre soluzioni per un certo input $x$.

#nota[
  Si utilizza $y^*$ per indicare una soluzione ottima e $C^*(x)$ per indicare la funzione obiettivo calcolata sulla soluzione ottima.
]

#esempio[
  *Problema dello Zaino (Knapsack)*

  - $I_Pi$: insieme di $n$ oggetti con peso $w_i$ e valore $v_i$, capacità dello zaino $W$
  - $"Amm"_(Pi)(I)$: sottoinsiemi di oggetti che rispettano il vincolo di peso
    $ "Amm"_(Pi)(I) = {S subset.eq {1, 2, ..., n} : sum_(i in S) w_i <= W} $
  - $C_(Pi)(I, S)$: valore totale degli oggetti selezionati
    $ C_(Pi)(I, S) = sum_(i in S) v_i $
  - $t_Pi = max$: massimizzare il valore

  L'obiettivo è trovare un sottoinsieme $S^*$ che massimizza il valore rispettando il vincolo di peso:
  $ C_(Pi)(I, S^*) = max_(S in "Amm"_(Pi)(I)) sum_(i in S) v_i $

  #nota[
    Come vedremo, è un problema di ottimizzazione "difficile".
  ]
]

La classificazione effettuata sui problemi di decisione può essere applicata anche ai problemi di ottimizzazione, suddividendo i problemi in base alla loro complessità strutturale.

=== Classe PO <classe-po>

#informalmente[
  È l'equivalente della classe P.
]

Un problema di ottimizzazione $Pi in "PO"$ sse esiste un algoritmo $A$ che lo risolve in tempo polinomiale.

#attenzione[
  Dato un input ammissibile, l'algoritmo $A$ deve trovare la soluzione *ottima* (o una delle soluzioni ottime in caso ne esistano più di una).
]

#nota[
  La classe $"PO"$ è molto rara, sopratutto in presenza di numerosi vincoli.
]

=== Classe NPO <classe-npo>

#informalmente[
  È l'equivalente della classe NP.

  Tuttavia, il non determinismo è modellato in maniera diversa: in caso usassimo l'istruzione magica, ogni ramo di esecuzione terminerebbe con una soluzione NON binaria, ma "comporle" per trovare la migliore in termini di funzione obiettivo potrebbe non essere banale.

  Di conseguenza usiamo un *oracolo*, ovvero un istruzione che ci fornisce "magicamente" il risultato che "stiamo cercando".
]

Un problema di ottimizzazione $Pi in "NPO"$ se:
+ $I_Pi in "P"$: decidere se un input $x$ è un valido impiega un tempo polinomiale
+ esiste un polinomio $Q$ tale che:
  - la dimensione di qualsiasi soluzione ammissibile deve essere limitata rispetto ad un polinomio basato sulla lunghezza dell'input
    $ forall x in I_Pi, quad forall y in "Amm"_(Pi)(x), quad |y| <= Q(|x|) $
  - è decidibile in tempo polinomiale se una certa soluzione $y$ è una soluzione ammissibile:
    $ forall x in I_Pi, quad forall y in 2^*, quad "se" |y| <= Q(|x|), quad y in "Amm"_(Pi)(x) "in tempo polinomiale" $
+ la funzione di costo $C_Pi$ è calcolabile in tempo polinomiale


#informalmente[
  // TODO: questo disegno serve davvero? più che altro sembra che dallo stesso x in ingresso esce tanta roba
  #let algo_tree = diagram(
    spacing: (10pt, 4em),
    {
      // --- NODI ---
      let (x, box, error) = ((0, 0), (0, 1), (1, 1))
      let (b1, b2, b3, b4) = ((-2, 2), (2, 2), (1, 2), (-1, 2))
      let (maxmin) = (0, 3)

      // Input in alto
      node(x, $x in I_Pi$)

      // Algoritmo (rettangolo)
      node(box, $"Algo"$, stroke: 1pt, shape: rect, width: 5em, height: 2.5em)

      // STOP & ERROR a destra
      node(error, $x in.not I_Pi$ + linebreak() + "STOP & ERROR")

      // Due rami verso il basso
      node(b1, $y' in.not "Amm"_(Pi)(x)$ + linebreak() + "NO, STOP")
      node(b3, $y''' in.not "Amm"_(Pi)(x)$ + linebreak() + "NO, STOP")
      node(b4, $y'' in "Amm"_(Pi)(x)$ + linebreak() + $"SI, "C_(Pi)(x,y)$)
      node(b2, $y'''' in "Amm"_(Pi)(x)$ + linebreak() + $"SI," C_(Pi)(x,y)$)

      node(maxmin, "MAX / MIN")

      // --- ARCHI ---
      edge(x, box, "->")
      edge(box, error, "->")
      edge(box, b1, "->")
      edge(box, b2, "->")
      edge(box, b4, "->")
      edge(box, b3, "->")
      edge(b4, maxmin, "->")
      edge(b2, maxmin, "->")
    },
  )
  #algo_tree

  // TODO: non ho capito questa cosa
  Funzionamento:
  - 1 bit per volta viene generata qualunque sequenza di input $y in 2^*,|y|<= Q(|x|)$
  - Se $y$ è ammissibile, viene valutata la funzione obiettivo $C_(Pi)(x)$
  - Viene presa la funzione di costo min/max in base al tipo di problema

  Possibile in tempo polinomiale grazie ai vincoli imposti.
]

#esempio[
  *MaxSAT* (Versione di ottimizazzione di SAT)

  - $I_Pi$: formula booleane in CNF $phi$
    #nota[
      Una formula booleana in forma normale congiunta (CNF) è composta da:
      - tante clausole, messe in _AND_ tra di loro
      - ogni clausola è composta da letterali (che possono essere negati), messi in _OR_ tra loro
    ]
  - $"Amm"_(Pi)(x)$: assegnamenti di valori di verità per le variabili che compaiono in x
  - $C_(Pi)(x, y)$: numero di clausole della formula $x in I_Pi$ rese vere da $y$
  - $t_Pi = max$, il massimo numero di formule rese vere da $y$.

  Se esistesse un algoritmo $A$ polinomiale per MaxSAT, allora si potrebbe usare per decidere SAT.
  Basterebbe controllare se il massimo numero di clausole risolvibili corrisponde al numero totale di formule.

  #informalmente[
    Per decidere se un problema di ottimizzazione è risolvibile in tempo polinomiale, spesso è utile ricondursi a proprietà applicabili/non applicabili rispetto ai problemi di decisione.
  ]
]

=== Problema di Decisione Associato ad un Problema di Ottimizzazione <problema-decisione-associato>

Da un problema $Pi$ di ottimizzazione vogliamo passare al problema $hat(Pi)$ di decisione associato:
- $I_hat(Pi) = I_Pi times bb(N)$: l'input del problema di decisione sono delle coppie formate dall'input del problema di ottimizzazione associato e un parametro intero $k$
- $(x, k) in I_hat(Pi) -> "yes" quad <==> quad C_(Pi)^*(x) >=_(<=) k$: l'output del problema di decisione è _Si_ solo se il risultato della funzione costo del problema di ottimizzazione è maggiore o minore rispetto alla soglia $k$ (in base al tipo $t_Pi$)

#esempio[
  Fissato $Pi ="MaxSat"(phi)$, definiamo il problema $hat(Pi)$ di decisione associato:
  $ I_hat(Pi) = (I_Pi, k), quad I_Pi = "Formula CNF" phi, quad k in bb(N) $
  Il problema di decisione $hat("MaxSat")(phi, k)$ risponde alla seguente domanda: esiste un assegnamento che rende vere $>= k$ clausole della formula $phi$?
]

#teorema("Teorema")[
  Dato un problema di ottimizzazione $Pi$ e il corrispettivo problema di decisione $hat(Pi)$ associato:
  - Se $Pi in "PO", quad hat(Pi) in "P"$
  - Se $Pi in "NPO", quad hat(Pi) in "NP"$
] <teorema-problema-ottimizzazione-decisione>

=== Classe NPO-completi (NPOc) <classe-npo-completi>

#informalmente[
  È l'equivalente della classe NPc.
]

Un problema di ottimizzazione $Pi in "NPOc"$ se:
- $Pi in "NPO"$: il problema è NPO
- $hat(Pi) in "NPc"$: il problema di decisione associato è NP-completo

#esempio[
  #todo

  // TODO: io non sono per nulla convinto da questo esempio

  $"MaxSat" in "NPOc"$, in quanto $hat("MaxSat") in "NPc"$. Se riuscissi a risolvere $"MaxSat"$ in tempo polinomiale, allora riuscirei anche a risolvere $hat("MaxSat")$. Basterebbe risolvere $"MaxSat"$ e ottenere il numero massimo di clausole soddisfacibili, diciamo $k_("opt")$, e poi confrontare tale numero con il $k$ dato in input al problema decisionale $hat("MaxSat")$.

  // TODO: soprattutto da questa frase, se Pi è in NPO, come fa a essere risolvibile i tempo polnomiale?
  Questo dimostrerebbe che se un problema $Pi$ in $"NPO"$ è risolvibile in tempo polinomiale, allora il suo problema decisionale $hat(Pi)$ associato è in $P$.
]

#teorema("Teorema")[
  Sia $Pi$ un problema di ottimizzazione:
  $ Pi in "NPOc" quad and quad Pi in "PO" quad -> quad "P" = "NP" $
  O alternativamente:
  $ Pi in "NPOc" quad -> quad Pi in.not "PO" quad "a meno che" quad "P" = "NP" $

  #dimostrazione[
    #nota[
      Questa dimostrazione si basa su $t_Pi = max$, questa è un'assunzione _senza perdità di generalità_, ovvero una semplificazione che mostra solo uno dei casi possibili, ma la dimostrazione rimane esattamente uguale anche con gli altri casi possibili (ovvero $t_Pi = min$).
    ]

    / Assunzioni:
      - $Pi$: problema di ottimizzazione di massimizzazione
      - $Pi in "NPOc"$: il problema è NPO completo
      - $hat(Pi) in "NPc"$: il problema di decisione associato è NP completo (per #link-teorema(<teorema-problema-ottimizzazione-decisione>))

    Per assurdo supponiamo che esista un algoritmo $A$ che risolva $Pi$, ovvero che calcola la soluzione ottima per tutti gli input $x in I_Pi$ in tempo *polinomiale*.

    Consideriamo ora il *problema di decisione* associato $hat(Pi)$, definito come: $ I_hat(Pi) = (x,k) in I_Pi times bb(N) $

    Possiamo usare l'algoritmo $A$ per decidere $hat(Pi)$ in tempo polinomiale:
    - usiamo $A$ per calcolare la soluzione ottima $y^*$
    - calcoliamo la funzione obiettivo $C_(Pi)(x,y^*)$
    - $
        C_(Pi)(x,y^*) space cases(
          >= k "output Yes",
          < k "output No",
          delim: #none,
        )
      $

    Ma allora è possibile risolvere il problema di decisione associato in tempo polinomiale: $hat(Pi) in P$.
    Tuttavia abbiamo assunto che $Pi in "NPOc"$, quindi $hat(Pi) in "NPc"$ per #link-teorema(<teorema-problema-ottimizzazione-decisione>).

    Questo è un assurdo, a meno che $"P" = "NP" qed$.
  ]
] <teorema-npoc-po-implica-p-np>

== Algoritmi di Approssimazione <algoritmi-approssimazione>

Per i problemi di decisione, essendo la risposta binaria, non si può "scendere a patti". O si è in grado di calcolare la soluzione corretta oppure no.

Per quanto riguarda i problemi di *ottimizzazione*, si possono fare dei compromessi riguardo l'*ottimalità* della soluzione trovata da un algoritmo.
Lo scopo di questa approssimazione è trovare degli algoritmi in grado di produrre soluzioni più velocemente (polinomiali), ma fornendo un output ammissibile *sub-ottimo*.

#attenzione[
  Non useremo *mai euristiche*, ovvero approssimazioni che ogni tanto funzionano e ogni tanto no.
  Siamo sempre in grado di determinare con precisione di quanto la soluzione sub-ottima si discosta dall'ottimo.
]

=== Rapporto di approssimazione <rapporto-approssimazione>

Dati:
- $Pi$ problema di ottimizzazione
- $A$ algoritmo che da un input $x in I_Pi$ restituisce un output $overline(y) in "Amm"_(Pi)(x)$

Definiamo $R_(A)(x)$ come il *rapporto di approssimazione*, che rappresenta quanto la soluzione $overline(y)$ si discosta dall'ottimo $y^*$:

$ R_(A)(x) = max((c_(Pi)(x, overline(y))) / (c_(Pi)(x, y^*)), (c_(Pi)(x, y^*)) / (c_(Pi)(x, overline(y)))) >= 1 $
$
  R_(A)(x) = cases(
    = 1 space "la soluzione" hat(y) "è ottima",
    > 1 space "la soluzione" hat(y) "è sub-ottima"
  )
$

#nota[
  Questo rapporto vale sia se il problema era un problema di massimizzazione che di minimizzazione.
]

#esempio[
  - se $R = 2$ e $t_(Pi) = max$, allora la soluzione sarà la metà dell'ottimo
  - se $R = 2$ e $t_(Pi) = min$, allora la soluzione sarà il doppio dell'ottimo
]

Si dice che $A$ è una *$alpha$-approssimazione* se, per ogni input, il rapporto di approssimazione è al massimo $alpha$:
$ forall x in I_Pi, quad R_(A)(x) <= alpha, quad alpha >= 1 $

Più alfa è grande più all'algoritmo è *permesso sbagliare*, producendo una soluzione che si discosta maggiormente dall'ottimo.

=== Classe APX <classe-apx>

Problemi di ottimizzazione approssimabili con un tasso costante:
$ "APX" = union.big_(alpha >= 1) alpha"-APX" $

#nota[
  Fissando $alpha = 1$, otteniamo la classe $1"-APX" = "P"$
]

#attenzione[
  Ci saranno problemi "difficili" in cui approssimare ad una costate non sarà più possibile, ma sarà, ad esempio, necessario approssimare linearmente o logaritmicamente sulla grandezza dell'input.
]

=== Classi PTAS e FPTAS <classi-ptas-fptas>

$"PTAS"$ e $"FPTAS"$ sono delle sottoclassi di $"APX"$.

/ PTAS, Polynomial-Time Approximation Scheme: i problemi $Pi in "PTAS"$ prendono in input anche il tasso di approssimazione desiderato $epsilon$. La soluzione prodotta si discosta di $epsilon$ da quella ottima:
$ Pi (x in I_(Pi), epsilon > 1) $

#attenzione[
  Non è possibile chiedere l'ottimo, $epsilon > 1$.
]

#nota[
  Gli algoritmi $in "PTAS"$ sono *meglio* degli algoritmi $in "APX"$, in quanto è possibile scegliere il tasso di approssimazione. Per $epsilon$ fissato otteniamo un $epsilon"-APX"$.
]

#nota[
  Non ci sono condizioni su quanto epsilon intacca il tempo di esecuzione. Quasi sempre, abbassando epsilon esplode il tempo di esecuzione. Più $epsilon$ tende a $1$ più $A in "PTAS"$ impiega un tempo *esponenziale*.
]

/ FPTAS, Fully Polynomial-Time Approximation Scheme: a differenza degli algoritmi in $"PTAS"$, un algoritmo $A in "FPTAS"$ garantisce un tempo polinomiale anche alla decrescità dell'approsimazione $epsilon$.

#nota[
  Questi problemi sono *quasi* problemi di cui conosciamo l'ottimo, la classe $"FPTAS"$ è poco più grande di $"P"$.
]

#figure(
  {
    set text(weight: "bold")
    let stroke_alpha = 180
    let fill_alpha = 60

    let optimization_classes = cetz.canvas({
      import cetz.draw: *

      grid(
        (0, 0),
        (rel: (12, 8)),
        help-lines: true,
      )

      // NPO - outermost circle (red)
      circle(
        (6, 4),
        radius: 3.8,
        stroke: rgb(220, 50, 50, stroke_alpha),
        fill: rgb(220, 50, 50, fill_alpha),
        name: "NPO",
      )
      content("NPO.north", [NPO], anchor: "north")

      // APX circle (orange)
      circle(
        (6, 4),
        radius: 3.2,
        stroke: rgb(255, 140, 0, stroke_alpha),
        fill: rgb(255, 140, 0, fill_alpha),
        name: "APX",
      )
      content("APX.north", [APX], anchor: "north")

      // PTAS circle (yellow)
      circle(
        (6, 4),
        radius: 2.4,
        stroke: rgb(255, 215, 0, stroke_alpha),
        fill: rgb(255, 215, 0, fill_alpha),
        name: "PTAS",
      )
      content("PTAS.north", [PTAS], anchor: "north")

      // FPTAS circle (light green)
      circle(
        (6, 4),
        radius: 1.6,
        stroke: rgb(144, 238, 144, stroke_alpha),
        fill: rgb(144, 238, 144, fill_alpha),
        name: "FPTAS",
      )
      content("FPTAS.north", [FPTAS], anchor: "north")

      // PO - innermost circle (green)
      circle(
        (6, 4),
        radius: 0.8,
        stroke: rgb(50, 205, 50, stroke_alpha),
        fill: rgb(50, 205, 50, fill_alpha),
        name: "PO",
      )
      content("PO.north", [PO], anchor: "north")
    })

    align(center, block(breakable: false, optimization_classes))
  },
  caption: "Classi di complessità per problemi di ottimizzazione",
)
