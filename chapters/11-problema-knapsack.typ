#import "../imports.typ": *

= Problema Knapsack (dello zaino) [NPOc] [FPTAS]

#informalmente[
  Dati un insieme di oggetti ciascuno con un certo _peso_ e _valore_ e uno _zaino_ con una _capacità_ massima, vogliamo mettere nello zaino un sotto-insieme degli oggetti di valore massimo non superando la capienza dello zaino.
]

Formalmente:
- *$I_Pi$*:
  - $W in bb(N)^+$: capacità dello zaino
  - $n in bb(N)^+$: numero di oggetti
  - $v_0, ..., v_(n-1) in bb(N)^+$: valore degli oggetti
  - $w_0, ..., w_(n-1) in bb(N)^*, "t.c." w_i <= W$: peso degli oggetti (nessun oggetto può essere più pesante della capacità dello zaino)
- *$"Amm"_Pi$*: insieme di oggetti tale che la somma dei pesi degli oggetti non eccede la capacità dello zaino
  $ I subset.eq n, quad sum_(i in I) w_i <= W $
- *$C_Pi$*: somma dei valori degli oggetti selezionati
  $ v = sum_(i in I) v_i $
- *$t_Pi$*: $max$

#teorema("Teorema")[
  *$ "Knapsack" in "NPOc" $*
]

#nota[
  Anche se sappiamo che questo problema non può essere risolto in modo efficiente (dato che è NPOc), ha comunque senso proporre delle soluzioni esatte.
  Per un certo insieme di istanze (di piccola taglia), l'algoritmo proposto funziona bene.
]

== Programmazione Dinamica (DP)

#nota[
  Piccola sezione che *non* intende descrivere ampiamente la programmazione dinamica, ma solo fornire una piccola infarinatura utile a comprendere la notazione delle sezioni successive.
  Si rimanda a #link("https://it.wikipedia.org/wiki/Programmazione_dinamica")[Wikipedia] e alla #link("https://ioi.di.unimi.it/dinamica.pdf")[dispensa di S. Vigna].
]

La programmazione dinamica è una tecnica algoritmica che si basa sulla divisione del problema in tanti *sottoproblemi* (non necessariamente disgiunti, altrimenti si potrebbero usare soluzioni #link("https://it.wikipedia.org/wiki/Divide_et_impera_(informatica)")[divide-et-impera]), le cui soluzioni (ottime) vengono sfruttate per costruire l'*ottimo* totale.
Generalmente un sottoproblema sfrutta le soluzioni dei sottoproblemi risolti in *precedenza* per calcolare il proprio ottimo.

#informalmente[
  È possibile vedere una DP come un'implementazione _"intelligente"_ di una risoluzione di problema con approccio *top-down ricorsivo* (e *memoization*).

  Tipicamente viene costruita una *tabella* $n$-dimensionale, dove $n$ è il numero di parametri, che non è altro che la memoization.
  Spesso è possibile ottimizzare queste versioni memorizzando (_portandosi dietro_) solo alcune parti della tabella (ad esempio l'ultima riga).
]

/ Parametri: tutti i sottoproblemi sono descritti da dei parametri, ovvero la parte che *differisce* tra i vari sottoproblemi.
  È fondamentale scegliere bene i parametri per ottenere una DP efficiente dato che il numero di sottoproblemi (quindi di *stati* possibili) è dato dal prodotto dei valori assumibili dei vari parametri.

/ Partenza: i _primi_ sottoproblemi non possono sfruttare soluzioni calcolate in precedenza, dato che sono appunto i _primi_ ad essere valutati e risolti.
  Questi sottoproblemi devono quindi avere un valore di *partenza* (equiparabile al *caso base* della ricorsione).

/ Transizioni: le transizioni sono il modo in cui vengono sfruttati i risultati calcolati per risolvere i prossimi sottoproblemi.
  Tipicamente si lavora *"in avanti"*, ovvero dal sottoproblema _attuale_ si calcola una transizione verso un sottoproblema più _complesso_ (al contrario della ricorsione dove si richiama un problema più semplice).

/ Soluzione finale: non è scontato capire quale sia la soluzione finale di una programmazione dinamica.
  L'ottimo totale potrebbe non essere semplicemente il risultato del sottoproblema massimo, ma il massimo o minimo tra un insieme di sottoproblemi (ad esempio il massimo dell'ultima riga).
  Per questo motivo è necessario descrivere come ottenere il risultato finale.

