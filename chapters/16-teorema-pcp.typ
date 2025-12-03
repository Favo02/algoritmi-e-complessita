#import "../imports.typ": *

= Teorema PCP (picipi) (Probabilistic Checkable Proofs)

Utilizzeremo il teorema PCP per dimostrare delle proprietà di *inapprossimabilità* di problemi di decisione.

== Macchine di Turing con Oracolo (Verificatori)

Per introdurre il teorema PCP, dobbiamo introdurre un nuovo modello di calcolo, ovvero le Macchine di Turing con oracolo.
Oltre all'input $x in 2^*$, accedono ad una *stringa oracolica* $w in 2^*$.

#informalmente[
  - $x$ è un'istanza di un problema
  - $w$ è una soluzione/dimostrazione del problema
  - $M$ deve verificare se la soluzione $w$ è valida per il problema $x$

  Per fare ciò, $M$ interroga la stringa $w$ in determinate posizioni (fissate), per farsi convincere che sia corretta:
  - se $x$ è *corretta* esiste almeno una stringa $w$ che convince al 100% $M$, quindi che permette di far restituire "YES"
  - se $x$ *NON è corretta*, allora non esiste nessuna stringa $w$ che convince $M$, quindi restituisce sempre "NO"
]

- La macchina $M$ riceve in input una stringa $x in 2^*$
- Viene interrogato l'oracolo attraverso le *query* $Q_i$, che interrogano posizioni specifiche $i_j$ della stringa oracolica $w$, ottenendo risposte $b_j in {0,1}$
- In base alle risposte ricevute dalle query, viene navigato l'albero delle interrogazioni (la logica interna alla macchina $M$).
  Sulle *foglie* di questo albero sono presenti le risposte finali (YES/NO)

L'output finale dipende sia dall'*input* $x$ che dalla *stringa oracolica* $w$.

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Macchina M (rettangolo principale)
    rect((-1, 0.5), (1, 2), stroke: 1.5pt + black, fill: gray.lighten(90%))
    content((0, 1.25), text(size: 14pt, weight: "bold")[$M$])

    // Input x
    line((-2.5, 1.25), (-1, 1.25), mark: (end: ">"), stroke: black)
    content((-2, 1.6), text(size: 11pt)[$x in 2^*$])

    // Output YES
    line((1, 1.8), (2.5, 2.5), mark: (end: ">"), stroke: black)
    content((2.8, 2.5), text(size: 11pt)[YES])

    // Output NO
    line((1, 0.8), (2.5, 0.2), mark: (end: ">"), stroke: black)
    content((2.8, 0.2), text(size: 11pt)[NO])

    // Connessione all'oracolo (freccia verso il basso)
    line((0, 0.5), (0, -0.5), mark: (end: ">"), stroke: black)

    // Oracolo (rettangolo in basso)
    rect((-2, -1.5), (2, -0.5), stroke: 1.5pt + black, fill: yellow.lighten(80%))
    content((-0.9, -1), text(size: 12pt, weight: "bold")[Oracolo])
    content((0.8, -1), text(size: 11pt)[$w in 2^*$])
  }),
  caption: [
    Schema di una Macchina di Turing con oracolo.
  ],
)

#teorema("Teorema")[
  Un linguaggio binario $L subset.eq 2^*$ sta in $"NP"$ se e solo se esiste una Macchina di Turing con oracolo $V$ (*verificatore*) tale che:
  + $V(x,w)$ risponde in tempo polinomiale in $|x|$
  + Se $x in L$ esiste una stringa oracolica $w$ che fa accettare $x$.\
    Se $x in.not L$ *non* esiste alcuna stringa oracolica che fa accettare $x$.
    $ forall x in 2^*, space (exists w in 2^* "t.c." V(x,w)="YES") <==> (x in L) $

  #informalmente[
    È possibile vedere una stringa oracolica $w$ come un *ramo* dell'albero.
    Se l'input $x$ appartiene al linguaggio, allora ci deve essere almeno un ramo che risponde "YES", altrimenti tutti i rami devono restituire "NO".
  ]
]

== Macchine di Turing con Oracolo e Probabilistiche (Verificatori Probabilistici)

Estensione delle Macchine di Turing con Oracolo.
Oltre all'oracolo questo modello di calcolo presenta anche una sorgente di bit *casuali* $r in 2^*$.

#informalmente[
  - $x$ è un'istanza di un problema
  - $r$ sono dei bit casuali
  - $w$ è una soluzione/dimostrazione del problema
  - $M$ deve verificare se la soluzione $w$ è valida per il problema $x$

  Per fare ciò, $M$ interroga la stringa $w$ in determinate posizioni, per farsi convincere che sia corretta.
  Queste *interrogazioni* non sono più fissate come in precedenza, ma sono *casuali*, dipendono dai bit casuali $r$:
  - se $x$ è *corretta* esiste almeno una stringa $w$ che convince al 100% $M$ a *prescindere* da quali bit $r$ vengono selezionati
  - se $x$ *NON è corretta*, allora per qualsiasi $w$ e qualsiasi bit $r$, è *improbabile* che venga accettata ($P <= 1/2$)

  #attenzione[
    $r$ non stabilisce direttamente quali posizioni di $w$ interrogare, ma sceglie quale "test" effettuare.
    Dopo aver estratto $r$, il verificatore diventa deterministico, ovvero viene navigato l'albero come in precedenza.
  ]
]

