#import "../imports.typ": *

= Problema Traveling Saleman in uno spazio metrico

#informalmente[
  Problema dei ponti di Königsberg.
  Percorrere tutti i ponti una volta sola e tornare al punto di partenza. Vogliamo quindi cercare un cammino Euleriano. Si rimanda alle definizioni di circuito, nel capitolo #link-section(<grafi>)
]

#teorema("Teorema")[
  Un multigrafo ammette un circuito Euleriano sse è connesso e tutti i suoi vertici hanno grado pari.

  #dimostrazione[
    #attenzione[
      Questa non è davvero una dimostrazione, ma solo una costruzione che mostra il senso $<==$ dell'implicazione. Ovvero come costruire un circuito dato un grafo connesso di grado $2$.
    ]

    //TODO FARE DISEGNO 

    Dato un grafo iniziamo a seguire un cammino che parte dal vertice $x$: 
    - Si procede con la visita fino a quando non si torna su un vertice già visitato.
    - Se siamo ritornati su un vertice già visitato, allora ha almeno $3$ lati.
    - Siccome il grafo ha grado pari, significa che deve per forza esserci un'altro lato
    - Continuiamo questa procedura fino a quando non si torna al vertice $x$ 
  ]
]

== Handshaking Lemma

#informalmente[
  Se un gruppo di persone in una stanza si stringe la mano (non per forza tutti devono dare la mano), il numero di persone che ha stretto un numero dispari di mani è pari.

  Questo genere di teorie (asserire dei risultati certi su eventi "strani"), prendono il nome di *Teorema di Ramsey*. Da una certa dimensione del problema in poi, appaiono dei pattern inevitabili.
]

#teorema("Lemma")[
  In ogni grafo non orientato, il numero di vertici di grado dispari è pari.

  #informalmente[
    Rappresentazione a grafo delle persone (vertici) e strette di mano (lati).
  ]

  #dimostrazione[
    Dato un grafo $G=(V,E)$, sia $d(x),x in V$. Sia $d(x)$ il grado di un vertice: 
    $ sum_(x in V) d(x)  = 2m $
    Sto sommando per ogni vertice il suo grado, ogni lato viene contato $2$ volte.\
    - Le componenti pari della sommatoria non contanto. Partendo da una quantità pari e sommando solamente quote pari il risultato è di nuovo pari. 
    - Le componenti dispari possono cambiare la parità della sommatoria. Ma siccome la sommatoria finale da un risultato pari, il numero di componenti dispari è pari. 
  ]
]

== Problema Commesso Viaggiatore (TSP) [NPOc]

- *$I_Pi$*:
  - $G(V, E)$, grafo non orientato
  - $angle.l delta_e angle.r_(e in E) in bb(Q)^+$, pesi dei lati 
- *$"Amm"_Pi$*: circuito hamiltoniano $pi in G$, cioè un circuito che tocchi tutti i vertici esattamente una volta, oppure $bot$
- *$C_Pi$*: lunghezza del circuito hamiltoniano:
  $ delta = sum_(c in pi) delta_e $
- *$t_Pi$* = $min$

== TSP Metrico [NPOc]

Tuttavia vedremo una versione del problema che lavora in uno spazio metrico. Avremo dei vincoli aggiuntivi sul grafo $G(V,E)$:
+ $G$ è una *clique*
+ $delta_e$ è una *metrica*, cioè:
  - Vale la distanza triangolare $delta_{x,y} + delta_{y,z} >= delta_{x,z}$

