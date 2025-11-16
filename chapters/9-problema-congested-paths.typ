#import "../imports.typ": *

= Problema Congested Paths [NPOc]

#attenzione[
  Questo problema è noto in letteratura come "Disjoint Paths".
]

#informalmente[
  Dato un grafo orientato e delle _sorgenti_ e _destinazioni_, vogliamo collegare le sorgenti con le corrispondenti destinazioni attraverso un _cammino_ nel grafo.

  Dato un tasso di congestione intero $c$, vogliamo che non ci siano più di $c$ cammini che passino per uno stesso arco.

  Obiettivo: massimizzare le coppie collegate (rispettando il vincolo $c$).
]

Formalmente:
- *$I_Pi$*:
  - $G = (N,A)$: grafo orientato
  - $s_0, ..., s_(k-1) in bb(N)$: lista di sorgenti
  - $t_0, ..., t_(k-1) in bb(N)$: lista di destinazioni
  - $c in bb(N^+)$: tasso di congestione
- *$"Amm"_Pi$*: insieme delle coppie collegate
  $
    I subset.eq k, quad
    forall i in I, quad exists "un cammino" pi_i: s_i ~> t_i \
    "t.c." forall a in A, quad "non ci sono più di" c "cammini" pi_i "che passano per" a
  $
- *$C_Pi$* = $|I|$: numero di coppie collegate
- *$t_Pi$*$= max$

#nota[
  È possibile specificare la stessa sorgente o destinazione più volte, basta inserirla più volte nella lista di sorgenti/destinazioni.
  L'algoritmo, lavorando sugli indici, le considererà coppie distinte.
]

== Algoritmo PricingCongestedPaths [$(2 c m^(1/(c+1))+1)$-APX]

Per l'algoritmo abbiamo bisogno di definire:

/ Costo di un cammino $pi$: somma dei costi degli archi su cui passa.
  $
    pi = chevron.l x_1,x_2,dots,x_i chevron.r \
  $

/ Funzione costo $ell$: funzione che associa ad ogni arco un costo. Se il parametro è un cammino, allora restituisce il costo del cammino.
  $
    ell : A -> bb(R)^+ \
    ell(pi) = ell(x_1, x_2)+ell(x_2, x_3)+dots+ell(x_(i-1), x_i)
  $
  #attenzione[
    Questa funzione varia nel tempo, possiamo cambiare il costo di un arco.
  ]

Oltre all'input del problema $"CongestedPath"$, all'algoritmo viene passato anche un parametro $beta in bb(Q) > 1$ _(di cui vedremo come calcolare il valore)_.