- Il verificatore $V$ riceve input una stringa $x in 2^*$ ed estrae $r in 2^*$ bit random
- Vengono scelte quali query effettuare in base a $r$
- Viene interrogato l'oracolo, ottenendo risposte $in {0, 1}$ e calcolando la risposta finale "YES/NO"

La probabilità di accettazione di $x$, considerando che $r$ sono scelti a caso, dipende da quanti insiemi $r$ fanno accettare la stringa, rispetto a tutti i possibili $r$:
$
  P[V(x,w) = "YES"] quad & = quad mu({r "t.c." V(x,w,r) = "YES"}) \
  P[V(x,w) = "YES"] quad & = quad (|{r "t.c." V(x,w,r) = "YES"}|)/ 2^(|r|)
$

#nota[
  La funzione $mu$ calcola la probabilità che un elemento cada all'interno dell'insieme passato, rispetto all'universo degli oggetti di quell'insieme:
  $ mu(A) = (|A|)/(|"elementi possibili"|) $
  Ad esempio, prendendo come esempio un dado:
  $ mu({3,5}) = (|{3,5}|) / (|{1,2,3,4,5,6}|) = 2/6 $
]

L'output della macchina $V$ dipende dall'input $x$, dalla stringa oracolica $w$ e dai bit casuali $r$.

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Macchina M (rettangolo principale)
    rect((-1, 0.5), (1, 2), stroke: 1.5pt + black, fill: gray.lighten(90%))
    content((0, 1.25), text(size: 14pt, weight: "bold")[$V$])

    // Input x
    line((-2.5, 1.25), (-1, 1.25), mark: (end: ">"), stroke: black)
    content((-2, 1.6), text(size: 11pt)[$x in 2^*$])

    // Random bits r
    line((0, 2.7), (0, 2), mark: (end: ">"), stroke: red)
    content((0, 3), text(size: 11pt)[$mr(r in 2^*)$])

    // Output YES
    line((1, 1.8), (2.5, 2.5), mark: (end: ">"), stroke: black)
    content((2.8, 2.5), text(size: 11pt)[YES])

    // Output NO
    line((1, 0.8), (2.5, 0.2), mark: (end: ">"), stroke: black)
    content((2.8, 0.2), text(size: 11pt)[NO])

    // Connessione all'oracolo (freccia verso il basso)
    line((0, 0.5), (0, -0.5), mark: (end: ">"), stroke: black)

    // Oracolo (rettangolo in basso)
    rect((-2, -1.5), (2, -0.5), stroke: 1.5pt + black, fill: yellow.lighten(80%))
    content((-0.9, -1), text(size: 12pt, weight: "bold")[Oracolo])
    content((0.8, -1), text(size: 11pt)[$w in 2^*$])
  }),
  caption: [
    Schema di una Macchina di Turing con oracolo probabilistica.
  ],
)

== Classe PCP

#informalmente[
  Utilizziamo un verificatore probabilistico, con due parametri $r$ e $q$, che limitano il numero di *query* (quanto a fondo possiamo ispezionare $w$) e il numero di *estrazioni* casuali (quante volte possiamo ispezionare $w$).
]

Siano $r,q$ due funzioni: $r,q: bb(N) -> bb(N)$.

La classe $"PCP"[r,q] subset.eq 2^(2^*)$ è la classe dei linguaggi $L subset.eq 2^*$ tale che esiste un verificatore probabilistico $V$ che:
+ $V$ lavora in tempo polinomiale in $|x|$
+ $V$ effettua al più $q(|x|)$ query
+ $V$ estrae al più $r(|x|)$ bit random
+ sia $x in 2^*$, una stringa di bit:
  $
    cases(
      "se" mb(x in L) & ==> exists w in 2^*\, space P[V(x,w)="YES"]=1,
      "se" mr(x in.not L) & ==> forall w in 2^*\, space P[V(x,w)="YES"]<1/2
    )
  $

  #attenzione[
    Se $x in L$, deve esistere una stringa oracolica $w in 2^*$ tale che il verificatore accetti sempre, *indipendentemente* dalla stringa random $r$ estratta.
  ]

#nota[
  I verificato introdotti fin'ora sono *adattivi*, ovvero le query che effettuano dipendono dai risultati delle query precedenti.

  Le query effettuate da un nodo dell'albero, dipendono dal ramo percorso fin'ora.
  I nodi, anche allo stesso livello, sono diversi.
]

#teorema("Teorema")[
  L'oracolo e la sorgente di bit random sono *inutilizzabili*.
  L'output dipende solo dall'input, se $x in L$ viene accettato dal verificatore.
  *$ "PCP"[0,0] = "P" $*
]

#teorema("Teorema")[
  Posso accedere all'*oracolo* solo un numero polinomiale di volte (rispetto all'input, quindi è possibile ispezionare tutta la stringa oracolica) ma non possono essere estratti bit random.
  *$ "PCP"[0,"Poly"] = "NP" $*
]