== Soluzione esatta basata sulla DP <knapsack-prima-versione-dp>

#attenzione[
  La soluzione proposta con questo approccio è *esatta* (fornisce l'ottimo), ma *non è polinomiale* (in quanto il problema di decisione associato è $"NPc"$) ma *pseudopolinomiale*.
]

Non è possibile utilizzare un approccio divide-et-impera in quanto i vari sottoproblemi che si verrebbero a creare *non* sono disgiunti.
Per questo motivo si ricorre alla programmazione dinamica.

/ Parametri della DP:
  - *$i$* (righe): sottoproblema in cui considero solo i primi $i$ oggetti
  - *$w$* (colonne): sottoproblema in cui la capacità dello zaino è $w$
  - *$v[i,w]$* (cella): ottimo del sottoproblema, ovvero il massimo valore ricavabile con i primi $i$ oggetti e uno zaino di capacità $w$

/ Partenza della DP:
  - Prima riga ($i = 0$): con $0$ oggetti disponibili, il massimo valore è $0$
    $ v[0, w] = 0 quad forall w in W $
  - Prima colonna ($w = 0$): con uno zaino di capacità $0$, possiamo portare via $0$ oggetti, di conseguenza il valore è $0$
    $ v[i, 0] = 0 quad forall i in n $

/ Transizioni della DP: per riempire la cella $(i+1, w+1)$ possiamo dividere in due casi:
  + Il peso dell'oggetto $i+1$ è più grande dello zaino attuale $w+1$: non possiamo prendere l'oggetto, quindi rimane l'ottimo calcolato all'oggetto precedente $mr((i\, w+1))$ nonostante incrementiamo la capacità dello zaino
  + Altrimenti, abbiamo abbastanza spazio per prendere l'oggetto. L'ottimo è calcolato come il massimo tra il prenderlo e il non prenderlo:
    - se non prendiamo l'oggetto, rimane l'ottimo calcolato all'oggetto precedente $mr((i\, w+1))$
    - se prendiamo l'oggetto, allora l'ottimo diventa il valore dell'oggetto $mb(v_i)$ sommato all'ottimo con uno zaino più piccolo, ovvero lo spazio rimasto prendendo l'oggetto $mg((i\, w+1 - w_i))$
  $
    v[i+1,w+1] = cases(
      v[mr(i\, w+1)] & "se" w_i > w+1,
      max(space v[mr(i\,w+1)], quad mb(v_i) + v[mg(i\, w+1-w_i)] space) quad & "altrimenti"
    )
  $
  Quindi andiamo a riempire dall'alto verso il basso una riga alla volta della tabella.

  #nota[
    Grazie al criterio di riempimento scelto (*per righe*) non c'è bisogno di tenere l'intera tabella in memoria, basta solamente tenere la riga precedente e la corrente.
    Lo spazio occupato è $Theta(2W)$, al posto di $Theta(n dot W)$.
  ]

/ Soluzione finale della DP: sottoproblema dove sono considerati tutti gli $n$ oggetti con capacità dello zaino di $W$, ovvero la cella in basso a destra della tabella.