#pseudocode(
  [input $<- G=(N, A), space S, space T, space c, space beta >1$],
  [$I <- emptyset$ #emph("// indici delle coppie collegate")],
  [$P <- emptyset$ #emph("// insieme dei cammini trovati")],
  [$ell(a)=1, quad forall a in A$ #emph("// tutti gli archi costano inizialmente 1")],
  [*While* true *do*],
  indent(
    [$pi_i <-$ find the shortest path connecting $(s_i,t_i)$ for some $i in.not I$ #emph("// cammino più corto tra tutti quelli esistenti tra una coppia sorgente-destinazione")],
    [*If* such path $exists.not$ *then*],
    indent(
      [*Break*],
    ),
    [$I <- I union {i}$],
    [$P <- P union {pi_i}$],
    [*Forall* arcs $a in pi_i$ *do* #emph("// per tutti gli archi del cammino")],
    indent(
      [$ell(a) <- ell(a) dot beta$ #emph("// penalizziamo gli archi usati, aumentando il loro costo")],
      [*If* $ell(a) = beta^c$ *then* #emph("// usato " + $c$ + " volte")],
      indent(
        [delete $a$ #emph("// quindi non si può più usare, lo eliminiamo")],
      ),
    ),
  ),
  [*Output* $I, P$],
)

#informalmente[
  L'algoritmo continua a scegliere il cammino minimo più corto tra una coppia sorgente-destinazione, utilizzando l'algoritmo di Dijkstra (non basta una BFS dato che i pesi sugli archi $ell$ esistono e non sono tutti uguali).

  Una volta selezionato il cammino minimo, gli archi che ne fanno parte vengono puniti, in modo da non utilizzarli troppe volte.
  Il loro costo $ell(a)$ viene moltiplicato per $beta$.

  Quando un arco ha costo $beta^c$, allora esso è già stato utilizzato $c$ volte, di conseguenza non potrà più essere usato.
  Per questo motivo viene cancellato.
]

Un certo cammino $pi$ può avere alcune proprietà in determinati istanti dell'esecuzione:

/ Cammino Corto:
  per una certa $ell$ (quindi ad un certo istante), un cammino $pi$ si dice *corto* se il suo costo è minore di $beta^c$:
  $ ell(pi) < beta^c $

/ Cammino utile: cammino che collega una *nuova coppia* (ovvero una coppia sorgente-destinazione non ancora collegata)

/ Insieme dei cammini corti utili $C_i$: insieme dei cammini corti e utili, prima dell'esecuzione dell'$i$-esima iterazione

#attenzione[
  Queste proprietà variano in base all'istante (iterazione) in cui siamo.
]

In un dato istante, procedendo con l'esecuzione, le *trasformazioni possibili* per un cammino $pi$ sono:
- $pi "utile" -> pi "inutile"$ _(la coppia che avrebbe collegato viene collegata)_
- $pi "corto" -> pi "lungo"$ _(il costo dei suoi archi aumenta)_
- $pi "esistente" -> pi "non esistente"$ _(un suo arco viene cancellato)_

Possiamo dividere l'esecuzione dell'algoritmo in due fasi:
$
  underbrace(C_0 supset.eq C_1 supset.eq C_2 supset.eq C_3 supset.eq dots supset.eq, mr("fase 1")) underbrace(C_s, mb("fase 2," overline(ell))) = emptyset
$
- $mr("fase 1")$: l'algoritmo sceglie un cammino corto utile $pi in C_i$
- $mb("fase 2")$: i cammini corti utili sono finiti, quindi $C_s = emptyset$ e l'algoritmo termina. Questa situazione è possibile per due casi:
  - non esistono più coppie collegabili
  - rimangono coppie collegabili solo con cammini *lunghi*. Definiamo *$overline(ell)$* come la funzione nell'istante $C_s$ dove *non* ci sono più cammini utili

#attenzione[
  L'algoritmo potrebbe essere modificato in modo tale che durante la prima fase non vengano cancellati archi, ma solo messi in un _buffer in attesa di cancellazione_.
  Essi saranno cancellati solo all'inizio della seconda fase.

  Questa modifica non altera l'algoritmo.
  Il singolo arco da cancellare peserebbe $beta^c$, di conseguenza solo quell'arco è per forza più lungo di un qualsiasi altro cammino corto (che esistono per forza dato che siamo appunto nella prima fase).

  L'analisi verrà effettuata su questa versione equivalente dell'algoritmo.
]

#teorema("Lemma")[
  Supponiamo ora di eseguire l'algoritmo, che produce una soluzione $I$.
  Tutte le coppie trovate dalla soluzione ottima $I^*$ ma non dalla soluzione $I$ devono essere collegate da un cammino $pi_i^*$ lungo:

  $ forall i in I^* \\ I, quad overline(ell)(pi_i^*) >= beta^c $

  #informalmente[
    Se esistono coppie sorgente-destinazione non collegate, allora devono per forza essere connesse da cammini lunghi (altrimenti l'algoritmo avrebbe trovato tali cammini).
  ]

  #dimostrazione[
    Supponiamo per assurdo che esista un cammino $pi_i^*$ selezionato dalla soluzione ottima tale che sia corto:
    $ overline(ell)(pi_i^*) < beta^c $

    Ma dato che non è stato selezionato in $I$, allora deve per forza essere lungo:
    $ overline(ell)(pi_i^*) >= beta^c $

    Questa cosa è assurda $qed$.
  ]
] <congested-paths-lemma-soluzione-ottima>

#teorema("Teorema")[
  Il teorema fornisce un limite superiore alla somma del peso degli archi selezionati alla fine della prima fase:
  $ sum_(a in A) overline(ell)(a) quad <= quad beta^(c+1) |I_s| + m $

  Dove:
  - $I_s$ è l'insieme dei cammini aggiunti nella prima fase (numero di iterazioni)
  - $m$ è il numero di archi del grafo

  #dimostrazione[
    Vogliamo dimostrare che ad ogni iterazione, la somma dei pesi degli archi cresce al massimo di $beta^(c+1)$, lo facciamo per induzione:

    + *Passo Base*. All'inizio il peso di tutti gli archi è inizializzato a $1$:
      $ sum_(a in A) underbrace(ell(a), =1) = m $


    + *Passo induttivo*. Quando aggiungo un nuovo cammino $pi$, il peso di tutti gli archi $a in A$ viene aggiornato, modificando la funzione $ell -> ell^'$:
      $
        ell'(a) = cases(
          mg(ell(a)) & quad "se" a in.not pi,
          mg(beta dot ell(a)) & quad "se" a in pi
        )
      $
      Calcoliamo ora di quanto è variata la somma del peso degli archi, facendo la differenza tra tutti gli archi della funzione $ell'$ e quelli all'istante precedente $ell$:
      $
          & sum_(a in A) ell'(a) - sum_(a in A) ell(a) \
        = & sum_mb(a in A) (mg(ell'(a)) - ell(a))
      $
      Possiamo dividere l'insieme dei lati $a in A$ tra i lati nel nuovo cammino $in pi$ e i lati non nel nuovo cammino $in.not pi$
      $
        = sum_mb(a in pi) (mg(beta ell(a)) - ell(a)) - underbrace(sum_mb(a in.not pi)(mg(ell(a)) - ell(a)), = 0)
      $
      Raccogliendo $ell(a)$:
      $
        = & sum_(a in pi) ell(a) mr((beta-1)) \
        = & mr((beta-1)) underbrace(sum_(a in pi) ell(a), = ell(pi)) \
        = & mr((beta-1)) ell(pi)
      $
      Siccome siamo nella prima fase, allora $mb(ell(pi)) < beta^c$:
      $
        = mr((beta-1)) mb(ell(pi)) quad < quad mr((beta-1)) mb(beta^c) quad < quad beta^(c+1)
      $

    Abbiamo dimostrato che ad ogni iterazione la somma dei pesi degli archi cresce al massimo di $mp(beta^(c+1))$.
    Dato che ci sono esattamente $mm(|I_s|)$ esecuzioni nella prima fase e il peso iniziale di $limits(sum)_(a in A) ell(a) = mg(m)$, allora abbiamo dimostrato l'upper bound dei pesi degli archi dopo la prima fase:
    $ sum_(a in A) overline(ell)(a) quad <= quad mp(beta^(c+1)) mm(|I_s|) + mg(m) space qed $
  ]
] <congested-paths-teorema-upper-bound-somma-pesi-archi>