#teorema("Teorema (Arora, Safra 1998)")[
  #informalmente[
    *Trade-off* fra *randomness* e *non determinismo*.
    Con una quantità di bit random logaritmica è possibile ridurre il numero di query all'oracolo a una costante (normalmente sarebbe polinomiale, dato che tutta la soluzione $w$ va controllata).

    La probabilità è *esponenzialmente* più forte del non determinismo.
  ]

  Sia $n$ la lunghezza dell'input: $n = |x|$.
  È possibile definire la classe NP con un numero logaritmico di accessi random e un numero costante di query.
  *$ "NP" = "PCP"[O(log n), O(1)] $*

  Con $log n$ bit random, esisteranno $2^(log n) = n$ diversi casi di test, rimanendo polinomiale.
]

=== Verificatori Probabilistici in Forma Normale

Un verificatore in forma normale, è un verificatore $V$ in forma $"PCP"[r, q]$, con delle ulteriori assunzioni:
+ $V$ legge *esattamente* $q$ bit dall'oracolo $w$ ed estrae *esattamente* $r(n)$ bit random.
  Assunzione wrost-case (da $<=$ ad $=$), basta fare query o estrarre bit che non verranno utilizzati
+ tutti i bit random $r$ vengono estratti all'*inizio*, costruendo subito la stringa $R in 2^(r(n))$
+ tutte le posizioni della stringa $w$ interrogate in *qualsiasi punto dell'albero*, vengono interrogate immediatamente.
  Vengono effettuate $2^q$ query (rimane un $O(1)$)

  #informalmente[
    Le prime due assunzioni sono banali.
    La terza:
    - in un verificatore *adattivo*, le query che vengono effettuate in un determinato istante, dipendono dai risultati delle query precedenti (in nodi diversi dell'albero, anche se sullo stesso livello, possono venir effettuare query in posizioni diverse)
    - in un verificatore in *forma normale*, tutte le possibili posizioni interrogate vengono memorizzate immediatamente
  ]

  #attenzione[
    Trasformare un verificatore probabilisto *adattivo* in un verificatore probabilistico in forma normale fa crescere *esponenzialmente* il numero di query fare all'oracolo.
    Questo perchè vengono fatte immediatamente tutte le query (tutto l'albero) e non solo le query che dipendono dalla risposta precedente (un ramo dell'albero).

    Nel *caso specifico* di $"PCP"[O(log n), O(1)]$ questa cosa è irrilevante, dato il numero totale di query $overline(q)$ rimane una costante $<= 2^q$, molto più grande di prima ma rimane un $O(1)$.

    #esempio[
      #figure(
        cetz.canvas({
          import cetz.draw: *

          content((0, 5), text(size: 11pt)[$q = 3$])

          // Livello 0: radice
          rect((-1.2, 3.8), (1.2, 4.5), stroke: blue, fill: white)
          content((0, 4.15), text(size: 12pt, fill: blue, weight: "bold")[$w_(13)?$])

          // Archi dal livello 0 al livello 1
          line((-0.6, 3.8), (-2.5, 2.7), stroke: black, mark: (end: ">"))
          content((-2, 3.4), text(size: 11pt)[$0$])

          line((0.6, 3.8), (2.5, 2.7), stroke: blue, mark: (end: ">"))
          content((2, 3.4), text(size: 11pt, fill: blue, weight: "bold")[$1$])

          // Livello 1: due nodi
          rect((-3.5, 2), (-1.5, 2.7), stroke: black, fill: white)
          content((-2.5, 2.35), text(size: 11pt, weight: "bold")[$w_(17)?$])

          rect((1.5, 2), (3.5, 2.7), stroke: blue, fill: blue.lighten(95%))
          content((2.5, 2.35), text(size: 11pt, weight: "bold", fill: blue)[$w_(42)?$])

          // Archi dal livello 1 al livello 2
          line((-3, 2), (-4.2, 0.9), stroke: black, mark: (end: ">"))
          content((-4, 1.6), text(size: 10pt)[$0$])

          line((-2, 2), (-1.2, 0.9), stroke: black, mark: (end: ">"))
          content((-1.4, 1.6), text(size: 10pt)[$1$])

          line((2, 2), (1.2, 0.9), stroke: blue, mark: (end: ">"))
          content((1.4, 1.6), text(size: 10pt, fill: blue, weight: "bold")[$0$])

          line((3, 2), (4.2, 0.9), stroke: black, mark: (end: ">"))
          content((4, 1.6), text(size: 10pt)[$1$])

          // Livello 2 (query nodes)
          rect((-5, 0.2), (-3.4, 0.9), stroke: black, fill: white)
          content((-4.2, 0.55), text(size: 11pt, weight: "bold")[$w_(41)?$])

          rect((-2, 0.2), (-0.4, 0.9), stroke: black, fill: white)
          content((-1.2, 0.55), text(size: 11pt, weight: "bold")[$w_(33)?$])

          rect((0.4, 0.2), (2, 0.9), stroke: blue, fill: blue.lighten(95%))
          content((1.2, 0.55), text(size: 11pt, weight: "bold", fill: blue)[$w_(12)?$])

          rect((3.4, 0.2), (5, 0.9), stroke: black, fill: white)
          content((4.2, 0.55), text(size: 11pt, weight: "bold")[$w_(64)?$])

          // Archi dal livello 2 alle foglie
          line((-4.6, 0.2), (-4.9, -0.7), stroke: black, mark: (end: ">"))
          content((-5.1, -0.3), text(size: 9pt)[$0$])

          line((-3.8, 0.2), (-3.5, -0.7), stroke: black, mark: (end: ">"))
          content((-3.3, -0.3), text(size: 9pt)[$1$])

          line((-1.6, 0.2), (-1.9, -0.7), stroke: black, mark: (end: ">"))
          content((-2.1, -0.3), text(size: 9pt)[$0$])

          line((-0.8, 0.2), (-0.5, -0.7), stroke: black, mark: (end: ">"))
          content((-0.3, -0.3), text(size: 9pt)[$1$])

          line((0.8, 0.2), (0.5, -0.7), stroke: blue, mark: (end: ">"))
          content((0.3, -0.3), text(size: 9pt)[$0$])

          line((1.6, 0.2), (1.9, -0.7), stroke: black, mark: (end: ">"))
          content((2.1, -0.3), text(size: 9pt)[$1$])

          line((3.8, 0.2), (3.5, -0.7), stroke: black, mark: (end: ">"))
          content((3.3, -0.3), text(size: 9pt)[$0$])

          line((4.6, 0.2), (4.9, -0.7), stroke: black, mark: (end: ">"))
          content((5.1, -0.3), text(size: 9pt)[$1$])

          // Foglie (YES/NO)
          rect((-5.4, -1.5), (-4.4, -0.7), stroke: green, fill: green.lighten(90%))
          content((-4.9, -1.1), text(size: 10pt, weight: "bold", fill: green)[YES])

          rect((-4, -1.5), (-3, -0.7), stroke: red, fill: red.lighten(90%))
          content((-3.5, -1.1), text(size: 10pt, weight: "bold", fill: red)[NO])

          rect((-2.4, -1.5), (-1.4, -0.7), stroke: green, fill: green.lighten(90%))
          content((-1.9, -1.1), text(size: 10pt, weight: "bold", fill: green)[YES])

          rect((-1, -1.5), (0, -0.7), stroke: red, fill: red.lighten(90%))
          content((-0.5, -1.1), text(size: 10pt, weight: "bold", fill: red)[NO])

          rect((0, -1.5), (1, -0.7), stroke: green, fill: green.lighten(90%))
          content((0.5, -1.1), text(size: 10pt, weight: "bold", fill: green)[YES])

          rect((1.4, -1.5), (2.4, -0.7), stroke: red, fill: red.lighten(90%))
          content((1.9, -1.1), text(size: 10pt, weight: "bold", fill: red)[NO])

          rect((3, -1.5), (4, -0.7), stroke: green, fill: green.lighten(90%))
          content((3.5, -1.1), text(size: 10pt, weight: "bold", fill: green)[YES])

          rect((4.4, -1.5), (5.4, -0.7), stroke: red, fill: red.lighten(90%))
          content((4.9, -1.1), text(size: 10pt, weight: "bold", fill: red)[NO])
        }),
        caption: [
          verificatore #text(blue)[_adattivo_]: esattamente $q$ query (altezza dell'albero) $mb({13\, 42\, 12})$\
          verificatore _forma normale_: tutte le possibili query: $overline(q) <= 2^q$ ${13, 17, 42, 41, 33, 12, 64}$
        ],
      )
    ]
  ]

