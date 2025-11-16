#import "../imports.typ": *

= Problema Load Balancing [NPOc] [PTAS]

#informalmente[
  Dato un numero di macchine fissato e un numero di task (di durata nota), vogliamo andare ad assegnare i task alle macchine, in modo tale che il *tempo* impiegato dalla macchina *più carica* sia il *minore* possibile.

  Vogliamo dunque distribuire il carico il meglio possibile, evitando di avere macchine in uno stato di idle prolungato.
]

Formalmente:
- *$I_Pi =$*
  - $m in bb(N)^+$: numero di macchine
  - $n in bb(N)^+$: numero di task
  - $t_0, t_1, ..., t_(n-1) in bb(N)^+$: durata dei task, $t_i$ è la durata dell'$i$-esimo task
- *$"Amm"_Pi$*: partizione degli indici dei task nelle macchine, ovvero i task che ogni macchina svolge
  $
    "Amm"_Pi = underbrace((A_0, A_1, ..., A_(m-1)), "partizione (insiemi disgiunti)") subset.eq underbrace(n, {0, dots, n-1})
  $
- *$C_Pi$*$= L$: span della soluzione ($L$), ovvero il carico della macchina con più lavoro
  $
    L = max_(i in m)(L_i), quad underbrace(L_i = sum_(j in A_i) t_j, "Carico della macchina" i)
  $
- *$t_Pi$*$= min$

#nota[
  La soluzione *ideale* assegnerebbe ad ogni macchina lo stesso carico, ovvero la *media* dei task:
  $ L = 1/m dot sum_(i=0)^(n-1) t_i $

  #attenzione[
    Non è detto che questa soluzione sia ottenibile, in quanto per realizzarla potrebbe essere necessario "spezzare" dei task.
  ]
]

#esempio[
  //TODO: fare il disegno?
  $m = 3, n = 8, t = [3, 1, 3, 1, 1, 4, 5, 1]$

  - $"macchina" 0$: $[5, 1]$ = $6$ tempo
  - $"macchina" 1$: $[3, 3, 1]$ = $7$ tempo
  - $"macchina" 2$: $[1, 4, 1]$ = $6$ tempo
  $ L = 7 $
  Soluzione ideale (se i task fossero perfettamente divisibili): $ceil(19 / 3) = 7$, quindi questa soluzione (fatta intuitivamente) è quella ottima.
]

#teorema("Teorema")[
  *$ "LoadBalancing" in "NPOc" $*
]

== Greedy LoadBalancing _(online)_ [$2$-APX]

#nota[
  Questo algoritmo è *online*, ovvero i task da assegnare alle varie macchine possono arrivare man mano.
  Non è necessario conoscerli tutti a priori.
]

