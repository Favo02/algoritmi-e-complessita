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

== Ulteriore soluzione basata su DP<seconda-versione-dp>

*Parametri* della DP:
- *$i$* (righe) = Considero solo i primi $i$ oggetti
- *$v$* (colonne) = Voglio portare a casa un valore $>=$ $v$. Da $0$ a $V = sum_(i in n) v_i$. Il numero di colonne è $n V$ (dove $V = max_i v_i$)
- *$w[i, v]$* (cella) =  Minimo peso che devo sopportare per portare via almeno valore $v$ con i primi $i$ oggetti (non sempre è possibile, anche con uno zaino $infinity$)
- *soluzione* = Considero solamente l'ultima riga ($n$ oggetti). Alcune celle potrebbero essere $> W$, ovvero più grandi della capacità dello zaino. La soluzione finale è la cella con valore più alto t.c $<= W$.

*Partenza* della DP:
- $w[0,0] = 0$. Per portare a casa $0$ di valore avendo $0$ oggetti basta uno zaino con capacità $= 0$
- $w[0,v] = infinity quad forall v in V$. Portare via $v > 0$ di valore con $0$ oggetti è impossibile
- $w[i,0] = 0 quad forall i in n$. Per portare via $v=0$ valore con $i$ oggetti disponibili, basta avere uno zaino con capacità $0$

*Transizioni* della DP:
$
  v[i+1,w+1] = cases(
    min(underbrace(w[i,v+1],"oggetto "i" non preso"), underbrace(w_i+w[i, v+1-v_i],"prendo oggetto "i)) "se" &v_i <= v+1 \
    \
    w[i,v+1] &"altrimenti"
  )
$
#nota()[
  è necessario fare due casi in quanto la componente $v+1-v_i$ può essere negativa. $v_i > v+1$ significa che l'oggeto $i$ ha talmente tanto valore che può essere preso da solo (secondo caso). 
]

//TODO provare a spiegare meglio (?)
#attenzione[
  Dato che ancora una volta la complessità dipende dal *valore* (e non dalla lunghezza) dell'input, allora l'approccio proposto è esponenziale (*pseudopolinomiale*).
]

== Scaling per Colonna

#informalmente[
  Approccio Turco: Dato che la Turchia era super super super inflazionata (un caffè costava milioni), è stata introdotta la lira pesante, ovvero la stessa valuta di prima ma divisa per $10000$.
]

L'idea dello scaling è rendere l'algorimto precedentemente presentato polinomiale. Per farlo andiamo a *ridurre il numero di colonne*. Al posto di usare tutte le colonne su $sum_W$, le _compattiamo_ abbassando la scala. Questo permette di compattare tanti valori in una stessa colonna, sarà necessario arrotondare (l'algoritmo si trasofrma in una versione approssimata).

#attenzione[
  Questo tipo di tecnica è applicabile *solo alla seconda versione di DP* #link-section(<seconda-versione-dp>).

  Se applicassimo la tecnica alla prima versione della DP andremo a mischiare delle soluzioni ammissibili e non ammissibili, *generando soluzioni sub-ammissibili* (concetto che non abbiamo nemmeno formalizzato).
]

Dati per lo scaling: 
- Istanza di knapsack 
$ X =(v_i, w_i, W), quad v_i, w_i, W in bb(N)^+ $
- Tasso di approssimazione $epsilon in (0, 1]$
- Parametro $theta$. Esso rappresenta il *fattore di scaling*, ovvero di quanto comprimiamo i valori dell'istanza originaria
$ theta = (epsilon V) / (2n), quad V = max_(i in n) v_i $

#informalmente()[
  $theta$ rappresenta l'unità di misura della nuova scala di valori:
  - Più $theta$ è grande, più comprimiamo (meno colonne, più approssimazione).
  - Più $theta$ è piccolo, meno comprimiamo (più colonne, meno approssimazione).
]

Risultato: 
- *$overline(I)$*. Nuova istanza dove i valori sono scalati ma reali:
$ overline(X) = (overline(v_i), w_i, W), quad overline(v_i) = ceil(v_i / theta) theta $

- *$hat(I)$*. Nuova istanza dove i valori sono scalati ma interi:
$ hat(X) = (hat(v_i), w_i, W) quad hat(v_i) = ceil(v_i / theta) $

Tutte queste istanze hanno delle soluzioni ottime: 
$ I^*, overline(I^*), hat(I^*) $
E dei valori ottimi:
$ v^*, overline(v^*), hat(v^*) $