#attenzione[
  Senza la seconda limitazione, allora è possibile trasformare qualsiasi grafo (non per forza cricca) in una cricca.
  Basta aggiungere tutti i lati mancanti con un costo enorme.
  #esempio()[
    #figure(
      cetz.canvas({
        import cetz.draw: *

        // Vertici del grafo
        circle((0, 0), radius: 0.15, fill: white, stroke: black)
        content((0, -0.5), text(size: 10pt)[$$])
        content((-0.5, 0), text(size: 10pt)[$v_1$])

        circle((2, 0), radius: 0.15, fill: white, stroke: black)
        content((2, -0.5), text(size: 10pt)[$6$])
        content((2.5, 0), text(size: 10pt)[$v_2$])

        circle((1, 1.5), radius: 0.15, fill: white, stroke: black)
        content((1, 2), text(size: 10pt)[$5$])
        content((1.5, 1.5), text(size: 10pt)[$v_3$])

        circle((1, -1.5), radius: 0.15, fill: white, stroke: black)
        content((1, 2), text(size: 10pt)[$5$])
        content((1.5, -1.5), text(size: 10pt)[$v_4$])

        // Archi con prezzature
        line((0, 0), (2, 0), stroke: 1pt + red)
        content((0.75, 0.25), text(size: 9pt, fill: red)[$17$])

        line((0, 0), (1, 1.5), stroke: 1pt + black)
        content((0.2, 0.8), text(size: 9pt, fill: black)[$4$])

        line((2, 0), (1, 1.5), stroke: 1pt + black)
        content((1.8, 0.8), text(size: 9pt, fill: black)[$1$])

        line((1, 1.4), (1.0, -1.4), stroke: 1pt + black)
        content((1.8, 0.8), text(size: 9pt, fill: black)[$1$])

        line((1, -1.5), (2.0, 0.0), stroke: 1pt + black)
        content((1.8, 0.8), text(size: 9pt, fill: black)[$1$])
      
        line((1, -1.5), (0.0, 0.0), stroke: 1pt + red)
        content((0.3, -1.0), text(size: 9pt, fill: red)[$17$])
      
      }),
      caption: [Gli archi di colore $mr("rosso")$ sono quelli fittizzi.\ 
      Come si può esservare il grafo originale non era una clique],
    )
  ]
  L'algoritmo non li sceglierà mai, in quanto vuole trovare il circuito minimo. Se l'algoritmo scegliesse dei lati fittizzi nella soluzione prodotta, allora li grafo di partenza non conteneva un circuito Hamiltoniano.
]

#teorema("Teorema")[
  *$ "TSP Metrico" in "NPOc" $*
]

== Algoritmo di Christofides per TSP metrico

L'algoritmo sfrutta le seguenti componenti: 
- *Minimum Spanning Tree*, ovvero una scelta di lati che è un albero e tocca tutti i vertici. Tra tutti i possibili spanning tree, prendiamo il minimo.\ 
  Tale problema è risolvibile in tempo polinomiale $->$ algoritmo di Kruskal.

- *Minimum-weight perfect matching $in "PO"$*, Dato un grafo $G=(V,E)$ pesato e con un numero pari di vertici, l'obiettivo è trovare un perfect matching di costo minimo (tutte le coppie sposate).\
 Tale problema è risolvibile in tempo polinomiale $->$ algoritmo di Edmons. 
 
