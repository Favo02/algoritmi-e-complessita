#import "../imports.typ": *

= Problema Knapsack (dello zaino) [NPOc] [FPTAS]

#informalmente[
  Abbiamo degli oggetti di un certo peso e valore e uno zaino con una capacità massima.

  Vogliamo portare via il massimo valore di oggetti che stanno nello zaino.
]

- $I_Pi$:
  - $n in bb(N)^*$: numero oggetti
  - $v_0, ..., v_(n-1) in bb(N)^*$: valore oggetti
  - $w_0, ..., w_(n-1) in bb(N)^*, quad w_i <= W$: peso oggetti
  - $W in bb(N)^*$: capacità zaino
- $"Amm"_Pi$: $I subset.eq n$ i pesi non eccedono lo zaino
  $ sum_(i in I) w_i <= W $
- $C_Pi$: massimo valore degli oggetti presi
  $ v = sum_(i in I) v_i $
- $t_Pi = max$

#attenzione[
  Anche se sappiamo che non possiamo risolverlo _bene_, ha comunque senso provarci.
  Magari per le nostre istanze funziona bene oppure lo vogliamo eseguire su numeri piccoli.
]

== Soluzione esatta basata sulla DP

#informalmente[
  La soluzione è esatta, ma non è polinomiale (ovviamente, dato che il problema di decisione associato è NPc).
]

*Parametri* della DP:
- $i$ (righe) = considero solo i primi $i$ oggetti
- $w$ (colonne) = capacità dello zaino
- cella = massimo valore ricavabile con i primi $i$ oggetti in capacità $w$
- soluzione finale = cella in basso a destra, ovvero tutti gli oggetti con zaino di capacità $W$

*Partenza* della DP:
- è facile riempire la prima riga: con $0$ oggetti ovviamente si possono portare via $0$ di valore
- è facile riempire la prima colonna: con zaino di capacità $0$, ovviamente possiamo portare via $0$ di valore

*Transizioni* della DP: come riempiamo le altre celle? dobbiamo capire da cosa dipende ogni cella (e queste celle da cui dipende devono esser già riempite, ad esempio se dipende solo da celle sopra, basta riempire la tabella riga per riga):
- cella $i+1, w+1$:
  - sicuramente sarà possibile portare via lo almeno stesso valore preso nella cella $i+1, w$ (dato che lo zaino è più piccolo)
  - sicuramente sarà possibile portare via lo almeno stesso valore preso nella cella $i, w+1$ (dato che abbiamo solo un oggetto in più ma zaino grande uguale)

  $
    v[i+1, w+1] = cases(
      "// l'oggeto è troppo grosso per stare nello zaino da solo, quindi sicuramente non si prende:"\
      v[i, w+1] "se" w_i > w+1,
      "// posso prendere o non prendere l'oggetto:" \
      max(
        cases(
          quad v[i, w+1] "// non prendo l'isemo oggetto",
          quad v_i + v[i, w+1-w_i] "// prendo l'oggetto togliendo spazio nello zaino"
        )
      ) "altrimenti"
    )
  $

#nota[
  Non c'è bisogno di tenere l'intera tabella, basta solo tenere la riga precedente, quindi si ottimizza lo spazio, al posto di avere N*W di spazio, abbiamo 2*W
]

#attenzione[
  Questo algoritmo sembra polinomiale, $O(N dot W)$.
  Ma è polinomiale sul valore di $W$.

  Ma $W$ è scritto in binario, quindi è esponenziale sulla sulla lunghezza, quinid esponenziale.

  Questo algoritmo è pseudopolinomiale.

  #nota[
    $N$ non è esponenziale perchè non ci serve davvero, si potrebbe non mettere come input ma intuirlo dalla lunghezza dei pesi/valori.
  ]
]

*Algoritmo* della DP:

- $forall i in n, quad v[i, 0] = 0$
- $forall w in W, quad v[0, w] = 0$
- for (i = 0; i < n-1, i++)
  - for (w = 0; w < W-1, w++)
    - if (w[i] <= w+1)

== Ulteriore soluzione basata su DP

*Parametri* della DP:
- $i$ (righe) = considero solo i primi $i$ oggetti
- $v$ (colonne) = voglio portare a casa un valore maggiore o uguale a $v$. Da $0$ a $sum_(i in n) v_i$
- cella w[i, v]: minimo peso che devo sopportare per portare via almeno $v$ con i primi $i$ oggetti (in caso non si possa, $infinity$, ovvero anche con zaino infinito, sarebbe impossibile portare via $>= v$ valore)
- soluzione: guardiamo l'ultima riga, ovvero dove considero tutti gli elementi. Ma alcuni elementi di questa riga potrebbero essere maggiori di $W$, ovvero più del vincolo dello zaino. Quindi dobbiamo trovare l'elemento più a destra $<= W$, quindi di valore (valore della colonna) più grande rimanendo dei vincoli.

*Partenza* della DP:
- cella $0,0 = 0$: per portare a casa $0$ di valore con $0$ oggetti ci basta $0$ capacità dello zaino
- riga $0 = infinity$: per portare via $v>0$ valore con $0$ oggetti è impossibile, qunid anche con zaino fininito è impossibile
- colonna $0 = 0$: per portare via $v= 0$ con $i$ oggetti, allora ci basta uno zaino di capacità $0$

*Transizioni* della DP: come riempiamo le altre celle?
- $
    w[i+1, v+1] = min(
      w[i, v+1],
      w_i + w[i, v+1 - v_i]
    )
  $
- questa cosa è imprecisa dato che potrebbe andare in negativo, perciò andrebbe scritta con i due casi:
  $
    w[i+1, v+1] = cases(
      min(
        w[i, v+1],
        w_i + w[i, v+1 - v_i]
      ),
      ...
    )
  $