#esempio[

  Supponiamo $n = 3$, $ε = 0.1$, $V = 1000$:
  
  $θ = (0.1 · 1000)/(2 · 3) = 100/6 ≈ 16.67$
  
  Valori originali: $v = [150, 299, 1000]$
  
  Valori scalati reali: $overline(v) = [⌈150/16.67⌉ · 16.67, ⌈299/16.67⌉ · 16.67, ⌈1000/16.67⌉ · 16.67] = [167, 317, 1000]$
  
  Valori scalati interi: $hat(v) = [⌈150/16.67⌉, ⌈299/16.67⌉, ⌈1000/16.67⌉] = [10, 19, 60]$
  
  *Risultato*: invece di $sum v_i = 1449$ colonne, ora abbiamo $max hat(v_i) = 60$ colonne
]

#teorema("Osservazione")[
  Risolvere l'istanza reale $overline(I)$ e l'istanza intera $hat(I)$ è la stessa cosa. Entrambe forniscono le stesse soluzioni in quanto *differiscono solamente di un coefficiente moltiplicativo fissato*.
  $
    overline(I^*) = hat(I^*) \
    overline(v^*) = theta hat(v^*)
  $
  L'istanza $overline(I)$ essendo intera è risolvibile attraverso la programmazione dinamica.
]

#teorema("Teorema")[
  Sia $I$ una soluzione ammissibile di $X$ (problema originale non compresso), $I in "Amm"_X$.

  La soluzione ottima del problema compresso intero $hat(I^*)$:

  $ (1+epsilon) sum_(i in hat(I^*)) v_i quad >= quad sum_(i in I) v_i $

  #dimostrazione[
    Dato un valore $v_i$ quando lo approssimo per $theta$, trovo un valore $v_i^' >= v^i$ (a casua della presenza dell'arrotondamento per ecesso). Di conseguenza:
    $
      sum_(i in I) v_i & <= sum_(i in I) ceil(v_i / theta) theta = sum_(i in I) overline(v_i) \
      & "Dato che" overline(I)^* "è ottima e il problema è di massimizzazione"
      \
        & <= sum_(i in overline(I^*)) overline(v_i) underbrace(=,mr(overline(I)^* = hat(I)^*)) sum_(i in hat(I^*)) overline(v_i) \

        & "Dato che ogni valore cresce al massimo di" theta \

        & <= sum_(i in overline(I^*)) (v_i + theta) \

        & = sum_(i in hat(I^*)) v_i + n theta \

        & = sum_(i in hat(I^*)) v_i + n (epsilon V) / (2 n) \

        & = sum_(i in hat(I^*)) v_i + (epsilon V) / (2) \
    $

    Riscrivendo la disequazione:
    $ sum_(i in I) v_i <= sum_(i in hat(I^*)) v_i + (epsilon V) / 2 $ <temp-asterisco>

    In particolare, la disequazione vale per $I = {i_max}$ dove $i_max$ è l'indice per cui $v_i_max = V$.
    $
      V & <= sum_(i in hat(I^*)) v_i + (epsilon V) / 2 \
      & "siccome" epsilon <= 1 "possiamo approssimarlo" \
        & <= sum_(i in hat(I^*)) v_i + V/2
    $
    $
      V/2 <= sum_(i in hat(I^*)) v_i
    $

    Seguendo da #link-equation(<temp-asterisco>):
    $
      sum_(i in I) v_i & <= sum_(i in hat(I^*)) v_i + epsilon sum_(i in hat(I)^*) v_i \
      & "raccogliendo" (1+epsilon) \
      &= (1+epsilon) sum_(i in hat(I)^*) v_i quad qed\
    $
  ]
]

#teorema("Teorema")[
  $ (1+epsilon) sum_(i in hat(I^*)) v_i >= v^* $
  dove $(1+epsilon) sum_(i in hat(I^*)) v_i$ è il valore ottimo che porto a casa applicando la DP al problema $hat(X)$.

  #dimostrazione[
    $
      (1 + epsilon) sum_(i in hat(I^*)) v_i >= sum_(i in I^*) v_i underbrace(=,"in quanto considero" \ hat(I^*) ) v^* space quad qed
    $
  ]
]

=== Tasso di approssimazione

Quante colonne ci sono (ovvero, quanto abbiamo compresso). Per prima cosa calcoliamo il valore compresso: 

$ hat(V) = ceil(V/theta) = ceil((V) / ((epsilon V)/(2n))) = ceil( (V 2n)/(epsilon V))=  ceil((2n)/epsilon) <= (2n)/epsilon + 1 $

#nota[
  Il numero di colonne della programmazione dinamica è $n hat(V) = O((2n^2)/ epsilon)$

  Per riempire la tabella di $hat(X)$ ci vuole tempo $O((2 n^3)/ epsilon)$, di conseguenza è polinomiale anche su $epsilon$, quindi $in$ FPTAS
]

#teorema("Teorema")[
  *$ "Knapsack" in "FPTAS" $*
]
