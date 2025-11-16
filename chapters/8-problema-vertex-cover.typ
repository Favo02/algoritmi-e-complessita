#import "../imports.typ": *

= Problema Vertex Cover (copertura di vertici) [NPOc]

#informalmente[
  Dato un grafo $G(V,E)$, vogliamo trovare un sottoinsieme di vertici $X subset.eq V$ tale che ogni lato $in E$ ha almeno un'estremo in $X$.

  Ogni lato del grafo deve essere coperto da almeno un vertice.
]

Formalmente:
- *$I_Pi$*:
  - $G(V, E)$: grafo non orientato
  - $w_i in bb(Q)^+, space forall i in V$: costo di ogni vertice
- *$"Amm"_Pi$*: insieme di vertici $X$ tale che ogni lato sia coperto da un vertice in $X$:
  $ X subset.eq V, quad forall e in E, quad e inter X != emptyset $
- *$C_Pi$*: costo totale dei vertici selezionati
  $ sum_(i in X)w_i $
- *$t_Pi$*$= min$

#nota[
  La notazione $e inter X$ è valida perché un lato $e$ non è altro che un _insieme_ di due vertici.

  In una soluzione ammissibile, almeno un'estremità di ogni lato (una coppia di vertici) deve appartenere all'insieme dei vertici coperti $X$, quindi $forall e in E, e inter X != emptyset$.
]

== Riduzione di VertexCover a SetCover [$H(D)$-APX]

#teorema("Proprietà")[
  La versione di decisione di $"VertexCover"$ è polinomialmente riducibile all'istanza di decisione di $"SetCover"$:
  *$ hat("VertexCover") <=_p hat("SetCover") $*

  #dimostrazione[
    Data un'istanza di $"VertexCover"$:
    $ x' = (underbrace(G=(V,E), "grafo"), underbrace((w_i)_(i in V), "costi"), underbrace(overline(w), "budget")) $

    Vogliamo trasformarla in un'istanza di $"SetCover"$:
    $
      x'' = (underbrace({S_1, ... ,S_m}, "aree"), underbrace((w_i)_(i in S), "costi"), underbrace(overline(v), "budget"))
    $

    Per fare ciò, definiamo la funzione $f(x') -> x''$, che costruisce:

    - Le _aree_ $S_i$ come gli insiemi che contengono gli archi $e$ incidenti su un certo vertice $V_i$:
    $
      forall i in V, quad S_i = {e in E "t.c." i in e}, quad
      union.big_(i=1)^(m) S_i = E
    $
    - I _costi_ degli insiemi come i costi del vertice che rappresentano: $v_i = w_i$
    - Il _budget_ rimane invariato: $overline(w) = overline(v)$

    #informalmente[
      I _punti_ dell'universo da coprire diventano i _lati_, mentre le _aree_ sono i _vertici_.
      Andando a selezionare un'area (quindi un vertice) copriamo tutti i lati che sono connessi a quel vertice.

      Coprendo tutti i punti dell'universo, andiamo a coprire tutti i lati, risolvendo VertexCover.
    ]

    Con la funzione $f$ un'istanza di VertexCover viene trasformata in un'istanza di SetCover (in tempo polinomiale).
    Dobbiamo anche dimostrare che una soluzione di VertexCover sia *valida* anche per SetCover, ovvero che le *soluzioni ammissibili* siano uguali:
    - _SetCover_: ogni punto dell'universo deve essere coperto da almeno un'area
    - _VertexCover_: ogni lato deve avere un'estremità in $X$

    Ma per come sono create le aree $S_i$ da $f$, ogni punto non è altro che un lato.
    Dato che le soluzioni ammissibili di _SetCover_ comprendono solo le soluzioni dove tutti i punti sono coperti, allora tutti i lati di _VertexCover_ sono coperti.

    Quindi le *soluzioni* delle istanze $x'$ e $x''$ sono le *medesime* $qed$, e il valore della *funzione obiettivo* viene conservato durante la trasformazione.
  ]
] <vertex-cover-riducibile-set-cover>