#esempio[
  Consideriamo un'istanza semplice del problema Knapsack:
  - Capacità zaino: $W = 5$
  - Numero oggetti: $n = 3$
  - Valori: $v = [3, 4, 5]$
  - Pesi: $w = [2, 3, 4]$

  La tabella DP $v[i,w]$ (valore massimo con $i$ oggetti e capacità $w$) viene riempita:

  #align(center)[
    #import "@preview/pinit:0.2.2": pin, pinit-arrow

    #table(
      columns: 7,
      align: center,
      table.header([], [$w=0$], [$w=1$], [$w=2$], [$w=3$], [$w=4$], [$w=5$]),
      [$i=0$], [$mp(0)$], [$mp(0)$], [$mp(0)$], [$mp(0)$], [$mp(0)$], [$mp(0)$],
      [$i=1$], [#pin("1,0")$mp(0)$], [$0$], [#pin("1,2")$3$], [#pin("1,3")$3$], [$3$], [#pin("1,5")$3$],
      [$i=2$], [$mp(0)$], [$0$], [$3$], [$#pin("2,3")4$], [$4$], [$#pin("2,5")7$],
      [$i=3$], [$mp(0)$], [$0$], [$3$], [$4$], [$5$], [$mp(7)$],
    )

    #pinit-arrow("2,3", "1,3", start-dy: -3pt, end-dy: 6pt, end-dx: 11pt, fill: red.transparentize(50%))
    #pinit-arrow("2,3", "1,0", start-dy: -3pt, end-dy: 6pt, end-dx: 17pt, fill: green.transparentize(50%))

    #pinit-arrow("2,5", "1,2", start-dy: -3pt, end-dy: 6pt, end-dx: 17pt, fill: green.transparentize(50%))
    #pinit-arrow("2,5", "1,5", start-dy: -3pt, end-dy: 6pt, end-dx: 11pt, fill: red.transparentize(50%))
  ]


  Ad esempio, la cella $v[2, 3]$ è calcolata come il massimo tra $mg(0+4)$ (prendere l'oggetto 2) e $mr(3)$ (non prendere l'oggetto 2). Mentre la cella $v[2, 5]$ come $max(mg(3+4), mr(3))$.

  La soluzione ottima è $v[3,5] = 7$, ottenuta prendendo gli oggetti 1 e 2.
]

Algoritmo:

#pseudocode(
  [$v[i,0] <- 0 quad forall i in n$],
  [$v[0,w] <- 0 quad forall w in W$],
  [*For* $i=0; quad i<n-1; quad i = i+1;$ *do*],
  indent(
    [*For* $w=0; quad w<W-1; quad w = w+1;$ *do*],
    indent(
      [*If* $w_i <= w+1$ *then*],
      indent(
        [$v[i+1,w+1] = max(v[i,w+1], v_i+v[i,w+1-w_i])$],
      ),
      [*Else*],
      indent(
        [$v[i+1,w+1] = v[i,w+1]$],
      ),
    ),
  ),
  [*End*],
)

#attenzione[
  Questo algoritmo a prima vista *sembra* polinomiale, $O(n dot W)$.

  Tuttavia, il secondo ciclo (e la grandezza della tabella) dipende dal *valore* di $W$ e non dalla sua lunghezza in bit.
  Questo algoritmo è *pseudopolinomiale* (#link-section(<pseudopolinomialita>)), in quanto alla crescita lineare della lunghezza in bit di $W$, il suo valore cresce esponenzialmente.

  #nota[
    L'algoritmo è pseudopolinomiale solo su $W$ e non su $n$ perché il numero di oggetti non ci serve davvero, è semplicemente il numero di pesi/valori.
  ]
]

== Ulteriore soluzione esatta basata sulla DP <knapsack-seconda-versione-dp>

/ Parametri della DP:
  - *$i$* (righe): considero solo i primi $i$ oggetti
  - *$v$* (colonne): valore minimo che voglio portare a casa
  - *$w[i, v]$* (cella): minima capacità dello zaino per portare via almeno valore $v$ con i primi $i$ oggetti (non sempre è possibile, dove è impossibile inseriamo $infinity$, ovvero uno zaino infinitamente grande)

  #nota[
    Per semplicità, nei conti che faremo nelle prossime sezioni considereremo il numero di colonne di questa DP come $n dot V$, dove $V$ è il valore più grande tra tutti gli oggetti ($V = max_i v_i$).

    In realtà, basterebbero tante colonne quante la somma del valore di tutti gli oggetti $sum_i v_i$, dato che è impossibile ottenere un valore totale maggiore.
    Per questo motivo, le colonne successive a $sum_i v_i$ saranno riempite di $infinity$.
  ]