#pseudocode(
  [*Input*: $G(V, E =binom(V, 2)), angle.l delta_e angle.r_(e in E)$],
  [$T <- $ *Minimum Spanning Tree*],
  [$D <- $ insieme dei vertici di grado dispari in $T$],
  [#emph("Per handshaking lemma " +$|D|$+ "è pari" )],
  [$M <- $ *Minimum-weight perfect matching* su $D$],
  [#emph($M$+" e "+$D$+ " possono contenere dei lati ripetuti")],
  [$M union T <- $ multigrafo],
  indent(
    [Tutti i vertici in $M$ hanno grado pari #emph("(per pefect matching)")],
    [$exists$ un circuito Euleriano $tilde(pi)$],
  ),
  [$pi <- tilde(pi)$, *$"Shortcircuit"$* ],
  [#emph("Il cirucuito euleriano "+$tilde(pi)$+" potrebbe passare per più vertici")],
)

#nota([
  Siccome sono in una clique, posso trasformare un circuito Euleriano in un circuito Hamiltoniano effetuando una *cortocircuitazione*: 
  - Quando incontro un vertice già visitato sul cammino passo ad uno non ancora visitato, sfruttando l'arco diretto.
  #esempio([
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Vertici del grafo
      circle((0, 0), radius: 0.15, fill: white, stroke: black)
      content((0, -0.5), text(size: 10pt)[$4$])
      content((-0.5, 0), text(size: 10pt)[$A$])

      circle((3.0, -1.0), radius: 0.15, fill: white, stroke: black)
      content((2, -0.5), text(size: 10pt)[$6$])
      content((3.2, -0.7), text(size: 10pt)[$B$])

      circle((2.0, 1.0), radius: 0.15, fill: white, stroke: black)
      content((1, 2), text(size: 10pt)[$$])
      content((2.0, 1.5), text(size: 10pt)[$C$])

      circle((1, -2), radius: 0.15, fill: white, stroke: black)
      content((1, -2.5), text(size: 10pt)[$D$])

      circle((-1, -1), radius: 0.15, fill: white, stroke: black)
      content((-1.3, -1.3), text(size: 10pt)[$E$])

      // Circuito Euleriano con ordine di visita (archi blu solidi)
      line((0.1, 0.1), (1.9, 0.9), stroke: 2pt + blue)
      content((1, 0.7), text(size: 9pt, fill: blue)[$1$])

      line((2.1, 0.9), (2.9, -0.9), stroke: 2pt + blue)
      content((2.7, 0), text(size: 9pt, fill: blue)[$2$])

      line((2.9, -1.1), (1.1, -1.9), stroke: 2pt + blue)
      content((2, -1.7), text(size: 9pt, fill: blue)[$3$])

      line((0.9, -2), (-0.9, -1.1), stroke: 2pt + blue)
      content((0, -1.8), text(size: 9pt, fill: blue)[$4$])

      line((-0.9, -0.9), (-0.1, -0.1), stroke: 2pt + blue)
      content((-0.7, -0.3), text(size: 9pt, fill: blue)[$5$])

      // A -> B di nuovo (6) - già visitato! (arco rosso tratteggiato)
      line((0.1, 0.1), (1.9, 0.9), stroke: (paint: red, thickness: 3pt, dash: "dashed"))
      content((1.0, 0.15), text(size: 10pt, fill: red)[$6$])

      // Shortcircuit: A -> C diretto (arco verde punteggiato)
      line((0.1, -0.1), (2.9, -0.9), stroke: (paint: green, thickness: 3pt, dash: "dotted"))
      content((1.5, -0.8), text(size: 9pt, fill: green)[*shortcut*])
    }),
    caption: [Esempio di shortcircuit: il circuito Euleriano $tilde(pi)$ visita B due volte, quindi si effettua un collegamento diretto A→C per ottenere il circuito Hamiltoniano $pi$.]
  )
])

])

#teorema("Lemma")[
  Sia $T$ uno spanning tree minimo per un grafo $G=(V,E)$:
  $ delta(T) <= delta^* $

  #dimostrazione[
    Sia $pi^*$ un circuito Hamiltoniano ottimo per TSP.\
    Se togliamo un lato da $pi^*$, otteniamo un grafo aciclico che copre tutti i lati, ovvero uno spanning tree.

    $ forall e in pi^*, quad delta^* >= delta^* - delta_e >= delta(T) space qed $

    Ma lo spanning tree è per forza $>=$ al costo dello spanning tree minimo $T$.
  ]
]<lemma-1-spanning>

