#import "../imports.typ": *

= Problema MaxEkSat

#informalmente[
  Versione ristretta di #link(<problema-max-sat>)[$"MaxSat"$], in cui ogni clausola ha esattamente $k$ letterali.
]

Formalmente:
- *$I_pi$*: formula CNF, in cui ogni clausola contiene esattamente $k$ letterali (su variabili distinte)
  #nota[
    Una formula booleana in forma normale congiunta (CNF) è composta da:
    - tante clausole, messe in _AND_ tra di loro
    - ogni clausola è composta da letterali (che possono essere negati), messi in _OR_ tra loro
  ]
  #esempio[
    Con $k = 3$:
    $underbrace((x_1 or not x_2 or x_4), "clausola") and (x_3 or not x_4 or not x_1) and (x_1 or x_2 or x_3)$
  ]
- *$"Amm"_Pi$*: assegnamenti di valori di verità delle variabili
- *$C_pi$*: numero di clausole soddisfatte
- *$t_pi$*: $max$

#nota[
  Se riuscissi a risolvere questa versione del problema in tempo polinomiale riuscirei anche a risolvere il problema $"SAT"$.
]

#teorema("Teorema")[
  $ forall k > 3, quad "Max"E_k"Sat" in "NPOc" $
]

#teorema("Teorema")[
  Un assegnamento *casuale* delle variabili rende in media vere $(2^k-1)/2^k$ delle clausole totali $t$.
  $ E[T] = (2^k - 1) / 2^k t $

  #attenzione[
    Il teorema "preciso" enuncia un'_uguaglianza stretta_ $=$, ma spesso viene riportato come un _almeno_ $>=$ (utile in problemi SAT dove ogni clausola ha almeno $k$ variabili e non esattamente $k$ variabili).

    Entrambe le versioni sono corrette dato che ovviamente $>=$ include anche $=$.
  ]

  #informalmente[
    Dato che ogni clausola è un OR di $k$ variabili, per essere falsa tutte le $k$ variabili devono essere false.
    Questo è abbastanza raro dato che ognuna è assegnata con probabilità $1/2$.
    La frazione di clausole rese vere è molto alta anche con assegnamenti random.

    Ad esempio, una Formula $3$-CNF, anche se non è soddisfacibile, ha in media $7/8$ di clausole rese vere da un assegnamento casuale.
  ]

  #dimostrazione[
    Siano $X_1, dots, X_n$ le variabili che compaiono nella formula di ingresso.
    Ogni variabile $X_i$ può essere vista come una variabile aleatoria che segue una distribuzione *uniforme* con $p = 1/2$:
    $ forall i = 1,dots,n, quad space X_i tilde "Uniforme"{0,1} $

    Inoltre, per ogni clausola $C_j$ vale:
    $
      C_j = cases(
        1 quad "se la clausola "j"-esima è soddisfatta",
        0 quad "altrimenti"
      )
    $

    Sia $t$ il numero di clausole totali e $T$ il numero di clausole soddisfatte.
    Siamo interessati a stimare il numero di clausole soddisfatte in media, ovvero: $E[T]$.

    Sfruttiamo la #link("https://en.wikipedia.org/wiki/Law_of_total_expectation")[legge del valore atteso totale]: date due variabili aleatorie $X$ e $Y$ definite sullo stesso spazio di probabilità, allora:
    $ E[E[X|Y]]=E[X] $

    #informalmente()[
      Anziché calcolare $E[T]$ direttamente lo calcoliamo condizionato su tutti i possibili assegnamenti delle variabili moltiplicati per la loro probabilità $E[T | X = b] dot P[X = b]$.
      Dato che provare ogni valore di una variabile significa provare $0$ e $1$, allora possiamo trasformarlo in una sommatoria: $limits(sum)_(b in 2) E[T | X = b] dot P[X = b]$.
    ]

    Applicando la legge a tutte le $n$ variabili, otteniamo:
    $
      E[T] = sum_(b_1 in 2) dots sum_(b_n in 2) E[T|X_1=b_1,dots,X_n=b_n] dot P[X_1=b_1,dots,X_n=b_n]
    $

    Siccome le $X_i$ variabili sono indipendenti ed ogni probabilità vale $p = 1/2$:
    $
      = sum_(b_1 in 2) dots sum_(b_n in 2) E[T|X_1=b_1,dots,X_n=b_n] dot underbrace(P[X_1=b_1], mr(p=1/2)) dot dots.c dot P[X_n=b_n]\
      = mr(1/2^n) sum_(b_1 in 2) dots sum_(b_n in 2) E[T|X_1=b_1,dots,X_n = b_n]
    $

    Sappiamo che il numero di clausole soddisfatte $T$ è la somma del valore delle singole clausole (dato che valgono $0$ o $1$ per definizione di $C_j$): $T = C_1 + dots + C_t$.
    Sfruttando la linearità del valore atteso: $mb(E[T] = E[C_1 + dots + C_t] = E[C_1] + dots + E[C_t])$:
    $
      = 1/2^n sum_(b_1 in 2) dots sum_(b_n in 2) mb(sum_(j=1)^t) E[mb(C_j)|X_1=b_1,dots,X_n = b_n]
    $ <maxeksat-lower-bound-eq>

    Una clausola $C_j$ è falsa solo quando tutti i $k$ letterali sono falsi (essendo in or).
    Quindi c'è *un solo modo* di assegnare le $k$ variabili per *falsificare* $C_j$.

    Quindi, il numero di assegnamenti che rendono una clausola $C_j$ *vera* è:
    $ mp(2^n) - mr(1) dot mg(2^(n-k)) $
    dove:
    - $mp(2^n)$ = numero totale di assegnamenti possibili delle $n$ variabili
    - $mr(1)$ = numero di assegnamenti delle $k$ variabili per rendere falsa la clausola $C_j$
    - $mg(2^(n-k))$ = numero di assegnamenti delle $n-k$ variabili non coinvolte in $C_j$

    Continuando da #link-equation(<maxeksat-lower-bound-eq>):
    $
      E[T] & = 1/2^n mb(sum_(j=1)^t) (mp(2^n)-mg(2^(n-k))) \
           & = 1 /2^n mb(t) (2^n-2^(n-k)) \
           & = (t 2^n)/2^n - (t(2^(n-k)))/2^n \
           & = (t 2^n)/2^n - (t(2^n/2^k))/2^n \
           & = t cancel(2^n) / cancel(2^n) - t cancel(2^n)/2^k 1/cancel(2^n) \
           & = t(1 - 1/2^k) \
           & = t (2^k - 1)/2^k
    $

    Quindi abbiamo dimostrato che:
    $
      E[T] = t dot (2^k - 1)/2^k
    $

    Il che significa che il numero atteso di *clausole soddisfatte* ($E[T]$) è $(2^k-1)/2^k$ volte il numero totale di clausole $t$:
    $
      E[T/t] = (2^k-1)/2^k space qed
    $
  ]
] <maxeksat-clausole-soddisfatte>