#teorema("Osservazione")[
  La somma del peso dei cammini $pi_i^*$ selezionati dalla soluzione ottima $I^*$ ma non dalla soluzione dell'algoritmo $I$ è grande almeno quanto $beta^c$ per il numero di questi cammini:

  $ sum_(i in I^* \\ I) overline(ell)(pi_i^*) quad >= quad beta^c |I^* \\ I| $

  #dimostrazione[
    Per il #link-teorema(<congested-paths-lemma-soluzione-ottima>), ogni cammino non selezionato è lungo:
    $
                               forall i in I^* \\ I, & quad overline(ell)(pi_i^*) >= beta^c \
      sum_(i in I^* \\ I) overline(ell)(pi_i^*) quad & >= quad sum_(i in I^* \\ I) beta^c \
      sum_(i in I^* \\ I) overline(ell)(pi_i^*) quad & >= quad |I^* \\ I| beta^c space qed
    $
  ]
] <congested-paths-oss1>

#teorema("Osservazione")[
  La somma del peso dei cammini selezionati dalla soluzione ottima $I^*$, ma non dalla soluzione dell'algoritmo $I$, è limitata da $c$ volte il peso massimo della somma dei cammini alla fine della prima fase (trovato in #link-teorema(<congested-paths-teorema-upper-bound-somma-pesi-archi>)):

  $ sum_(i in I^* \\ I)overline(ell)(pi_i^*) quad <= quad c(beta^(c+1)|I_s|+m) $

  #dimostrazione[
    Per definizione del problema, nessun arco $a in A$ può essere usato dai cammini più di $c$ volte.
    Di conseguenza, anche se tutti i cammini usassero tutti gli archi:
    $ sum_(i in I^* \\ I) overline(ell)(pi_i^*) quad <= quad c sum_(a in A) overline(ell)(a) $
    Per il #link-teorema(<congested-paths-teorema-upper-bound-somma-pesi-archi>):
    $ c mr(sum_(a in A) overline(ell)(a)) <= c mr((beta^(c+1)|I_s|+m)) space qed $
  ]

] <congested-paths-oss2>

