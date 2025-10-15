#import "../imports.typ": *

= Problema Min Cut (taglio minimo) [NPOc]

#informalmente[
  Vogliamo dividere i vertici di un grafo in due insiemi (non vuoti).
  Vogliamo minimizzare i lati da tagliare per ottenere questa cosa.
]

- $I_Pi$: $G = (V,E)$ grafo non orientato
- $"Amm"_Pi$: insieme di vertici che non comprende tutti i vertici e non esclude tutti i vertici $ S subset.eq V, quad emptyset != S != V $
- $C_Pi$: i lati tagliati dal taglio
  $ | E_S |, quad E_S = {e in E "t.c." e inter S != emptyset, quad e inter S^c != emptyset } $

#teorema("Proprietà")[
  Il taglio minimo ha dimensione minore o uguale del grado minimo di un vertice del grafo.

  Ma può essere più piccolo (controesempio: due clique connesse da un ponte).

  #dimostrazione[
    Basta tagliare tutti gli archi del vertice di grado minimo e si isola lui.
  ]
]

== Contrazione di un Lato

Contrarre $G$ su $e$, indicato con $G arrow.b e$ significa prendere un lato e toglierlo, connettendo direttamente i due estremi del lato.

#nota[
  Questa cosa può dare luogo a multigrafi.

  Avviene quando esiste un vertice connesso ad entrambi i due estremi del lato.
]

Tutti i lati di un grafo contratto corrispondono ad un singolo lato del grafo originale.
Alcuni lati possono proprio sparire.

== Algoritmo di Karger

- If $G$ non è connesso
  - Output una qualunque componente connessa
- Else:
  - While $|V| > 2$:
    - $e <-$ lato a caso \/\/ parte probabilistica
    - $G <- G arrow.b e$
- Ouput classe di equivalenza di una delle due estremità

#nota[
  Ad ogni contrazione, i due vertici compressi si uniscono nella stessa classe di equivalenza.

  Dato che ci fermiamo ad esattamente due nodi, allora avremo due classi di equivalenza.
]

#informalmente[
  Otterremo l'ottimo con una certa probabilità.

  Ma se non otteniamo l'ottimo, allora non sappiamo di quanto è sbagliato quella soluzione.
]

Sia:
- $S^*$ scelta di vertici che da luogo al taglio più piccolo possibile
- $k^*$ la dimensione del taglio minimo:
  $ k^* = |E_(S^*) "dove" E_(S^*) = {e | e inter S^* != emptyset, e inter S^*^C != emptyset } | $
- $G_i$ il grafo prima dell'$i$ contrazione ($G_1, G_2, ...$)

#teorema("Osservazione")[
  Il numero di nodi del del grafo $G_i$ è:
  $ n_G_i = n-i $

  #dimostrazione[
    Ad ogni cotnrazione uniamo due nodi, quindi si riduce di uno il numero inizial e di nodi.
    %
  ]
]

#teorema("Osservazione")[
  Ogni taglio di $G_i$ corrisponde ad untaglio di $G$ della stessa dimensione.

  Implica che grado minimo di $G_i >= k^*$

  #dimostrazione[
    Dato che il taglio minimo è minore o uguale del grado minimo del grafo e dato che ogni taglio di $G_i$ è anche un taglio di $G$, allora $qed$.
  ]
]

#teorema("Osservazione")[
  Sommiamo i gradi di $G_i$
  $
    mr(sum_(v in V_G_i) d_(G_i)(v)) >= k^* (n-i+1) \
    mr(2 m_G_i) >= k^* (n-i+1) \
    m_G_i >= (k^* (n-i+1))/2
  $

  #dimostrazione[
    Sommando il grado di ogni vertice, stiamo praticamnete contanto ogni lato due volte (roba in rosso).

    Per il >= sfruttate le scorse due proprietà.
  ]
]

Sia $xi_i$ l'evento all'$i$-esima contrazione non si è contratto un lato di $E_S^*$.

#informalmente[
  $xi_i$: non abbiamo tagliato nessun lato che andava preservato, ci è andata bene col lato casuale.
]

#teorema("Lemma")[
  Probabilità che non tagliamo un lato che ci serve all'$i$-esima iterazione, posto che non lo abbiamo fatto prima:
  $ P[xi_i | xi_1, ..., xi_(i-1)] >= (n-i-1)/(n-i+1) $

  #dimostrazione[
    $
      P[xi_i | xi_1, ..., xi_(i-1)] & = 1- P[not xi_i | xi_1, ..., xi_(i-1)] \
                                    & = 1 - (k^*)/m_G_i
    $
    $k^*$: casi favorevoli
    $m_G_i$: casi possibilie

    Per osservazione 3:
    $
      >= 1 - (k^* 2)/(k^*(n-i+1)) \
      = (n-i+1-2)/(n-i+1) \
      = (n-i-1)/(n-i+1) space qed
    $
  ]
]

#teorema("Teorema")[
  L'algoritmo di Karger trova il taglio minimo con probabbilità $>= 1/binom(n, 2)$.

  #dimostrazione[
    Vogliamo dimostrare:
    $ P[xi_1 inter x_2 inter ... inter xi_(n-2)] $

    Attraverso la regola della catena (=) e usando il Lemma1 (>=):
    $
      & = P[xi_1] dot P[xi_2 | xi_1] dot P[xi_3 | xi_1, xi_2] \
      & >= (n-2)/n dot (n-3)/(n-1) dot ... dot 1/3 \
      & = (limits(product)_(i=1)^(n-2)i)/(limits(product)_(i=3)^n i) \
      & = (1dot 2)/(n ( n-1)) = 1/binom(n, 2) space qed
    $
  ]
]

#attenzione[
  Questa proprietà è molto piccola, quindi non molto buona.

  Possiamo però iterare questo algoritmo, in modo da far crescere la probabilitò.
  Tra tutte le iterazioni prendiamo quella migliore (minima).
]

#teorema("Corollario")[
  Eseguendo Karger $binom(n, 2) ln n$ volte, otteniamo il taglio minimo con probabilità $>= 1 - 1/n$.

  #dimostrazione[
    Ogni volta, la probabilità di NON trovare l'ottimo è
    $ <= 1 - 1/binom(n, 2) $

    Quindi, eseguendo l'algoritmo $binom(n, 2) ln n$ volte, diventa:
    $ <= (1 - 1/binom(n, 2))^(binom(n, 2) ln n) $

    Dato che sempre vale la proprietà:
    $ forall x >= 1, quad 1/4 <= (1-1/x)^x <= 1/e $

    Allora:
    $ <= (1 - 1/binom(n, 2))^(binom(n, 2) ln n) $
  ]
]
