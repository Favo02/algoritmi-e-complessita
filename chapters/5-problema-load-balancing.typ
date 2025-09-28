#import "../imports.typ": *

= Problema Load Balancing [NPOc] [PTAS]

#informalmente[
  Dato un numero di macchine fissato e un numero di task (di durata nota), vogliamo andare ad assegnare i task alle macchine, in modo tale che il *tempo* impiegato dalla macchina *più carica* sia il *minore* possibile.

  Vogliamo dunque distribuire il carico il meglio possibile, evitando di avere macchine in uno stato di idle prolungato.
]

- $I_Pi =$
  - $m in bb(N)^+$: numero di macchine
  - $n in bb(N)^+$: numero di task
  - $t_0, t_1, ..., t_(n-1) in bb(N)^+$: durata dei task, $t_i$ è la durata dell'$i$-esimo task
- $"Amm"_Pi$: partizione degli indici dei task nelle macchine, ovvero le task che ogni macchina svolge
  $
    "Amm"_Pi = underbrace((A_0, A_1, ..., A_(m-1)), "partizione (insiemi disgiunti)") subset.eq underbrace(n, {0, dots, n-1})
  $
- $C_(Pi) = L$: span della soluzione ($L$), ovvero il carico della macchina con più lavoro
  $
    L = max_(i in m)(L_i), quad underbrace(L_i = sum_(j in A_i) t_j, "Carico della macchina" i)
  $
- $t_Pi = min$

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
  Soluzione ideale (se le task fossero perfettamente divisibili): $ceil(19 / 3) = 7$, quindi questa soluzione (fatta intuitivamente) è quella ottima.
]

#teorema("Teorema")[
  *$ "LoadBalancing" in "NPOc" $*
]

== Greedy LoadBalancing _(online)_ [2-APX]

#nota[
  Questo algoritmo è *online*, ovvero i task da assegnare alle varie macchine posso arrivare man mano.
  Non è necessario conoscerli tutti a priori.
]

#pseudocode(
  [$A_i <- emptyset quad forall i in m$],
  [$L_i <- 0 quad forall i in m$],
  [*For* $j = 0, 1, dots, n-1$ #emph("// per ogni task")],
  indent(
    [$hat(i) <- limits(arg min)_(i in m) space L_i$ #emph("// macchina più scarica in questo momento: " + $hat(i)$)],
    [$A_hat(i) <- A_hat(i) union {j}$],
    [$L_hat(i) <- L_hat(i)+t_j$],
  ),
  [*End*],
)

#esempio[
  $m = 3, n = 8, t = [3, 1, 3, 1, 1, 4, 5, 1]$

  - $"macchina" 0$: $[3, 4]$ = $"tempo" 7$
  - $"macchina" 1$: $[1, 1, 1, 5]$ =  $"tempo" 8$
  - $"macchina" 2$: $[3, 1]$ = $"tempo" 4$
  $ L = 8 $

  La soluzione seguendo l'algoritmo non è ottima.
]

/ Complessità di Greedy LoadBalancing: per ogni task ($n$), deve essere trovata la macchina più scarica. Utilizzando un heap (operazioni logaritmiche): $O(n log m)$, *polinomiale*.