#teorema("Lemma")[
  Dati: 
  - $T <- $ minimum spannig tree
  - $D <- $ insieme dei vertici di  grado dispari di $T$
  Consideriamo $M$, ovvero il minimum weight perfect matching su $D$: 
  $ delta(M) <= 1/2 delta^* $

  #dimostrazione[
    Prendiamo $pi^*$ (TSP ottimo) e cortocircuitiamo sui vertici di $D$ (i vertici di grado dispari sull'albero).

  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Vertici del grafo (disposizione secondo l'immagine)
      // Vertici neri (appartenenti a D - grado dispari)
      circle((0, 0), radius: 0.15, fill: black, stroke: black)
      content((-0.4, -0.3), text(size: 10pt, fill: black)[$v_1$])

      circle((3, 0), radius: 0.15, fill: black, stroke: black)
      content((3.4, -0.3), text(size: 10pt)[$v_2$])

      circle((3, 2), radius: 0.15, fill: black, stroke: black)
      content((3.4, 2.3), text(size: 10pt)[$v_3$])

      circle((0, 2), radius: 0.15, fill: black, stroke: black)
      content((-0.4, 2.3), text(size: 10pt, fill: black)[$v_4$])

      // Vertici bianchi (grado pari)
      circle((1.5, 3), radius: 0.15, fill: black, stroke: black)
      content((1.5, 3.4), text(size: 10pt, fill:black)[$v_5$])

      circle((-0.5, 1), radius: 0.15, fill: white, stroke: black)
      content((-1, 1), text(size: 10pt)[$v_6$])

      circle((3.5, 1), radius: 0.15, fill: white, stroke: black)
      content((4, 1), text(size: 10pt)[$v_7$])

      // Circuito Hamiltoniano ottimo π* (archi neri solidi)
      line((0.15, 0.05), (2.85, 0.05), stroke: 2pt + red)
      line((2.85, 2), (1.6, 2.85), stroke: 2pt + black)
      line((1.4, 2.85), (0.15, 2), stroke: 2pt + black)
      line((0, 1.85), (-0.4, 1.1), stroke: 2pt + black)
      line((-0.4, 0.9), (0, 0.15), stroke: 2pt + black)
      line((3.15, 1.85), (3.4, 1.1), stroke: 2pt + black)
      line((3.4, 0.9), (3, 0.15), stroke: 2pt + black)

      // Matching M₁ (linee rosse)
      line((3, 2), (0, 2), stroke: 2pt + red)
      content((4.5, 0.5), text(size: 10pt, fill: red)[$M_1$])

      // Matching M₂ (linee verdi)
      line((3, 0.15), (3, 1.85), stroke: 2pt + green)
      content((4.5, 1.5), text(size: 10pt, fill: green)[$M_2$])

      line((0, 0), (0, 2), stroke: 2pt + green)
      content((4.5, 1.5), text(size: 10pt, fill: green)[$M_2$])

      // Legenda
      content((3.5, 3.0), text(size: 12pt)[$pi^*$])

      content((1.5, 2.3), text(size: 12pt)[$overline(pi)^*$])

    }),
    caption: [
      Dal circuito ottimo $pi^*$ si identificano i vertici di grado dispari $D$ (rispetto all'albero).\ 
      I matching $mr(M_1)$ e $mg(M_2)$ collegano alternativamente i vertici di $D$ seguendo il percorso cortocircuitato, creando il cammino $overline(pi)^*$.
    ]
  )
    Possiamo collegare tra loro i vertici $in D$, formando un ciclo $overline(pi)^*$. Grazie alla disuguaglianza triangolare, allora: 
    $ delta(overline(pi)^*) <= delta(pi^*) $

    $overline(pi)^*$ è un circuito su un numero pari di vertici, lo divido a metà e scelgo in maniera alternata i lati, formando $mr(M_1)$ e $mg(M_2)$.

    $ delta^* >= quad delta(overline(pi)^*) = delta(mr(M_1)) + delta(mg(M_2)) $

    Ma $mr(M_1)$ e $mg(M_2)$ sono dei perfect matching, ma sono maggiori del minimum perfect matching $M$:

    $ 
      delta^* >= delta(mr(M_1)) + delta(mg(M_2)) >= delta(M) + delta(M) >= 2 delta(M) space\ 
      delta^* >= 2 delta(M) \
      delta(M) <= 1/2 delta^*
    $

  ]
]<lemma-2-multigrafo>

#teorema("Teorema")[
  L'algoritmo di Christofides è una *$3/2$-approssimazione* per il TSP metrico.

  #dimostrazione[
    Consideriamo il multigrafo $T union M$. Esso contiene un cammino Euleriano $pi_"euler"$, l'idea è cortocircuitarlo per ottenere un cammino hamiltoniano $pi$:
    $
      delta(pi) & <= delta(pi_"euler") = delta(T) + delta(M) \
      delta(pi) &underbrace(<=,#link-teorema(<lemma-1-spanning>) " "e #link-teorema(<lemma-2-multigrafo>)) delta^* + 1/2 delta^* = 3/2 delta^* space qed
    $
  ]
]

