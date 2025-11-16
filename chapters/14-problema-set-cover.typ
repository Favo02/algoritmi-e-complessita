#import "../imports.typ": *

= Problema Set Cover (basato sul Probabilistic Rounding) [NPOc]

#informalmente[
  Esiste un universo di $n$ _punti_.
  Questi punti sono coperti da $m$ _aree_, ognuna avente un _costo_.
  Le aree possono sovrapporsi (non sono una partizione).

  L'obiettivo è comprare un insieme di aree, tale che tutti i punti siano coperti, minimizzando il costo totale.
]

#nota[
  Problema già visto, #link-section(<problema-set-cover>).
  Avevamo trovato una soluzione approssimata basata sul *pricing*.
]

Formalmente:
- *$I_Pi$*:
  - $S_1, S_2, ..., S_m subset.eq 2^Omega, quad limits(union.big)_(i=1)^m S_i = Omega, quad |Omega| = n$: insiemi delle aree che unite coprono tutto l'universo (possono anche sovrapporsi)
  - $w_1, w_2, ..., w_m in bb(Q)^+$: costi delle aree
- *$"Amm"_Pi$* $= I subset.eq {1, ..., m}, quad limits(union.big)_(i in I) S_i = Omega$: un insieme di indici di aree che coprono tutti i punti
- *$C_Pi$*= somma dei costi delle aree selezionate
  $ w = sum_(i in I) w_i $
- *$t_Pi$*$= min$

== Set Cover come Programmazione Lineare

Il problema si può vedere come un problema di programmazione lineare intera (#link-section(<problema-programmazione-lineare-intera>)).

Formalizzando, i *vincoli* del problema Set Cover come ILP sono:
- Ogni area $S_i$ può essere vista come una variabile booleana $x_i$ (può essere presa o meno):
  - $x_i >= 0 quad forall i in {1,dots,m}$
  - $x_i <= 1 quad forall i in {1,dots,m}$
- Ogni punto $p in Omega$ dell'universo deve essere coperto, quindi la somma delle variabili delle aree che lo contengono deve essere almeno $1$:
  - $limits(sum)_(i "t.c." p in S_i) x_i >= 1 quad forall p in Omega$

La soluzione (da minimizzare) è la somma dei costi delle aree prese:
$ min x_1 w_1 + x_2 w_2 + ... + x_m w_m $

#nota[
  Il numero di vincoli è polinomiale rispetto a $n$ e $m$.
]

Questa istanza di ILP rappresenta esattamente un problema di Set Cover.

#attenzione[
  La programmazione lineare intera (ILP) *non* si può risolvere in tempo polinomiale.
  Andiamo quindi a rilassare i vincoli, ottenendo un problema di programmazione lineare non intera (LP).
]

== Algoritmo Rilassato (LP non intera)

Sia $hat(V)$ la versione del problema rilassata.
I vincoli di $hat(V)$ diventano numeri reali $in [0,1]$, non più interi $0$ o $1$.

#attenzione[
  Questa istanza non risolve più il problema di Set Cover, dato che non sappiamo quali aree comprare (un numero reale non è _chiaro_ come una variabile booleana).

  Abbiamo quindi bisogno di un algoritmo che decide quali aree selezionare.
]

#informalmente[
  Ogni area $S_i$ viene inserita nella soluzione con una certa *probabilità*.
  Questa probabilità dipende dal numero reale soluzione della programmazione lineare.
]


#pseudocode(
  [input $<- k in bb(N)^+$ #emph("// fattore di quanto \"pompiamo\" la probabilità calcolata dal solver LP")],
  [$hat(x)_i <-$ risolvi $hat(V)$ come $"LP"$ #emph("// non intera, " + $hat(x)_1 dots, hat(x)_m in [0,1]$)],
  [$I <- emptyset$],
  [*For* $t=1, dots, ceil(k+ln n)$ *do*],
  indent(
    [*For* $i = 1,dots,m$ *do*],
    indent(
      [$I <- I union {i}$ con probabilità $hat(x)_i$],
      [#emph(
        "// i viene selezionato con una probabilità " + $>= P(hat(x)_i)$ + " in quanto iteriamo " + $k+ln n$ + " volte",
      )],
    ),
  ),
  [*Output* $I$],
)

#attenzione[
  Non otteniamo sempre una soluzione ammissibile.
]

