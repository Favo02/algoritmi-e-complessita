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
  *$ "VertexCover" in H(D)"-APX" $*
  dove $D$ è il grado massimo del grafo. 

  #attenzione()[
    In precendenza abbiamo dimostrato che $"VertexCover" <=_p "SetCover"$. Dato che il valore delle funzione obiettivo viene conservato, possiamo usare $"SetCover"$ per risolvere il problema $"VertexCover"$ ottenendo una stessa approssimazione. 
  ]

  #nota[
    Dato che i problemi trattasi sono $"NPOc"$, allora la versione di decisione è in $"NPc"$, di conseguenza sono tutte riducibili tra di loro [ #link-section(<riduzione-tempo-polinomiale>)]
  ]
]

== Vertex Cover mediante Pricing

In ogni istante è presente una *funzione di prezzatura*  (pricing): 
$ [<P_e> forall e in E] $

#informalmente()[
  Per ogni lato, la funzione di pricing indica il prezzo offerto dai lati (in un certo istante), per acquistare un vertice $v$ adiacente. 

  Se il prezzo offerto dai lati è variabile, il prezzo di ogni vertice è fisso.
]

Una *prezzatura* $<P_e>$ si dice *equa* se ogni vertice riceve dai lati incidenti un offerta $<=$ al suo prezzo d'acquisto $w_i$ :
$ forall i in V, quad sum_(e "t.c." i in e) P_e <= w_i $

#nota[
  La prezzatura equa banale è quando ogni lato offre $0$.
]

Una *prezzatura*  $<P_e>$ si dice *stretta* sul vertice $overline(i) in V$, se: 
$ sum_(e "t.c." overline(i) in e) P_e = w_overline(i) $

#informalmente[
  Il vertice $overline(i)$ riceve esattamente quanto chiede.
]

#figure(
  box(width: 150pt, height: 150pt, stroke: 0.5pt)[
    // Vertice centrale (costo 10)
    #place(top + left, dx: 67pt, dy: 67pt, circle(radius: 8pt, fill: red))
    #place(top + left, dx: 71pt, dy: 80pt, text(size: 18pt, fill: red, [v]))
    #place(top + left, dx: 90pt, dy: 71pt, text(size: 12pt, [$w_i = 10$], fill: red))
    
    // Tre archi con le loro prezzature
    #place(top + left, dx: 75pt, dy: 75pt, line(length: 45pt, angle: 45deg, stroke: purple))
    #place(top + left, dx: 100pt, dy: 27pt, text(size: 12pt, [$P_(e_1) = 4$], fill: green))
    
    #place(top + left, dx: 75pt, dy: 75pt, line(length: 45pt, angle: 180deg, stroke: blue))
    #place(top + left, dx: 20pt, dy: 57pt, text(size: 12pt, [$P_(e_2) = 3$], fill: blue))
    
    #place(top + left, dx: 75pt, dy: 75pt, line(length: 45pt, angle: -45deg, stroke: green))
    #place(top + left, dx: 100pt, dy: 110pt, text(size: 12pt, [$P_(e_3) = 3$], fill: purple))
  ],
  caption: [Esempio di prezzatura stretta: la somma delle offerte dei tre archi entranti in $v$ è uguale al suo costo.]
)

== Algoritmo PricingVertexCover

#informalmente[
  L'algoritmo proposto *non passa mai per offerte inique*:
  - si parte dalla prezzatura euqa banale (tutti 0):
  - ad ogni passo si cerca di creare una prezzatura stretta, in modo da acquistare un certo vertice
]

Algoritmo $"PricingVertexCover"$:
#pseudocode(
  [$P_e <- 0,forall e in E)$],
  [*While* $exists {i,j} in E "t.c" <P_e> "non è stretto nè su" i "nè su "j$],
  indent(
    [Sia $overline(e) = {overline(i),overline(j)}$ un lato t.c],
    [$Delta = min{w_overline(i) - sum_(e, overline(i) in e)P_e, w_overline(j)- sum_(e, overline(j) in e) P_e)}$],
    [#emph("stiamo cercando un qualsiai lato, dove il delta è la differenza di prezzo tra il costo del vertice "+$overline(i)$+" e quanto i lati incidenti stanno offrendo")],
    [$P_overline(e) = P_overline(e)+Delta$],
    [#emph("Aumentiamo la prezzatura di un lato, in modo tale che in almeno una delle due estremità diventi stretta")]
  ),
  [*end*]
)

#informalmente()[
  Se una prezzatura non è stretta su nessuna delle due estremità di un lato, allora vuol dire che non stiamo coprendo quel lato.
]

