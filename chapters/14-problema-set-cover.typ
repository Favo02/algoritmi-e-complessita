#import "../imports.typ": *

= Problema Set Cover (basato sul Probabilistic Rounding)

== Proprietà utili

Definiamo con $xi_i$ un evento

/ Chain Rule:
$
  P[xi_1 inter xi_2 inter dots inter xi_n] = P[xi_1] dot P[xi_2 | xi_1] dot P[xi_3 | xi_2 xi_1] dots
$ 
<chain-rule>

/ Union Bound: Permette di stimare la probabilità dell'unione di event: 
$
  P[union.big_i xi_i] underbrace(<=,"contiamo più volte la" \ "sovrapposizione degli insiemi") sum_i P[xi_i]
$
<union-bound>

/ Disuguaglianza di Markov: La Proprietà $forall$ v.a $X$ con media finita: 
$
  forall a > 0, P[X >= a] <= E[X] / a 
$
Sfrutto la *Legge di concentrazione* = Vogliamo sapere di quanto una v.a $X$ si discosta da un certo valore $a$, possiamo sfruttare il valore atteso.
<disuguaglianza-markov>

== Definizione del problema

#informalmente[
  Problema già visto, avevamo trovato una soluzione approssimata basata sul pricing.
]

Definizione formale: 
- *$I_Pi$*:
  - $S_1, S_2, ..., S_m subset.eq 2^Omega, quad limits(union.big)_(i=1)^m S_i = Omega, quad |Omega| = n$: insiemi delle aree che unite coprono tutto l'universo (possono anche sovrapporsi)
  - $w_1, w_2, ..., w_m in bb(Q)^+$: costi delle aree
- *$"Amm"_Pi$* $= I subset.eq {1, ..., m}, quad limits(union.big)_(i in I) S_i = Omega$: un insieme di indici di aree che coprono tutti i punti
- *$C_Pi$*= somma dei costi delle aree selezionate
  $ w = sum_(i in I) w_i $
- *$t_Pi = min$*

== Set Cover come Programmazione Lineare

Il problema si può vedere come un problema di programmazione lineare $"PL"$ intera.\

Formalizzazione:
- *Vincoli*. Ogni insieme $S_i$ può essere visto come una variabile booleana $x_j$:
  - $x_j >= 0 quad forall j in {1,dots,m}$
  - $x_j <= 1 quad forall j in {1,dots,m}$
- *$"Sol"_"amm"$*. Ogni punto $p in Omega$ dell'universo deve essere preso. Definiamo il vincolo che conta quante aree hanno preso un certo punto $p$, deve essere almeno una:
$ forall p in Omega quad sum_(p in S_i) x_i >= 1 $
- *$C_Pi$*. La soluzione è il costo delle aree prese:
$ min x_1 w_1 + x_2 w_2 + ... x_n w_n $

#nota()[
  Il numero di vincoli è polinomiale rispetto a $n$ e $m$.
]
Il problema è che la programmazione lineare intera (PLI) non si può risolvere in tempo polinomiale. Andiamo a rilassare i vincoli, ottenendo un problema di programmazione lineare non intera. Nella versione rilassata i vincoli $x_i in [0,1]$, non sono più solo $0$ o $1$.

=== Algoritmo Rilassato (PL non intera)

#informalmente[
  Ogni area $S_i$ viene inserita nella soluzione con una certa probabilità.
  La probabilità con cui inseriamo un area nella soluzione dipende dalla soluzione della programmazione lineare.
]

Sia $hat(V)$ la versione del problema di programmazione intera non rilassato. 