#teorema("Teorema")[
  L'algoritmo produce una soluzione ammissibile con probabilità $>= 1- e^(-k)$.

  #informalmente[
    Man mano che $k$ cresce, *aumenta* la probabilità di ottenere una *soluzione ammissibile*.
    Tuttavia, la qualità della soluzione ottenuta decresce (prendiamo più aree paghando di più).
  ]

  #dimostrazione[
    Sia $hat(v)$ la soluzione ottenuta risolvendo il problema di LP rilassato:
    $ hat(v) = sum_(i = 1)^m w_i hat(x)_i $

    Sia $v^*$ la soluzione ottima del problema originale (quindi risolto sugli interi ed ottima per Set Cover).
    Siccome rilassiamo un problema di minimizzazione, allora:
    $ hat(v) <= v^* $

    Quanto è probabile che la soluzione $hat(v)$ sia ammissibile?
    $ P["ammissibile"] = 1 - P["almeno un punto non è coperto"] $

    Chiamiamo $cal(E)_p$ l'evento "il punto $p$ *non* è coperto nella soluzione", di conseguenza:
    $
      P["almeno un punto non è coperto"] quad & = quad P[union.big_(p in Omega) cal(E)_p] \
                        P["ammissibile"] quad & = quad 1 - P[union.big_(p in Omega) cal(E)_p]
    $

    Applicando l'union bound (#link-teorema(<union-bound>)):
    $ >= quad 1- sum_(p in Omega) mr(P[cal(E)_p]) $

    Possiamo calcolare la probabilità di $mr(cal(E)_p)$ (un punto non sia coperto) come la probabilità che ogni area che include quel punto $i$ non sia stata comprata da $I$.
    Dato che tutti gli eventi "area comprata" sono indipendenti, allora possiamo moltiplicarle tra loro:
    $
      = quad 1- sum_(p in Omega) mr(product_(i "t.c."\ p in S_i) P[i in.not I]) \
    $

    Siccome un area viene aggiunta alla soluzione $I$ con probabilità $hat(x)_i$, allora la probabilità che non venga selezionata $P[i in.not I] = mp(1 - hat(x)_i)$.
    Per ogni area, ci proviamo $mb(k + ln n)$ volte:
    $
      = quad 1 - sum_(p in Omega) product_(i "t.c." \ p in S_i) mp((1 - hat(x)_i))^mb(k + ln n)
    $

    Usando la proprietà $mp(1-x) <= e^(-x)$ in quanto $x_i in [0, 1]$:
    $
      & >= quad 1 - sum_(p in Omega) product_(i "t.c." \ p in S_i) mp(e^(-hat(x)_i)^mb(k + ln n)) \
      & = quad 1 - sum_(p in Omega) mr(product_(i "t.c." \ p in S_i)) mp(e^(-hat(x)_i dot mb((k + ln n))))
    $

    Sfruttando la proprietà degli esponenziali $x^a dot x^b = x^(a+b)$:
    $
      & = quad 1 - sum_(p in Omega) e^((mr(limits(sum)_(i "t.c." \ p in S_i)) -hat(x)_i (k + ln n))) \
      & = quad 1 - sum_(p in Omega) e^((-(k + ln n) mr(limits(sum)_(i "t.c." \ p in S_i) hat(x)_i)))
    $

    Per i vincoli che abbiamo dato al problema di LP, $forall p in Omega, mr(limits(sum)_(p in S_i) hat(x)_i >=1)$, possiamo quindi vederla come una costante (di fatto, ignorando la sommatoria all'esponente):
    $
      & >= quad 1-sum_(p in Omega) e^(-(k + ln n)) \
      & = quad 1-sum_(p in Omega) e^(-k) dot e^(-ln n)
    $

    Sfruttando $x^(-y) = 1/x^y$:
    $
      & = quad 1-sum_(p in Omega) e^(-k) dot 1/e^(ln n) \
      & = quad 1-sum_(p in Omega) e^(-k) dot 1/n \
      & = quad 1-e^(-k) underbrace(sum_(p in Omega) dot 1/n, n "volte" 1/n) \
      & = quad 1-e^(-k) quad qed \
    $
  ]
] <set-cover-probabilistico-ammissibile>

