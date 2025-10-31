#import "../imports.typ": *

= $"Max"E_k"Sat"$

Si tratta di una versione ristretta di $"MaxSat"$ //TODO LINK.
Formalmente: 
- *$I_pi$*: Formula CNF, in cui ogni clausola contiene esattamente $k$ letterali (su variabili distinte)
  #esempio()[
    $underbrace((x_1 or not x_2 or x_4),"clausola") and (x_3 or not x_4 or not x_1) and (x_1 or x_2 or x_3)$
  ]
- *$"Amm"_Pi$*: Assegnamenti di valori di verità delle variabili
- *$C_pi$*: Numero di clausole soddisfatte
- *$t_pi$*: $min$

Se riuscissi a risolvere questa versione del problema in tempo polinomiale riuscirei anche a risolvere il problema $"SAT"$.
#nota()[
  $"Max"E_k"Sat" in "NPOc"$ con $k > 3$
]

#teorema("Teorema")[
  Un assegnamento *casuale* delle variabili rende in media vere almeno *$>= (2^k-1)/2^k$* delle clausole totali.
  
  Sia $T$ il numero di clausole della formula, di conseguenza:
  $ (2^(k)-1) / 2^k <= underbrace(C^*,"sol ottima") <= T $

  Chiamo ora con $C$ il numero di clausole rese vere dall'algoritmo probabilistico, per il teorema: 
  $ E[C] >= (2^k-1)/2^k T $
  Calcoliamo il rapporto di approssimazione:
  $ C^* / C = T / E[C] =  T / ((2^k-1)/2^k T) = 2^k / (2^k-1) $ 

  #informalmente()[
    Una Formula CNF, anche se non è soddisfacibile, ha almeno $7/8$ di clausole rese vere da un assegnamento casuale. La frazione di clausole rese vere è molto alta, questo ha delle implicazioni sulla bontà dell'approsimazione.
  ]
  #dimostrazione()[
    Siano $X_1,dots,X_n$ le variabili che compaiono nella formula di ingresso. Ogni variabile $X_i$ può essere vista come una v.a che segue una distribuzione *uniforme* con $p = 1/2$:
    $
      forall i =1,dots,n space X_i tilde "Uniforme"{0,1}
    $
    Inoltre, per ogni clausola $C_j$ vale:
    $
      C_j = cases(
        1 space "Se la clausola "j"-esima è soddisfatta"\
        0 space "Altrimenti"
      )
    $
    Sia *$t$* il numero di clausole totali e *$T$* il numero di clasuole soddisfatte. Siamo interessati a stimare il numero di clausole soddisfatte in media, ovvero: $E[T]$.\

    Sfruttiamo ora la $mb("legge del valore atteso totale")$. Essa afferma che date due v.a $X$ e $Y$ definite sul medesimo spazio di probabilità: $mb(E[E[X|Y]]=E[X])$.
    #informalmente()[
      Anizichè calcolare $E[T]$ direttamente lo calcoliamo condizionato su tutti i possibili assegnamenti delle variabili moltiplicati per la loro probabilità, $E[T|X_1=b_1,dots,X_n=b_n] dot P[X_1=b_1,dots,X_n=b_n]$
    ]
    Applichiamo la $mb("legge del valore atteso")$:
    $
      E[T] = E[E[T|X]]\
      = sum_(b_1 in 2)sum_(b_2 in 2) dots sum_(b_n in 2) E[T|X_1=b_1,dots,X_n=b_n] dot P[X_1=b_1,dots,X_n=b_n]\

      mb("Siccome le" X_i "sono indipendenti")\

      = sum_(b_1 in 2)sum_(b_2 in 2) dots sum_(b_n in 2) E[T|X_1=b_1,dots,X_n=b_n] dot underbrace(P[X_1=b_1],mr(p=1/2)),dots,P[X_n=b_n]\

      = mr(1/2^n) sum_(b_1 in 2)sum_(b_2 in 2) dots sum_(b_n in 2) E[T|X_1=b_1,dots,X_n = b_n]
    $
    Sappiamo che $T=C_1+dots+C_t$. Sfruttando la $mb("linerità del valore atteso")$ $mb(E[T] = E[C_1]+dots+E[C_t])$. Di conseguenza:
    $
      = 1/2^n sum_(b_1 in 2)sum_(b_2 in 2) dots sum_(b_n in 2) mb(sum_(j=1)^t) E[mb(C_j)|X_1=b_1,dots,X_n = b_n]
      
    $
    Ma qual'è il numero di assegnamenti che rendono una clausola *$C_j$ vera*: 
    - $mr(2^n)$ = $"#"$ Assegnamenti totali
  
    - $mb(2^(n-k))$ = $"#"$ Assegnamenti delle variabili non coinvolte in $C_j$. Una clausola $C_j$ è falsa solo quando tutti i $k$ letterali sono falsi (essendo in or). Quindi c'è *solo un modo* di assegnare le $k$ variabili *per falsificare $C_j$*, le restanti $(n-k)$ variabili non coinvolte possono assumere un valore qualsiasi ($2^(n-k)$). 

    - $mr(2^n)-mb(2^(n-k))$ = $"#"$ combinazioni di assegnamenti $b_1 in 2,dots,b_n in 2$ che rendono vera $C_j = 1$
    $
      E[T] &= 1/2^n sum_(j=1)^t (mr(2^n)-mb(2^(n-k)))\
      &= t /2^n (2^n-2^(n-k))\
      &= (t 2^n / 2^n) - (t(2^n/2^k)dot 1/2^n)\
      &= t - t / 2^k\
      &mb("Raccologo" t)\
      &= mb(t)(1 - 1/2^k)\
      &= t dot (2^k - 1)/2^k
    $
    Quindi abbiamo dimostrato che:
    $
      E[T] = t dot (2^k - 1)/2^k
    $
    Il che significa che il numero atteso di *clausole soddisfatte* ($E[T]$) è *almeno* $(2^k-1)/2^k$ volte il numero totale di clausole $t$:
    $
      E[T/t] = (2^k-1)/2^k space qed
    $
  ]
]<teorema-upper-bound-maxeksat>

