#import "../imports.typ": *

= Classi di Complessità

Studiando la complessità strutturale dei problemi, possiamo andare a suddividerli in diverse famiglie, che prendono il nome di classi di complessità.

#informalmente[
  Dati due algoritmi che impiegano $O(n^(1.81))$ e $O(3 n^(1.61))$ per risolvere un problema $Pi$, ai fini del corso sono equiparabili. Ci basterà sapere se il tempo di un algoritmo è:
  - *Polinomiale*
  - *Super-polinomiale*
]

== Problemi di Decisione

Andremo a classificare i problemi di decisione in tre classi: *P*, *NP* e *NP completi*.

=== Classe P

Insieme dei problemi di decisione che ammettono un algoritmo *polinomiale* che li risolve.

Per determinare l'appartenenza (o meno) di un problema a questa classe dobbiamo dimostrare almeno una tra le seguenti condizioni:
- *$Pi in P$*: l'_upper bound_ di $Pi$ deve essere riconducibile ad un polinomio (esiste un algoritmo $A$ che risolve $Pi$ in tempo polinomiale)
- *$Pi in.not P$*: dimostrare che il _lower bound_ di $Pi$ sia superpolinomiale

#esempio[
  Problema dell'ordinamento: l'algoritmo "BubbleSort" risolve il problema di $O(n^2)$, quindi l'upper bound è polinomiale. Di conseguenza *$"BubbleSort" in "P"$*.
]

=== Classe NP

Insieme dei problemi $Pi$ di decisione che ammettono un algoritmo *polinomiale non deterministico* che li risolve.

==== Algoritmo non deterministico

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

=== Problema $"P" eq.quest "NP"$

Possiamo osservare che *$P subset.eq "NP"$*: basta non utilizzare l'istruzione magica negli algoritmi.

Tuttavia non è nota con certezza la natura dell'inclusione, ovvero se $P subset.eq "NP"$ o $P subset "NP"$.

#attenzione[
  Ad oggi l'_ipotesi_ universalmente accettata è che *$P != "NP"$* (assunzione che verrà fatta durante tutto il corso).
]

=== Riduzione in tempo polinomiale

Siano $Pi_1, Pi_2 subset.eq 2^*$ due problemi di decisione, allora una riduzione polinomiale di $Pi_1$ a $Pi_2$ è una funzione $f$ che *trasforma* in tempo *polinomiale* un'istanza di $Pi_1$ ad un'istanza di $Pi_2$, ottenendo lo stesso risultato:
- $f: 2^* -> 2^*$, calcolabile in tempo polinomiale
- $forall x in 2^*, quad x in Pi_1 <==> f(x) in Pi_2$
e si indica con *$Pi_1 <=_p Pi_2$*.

L'idea è dare un *ordine di difficoltà*. Se posso trasformare un problema $Pi_1$ in un problema $Pi_2$ ed ottenere gli stessi risultati, allora non può essere più difficile di $Pi_2$.

#teorema("Proprietà")[
  Se $Pi_1$ non è più difficile di $Pi_2$ e $Pi_2 in "P"$, allora anche $Pi_1 in "P"$:
  $ Pi_1 <=_p Pi_2, quad Pi_2 in P quad ==> quad Pi_1 in P $
]

#informalmente[
  Se trovo un algoritmo polinomiale per $Pi_2$, lo trovo anche per $Pi_1$, dato che posso trasformare gli input di $Pi_1$ in quelli di $Pi_2$. L'overhead di trasformazione è comunque polinomiale, quindi trascurabile.
]

=== Classe NP-completi (NPc)

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
]

#teorema("Corollario Teorema di Cook")[
  $ "SAT" in P quad <==> quad P = "NP" $
  $ "SAT" in.not P quad <==> quad P != "NP" $

  #attenzione[
    - Se si trova una soluzione polinomiale per SAT, allora dimostriamo che *$P = "NP"$*, dato che possiamo ricondurvi ogni altro problema NP
    - Se si trova un lower bound super-polinomiale per SAT, allora dimostriamo che *$P != "NP"$*, dato che non possono esistere problemi più difficili
  ]
]

== Problemi di Ottimizzazione

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