#teorema("Teorema")[
  *$ "GreedyLoadBalancing" in 2"-APX" $*

  #dimostrazione[

    #teorema("Osservazione 1")[
      La soluzione ottima $L^*$ ha uno _span_ (tempo usato dalla macchina più carica) è almeno la *media* tra i task e il numero di macchine.
      Ovvero, se nessuna macchina sarà mai scarica, non ci sarà inattività quindi la soluzione sarà ottima.
      $ L^*>=1/m sum_(j in n)t_j $

      #dimostrazione[
        Se sommo i carichi di ogni macchina (supponendo che siano distribuiti in maniera ottima $L_i^*$), ottengo la somma di tutti i task. Il lavoro totale completato è uguale al lavoro totale disponibile:
        $ sum_(i in m) L_i^* = sum_(j in n) t_j $

        Applicando il principio di *pigeonhole*, almeno una macchina $i$ avrà un carico maggiore o uguale alla media $1/m limits(sum)_(j in n) t_j$:
        $ exists i in m, space L_i^* >= 1/m sum_(j in n) t_j $

        #nota[
          Il principio di *pidgenhole*, (oppure _pidgeon holding_, _della piccionaia_ o _delle camicie e cassetti_ afferma che se $m$ oggetti devono essere messi in $n$ contenitori, con $m > n$, allora almeno un contenitore deve contenitore $> 1$ oggetti.

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

    Supponiamo di eseguire ora l'algorimto Greedy Load Balancing, ci restituisce una soluzione $L$, che non è altro che il carico della macchina più carica:
    $ L = max L_hat(i), quad hat(i) "macchina più carica" $

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
      L_hat(i)-t_hat(j) <= 1/m sum_(j in n)t_j underbrace(<=, "per" #link-teorema(<greedy-load-balancing-apx-2-oss-1>)) L^*
    $

    Possiamo riscrivere la soluzone trovata $L$ (output dell'algoritmo) come:
    $
      L = underbrace(L_hat(i), max L_i forall i) &= underbrace(L_hat(i) - t_hat(j), <= mr(L^*) "appena dimostrato") + underbrace(t_hat(j), <= mr(L^*) "per" #link-teorema(<greedy-load-balancing-apx-2-oss-2>)) \
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
  Con lasca si intende che l'algoritmo è effettivamente 2-approssimante, ma potrebbe essere meglio, ovvero non si ottine mai un output abbastanza brutto da essere un 2-ottimo.

  Ci sono due alternative:
  - Si trova un caso in cui la soluzione prodotta dall'algorimto è $2$ volte l'ottimo (caso peggiore)
  - Si va a migliorare la dimostrazione, ottenendo un $alpha$ più piccolo ($1.8$-APX ad esempio)
]

#teorema("Teorema")[
  $forall epsilon > 0, space exists x in I_Pi$ su cui Greedy LoadBalancing produce una soluzione:
  $ L-epsilon <= L / L^* <= 2 $

  #informalmente[
    Gli input occupano tutto lo spazio delle soluzioni:
    - alcuni vanno _bene_ e producono una soluzione $L-epsilon$
    - altri vanno _male_ e producono una $2$-approsimazione
  ]

  #dimostrazione[
    Dati:
    - $m in bb(N)^+ > 1/epsilon$: numero macchine
    - $n = m(m - 1) + 1$: numero task
    - $t_0, ... t_(n-2) = 1$: durata dei primi $n-1$ task (tutti tranne l'ultimo)
    - $t_(n-1) = m$: durata dell'ultimo task

    Come si comporta l'algoritmo:
    - tutti i task da $1$ vengono assegnati alla prima macchina libera
    - l'assegnazione viene reiterata $m-1$ volte (numero di task da 1), quindi ogni macchina ha un carico pari a $m-1$
    - all'arrivo dell'ultimo task, viene assegnato alla prima macchina, avendo così un carico $L = m-1+m = 2m-1$

    $ L/L^* = (2 m -1) / m = 2 - 1/m underbrace(>=, "per" m > 1 / epsilon) 2-epsilon space qed $

    //TODO: Non so se volete mettere un diesgno. io penso si capisca cosi.

    #informalmente[
      L'algoritmo non sa che il task grande arriva alla fine, di conseguenza distribuisce equalmente tra le varie macchine i task da $1$.
      In un ipotetica soluzione ottima, si potrebbe lasciare una macchina vuota e assegnarle il task da $m$ alla fine.
      In questo csao, tutte le macchine arriverebbero alla fine con carico $m$ (le prime $m-1$ con $m - 1 + 1$ task da 1, l'ultima con solo il carico da $m$).
      Questa è la soluzione ottima dato che è la media.
    ]

    #nota[
      Questa dimostrazione ha anche evidenziato i punti deboli dell'algorimto.
    ]
  ]
]

