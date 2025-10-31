#import "../imports.typ": *

= Teorema PCP (picipi)

== Introduzione al teorema PCP


















- fissare due funzioni
- un verificatore per un linguaggio
  - prende in ingresos una stringa
  - effettua q query all'oracolo
  - estrae al massimo r bit random

#teorema("Teorema")[
  NP = PCP[O(log n), O(1)]
]

noi useremo un verificatore in forma normale:
+ la funzione $r$ (bit random) dice che se ne estrae esattamente quel numero (e non al massimo quel numero)
+ faccio esattamente quelle query (non al massimo)
+ le query sono indipendenti tra loro

== Inapprossimabilità di Max E 3 SAT mediante PCP

lemma...
(vogliamo dire che non esiste una 1+$overline(epsilon)$ approssimabile)

quel al più $k$ clausole si può trasformare in esattamente $k$ clausole (ripetendo alcune ckausole)

dimostrazione:

dimostriamo che non è approssimabile per qualche costante (non riusciamo a determinare la costante, ma dire che esista)

...

- Consideriamo una specifica srtinga $x$.
- Interroghiamo $q$ specifiche posizioni dell'oracolo.
- È possibile descrivere le interrogazioni come una funzione.
- QUesta funzione è possibile scriverla come una formula CNF.
- Un'altra CNF $Phi_x$ che mette in and tutte le singole CNF (che non ho capito perchè sono tante)
- il numero di clausole in questa formula grande è un polinomio

Sia $t^*_x$ il masasimo numero di clausole soddisfacibili in $Phi_x$

/ Primo caso: se $x in L, exists w$ (stringa di bit) che fa accettare con probabilità $1$
  i $w$ sono come degli assegnamenti di valori di verità delle clausole CNF, quinid è riscrivibile come $exists$ assegnamento che rende vere tutte le singole clausole, quindi rende vera la CNF $Phi_x$

  $ t_x^* = P(|x|) $

/ Secondo caso: se $x in.not L, forall w$ fa accettare con probabilità $< 1/2$
  Cioè, $forall w$, non siddisfa $>= 2^r(|x|) / 2$ delle $phi_(x,r)$.
  Queste $phi$ sono fatte da $2^q$ clausole

  Qualunque sia $w$, allora non riesco a rendere vero almeno una delle clausole di almeno metà delle $phi$ CNF

  $forall w$ non siddisfa $>=$ ...

  Questo era il numero di clausole non soddisfacibili, quindi il contrario, ovvero quelle soddisfacibili è al massimo:
  $ t_x^* <= P(|x|) - ... $


Adesso dobbiamo chiudere la dimostraszione per assurdo con un $overline(epsilon)$

$ overline(epsilon) = ... $

SUpponiamo per assurdo che ci sia un algoritmo di ottimizazione $A$ che fornisce una $(1+overline(epsilon))$-approssimazione di MaxCNFSAT

Questo algoritmo al posto di prendere in pasto il riconoscitore prende in pasto una CNF prodotta da questo riconoscitore e restituisce $overline(t)$, un'approssimazione di $t^*$

- $A_x$: $x in L => t^* = P(|x|)$
- $B_x$: $x in.not L => t^* <= P(|x|)(1 - 1/(2^...))$

Vogliamo mostrare che i due casi sono disgiunti e nello specifico che $B_x < A_x$, quindi guardando l'approssimazione capire in che caso siamo. Per assurdo:

se $B_x >= A_X$, allora
$ P(|x|) ... $
impossibile dato che $overline(epsilon)$ deve essere $= 0$, quindi otterremmo una $1$-approssimazione, ovvero l'ottimo, impossibile.

Dato $x$ possiamo decidere in tempo polinomiale se $x$ sta in $L$, allora potremmo decidere $L$, sarebbe in $P$. Ma per ipotesi $L in "NPc"$, quindi assurdo, $qed$.

== Inapprossimabilità di MaxIndependentSet

Problema MaxIndependentSet:
- input $G(V,E)$ non orientato
- sol amm: il contrario di una clique: nessun lato del grafo che ha le due estremità dell'insieme $X$
  $ X subset V "indipendenti", quad E inter binom(X, 2) = emptyset $
- funz ob: $|X|$
- tipo: max

#teorema("Teorema")[
  Per ogni $epsilon > 0$, il problema MaxIndependentSet non è $(2-epsilon)$-approssimabile (in tempo polinomiale, se $"P" != "NP"$)

  #dimostrazione[
    Sia $L subset.eq 2^*$ un linguaggio NP-completo

    $L in "PCP"[r(n), q]$ per una specifica funzione $r(n) in O(log n)$ e $q in bb(N)$.

    Sia $V$ un verificatore per $L$.


    Invece che costruire una formula, costruiamo un grafo $G_x$:
    - vertici: $x$-configurazioni, ovvero una coppia:
      $ (R, {i_1 : b_1, ... i_q : b_q}) $
      ovvero una specifica stringa estratta e le posizioni sulla specifica stringa interrogate all'oracolo e le rispettive risposte
      - $R$ è la stringa estratta da $V$
      - $i_1, ..., i_q$ sono le posizioni interrogate su input $x$ e stringa random $R$
      - $b_q, ..., b_q$ sono le risposte dell'oracolo (ovvero i valori della stringa in quelle posizioni)

      Abbiamo esattamente questo numero di vertici:
      $ |V| <= 2^r(|x|) dot 2^q $
    - lati: c'è un lato tra $(R, {...})$ e $(R', {...})$ se e solo se le configurazioni sono incompatibili, cioè
      - $R = R'$
      - oppure $exists k, k'$ tale che $i_k = i'_k'$ e $b_k != b'_k'$

    #teorema("Fatto")[
      Se $x in L, G_x$ ha un insieme indipendente di cardinalità $>= 2^r(|x|)$

      #dimostrazione[
        $exists w$ che fa accettare con probabilità $1$.
        Prendiamo tutte le configurazioni accettanti compatibili con $w$.
        Queste configurazioni non hanno lati che le collegano (dato che sono compatibili).

        Quindi questo è un insieme indipendente, dato che devo accettare con probabilità $1$, la sua cardinalità deve essere $2^r(|x|)$
      ]
    ]

    #teorema("Fatto")[
      Se $x in.not L$, ogni insieme indipendente di $G_x$ ha cardinalità $<= 2^(r(|x|)-1)$

      #dimostrazione[
        Per assurdo, sia $S subset.eq V_G_x$ un inieme indipendente con $|S| > 2^(r(|x|)-1)$.
        Quindi esiste un $w$ compatibile con tutte le configurazioni.
        Accetto con probabilità $> 1/2$, impossibile, $qed$.
      ]
    ]

    #informalmente[
      Quindi, se $x in L$, allora c'è un insieme indipendente grosso, altrimenti è piccolo (queste due cosi sono disgiunte).
    ]

    Sia $t_x^*$ la cardinalità del MaxIndependentSet per $G_x$:
    - se $x in L => t^*_x >= 2^(r(|x|))$
    - se $x in.not L => t_x^* < 2^(r(|x|))/2$

    Adesso supposiamo che esista un algoritmo che restituisce un $overline(t)$ approssimato, con $overline(t) >= t^* / (2-epsilon)$.

    Guardando i due casi dinsgiunti:
    - $x in L => overline(t) >= t^* / (2-epsilon) >= ...$
    - $x in.not L => overline(t) <= t^* / (2-epsilon) <= ...$
  ]
]