#teorema("Teorema")[
  Sia $t$ il numero di clausole della formula, $C <= t$ una soluzione casuale e $C^* <= t$ la soluzione ottima (ovvero il massimo numero di clausole soddisfacibili).
  $ C <= C^* <= t $

  Per #link-teorema(<maxeksat-clausole-soddisfatte>):
  $ E[C] = (2^k-1)/2^k t $

  Calcoliamo il rapporto di approssimazione atteso:
  $ E[C^* / C] <= t / E[C] <= t / ((2^k-1)/2^k t) = 2^k / (2^k-1) $
]

#teorema("Lemma")[
  #informalmente[
    Esiste un modo di scegliere l'assegnamento delle prime $j$ variabili per mantenere un numero medio di clausole soddisfatte: $E[T] >= (2^k-1)/2^k$.

    Questa cosa è molto utile per *costruire* un assegnamento che mantenga questa approssimazione:
    - il teorema #link-teorema(<maxeksat-clausole-soddisfatte>) ci diceva semplicemente che esiste un assegnamento con buona approssimazione
    - questo lemma #link-teorema(<maxeksat-costruzione-clausole>) ci permette di ottenere questa buona approssimazione per ogni quantità $j$ di variabili assegnate, permettendoci di costruire un buon assegnamento iterativamente
  ]

  Generalizzazione del teorema #link-teorema(<maxeksat-clausole-soddisfatte>), dove $j$ era posto a $0$.

  Per ogni $j=0,dots,n$ esiste una scelta di bit ${b_1,b_2,dots,b_j} in 2$ tale che:
  $ E[T|X_1=b_1,dots,X_j=b_j] >= (2^k-1)/2^k t $

  #dimostrazione[
    Per *induzione* su $j$:

    - *Caso base $j=0$*: non vengono scelte variabili, dal teorema #link-teorema(<maxeksat-clausole-soddisfatte>) sappiamo che un qualunque assegnamento casuale soddisfa almeno $E[T] >= (2^k-1)/2^k t space qed$.

    - *Passo induttivo $j >0$*: fino alla variabile precedente $X_(j-1)$ sappiamo che esistono $b_1,dots,b_(j-1) in 2$ assegnamenti per cui vale:
      $ (2^k-1)/2^k t <= E[T|X_1=b_1,dots,X_(j-1)=b_(j-1)] $

      Per calcolare il valore atteso includendo la variabile $X_j$, dobbiamo sommare tutti i casi possibili, pesati per la loro probabilità.
      Dato che i due assegnamenti possibili sono $0$ e $1$, entrambi con probabilità $1/2$:
      $
        underbrace(E[T|X_1=b_1, dots ,X_(j-1)=b_(j-1), mb(X_j=0)], mp(e_0)) dot P[mb(X_j=0)]\
        + \
        underbrace(E[T|X_1=b_1, dots, X_(j-1)=b_(j-1), mr(X_j=1)], mg(e_1)) dot P[mr(X_j=1)]\
        = mp(e_0)1/2 + mg(e_1)1/2
      $

      Vogliamo dimostrare che continua a valere l'ipotesi induttiva:
      $ (2^k-1)/2^k t <= mp(e_0)1/2 + mg(e_1)1/2 $ <maxeksat-induzione-ipotesi>

      Supponiamo per *assurdo* che nessuno dei due assegnamenti $e_0$, $e_1$ sia _buono_, quindi:
      $ e_0 < (2^k-1)/2^k t quad and quad e_1 < (2^k-1)/2^k t $ <maxeksat-induzione-assurdo>

      Ma non possono essere vere entrambe:
      $
        underbrace((2^k-1)/2^k t <=, #link-equation(<maxeksat-induzione-ipotesi>)) quad e_0 1/2 + e_1 1/2 & quad underbrace(< (2^k-1)/2^k t, #link-equation(<maxeksat-induzione-assurdo>))
      $

      Assurdo, quindi almeno uno tra $e_1$ ed $e_2$ deve essere $>= (2^k-1)/2^k t space qed$.
  ]
] <maxeksat-costruzione-clausole>

