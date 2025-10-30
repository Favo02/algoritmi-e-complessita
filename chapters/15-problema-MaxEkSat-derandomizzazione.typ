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
  Un assegnamento *casuale* delle variabili rende in media vere almeno *$>= (2^k-1)/2^k$* delle clausole.
  
  Sia $T$ il numero di clausole della formula, di conseguenza:
  $ (2^(k)-1) / 2^k <= underbrace(C^*,"sol ottima") <= T $

  Chiamo ora con $C$ il numero di clausole rese vere dall'algoritmo probabilistico, per il teorema: 
  $ E[C] >= (2^k-1)/2^k T $
  Calcoliamo il rapporto di approssimazione:
  $ T / E[C] =  T / ((2^k-1)/2^k T) = 2^k / (2^k-1) $ 

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
    Il che significa che il numero atteso di *clausole soddisfatte* è *almeno* $(2^k-1)/2^k$ volte il numero totale di clausole $t$:
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