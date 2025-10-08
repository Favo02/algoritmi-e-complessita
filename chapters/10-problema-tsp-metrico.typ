#import "../imports.typ": *

= Problema Traveling Saleman Problem in Spazio Metrico

#informalmente[
  Problema dei ponti di Königsberg.
  Percorrere tutti i ponti una volta sola e tornare nel punto di partenza: cammino Euleriano.
]

== Circuiti Euleriani

// TODO: spostare nel primo capitolo queste definizioni?

/ Circuito Euleriano: circuito (cammino da $x$ a $x$) che passa esattamente una volta per ogni lato

/ Connesso: si usa per i grafi non orientati, da un nodo si può raggiungere ogni nodo (quindi dato che non ci sono direzioni, tutti possono raggiungere tutti)

/ Fortemente connesso: solo per i grafi orientati, da ogni nodo si può raggiungere ogni altro nodo

/ Debolemente connesso: se si ignorano le direzioni allora è fortemente connesso (ovvero non ci sono nodi o aree isolate)

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
- $"Amm"_Pi$: circuito hamiltoniamo $pi in G$, cioè un circuito che tocchi tutti i vertici esattamente una volta, oppure $bot$
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
- shortcircuit $tilde(pi) -> pi$
  - dove passo due volte da un vertice, allora salto quel vertice e vado direttamente a quello successivo (possibile perchè è una cricca)