#teorema("Proprietà")[
  *$ "VertexCover" in H(D)"-APX" $*
  dove $D$ è il grado massimo del grafo.

  #dimostrazione[
    Abbiamo dimostrato che $"VertexCover" <=_p "SetCover"$ (#link-teorema(<vertex-cover-riducibile-set-cover>)).
    Dato che il valore della *funzione obiettivo* viene conservato, possiamo usare l'algoritmo di approssimazione per $"SetCover"$ che garantisce un rapporto di approssimazione $H(D)$ anche per $"VertexCover"$, ottenendo una soluzione con la *stessa approssimazione* $qed$.
  ]

  #attenzione[
    Due problemi $in "NPOc"$ *non* è detto che mantengano la *stessa approssimazione*!

    In questo esempio l'approssimazione è mantenuta perché i valori della *funzione obiettivo* sono gli stessi.
  ]
]

== Vertex Cover mediante Pricing [$2$-APX]

In ogni istante è presente una *funzione di prezzatura* (pricing):
$ chevron.l P_e chevron.r quad forall e in E $

#nota[
  Notazione:
  - $P_e$ indica il prezzo di un singolo lato $e$. È una _variabile duale_ associata al lato $e$
  - $chevron.l P_e chevron.r$ indica l'insieme di tutti i prezzi dei lati $e$. Non è propriamente una _funzione_ (nonostante si comporti come tale) ma l'_intero vettore_ di _variabili duali_
]

#informalmente[
  Per ogni lato, la funzione di pricing indica il prezzo offerto da quel lato.
  Un vertice può essere comprato se la somma dei prezzi offerti dai lati incidenti su di esso è $>=$ al suo costo.

  Mentre il prezzo offerto dai lati è _variabile_, il costo di ogni vertice è _fisso_.
]

/ Prezzatura equa:
  una prezzatura $chevron.l P_e chevron.r$ si dice *equa* se ogni vertice riceve dai lati incidenti un'offerta minore o uguale al suo prezzo d'acquisto $w_i$ (ovvero nessun vertice riceve più del suo costo):
  $ forall i in V, quad sum_(e "t.c." i in e) P_e <= w_i $

  #nota[
    La prezzatura equa banale è quando ogni lato offre $0$.
  ]

  #esempio[
    #figure(
      cetz.canvas({
        import cetz.draw: *

        // Vertici del grafo
        circle((0, 0), radius: 0.15, fill: white, stroke: black)
        content((0, -0.5), text(size: 10pt)[$8$])
        content((-0.5, 0), text(size: 10pt)[$v_1$])

        circle((2, 0), radius: 0.15, fill: white, stroke: black)
        content((2, -0.5), text(size: 10pt)[$6$])
        content((2.5, 0), text(size: 10pt)[$v_2$])

        circle((1, 1.5), radius: 0.15, fill: white, stroke: black)
        content((1, 2), text(size: 10pt)[$5$])
        content((1.5, 1.5), text(size: 10pt)[$v_3$])

        // Archi con prezzature
        line((0, 0), (2, 0), stroke: 2pt + blue)
        content((1, -0.25), text(size: 9pt, fill: blue)[$3$])

        line((0, 0), (1, 1.5), stroke: 2pt + red)
        content((0.2, 0.8), text(size: 9pt, fill: red)[$4$])

        line((2, 0), (1, 1.5), stroke: 2pt + green)
        content((1.8, 0.8), text(size: 9pt, fill: green)[$1$])
      }),
      caption: [Esempio di prezzatura equa: \
        $v_1$ riceve $mr(4)+mb(3)=7 <= 8$ \
        $v_2$ riceve $mb(3)+mg(1)=4 <= 6$ \
        $v_3$ riceve $mr(4)+mg(1)=5 <= 5$
      ],
    )
  ]