=== Strettezza dell'analisi

Per dimostrare che l'analisi proposta è stretta, costruiamo un grafo per cui l'algoritmo proposto è una $3/2$-approssimazione.\
Consideriamo il seguente cammino, con *$n$ pari*:
#esempio([
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Cammino principale con vertici (figura più grande)
      circle((0, 0), radius: 0.15, fill: white, stroke: black)
      content((0, -0.35), text(size: 13pt)[$v_1$])

      circle((1.5, 0), radius: 0.15, fill: white, stroke: black)
      content((1.5, -0.35), text(size: 13pt)[$v_2$])

      circle((3, 0), radius: 0.15, fill: white, stroke: black)
      content((3, -0.35), text(size: 13pt)[$v_3$])

      content((3.8, 0), text(size: 13pt)[$dots.c$])

      circle((5.5, 0), radius: 0.15, fill: white, stroke: black)
      content((5.8, -0.35), text(size: 12pt)[$v_(n-1)$])

      circle((4.5, 0), radius: 0.15, fill: white, stroke: black)
      content((7, -0.40), text(size: 13pt)[$v_n$])

      circle((7, 0), radius: 0.15, fill: white, stroke: black)
      content((7, -0.40), text(size: 13pt)[$v_n$])

      // Archi del cammino MST T (gialli) - collegamenti corretti ai bordi dei cerchi
      line((0.15, 0), (1.35, 0), stroke: 4pt + yellow)
      content((0.75, 0.25), text(size: 9pt)[$1$])

      line((1.65, 0), (2.85, 0), stroke: 4pt + yellow)
      content((2.25, 0.25), text(size: 9pt)[$1$])

      line((4.65, 0), (5.35, 0), stroke: 4pt + yellow)
      content((5, 0.25), text(size: 9pt)[$1$])

      line((5.65, 0), (6.85, 0), stroke: 4pt + yellow)
      content((6.25, 0.25), text(size: 9pt)[$1$])

      // Arco del matching M (viola) - curva verso il basso
      bezier((0.1, -0.15), (7, 0), (3.5, -2.85), stroke: 3pt + purple)
      content((3.5, -1.7), text(size: 11pt, fill: purple)[$(1+epsilon) dot n/2 + 1$])

      // Archi di salto per π* (neri) - curvi verso l'alto
      bezier((0.0, 0.0), (3, 0.0), (1.5, 1.15), stroke: 2pt + black)
      content((0.75, 1.0), text(size: 9pt)[$$])

      bezier((1.5, 0.0), (3.8, 0), (3.0, -1.55), stroke: 2pt + black)  
      content((1.55, 0.8), text(size: 9pt)[$1 + epsilon$])

      bezier((3.8, 0.0), (5.5, 0), (4.5, -1.55), stroke: 2pt + black)  
      content((2.25, 1.0), text(size: 9pt)[$$])

      bezier((4.5, 0.0), (7, 0.0), (5.55, 1.55), stroke: 2pt + black)
      content((5.75, 1.0), text(size: 9pt)[$1 + epsilon$])

      // Legenda (spostata a destra)
      content((8.5, 1.5), text(size: 11pt, fill: yellow)[— $T$ (MST)])
      content((8.5, 1), text(size: 11pt, fill: purple)[— $M$ (Matching)])
      content((8.5, 0.5), text(size: 11pt)[— Salti per $pi^*$])

      // Etichetta del grafo
      content((-0.8, 1), text(size: 14pt, weight: "bold")[$G$])
    }),
    caption: [
      Per $n$ pari consideriamo un cammino così composto:\ 
      $n$ vertici collegati da dei lati di lunghezza $1$\
      dei lati alternati di lunghezza $1+epsilon$\
      I lati $mp("viola")$ serve per far diventare il grafo $G$ una clique, costano quanto il cammino minimo.
    ]
  )
])
Per qualunque $epsilon$ compreso fra *$0 < epsilon < 1$*, la clique sopra proposta è metrica: 
$ underbrace(d(v_1,v_2),1) + underbrace(d(v_2,v_3),"1") <= underbrace(d(v_1,v_3),1+epsilon) $
#dimostrazione()[
  Eseguiamo ora l'algorimto di Christofides sulla clique metrica: 
  - $my(T) <- "MST"$, è possibile osservare che: 
    - MST è il cammino giallo (solo lati con peso $1$)

  - $D <- {v_1,v_n}$
    - Gli unici vertici di grado dispari sono $v_1,v_n$ in quanto hanno grado $1$

  - Chiamo con $mp(M)$ il matching minimo su $D$. Dato che $D$ ha solo $2$ vertici, li sposiamo con l'arco che li collega. Il suo peso è il cammino minimo (dato che è lato aggiunto per rendere $G$ una clique), calcolato come:
   - Prendo gli archi alternati (con costo $1+epsilon$)
   - Prendo l'arco di costo $1$ che collega $v_(n-1)$ a $v_n$
  Il costo di $M = mp((1+epsilon) dot n/2 + 1)$ 

  - Unendo $my(T) union mp(M)$ otteniamo un circuito hamiltoniano (non c'è bisogno di cortocircuitazione), esso ha costo: 
  $ 
    delta &= (1+epsilon)n/2+ 1 + (n-1)\
          &= n/2 + epsilon n/2 + 1 + n -1\
          &= 3/2 n + epsilon n/2
  $

  Tuttavia il cammino ottimo del grafo $delta^*$ ha il seguente costo: 
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Cammino principale con vertici (figura più grande)
      circle((0, 0), radius: 0.15, fill: white, stroke: black)
      content((0, -0.35), text(size: 13pt)[$v_1$])

      circle((1.5, 0), radius: 0.15, fill: white, stroke: black)
      content((1.5, -0.35), text(size: 13pt)[$v_2$])

      circle((3, 0), radius: 0.15, fill: white, stroke: black)
      content((3, -0.35), text(size: 13pt)[$v_3$])

      content((3.8, 0), text(size: 13pt)[$dots.c$])

      circle((5.5, 0), radius: 0.15, fill: white, stroke: black)
      content((5.8, -0.35), text(size: 12pt)[$v_(n-1)$])

      circle((4.5, 0), radius: 0.15, fill: white, stroke: black)
      content((7, -0.40), text(size: 13pt)[$v_n$])

      circle((7, 0), radius: 0.15, fill: white, stroke: black)
      content((7, -0.40), text(size: 13pt)[$v_n$])

      // Archi del cammino MST T (gialli) - collegamenti corretti ai bordi dei cerchi
      line((0.15, 0), (1.35, 0), stroke: 4pt + purple)
      content((0.75, 0.25), text(size: 9pt)[$1$])

      line((1.65, 0), (2.85, 0), stroke: 4pt + black)
      content((2.25, 0.25), text(size: 9pt)[$1$])

      line((4.65, 0), (5.35, 0), stroke: 4pt + black)
      content((5, 0.25), text(size: 9pt)[$1$])

      line((5.65, 0), (6.85, 0), stroke: 4pt + yellow)
      content((6.25, 0.25), text(size: 9pt)[$1$])

      // Arco del matching M (viola) - curva verso il basso
      bezier((0.1, -0.15), (7, 0), (3.5, -2.85), stroke: 2pt + black)
      content((3.5, -1.7), text(size: 11pt, fill: black)[$(1+epsilon) dot n/2 + 1$])

      // Archi di salto per π* (neri) - curvi verso l'alto
      bezier((0.0, 0.0), (3, 0.0), (1.5, 1.15), stroke: 2pt + yellow)
      content((0.75, 1.0), text(size: 9pt)[$$])

      bezier((1.5, 0.0), (3.8, 0), (3.0, -1.55), stroke: 2pt + purple)  
      content((1.55, 0.8), text(size: 9pt)[$1 + epsilon$])

      bezier((3.8, 0.0), (4.5, 0), (4.5, -1.55), stroke: 2pt + purple)  
      content((2.25, 1.0), text(size: 9pt)[$$])

      bezier((4.5, 0.0), (7, 0.0), (5.55, 1.55), stroke: 2pt + purple)
      content((5.75, 1.0), text(size: 9pt)[$1 + epsilon$])

         bezier((5.5, 0.0), (3.5, 0.0), (4.55, 1.55), stroke: 2pt + yellow)
      content((4.35, 1.0), text(size: 9pt)[$1 + epsilon$])


      // Legenda (spostata a destra)
      content((8.5, 1.5), text(size: 11pt, fill: yellow)[— ritorno])
      content((8.5, 1), text(size: 11pt, fill: purple)[— andata])

      // Etichetta del grafo
      content((-0.8, 1), text(size: 14pt, weight: "bold")[$G$])
    }),
    caption: [
      Il cammino ottimo è definito da : 
      - $mp("Andata")$, peso = $(1+epsilon)n/2 +1$
      - $my("Ritorno")$, peso = $(1+epsilon)n/2+1$
    ]
  )
  Il peso totale del cammino è $delta^*$:
  $ 
    delta^* &= ((1+epsilon)n/2 +1) + mp((1+epsilon)n/2 +1)\
    &= (1+epsilon)n/2 + (1+epsilon)n/2 + 2 \
    &= (1+epsilon)n + 2
  $
  Consideriamo ora il rapporto di approssimazione:
  $ delta/delta^* = (3/2 n + epsilon n/2) / ((1+epsilon)n+2) $

  Per un $n$ abbastanza grande $n-> infinity$ e per un $epsilon$ abbastanza piccolo $epsilon -> 0$, il rapporto $delta/delta^*$ tende a $3/2$.
]