#teorema("Teorema")[
  Per ogni $1/alpha in [0, 1]$:
  $ P["fattore di approssimazione" >= alpha (k + ln n)] quad <= quad 1/alpha $

  #informalmente[
    La probabilità di avere un fattore di approssimazione grande (quindi una brutta soluzione) è bassa.

    Inoltre, dobbiamo capire quale sia l'$alpha$ migliore da dare in input all'algoritmo.
  ]

  #dimostrazione[
    Sappiamo che la probabilità che un insieme $i$ appartenga alla soluzione $I$ è:
    $ P[i in I] quad <= quad (k + ln n) hat(x)_i $
    <set-cover-probabilistico-bound-prob>

    Sia $cal(F)_(t,i)$ l'evento: "l'area $i$ è inserita nella soluzione $I$ durante la $t$-esima iterazione".
    La probabilità che l'area $i$ è nella soluzione è quindi:
    $
      P[i in I] quad = quad P[union.big_(t=1)^(k+ln n)cal(F)_(t,i)]
    $
    Applicando l'union bound (#link-teorema(<union-bound>)), otteniamo:
    $
      P[union.big_(t=1)^(k + ln n) cal(F)_(t, i)] quad & <= quad sum_(t=1)^(k + ln n) mr(P[cal(F)_(t, i)]) \
                                                       & = quad sum_(t=1)^(k + ln n) mr(hat(x)_i) \
                                                       & = quad (k + ln n) hat(x)_i
    $

    Il costo della soluzione dell'algoritmo ($mg(v)$) equivale alla somma dei costi delle singole aree selezionate.
    Dato che parliamo di probabilità, dobbiamo calcolare il valore atteso:
    $
      E[mg(v)] & space = quad sum_i w_i mr(P[i in I]) \
               & underbrace(<=, #link-equation(<set-cover-probabilistico-bound-prob>)) sum_i w_i mr((k + ln n) hat(x)_i) \
               & space = quad (k + ln n) mp(sum_i w_i hat(x)_i)
    $
    La somma dei pesi moltiplicati per $hat(x)_i$ non è altro che la soluzione del problema rilassato $mp(hat(v))$.
    Dato che il problema è di minimizzazione e che $hat(v)$ è rilassata, allora è più piccola dell'ottimo originale (ovvero del problema intero $mb(v^*)$):
    $
      & = quad (k + ln n) mp(hat(v)) \
      & <= quad (k + ln n) mb(v^*)
    $

    Riscrivendo la disequazione otteniamo:
    $
        E[mg(v)] & <= (k+ln n)mb(v^*) \
      E[v] / v^* & <= k + ln n \
      E[v / v^*] & <= k + ln n
    $ <set-cover-probabilistico-valore-atteso>

    Applichiamo la disuguaglianza di Markov (#link-teorema(<disuguaglianza-di-markov>)):
    $
      P[v/v^* >= alpha (k + ln n)] quad & space<= quad E[v/v^*] / (alpha (k + ln n)) \
      &underbrace(<=, #link-equation(<set-cover-probabilistico-valore-atteso>)) (k + ln n) / (alpha (k + ln n)) \
      & space = quad 1/alpha space qed
    $

  ]
] <set-cover-approssimazione>

#nota[
  Usare bene il teorema per l'ammisibilità (#link-teorema(<set-cover-probabilistico-ammissibile>)) e per l'approssimazione (#link-teorema(<set-cover-approssimazione>)) significa trovare un valore di *$k$ bilanciato*:
  - Nel primo caso vorremo un $k$ alto, per aumentare l'ammissibilità
  - Nel secondo caso vorremmo un $k$ basso, per avere una soluzione più vicina all'ottimo
]

#teorema("Corollario")[
  Eseguendo l'algoritmo con $k = 3$, c'è almeno il $45%$ di probabilità di ottenere una soluzione ammissibile con un rapporto di approssimazione di al massimo $6 + 2 ln n$.

  #dimostrazione[
    Sia:
    - $cal(E)_"non-amm"$ l'evento "l'algoritmo ha prodotto una soluzione non ammissibile".
      Usando il teorema #link-teorema(<set-cover-probabilistico-ammissibile>) con $k = 3$:
      $ P[cal(E)_"non-amm"] <= e^(-3) $

    - $cal(E)_"non-ott"$ l'evento "la soluzione prodotta ha un tasso di approssimazione $> 6 + 2 ln n$".
      Usando il teorema #link-teorema(<set-cover-approssimazione>) con $alpha = 2$:
      $
        P[cal(E)_"non-ott"] & = P["fatt approx" > 6 + 2 ln n] \
                            & <= 1/2
      $



    - $cal(E)_"ok"$ l'evento "la soluzione è ammissibile e ha tasso di approssimazione $<= 6 + 2 ln n$", quindi una soluzione _buona_:
      $
        P[cal(E)_"ok"] & space = quad 1 - P[cal(E)_"non-amm" union cal(E)_"non-ott"] \
                       & underbrace(>=, #link-teorema(<union-bound>)) 1- (P[cal(E)_"non-amm"] + P[cal(E)_"non-ott"]) \
                       & space >= quad 1 - (e^(-3) + 1/2) \
                       & space tilde.equiv quad 45% space qed
      $
  ]
]