Queste assunzioni permettono:
- leggere input $x$ e stringa random $R$
- visitare l'albero e effettuare tutte le possibili query, salvando i risultati
- procedere come un normale verificatore *deterministico* (senza non determinismo o randomicità)

== Inapprossimabilità di $"Max"E_3"SAT"$ mediante PCP

#teorema("Lemma")[
  Data una funzione booleana $f$:
  $
    f : 2^({x_1,dots,x_k}) -> {0,1}
  $
  Allora $f$ si può scrivere come una *CNF* con al più $2^k$ clausole, ognuna con esattamente $k$ letterali.

  #informalmente[
    Per ogni assegnamento che deve valere falso costruiamo una clausola che vale $0$ per esattamente quell'assegnamento.

    In questo modo, quando un assegnamento che deve valere falso viene passato, la corrispettiva clausola vale $0$, rendendo falsa tutta la CNF.
  ]

  #esempio[
    #figure(
      table(
        columns: 4,
        align: center,
        table.cell(colspan: 3, fill: gray.lighten(80%))[Funzione $f$],
        table.cell(fill: gray.lighten(80%))[CNF],
        table.cell(fill: gray.lighten(80%))[$x_1$],
        table.cell(fill: gray.lighten(80%))[$x_2$],
        table.cell(fill: gray.lighten(80%))[Valore],
        table.cell(fill: gray.lighten(80%))[Clausola],
        [$0$], [$0$], [$0$], [$(x_1 or x_2)$],
        [$0$], [$1$], [$1$], [_nessuna_],
        [$1$], [$0$], [$0$], [$(not x_1 or x_2)$],
        [$1$], [$1$], [$1$], [_nessuna_],
      ),
      caption: [
        Formula CNF per la funzione $f$: $(x_1 or x_2) and (not x_1 or x_2)$.
      ],
    )
  ]
] <pcp-lemma-formula-booleana>