// TODO: spostare questo esempio nella sezione NPOc?
#esempio[
  *MaxSAT* (Versione di ottimizazzione di SAT)

  - $I_Pi$: formule booleane in CNF
  - $"Amm"_(Pi)(x)$: assegnamenti di valori di verità per le variabili che compaiono in x
  - $C_(Pi)(x, y)$: numero di clausole della formula $x in I_Pi$ rese vere da $y$
  - $t_Pi = max$, il massimo numero di formule rese vere da $y$.

  Se esistesse un algoritmo $A$ polinomiale per MaxSAT, allora si potrebbe usare per decidere SAT. Ma dato che $"SAT" in "NPc" -> "MaxSat" in "NPOc"$

  #informalmente[
    Per decidere se un problema di ottimizzazione è risolvibile in tempo polinomiale, potrebbe essere utile ricondursi a proprietà applicabili/non applicabili studiate sui problemi di decisione.
  ]

  #nota[
    Ogni formula booleana in forma normale conguinta (CNF) è composta da:
    - letterali: variabili o variabili negate,
    - clausole: letterali in or,
    - condizione logica: clausole legate in and tra di loro.
  ]
]

La classificazione effettuata sui problemi di decisione può essere applicata anche ai problemi di ottimizzazione, suddividendo i problemi in base alla loro complessità strutturale.

=== Classe PO

#informalmente[
  È l'equivalente della classe P per i problemi di ottimizzazione.
]

Un problema di ottimizzazione $Pi in "PO"$ sse esiste un algoritmo $A$ che lo risolve in tempo polinomiale.

#attenzione[
  Dato un input ammissibile, l'algorimto $A$ deve trovare la soluzione *ottima* (o una delle soluzioni ottime in caso ne esistano più di una).
]

#nota[
  La classe $"PO"$ è molto rara, sopratutto in presenza di numerosi vincoli.
]

=== Classe NPO

#informalmente[
  Equivalente alla classe NP.

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

=== Problema di Decisione Associato ad un Problema di Ottimizzazione

Da un problema $Pi$ di ottimizzazione vogliamo passare al problema $hat(Pi)$ di decisione associato:
- $I_hat(Pi) = I_Pi times bb(N)$: l'input del problema di decisione sono delle coppie formate dall'input del problema di ottimizzazione associato e un parametro intero $k$
- $(x, k) in I_hat(Pi) -> "yes" quad <==> quad C_(Pi)^*(x) >=_(<=) k$: l'output del problema di decisione è _Si_ solo se il risultato della funzione costo del problema di ottimizzazione è maggiore o minore rispetto alla soglia $k$ (in base al tipo $t_Pi$)

#esempio[
  Fissato $Pi ="MaxSat"$, definiamo il problema $hat(Pi)$ di decisione associato:
  $ I_hat(Pi) = (I_Pi, k), quad I_Pi = "Formula CNF", quad k in bb(N) $
  Il problema di decisione $hat(Pi)$ risponde alla seguente domanda: esiste un assegnamento che rende vere $>= k$ clausole della formula?
]

#teorema("Teorema")[
  Dato un problema di ottimizzazione $Pi$ e il corrispettivo problema di ottimizzazione $hat(Pi)$ associato:
  - Se $Pi in "PO", quad hat(Pi) in "P"$
  - Se $Pi in "NPO", quad hat(Pi) in "NP"$
]

=== Classe NPO-completi (NPOc)

Dato un problema di ottimizzazione $Pi$ esso appartiene alla classe *$"NPOc"$* se:
- *$Pi in "NPO"$*
- *$hat(Pi) in "NPc"$*, il problema di decisione associato è NP-completo

#esempio[
  $"MaxSat" in "NPOc"$, in quanto $hat("MaxSat") in "NPc"$. Se riuscissi a risolvere $"MaxSat"$ in tempo polinomiale, allora riuscirei anche a risolvere $hat("MaxSat")$. Basterebbe risolvere $"MaxSat"$ e ottenere il numero massimo di clausole soddisfacibili, diciamo $k_("opt")$, e poi confrontare tale numero con il $k$ dato in input al problema decisionale $hat("MaxSat")$.

  Questo dimostrerebbe che se un problema $Pi$ in $"NPO"$ è risolvibile in tempo polinomiale, allora il suo problema decisionale $hat(Pi)$ associato è in $P$.
]