#teorema("Lemma")[
  #informalmente()[
    Si tratta di una generalizzazione del teorema precedente #link-teorema(<teorema-upper-bound-maxeksat>) ($j=0$). Il lemma ci sta dicendo che c'è un modo per scegliere l'assegnamento delle prime $j$ variabili per manterenere un numero medio di clauosole soddisfatte: $E[T] >= (2^k-1)/2^k$
  ]
  Per ogni $j=0,dots,n$ esiste una scelta di bit ${b_1,b_2,dots,b_j} in 2$ t.c: 
  $ E[T|X_1=b_1,dots,X_j=b_j] >= (2^k-1)/2^k t $

  #dimostrazione()[
    Per *induzione su $j$*.
    - *Caso base* (*$j=0$*). Ci rifacciamo al teorea precedente #link-teorema(<teorema-upper-bound-maxeksat>). Con $j=0$, non scegliamo le variabili, dal teorema precedente sappiamo che un qualunque assegnamento casuale soddisfa almeno $E[T] >= (2^k-1)/2^k space qed$. 

    - *Passo induttivo* (*$j >0$*). Esistono $b_1,dots,b_(j-1) in 2$ assegnamenti per cui il teorema vale (fino a $j-1$). Di conseguenza: 
      $ (2^k-1)/2^k <= E[T|X_1=b_1,dots,X_(j-1)=b_(j-1)] $
      Abbiamo due possibilità per l'assegnamento della variabile $X_j$:
      $ 
        underbrace(E[T|X_1=b_1,dots,X_(j-1)=b_(j-1),mb(X_j=0)],mb(e_0)) dot P[mb(X_j=0)]\ 
        + \ 
        underbrace(E[T|X_1=b_1,dots,X_(j-1)=b_(j-1),mr(X_j=1)],mr(e_1)) dot P[mr(X_j=1)]\
        = mb(e_0)1/2 + mr(e_1)1/2
      $
      Riassumendo: 
      $ 
        (2^k-1)/2^k <= mb(e_0)1/2 + mr(e_1)1/2
      $
      Supponiamo per *assurdo* che: 
      $
        e_0 < (2^k-1)/2^k t space "," space e_1 < (2^k-1)/2^k t
      $
      Allora anche la media pesata di $e_1$ e $e_2$ sarebbe $<$: 
      $
        (2^k-1)/2^k t <= e_0 1/2 + e_1 1/2 &< (2^k-1)/2^k t \
        (2^k-1)/2^k &< (2^k-1)/2^k space "contraddizione"
      $
      Questa è una contraddizione dell'ipotesi induttiva ($(2^k-1)/2^k <= e_0 1/2 + e_1 1/2$), almeno uno tra $e_1$ e $e_2$ deve essere $>= (2^k-1)/2^k space qed$
  ]
]

#teorema("Crollario")[
  Esiste un assegnamento $b_1,dots b_n in 2$ (dove $n$ è il numero di variabili) t.c il numero di clausole soddisfatte è $ >= (2^k-1)/2^k t$ 
]