#teorema("Corollario")[
  Esiste un assegnamento $b_1, dots, b_n in 2$ (dove $n$ è il numero di variabili della CNF) tale che il numero di clausole soddisfatte è $>= (2^k-1)/2^k t$.
]

== Algoritmo Derandomizzato

#pseudocode(
  [$D <- emptyset$ #emph("// insieme delle clausole già decise")],
  [*For* $i=1,2,dots,n$ *do* #emph("// scorro tutte le " + $n$ + " variabili, le variabili " + $< i$ + " sono già decise")],
  indent(
    [$Delta_0 <- 0$ #emph("// quanto guadagno in valore atteso se " + $X_i=0$)],
    [$Delta_1 <- 0$ #emph("// quanto guadagno in valore atteso se " + $X_i=1$)],
    [$Delta_(D_0) <- 0$ #emph("// clausole soddisfatte da " + $X_i=0$)],
    [$Delta_(D_1) <- 0$ #emph("// clausole soddisfatte da " + $X_i=1$)],
    [],
    [*For* $j=1,2,dots,t$ *do* #emph("// scorro tutte le clausole")],
    indent(
      [*If* $j in D$ *then* #emph("// clausola " + $j$ + " già decisa")],
      indent(
        [*Continue*],
      ),
      [*If* $X_i$ non compare nella clausola $j$-esima *then*],
      indent(
        [*Continue*],
      ),
      [],
      [$h <-$ numero di variabili di indice $>= i$ nella clausola $j$-esima],
      [*If* $X_i$ compare positiva *then*],
      indent(
        [$Delta_0 <- Delta_0 - 1/2^h$ #emph("// la clausola dovrà essere soddisfatta da una variabile successiva")],
        [$Delta_1 <- Delta_1 + 1/2^h$ #emph("// clausola soddisfatta")],
        [$Delta_(D_1) <- Delta_(D_1) union {j}$ #emph("// assegnare " + $X_i=1$ + " soddisfarebbe la clausola " + $j$)],
      ),
      [*Else*],
      indent(
        [$Delta_0 <- Delta_0 + 1/2^h$],
        [$Delta_1 <- Delta_1 - 1/2^h$],
        [$Delta_(D_0) <- Delta_(D_0) union {j}$],
      ),
    ),
    [],
    [#emph("// prendo l'assegnamento migliore per il futuro")],
    [*If* $Delta_0 > Delta_1$],
    indent(
      [$X[i]<- 0$ #emph("// assegno variabile")],
      [$D <- D union Delta_(D_0)$ #emph("// aggiorno clausole soddisfatte")],
    ),
    [*Else*],
    indent(
      [$X[i]<- 1$],
      [$D <- D union Delta_(D_1)$],
    ),
  ),
)

#informalmente[
  L'idea alla base dell'algoritmo è decidere man mano il valore di verità di una variabile $X_i$.
  In particolare viene valutato cosa succede se $X_i = 1$ o $X_i=0$, in termini di clausole future che tale assegnamento rende vere (variabili $Delta$).
]

Ad ogni iterazione $i$, valutiamo come il valore atteso cambia al variare del valore $mr(b_i)$ assegnato a $X_i$:
$ E[C_j|X_1=b_1, X_2=b_2,dots,X_(i-1)=b_(i-1),mr(X_i=b_i)] $
Di conseguenza il $Delta$ è definito come:
$
  Delta = underbrace(E[C_j|X_1=b_1, X_2=b_2,dots,X_(i-1)=b_(i-1),mr(X_i=b_i)], E[C_j] "dopo l'assegnamento di" X_i) - underbrace(E[C_j|X_1=b_1, X_2=b_2,dots,X_(i-1)=b_(i-1)], E[C_j] "prima dell'assegnamento di" X_i)
$

Le casistiche a cui *non* siamo interessati sono:
+ il valore di verità della clausola $C_j$ è già determinato dalle variabili $X_1,dots,X_(i-1)$ precedenti. La variabile $X_i$ può assumere un valore qualsiasi
+ $X_i$ non compare nella clausola $C_j$

L'unico caso a cui siamo interessati è che $X_i$ compare in $C_j$ e il valore di $C_j$ non è ancora stato determinato.

Sia $h$ il numero di variabili da $X_i$ *in poi* ($X_i$ inclusa). All'istante $i$ ci sono ancora $(2^h-1)/2^h$ assegnamenti *futuri* che rendono $C_j$ vera.

- Supponiamo che $X_i in C_j$ e $mb(X_i = 0)$: abbiamo una variabile in meno che può rendere vera la clausola $C_j$, quindi diventano $h-1$:
  $
    Delta &= underbrace((2^(h-1) -1)/2^(h-1), E[C_j] "dopo l'assegnamento"\ "di" X_i) - underbrace((2^h-1)/2^h, E[C_j] "prima dell'assegnamento" \ "di" X_i) \
    &= (2 dot 2^(h-1) - 2 - 2^h + 1) / 2^h \
    &= (2^h - 2 - 2^h + 1) / 2^h \
    &= -1/2^h
  $

- Supponiamo che $X_i in C_j$ e $mr(X_i = 1)$: abbiamo deciso la clausola $C_j$:
  $
    Delta &= underbrace(1, C_j "è stata resa vera dopo" \ "assegnamento di " X_i) - underbrace((2^h-1)/2^h, E[C_j] "prima dell'assegnamento" \ "di" X_i) \
    &= 1 - (2^h - 1)/2^h \
    &= (2^h - 2^h + 1)/2^h \
    &= + 1/2^h
  $

#nota[
  Se assegniamo $0$ alla variabile, allora ogni clausola che la comprende, perde possibilità di essere soddisfatta, di conseguenza l'impatto della variabile $X_i$ su quella clausola è negativo ($Delta$ negativo).

  Se invece assegniamo $1$ alla variabile, allora la probabilità che la clausola sia soddisfatta diventa $1$, sicuramente un incremento ($Delta$ positivo).
]

#attenzione[
  Questo ragionamento vale al contrario se $X_i$ compare negata nella clausola.
]

#teorema("Teorema")[
  L'algoritmo deterministico è una $(2^k/(2^k-1))$-approssimazione per $"Max"E_k"Sat"$.

  #dimostrazione()[
    Sia $t$ il numero di clausole, $overline(t)$ il numero di clausole soddisfatte dall'algoritmo e $t^*$ l'ottimo.
    Calcoliamo il rapporto di approssimazione:
    $
      (t^*)/overline(t) underbrace(<=, "al massimo " t^*\ "soddisfa" t "clausole") t/overline(t)
    $

    Per #link-teorema(<maxeksat-clausole-soddisfatte>) sappiamo che $mr(overline(t) >= (2^k-1)/2^k t)$, di conseguenza:
    $
      (t^*)/overline(t) & <= t / mr(overline(t)) \
                        & <= t / mr((2^k-1)/2^k t) \
                        & <= 1 / ((2^k-1)/2^k) \
                        & <= 2^k / (2^k-1) space qed
    $
  ]
]

#nota()[
  Durante il processo di derandomizzazione abbiamo usato la proprietà di *internalità della media*: l'intervallo di valori che una variabile aleatoria può assumere contiene per forza la sua media.

  Di conseguenza se, in media, una variabile aleatoria vale $A$, calcolando tutti i suoi valori almeno uno deve valere $>= A$.
  Noi abbiamo sfruttato questa proprietà calcolando entrambi i valori che le variabili potevano assumere, almeno uno dei due deve essere "buono".
]
