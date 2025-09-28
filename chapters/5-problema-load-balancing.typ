#import "../imports.typ": *

= Problema Load Balancing [NPOc]

#informalmente[
  Dato un numero di macchine fissato e un numero di task (di durata nota), vogliamo andare ad assegnare i task alle macchine, in modo tale che *il tempo impiegato dalla macchina più carica sia il minore possibile*. \
  Vogliamo dunque evitare di avere macchine in uno stato di idle prolungato. \
]

- Input:
  - *$m in bb(N)^+$*, numero di macchine
  - *$n in bb(N)^+$*, numero di task
  - *$t_0, t_1, ..., t_(n-1) in bb(N)^+$*, $t_i$ è la *durata dell'i-esimo task*
- $"Amm"_(Pi)(x)$: *$underbrace((A_0, A_1, ..., A_(m-1)), "partizione") subset.eq underbrace(n, {0, dots, n-1})$*, ovvero una partizione degli indici dei task nelle varie macchine
- *$C_(Pi)(x)$*: $ underbrace(L_i = sum_(j in A_i) t_j, "Carico della macchina i"), quad L = max_(i in m)(L_i) = "span della soluzione" $
$L$ è il carico della macchina con più lavoro.
- *$t_Pi$*: $min$

#nota[
  *La soluzione ideale assegnerebbe ad ogni macchina lo stesso carico*:
  $ L = 1/m * sum_(i=0)^(n-1) t_i $
]

//TODO: Fare il disegno forse
#esempio[
  $m = 3, n = 8, t = [3, 1, 3, 1, 1, 4, 5, 1]$

  - $"macchina" 0$: $[5, 1]$ = $6$ tempo
  - $"macchina" 1$: $[3, 3, 1]$ = $7$ tempo
  - $"macchina" 2$: $[1, 4, 1]$ = $6$ tempo
  $ L = 7 $
  Soluzione ottima (se le task fossero perfettamente divisibili): $ceil(19 / 3) = 7$, quindi questa soluzione (fatta intuitivamente) è quella ottima.
]

#teorema("Teorema")[
  *$"LoadBalancing" in "NPOc"$*
]

#pagebreak()

=== Greedy LoadBalancing [2-APX]

Si tratta di un *algoritmo online*. Ovvero, i task da assegnare alle varie macchine posso arrivare man-mano. Non è necessario disporli tutti a priori. 

#pseudocode(
  [$A_i <- emptyset quad forall i in m$],
  [$L_i <- 0 quad forall i in m$],
  [*For* $j=0,1,2 dots, n-1$],
  indent(
    [$hat(i)<- underbrace("argmin", i in m) L_i$],
    [#emph($hat(i)$ + " " + "è l'indice della macchina più scarica")],
    [$A_hat(i)<-A_hat(i) union {j}$],
    [$L_hat(i)<-L_hat(i)+t_j$],
  ),
  [*End*],
)

#esempio[
  $m = 3, n = 8, t = [3, 1, 3, 1, 1, 4, 5, 1]$

  - $"macchina" 0$: $[3, 4]$ = $"tempo" 7$
  - $"macchina" 1$: $[1, 1, 1, 5]$ =  $"tempo" 8$
  - $"macchina" 2$: $[3, 1]$ = $"tempo" 4$
  $ L = 8 $

  La soluzione seguendo l'algoritmo non è ottima
]

=== Complessità di Greedy LoadBalancing

L'algoritmo proposto è polinomiale: *$O(m log n)$*, utilizzando un heap

=== Greedy LoadBalancing *$in 2-"APX"$*

#teorema("Teorema")[
  *Greedy LoadBalancing è un algoritmo $2$-Approssimanto*
]

