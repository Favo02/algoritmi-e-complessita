#import "../imports.typ": *

= Problema Traveling Saleman in uno spazio metrico

#informalmente[
  Problema dei ponti di Königsberg.
  Percorrere tutti i ponti una volta sola e tornare al punto di partenza. Vogliamo quindi cercare un cammino Euleriano.
]

Si rimanda alle definizioni di circuito, nel capitolo #link-section(<grafi>)


#teorema("Teorema")[
  Un (multi)grafo ammette un circuito euleriano se e solo se è connesso e tutti i suoi vertici hanno grafo pari.

  #dimostrazione[
    #attenzione[
      Questa non è davvero una dimostrazione, ma solo una costruzione del senso $<==$ dell'implicazione, ovvero come costruire un cammino dato un grafo connesso di grado 2.
    ]

    Si va avanti fino a quando non finiscono i vertici e bisogna tornare su un vertice già visitato.

    Ma una volta che sono qua, ho visitato tutti i lati?

    Ma dato che ci sono tornato vuole dire che ha almeno 3 lati, ma dato che è di grado pari ci deve per forza essere un altro lato, quindi si può continuare.

    Questa cosa si può continuare fino a quando non si torna nel vertice iniziale.
  ]
]

== Handshaking Lemma

#informalmente[
  Se un gruppo di persone si stringe delle mani (non per forza tutti devono stringere delle mani).

  Il numero di persone che ha stretto un numero dispari di mani è pari.
]

#nota[
  Questo genere di cose (ovvero avere delle informazioni certe su eventi "strani") si chiaam Teorema di Ramsey.

  Ovvero che appaiono dei pattern inevitabili (da una certa quantità in poi).
]

#teorema("Lemma")[
  In ogni grafo non orientato, il numero di vertici di grado dispari è pari.

  #informalmente[
    Rappresentazione a grafo delle persone (vertici) e strette di mano (lati)
  ]

  #dimostrazione[
    $d(x)$ è il grafo di un vertice
    $ sum_(x in V) d(x) = 2 m $
    Ogni lato viene contato due volte, dato che viene contato sia nel grafo del primo estremo che del secondo estremo.

    Nella sommatoria le quantità pari non interessano, dato che partendo da una cosa pari e sommando pari, si rimane in un numero pari.

    L'unica cosa che può cambiare la parità della sommatoria sono i numeri dispari.
    Ma dato che alla fine la sommatoria è pari, vuol dire che il numero di cose dispari nella sommatoria è pari.
  ]
]

== Problema Commesso Viaggiatore (TSP) [NPOc]

- $I_Pi$:
  - grafo non orientato $G(V, E)$
  - pesi dei lati $angle.l delta_e angle.r_(e in E) in bb(Q)^+$
- $"Amm"_Pi$: circuito hamiltoniano $pi in G$, cioè un circuito che tocchi tutti i vertici esattamente una volta, oppure $bot$
- Funzione obiettivo: lunghezza del circuito hamiltoniano:
  $ delta = sum_(c in pi) delta_e $
- $t_Pi = min$

== TSP Metrico [NPOc]

Abbaimo ulteriori vincoli sul grafo:
+ $G$ è una clique
+ $delta_e$ è una metrica, cioè:
  - $delta_{x,y} + delta_{y,z} >= delta_{x,z}$

#attenzione[
  Senza la seconda limitazione, allora è possibile trasformare qualsiasi grafo (non per forza cricca) in una cricca.

  Basta aggiungere tutti i lati mancanti di costo enorme, quindi l'algoritmo non li sceglierà mai (o se li sceglie vuol dire che la soluzione non è possibile).

  Mentre la seconda restrizione non rende possibile fare questa cosa
]

#teorema("Teorema")[
  *$ "TSP Metrico" in "NPOc" $*
]

== Algoritmo di Christofides per TSP metrico

Cose necessarie prima dell'algoritmo:
+ Minimum Spanning Tree [PO]:
  - Tree = grafo connesso aciclico
  - Spanning tree = scelta di lati che è un albero e tocca tutti i vertici
  - Minimum = costo minimo dei possibili spanning tree
  - con algoritmo di Kruskal, tempo polinomiale
+ Minimum Weight Perfect Matching [PO]:
  - Grafo con lati pesati e numero pari di vertici
  - Vogliamo un perfect matching di costo minimo
  - con algoritmo di Edmons del'infiorescenza, tempo polinomiale

Algoritmo:
- Input:
  - $G(V, E=binom(V, 2))$ // TODO: mettere in notaazione la clique
  - $angle.l delta_e angle.r_(e in E)$ metrico
- $T <-$ minimum spanning tree
- $D <-$ insieme di vertici di grafo dispari in $T$
  - per Handshaking lemma, $|D|$ è pari
- $M <-$ minimum weight perfect matching su $D$
  - possono esistere dei lati che fanno parte del matching ma non dell'albero
- $? <- M union T$ multigrafo
  - tutti i vertici di $M union T$ hanno grado pari
    - tutti quelli pari in $T$ non li abbiamo toccati
    - tutti quelli dispari in $T$, quindi $D$ abbiamo aggiunto $1$ da $M$
  - esiste un cammino chiamato $tilde(pi)$
- $pi <-$ shortcircuit $tilde(pi)$
  - dove passo due volte da un vertice, allora salto quel vertice e vado direttamente a quello successivo (possibile perchè è una cricca)

#teorema("Lemma")[
  $ delta(T) <= delta^* $

  #dimostrazione[
    Sia $pi^*$ un TSP ottimo.

    Se togliamo un lato, allora otteniamo un grafo aciclico che copre tutti i lati, ovvero uno spanning tree.

    $ forall e in pi^*, quad delta^* >= delta^* - delta_e >= delta(T) space qed $

    Ma lo spanning tree è per forza maggiore o uguale al costo dello spanning tree minimo $T$.
  ]
]

#teorema("Lemma")[
  $ delta(M) <= 1/2 delta^* $

  #dimostrazione[
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