#pseudocode(
  [$A_i <- emptyset quad forall i in m$],
  [$L_i <- 0 quad forall i in m$ #emph("// carico totale di ogni macchina")],
  [*For* $j = 0, 1, dots, n-1$ *do* #emph("// per ogni task")],
  indent(
    [$hat(i) <- limits(arg min)_(i in m) space L_i$ #emph("// macchina più scarica in questo momento: " + $hat(i)$)],
    [$A_hat(i) <- A_hat(i) union {j}$],
    [$L_hat(i) <- L_hat(i)+t_j$],
  ),
  [*Output* A],
)

#esempio[
  $m = 3, n = 8, t = [3, 1, 3, 1, 1, 4, 5, 1]$

  - $"macchina" 0$: $[3, 4]$ = $"tempo" 7$
  - $"macchina" 1$: $[1, 1, 1, 5]$ = $"tempo" 8$
  - $"macchina" 2$: $[3, 1]$ = $"tempo" 4$
  $ L = 8 $

  La soluzione seguendo l'algoritmo non è ottima.
]

/ Complessità di Greedy LoadBalancing: per ogni task ($n$), deve essere trovata la macchina più scarica. Utilizzando un heap (operazioni logaritmiche): $O(n log m)$, *polinomiale*.

#teorema("Teorema")[
  *$ "GreedyLoadBalancing" in 2"-APX" $*

  #dimostrazione[

    #teorema("Osservazione 1")[
      La soluzione ottima $L^*$ ha uno _span_ (tempo usato dalla macchina più carica) che è almeno la *media* tra i task e il numero di macchine.
      Ovvero, se nessuna macchina sarà mai scarica, non ci sarà inattività, quindi la soluzione sarà ottima.
      $ L^* >= 1/m sum_(j in n)t_j $

      #dimostrazione[
        Se sommo i carichi di ogni macchina (supponendo, in questo caso, che siano distribuiti in maniera ottima $L_i^*$), ottengo la somma di tutti i task. Il lavoro totale completato è uguale al lavoro totale disponibile:
        $ sum_(i in m) L_i^* = sum_(j in n) t_j $

        Applicando il principio di *pigeonholing*, almeno una macchina $i$ avrà un carico maggiore o uguale alla media $1/m limits(sum)_(j in n) t_j$:
        $ exists i in m, space L_i^* >= 1/m sum_(j in n) t_j $

        #nota[
          Il principio di *pigeonholing*, (oppure _della piccionaia_ o _delle camicie e cassetti_) afferma che se $m$ oggetti devono essere messi in $n$ contenitori, con $m > n$, allora almeno un contenitore deve contenere $> 1$ oggetti.

          Una generalizzazione afferma che ci sarà almeno un contenitore che conterrà almeno $ceil(m / n)$ oggetti, ovvero $>=$ alla media (come utilizzato sopra).

          #informalmente[
            Se ci sono $7$ camicie e $5$ cassetti, almeno un cassetto conterrà più della media tra camicie e cassetti, ovvero $> ceil(7 / 5)$, quindi $> 2$.
          ]
        ]

        Di conseguenza, la soluzione ottima $L^*$ (che è il massimo tra i singoli span $L_i^*$), sarà maggiore della media:

        $
          L^* = max_(i in m) L_i^* >= 1/m sum_(j in n) t_j \
          L^* >= 1/m sum_(j in n) t_j space qed
        $
      ]
    ] <greedy-load-balancing-apx-2-oss-1>

    #teorema("Osservazione 2")[
      La soluzione ottima è grande almeno quanto il task più grande:
      $ L^* >= max_(j in n) t_j $

      #dimostrazione[
        Ovvia: il task più lungo deve per forza essere assegnato ad una macchina.
      ]
    ] <greedy-load-balancing-apx-2-oss-2>

    Supponiamo di eseguire ora l'algoritmo Greedy Load Balancing, ci restituisce una soluzione $L$, che non è altro che il carico della macchina più carica:
    $ L = L_hat(i) = max L_i space forall i in m, quad hat(i) "macchina più carica" $

    Consideriamo ora *l'ultimo task* $t_hat(j)$ assegnato alla macchina $hat(i)$.

    Prima dell'assegnazione di questo task, la macchina $hat(i)$ aveva carico $L_hat(i) - t_hat(j)$. In questo istante, $hat(i)$ era la macchina più scarica:
    $
      L_hat(i) - t_hat(j) <= underbrace(L_i^', "carico delle macchine" \ "all'assegnamento") <= underbrace(L_i, "carico finale" \ "delle macchine") mr(forall i in m)
    $

    Possiamo riscrivere il $forall i in m$ come una sommatoria per tutte le $i in m$:
    $
      mr(sum_(i in m))(L_hat(i)-t_hat(j)) & <= mr(sum_(i in m)) L_i \
                 mr(m)(L_hat(i)-t_hat(j)) & <= mr(sum_(i in m)) L_i = sum_(j in n) t_j \
                     m(L_hat(i)-t_hat(j)) & <= sum_(j in n) t_j
    $

    Dividendo per $m$:
    $
      L_hat(i)-t_hat(j) <= 1/m sum_(j in n)t_j underbrace(<=, "per" #link-teorema(<greedy-load-balancing-apx-2-oss-1>)) L^* #<greedy-load-balancing-m-minore-lstar>
    $

    Possiamo riscrivere la soluzione trovata $L$ (output dell'algoritmo) come :
    $
      L = underbrace(L_hat(i), max L_i forall i) &= underbrace(L_hat(i) - t_hat(j), <= mr(L^*) "per" #link-equation(<greedy-load-balancing-m-minore-lstar>)) + underbrace(t_hat(j), <= mr(L^*) "per" #link-teorema(<greedy-load-balancing-apx-2-oss-2>)) \
      L &<= mr(L^* + L^*) \
      L &<= 2L^*
    $
    Di conseguenza, dividendo per $L^*$ otteniamo il rapporto di approsimazione:
    *$ L/L^* <= 2 space qed $*

    #informalmente()[
      La dimostrazione utilizza i seguenti concetti:
      - Utilizza proprietà dell'ottimo (non dell'algoritmo), ma senza sapere come questo ottimo viene costruito. Le osservazioni fatte valgono per una qualunque soluzione, al posto di $L^*$ si poteva usare $forall L$.
      - Ragionando sull'algoritmo:
        - Cosa rende l'algoritmo pessimo? L'assegnazione dell'ultimo task. Quindi, cosa succede quando si assegna l'ultimo task?
    ]
  ]
]