#attenzione[
  Dato che ancora una volta la complessità dipende dal *valore* (e non dalla lunghezza) dell'input, allora è ancora esponenziale (*pseudopolinomiale*).
]

== Scaling per Colonna

#informalmente[
  Approccio Turco: Dato che la Turchia era super super super inflazionata (un caffè costava milioni), è stata introdotta la lira pesante, ovvero la stessa valuta di prima ma divisa per $10000$.

  L'idea è la stessa, al posto di usare tutte le colonne su $sum_W$, allora le _compattiamo_ abbassando la scala.
  Questo compatta tanti valori in una stessa colonna, sarà necessario arrotondare tante colonne in una stessa (questo sarà la fonte dell'approssimazione).
]

#attenzione[
  Questa cosa è applicabile solo alla seconda versione di DP.

  Vogliamo *sempre* qualcosa di ammissibile, ma in caso subottimo.
  Mentre invece compattando i pesi della prima DP, staremmo mischiando soluzioni ammissibili e non ammissibili, generando soluzioni sub-ammissibili (concetto che non abbiamo nemmeno introdotto e non vogliamo).
]

Prendiamo un'istanza di knapsack:
$ X =(v_i, w_i, W), quad v_i, w_i, W in bb(N)^+ $
E un tasso di approssimazione per produrre una $1+epsilon$-approssimazione:
$ epsilon in (0, 1] $
Theta: tasso di quanto un valore vecchio vale nuovo
$ theta := (epsilon V) / (2n), quad V = max_(i in n) v_i $
Nuova istanza dove i valori sono scalati ma reali:
$ overline(X) = (overline(v_i), w_i, W), quad overline(v_i) = ceil(v_i / theta) theta $
Nuova istanza dove i valori sono scalati ma interi:
$ hat(X) = (hat(v_i), w_i, W) quad hat(v_i) = ceil(v_i / theta) $

Tutte queste istanze hanno delle soluzioni ottime, $ I^*, overline(I^*), hat(I^*) $
e dei valori ottimi:
$ v^*, overline(v^*), hat(v^*) $

#teorema("Osservazione")[
  Risolvere l'istanza compressa reale e la soluzione compressa intera danno le stesse soluzioni dato che differiscono solo di un coefficiente moltiplicativo fissato.
  $
    overline(I^*) = hat(I^*) \
    overline(v^*) = theta hat(v^*)
  $
  Solo che l'istanza reale non sappiamo come risolverla, invece quella intera possiamo usare la programmazione dinamica.
]

#teorema("Teorema")[
  Sia $I$ una soluzione ammissibile di $X$ (problema originale non compresso).

  La soluzione ottima del problema compresso intero $hat(I^*)$:

  $ (1+epsilon) sum_(i in hat(I^*)) v_i quad >= quad sum_(i in I) v_i $

  #dimostrazione[
    Dividendo, approssimando e rimoltiplicando per la stessa costante, allora si ottiene un valore sicuramente uguale (arrotondamento non necessario) o maggiore (arrotondamento effettuato per ececsso):
    $
      sum_(i in I) v_i & <= sum_(i in I) ceil(v_i / theta) theta \
                       & = sum_(i in I) overline(v_i) \
                       & <= sum_(i in overline(I^*)) overline(v_i) \
                       & = sum_(i in hat(I^*)) overline(v_i) \
                       & "dato che approssimando cresce al massimo di " theta \
                       & <= sum_(i in overline(I^*)) (v_i + theta) \
                       & = sum_(i in hat(I^*)) v_i + n theta \
                       & = sum_(i in hat(I^*)) v_i + n (epsilon V) / (2 n) \
                       & = sum_(i in hat(I^*)) v_i + (epsilon V) / (2) \
    $

    Riscrivendo, questa cosa è valida per ogni I soluzione ammissibile:
    $ sum_(i in I) v_i <= sum_(i in hat(I^*)) v_i + (epsilon V) / 2 $ <temp-asterisco>

    In particolare questo è vero per $I = {i_max}$ dove $i_max$ è l'indice per cui $v_i_max = V$.
    $
      V & <= sum_(i in hat(I^*)) v_i + (epsilon V) / 2 \
        & <= sum_(i in hat(I^*)) v_i + V/2
    $
    $
      V/2 <= sum_(i in hat(I^*)) v_i
    $

    Seguendo da #link-equation(<temp-asterisco>):
    $
      sum_(i in I) v_i <= sum_(i in hat(I^*)) v_i + epsilon sum_(i in ) ... \
      ... \
      qed
    $
  ]
]

#teorema("Teorema")[
  $ (1+epsilon) sum_(i in hat(I^*)) v_i >= v^* $

  #dimostrazione[
    $
      (1 + epsilon) sum_(i in hat(I^*)) v_i >= sum_(i in I^*) v_i = v^* space qed
    $
  ]
]

Tasso di approssimazione...

Quante colonne ci sono (ovvero, quanto abbiamo compresso)?

$ hat(V) = ceil(V/theta) = ceil((V 2 n) / (epsilon V)) = ceil((2n)/epsilon) <= (2n)/epsilon + 1 $

#informalmente[
  Ovvero, il numero di colonne della programmazione dinamica è $n hat(V) = O((2n^2)/ epsilon)$

  Per riempire la tabella di $hat(X)$ ci vuole tempo $O((2 n^3)/ epsilon)$, di conseguenza è polinomiale anche su $epsilon$, quinid FPTAS
]

#teorema("Teorema")[
  *$ "Knapsack" in "FPTAS" $*
]