#let vertex-cover-graph(
  colors: ((0,0,0), (0,0,0), (0,0,0), (0,0,0), (0,0,0)), 
  weights: (0,0,0,0,0),                                    
  node_colors: (white, white, white, white)                
) = {
  box(width: 350pt, height: 200pt, stroke: 0.0pt)[
    //NODO B
    #place(top + left, dx: 37pt, dy: 147pt, circle(radius: 12pt, fill: node_colors.at(0), stroke: black))
    #place(top + left, dx: 42pt, dy: 175pt, text(size: 17pt, [$B$]))
    #place(top + left, dx: 46pt, dy: 152pt, text(size: 14pt, [$3$]))

    //NODO A
    #place(top + left, dx: 150pt, dy: 10pt, circle(radius: 12pt, fill: node_colors.at(1), stroke: black))
    #place(top + left, dx: 135pt, dy: 15pt, text(size: 17pt, [$A$]))
    #place(top + left, dx: 157pt, dy: 15pt, text(size: 14pt, [$4$]))

    //NODO C
    #place(bottom + left, dx: 150pt, dy: -28pt, circle(radius: 12pt, fill: node_colors.at(2), stroke: black))
    #place(bottom + left, dx: 153pt, dy: -12pt, text(size: 17pt, [$C$]))
    #place(bottom + left, dx: 159pt, dy: -35pt, text(size: 14pt, [$5$]))
    
    //NODO D
    #place(bottom + right, dx: -55pt, dy: -27pt, circle(radius: 12pt, fill: node_colors.at(3), stroke: black))
    #place(bottom + right, dx: -60pt, dy: -11pt, text(size: 17pt, [$D$]))
    #place(bottom + right, dx: -63pt, dy: -35pt, text(size: 14pt, [$5$]))
    
    // Linee di collegamento con colori parametrici
    // B-A
    #place(top + left, dx: 50pt, dy: 147pt, line(length: 157pt, angle: 310deg, stroke: colors.at(0)))
    #place(top + left, dx: 90pt, dy: 68pt, text(size: 14pt)[#weights.at(0)])
    
    // B-C
    #place(top + left, dx: 60pt, dy: 157pt, line(length: 90pt, angle: 360deg, stroke: colors.at(1)))
    #place(top + left, dx: 100pt, dy: 142pt, text(size: 14pt)[#weights.at(1)])
    
    // A-C
    #place(top + left, dx: 160pt, dy: 33pt, line(length: 115pt, angle: 90deg, stroke: colors.at(2)))
    #place(top + left, dx: 165pt, dy: 80pt, text(size: 14pt)[#weights.at(2)])
    
    // A-D
    #place(top + left, dx: 170pt, dy: 30pt, line(length: 167pt, angle: 46deg, stroke: colors.at(3)))
    #place(top + left, dx: 225pt, dy: 70pt, text(size: 14pt)[#weights.at(3)])
    
    // C-D
    #place(bottom + left, dx: 175pt, dy: -42pt, line(length: 95pt, angle: 0deg, stroke: colors.at(4)))
    #place(bottom + left, dx: 215pt, dy: -47pt, text(size: 14pt)[#weights.at(4)])
  ]
}

#esempio()[
  *Passo $0$*: Inizialmente il peso di ogni arco è 0.
  #figure(
    vertex-cover-graph(
      colors: (black, black, black, black, black),
      weights: (0, 0, 0, 0, 0),
      node_colors: (white, white, white, white)
    ),
    caption: [Passo $0$]
  )

  *Passo $1$*: supponiamo venga selezionato il lato ${A,B}$: 
  $ Delta = min{3-0,4-0} $
  Ottenendo $Delta = 3$, aumento $P_({A,B})$. \
  Possiamo ora comprare il lato $B$.
  #figure(
    vertex-cover-graph(
      colors: (red, black, black, black, black),
      weights: (3, 0, 0, 0, 0),
      node_colors: (red, white, white, white)
    ),
    caption: [Passo $1$]
  )

  *Passo $2$*: supponiamo venga scelto il lato ${A,D}$:
  $ Delta = {4-3,5-0} $
  Ottenendo $Delta = 4$, incremento $P_{A,D}$.\
  Posso quindi comprare il verice $A$.
  #figure(
    vertex-cover-graph(
      colors: (black, black, black, red, black),
      weights: (3, 0, 0, 1, 4),
      node_colors: (red, red, white, white)
    ),
    caption: [Passo $2$]
  )
  *Passo $3$*: l'ultima scelta possibile è il lato ${C,D}$: 
  $ Delta = min{5-0, 5-1} $
  Ottenendo $Delta = 4$, , incremento $P_{C,D}$.\
  Possiamo ora acquistare il vertice $D$
  #figure(
    vertex-cover-graph(
      colors: (black, black, black, black, red),
      weights: (3, 0, 0, 1, 0),
      node_colors: (red, red, white, red)
    ),
    caption: [Passo $3$]
  )

  L'algoritmo termina in quanto tutti i lati sono stati coperti. Soluzione finale: 
  $ {A,B} union {A,D} union {C,D} $
  Il costo totale è $10$ (i vertici acquistati).


]



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