#dimostrazione()[
  #teorema("Osservazione 1")[
    $ L^*>=1/m sum_(j in n)t_j $
    Lo span (soluzione ottima) è almeno la media tra i task / il numero di macchine. In questo modo nessuna macchina sarà mai scarica -> basso periodo di inattività.
  ]
  #dimostrazione()[
    Se sommo i carichi di ogni macchina, ottengo la somma di tutti i task:
    *$ sum_(i in m) L_i^* = sum_(j in n) t_j $*
    Applicando il principio di *pidgeon holding*, almeno una macchina $i$ avrà un carico $L_i^* >= 1/m sum_(i in n) t_j$, di conseguenza la soluzione ottima:
    *$ L^* = underbracket(max, i in m) L_i^* >= 1/m sum_(j in n) t_j $*

    #informalmente[
      Il *principio di pidgeon holding* (o anche detto problema delle camicie e cassetti) afferma che se ci sono $7$ camicie e $5$ cassetti, almeno un cassetto contiene $2$ camicie.
    ]
  ]

  #teorema("Osservazione 2")[
    *$ L^*>= underparen(max, j in n) t_j $*
    La dimostrazione è ovvia: il task più lungo deve per forza essere assegnato ad una macchina.
  ]

  Supponiamo di eseguire ora l'algorimto Greedy LoadBalancing. L'output è una *soluzione $L$* :
  *$ L = max L_hat(i), hat(i) "macchina più carica" $*
  Consideriamo ora *l'ultimo task assegnato $t_hat(j)$* alla macchina $hat(i)$.\
  Cosa Rappresentata *$L_hat(i) - t_hat(j)$* ? é il carico che aveva la macchina più scarica $hat(i)$ prima dell'assegnazione del carico $t_hat(j)$:
  *$ L_hat(i) - t_hat(j) <= L_i^' <= L_i forall i in m $*

  Dove $L^'$ è il carico delle altra macchine all'assegnamento del task $t_hat(j)$ (più cariche di $L_hat(i)-t_hat(j)$).\
  Moltiplichiamo per $m$:

  *$ m(L_hat(i)-t_hat(j)) <= sum_(i in m) L_i = sum_(j in n) t_j $*

  La disuguaglianza regge in quanto il carico $L_hat(i)-t_hat(j)$ (macchina pià scarica) è $<=$ alla somma di tutti i carichi che compongono la soluzione finale $L$ (per questo moltiplichiamo per $m$). \
  Dividendo per $m$:

  *$ L_hat(i)-t_hat(j) <= 1/m sum_(j in n)t_j <= underbrace(L^*, "oss 1") $*

  Possiamo riscrivere la soluzone trovata $L$ (non ottima) come:
  *$ L = underbrace(L_hat(i), max L_i) = underbrace(L_hat(i) - t_hat(j), <= L^*) + underbrace(t_hat(j), <= L^*) <= 2L^* $*
  Di conseguenza considerando il rapporto di approsimazione:
  *$ L/L^* <= 2 $*

  #informalmente()[
    La dimostrazione utilizza i seguenti concetti:
    - La dimostrazione utilizza proprietà dell'ottimo, ma senza sapere come questo ottimo viene costruito. Le osservazioni fatte valgono per una qualunque soluzione, al posto di $L^*$ si poteva usare $forall L$.
    - Ragionando sull'algoritmo:
      - Cosa rende l'algoritmo pessimo?
        - l'assegnazione dell'ultimo task
        - cosa succede quando si assegna l'ultimo task?
  ]
]

A questo punto potremo chiederci *se la dimostrazione proposta è la "migliore possibile"*.

#informalmente[
  Ci stiamo chiedendo se la dimostrazione proposta in precedenza è precisa oppure è lasca (a causa dei $<=$ introdotti). Ci sono due alternative: 
  - Si trova un caso in cui la soluzione prodotta dall'algorimto è $2$ volte l'ottimo 
  - Si va a migliorare la dimostrazione, ottenendo un $a$ più piccolo ($1.8$-APX ad esempio).
]

#teorema("Teorema")[
  $forall epsilon > 0, exists x in I_Pi$ su cui Greedy LoadBalancing produce una soluzione: 
  *$ L-epsilon <= L / L^* <= 2 $*

  #informalmente[
    Gli input occupano tutto lo spazio delle soluzioni: 
    - alcuni vanno bene e producono una soluzione $L-epsilon$
    - altri vanno male e producono una $2$-approsimazione
  ]
]