/ Partenza della DP:
  - Prima cella $(i = 0, v = 0)$: per portare a casa $0$ di valore avendo $0$ oggetti basta uno zaino con capacità $0$
    $ w[0, 0] = 0 $
  - Prima riga ($i = 0$): portare via $v > 0$ di valore con $0$ oggetti è impossibile
    $ w[0,v] = infinity quad forall v > 0 $
  - Prima colonna ($v = 0$): portare via $0$ valore con qualsiasi numero di oggetti disponibili, basta avere uno zaino con capacità $0$
    $ w[i,0] = 0 quad forall i in n $

/ Transizioni della DP: per riempire la cella $(i + 1, v + 1)$ possiamo dividere in due casi:
  + L'oggetto da solo non vale abbastanza per ottenere il valore che vogliamo $v+1$.
    Possiamo prendere o non prendere l'oggetto attuale $i$:
    - se non prendiamo l'oggetto, rimane l'ottimo calcolato all'oggetto precedente $mb(w[i, v+1])$
    - se prendiamo l'oggetto, allora la capacità minima dello zaino per ottenere almeno $mo(v+1)$ valore diventa il #text(fill: red)[peso dell'oggetto appena preso] più la capacità necessaria per raggiungere il #text(fill: orange)[valore rimanente], ovvero il risultato del sottoproblema con target $mo(v+1) - v_i$: $mr(w_i) + mg(w[i, v+1 - v_i])$
  + L'oggetto da solo vale abbastanza per ottenere il valore che vogliamo $v+1$, quindi possiamo prendere solo lui: $mr(w_i)$.
    Dobbiamo comunque controllare se esisteva già una soluzione migliore (di peso minore) controllando il sottoproblema precedente con un oggetto in meno: $mb(w[i, v+1])$. Il minimo tra queste due quantità è la minima capacità dello zaino possibile.
  $
    w[i+1, v+1] = cases(
      min(space mb(w[i,v+1]), quad mr(w_i) + mg(w[i, v+1-v_i]) space) quad & "se" v_i <= v+1,
      min(space mb(w[i,v+1]), quad mr(w_i) space) & "altrimenti"
    )
  $

  #nota[
    È necessario dividere i due casi in quanto la componente $v+1-v_i$ del primo caso può essere negativa.
  ]

/ Soluzione finale della DP: considero solamente l'ultima riga ($n$ oggetti).
  Alcune celle potrebbero essere $> W$, ovvero più grandi della capacità dello zaino.
  La soluzione finale è il numero di colonna contenente cella con valore più alto tale che il suo contenuto sia $<= W$, ovvero la colonna più a destra con contenuto $<= W$.

  #attenzione[
    La soluzione non è il contenuto della cella, ma il numero di colonna!
  ]