#teorema("Teorema")[
  Sia $Pi$ un problema di ottimizzazione.
  \ *Se $Pi in "NPOc"$, allora $Pi in.not "PO"$ a meno che $P = "NP"$*
]

#dimostrazione[
  *Assunzioni*:
  - $Pi$ sia un problema di ottimizzazione di massimo $t_(Pi)=max$.
  - $Pi in "NPOc"$
  - $hat(Pi) in "NPc"$

  *Per assurdo* suppongo che esista un algorimto *$A$ che risolva $Pi$ in tempo polinomiale*:

  #let algo_diagram = diagram(
    spacing: (10pt, 4em),
    {
      let (x, a, y) = ((0, 0), (3, 0), (6, 0))

      node(x, $x in I_Pi$)
      node(a, $A$, stroke: 1pt, shape: rect, width: 4em, height: 3em)
      node(y, $y^* "t.c" max{C_(Pi)(x,y^*)}$)

      edge(x, a, "->")
      edge(a, y, "->")
    },
  )
  #align(center, algo_diagram)
  Ovvero, $A$ calcola la soluzione ottima per un certo input $x$ in tempo polinomiale. \
  Consideriamo ora il *problema di decisione associato $hat(Pi)$*, definito come:
  - $I_hat(Pi)=(x,k) in I_Pi times bb(N)$
  - Uso $A$ per calcolare la soluzione ottima $y^*$ e calcolo $C_(Pi)(x,y^*)$
  - Se $C_(Pi)(x,y^*) cases(
      >= k & "out yes" \
      < k & "out no"
    )$
  Ma allora posso *risolvere il problema di decisione associato $hat(Pi)$ in tempo polinomiale*, *$hat(Pi) in P$*. Tuttavia abbiamo assunto che $hat(Pi) in "NPc"$, di conseguenza *è un assurdo*.\
  *Non si può risolvere $hat(Pi)$ in tempo polinomiale a meno che $P="NP"$*
]

== Algoritmi di Approssimazione

Come osservato in precedenza per i problemi di decisione, non si può "scendere a patti", essendo la risposta binaria o si sa quella giusta oppure no.

Per quanto riguarda i *problemi di ottimizzazione*, si può *scendere a compromessi per quanto riguarda l'ottimalità della soluzuione* trovata da un algorimto. Lo scopo di questa approssimazione è trovare degli algorimti in grado di produrre soluzioni più velocemente (polinomiali).
Dunque, *gli algoritmi di approssimazione dato un certo input forniscono un output ammissibile ma sub-ottimo*.

#attenzione[
  *Non useremo mai euristiche*, ovvero approssimazioni che ogni tanto funzionano e ogni tanto no. *Siamo sempre in grado di determinare con precisione di quanto la soluziome sub-ottima si discosta dall'ottimo*.
]

=== Rapporto di appossimazione

Dati:
- $Pi$ problema di ottimizzazione
- $A$ algoritmo t.c:
  #let algo_diagram = diagram(
    spacing: (10pt, 4em),
    {
      let (x, a, y) = ((0, 0), (3, 0), (6, 0))

      node(x, $x in I_Pi$)
      node(a, $A$, stroke: 1pt, shape: rect, width: 4em, height: 3em)
      node(y, $hat(y) in "Amm"_(Pi)(x)$)

      edge(x, a, "->")
      edge(a, y, "->")
    },
  )
  #align(center, algo_diagram)

- $R_(A)(x)$ ovvero il *rapporto di approssimazione*:

  $ R_(A)(x) = max((c_(Pi)(x, overline(y))) / (c_(Pi)(x, y^*)), (c_(Pi)(x, y^*)) / (c_(Pi)(x, overline(y)))) >= 1 $

  Questo rapporto vale sia se il problema era un problema di massimizzazione che di minimizzazione.
  $
    R_A(x) = cases(
       = 0 & "La soluzione" hat(y) "è ottima" \
      >= 1 & "La soluzione" hat(y) "è sub-ottima"
    )
  $

  #esempio[
    - se $R = 2$ e $t_(Pi) = max$, allora la soluzione sarà la metà dell'ottimo
    - se $R = 2$ e $t_(Pi) = min$, allora la soluzione sarà il doppio dell'ottimo
  ]