#teorema("Teorema")[
  L'algoritmo $"PricingCongestedPaths"$ con input $beta = m^(1/(c+1))$ dà una
  $ (2 c m^(1/(c+1))+1)"-approssimazione" $

  #dimostrazione[
    Partiamo applicando il principio di inclusione-esclusione sull'insieme $I^*$:
    $ I^* = (I^*\\I) + (I^* inter I) $
    Passando alle cardinalità e moltiplicando per $beta^c$:
    $ beta^c |I^*| <= mr(beta^c |I^* \\ I|) + beta^c mb(|I^* inter I|) $
    Per #mr(link-teorema(<congested-paths-oss1>)) e dato che #mb("l'intersezione") tra due insiemi è sempre $<=$ dei due insiemi originali:
    $ beta^c |I^*| <= mr(sum_(i in I^* \\ I) overline(ell)(pi_i^*)) + beta^c mb(|I|) $
    Per #mr(link-teorema(<congested-paths-oss2>)):
    $ beta^c |I^*| <= mr(c(beta^(c+1) mg(|I_s|) + m)) + beta^c |I| $
    Siccome il numero di iterazioni totali $mg(|I|)$ è maggiore del numero di iterazioni della prima fase $mg(|I_s|)$:
    $ beta^c |I^*| <= c(beta^(c+1) mg(|I|) + m) + beta^c |I| $
    Dividendo per $beta^c$:
    $
      (beta^c|I^*|) / mr(beta^c) & <= (c(beta^(c+1) |I| + m) + beta^c |I|) / mr(beta^c) \
                           |I^*| & <= c(beta^(c+1)|I| + m) / mr(beta^c) + (beta^c|I|) / mr(beta^c) \
                           |I^*| & <= (c beta^(c+1)|I|)/mr(beta^c) + (c m) / mr(beta^c) + |I| \
                           |I^*| & <= c beta |I| + c m beta^(-c) + |I| \
                           |I^*| & <= c(beta|I|+m beta^(-c))+|I| \
                           |I^*| & <= c(beta+m beta^(-c)) dot |I|+|I|
    $
    Calcoliamo il rapporto di approssimazione:
    $
      (|I^*|) / (|I|) <= (c(beta + beta^(-c) m) dot |I| + |I|) / (|I|) \
      (|I^*|) / (|I|) <= c(beta + beta^(-c) m) + 1
    $
    L'approssimazione dipende dal parametro $beta$.
    Analizzando questa funzione, il minimo si ottiene come:
    $ beta eq.delta m^(1/(c+1)) $
    Quindi il *miglior tasso di approssimazione*:
    $
      (|I^*|) / (|I|) & <= c(m^(1/(c+1)) + m^(-(c/(c+1))) m) + 1 \
                      & <= 2c m^(1/(c+1))+1 space qed
    $
  ]
]

L'approssimazione ottenuta dipende dal numero di archi $m$ e dal tasso di congestione $c$.
Tipicamente $c$ è un numero piccolo, fissandolo otteniamo:

#figure(
  table(
    columns: 2,
    rows: 20pt,
    align: center,
    table.header([Parametro $c$], [Approssimazione]),
    fill: (_, y) => if y == 0 { gray.lighten(50%) } else { white },
    [1], [$2sqrt(m) + 1$],
    [2], [$4 root(3, m) + 1$],
    [3], [$6 root(4, m) + 1$],
    [$dots.v$], [$dots.v$],
  ),
)

#informalmente[
  Il tasso di approssimazione ottenuto è *pessimo*, soprattutto se le coppie che si vogliono collegare sono poche.
  Ha senso utilizzare questo algoritmo solo se il numero di coppie sorgente-destinazione è molto elevato *$k >> 2sqrt(m) + 1$*.
]
