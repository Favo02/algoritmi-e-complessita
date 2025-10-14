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
]

#teorema("Lemma")[
  Dati: 
  - $T <- $ minimum spannig tree
  - $D <- $ insieme dei vertici di  grado dispari di $T$
  Consideriamo $M$, ovvero il minimum weight perfect matching su $D$: 
  $ delta(M) <= 1/2 delta^* $

  #dimostrazione[
    
    #esempio([
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
  ])


    Prendiamo $pi^*$ (TSP ottimo) e cortocircuitiamo sui vertici di $D$ (i vertici di grado dispari sull'albero).

    Possiamo collegare tra loro i vertici $in D$, formando un ciclo $overline(pi)^*$.
    Per via della disuguaglianza triangolare, allora: $ delta(overline(pi)^*) <= delta(pi^*) $

    Scegliamo metà dei lati di questo circuito in maniera alternata, formando $M_1$ e $M_2$.

    $ delta^* >= quad delta(overline(pi)^*) = delta(M_1) + delta(M_2) $

    Ma $M_1$ e $M_2$ sono dei perfect matching, ma sono maggiori del minimum perfect matching:

    $ delta^* >= quad delta(overline(pi)^*) = delta(M_1) + delta(M_2) >= delta(M) + delta(M) >= 2 delta(M) space qed $
  ]
]

#teorema("Teorema")[
  L'algoritmo di Christofides è una $3/2$-approssimazione per il TSP metrico.

  #dimostrazione[
    Noi prendiamo $T union M$ e costruiamo un cammino hamiltoniano cortocircuitando un cammino euleriano:

    $
      delta(pi) & <= delta(pi_"euler") = delta(T) è delta(M) \
                & <= delta^* + 1/2 delta^* = 3/2 delta^* space qed
    $
  ]
]

=== Strettezza dell'analisi

Per $n$ pari, consideriamo il grafo:
- cammino di $n$ vertici collegati da dei lati di lunghezza $1$
- dei lati che saltano di lunghezza $1+epsilon$
- lati extra per diventare una clique costano come il cammino minimo (fare il cammino minimo tra i due vertici e il lato diretto costa uguale, in modo da mantenere la disuguaglianza metrica)
- per qualunque $0 < epsilon < 1$ la clique è metrica

Eseguiamo Christofides sulla clique:
- trovare il MST $T$
  - è facile dimostrare che è il cammino iniziale con tutti i pesi $1$
  - i vertici di grado dispari in $T$ sono il primo e l'ultimo
- $D$ è composto solo da $v_1$ e $v_(n-1)$, quindi il perfect matching è semplicemente il collegamento del loro lato
  - il lato che li collega è un lato aggiunto per renderla clique, quindi di peso cammino minimo tra $v_1$ e $v_n$, quindi $(1+epsilon) n/2 + 1$
- unendo $T$ e $M$ otteniamo già un circuito hamiltoniano senza dover fare cortocircuitazione
  - ha costo:
  $
    delta & = (1+epsilon)n/2 + 1 + (n-1) \
          & = n/2 + epsilon n/2 + 1 + n -1 \
          & = 3/2 n + epsilon n/2
  $

Ma circuito hamiltoniano ottimo sarebbe:
- partendo da un vertice pari $v_2$, saltare di 2 in 2 fino a $v_n$
- torniamo indietro di $1$ e da $v_(n-1)$ facciamo la stessa cosa all'indietro per i vertici pari, arrivando a $v_0$
- colleghaimo $v_0$ a $v_1$
- ha costo:
  $
    delta^* & = (1+epsilon) n/2 + (1+epsilon)n/2 + 2 \
            & = (1+epsilon)n + 2
  $
- con tasso di approssimazione:
  $ delta/delta^* = (3/2 n + epsilon n/2) / ((1+epsilon)... ) $
- se mandiamo $n -> infinity$ e $epsilon -> 0$, allora tende a $3/2$

#teorema("Teorema")[
  $3/2$ è il miglior tasso di approssimaione noto per TSP metrico
]

== Inapprossimabilità di TSP

#teorema("Teorema")[
  Non esiste nessun $alpha > 1$ tale che TSP sia $alpha$-approssimabile (nemmeno sulle clique).

  #attenzione[
    Si intende il TSP non metrico.
  ]

  #dimostrazione[
    Determinare se un grafo ha un circuito hamiltoniano è NPc.

    Supponiamo per assurdo che esista un algoritmo che $alpha$-approssima (per qualche $alpha > 1$) TSP sulle clique.

    Dato un grafo $G$ costruiamo questa clique:
    $ overline(G) = (V, binom(V, 2)) $
    $ overline(delta)_{x, y} = cases(1 quad "se" {x, y} in E, ceil(alpha n) + 1 quad "altrimenti") $

    Dando $overline(G), overline(delta)$ all'algorimto, ci verrà resituito un circuito hamiltoniano $pi$ di costo $overline(delta)(pi)$ (non per forza ottimo).

    Esistono due casi:
    - se $G$ ha un circuito hamiltoniano, allora $overline(G)$ ha ancora un circuito hamiltoniano, di costo $n$ (dato che i lati già in $G$ costano $1$), $overline(delta)^* = n$
    - se $G$ non ha un circuito hamiltoniano, allora il circuito hamiltoniano trovato su $overline(G)$ deve prendere almeno un arco non in $G$, quindi $overline(delta)^* >= ceil(alpha n) + 1$

    Quindi $overline(delta) <= alpha overline(delta)^*$:
    - nel primo caso $<= alpha n$
    - nel secondo caso $>= ceil(alpha n) + 1$

    #informalmente[
      Se esisteva, allora trova una soluzione di al massimo $alpha n$, se non eisteva allora deve usare un arco aggiuntivo, quindi deve per forza essere $> alpha n$
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
