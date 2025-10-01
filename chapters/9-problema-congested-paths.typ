#import "../imports.typ": *

= Problema Congested Paths

#informalmente[
  Dato un grafo orientato, ci sono delle _sorgenti_ e delle _destinazioni_.
  Vogliamo collegare le sorgenti con le corrispondenti destinazioni attraverso un _cammino_ nel grafo.

  C'è un vincolo, un paramtro di congestione intero.
  Non ci devono essere più di $c$ cammini passino su un certo arco.

  Obiettivo: massimizzare le coppie collegate.
]

- $I_Pi$:
  - $G(N, A)$: grafo orientato (nodi e archi)
  - $s_0, ..., s_k-1 in bb(N)$: sorgenti
  - $t_0, ..., t_k-1 in bb(N)$: destinazioni
  - $c in bb(N)^+$: parametro di congestione
- $"Amm"_Pi$: insieme di coppie che risciamo a collegare
  $I subset.eq k, forall i in I$ un cammino $pi_i$ da $s_i$ a $t_i$, tale che $forall a in A$ non ci sono più di $c$ cammini che passano per $a$
- $C_Pi = |I|$
- $t_Pi = max$

Abbiamo anche bisogno di una funzione $l$, che associa ad ogni arco un costo.
Questa funzione cambia nel tempo.
$ l: A -> bb(R)^+ $
Questa funzione si può estendere a dei cammini:
$ pi = <x_1, ..., x_i> $
$ l(pi) = l(x_1, x_2) + l(x_2, x_3) + ... + l_(x_(i-1), x_i) $

== Algoritmo PricingCongestedPaths

- Input: input del problema + $beta > 1$
- $I <- emptyset$
- $P <- emptyset$
- $l(a) = 1 forall a in A$
- While true
  - find the shortest path $pi_i$ connecting $(s_i, t_i)$ for some $i in.not I$ \/\/ trovo il cammino minimo tra ogni coppia sorgente-destinazione, prendo il cammino minimo più piccolo
  - if such path $exists.not$
    - break \/\/ tutte le sorgenti sono connesse alle destinazioni
  - $I <- I union {i}$
  - $P <- P union {pi_i}$
  - forall ares $a in pi_i$:
    - $l(a) <- l(a) dot beta$
    - if $l(a) = beta^c$
      - delete $a$
- output $I, p$

#informalmente[
  Continuiamo a scegliere il cammino minimo più corto tra sorgente e destinazione.
  Per fare questa cosa dobbiamo eseguire degli algoritmo di dijkstra (non basta bfs dato che i pesi sugli archi esistono (e cambiano)).

  Ma andiamo a punire gli archi utilizzati da questo cammino (per evitare di usarli troppe volte).

  Questa punizione è aumentare il costo degli archi, moltiplicandolo per $beta$.

  Quando un arco arriva a costo $beta^c$, allora questo arco è arrivato ad essere usato $c$ volte, quindi non potrà più essere usato, lo cancelliamo.
]