/ Prezzatura stretta:
  una prezzatura $chevron.l P_e chevron.r$ si dice *stretta* su un vertice $overline(i) in V$ se l'offerta proveniente dai lati incidenti è esattamente uguale al suo costo $w_i$:
  $ sum_(e "t.c." overline(i) in e) P_e = w_overline(i) $

  #esempio[
    #figure(
      cetz.canvas({
        import cetz.draw: *

        // Vertici del grafo
        circle((0, 0), radius: 0.15, fill: red, stroke: black)
        content((0, -0.5), text(size: 10pt)[$10$])
        content((-0.5, 0), text(size: 10pt)[$v_1$])

        circle((2, 0), radius: 0.15, fill: white, stroke: black)
        content((2, -0.5), text(size: 10pt)[$6$])
        content((2.5, 0), text(size: 10pt)[$v_2$])

        circle((1, 1.5), radius: 0.15, fill: white, stroke: black)
        content((1, 2), text(size: 10pt)[$8$])
        content((1.5, 1.5), text(size: 10pt)[$v_3$])

        // Archi con prezzature
        line((0, 0), (2, 0), stroke: 2pt + blue)
        content((1, -0.25), text(size: 9pt, fill: blue)[$4$])

        line((0, 0), (1, 1.5), stroke: 2pt + red)
        content((0.2, 0.8), text(size: 9pt, fill: red)[$6$])
      }),
      caption: [Esempio di prezzatura stretta su $v_1$: \
        $v_1$ riceve $mr(6)+mb(4)=10 = w_1$ (prezzatura stretta)
      ],
    )
  ]

=== Algoritmo PricingVertexCover

#informalmente[
  L'algoritmo proposto *non* passa mai per *offerte inique*:
  - si parte dalla prezzatura equa banale (tutti 0)
  - ad ogni passo si cerca di creare una prezzatura stretta su un certo vertice, in modo da acquistarlo
]

#pseudocode(
  [$P_e <- 0, quad forall e in E$],
  [*While* $exists space overline(e) = {i,j} in E "t.c." P_overline(e) "non è stretta né su" i "né su "j$ *do* #emph("// esiste un lato non stretto su nessuno dei due estremi")],
  indent(
    [$overline(e) <- {overline(i),overline(j)}$ #emph(
        "// lato selezionato non stretto",
      )],
    [$Delta = min(
        w_overline(i) - limits(sum)_(e, overline(i) in e) P_e, space
        w_overline(j)- limits(sum)_(e, overline(j) in e) P_e
      )$ #emph(
        "// minimo tra il costo per far diventare " + $i$ + " o " + $j$ + " stretto",
      )],
    [$P_overline(e) = P_overline(e)+Delta$ #emph(
        "// aumentiamo la prezzatura del lato, una delle due estremità diventa stretta",
      )],
  ),
  [$X <- "insieme dei vertici su cui" chevron.l P_e chevron.r "è stretta"$],
  [*Output* $X$],
)