A questo punto potremo chiederci se la dimostrazione proposta è la *"migliore possibile"*.

#informalmente[
  Ci stiamo chiedendo se la dimostrazione proposta in precedenza è *precisa* oppure è *lasca*.
  Con lasca si intende che l'algoritmo è effettivamente 2-approssimante, ma potrebbe essere meglio, ovvero non si ottiene mai un output abbastanza brutto da essere un 2-ottimo.

  Ci sono due alternative:
  - Si trova un caso in cui la soluzione prodotta dall'algoritmo è $2$ volte l'ottimo (caso peggiore)
  - Si va a migliorare la dimostrazione, ottenendo un $alpha$ più piccolo ($1.8$-APX ad esempio)
]

#teorema("Teorema")[
  $forall epsilon > 0, space exists x in I_Pi$ su cui Greedy LoadBalancing produce una soluzione:
  $ 2 - epsilon <= L / L^* <= 2 $

  #informalmente[
    Gli input occupano tutto lo spazio delle soluzioni:
    - alcuni vanno _bene_ e producono una soluzione con rapporto di approssimazione $2 - epsilon$
    - altri vanno _male_ e producono una $2$-approssimazione
  ]

  #dimostrazione[
    Dati:
    - $m in bb(N)^+ > 1/epsilon$: numero macchine
    - $n = m(m - 1) + 1$: numero task
    - $t_0, ... t_(n-2) = 1$: durata dei primi $n-1$ task (tutti tranne l'ultimo)
    - $t_(n-1) = m$: durata dell'ultimo task

    Come si comporta l'algoritmo:
    - tutti i task da $1$ vengono assegnati alla prima macchina libera
    - l'assegnazione viene reiterata $m-1$ volte (numero di task da $1$), quindi ogni macchina ha un carico pari a $m-1$
    - all'arrivo dell'ultimo task, viene assegnato alla prima macchina, avendo così un carico $L = m-1+m = 2m-1$

    $ L/L^* = (2 m -1) / m = 2 - 1/m underbrace(>=, "per" m > 1 / epsilon) 2-epsilon space qed $

    //TODO: Non so se volete mettere un disegno. io penso si capisca cosi.

    #informalmente[
      L'algoritmo non sa che il task grande arriva alla fine, di conseguenza distribuisce equamente tra le varie macchine i task da $1$.
      In una ipotetica soluzione ottima, si potrebbe lasciare una macchina vuota e assegnarle il task da $m$ alla fine.
      In questo caso tutte le macchine arriverebbero alla fine con carico $m$ (le prime $m-1$ con $m - 1 + 1$ task da $1$, l'ultima con solo il carico da $m$).
      Questa è la soluzione ottima dato che è la media.
    ]

    #nota[
      Questa dimostrazione ha anche evidenziato i punti deboli dell'algoritmo.
    ]
  ]
]

== Sorted Greedy LoadBalancing _(offline)_ [$3/2$-APX]

Un modo per cercare di risolvere i problemi descritti in precedenza è *ordinare* i task in maniera decrescente:

#pseudocode(
  [$I_Pi <- I_("GreedyLoadBalancing")$],
  [Sort($t$) #emph("// ordinare i task (decrescente)")],
  [$A <-$ GreedyLoadBalancing($n$, $m$, $t$) #emph("// viene eseguito l'algoritmo greedy")],
  [*Output* $A$],
)

#attenzione[
  Questa versione dell'algoritmo *non* è più *online*, ovvero è necessario avere a disposizione tutti i task prima di iniziare ad assegnarli alle macchine.
]

