#import "../imports.typ": *

= Problema Set Cover (basato sul Probabilistic Rounding)

#informalmente[
  Problema già visto, avevamo trovato una soluzione approssimata basata sul pricing
]

- *$I_Pi$*:
  - $S_1, S_2, ..., S_m subset.eq 2^Omega, quad limits(union.big)_(i=1)^m S_i = Omega, quad |Omega| = n$: insiemi delle aree che unite coprono tutto l'universo (possono anche sovrapporsi)
  - $w_1, w_2, ..., w_m in bb(Q)^+$: costi delle aree
- *$"Amm"_Pi$* $= I subset.eq {1, ..., m}, quad limits(union.big)_(i in I) S_i = Omega$: un insieme di indici di aree che coprono tutti i punti
- *$C_Pi$*: somma dei costi delle aree selezionate
  $ w = sum_(i in I) w_i $
- *$t_Pi = min$*

== Set Cover come Programmazione Lineare

Il problema si può vedere come un problema di programmazione lineare intera $P$.

Ogni insieme si può vedere come una variabile booleana:
- $x_j >= 0 quad forall j in m$
- $x_j <= 1 quad forall j in m$

La soluzione deve essere ammissibile, quindi ogni punto deve essere preso. Definiamo il vincolo che conta quante aree hanno preso quel punto, e deve essere almeno uno:
- $sum_(p in S_i) x_i >= 1 quad forall p in Omega$

La soluzione è il costo delle aree prese:
- $min x_1 w_1 + x_2 w_2 + ... x_n w_n$

Il numero di vincoli è polinomiale rispetto a $n$ e $m$.

Il problema è che la programmazione lineare intera non si può risolvere.
Quindi rilassiamo i vincoli e lo trattiamo come problema di programmazione lineare.

=== Algoritmo Rilassato

#informalmente[
  Per ogni area, la inseriamo nella soluzione con una certa probabilità.
  La probabilità con cui inseriamo è la soluzione della programmazione lineare.
]

- Input $k in bb(N)^+$ \/\/ Fattore di quanto "pompiamo" la probabilità calcolata dal solver LP
- Risolvi $P$ come LP _(non intera)_
- Sia $hat(x_!), ... hat(x_m) in [0,1]$
- $I <- emptyset$
- for $i = 1, ..., m$ do
  - for $t = 1, ..., ceil(k + ln n)$ do
    - con probabilità $hat(x_i)$ inserisci $i in I$
- Output $I$

#teorema("Teorema")[
  #attenzione[
    Non otteniamo sempre una soluzione ammissibile.
  ]

  L'algoritmo produce una soluzione ammissibile con probabilità $>= 1- e^(-k)$

  #dimostrazione[
    $ hat(v) = sum_(i = 1)^m w_i hat(x_i) $

    Sia $v^*$ la soluzione ottima del problema originale (quindi risolto sugli interi).

    Per come funzioan il rilassament, allora:
    $ hat(v) <= v^* $

    Quanto è probabile che la soluzione sia ammissibile?

    $ P["sol ammissibile"] = 1 - P["almeno un punto non coeprto"] $

    Chiamiamo $xi_p$ l'evento: $p$ non è coeprto nella soluzione, quindi (anche applicando lo union bound):

    $
      P["sol ammissibile"] & = 1 - P[union.big_(p in Omega) xi_p] \
                           & >= 1- sum_(p in Omega) P[xi_p]
    $

    Dobbiamo calcolare l'evento di ogni songolo punto $xi_p$:
    $
      = 1- sum_(p in Omega) product_(i "t.c." p in S_i) P[i in.not I] \
      1 - sum_(p in Omega) product_(i "t.c." p in S_i) (1 - hat(x_i))^(k + ln n) \
      >= 1 sum_(p in Omega) product_(i "t.c." p in S_i) e^(-hat(x_i) ( k + ln n)) \
      >= 1 sum_(p in Omega) e^((k + ln n) mr(limits(sum)_(i "t.c." p in S_i) hat(x_i))
    $

    Ma dato che per ogni punto $p$ il vincolo dice che la sommatoria rossa deve essere $>= 1$, allora

    $
      >= 1-sum_(p in Omega) e^(-(k + ln n)) \
      ...
    $

  ]

  #informalmente[
    Al crescere di $k$, aumenta la probabilità di ottenere una soluzione ammissibile, ma abbassa la qualità della soluzione (prendiamo più aree, quindi paghiamo di più).
  ]
]

