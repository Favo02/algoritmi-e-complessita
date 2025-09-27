#import "../imports.typ": *

= Problema Load Balancing [NPOc]

#informalmente[
  Dato un numero di macchine fissato e un numero di task (di durata nota), vogliamo andare ad assegnare i task alle macchine, in modo tale che *il tempo impiegato dalla macchina più carica sia il minore possibile*. \
  Vogliamo dunque evitare di avere macchine in uno stato di idle prolungato. \
  Inoltre la *versione dell'algoritmo presentata è online*, ovvero il numero di task non è noto a priori, possono essere inserite man mano.
]

- Input:
  - *$m in bb(N)^+$*, numero di macchine
  - *$n in bb(N)^+$*, numero di task
  - *$t_0, t_1, ..., t_(n-1) in bb(N)^+$*, $t_i$ è la *durata dell'i-esimo task*
- $"Sol"_("amm")(x)$: *$underbrace((A_0, A_1, ..., A_(m-1)), "partizione") subset.eq underbrace(n, {0, dots, n-1})$*, ovvero una partizione degli indici dei task nelle varie macchine
- *$C_(Pi)(x)$*: $ underbrace(L_i = sum_(j in A_i) t_j, "Carico della macchina i"), quad L = max_(i in m)(L_i) = "span della soluzione" $
$L$ è il carico della macchina con più lavoro.
- *$t_Pi$*: $min$

#nota[
  *La soluzione ottima assegnerebbe ad ogni macchina lo stesso carico*:
  $L = 1/m * sum_(i=0)^(n-1) t_i$
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
    Se sommo i carici di ogni macchina, ottengo la somma di tutti i task:
    *$ sum_(i in m) L_i^* = sum_(j in n) t_j $*
    Applicando il principio di *pidgeon holding*, almeno una macchina $i$ avrà un carico $L_i^* >= 1/m sum_(i in n) t_j$, di conseguenza la soluzione ottima:
    *$ L^* = underbracket(max, i in n) L_i^* >= 1/m sum_(j in n) t_j $*

    #informalmente[
      Il *principio di pidgeon holding* (o anche detto problema delle camicie e cassetti) afferma che se ci sono $7$ camicie e $5$ cassetti, almeno un cassetto contiene $2$ camicie.
    ]
  ]

  #teorema("Osservazione 2")[
    *$ L^*>= underparen(max, j in n) t_j $*
    La dimostrazione è ovvia: il task più lungo deve per forza essere assegnato ad una macchina.
  ]

  Supponiamo di eseguire ora l'algorimto Greedy LoadBalancing. L'output è una *soluzione $L$* (non ottima):
  *$ L = max L_hat(i), hat(i) "macchina più carica" $*
  Consideriamo ora *l'ultimo task assegnato $t_hat(j)$* alla macchina $hat(i)$.\
  Cosa Rappresentata *$L_hat(i) - t_hat(j)$* ? é il carico che aveva la macchina più scarica $hat(i)$ prima dell'assegnazione del carico $t_hat(j)$:
  *$ L_hat(i) - t_hat(j) <= L_i^' <= L_i forall i in m $*

  Dove $L^'$ è il carico delle altra macchine all'assegnamento del task $t_hat(j)$ (più cariche di $L_hat(i)-t_hat(j)$).\
  Moltiplichiamo per $m$:

  *$ m(L_hat(i)-t_hat(j)) <= sum_(i in m) L_i = sum_(j in n) t_j $*

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

A questo punto potremo chiederci se la dimostrazione proposta è la "migliore possibile".

#informalmente[
  Ci stiamo chiedendo se la dimostrazione proposta in precedenza è precisa oppure è lasca. Ci sono due alternative:
  - Si trova un caso in cui la soluzione prodotta dall'algorimto è $2$ volte l'ottimo
  - Si migliora la dimostazione ($1.8$-APX ad esempio).
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
  - assegnaimo il carico da $1$ ad ogni macchina
  - ripetiamo questa cosa  $m-1$ volte, quindi ogni macchina ha $m-1$ tempo
  - arriva l'ultimo task, la assegnaimo alla prima macchina, che ha $m-1 + m$ tempo

  #informalmente[
    L'algoritmo non sa che arriva la task grande, quindi distribuisce equalmente quelli da 1. Se lo sapesse lascerebbe una macchina vuota e gli assegnerebbe alla fine $m$. In questo csao tutte le macchine arriverebbero alla fine con carico $m$ (le prime $m-1$ con $m -1 + 1$ task da 1, l'ultima con solo il carico da $m$). Questa è la soluzione ottima dato che è la media.
  ]

  $ L/L^* = (2 m -1) / m = 2 - 1/m >= 2-epsilon space qed $

  #informalmente[
    Questa dimostrazione ci ha anche mostrato i punti deboli dell'algorimto.
  ]
]

== SortedGreedyLoadBalancing [3/2-APX]

- Input
- Ordina i task in modo decrescente
- Esegui GreedyLoadBalancing

Questo algoritmo è $O(n log n + n log m)$.

#attenzione[
  Questo algoritmo non è più online, ovvero serve sapere tutte le task prima di iniziare ad assegnare i task.
]

#teorema("Teorema")[
  $ "SortedGreedyLoadBalancing è" 3/2 "-approssimante" $

  #dimostrazione[
    / Caso 1: se ci sono meno task che macchine $n <= m$, funziona esattamente uguale a greedyloadbalancing (senza sorting): assegna ad ogni macchina un task. Troviamo la soluzione ottima, il rapporto è $1$. Il carico finale è la lunghezza del carico più lungo, per osservazione fatta prima questo è l'ottimo. $qed$

    / Caso 2: $n > m$, ci sono più task che macchine.

    / Osservazione 1: $ L^* >= 2 t_m $ La soluzione ottima è almeno due volte il task di indice $m$.
    / Dimostrazione 1: $
        underbrace(t_0 >= t_1 >= ... >= t_m-1 >= t_m, "m+1 task") >= ... \
      $
      Per principio della piccionaia, almeno due task devono essere assegnati alla stessa macchina $i$.
      $ L^* >= L_i^* >= 2 t_m $


    Sia $hat(i)$ la macchina con carico massimo:
    - se ha avuto un solo assegnamento, allora questa è una soluzione ottima. Questo vuol dire che quello che fa questa soluzione è un solo task, quindi non possiamo fare di meglio. $qed$
    - se ha avuto più carichi $>= 2$. Sia $hat(j)$ l'ultimo compilto assegnato a $hat(i)$, già il secondo che le viene assegnato deve essere dopo il carico $m$, quindi deve essere maggiore del carico $m$:
      $
        hat(j) >= m \
        t_hat(j) <= t_m <= 1/2 L^* "per oss1" \
        L = L_hat(i) = ... <= 3/2 L^* \
        L / L^* <= 3/2 space qed
      $
  ]
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