#pseudocode(
  [*Input* $k in bb(N)^+$ #emph("// fattore di quanto pompiamo la probabilità calcolata dal solver LP")],
  [Risolvi $hat(V)$ come $"LP"$ #emph("// non intera")],
  [Sia $hat(x_1),dots,hat(x_m) in [0,1]$],
  [$I <- emptyset$],
  [*For* $t=1, dots, ceil(k+ln m)$],
  indent(
    [*For* $i = 1,dots,m$],
    indent(
      [Inserisci $i in I$ con probabilità $hat(x_i)$ #emph("// i viene inserito con una probabilità "+$>= P(hat(x_i))$+" in quanto iteriamo "+$k+ln n$)] 
    ),
  ),
  [*Output* $I$]
)

#teorema("Teorema")[
  #attenzione[
    Non otteniamo sempre una soluzione ammissibile.
  ]

  L'algoritmo produce una soluzione ammissibile con probabilità $>= 1- e^(-k)$

  #dimostrazione[
    sia $hat(v)$ la soluzione ottenuta risolvendo il problema di LP rilassato:
    $ hat(v) = sum_(i = 1)^m w_i hat(x_i) $

    Sia $v^*$ la soluzione ottima del problema originale (quindi risolto sugli interi).\
    Siccome rilassiamo un problema di minimizzazione, allora:
    $ hat(v) <= v^* $

    Quanto è probabile che la soluzione $hat(v)$ sia ammissibile?

    $ P["sol ammissibile"] = 1 - P["almeno un punto non è coperto"] $

    Chiamiamo *$xi_p$* l'evento: il punto *$p$* *non è coperto* nella soluzione, di conseguenza: 
    $ P["almeno un punto non è coperto"] = P[union.big_(p in Omega) xi_p] $
    Applichiamo ora l'union buond #link-teorema(<union-bound>) :
    $
      P["sol ammissibile"] & = 1 - P[union.big_(p in Omega) xi_p] \
                           & >= 1- sum_(p in Omega) underbrace(P[xi_p],"probabilità che il punto" p \ "non sia coperto")
    $

    Calcoliamo ora l'evento $xi_p$ per ogni singolo punto (siccome le iterazioni sono indipendenti possiamo moltiplicarle):
    $
       &>= 1- sum_(p in Omega) P[xi_p] \ 
       &= 1- sum_(p in Omega) product_(i "t.c."\ p in S_i) P[i in.not I] \
    $
    Siccome un area viene aggiunta alla soluzione $I$ con $P(hat(x_i))$ e ci proviamo $k+ln n$ volte:
    $
          &= 1 - sum_(p in Omega) product_(i "t.c." p in S_i) (1 - hat(x_i))^(k + ln n) \

          & mb("Usando" 1-x <= e^(-x) "in quanto" x_i in [0,1]) \

          &>= 1 sum_(p in Omega) product_(i "t.c." p in S_i) e^(-hat(x_i) ( k + ln n)) \

          &mb("Per le proprietà degli esponenziali") mr(e^a dot e^b = e^(a+b))\

          &>= 1 sum_(p in Omega) e^mr(limits(sum)_(i "t.c." p in S_i) -hat(x_i) (k + ln n)) \

          &>= 1 sum_(p in Omega) e^(-(k + ln n) mr(limits(sum)_(i "t.c." p in S_i) hat(x_i)))
    $
    Per i vincoli del problema sappiamo che $forall p in Omega, mr(limits(sum)_(p in S_i) hat(x_i) >=1)$, possiamo quindi vederla come una costante:
    $
      &>= 1-sum_(p in Omega) e^(-(k + ln n)) \
      &mb("Per" e^(a+b) = e^a dot e^b) \
      &= 1-sum_(p in Omega) e^(-k) dot e^(-ln n)\
      &mb("Per" e^(-x) = 1/a^x) \
      &= 1-sum_(p in Omega) e^(-k) dot 1/e^(ln n)\
      &= 1-sum_(p in Omega) e^(-k) dot 1/n\
      &= 1-e^(-k) underbrace(sum_(p in Omega)  dot 1/n,n "volte" 1/n)\
      &= 1-e^(-k) quad qed\
      
    $

  ]

  #nota[
    Man mano che $k$ cresce, *aumenta* la probabilità di *ottenere una soluzione ammissibile*. Tuttavia, la qualità della soluzione ottenuta decresce (prendiamo più aree paghando di più).
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