#teorema("Teorema")[
  Esiste un $overline(epsilon) > 0$ tale che $"MaxSAT"$ non è $(1+overline(epsilon))$-approssimabile, a meno che $"P"="NP"$.

  #informalmente[
    Come per ogni dimostrazione di inapprossimabilità, andiamo a creare un input in cui il gap tra le soluzioni è molto grande.
    Con un'approssimazione troppo piccola, sarebbe possibile capire in quale soluzione ottima siamo, generando un assurdo.
  ]

  #dimostrazione[
    Sia $L$ un linguaggio $in "NPc"$.
    Di conseguenza, per qualche $r(n) in O(log(n))$ e $q in bb(N)$:
    $ L in "NP" = "PCP"[r(n),q] $

    Sia $V$ un verificatore in forma normale per $L$.

    Fissato l'input $x in 2^*$ e i bit random $R in 2^(r(|x|))$, il verificatore $V$ interroga l'oracolo $w$ in $q$ posizioni indipendenti ${i_(1)(x,R), dots, i_(q)(x,R)}$ e accetta o rifiuta in base alle risposte dell'oracolo.
    Possiamo descrivere questo comportamento come una funzione:
    $ f(w_(i_1(x,R)), dots, w_(i_q (x,R))) in {0, 1} space ("YES/NO") $

    Siccome la stringa oracolica $w$ è una funzione booleana, per il lemma #link-teorema(<pcp-lemma-formula-booleana>), $f$ è descrivibile come una formula CNF $phi_(x,R)$ nelle variabili $w_(i_1(x,R)),dots,w_(i_q (x,R))$ con un numero di clausole $<= 2^q$, ciascuna di $q$ letterali.

    Questa formula è diversa per qualsiasi possibile stringa $R$ random scelta.
    Chiamiamo con $Phi_x$ la congiunzione delle formule $phi_(x,R)$ per tutte le *possibili sequenze* di bit random $R$:
    $ Phi_x = underbrace(and.big_(R in 2^(r(|x|))) phi_(x,R), "AND di CNF") $

    Dove:
    + $phi$ è fatta da clausole con $q$ letterali ciascuna (un ramo dell'albero)
    + il numero di clausole di $phi$ è $2^q$
    + $Phi$ contiene $2^r(|x|)$ formule $phi$
    + di conseguenza, in totale, il numero di clausole è:
      $
        2^q dot 2^r(|x|) & = 2^(q+r(|x|)) \
                         & = 2^(q+O(log |x|)) \
                         & in "Poly"
      $

    Esiste quindi un *polinomio* $P(|x|)$ per cui $Phi$ contiene esattamente $|P(x)|$ clausole.

    #informalmente[
      Ogni $phi_(x,R)$ rappresenta una "traccia di esecuzione" (ramo dell'albero) del verificatore con una specifica estrazione random $R$.
      La forma $Phi_x$ è soddisfacibile se e solo se esiste una *stringa* dell'oracolo $w$ che fa *accettare* il verificatore per *ogni* possibile *estrazione random*.
    ]

    Indichiamo con $t^*_x$ il numero di *clausole soddisfatte*.

    Possiamo ora collegarci al linguaggio $L$:
    - se $mb(x in L)$: $V$ deve essere tale per cui esiste una stringa oracolica $w$ che fa accettare $x$ con probabilità $1$.
      *Tutte* le $phi_(x,R)$ devono essere soddisfatte, quindi $Phi_x$ è *soddisfacibile*.
      Esiste quindi un assegnamento che *soddisfa* tutte le $P(|x|)$ clausole di $Phi_x$:
      $ mb(t_x^*) = underbrace(2^r(|x|), "#" phi) underbrace(2^q, "# clausole" phi) = mb(P(|x|)) $

    - se $mr(x in.not L)$: $V$ deve essere tale per cui ogni stringa oracolica $w$ fa accettare $x$ con probabilità $< 1/2$.
      Ogni $w$ *non* soddisfa almeno *metà* delle $phi_(x,R)$ clauosole di $Phi_x$.
      In totale, il numero di clausole soddisfatte è:
      $
        mr(t^*_x) & < underbrace(2^r(|x|) / 2 2^q, "# clausole"\ "soddisfatte") + underbrace(2^r(|x|) / 2 2^(q-1), "# clausole non"\ "soddisfatte") \
        & < P(|x|) / 2 + (2^r(|x|) 2^q 2^(-1)) / 2 \
        & < P(|x|) / 2 + (2^r(|x|) 2^q) / 4 \
        & < P(|x|) / 2 + P(|X|) / 4 \
      $

      #todo

      $
        forall w "soddisfa" & < underbrace(P(|x|), 2^q dot 2^r(|x|) "clausole")- 2^r(|x|)/2 "clausole" \
                            & mb(2^(r(|x|)) = P(|x|)/2^q) \
                            & = P(|x|) - (mb(P(|x|)/2^q) / 2) \
                            & = P(|x|) - P(|x|)/(2^q dot 2) \
                            & = P(|x|) - P(|x|)/2^(q+1)
      $
      Riscrivendo la disequazione per $,mb(t_x^*)$ (numero massimo di clausole soddisfacibili):
      $
        mb(t_x^*) <= P(|x|)-P(|x|)/2^(q+1)\
        mb("Raccogliamo" P(|x|))\
        t_x^* <= P(|x|)(1-1/2^(q+1))\
        mb("Scegliendo il tasso di approx." overline(epsilon) = 1/2^(q+1))\
        mr(t_x^* <= P(|x|)(1-overline(epsilon)))
      $

    #nota[
      Viene usato il *$<=$* e *non* il *$<$* in $t_x^* <= P(|x|)(1-overline(epsilon))$, in quanto:
      - Se il verificatore rifiuta, la formula diventa FALSA.
      - Vuol dire che *almeno una clausola è falsa* (formule CNF in and), non per forza tutte.

      Ad esempio se rendessimo vere *9* clausole su *10*, dobbiamo scrivere che il numero di clausole soddisfatte punteggio è $<= 9$. Non possiamo scrivere $< 9$ (cioè $8$), perché $9$ è raggiungibile.
    ]

    Riassumendo:
    - $"Se" x in L$ = $mb(t_x^* = P(|x|))$
    - $"Se" x in.not L$ = $mr(t_x^* <= P(|x|)(1-1/(2^q+1)))$

    Supponiamo per *assurdo* che ci sia un algoritmo di ottimizzazione $A$ che fornisce una $(1+overline(epsilon))$-approssimazione per $"MaxCNFSat"$. Chiamiamo con $overline(t)$ la soluzione prodotta da $A$ che approssima $t^*$. L'algoritmo $A$ fornisce una approssimazione pari a:
    $
      ((t^*))/(overline(t)) & <= 1 + overline(epsilon) \
                overline(t) & >= t^* / (1+overline(epsilon))
    $
    Di conseguenza:
    - $"Se" mr(x in L)$, la formula è completamente soddisfacibile $t^*=P(|x|)$:
      $ overline(t)>= t^* /(1+overline(epsilon)) = P(|x|)/(1+overline(epsilon)) = mr(A_x) $

    - $"Se" mb(x in.not L)$, non è possibile soddisfare tutte le clausole, ne fallisce una frazione fissa $overline(epsilon)$:
      $
        overline(t) & <= t^* \
                    & <= P(|x|)(1-overline(epsilon)) = mb(B_x)
      $

    Vogliamo dimostrare che $mb(B_x)$ e $mr(A_x)$ *sono separati*, ci riusciamo per $mb(B_x) < mr(A_x)$ , in questo modo guardando la soluzione $overline(t)$ riusciamo a capire in che caso simao, risolvendo così il problema. Se valesse:
    $
      mb(B_x) >= mr(A_x)\
      P(|x|)(1-overline(epsilon)) >= P(|x|)/(1+overline(epsilon))\
      mb("Dividiamo per" P(|x|))\
      (1-overline(epsilon)) >= 1/(1+overline(epsilon))\
      mb("Moltiplichiamo per" (1+overline(epsilon)))\
      (1+overline(epsilon))(1-overline(epsilon)) >= 1\
      1-overline(epsilon)^2 >= 1\
      -overline(epsilon)^2 >= 0\
      underbrace(overline(epsilon)^2, "siccome" overline(epsilon)^2 >=0 \ "sempre") <= 0 => overline(epsilon) = 0 "impossibile" space qed
    $
    impossibile in quanto avevamo definito $overline(epsilon) = 1/2^(q+1)$, di conseguenza $mb(B_x) < mr(A_x)$.\
    Questo signifca che $A_x$ e $B_x$ sono distinguibili, potrei decidere *l'appartenenza* o meno di $x$ al linguaggio $L$ in *tempo polinomiale*. Siccome *$L in "NPc"$* questo è un assurdo $qed$
  ]
]

