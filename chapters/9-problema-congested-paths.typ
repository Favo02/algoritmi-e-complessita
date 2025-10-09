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
  - $s_0,dots,s_(k-1) in bb(N^+)$, lista di sorgenti
  - $t_0,dots,t_(k-1) in bb(N^+)$, lista di destinazioni
  - $c in bb(N^+)$, tasso di consegtione
- *$"Amm"_(Pi)$*:
  $ 
    I subset.eq k \
    forall i in I, exists "un cammino" pi_i: s_i -> t_i \
    "t.c" forall a in A, "non ci sono più di" c "cammini" pi_i "che passano per" a 
  $

- *$C_Pi$* = $|I|$, numero di coppie collegate
- *$t_Pi$* = max 

Definiamo anche una *funzione di costo $ell$*, la quale associa ad ogni arco un costo. Essa *varia nel tempo*:
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
  L'algoritmo continua a scegliere il cammino minimo più corto tra sorgente e destinazione, utilizzando l'algoritmo di dijkstra (non basta una bfs dato che i pesi sugli archi esistono e cambiano).

  Una volta selezionato il cammino minimo, gli archi che ne fanno parte vengono puniti, in modo da non utilizzarli troppe volte. Il loro costo $ell(a)$ viene moltiplicato per $beta$.

  Quando un'arco ha costo $beta^c$, allora esso è già stato utilizzato $c$ volte, di conseguenza non potrà più essere usato. Per questo motivo viene cancellato.
]

Un certo cammino $pi$ inoltre può avere alcune proprietà in determinati istanti dell'esecuzione. 

/ Cammino Corto:
  Per una certa $ell$ (quindi ad un certo istante), un *cammino $pi$* si dice *corto* se: 
  *$ ell(pi) < beta^c $*

/ Cammini utili: Cammini che *collegano una nuova coppia* (ovvero una coppia non ancora collegata)

/ $C_i$ insieme dei cammini corti utili: prima dell'$i$-esima iterazione

#attenzione[
  Queste proprietà variano in base all'esecuzione (istante) in cui siamo
] 

In un dato istante, le *trasformazioni possibili* per un cammino $pi$ sono: 
- $pi "utile" -> pi "inutile"$
- $pi "corto" -> pi "lungo"$
- $pi "esistente" -> pi "non esistente"$

Possiamo dividere l'esecuzione dell'algoritmo in due fasi: 
$ underbrace(C_0 subset.eq C_1 subset.eq C_2 subset.eq C_3, mr("fase 1")) dots subset.eq underbrace(C_s,mb("fase 2," overline(ell)(pi))) = emptyset $
- $mb("fase 1")$: l'algoritmo sceglie un cammino corto utile
- $mr("fase 2")$: i cammini corti utili sono finiti: 
  - non esistono più coppie collegabili
  - rimangono coppie collegabili solo con camminimi lunghi.\
    L'algoritmo termina dopo l'istante $s$.\
    *$overline(ell)$* = la funzione nell'istante $C_s$ dove *non* ci sono più cammini utili  

#informalmente[
  Dato che l'algoritmo sceglie sempre il cammino utile più corto, fino all'istante $s$ sceglierà sempre cammini corti (cammino più corto di $beta^c$)
]

#attenzione[
  L'algoritmo potrebbe essere modificato in modo tale che durante la prima fase non vengano cancellati archi. Essi saranno cancellati solo all'inizio della seconda fase.

  Questa modifica non altera l'algoritmo. Il singolo arco da cancellare peserebbe più di $beta^c$, di conseguenza solo quell'arco è per forza più lungo di un qualsiasi altro cammino, l'arco non sarà dunque selezionato (essendo nella prima fase, esistono cammini corti).
]