#esempio[
  #let draw-graph-step(pricings: (:), purchased: ()) = {
    cetz.canvas({
      import cetz.draw: *

      // Vertici del grafo
      circle((0, 0), radius: 0.15, fill: if "B" in purchased { red } else { white }, stroke: black)
      content((-1, 0), text(size: 10pt)[$B, w = 3$])

      circle((2, 1.5), radius: 0.15, fill: if "A" in purchased { red } else { white }, stroke: black)
      content((2, 2), text(size: 10pt)[$A, w = 4$])

      circle((2, -1.5), radius: 0.15, fill: if "C" in purchased { red } else { white }, stroke: black)
      content((2, -2), text(size: 10pt)[$C, w = 5$])

      circle((4, 0), radius: 0.15, fill: if "D" in purchased { red } else { white }, stroke: black)
      content((5, 0), text(size: 10pt)[$D, w = 3$])

      // Archi con prezzature
      let ab-price = pricings.at("AB", default: 0)
      line((0, 0), (2, 1.5), stroke: if ab-price > 0 { 2pt + red } else { 1pt + black })
      content((0.8, 0.8), text(size: 9pt, fill: if ab-price > 0 { red } else { black })[$#ab-price$])

      let bc-price = pricings.at("BC", default: 0)
      line((0, 0), (2, -1.5), stroke: if bc-price > 0 { 2pt + black } else { 1pt + black })
      content((0.8, -0.8), text(size: 9pt, fill: black)[$#bc-price$])

      let ac-price = pricings.at("AC", default: 0)
      line((2, 1.5), (2, -1.5), stroke: if ac-price > 0 { 2pt + black } else { 1pt + black })
      content((1.7, 0), text(size: 9pt, fill: black)[$#ac-price$])

      let ad-price = pricings.at("AD", default: 0)
      line((2, 1.5), (4, 0), stroke: if ad-price > 0 { 2pt + blue } else { 1pt + black })
      content((3.2, 0.8), text(size: 9pt, fill: if ad-price > 0 { blue } else { black })[$#ad-price$])

      let cd-price = pricings.at("CD", default: 0)
      line((2, -1.5), (4, 0), stroke: if cd-price > 0 { 2pt + green } else { 1pt + black })
      content((3.2, -0.8), text(size: 9pt, fill: if cd-price > 0 { green } else { black })[$#cd-price$])
    })
  }

  / Passo $0$: Inizialmente il peso di ogni lato è 0.
    #figure(
      draw-graph-step(),
    )

  / Passo $1$: supponiamo venga selezionato il lato $mr({A,B})$:
    - $Delta = min{4-0,3-0} = 3$
    - Aumento $P_({A,B}) = 3$
    - Possiamo ora comprare il vertice $B$.
    #figure(
      draw-graph-step(pricings: ("AB": 3), purchased: ("B",)),
    )

  / Passo $2$: supponiamo venga scelto il lato $mb({A,D})$:
    - $Delta = min{4-3,3-0} = 1$
    - Incremento $P_({A,D}) = 1$
    - Posso quindi comprare il vertice $A$.
    #figure(
      draw-graph-step(pricings: ("AB": 3, "AD": 1), purchased: ("A", "B")),
    )

  / Passo $3$: l'ultima scelta possibile è il lato $mg({C,D})$:
    - $Delta = min{5-0, 3-1} = 2$
    - Incremento $P_({C,D}) = 2$
    - Possiamo ora acquistare il vertice $D$.
    #figure(
      draw-graph-step(pricings: ("AB": 3, "AD": 1, "CD": 2), purchased: ("A", "B", "D")),
    )

  L'algoritmo termina poiché non esiste alcun lato che non sia stretto su almeno uno dei due estremi.
  Soluzione finale:
  $
    X = {A,B,D}, quad 4 + 3 + 3 = 10
  $
]

#teorema("Lemma")[
  Se $chevron.l P_e chevron.r$ è una *prezzatura equa*, allora la somma della prezzatura di ogni lato $P_e$ è minore o uguale al costo della soluzione ottima $w^*$:
  $ sum_(e in E) P_e <= w^* $

  #dimostrazione[
    Per definizione di prezzatura equa sappiamo che per ogni vertice, la somma dei _prezzi degli archi_ incidenti è minore o uguale al suo _costo_:
    $ forall i, quad mr(sum_(e, i in e) P_e) <= mb(w_i) $ <vertex-cover-eq-definizione-prezzatura-equa>

    Il costo $w^*$ della soluzione ottima $X^*$ è la somma dei prezzi dei vertici selezionati da $X$:
    $ sum_(i in X^*) w_i = w^* $ <vertex-cover-eq-soluzione-ottima>

    Infine, per definizione di VertexCover, ogni lato $e$ deve essere coperto, quindi deve apparire per forza collegato ad un vertice $i$ della soluzione ottima $X^*$.
    È un minore e non un uguale dato che ogni lato potrebbe apparire per entrambi i suoi estremi, quindi due volte:
    $ sum_(e in E) P_e <= sum_(i in X^*) sum_(e, i in e) P_e $ <vertex-cover-eq-ogni-lato>

    Mettendo i pezzi insieme: // TODO: perché la sommatoria di tutti i P_e non al costo w_i della soluzione ottima come anche mostrato nella dimostazionae successiva (66)?

    $
      sum_(e in E) P_e underbrace(<=, #link-equation(<vertex-cover-eq-ogni-lato>))
      sum_(i in X^*) mr(sum_(e, i in e) P_e) underbrace(<=, #link-equation(<vertex-cover-eq-definizione-prezzatura-equa>))
      sum_(i in X^*) mb(w_i) underbrace(=, #link-equation(<vertex-cover-eq-soluzione-ottima>)) w^*
      space qed
    $
  ]
] <lemma1-vertex-cover>

#teorema("Lemma")[
  La soluzione *$w$* trovata da $"PricingVertexCover"$ è minore o uguale al doppio della prezzatura (somma delle offerte dei lati):
  $ w <= 2 sum_(e in E) P_e $

  #informalmente[
    Ogni lato, può pagare la propria offerta al *massimo* due volte, dato che può contribuire all'acquisto di *nessuno*, *uno* o *entrambi* i vertici adiacenti.
  ]

  #dimostrazione[
    Definiamo l'insieme dei vertici $X$ come l'insieme dei vertici su cui la prezzatura $P_e$ è stretta, ovvero una soluzione di PricingVertexCover.
    Il costo totale pagato è, quindi, la somma dei vertici selezionati $X$:
    $ w = sum_(i in X) mr(w_i) $

    Ma per definizione di prezzatura stretta, il costo di un vertice è uguale al prezzo offerto dai lati incidenti:
    $ w_i = mr(sum_(e, i in e) P_e) $

    Di conseguenza:
    $ w = sum_(i in X) mr(w_i) = sum_(i in X) mr(sum_(e, i in e) P_e) $

    Ogni lato potrebbe apparire al massimo due volte in questa sommatoria, dato che potrebbe apparire una volta per ogni estremo $mb(i)$:
    $
      w space = space sum_(i in X) w_i space = space sum_(i in X) sum_mb(e\, i in e) P_e underbrace(<=, mb(forall e in E\, \ e "compare" <= 2 "volte"))
      2 sum_(e in E) P_e space
      qed
    $
  ]
] <lemma2-vertex-cover>

#teorema("Teorema")[
  *$ "PricingVertexCover" in 2"-APX" $*

  #dimostrazione[
    Per #link-teorema(<lemma2-vertex-cover>):
    $
                w & <= 2 sum_(e in E) P_e \
      w / mr(w^*) & <= (2 limits(sum)_(e in E) P_e) / mr(w^*)
    $

    Ma dato che, per #link-teorema(<lemma1-vertex-cover>), $mr(w^*) >= mb(limits(sum)_(e in E) P_e)$, allora:

    $
      w / w^* space <= space
      (2 limits(sum)_(e in E) P e) / mr(w^*) space <= space
      (2 limits(sum)_(e in E) P e) / mb(limits(sum)_(e in E) P e)
      \
      w / w^* space <= space
      (2 limits(sum)_(e in E) P e) / w^* space <= space
      2 space (cancel(limits(sum)_(e in E) P e)) / cancel(limits(sum)_(e in E) P e)
      \
      w / w^* <= 2 space qed
    $
  ]
]