#teorema("Crollario")[
  Eiste un $overline(epsilon) > 0$ t.c $"Max"E_3"Sat"$ non è $(1+overline(epsilon))$-approssimabile in tempo polinomiale, a meno che $"P" = "NP"$.

  #nota[
    Nella pratica sappiamo che esiste una $8/7+overline(epsilon)$-approssimazione.
  ]
]

== Inapprossimabilità di MaxIndependentSet

#todo

#informalmente[
  Dato un grafo non orientato, vogliamo trovare il più grande insieme di vertici $X$ tale che nessuno di questi vertici $v in X$ sia collegato tra loro da un lato.
]

#esempio([
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== LIVELLO SUPERIORE =====

      // GRAFO ORIGINALE
      content((-6, 3.8), text(size: 12pt, weight: "bold")[Grafo $G$])

      // Vertici
      circle((-7, 2.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-7.4, 2.5), text(size: 10pt)[$v_1$])

      circle((-5, 3), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-5, 3.4), text(size: 10pt)[$v_2$])

      circle((-6, 1.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-6.4, 1.5), text(size: 10pt)[$v_3$])

      circle((-4, 2), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-3.6, 2), text(size: 10pt)[$v_4$])

      circle((-5, 0.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-5, 0.1), text(size: 10pt)[$v_5$])

      // Lati
      line((-6.85, 2.5), (-5.15, 3), stroke: 2pt + black) // v1-v2
      line((-6.9, 2.4), (-6.1, 1.6), stroke: 2pt + black) // v1-v3
      line((-5.85, 1.5), (-4.15, 2), stroke: 2pt + black) // v3-v4
      line((-5.1, 2.9), (-4.1, 2.1), stroke: 2pt + black) // v2-v4
      line((-5.9, 1.4), (-5.1, 0.6), stroke: 2pt + black) // v3-v5
      line((-4.1, 1.9), (-5, 0.6), stroke: 2pt + black) // v4-v5

      // SOLUZIONE NON INDIPENDENTE
      content((-1, 3.8), text(size: 12pt, weight: "bold")[Non Indipendente])
      content((1.5, 3.4), text(size: 10pt, fill: red)[${v_1, v_2, v_3}$ ✗])

      // Vertici
      circle((-2, 2.5), radius: 0.15, fill: red.lighten(70%), stroke: 2pt + red)
      content((-2.4, 2.5), text(size: 10pt)[$v_1$])

      circle((0, 3), radius: 0.15, fill: red.lighten(70%), stroke: 2pt + red)
      content((0, 3.4), text(size: 10pt)[$v_2$])

      circle((-1, 1.5), radius: 0.15, fill: red.lighten(70%), stroke: 2pt + black)
      content((-1.4, 1.5), text(size: 10pt)[$v_3$])

      circle((1, 2), radius: 0.15, fill: white, stroke: 2pt + black)
      content((1.4, 2), text(size: 10pt)[$v_4$])

      circle((0, 0.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((0, 0.1), text(size: 10pt)[$v_5$])

      // Lati
      line((-1.85, 2.5), (-0.15, 3), stroke: 3pt + red) // v1-v2 PROBLEMA!
      line((-1.9, 2.4), (-1.1, 1.6), stroke: 2pt + black) // v1-v3
      line((-0.85, 1.5), (0.85, 2), stroke: 2pt + black) // v3-v4
      line((-0.1, 2.9), (0.9, 2.1), stroke: 2pt + black) // v2-v4
      line((-0.9, 1.4), (-0.1, 0.6), stroke: 2pt + black) // v3-v5
      line((0.9, 1.9), (0, 0.6), stroke: 2pt + black) // v4-v5

      content((-1.5, 0.8), text(size: 9pt, fill: red)[
        $v_1$ e $v_2$ \ collegati!
      ])

      // ===== LIVELLO INFERIORE =====

      // INSIEME INDIPENDENTE
      content((-6, -0.5), text(size: 12pt, weight: "bold")[Insieme Indipendente])
      content((-6, -1.2), text(size: 10pt, fill: green)[${v_1, v_4}$ ✓])

      // Vertici
      circle((-7, -2), radius: 0.15, fill: green.lighten(70%), stroke: 2pt + green)
      content((-7.4, -2), text(size: 10pt)[$v_1$])

      circle((-5, -1.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-5, -1.1), text(size: 10pt)[$v_2$])

      circle((-6, -3.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-6.4, -3.5), text(size: 10pt)[$v_3$])

      circle((-4, -3), radius: 0.15, fill: green.lighten(70%), stroke: 2pt + green)
      content((-3.6, -3), text(size: 10pt)[$v_4$])

      circle((-5, -4.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-5, -4.9), text(size: 10pt)[$v_5$])

      // Lati
      line((-6.85, -2), (-5.15, -1.5), stroke: 2pt + black) // v1-v2
      line((-6.9, -2.1), (-6.1, -3.4), stroke: 2pt + black) // v1-v3
      line((-5.85, -3.5), (-4.15, -3), stroke: 2pt + black) // v3-v4
      line((-5.1, -1.6), (-4.1, -2.9), stroke: 2pt + black) // v2-v4
      line((-5.9, -3.6), (-5.1, -4.4), stroke: 2pt + black) // v3-v5
      line((-4.1, -3.1), (-5, -4.4), stroke: 2pt + black) // v4-v5

      content((-5.5, -5.3), text(size: 9pt, fill: green)[
        Nessun lato tra $v_1$ e $v_4$!
      ])
    }),
    caption: [
      Esempio di MaxIndependentSet. Un insieme è indipendente se nessun vertice è collegato ad un altro. L'obiettivo è trovare l'insieme indipendente di cardinalità massima.
    ],
  )
])