#dimostrazione()[
  Dati: 
  - *$m$* un intero *$m > 1/epsilon$* *numero macchine*
  - *$n = m(m - 1) + 1$* numero task
  - *$t_0, ... t_(n-2) = 1$* tutti i task tranne l'ultimo, *$m(m-1)$* task
  - *$t_(n-1) = m$* l'ultimo task
  
  Come si comporta l'algoritmo:
  - assegnaimo i task da 1 alla prima macchina libera
  - l'assegnazione viene reiterata $m-1$ volte (numero di task da 1). Ogni macchina ha un carico pari a $m-1$.
  - quando arriva l'ultimo task, viene assegnato alla prima macchina. Avendo così un carico *$L = m-1+m = 2m-1$*.

  //TODO: Non so se volete mettere un diesgno. io penso si capisca cosi.

  #informalmente[
    L'algoritmo non sa che il task grande arriva alla fine, di conseguenza distribuisce equalmente tra le varie macchine i task da $1$. In un ipotetica soluzione ottima, si potrebbe lascere una macchina vuota e assegnare il task da $m$ alla fine. In questo csao, tutte le macchine arriverebbero alla fine con carico $m$ (le prime $m-1$ con $m -1 + 1$ task da 1, l'ultima con solo il carico da $m$). Questa è la soluzione ottima dato che è la media.
  ]

  *$ L/L^* = (2 m -1) / m = 2 - 1/m underbrace(>=,"per" m > 1/ epsilon) 2-epsilon space $*

  #informalmente[
    Questa dimostrazione ha anche evidenziato i punti deboli dell'algorimto
  ]
]

== Sorted Greedy LoadBalancing [3/2-APX]

Un modo per risolvere i problemi descritti in precedenza è *ordinare i task in maniera decrescente*:
- $I_Pi = I_("GreddyLoadBalancing")$
- Ordina i task in modo decrescente: 
  $ t_0 >= t_1 >= dots >= t_n-1 $
- Esegue L'algorimto GreedyLoadBalancing

=== Complessità di Sorted Greddy LoadBalancing
L'algoritmo ha complessità: 
  *$ O(underbrace( n log n, "Heapsort") + underbrace(n log m,"GreedyLoadBalancing")) $*

#attenzione[
  *Questa versione dell'algoritmo non è più online*, ovvero è necessario avere a disposizione tutti i task prima di iniziare ad assegnarli alle macchine.
]

#teorema("Teorema")[
  *$ "SortedGreedyLoadBalancing è una" 3/2 "-approssimazione" $*
]

#dimostrazione[
  Abbiamo due casi:
    - *Caso 1 $n <= m$*: se ci sono meno task che macchine, *troviamo la soluzione ottima*. Il carico finale è la lunghezza del carico più lungo, per le osservazioni fatte in precedenza questo è l'ottimo.

   - *Caso 2 $n >m$*: ci sono più task che macchine:

    #teorema("Osservazione 1")[
      *$ L^* >= 2 t_m $* 
      La soluzione ottima è almeno due volte il task di indice $m$.
    ]
    #dimostrazione()[
        $ underbrace(t_0 >= t_1 >= ... >= t_m-1 >= t_m, "m+1 task") >= ... \ $
        Per il principio del pidgeon holding, almeno due task sono assegnati alla stessa macchina: 
        *$ L^* >= underbrace(L_i^*,i "ha almeno due tast") >= 2t_m $*
    ]

    Sia *$hat(i)$ la macchina con carico massimo*:
    - *se ha avuto un solo assegnamento*, allora questa è una *soluzione ottima*.
    - *se le sono stati assegnati più carichi $>= 2$*.\
      Sia $hat(j)$ l'ultimo compilto assegnato a $hat(i)$, già il secondo che le viene assegnato deve essere dopo il carico $m$, quindi deve essere maggiore del carico $m$:
      $ hat(j) >= m \
        t_hat(j) <= t_m <= 1/2 L^* "per oss1" \
      L = L_hat(i) = ... <= 3/2 L^* \
        L / L^* <= 3/2 space qed
      $
  ]

#attenzione[
  Questa dimostrazione non è la migliore possibile. L'algorimto non arriverà mai a generare una soluzione $3/2$ volte più grande dell'ottimo.

  Esiste una dimostrazione di _Graham 1969_ che mostra che è una $4/3$-approssimazione
]

== LoadBancing in [PTAS]

Load Balancing sta in PTAS (dimostrata da _Hochbaum-Shmoys 1988_).

Se $P != N P$, LoadBalancing non può stare in FPTAS.

Quindi loadbalancing cresce in maniera esponenziale all'abbassarsi di $epsilon$.

#dimostrazione[
  Si sa in quanto il problema di decisione è fortemente NP-completo
]