== Algoritmo Derandomizzato
#pseudocode(
  [$D <- emptyset$ #emph("// insieme delle clausole già decise")],
  [*For* $i=1,2,dots,n$ #emph("// Scorro tutte le "+$n$+" variabili")],
  indent(
    [$Delta_0 <- 0$ #emph("quanto guadagno in valore atteso se "+$x_i=0$)],
    [$Delta_1 <- 0$],
    [$Delta_(D_0) <- 0$],
    [$Delta_(D_1) <- 0$],
    [#emph("// le variabili "+$< i$+" sono già decise")],
    [*For* $j=1,2,dots,t$ #emph("// Scorro tutte le clausole")],
    indent(
      [*If* $j in D$ #emph("// clausola "+$j$+ " già decisa")],
      indent(
        [*continue*]
      ),
      [*If* $x_i$ non compare nelle clausola $j$-esima],
      indent(
        [*continue*]
      ),
      [$h <-$ numero di variabili di indice $>= i$ nella clausola $j$-esima],
      [*If* $x_i$ compare positiva],
      indent(
        [$Delta_0 <- Delta_0 - 1/2^h$],
        [$Delta_1 <- Delta_1 + 1/2^h$ #emph("// come l'assegnamento "+$x_i=1$+" influenza le clausole successive")],
        [$Delta_(D_1) <- Delta_(D_1) union {j}$]
      ),[*Else*],indent(
        [$Delta_0 <- Delta_0 + 1/2^h$],
        [$Delta_1 <- Delta_1 - 1/2^h$],
        [$Delta_(D_0) <- Delta_(D_0) union {j}$]
      )
    ),
    [*If* $Delta_0 > Delta_1$ #emph("// prendo l'assegnamento migliore per il futuro")],
    indent(
      [$x[i]<- 0$],
      [$D <- D union Delta_(D_0)$]
    ),[*Else*],indent(
      [$x[i]<- 1$],
      [$D <- D union Delta_(D_1)$]
    )
  ),
)

=== Funzionamento dell'algoritmo

#informalmente()[
  L'idea alla base dell'algoritmo è decidere man mano il valore di verità di una variabile $x_i$.\
  In particolare viene valutato cosa succede se $x_i = 1$ o $x_i=0$, in termini di clausole future che tale assegnamento rende vere (variabili $Delta$).
]
Formalmente stiamo andando a studiare come ad ogni iterazione $i$ cambia :
$ E[C_j|X_1=b_1, X_2=b_2,dots,X_(i-1)=b_(i-1),mr(X_i=b_i)] $
al variare del valore $mr(b_i)$ assegnato a $mr(X_i)$. Di conseguenza il $Delta$ è definito come: 
$ Delta = underbrace(E[C_j|X_1=b_1, X_2=b_2,dots,X_(i-1)=b_(i-1),mr(X_i=b_i)],E[C_j] "dopo l'assegnamento di" x_i) - underbrace(E[C_j|X_1=b_1, X_2=b_2,dots,X_(i-1)=b_(i-1)],E[C_j] "prima dell'assegnamento di" x_i) $

Le casistiche a cui *non* siamo interessati sono: 
1. Se il valore di verità della clausola $C_j$ è già determinato dalle variabili $X_1,dots,X_(i-1)$ precedenti. La variabile $X_i$ può assumere un valore qualsiasi.
2. Se $X_i$ non compare nella clausola $C_j$

L'unico caso a cui siamo interessati è che $X_i$ compare in $C_j$ e il valore di $C_j$ non è ancora stato determinato.\ 
Sia *$h$* il numero di variabili da *$X_i$ in poi* ($X_i$ inclusa). All'istante $i$ ci sono ancora *$(2^h-1)/2^h$* assegnamenti futuri che rendono $C_j$ vera.

- Supponiamo che $X_i in C_j$ e *$mb(X_i = 0)$*
  $
    Delta &= underbrace((2^(h-1) -1)/2^(h-1), E[C_j] "dopo l'assegnamento"\ "di" x_i) - underbrace((2^h-1)/2^h, E[C_j] "prima dell'assegnamento" \ "di" x_i) \
    &= (2^h-2-2^h+1)/2^h = -1/2^h
  $
  #nota()[
    Il $Delta$ viene negativo in quanto sto perdendo delle possibilità di rendere vera la clausola $C_j$ 
  ]
- Supponiamo che $X_i in C_j$ e *$mr(X_i = 1)$*
$
  Delta = underbrace(1,C_j "è stata resa vera dopo" \ "assegnamento di " x_i) - underbrace((2^h-1)/2^h,E[C_j] "dopo l'assegnamento" \ "di" x_i) = 1/2^h
$

#teorema("Teorema")[
  L'algoritmo deterministico è una $2^k/(2^k-1)$-approssimazione per $"Max"E_k"Sat"$.

  #dimostrazione()[
    Sia $hat(t)$ il numero di clausole soddisfatte dall'algoritmo e sia $t^*$ l'ottimo. Calcoliamo il rapporto di approsimazione: 
    $
      (t^*)/hat(t) underbrace(<=,"al massimo " t^*\ "soddisfa" t "clausole") t/hat(t)
    $
    Per il #link-teorema(<teorema-upper-bound-maxeksat>) sappiamo che $hat(t) >= (2^k-1)/2^k t$, di conseguenza: 
    $
      t/hat(t) &>= hat(t) / ((2^k-1)/2^k t)\ 
      &<= (hat(t) (2^k)/2^(k-1)) / hat(t) = 2^k / 2^(k-1) space qed
    $
  ]
]

#nota()[
  Durante il processo di derandomizzazione abbiamo usato la $mb("proprietà di internalità della media")$. L'intervallo di valori che una v.a può assumere contiene la sua media. Questo ci permette di inseguire il valore più piccolo rimanendo dentro la media della v.a.
]