Formalmente:
- *$I_pi$* = $G(V,E)$ non orientato
- *$"Amm"_pi$* = il contrario di una clique, un insieme di vertici $X$, dove nessun lato del grafo che ha le due estremità in esso.
  $ X subset.eq V "indipendenti", quad E inter binom(X, 2) = emptyset $
- *$C_pi$* = $|X|$
- *$t_pi$* = $max$

#teorema("Teorema")[
  Per ogni $epsilon > 0$:
  $
    "MaxIndependentSet non è" (2-epsilon)-"approssimabile"
  $
  in tempo polinomiale, se $"P" != "NP"$
  #dimostrazione[
    Sia $L subset.eq 2^*$ un linguaggio NP-completo, allora :
    $
      L in "PCP"[r(n), q]
    $
    per una specifica funzione $r(n) in O(log n)$ e $q in bb(N)$.\
    Sia $V$ un verificatore in forma normale per $L$. Invece che costruire una formula, costruiamo un grafo *$G_x$* *per ogni* input possibile *$x in 2^*$*:
    - *Vertici*= $x$-configurazioni (ammissibili), ovvero una coppia:
      $ (R, {i_1 : b_1, ... i_q : b_q}) $
      Dove:
      - $R in 2^r(|x|)$ = è la stringa estratta da $V$
      - ${i_1, ..., i_q} in bb(N)$ = sono le posizioni interrogate con input $x$ e stringa random $R$ fissati
      - ${b_1, ..., b_q} in 2 = {0,1}$ = sono le risposte dell'oracolo (ovvero i valori della stringa in quelle posizioni)

      Il numero di vertici è pari a:
      $ mb(|V| <= 2^r(|x|) dot 2^q) $
    - *Lati*= Dati due vertici $(R, {i_1=b_1,dots,i_q=b_q}) in V$ e $(R', {i_1=b_1,dots,i_q=b_q})in V$, esiste un *arco* se e solo se le *configurazioni* sono *incompatibili*, cioè
      - $R eq R'$ //Todo verificare se != o =
      - oppure $exists k, k'$ tale che $i_k = i'_k'$ e $b_k != b'_k'$. Insieme di interrogazione uguale ma risposte dell'oracolo diverse.

    #attenzione[
      Anche se i vertici sono $|V| <= 2^r(|x|) dot 2^q$, nell'insieme indipendente il numero massimo di *vertici selezionabili* è uno per ogni "gruppo" $R$ (al massimo *$2^(r(|x|))$*). Non possiamo prendere due vertici che usano la stessa stringa random $R$ (incompatibili).
    ]

    #esempio[
      configurazioni incompatibili:
      $
        (001,{3:0,mr(4:1),7:3})\
        (010,{13:0,mr(4:0),17:1})
      $
    ]

    #informalmente[
      configurazioni indipendenti significa che non ci può essere una stringa dell'oracolo compatibile con entrambe le stringhe, *non possono coesistere* nello stesso universo.
    ]

    #teorema("Fatto")[
      Se *$x in L, G_x$* ha un insieme indipendente di cardinalità *$>= 2^r(|x|)$*

      #dimostrazione[
        $exists w$ che fa accettare con probabilità $1$.
        Prendiamo *tutte* le *configurazioni* accettanti *compatibili* con *$w$*.
        Queste configurazioni non hanno lati che le collegano (dato che sono compatibili).

        L'insieme di tali configurazioni è un insieme indipendente, dato che devo accettare con probabilità $1$, la sua cardinalità deve essere $2^r(|x|) space qed$

        #nota[
          L'insieme di vertici ha dimensione $>= 2^r(|x|)$, in quanto per un qualunque $R$ devo accettare.
        ]
      ]
    ]<indipendent-sat-fatto-1>

    #teorema("Fatto")[
      Se *$x in.not L$*, ogni insieme indipendente di $G_x$ ha cardinalità $<= 2^(r(|x|)-1)$

      #dimostrazione[
        Per *assurdo*, sia $S subset.eq V_G_x$ un inieme indipendente dove:
        $
          |S| > 2^(r(|x|)-1)
        $
        $S$ è un insieme di configurazioni al cui interno non ci possono essere configurazioni incompatibili tra loro. Si può costruire un $w$ compatibile con tutti i vertici di $S$. Di conseguenza, $w$ viene accettato in tutte le configurazioni, stiamo accettando con probabilità $> 1/2$, ma per definizione è *impossibile* $qed$.
      ]
    ]<indipendent-sat-fatto-2>

    #informalmente[
      Se $x in L$, allora c'è un insieme indipendente di taglia grande, altrimenti avrà uan dimensione ridotta (queste due casistiche sono disgiunte).
    ]
    Sia *$t_x^*$* la cardinalità del MaxIndependentSet per $G_x$:
    - se $mb(x in L) underbrace(=>, #link-teorema(<indipendent-sat-fatto-1>)) t^*_x >= 2^(r(|x|))$

    - se $mr(x in.not L) underbrace(=>, #link-teorema(<indipendent-sat-fatto-2>)) t_x^* < 2^(r(|x|)-1) = 2^(r(|x|))/2$

    Adesso supposiamo per *assurdo* che esista un algoritmo $A$ in grado di restituire una soluzione $overline(t)$ approssimata, con:
    $
      overline(t) >= t^* / (2-epsilon)
    $
    Guardiamo ora i due casi dinsgiunti:
    - Se $mb(x in L)$:
      $
        overline(t) >= t^* / (2-epsilon) underbrace(>=, #link-teorema(<indipendent-sat-fatto-1>)) 2^(r(|x|)) / (2-epsilon) > 2^(r(|x|)) / 2
      $

    - Se $mr(x in L)$:
      $
        overline(t) <= t^* < 2^(r(|x|))/2
      $
      Tuttavia riusciremo a risolvere in tempo polinomaile il problema MaxIndependentSet guardando la soluzione $overline(t)$, questo è un *assurdo* in quanto *$L in "Npc"$*
  ]
]