/ Complessità di Sorted Greedy LoadBalancing: oltre alla complessità di Greedy LoadBalancing $O(n log m)$, i task devono essere ordinati, in $O(n log n)$. Di conseguenza complessità totale: $O(n log n + n log m)$, *polinomiale*.

#teorema("Teorema")[
  *$ "SortedGreedyLoadBalancing" in 3/2"-APX" $*

  #dimostrazione[
    Abbiamo due casi:
    / Caso 1 $n <= m$: se ci sono meno task che macchine, *troviamo la soluzione ottima*.
      Il carico finale è la lunghezza del carico più lungo, per le osservazioni fatte in precedenza questo è l'ottimo.

    / *Caso 2 $n >m$*: ci sono più task che macchine:

      #teorema("Osservazione 1")[
        La soluzione ottima è almeno due volte il task di indice $m$:
        $ L^* >= 2 t_m $

        #dimostrazione[
          $ underbrace(t_0 >= t_1 >= ... >= t_(m-1) >= t_m, "m+1 task") >= ... >= t_(n-1) $
          Per il principio del _pigeonholing_, almeno due task sono assegnati alla stessa macchina. Dato che il task $t_m$ è il più piccolo tra i primi $m+1$, allora i due assegnati alla stessa macchina devono essere per forza $>= 2 t_m$:
          $ L^* >= underbrace(L_i^*, i "ha almeno" \ "due task") >= 2t_m space qed $
        ]
      ] <sorted-greedy-loadbalancing-32-apx-oss1>

      Sia $hat(i)$ la macchina con *carico massimo*:
      - se ha avuto *un solo* assegnamento, allora questa è una *soluzione ottima* $L = L^*$ (dato che la singola task deve essere svolta da qualcuno) $L/L^* = 1 <= 3/2 space qed$
      - se le sono stati assegnati *più carichi* ($>= 2$): sia $hat(j)$ l'ultimo task assegnato a $hat(i)$.\
        Questo carico deve avere indice $hat(j) >= m$ dato che per ricevere un secondo assegnamento tutte le macchine devono aver ricevuto almeno un carico, quindi i primi $m$ task finiscono a macchine diverse:
        $
            hat(j) & >= m \
          t_hat(j) & underbrace(<=, "task ordinate") t_m \
          t_hat(j) & <= 2t_m underbrace(&<=, "per" #link-teorema(<sorted-greedy-loadbalancing-32-apx-oss1>)) L^* \
          t_hat(j) & <= t_m <= 1/2 L^*
        $
        Quindi:
        $
          L = L_hat(i) & = underbrace(L_hat(i) - t_hat(j), <= L^*) + underbrace(t_hat(j), <= 1/2 L^*) \
                     L & <= L^* + 1/2 L^* \
                     L & <= 3/2 L^* \
                 L/L^* & <= 3/2 space qed
        $
  ]
]

#attenzione[
  Questa dimostrazione non è la migliore possibile.
  L'algoritmo non arriverà mai a generare una soluzione $3/2$ volte più grande dell'ottimo.

  Esiste una dimostrazione _(che non vedremo)_ di _Graham 1969_ che mostra che è una $4/3$-approssimazione, di conseguenza:
  *$ "SortedGreedyLoadBalancing" in 4/3"-APX" $*
]

== LoadBalancing e PTAS/FPTAS

#teorema("Teorema")[
  *$ "LoadBalancing" in "PTAS" $*

  #dimostrazione[
    Dimostrato da _Hochbaum-Shmoys 1988_.
  ]
]

#teorema("Teorema")[
  *$ "Se P" != "NP, LoadBalancing" in.not "FPTAS" $*

  #dimostrazione[
    Il problema di decisione associato a LoadBalancing è fortemente NP completo.
  ]
]

=== PTAS per 2-Load Balancing _(offline)_

#nota[
  Versione semplificata del problema $"LoadBalancing"$, con $m = 2$, ovvero solo $2$ macchine.
]

Formalmente:
- *$I_Pi$*:
  - $t_0, ..., t_(n-1) in bb(N)^+$: durata dei task
  - $epsilon > 0 in bb(Q)^+$: tasso di approssimazione desiderato, otterremo una $(1+epsilon)$-approssimazione