#teorema("Teorema")[
  Non è noto alcun algoritmo polinomiale che offre un'approssimazione significativamente migliore di $2$.

  #informalmente[
    Neanche selezionando il lato che minimizza il $Delta$ tra tutti i lati selezionabili.
  ]
]

#teorema("Teorema")[
  *$ "VertexCover" in.not "PTAS" $*

  #informalmente[
    Non esistono algoritmi che garantiscono un certo tasso di approssimazione, nemmeno, ad esempio, provando a effettuare un _bruteforce_ su una parte ridotta di lati/vertici.
  ]
]

== Vertex Cover tramite Programmazione Lineare [$2$-APX]

Ulteriore soluzione a VertexCover, anch'essa 2-approssimazione, basata sul problema della programmazione lineare.

=== Problema Programmazione Lineare (LP) [PO] <problema-programmazione-lineare>

#informalmente[
  Abbiamo $n$ variabili, ovvero gli elementi del vettore $x$.

  Queste variabili sono sottoposte a dei vincoli, ogni vincolo è una riga della matrice (quindi $m$ vincoli).

  Somma pesata degli $x_i >=$ certo valore.

  Tra tutti gli $x$ che soddisfano i vincoli (se ce ne sono), si vuole prendere quello che minimizza la funzione obiettivo (che è la somma pesata degli $x_i$).
]

Formalmente:
- *$I_Pi$*:
  - matrice $A in bb(Q)^(m times n)$: vincoli a cui sono sottoposte le variabili, ogni riga rappresenta gli scalari che moltiplicano le variabili
  - vettore $underline(b) in bb(Q)^m$: limiti o lati destri di ogni vincolo, ovvero il valore a destra della disequazione
  - vettore $underline(c) in bb(Q)^n$: costi o pesi per calcolare il valore della funzione obiettivo
- *$"Amm"_Pi$*: vettore $underline(x) in bb(Q)^n$, dove ogni riga rispetta i vincoli:
  $ A underline(x) >= underline(b) $
- *$C_Pi$*: il valore pesato del vettore $underline(x)$, dove $T$ all'esponente indica la trasposizione
  $ underline(c)^T underline(x) $
- *$t_Pi$*$= min$