#teorema("Teorema")[
  *$3/2$* è il miglior tasso di approssimaione noto per *TSP metrico*
]

== Inapprossimabilità di TSP

#teorema("Teorema")[
  Non esiste nessun $alpha > 1$ tale che TSP sia $alpha$-approssimabile (nemmeno sulle clique).

  #attenzione[
    Si intende il TSP non metrico.
  ]

  #dimostrazione[
    Determinare se un *grafo* ha un *circuito hamiltoniano* è *$"NPc"$*.

    Supponiamo per assurdo che esista un algoritmo che $alpha$-approssima (per qualche $alpha > 1$) TSP sulle clique.

    Dato un grafo $G$ (con $n$ nodi) costruiamo la seguente clique:
    $ overline(G) = (V, E = binom(V, 2)) $
    $ overline(delta)_{x, y} = cases(1 quad "se" {x, y} in E, ceil(alpha n) + 1 in.not E) $

    Eseguendo l'algorimto con $overline(G)$ e $overline(delta)$, ci verrà resituito un circuito hamiltoniano $pi$ di costo $overline(delta)(pi)$ (non per forza ottimo).

    Esistono due casi:
    - *$overline(delta)^* = n$*, se $G$ ha un circuito hamiltoniano, allora $overline(G)$ ha ancora un circuito hamiltoniano di costo $n$ (dato che i lati già in $G$ costano $1$)
    - *$overline(delta)^* >= ceil(alpha n) + 1$*, se $G$ non ha un circuito hamiltoniano, allora il circuito hamiltoniano trovato su $overline(G)$ deve prendere almeno un arco non in $G$, quindi:
    $ overline(delta) <= alpha overline(delta)^* $

    Esistono due sotto-casi:
      - nel primo caso $<= alpha n$
      - nel secondo caso $>= ceil(alpha n) + 1$

    #informalmente[
      Se esiste un circuito hamiltoniano, allora trova una soluzione di al massimo $alpha n$, se non eiste allora il cammino deve usare un arco aggiuntivo, quindi deve per forza essere $> alpha n$
    ]

    $
      overline(delta) <= alpha n quad "se" G "ha un circuito hamiltoniano" \
      overline(delta) > ceil(alpha n) + 1 quad "se" G "non ha un circuito hamiltoniano" space qed
    $

    #informalmente[
      Abbiamo costruito un problema di ottimizzazione, in modo che l'approssimazione trovata cada in uno di due intervalli *disgiunti* che ci permettono di capire qual era l'ottimo.
    ]
  ]
]