- *$"Amm"_Pi$*:
  $
    "Amm"_Pi = underbrace((A_0, A_1, ..., A_(m-1)), "partizione (insiemi disgiunti)") subset.eq underbrace(n, {0, dots, n-1})
  $
- *$C_Pi$*:
  $
    L = max(L_1, L_2), quad underbrace(L_i = sum_(j in A_i) t_j, "Carico della macchina" i)
  $
- *$t_Pi$*$= min$

Algoritmo:

#pseudocode(
  [input $<- t_0,dots,t_(n-1), quad epsilon > 0$],
  [*If* $epsilon >= 1$ *then*],
  indent(
    [Assegna tutti i task a una macchina sola #emph("// approsimazione pessima ma " + $<= 2$)],
    [*Stop*],
  ),
  [Sort $t_i$ in ordine non crescente $t_0 >= t_1 >= dots >= t_(n-1)$],
  [*Fase $1$*],
  indent(
    [$k <- ceil(1/epsilon-1)$],
    [Assegna in modo ottimo i task $t_0,t_1,dots,t_(k-1)$ #emph("// bruteforce, lo span è minimo")],
  ),
  [*Fase $2$*],
  indent(
    [Assegna i restanti $t_k,t_(k+1),dots,t_(n-1)$ in modo greedy],
  ),
)

#attenzione[
  Questo algoritmo rimane polinomiale sulla lunghezza dell'input, ovvero su $n$, ma diventa esponenziale su $epsilon$.
  Per $epsilon -> 0$ i tempi di esecuzione diventano esponenziali.
]

