#import "../imports.typ": *

= Problema Congested Paths

#informalmente[
  Dato un grafo orientato e una lista di _sorgenti_ e _destinazioni_, vogliamo collegare le sorgenti con le corrispondenti destinazioni attraverso un _cammino_ nel grafo.\
  Inoltre, dato un tasso di congestione intero $c$, vogliamo che non ci siano più di $c$ cammini che passino per uno stesso arco $a$.

  Obiettivo: massimizzare le coppie collegate.
]

Formalmente: 
- *$I_Pi$*:
  - $G = (N,A)$, grafo orientato
  - $s_0,dots,s_(k-1) in bb(N)$, lista di sorgenti
  - $t_0,dots,t_(k-1) in bb(N)$, lista di destinazioni
  - $c in bb(N^+)$, tasso di consegtione
- *$"Amm"_(Pi)$*:
  $ 
    I subset.eq k \
    forall i in I, exists "un cammino" pi_i: s_i -> t_i \
    "t.c" forall a in A, "non ci sono più di" c "cammini" pi_i "che passano per" a 
  $
- *$C_Pi$* = $|I|$, numero di coppie collegate
- *$t_Pi$* = max 

Definiamo anche una *funzione di costo $l$*, la quale associa ad ogni arco un costo. Essa *varia nel tempo*:
$ ell : A -> bb(R)^+ $
Il costo di un cammino $pi$ è definito come: 
$
  pi = <x_1,x_2,dots,x_i>\
  ell(pi) = ell(x_1,x_2)+ell(x_2,x_3)+dots+ell(x_(i-1),x_i)
$

== Algoritmo PricingCongestedPaths

L'input di questo problema è analogo a $"CongestedPath"$, con l'aggiunta di una costante $beta$. 

#pseudocode(
  [*Input* = $"CongestedPath"$ + $beta >1$],
  [$I <- emptyset$],
  [$P <- emptyset$ #emph("insieme dei cammini")],
  [$ell(a)=1, forall a in A$],
  [*Forever*],
  indent(
    [Find the shortest path $pi_i$ connecting $(s_i,t_i)$ for some $i in.not I$],
    [*If* such path $exists.not$],
    indent(
      [*Break*]
    ),
    [$I <- I union {i}$],
    [$P <- P union {pi_i}$],
    [*Forall* ares $a in pi_i$],
    indent(
      [$ell(a) <- ell(a)*beta$],
      [#emph("penalizzo gli archi usati")],
      [*If* $ell(a) = beta^c$],
      indent(
        [*Delete* $a$],
        [#emph("L'arco è già stato usato "+$c$+" volte, lo ellimino")]
      ),
    ),
  ),
  [*Output* $I,P$]
)

#informalmente[
  L'algoritmo continua a scegliere il cammino minimo più corto tra sorgente e destinazione, utilizzando l'algoritmo di dijkstra (non basta una bfs dato che i pesi sugli archi esistono (e cambiano)).

  Una volta selezionato il cammino minimo, gli archi che ne fanno parte vengono puniti, in modo da non utilizzarli troppe volte. il loro costo $ell(a)$ viene moltiplicato per $beta$.

  Quando un'arco ha costo $beta^c$, allora esso è già stato utilizzato $c$ volte, di conseguenza non potrà più essere usato. Per questo motivo viene cancellato.
]

/ Cammino Corto:
  Per una certa $l$ (quindi ad un certo istante), un cammino $pi$ si chiama *corto* se $ell(pi) < beta^c$.

  #informalmente[
    Per una certa funzione $l$ npn significa altro che ad un certo istante
  ]

/ Cammini utili: cammini che collegano una nuova coppia (ovvero una coppia non ancora collegata)

/ $C_i$ insieme dei cammini utili: insieme dei cammini corti utili prima dell'$i$-esima iterazione

#attenzione[
  Queste proprietà cambiano col passare del tempo
]

Durante l'esecuzione, possono succede le seguenti cose (non il contrario):
- prima utile diventa inutile (abbiamo collegato sorgente destinazione)
- corto diventi lungo (alcuni dei lati su cui passa hanno aumentato il peso)
- un cammino esistente diventa inesistente

Quindi: $ underbrace(C_0 supset.eq C_1 supset.eq C_2 supset.eq ... supset.eq, "prima fase") C_s = emptyset $

Quando finiamo i cammini corti utili $emptyset$:
- abbiamo collefato tutte le coppie
- rimangono coppie collegabili solo attraverso cammini lunghi

Quindi l'algoritmo termina dopo l'istante $s$, chiamiamo la funzione $overline(ell)$ la funzione nell'istante dove non ci sono più cammini corti utili $C_s$.

#informalmente[
  Dato che l'algoritmo sceglie sempre il cammino utile più corto, allora fino all'istante $s$ sceglierà sempre cammini corti, quindi un cammino più corto di $beta^c$
]