#nota[
  I vincoli possono essere sia di $>=$ che $<=$ (basta cambiare i segni della riga)

  Se vogliamo un vincolo $=$, basta mettere entrambi i vincoli, sia $>=$ che $<=$.

  #attenzione[
    I vincoli stretti $>$ o $<$ sono molto più complessi _(non li vediamo)_.
  ]
]

#esempio[
  Supponiamo di avere le seguenti variabili e vincoli:
  - $x_1, x_2 in bb(Q)$ (variabili)
  - Vincoli:
    - $x_1 + 2x_2 >= 3 quad -> quad A_0 = (1, 2), quad underline(b)_0 = 3$
    - $2x_1 + x_2 <= 4 quad -> quad A_1 = (-2, -1), quad underline(b)_1 = -4$
    - $x_1 >= 0 quad quad quad quad -> quad A_2 = (1, 0), quad underline(b)_2 = 0$
    - $x_2 >= 0 quad quad quad quad -> quad A_3 = (0, 1), quad underline(b)_3 = 0$
  - Funzione obiettivo: $min(3x_1 + 2x_2)$

  In forma matriciale:
  $
    A = mat(1, 2; -2, -1; 1, 0; 0, 1), quad
    underline(b) = vec(3, -4, 0, 0), quad
    underline(c) = vec(3, 2)
  $
]

#informalmente[
  Ci vuole poco a rendere questa cosa non lineare, basta aggiungere un valore assoluto o un quadrato su un vincolo o sulla funzione obiettivo.
]

#teorema("Teorema")[
  *$ "LinearProgramming" in "PO" $*

  #dimostrazione[
    Dimostrato da _Karmarkar, 1981_.
  ]

  #attenzione[
    Nonostante esista una soluzione polinomiale, sono spesso preferite soluzioni che, nel caso peggiore, sono _esponenziali_ ma che performano meglio nel mondo reale (come l'algoritmo del Simplesso).
  ]
]


=== Programmazione Lineare Intera (ILP) [NPOc] <problema-programmazione-lineare-intera>

#informalmente[
  Stesso problema della LP, ma con solo interi come soluzioni ammissibili.

  Nonostante l'insieme delle soluzioni sia un sottoinsieme rispetto a LP, il problema è più difficile.
]

Formalmente:
- *$I_Pi$*:
  - matrice $A in bb(Q)^(m times n)$: vincoli
  - vettore $underline(b) in bb(Q)^m$: limiti destri
  - vettore $underline(c) in bb(Q)^n$: costi
- *$"Amm"_Pi$*: vettore $underline(x) in mr(bb(Z)^n)$, dove ogni riga rispetta i vincoli: $A underline(x) >= underline(b)$
- *$C_Pi$*: il valore pesato della soluzione, $underline(c)^T underline(x)$
- *$t_Pi$*$= min$

#teorema("Teorema")[
  *$ "IntegerLinearProgramming" in "NPOc" $*

  #attenzione[
    Non sono note nemmeno approssimazioni con tassi di approssimazione decenti.

    Gli algoritmi utilizzati sono esponenziali (come il branch and bound).
  ]
]

=== Vertex Cover come ILP

Possiamo trattare un'istanza di VertexCover come un'istanza di IntegerLinearProgramming.

#grid(
  columns: (1fr, 1fr),
  // align: center,
  [
    $I_"VertexCover"$:
    - grafo $G = (V,E)$
    - pesi dei vertici $chevron.l w_i chevron.r_(i in V)$
  ],
  [
    $I_"ILP"$:
    - matrice dei vincoli $A$
    - limiti destri $underline(b)$
    - costi $underline(c)$
  ],
)

Descriviamo ogni vertice come una variabile boolenata (presa nella copertura o meno):
$ x_i in {0, 1} quad forall i in V $

Possiamo definire i vincoli (da cui ricaveremo $A$ e $underline(b)$):
$
  cases(
    x_i + x_j >= 1 quad & forall {i, j} in E,
    x_i >= 0 quad & forall i in V,
    x_i <= 1 quad & forall i in V
  )
$

L'obiettivo è minimizzare il peso dei vertici presi (definendo i pesi $underline(c)$):
$ min sum_(i in V) w_i x_i $

Questa è un'istanza di vertex cover *esatta* $Pi$, che è possibile dare ad un solutore di ILP (che è, però, *esponenziale*).