== Sorted Greedy LoadBalancing _(offline)_ [$3/2$-APX]

Un modo per cercare di risolvere i problemi descritti in precedenza è *ordinare* i task in maniera decrescente:

#pseudocode(
  [$I_Pi <- I_("GreedyLoadBalancing")$],
  [Sort($t$) #emph("// ordinare le task (decrescente)")],
  [GreedyLoadBalancing($n$, $m$, $t$) #emph("// viene eseguito l'algoritmo greedy")],
  [*End*],
)

#attenzione[
  Questa versione dell'algoritmo *non* è più *online*, ovvero è necessario avere a disposizione tutti i task prima di iniziare ad assegnarli alle macchine.
]

/ Complessità di Sorted Greedy LoadBalancing: oltre alla complessità di Greedy LoadBalancing $O(n log m)$, le task devono essere ordinate, in $O(n log n)$. Di conseguenza complessità totale: $O(n log n + n log m)$, *polinomiale*.

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
          $ underbrace(t_0 >= t_1 >= ... >= t_m-1 >= t_m, "m+1 task") >= ... t_(n-1)\ $
          Per il principio del _pidgeon holding_, almeno due task sono assegnati alla stessa macchina. Dato che il task $t_m$ è il più piccolo, allora le due assegnate alla stessa macchina devono essere per forza $>= 2 t_m$:
          $ L^* >= underbrace(L_i^*, i "ha almeno" \ "due tast") >= 2t_m space qed $
        ]
      ] <sorted-greedy-loadbalancing-32-apx-oss1>

      Sia $hat(i)$ la macchina con *carico massimo*:
      - se ha avuto *un solo* assegnamento, allora questa è una *soluzione ottima* $L^*$ (dato che la singola task deve essere svolta da qualcuno) $L^* <= 3/2 L^* space qed$
      - se le sono stati assegnati *più carichi* $>= 2$: sia $hat(j)$ l'ultimo task assegnato a $hat(i)$.\
        Questo carico deve essere $>= m$ dato che per ricevere un secondo assegnamento tutte le macchine devono aver ricevuto almeno un carico, quindi i primi $m$ task finiscono a macchine diverse:
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
  L'algorimto non arriverà mai a generare una soluzione $3/2$ volte più grande dell'ottimo.

  Esiste una dimostrazione _(che non vedremo)_ di _Graham 1969_ che mostra che è una $4/3$-approssimazione, di conseguenza:
  *$ "SortedGreedyLoadBalancing" in 4/3"-APX" $*
]

== LoadBalancing e PTAS/FPTAS

#teorema("Teorema")[
  *$ "LoadBalancing" in "PTAS" $*

  #dimostrazione[
    Dimostrato da _Hochbaum-Shmoys 1988_.
  ]

  #informalmente[
    Per ottenere una $epsilon$-approssimazione, basta _bruteforcare_ (provando tutte le combinazioni) di un certo numero di task (che dipende dal tasso $epsilon$ richiesto) e poi continuare in maniera Greedy. Al diminuire di $epsilon$ il tempo richiesto cresce in maniera esponenziale.

    Non vedremo come implementare questa variante.
  ]
]

#teorema("Teorema")[
  *$ "Se P" != "NP, LoadBalancing" in.not "FPTAS" $*

  #dimostrazione[
    Il probelma di decisione associato a LoadBalancing è fortemente NP completo.
  ]
]

Load Balancing sta in PTAS (dimostrata da _Hochbaum-Shmoys 1988_).

Se $P != N P$, LoadBalancing non può stare in FPTAS.

Quindi loadbalancing cresce in maniera esponenziale all'abbassarsi di $epsilon$.

#dimostrazione[
  Si sa in quanto il problema di decisione è fortemente NP-completo
]