// TODO: pinit fa cagare, trovare libreria migliore per disegnare in absolute
#show: gentle-clues.gentle-clues.with(breakable: false)
#esempio[
  Consideriamo la stessa istanza ma con valori ridotti:
  - Capacità zaino: $W = 5$
  - Numero oggetti: $n = 3$
  - Valori: $v = [2, 3, 4]$
  - Pesi: $w = [2, 3, 4]$

  La tabella DP $w[i,v]$ (capacità minima per ottenere valore $v$ con $i$ oggetti) viene riempita:

  #align(center)[
    #import "@preview/pinit:0.2.2": pin, pinit-arrow

    #table(
      columns: 11,
      align: center,
      table.header([], [$v=0$], [$v=1$], [$v=2$], [$v=3$], [$v=4$], [$mp(v=5)$], [$v=6$], [$v=7$], [$v=8$], [$v=9$]),
      [$i=0$],
      [$mp(0)$],
      [$mp(infinity)$],
      [$mp(infinity)$],
      [$mp(infinity)$],
      [$mp(infinity)$],
      [$mp(infinity)$],
      [$mp(infinity)$],
      [$mp(infinity)$],
      [$mp(infinity)$],
      [$mp(infinity)$],

      [$i=1$],
      [$mp(0)$],
      [$infinity$],
      [#pin("1,2")$2$],
      [$infinity$],
      [$infinity$],
      [#pin("1,5")$infinity$],
      [$infinity$],
      [$infinity$],
      [$infinity$],
      [$infinity$],

      [$i=2$],
      [$mp(0)$],
      [$infinity$],
      [$2$],
      [$3$],
      [#pin("2,4")$infinity$],
      [#pin("2,5")$5$],
      [$infinity$],
      [$infinity$],
      [#pin("2,8")$infinity$],
      [$infinity$],

      [$i=3$], [$mp(0)$], [$infinity$], [$2$], [$3$], [$4$], [$5$], [$6$], [$infinity$], [#pin("3,8")$infinity$], [$9$],
    )

    #pinit-arrow("2,5", "1,5", start-dx: 10pt, start-dy: 5pt, end-dx: 7pt, end-dy: 5pt, fill: blue.transparentize(50%))
    #pinit-arrow(
      "2,5",
      "1,2",
      start-dx: 10pt,
      start-dy: 5pt,
      end-dx: 17pt,
      end-dy: 5pt,
      fill: green.transparentize(50%),
    )

    #pinit-arrow("3,8", "2,8", start-dx: 7pt, start-dy: 5pt, end-dx: 7pt, end-dy: 5pt, fill: blue.transparentize(50%))
    #pinit-arrow(
      "3,8",
      "2,4",
      start-dx: 7pt,
      start-dy: 5pt,
      end-dx: 17pt,
      end-dy: 5pt,
      fill: green.transparentize(50%),
    )
  ]

  Ad esempio, la cella $w[2, 5]$ è calcolata come il minimo tra $mb(infinity)$ (non prendere l'oggetto 2) e $mg(2) + mr(3) = 5$ (prendere oggetto 2 con peso 3, più la capacità necessaria per ottenere valore $5-3$ con i primi oggetti).

  La prima colonna da destra con valore $<= W$ è la colonna $v=5$, quindi la soluzione ottima è $5$, prendendo oggetti 1 e 2.
]
// TODO: pinit fa cagare, trovare libreria migliore per disegnare in absolute
#show: gentle-clues.gentle-clues.with(breakable: true)

#attenzione[
  Dato che ancora una volta la complessità dipende dal *valore* (e non dalla lunghezza in bit) dell'input (nello specifico dai valori di $v_i$), allora l'approccio proposto è *pseudopolinomiale* (#link-section(<pseudopolinomialita>)).
]

== Scaling per Colonna (soluzione approssimata)

#informalmente[
  Questo approccio viene anche chiamato _Approccio Turco_.
  Dato che la Turchia era super super super inflazionata (un caffè costava milioni), è stata introdotta la lira pesante, ovvero la stessa valuta di prima ma divisa per $1000000$.
]

L'obiettivo dello scaling è rendere l'algoritmo precedentemente presentato polinomiale.
Per farlo andiamo a *ridurre il numero di colonne*. Al posto di usare tutte le colonne ($sum_i v$), le _compattiamo_ abbassando la *scala*, ovvero compattare i valori di diverse colonne in un'unica colonna.
Per ottenere ciò sarà necessario arrotondare, trasformando la soluzione esatta una soluzione *approssimata*.

#attenzione[
  Questo tipo di tecnica è applicabile solo alla *seconda* versione di DP.

  Questo perché, scalando le colonne, approssimiamo i valori riportati dalle colonne (falsandoli):
  - scalando la *prima* versione, riportiamo dei *pesi falsi*, ovvero intacchiamo tutte le cose che dipendono dal *peso* (quindi l'*ammissibilità*)
  - scalando la *seconda* versione, riportiamo dei *valori falsi*, ovvero intacchiamo tutte le cose che dipendono dal *valore* (quindi la funzione *obiettivo*)

  Quindi, scalando la prima versione otteniamo soluzioni *sub-ammissibili* (concetto che non abbiamo nemmeno formalizzato), scalando la seconda otteniamo soluzioni *sub-ottime*.
]

Elementi necessari per la scalatura:
- Istanza di knapsack
  $ X =(v_i, w_i, W), quad v_i, w_i, W in bb(N)^+ $
- Tasso di approssimazione $epsilon in (0, 1]$, otterremo una $(1+epsilon)$-approssimazione
- Fattore di scaling $theta$, ovvero di quanto comprimiamo i valori dell'istanza originaria.
  Lo definiamo come:
  $ theta = (epsilon V) / (2n), quad V = max_(i in n) v_i $
  #informalmente[
    $theta$ rappresenta l'unità di misura della nuova scala di valori:
    - Più $theta$ è grande, più comprimiamo (meno colonne, più approssimazione)
    - Più $theta$ è piccolo, meno comprimiamo (più colonne, meno approssimazione)
  ]