#attenzione[
  Nella prima fase potremmo anche non cancellare alcun arco, ma li teniamo da parte e li cancelliamo solo all'inizio della seconda fase.

  Questa cosa non fa cambiare nulla perchè il singolo arco da cancellare peserebbe più di $beta^c$, quindi solo quell'arco è per forza più lungo di un altro intero cammino (dato che siamo appunto nella prima fase e quindi esistono cammini corti).
]

#teorema("Lemma")[
  $ forall i in I^* \\ I, quad overline(ell)(pi_i^*) >= beta^c $

  $i$ è una coppia sorgente-destinazione che l'algoritmo non ha collegato ma che la soluzione ottima ha collegato

  #dimostrazione[
    Per assurdo esiste un cammino selezionato dalla soluzione ottime $overline(ell)(pi_i^*) < beta^c$

    Ma questo è un cammino corto e utile, assurdo $qed$.

    #informalmente[
      Se esistono coppie sorgente/destinazione non collegate, allora devono per forza essere connessi da cammini lunghi (altrimenti l'algoritmo lo avrebbe trovato).
    ]
  ]
]

#teorema("Teorema")[
  Se guardo ilcosto totale deglii archi alla fine della prima fase, allora la somma viene $beta^(c+1)$ per il numero di cammini trovati $s$

  $ sum_(a in A) overline(ell)(a) <= beta^(c+1) |I_s| + m $

  dove $I_s$ è l'insieme dei cammini raggiunti nella prima fase (numero di iterazioni) ed $m$ è il numero di archi del grafo

  #dimostrazione[
    Per induzione, guardo come cambia per ogni iterazione la sommatoria.
    Se aumenta al massimo $beta^(c+1)$ volte ogni iterazione, allora abbiamo dimostrato dato che viene moltiplciato per il numero di iterazioni.

    All'inizio ogni arco vale $1$:
    $ sum_(a in A) ell(a) = m $

    Cosa succede quando viene aggiunto un nuovo cammino $ell -> ell'$?

    $ ell'(a) = cases(ell(a) "se" a in.not Pi, beta ell(a) "se" a in pi) $

    Calcoliamo:
    $
      sum_(a in A) ell'(a) - sum_(a in A) ell(a) \ =
      sum_(a in pi)(beta ell(a) ell(a)) + underbrace(sum_(a in.not pi) (ell(a) - ell(a)), 0) \
      = sum_(a in pi)(beta - 1) ell(a) \
      = (beta-1) sum_(a in pi) ell(a) = (beta-1) ell(pi) \
      < (beta-1) underbrace(beta^c, "dato che è corto") < beta^(c+1) space qed
    $
  ]
]

#teorema("Osservazioni")[
  1. $ sum_(i in I^* \\ I) overline(ell)(pi_i^*) underbrace(>=, "lemma") beta^c |I^* \\ I| $

  2. $
      sum_(i in I^* \\ I) overline(ell)(pi_i^*) underbrace(<=, "per definizione del problema" \ "allora nessun cammino usa un arco più di c volte") underbrace(c sum_(a in A) overline(ell)(a), "tutti gli archi usati esattamente c volte") \
      <= c(beta^(c+1) |I_s| + m)
    $
]

#teorema("Teorema")[
  L'algoritmo PricingCongestedPaths con input $beta = m^(1/(c+1))$ da una $ (2c m^(1/(c+1))+1)"-approssimazione" $

  #dimostrazione[
    Principio di inclusione eslusione:
    $
          beta^c |I^*| & <= beta^c |I^* \\ I| + beta^c |I inter I| \
                       & underbrace(<=, "oss1") sum_(i in i^* \\ I) overline(ell)(pi_i^*) + beta^c |I| \
                       & underbrace(<=, "oss2") c(beta^(c+1) |I_s| + m) + beta^c |I| \
                       & <= c(beta^(c+1) |I| + m) + beta^c |I| \
      (|I^*|) / beta^c & <= (c(beta^(c+1) |I| + m) + beta^c |I|) / beta^c \
                   ... \
                       & <= c(beta + beta^(-c) m) |I| + |I|
    $

    Vogliamo calcolare il rapporto di approssimazione:

    $ (|I^*|) / (|I|) <= c(beta + beta^(-c) m) + 1 $

    Studiando questa funzione, il minimo si ottiene come:
    $ beta eq.delta m^(1/(c+1)) $

    Quindi il miglior tasso di approssimazione:
    $
      (|I^*|) / (|I|) & <= c(m^(1/(c+1)) + m^(1/(c+1))^(-c) m) + 1 \
                      & <= 2c m^(1/(c+1))+1
    $
  ]
]

Studiamo i casi bassi di $c$, soprattutto il caso in cui i cammini siano proprio disgiunti $c = 1$:
...

#informalmente[
  Questo tasso di approssimazione fa abbastanza schifo, sopratutto se le coppie sono poche.
  Ha senso questo algoritmo solo se $>> 2sqrt(m) + 1$
]