#teorema("Teorema")[
  L'algoritmo è una $(1+epsilon)$-approssimazione per $2$-$"LoadBalancing"$.

  #dimostrazione[
    Definiamo $T$ come la somma del lavoro da effettuare, ovvero la somma delle task:
    $ T = sum_(i in n) t_i $

    Nessuna soluzione può essere migliore di $T/2$, dato che è la media tra le macchine:
    $ L^* >= T/2 $ <load-balancing-ptas-lstar-tmezzi>

    / Caso 1: $epsilon >= 1$:

      Tutti i carichi sono assegnati ad una macchina, quindi lo span finale $L$ sarà uguale al lavoro:
      $ L = T $
      Considerando il rapporto di approssimazione:
      $
        L / L^* quad <= quad T/(T/2) quad = quad (2T)/T quad = quad 2 quad underbrace(<=, epsilon >=1) quad 1 + epsilon space qed
      $

    / Caso 2: $0 < epsilon < 1$:

      Senza perdita di generalità, assumiamo che la macchina $L_1$ sia la più carica al termine dell'algoritmo _(è possibile fare il ragionamento inverso)_:
      $ L = L_1 >= L_2 $ <ptas-load-balancing-perdita-generalita>

      / Sottocaso 2A:
        Alla macchina $1$ *non* vengono assegnati dei task nella _fase$2$_:

        Dato che nella _fase$2$_ la soluzione prodotta nella _fase$1$_ (quindi ottima) non viene toccata, essa rimane ottima.
        Per ottenere una soluzione migliore bisognerebbe migliorare la _fase$1$_, ma questo è impossibile in quanto è già ottima $qed$.

        #dimostrazione[
          Dimostrazione del fatto "banale".

          Sia $L$ una soluzione prodotta dall'algoritmo, dove $L = L_1 >= L_2$ (senza perdita di generalità, #link-equation(<ptas-load-balancing-perdita-generalita>)).

          Sia $x$ la somma delle task $t_i$ assegnate durante la _fase$2$_: $x = limits(sum)_(i = k)^(n-1) t_i$

          L'assegnazione ottima dei primi $k$ task (_fase$1$_) è $(L_1, L_2 - x)$:
          - macchina $1$: per ipotesi, alla prima macchina non verranno assegnati task nella _fase$2$_, quindi il suo carico dopo la _fase$1$_ rimarrà uguale al carico finale $L_1$
          - macchina $2$: tutti i task rimanenti $x$ vengono assegnati ad essa, quindi il carico dopo la _fase$1$_ sarà quello finale $L_2$ meno quelli assegnati durante la seconda fase, $L_2 - x$

          Supponiamo per assurdo che ci sia un modo migliore rispetto a $(L_1, L_2)$ per assegnare tutti i task alle macchine, chiamandolo $(L_1^*, L_2^*)$:
          $
            L quad > quad L^* quad = quad L_1^* underbrace(>=, #link-equation(<ptas-load-balancing-perdita-generalita>)) L_2^*
          $

          Questo assegnamento ottimo, assegna durante la _fase$2$_ rispettivamente $x_1$ e $x_2$ somma di task alle macchine $1$ e $2$.
          Quindi alla fine della prima fase, per questo assegnamento ottimo i carichi varrebbero $(L_1^* - x_1, L_2^* - x_2)$.

          Alla fine della _fase$1$_ ci sono due casi possibili:
          - la prima macchina era più carica
            $
              L_1^* - x_1 >= L_2^* - x_2 \
              L_1^* - x_1 quad <= quad L_1^* quad < quad L quad = quad L_1
            $
          - la seconda macchina era più carica
            $
              L_2^* - x_2 >= L_1^* - x_1 \
              L_2^* - x_2 quad <= quad L_2^* quad <= quad L^* quad < quad L quad = quad L_1
            $

          In entrambi i casi otteniamo un assurdo, dato che $L_1$ è il carico ottimo per i primi $k$ task, $qed$.
        ]

      / Sottocaso 2B: Alla macchina $1$ vengono assegnati dei task nella _fase$2$_:

        Abbiamo detto che l'algoritmo si suddivide in $2$ fasi:
        $
          underbrace(t_0\, t_1\, dots\, t_(k-1), "fase1"), underbrace(t_k\, t_(k+1)\, dots\, t_h\, dots\, t_(n-1), "fase2")
        $

        Sia $t_h$ l'ultimo task assegnato alla macchina $1$ (assegnato durante la _fase$2$_).

        Dato che $t_h$ è stato assegnato alla macchina $1$, allora in quell'istante il suo carico doveva essere minore del carico della macchina $2$, chiamato $L'_2$:
        $ L_1 - t_h quad <= quad L'_2 quad <= L_2 $

        Sommando $L_1$ da entrambe le parti:
        $
            2 L_1 - t_h quad & <= quad L'_2 quad <= quad underbrace(mr(L_1 + L_2), "lavoro totale") \
            2 L_1 - t_h quad & <= quad mr(T) \
          L_1 - t_h / 2 quad & <= quad T/2
        $

        Ricordando che, per #link-equation(<ptas-load-balancing-perdita-generalita>), $L = L_1$:
        $ L quad = quad L_1 quad <= quad t_h / 2 + T/2 $ <load-balancing-ptas-l-th-tmezzi>

        Sappiamo che il lavoro totale è la somma di tutti i task:
        $ T = sum_(i in n) t_i = underbrace(t_0 + ... + t_k, "tutti" >= t_h) + ... + t_h + ... + t_(n-1) $

        Ma dato che sono ordinati, i primi $k+1$ task sono tutti più grandi o uguali di $t_h$ (che è per forza nella seconda fase, quindi dopo $t_k$). In particolare, per ogni $i <= k$ vale $t_i >= t_h$, quindi:
        $
          T quad >= quad sum_(i=0)^k t_i quad >= quad t_h (k+1)
        $ <load-balancing-ptas-th-k1>

        Calcoliamo il tasso di approssimazione:
        $
          L/mr(L^*) & underbrace(<=, #link-equation(<load-balancing-ptas-lstar-tmezzi>)) L / mr(T/2) \
          mb(L)/L^* & underbrace(<=, #link-equation(<load-balancing-ptas-l-th-tmezzi>)) mb(t_h/2 + T/2)/(T/2) quad = quad 1 + t_h/mg(T) \
          L/L^* & underbrace(<=, #link-equation(<load-balancing-ptas-th-k1>)) 1+(t_h)/mg(t_h ( k+1)) quad = quad 1+ 1/(mr(k)+1) \
          L/L^* & underbrace(<=, mr(k = ceil(1/epsilon-1))) 1 + 1/(mr(ceil(1/epsilon-1))+1) \
          L/L^* & <= 1 + 1/(1/epsilon-1+1) \
          L/L^* & <= 1 + epsilon space qed
        $
  ]
]