#teorema("Teorema")[
  Per ogni $1/alpha in [0, 1]$:
  $ P["fattore di approssimazione" >= alpha (k + ln n)] <= 1/alpha $

  #informalmente[
    Stiamo dimostrando che la probabilità che il fattore di approssimazine sia grande (quindi una brutta soluzione) sia bassa.

    Dobbiamo anche vedere che $alpha$ conviene dare in input all'algoritmo.
  ]

  #dimostrazione[
    La probabilità che $i in I$ è $<= (k + ln n) hat(x_i)$.

    Sia $xi_(t,i)$ l'evento "l'elemento $i$ è inserito nella soluzione $I$ nalla $t$-esima iterazione"

    Quindi se l'evento è stato inserito, è se è stato selezionato almeno una volta, quindi per union bound

    $
      P[union.big_(t=1)^(k + ln n) xi_(t, i)] & <= sum_(t=1)^(k + ln n) P[xi_(t, i)] \
                                              & = (k + ln n) hat(x_i)
    $

    Il costo che paghiamo alla fine $v$, è il suo valore atteso, ovvero la somma di tutti i costi delle singole aree pagate:
    $
      E[v] & = sum_i w_i P[i in I] \
           & <= sum_i w_i hat(x_i) (k + ln n) \
           & = (k + ln n) mr(sum_i w_i hat(x_i)) \
           & = (k + ln n) mr(hat(v)) \
           & <= v^* (k + ln n)
    $

    Dove:
    - $hat(v)$ è la funzione obiettivo del problema rilassato.
    - $v^*$ è l'ottimo del problema originale (non rilassato)
    - $v$ è l'output del nostro algoritmo probabilistico

    Quindi (e dato che $v^*$ + costante):
    $
      E[v] / v^* <= k + ln n \
      E[v / v^*] <= k + ln n
    $

    Applichiamo la disuguaglianza di Markov (alla variabile aleatoria $v$): // TODO: link
    $
      P[v/v^* >= alpha(k + ln n)] <= E[v/v^*] / (alpha (k + ln n)) \
      <= (k + ln n) / (alpha (k + ln n))\
      = 1/alpha space qed
    $

  ]
]

Nel teorema che riguarda l'ammissibilità vorremmo tenere un $k$ alto per avere un algoritmo che produce con alta probabilità una soluzione ammissibile.
Mentre nel secondo teorema, con $k$ alti, otteniamo fattori di approssimazione tanto alti.
Quindi $k$ va bilanciato.

#teorema("Corollario")[
  Eseguendo l'algoritmo con $k = 3$, c'è almeno il $45%$ di probabilità di ottenere una soluzione ammissibile con un rapporto di approssimazione di al massimo $6 + 2 ln n$.

  #dimostrazione[
    Sia:
    - $xi_"non-amm"$ l'evento "l'algoritmo ha prodotto una soluzione non ammissibile"
    - $xi_"non-ott"$ l'evento "la soluzione prodotta ha un tasso di approssimazione $> 6 + 2 ln n$"

    Primo teorema:
    $ P[xi_"non-amm"] <= e^-3 $

    Secondo teorema:
    $
      P[xi_"non-ott"] & = P["fatt approx" > 6 + 2 ln n] \
                      & <= 1/2 ("Teorema 2 con" alpha = 2)
    $

    Unione dei due eventi:
    $
      P[xi_"ok"] & = 1 - P[xi_"non-amm" union xi_"non-ott"] \
                 & >= 1- (P[xi_"non-amm"] + P[xi_"non-ott"]) \
                 & >= 1 - ()
    $
  ]
]