Applicando lo scaling, otteniamo:
- Nuova istanza dove i valori sono scalati, con numeri reali:
  $ overline(X) = (overline(v_i), w_i, W), quad overline(v_i) = ceil(v_i / theta) theta $
  #nota[
    Questa istanza ci serve per la dimostrazione, non sta riducendo la scala ma la sta aumentando.
  ]
- Nuova istanza dove i valori sono scalati, con numeri interi:
  $ hat(X) = (hat(v_i), w_i, W) quad hat(v_i) = ceil(v_i / theta) $

Ogni istanza (non scalata $X$, scalata reale $overline(X)$, scalata intera $hat(X)$) ha una sua soluzione ottima $I$ e valore ottimo $v$:
$ I^*, overline(I^*), hat(I^*) quad quad v^*, overline(v^*), hat(v^*) $

#esempio[
  Supponiamo $n = 4$, $epsilon = 0.2$, $V = 100$:

  $theta = (0.2 dot 100)/(2 dot 4) = 20/8 = 2.5$

  - Valori originali: $ v = [10, 25, 50, 100] $
  - Valori scalati reali: $ overline(v) = [ceil(10/2.5) dot 2.5, ceil(25/2.5) dot 2.5, ceil(50/2.5) dot 2.5, ceil(100/2.5) dot 2.5] = [10, 25, 50, 100] $
  - Valori scalati interi: $ hat(v) = [ceil(10/2.5), ceil(25/2.5), ceil(50/2.5), ceil(100/2.5)] = [4, 10, 20, 40] $

  Invece di $sum v_i = 185$ colonne, ora abbiamo $sum hat(v_i) = 74$ colonne
]

#teorema("Osservazione")[
  Risolvere l'istanza reale $overline(I)$ e l'istanza intera $hat(I)$ è la stessa cosa.
  Entrambe forniscono le *stesse soluzioni* in quanto differiscono solamente di un *coefficiente moltiplicativo fissato* $theta$.
  $
    overline(I^*) = hat(I^*) \
    overline(v^*) = theta hat(v^*)
  $

  L'istanza $hat(I)$, essendo intera, è risolvibile attraverso la programmazione dinamica.
] <knapsack-oss1>