Si dice che *$A$ è una $alpha$-approssimazione* sse $forall x in I_Pi$,
*$ R_(A)(x) >= alpha, quad alpha >= 1 $*

*Più alfa è grande* più *all'algoritmo è permesso* sbagliare, producendo una *soluzione che si discosta maggiormente dall'ottimo*.

=== Classe APX

Si tratta di problemi di ottimizzazione approssimabili con un tasso entro una costante. Può essere definita come segue:
*$ "APX" = union_(alpha >= 1) alpha-"APX" $*

#nota[
  fissando $a=1$, otteniamo la classe $1-"APX" = P$
]

#informalmente[
  Ci saranno problemi "difficili" in cui approssimare ad una costate non sarà più possibile. Ovviamente richiedendo un approssimazione sempre più piccola i tempi possono crescere in maniera esponenziale
]

=== PTAS e FPTAS

$"PTAS"$ e $"FPTAS"$ sono delle sottoclassi di $"APX"$.

*PTAS*: *Polynomial-Time Approximation Scheme*. Un problema $Pi$ appartenente a questa classe è descritto come segue:
*$ Pi (x in I_(Pi), epsilon > 1) "con" epsilon "tasso di approsimazione desiderato" $*

#informalmente[
  Algoritmi che prendono in input anche il tasso di approssimazione che desideriamo, la soluzione prodotta si discosta di $epsilon$ da quella ottima. *$A in "PTAS"$ sono meglio degli algoritmi APX*, in quanto è possibile scegliere il tasso di approssimazione. Per $epsilon$ fissato otteniamo un $a-"APX"$
]

#nota[
  Non ci sono condizioni su quanto epsilon intacca il tempo di esecuzione. Quasi sempre, abbassando epsilon allora esplode il tempo necessario. *Più $epsilon$ tende a $1$ più $A in "PTAS"$ impiega un tempo esponenziale*.
]

#attenzione[
  *Non è possibile chiedere l'ottimo*, *$epsilon > 1$*.
]

/ FPTAS: *Fully Polynomial-Time Approximation Scheme*.
#attenzione[
  A differenza degli algorimti in $"PTAS"$, un algorimto *$A in "FPTAS"$ garantisce un tempo polinomiale anche alla decrescità dell'approsimazione $epsilon$*.
]
#nota[
  Questi problemi sono quasi problemi apprtenenti a PO.
]

#let rect-fill(width, height, fill) = {
  box(
    width: width,
    height: height,
    radius: 5pt,
    fill: fill,
    stroke: 1.5pt + black,
  )
}

#let label(text, x, y, fill) = locate(
  loc => {
    let rel-x = measure(100%, loc).width * x
    let rel-y = measure(100%, loc).height * y
    place(dx: rel-x, dy: rel-y)[
      #text(fill: fill, size: 16pt, weight: "bold")[#text]
    ]
  },
)

#box(width: 300pt, height: 250pt)[
  // Rettangoli di sfondo
  #place(dx: 0pt, dy: 0pt)[#rect-fill(380pt, 250pt, rgb(100, 150, 200))]
  #place(dx: 30pt, dy: 30pt)[#rect-fill(320pt, 200pt, rgb(150, 180, 220))]
  #place(dx: 60pt, dy: 60pt)[#rect-fill(260pt, 150pt, rgb(180, 200, 230))]
  #place(dx: 90pt, dy: 90pt)[#rect-fill(200pt, 100pt, rgb(200, 220, 240))]
  #place(dx: 120pt, dy: 120pt)[#rect-fill(140pt, 50pt, rgb(220, 230, 245))]

  // Etichette posizionate separatamente
  #place(dx: 15pt, dy: 15pt)[#text(fill: black, size: 16pt, weight: "bold")[NPO]]
  #place(dx: 45pt, dy: 45pt)[#text(fill: black, size: 16pt, weight: "bold")[APX]]
  #place(dx: 75pt, dy: 75pt)[#text(fill: black, size: 16pt, weight: "bold")[PTAS]]
  #place(dx: 105pt, dy: 105pt)[#text(fill: black, size: 16pt, weight: "bold")[FPTAS]]
  #place(dx: 135pt, dy: 135pt)[#text(fill: black, size: 16pt, weight: "bold")[PO]]
]