#teorema("Lemma")[
  Supponiamo ora di eseguire l'algoritmo. Esso produce una soluzione $I$:
  
  $ forall i in I^* \\ I, quad overline(ell)(pi_i^*) >= beta^c $

  Dove $i$ è una coppia sorgente-destinazione non collegata nella soluzione trovata $I$, ma collegata nella soluzione ottima $I^*$.

  #informalmente[
    Se esistono coppie sorgente-destinazione non collegate, allora devono per forza essere connesse da cammini lunghi (altriment avrebbe trovato tali cammini).
  ]

  #dimostrazione[
    Supponiamo che per assurdo esista un cammino $pi_i^*$ selezionato dalla soluzione ottima tale che: 
    $ overline(ell)(pi_i^*) < beta^c $
    Per definizione $pi_i^*$ è un cammino corto utile, di conseguenza l'algoritmo l'avrebbe selezionato aggiungendolo alla soluzione $I$:
    $ overline(ell)(pi_i^*) >= beta^c quad qed $ 
  ]
]<lemma-soluzione-ottima>

#teorema("Teorema")[
  Il teorema fornisce un limite superiore alla somma del peso degli archi selezionati alla fine della prima fase:
  $ sum_(a in A) overline(ell)(a) <= beta^(c+1) |I_s| + m $

  Dove: 
  - $I_s$ è l'insieme dei cammini aggiunti nella prima fase (numero di iterazioni)
  - $m$ è il numero di archi del grafo

  #dimostrazione[
    La dimostrazioene avviene per induzione: 
    
    1. *Passo Base*. All'inizio il peso di tutti gli archi è inizializzato a $1$:
      $ sum_(a in A) underbrace(ell(a),=1) = m $


    2. *Passo induttivo*. Ci chiediamo cosa succede quando aggiungo un nuovo cammino $pi$.\
      Il peso degli archi $forall a in A$ viene aggiornato $ell-> ell^'$:
      $ 
        ell^(')(a) = cases(
          l(a) &"se" a in.not pi \
          beta dot l(a) &"se" a in pi
        )  
      $
      Calcoliamo ora di quanto è variato il peso degli archi: 
      $ 
        sum_(a in A) ell^(')(a) - sum_(a in A) ell(a) \
        = sum_(a in A) ell^(')(a) - ell(a) \
        italic("Espandendo la sommatoria") \
        = sum_(a in pi) (beta ell(a)-ell(a)) - underbrace(sum_(a in.not pi)(ell(a)-ell(a)),0)\
        italic("raccolgo" mr(beta-1))\
        = sum_(a in pi) mr((beta-1)) ell(a)\
        = mr((beta-1)) underbrace(sum_(a in pi) ell(a), ell(pi))\
        = mr((beta-1)) ell(pi) \
        italic("siccome siamo nella prima frase:" ell(pi)< beta^c)\
        = mr((beta-1)) ell(pi) < mr((beta-1)) beta^c < beta^(c+1) quad qed \
        
      $
  ]
]<teorema-upper-bound-somma-pesi-archi>

#teorema("Osservazione 1")[
  $ sum_(i in I^* \\ I) overline(ell)(pi_i^*) >= beta^c |I^* \\ I| $

  #informalmente()[
    L'osservazione ci dice che la somma della lunghezza dei cammini selezionati dalla soluzione ottima è $>= beta^c$ per il numero di cammini $pi_i^* "t.c" i in I^*\\I$ 
  ]

  #dimostrazione()[
    Per il #link-teorema(<lemma-soluzione-ottima>), $ overline(ell)(pi_i^*) >= beta^c quad forall i in I^* \\ I quad qed$
  ]
]<oss1-congestedpath>

#teorema("Osservazione 2")[
  $ sum_(i in I^* \\ I)overline(ell)(pi_i^*) <= c(beta^(c+1)|I_s|+m) $

  #dimostrazione()[
    Per la definizione del problema, nessun arco $a in A$ può essere usato dai cammini più di $c$ volte. Di conseguenza:
    $ sum_(i in I^* \\ I) overline(ell)(pi_i^*) <= c sum_(a in A) overline(ell)(a) $
    Per il #link-teorema(<teorema-upper-bound-somma-pesi-archi>): 
    $ c sum_(a in A) overline(ell)(a) <= c(beta^(c+1)|I_s|+m) quad qed $
  ]

]<oss2-congestedpath>