#teorema("Teorema")[
  Sia $I$ una qualsiasi soluzione ammissibile di $X$ (problema originale non compresso).

  La soluzione ottima del problema compresso intero $hat(I^*)$, moltiplicata per $(1 + epsilon)$, è grande almeno quanto una qualsiasi soluzione $I$:

  $ (1+epsilon) sum_(i in hat(I^*)) v_i quad >= quad sum_(i in I) v_i $

  #informalmente[
    Qualsiasi soluzione ammissibile originale ha un valore non superiore al valore della soluzione ottima compressa moltiplicato per il tasso di approssimazione.
  ]

  #dimostrazione[
    Dato che approssimiamo per eccesso, allora:
    $ ceil(v_i / theta) theta >= v_i, quad forall i $

    Di conseguenza:
    $
      sum_(i in I) v_i quad <= quad sum_(i in I) ceil(v_i / theta) theta quad = quad sum_(i in I) overline(v_i)
    $

    Dato che il problema è di massimizzazione, allora $overline(I^*)$ è ottimo per l'istanza scalata reale, quindi $overline(I^*) >= overline(I)$:
    $
      sum_(i in I) overline(v_i) quad <= quad sum_(i in overline(I^*)) overline(v_i) underbrace(=, #link-teorema(<knapsack-oss1>)) sum_(i in hat(I^*)) overline(v_i)
    $

    In generale, quando approssimiamo per eccesso, la differenza tra $a$ e $a'$ è al massimo $theta$:
    $ a' = ceil(a / theta) theta, quad a' - a <= theta $

    Applicando questo a ciascun valore:
    $
      sum_(i in hat(I^*)) overline(v_i) quad & <= quad sum_(i in hat(I^*)) (v_i + mr(theta)) \
                                             & = quad sum_(i in hat(I^*)) v_i + mr(|hat(I^*)| theta) \
                                             & <= quad sum_(i in hat(I^*)) v_i + mr(n theta) \
                                             & = quad sum_(i in hat(I^*)) v_i + mr(cancel(n) (epsilon V) / (2 cancel(n))) \
    $

    Riscrivendo la disequazione:
    $ sum_(i in I) v_i quad <= quad sum_(i in hat(I^*)) v_i + (epsilon mb(V)) / mb(2) $ <knapsack-oss2>

    Dato che questa disequazione vale per ogni soluzione ammissibile $I$, allora vale anche quando $I = {i_"max"}$ con $v_(i_"max") = V$, ovvero la soluzione che contiene solo un oggetto, quello di valore massimo (che è per forza ammissibile dato che nessun oggetto può essere più grande dello zaino):
    $
            V & quad <= quad sum_(i in hat(I^*)) v_i + (mr(epsilon) V) / 2 \
            V & quad underbrace(mr(<=), mr(epsilon <= 1)) quad sum_(i in hat(I^*)) v_i + V/2 \
      mb(V/2) & quad <= quad sum_(i in hat(I^*)) v_i
    $

    Seguendo da #link-equation(<knapsack-oss2>):
    $
      sum_(i in I) v_i & quad <= quad sum_(i in hat(I^*)) v_i + epsilon mb(sum_(i in hat(I^*)) v_i)
    $

    Raccogliendo la sommatoria:
    $
      sum_(i in I) v_i quad <= quad (1+epsilon) sum_(i in hat(I^*)) v_i space qed
    $
  ]
] <knapsack-teorema1>

#teorema("Teorema")[
  Applicando la DP alla scalatura intera $hat(X)$, otteniamo come soluzione $limits(sum)_(i in hat(I^*))$, che moltiplicata per il tasso di approssimazione, è migliore del valore della soluzione ottima originale:
  $ (1+epsilon) sum_(i in hat(I^*)) v_i quad >= quad v^* $

  #dimostrazione[
    La disuguaglianza dimostrata da #link-teorema(<knapsack-teorema1>) vale per ogni $I$, di conseguenza vale anche per quella ottima $I^*$.
    Inoltre la somma di tutti i $v_i$ selezionati da una soluzione $I$, non è altro che il risultato finale $v$.
    $
      (1 + epsilon) sum_(i in hat(I^*)) v_i quad >= quad sum_(i in I^*) v_i quad = quad v^* space quad qed
    $
  ]
]

=== Analisi dell'approssimazione

Per analizzare l'approssimazione dobbiamo calcolare il massimo tra tutti i valori $hat(V)$ dell'istanza:
$
  hat(V) = ceil(V/theta) = ceil((V) / ((epsilon V)/(2n))) = ceil((V 2n)/(epsilon V))= ceil((2n)/epsilon) <= (2n)/epsilon + 1
$

Il numero di colonne della tabella DP è quindi $<= n dot hat(V) = O((2n^2) / epsilon)$, mentre il numero di righe è $n$.

Di conseguenza la complessità è $O((2 n^3)/ epsilon)$, polinomiale anche su $epsilon$, quindi $in "FPTAS"$.

#teorema("Teorema")[
  *$ "Knapsack" in "FPTAS" $*
]
