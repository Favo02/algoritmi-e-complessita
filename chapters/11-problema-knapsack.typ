#import "../imports.typ": *

= Problema Knapsack (dello zaino) [NPOc] [FPTAS]

#informalmente[
  Dati un insieme di oggetti ciascuno con un certo peso e valore, uno zaino con una capacità massima, vogliamo mettere nello zaino un sotto-insieme di oggetti di valore massimo non superando la capienza dello zaino.
]

Formalmente:
- *$I_Pi$*:
  - $n in bb(N)^*$, numero oggetti
  - $v_0, ..., v_(n-1) in bb(N)^*$, valore oggetti
  - $w_0, ..., w_(n-1) in bb(N)^* quad t.c quad w_i <= W$, peso degli oggetti
  - $W in bb(N)^+$, capacità dello zaino
- *$"Amm"_Pi$*: $I subset.eq n "t.c" $ i pesi degli oggetti non eccedono la capacità dello zaino
  $ sum_(i in I) w_i <= W $
- *$C_Pi$*: massimo valore degli oggetti presi
  $ 
    v = sum_(i in I) v_i \
    C_pi = max(v)
  $
- *$t_Pi$*= $max$

#attenzione[
  Anche se sappiamo che questo problema non può essere risolto in modo efficiente ha comunque senso proporre una soluzione che ci provi.
  Magari per un certo insieme di istanze (di piccola taglia), l'algoritmo proposto funziona bene. 
]

== Soluzione esatta basata sulla DP

#nota()[
  Non è possibile utilizzare un approccio dived-et-impera in quanto i vari sotto-problemi che si verrebero a creare non sono disgiunti. Per questo motivo si ricorre alla programmazione dinamica. 
]

#informalmente[
  La *soluzione* proposta con questo approccio è *esatta* (fornsice l'ottimo), ma *non è polinomiale* (in quanto il problema di decisione associato è $"NPc"$).
]

In un'approccio che sfrutta la DP, è essenziale la scelta dei parametri. Essi devono avere la seguente caratteristica: 
- Deve essere facile rimpire la prima riga e colonna della tabella. 
*Parametri*:
- *$i$* (righe) = considero solo i primi $i$ oggetti
- *$w$* (colonne) = capacità dello zaino
- *$v[i,w]$* cella = massimo valore ricavabile con i primi $i$ oggetti con uno zaino di capacità $w$
- *soluzione finale* = cella in basso a destra, ovvero considero tutti gli $N$ oggetti con uno zaino di capacità $W$

Una volta scelti i parametri è necessario scegliere una *regola di riempimento* (determina la direzione in cui riempiamo la tabella).\
*Partenza* della DP:
- Prima riga: con $0$ oggetti disponibili, otteniamo $0$ di valore
- Prima colonna: con uno zaino di capacità $0$, possiamo portare via $0$ oggetti, di conseguenza il valore è $0$

*Transizioni* della DP: Data la cella corrente da riempire, dobbiamo determinare le celle da cui dipende (devono essere già riempite):
$
  v[i+1,w+1] = cases(
    v[i,w+1] &"se" w_i > w+1 \
    max(v[i,w+1], v_i + v[i,w+1-w_i]) &"altimenti" 
  ) 
$
#informalmente()[
  - Primo caso: l'oggeto $i$ è più grande della capacità dello zaino $w+1$ (anche se preso da solo).
  - Secondo caso: scelgo se non prendere o prendere l'oggetto $i-"esimo"$, nel caso riduco la capacità dello zaino. 
]

#nota[
  Grazie al criterio di riempimento scelto (*per righe*) non c'è bisogno di tenere l'intera tabella in memoria, basta solamente tenere la riga precedente e la corrente. Lo spazio occupato è $Theta(2W)$, al posto di $Theta(N dot M)$
]

Algoritmo: 
#pseudocode(
  [$v[i,0] <- 0 quad forall i in n $],
  [$v[0,w] <- 0 quad forall w in W$],
  [*For*$(i=0 ; i<n-1; i=_+1)$],
  indent(
    [*For*$(w=0 ; w<w-1; w=_+1)$],
    indent(
      [*If* $w[i] <= w+1$],
      indent(
        [$v[i+1,w+1] = max(v[i,w+1],v[i]+v[i,w+1-w_i])$]
      ),
      [*Else*],
      indent(
        [$v[i+1,w+1] = v[i,w+1]$]
      ),
    ),
  ),
  [*End*]
)


#attenzione[
  Questo algoritmo a prima vista sembra polinomiale, $O(N dot W)$. Tuttavia, il secondo ciclo dipende dal valore di $W$ e non dalla sua lunghezza (lunghezza in binario $!=$ valore).\
  Questo *algoritmo è pseudopolinomiale*.

  #nota[
    $n$ (numero di oggetti) non è esponenziale perchè non ci serve davvero, si potrebbe dedurlo dalla lunghezza dei pesi/valori.
  ]
]

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
