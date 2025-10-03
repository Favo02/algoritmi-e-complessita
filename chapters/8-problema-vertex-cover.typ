#import "../imports.typ": *

= Problema Vertex Cover (copertura di vertici)

#informalmente[
  Dato un grafo $G(V,E)$, vogliamo trovare un sotto-insieme di vertici $S subset.eq V$ tale che, ogni lato $in E$ ha almeno un estremo in $S$.  

  Ogni lato del grafo deve essere coperto da almeno un vertice.
]
Formalmente:
- *$I_Pi$*:
  - $G(V, E)$: grafo non orientato
  - $w_i in bb(Q)^+, forall i in V$. Ogni vertice ha un costo
- *$"Amm"_Pi$*: $X subset.eq V, "t.c" forall e in E, e inter X != emptyset$
- *$C_Pi$*: $sum_(i in X)w_i$. Costo totale dei vertici selezionati
- *$t_Pi = min$*

#informalmente[
  In una soluzione ammissibile, almeno un estremità di ogni lato (una coppia di vertici) deve appartenere all'insieme dei vertici coperti $X$.
]


#teorema("Proprietà")[
  La versione di decisione di $"VertexCover"$ è polinomialmente riducibile all'istanza di decione di $"SetCover"$:
  *$ hat("VertexCover") <=_p hat("SetCover") $*

  #dimostrazione()[
    Data un istanza di $"SetCover"$: 
    $ x = (G=(V,E), (w_i)_(i in V), hat(w)) $

    Vogliamo trasformala in un istanza di $"SetCover"$:
    $ m = (f(x) = {S_1,....,S_2}, v_(i in {1,dots,m}),hat(v)) $

    Trasformazioni: 
    - Gli insiemi $S_i$ contengono tutti gli archi incidenti su un certo vertice $V_i$: 
    $ 
      forall i in V_i, S_i = {e in E | i in e}\
      union.big_(i=1)^(m) S_i = E
    $
    - I costi degli insiemi sono i costi dei vertici: 
     $ v_i = w_i $  
    - Stessa soglia 
     $ hat(w) = hat(v) $
    
    Possiamo definire ora una *soluzione ammissibile*: 
    Scelta di $S_i$ che coprono tutti i lati del grafo. Ovvero devo scegliere dei vertici tali che tutti i lati del grafo originale hanno almeno un lato dentro un sotto-insieme $S_i$.

    Le *soluzoni delle istanze $m$ e $x$ sono le medesime*. \
    Il *valore della funzione obiettivo viene conservato* durante la trasformazione. 
  ]
]

#teorema("Proprietà")[
  $ "VertexCover" in H(D)"-APX" $
  dove $D$ è il grafo massimo del grafo.

  #informalmente[
    Dato che sappiamo trasformare un'istanza di Vertex cover in setcover, allora è possibile applicare lo stesso algorimto, che ci fa ottenere la stessa approssimazione.
  ]

  #informalmente[
    Dato che tutti questi problemi sono NPOc, allora la versione di decisione è in NPc, di conseguenza sono tutte riducibili tra di loro.

    Quello di "strano" che succede qua è che anche le versioni di ottimizzazione sono riducibili e quindi hanno (come minimo) stessa approssimazione.
  ]
]

== Vertex Cover mediante Pricing

#informalmente[
  Ogni vertice ha un prezzo, ma questo prezzo può essere pagato da più di un lato, dato che pagando una sola volta il prezzo entrambi i lati sarebbero coperti da quel vertice.
]

/ Funzione di prezzatura (pricing):
  $<"Pe"> forall e in E$

Una prezzatura si dice *equa* se ogni vertice riceve al massimo quello che chiede:
$ forall i in V, quad sum_(e "t.c. i in e") P_e <= w_i $

#informalmente[
  Se ad ogni vertice è offermo meno o uguale a quanto richiede.
  La prezzatura equa banale è dove ogni lato offre $0$.
]

Prezzatura stretta: una prezzatura $<"Pe">$ è stretta sul vertice $overline(i) in V$, se: $ sum_(e "t.c." overline(i) in e) "Pe" = w_i $

#informalmente[
  Tutti i vertici ricevono esattamente quanto chiedono.
]

== Algoritmo PricingVertexCover

#informalmente[
  Idea dell'algoritmo:
  - partire dalla prezzatura euqa banale (tutti 0):
  - far diventare stretta la prezzatura su qualche vertice ()
]

- $"Pe" <- 0 forall e in E$
- *While* $exists space [i, j] in E "t.c." <"Pe">$ non è stretto nè su $i$ nè su $j$: \/\/ se una prezzatura non è stretta su nessuna delle due estremità di un lato, allora vuol dire che non stiamo coprendo quel lato
  - sia $overline(e) = {overline(i), overline(j)}$ un lato tale che
  $ Delta = min underbrace(w_overline(i) - sum_e, > 0) "Pe", w_overline(j) - sum_e "Pe" $
  - $P overline(e) <- P overline(e) + Delta$ \/\/ abbiamo scelto uno dei due vertici di un lato e abbiamo fatto diventato quel vertice stretto
- ...

#teorema("Lemma")[
  Se $<P e>$ è una pezzatura qeual, allora:
  $ sum_(e in E) P e <= w^* $

  #dimostrazione[
    Per definizione di equo:

    $
      forall i, quad sum_(e "t.c." i in e) P e <= w_i \
      ...
    $
    #informalmente[
      Ma tutti i lati devono contenere, dato che è un vertex cover.
      Qualche lato potrebbe apparire due volte dato che entrambi gli estremi siano nel set dei vertici presi, ma tutti almeno una volta.
      Quindi è maggiore uguale della sommatoria sui singoli lati.
    ]
  ]
]

#teorema("Lemma")[
  La soluzione $w$ trovata da PricingVertexCover soddisfa la proprietà che $ w <= 2 sum_(e in E) P e $

  #informalmente[
    Ogni lato può pagare ad una delle due estremità o ad entrambe, ma non più di così.
  ]

  #dimostrazione[
    X = insieme dei vertici su cui Pe è stretto
    $ w = sum_(i in X) w_i = sum_(i in X) sum_(e "t.c." i in e) P e <= 2 sum_(e in E) P e space qed $

    Per definizione se $w_i$ è stretto,allora la somma dei vertici che vi incino è uguale.

    Ogni $e$ compare $<= 2$ volte.
  ]
]

#teorema("Teorema")[
  *$ "PricingVertexCover" in 2"-APX" $*

  #dimostrazione[
    $
      w / w^* underbrace(<=, "lemma2") (2 sum_(e in E) P e) / w^* underbrace(<=, "lemma1") (2 sum_(e in E) P e) / (sum_(e in E) P e) <= 2 space qed
    $
  ]
]

#informalmente[
  Nel precedente problema, il pricing era usato come metodo per andare ad ottimizzare due obiettivi (il numero di punti coperti e il costo dell'area).

  In questo problema il pricing ha più il senso della parola, ha quasi delle prorprietà economiche (i lati offrono una cifra, i vertici hanno un costo per coprire).
]

#teorema("Teorema")[
  Non è noto alcun algoritmo polinomiale migliore di questa approssimazione.
]

#teorema("Teorema")[
  *$ "VertexConver" in.not "PTAS" $*
]