#teorema("Teorema")[
  L'algoritmo $"PricingCongestedPaths"$ con input $beta = m^(1/(c+1))$ da una $ (2c m^(1/(c+1))+1)"-approssimazione" $

  #dimostrazione[
    Per il principio di inclusione eslusione $|I^*| = |I^*\\I| + |I^* inter I|$:
    $
      beta^c |I^*| & <= beta^c |I^* \\ I| + beta^c |I^* inter I| \
                   &italic("nota: "mb(|I^* inter I| <= |I|)" in quanto" I "non è ottima")\
                   & underbrace(<=, #link-teorema(<oss1-congestedpath>)) sum_(i in I^* \\ I) overline(ell)(pi_i^*) + beta^c mb(|I|) \
                   & underbrace(<=, #link-teorema(<oss2-congestedpath>)) c(beta^(c+1) |I_s| + m) + beta^c |I| \
                   &italic("siccome" mb(underbrace(|I_s|,"iterazioni fase 1") >= underbrace(|I|,"iterazioni totali"))) \
                   & <= c(beta^(c+1) mb(|I|) + m) + beta^c |I| \
    $
    $italic("Dividiamo ora per " mr(beta^c))$
    $ 
      (beta^c|I^*|) / mr(beta^c) & <= (c(beta^(c+1) |I| + m) + beta^c |I|) / mr(beta^c) \
      & <= c(beta^(c+1)|I| + m) / mr(beta^c) + (beta^c|I|) / mr(beta^c)  \
      & <= (c beta^(c+1)|I|)/mr(beta^c) + (c m) / mr(beta^c) + |I| \
      & <= c beta |I| + c m beta^(-c) + |I| \
      & <= c(beta|I|+m beta^(-c))+|I| \
      & italic("siccome" |I| >= 1 "è una costante")\
      & <= c(beta+m beta^(-c)) dot |I|+|I|
    $
    Calcoliamo il rapporto di approssimazione:
    $ 
      (|I^*|) / (|I|) <= (c(beta + beta^(-c) m) dot |I| + |I|) / (|I|)\
      (|I^*|) / (|I|) <= (c(beta + beta^(-c) m) + 1
    $
    L'approssimazione dipende dal parametro *$beta$*. Plottando questa funzione, il minimo si ottiene come:
    $ beta eq.delta m^(1/(c+1)) $
    Quindi il *miglior tasso di approssimazione*:
    $
      (|I^*|) / (|I|) & <= c(m^(1/(c+1)) + m^(1/(c+1))^(-c) m) + 1 \
                      & <= 2c m^(1/(c+1))+1
    $
  ]
]

Studiano l'approssimazione ottenuta, possiamo osservare che dipende dai parametri $beta$ e $c$: 

#figure(
  box(width: 200pt, height: 150pt)[
    // Linee della tabella
    #place(top + left, dx: 40pt, dy: 20pt, line(length: 120pt, angle: 0deg))  // linea orizzontale
    #place(top + left, dx: 60pt, dy: 0pt, line(length: 150pt, angle: 90deg))  // linea verticale
    
    // Intestazioni
    #place(top + left, dx: 40pt, dy: 0pt, text(size: 12pt)[$c$])
    #place(top + left, dx: 70pt, dy: 0pt, text(size: 12pt)[Approssimazione])
    
    // Valori
    #place(top + left, dx: 40pt, dy: 40pt, text(size: 12pt)[1])
    #place(top + left, dx: 70pt, dy: 40pt, text(size: 12pt)[$2sqrt(m) + 1$])
    
    #place(top + left, dx: 40pt, dy: 70pt, text(size: 12pt)[2])
    #place(top + left, dx: 70pt, dy: 70pt, text(size: 12pt)[$4 root(3, m) + 1$])
    
    #place(top + left, dx: 40pt, dy: 100pt, text(size: 12pt)[3])
    #place(top + left, dx: 70pt, dy: 100pt, text(size: 12pt)[$6 root(4, m) + 1$])
    
    #place(top + left, dx: 40pt, dy: 130pt, text(size: 12pt)[...])
    #place(top + left, dx: 70pt, dy: 130pt, text(size: 12pt)[...])
  ]
)

#informalmente[
  Il *tasso di approssimazione ottenuto è pessimo*, sopratutto se le coppie che si vogliono collegare sono poche.
  Questo algoritmo solo se *$k >> 2sqrt(m) + 1$*. 
]

#nota()[
  Una coppia sorgente-destinazione può essere collegata più volte per ottenere dei collegamenti robusti. Ottenere un $k$ alto è più semplice. 
]