=== Vertex Cover come LP approssimata

#informalmente[
  Dato che il problema di _ILP_ è _NPOc_, si può provare a rilassare il problema, ovvero cercare una soluzione in $bb(Q)$, rendendolo un problema di _LP_ (quindi _PO_).

  Le soluzioni in $bb(Q)$ andranno poi approssimate a soluzioni intere, dato che non ha senso avere variabili booleane che valgono un numero diverso da $1$ e $0$.
]

Possiamo quindi calcolare una soluzione rilassata utilizzando un solutore di LP, dove ogni variabile avrà valore $0 <= x_i <= 1$.

#teorema("Teorema")[
  Se un problema $Pi$ è un problema ILP e $tilde(Pi)$ è la sua versione rilassata LP, allora le soluzioni intere sono sicuramente maggiori o uguali a quelle razionali:
  $ w^* >= tilde(w)^* $

  #attenzione[
    Questa cosa vale per i problemi di minimizzazione, per la massimizzazione è il contrario.
  ]
] <vertex-cover-ilp-intere-rilassate>

Dalla soluzione _rilassata_ ottima $tilde(x)_i^* in bb(Q)^(|V|)$ (ottenibile in tempo polinomiale), dobbiamo trovare una soluzione *intera*.
Definiamo il vettore $underline(r)$ come:
$
  r_i = cases(
    1 quad & "se" tilde(x_i)^* >= 1/2,
    0 quad & "altrimenti"
  )
$

#informalmente[
  Questa approssimazione è un Vertex Cover valido?
]

#teorema("Osservazione")[
  Il vettore approssimato $underline(r)$ rappresenta un Vertex Cover *ammissibile*.

  #dimostrazione[
    Per assurdo, supponiamo esista un lato ${i, j} in E$ non coperto, quindi entrambi i suoi vertici valgono $0$:
    $
      exists space{i, j} in E, quad "t.c." quad r_i = 0 r_j = 0
    $
    Per essere stati approssimati a $0$ dovevano valere meno di $1/2$:
    $
      x_i^* < 1/2, quad x_j^* < 1/2 \
      x_i^* + x_j^* < 1
    $

    Ma questa cosa è impossibile, dato che esiste il vincolo $x_i^* + x_j^* >= 1, space qed$
  ]
]

#informalmente[
  Quanto è buona questa approssimazione?
]

#teorema("Osservazione")[
  Per ogni vertice, l'approssimazione $r_i$ è al massimo il doppio del valore razionale $tilde(x)_i^*$:
  $ forall i in V, quad r_i <= 2 tilde(x_i)^* $

  #dimostrazione[
    Esistono due casi:
    $
      cases(
        mb(0) <= 2 dot (0 <= tilde(x)_i^* < 1/2) & quad "se" r_i = mb(0),
        mr(1) <= 2 dot (1/2 <= tilde(x)_i^* <= 1) & quad "se" r_i = mr(1),
      )
    $
  ]
] <vertex-cover-ilp-r-approssimazione>

#teorema("Lemma")[
  L'approssimazione del vettore $underline(r)$ pesata con $w_i$ è al massimo il doppio della soluzione rilassata ottima $tilde(w)^*$:

  $ sum_(i in V) w_i r_i <= 2 tilde(w)^* $

  #dimostrazione[
    $
      sum_(i in V) w_i mr(r_i) & quad underbrace(<=, #link-teorema(<vertex-cover-ilp-r-approssimazione>)) quad sum_(i in V) w_i mr(2 tilde(x)_i^*) \
      sum_(i in V) w_i r_i & quad <= quad 2 sum_(i in V) w_i tilde(x)_i^* \
      sum_(i in V) w_i r_i & quad <= quad 2 tilde(w)^* space qed
    $
  ]
] <vertex-cover-ilp-2-approssimazione>

#teorema("Teorema")[
  Il vettore $underline(r)$ è una soluzione $2$-approssimata di VertexCover.

  #dimostrazione[
    $
      sum_(i in V) w_i r_i quad underbrace(<=, #link-teorema(<vertex-cover-ilp-2-approssimazione>)) quad 2 tilde(w)^* quad underbrace(<=, #link-teorema(<vertex-cover-ilp-intere-rilassate>)) quad 2 w^* space qed
    $
  ]
]
