#import "../imports.typ": *

= Problemi e Algoritmi <problemi-algoritmi>

/ Algoritmo: metodo risolutivo formale di un problema _(ne riparleremo meglio dopo aver definito problema)_
/ Problema ($Pi$):
  - Insieme degli input possibili: $quad I_Pi subset.eq 2^*$
  - Insieme degli output possibili: $quad O_Pi subset.eq 2^*$
  - Funzione soluzione, ad ogni input associa un insieme non vuoto dei possibili output: $ "sol"_Pi: I_Pi -> 2^(O_Pi \\ {emptyset}) $
  #nota[
    La funzione soluzione ha come codominio l'insieme delle parti dei possibili output $2^(O_Pi \\ {emptyset})$, ovvero associa ad ogni input $in I_Pi$ un sottoinsieme dei possibili output, ovvero un elemento dell'insieme delle parti di $O_Pi$.
  ]
  #attenzione[
    Questo sottoinsieme non deve essere vuoto, ovvero assumiamo che per ogni input *esista* almeno una soluzione.

    Ma *non* è detto che questa soluzione sia *univoca*, un input potrebbe avere più soluzioni ugualmente corrette. Un algoritmo è corretto per un certo problema se restituisce *uno qualsiasi* tra i possibili output corretti. È quindi possibile che due algoritmi diversi producano output diversi a fronte dello stesso input.

    #esempio[
      Problema: dato l'elenco dei nomi degli studenti presenti in aula, restituire il primo studente in ordine alfabetico.

      In caso ci siano due studenti con lo stesso nome, chi viene restituito? È *sbagliato* stamparli entrambi, ne viene chiesto solo uno.

      Quindi, due algoritmi diversi possono restituire soluzioni diverse ma essere entrambi corretti.
    ]
  ]

#esempio[
  #nota[
    Un problema è formalmente definito dalle caratteristiche appena listate, ma viene normalmente descritto in linguaggio naturale.
  ]

  Problema: Decidere se un numero è primo.

  Formalmente:
  - *$I_Pi$*: numeri interi naturali $bb(N)$
  - *$O_Pi$*: vero/falso (quindi è un problema di decisione)
  - *$"sol"_Pi$*: per questo specifico esempio, per ogni input c'è un SOLO output, quindi ogni insieme è un *singoletto*

  #nota[
    Restringere l'insieme degli output non rende più facili i problemi!
  ]
]

== Input e Output binari <input-output-binari>

Assumiamo sempre che $I_Pi, O_Pi subset.eq 2^*$. Tutti i problemi che vedremo sono *mappabili su sequenze binarie* (numeri in base due, stringhe in ASCII, ...).

#esempio[
  Problema: dati due interi positivi $x, y$, calcolare il loro $"MCD"(x, y)$.

  Il programma deve prendere una *sola* sequenza di bit, quindi non possiamo dare i due numeri in binario (l'algoritmo non saprebbe separarli: come capire quando finisce il primo e inizia il secondo?).

  / Soluzione 1: usare direttamente l'ASCII, i numero vengono codificati in ASCII e in mezzo viene inserito un carattere non cifra separatore (una virgola ad esempio).

  $ 12 mb(",") 7 $

  / Soluzione 2: prima del numero, viene dichiarato quando è lungo il numero che segue, utilizzando una codifica unaria. Ovvero tanti zeri quanti è lungo il numero seguiti da un bit a uno per indicare l'inizio del numero vero e proprio. Questa rappresentazione prende il nome di *Elias $gamma$*:

    In binario:
    $ x = 12 -> mono(1100) $
    $ y = 7 -> mono(111) $

    Elias $gamma$:
    $
      mono(mb(underbrace(0000, "4 zeri")1) space underbrace(1100, "4") space mb(underbrace(000, "3 zeri")1) space underbrace(111, "3"))
    $

  / Soluzione 3: scrivere i numeri in unario, tanti zeri quanti è lungo il numero seguiti da un bit a uno per indicare la fine.

  $ mono(underbrace(000000000000, "12 zeri") mb(1) space underbrace(0000000, "7 zeri")mb(1)) $

  Quale di queste soluzioni è la più efficiente?

  / Soluzione 1: $8 ceil(log_10 x) + 8 + 8 ceil(log_10 y)$

  / Soluzione 2: $2 ceil(log_2 x) + 2 ceil(log_2 y)$

  / Soluzione 3: $x + 1 + y + 1$

  Per numeri molto piccoli dovrebbe funzionare meglio la soluzione 1, per numeri grandi la soluzione 2.
  Le prime due soluzioni differiscono solamente di un fattore moltiplicativo, quindi sono *asintoticamente equiparabili*. La terza invece è *esponenzialmente* più grande delle prime due dato che è lineare, quindi è da evitare.
]

== Correttezza <correttezza>

Un algoritmo $A$ si dice *corretto* se per ogni input $x in I_Pi$ produce un output $y in O_Pi$ che appartiene alle soluzioni ammissibili $"sol"_Pi$ per l'input $x$:

#{
  set align(center)
  import fletcher: *
  diagram(
    spacing: (10pt, 4em),
    {
      let (x, a, y) = ((0, 0), (3, 0), (6, 0))

      node(x, $x$)
      node(a, $A$, stroke: 1pt, shape: rect, width: 4em, height: 3em)
      node(y, $y in O_Pi, quad y in "sol"_(Pi)(x)$)

      edge(x, a, "->")
      edge(a, y, "->")
    },
  )
}

La definizione di algoritmo corrisponde alla *Macchina di Turing* (MdT).

#teorema("Tesi di Church")[
  È possibile affermare che un qualsiasi sistema di calcolo sensato (python, c, ...) è riconducibile alla macchina di Turing (a patto che si supponga memoria infinita).

  #informalmente[
    Ovvero, per qualsiasi sistema di calcolo inventato dall'uomo, come la macchina di Turing o Python (supponendo infinita memoria), otteniamo lo stesso insieme di problemi decidibili.
  ]
] <teorema-tesi-church>

== Problemi di decisione: Decidibilità <problemi-decisione-decidibilita>

I problemi di decisione (detti anche _membership problems_) sono una particolare famiglia di problemi, i quali ammettono, per ogni istanza di input, solamente due possibili risposte: vero o falso.

/ Decidibili: un problema si dice *decidibile* se esiste un algoritmo in grado di risolverlo. Sia $X$ un insieme, un problema di decisione è decidibile se esiste un algoritmo $A$:

#{
  set align(center)
  import fletcher: *
  diagram(
    spacing: (10pt, 4em),
    {
      let (x, a, x1, x2) = ((0, 0), (3, 0), (6, -0.2), (6, 0.2))

      node(x, $x in 2^*$)
      node(a, $A$, stroke: 1pt, shape: rect, width: 4em, height: 3em)
      node(x1, $"si", space x in X$)
      node(x2, $"no", space x in.not X$)

      edge(x, a, "->")
      edge(a, x1, "->")
      edge(a, x2, "->")
    },
  )
}

#nota[
  Parlare di problema decidibile o di *linguaggio* decidibile è la stessa cosa. Gli input del problema non sono altro che delle stringhe di bit e di conseguenza si può determinare se appartengono o meno al linguaggio.
]

#informalmente[
  Un problema è decidibile se possiamo rispondere correttamente alla domanda "Un elemento $x$ fa parte dell'insieme che definisce il problema?"
]

#teorema("Teorema")[
  Se il linguaggio del problema di decisione $X$ è *finito*, allora il problema è *decidibile*.

  #dimostrazione[
    Banalmente, basterebbe fare una catena di if elencando tutte le stringhe che appartengono al linguaggio.
  ]
] <teorema-linguaggio-finito-decidibile>

/ Non decidibili: esistono degli insiemi che non sono decidibili? Si, l'insieme dei problemi di decisione è troppo numeroso.

#dimostrazione[
  / Numerabilità programmi: ogni programma che implementa un algoritmo è rappresentabile come un intero. Quindi esistono altrettanti programmi quanti numeri naturali $|bb(N)|$.

  / Più che numerabilità problemi: un problema di decisione è un sottoinsieme di tutte le possibile stringhe di input. Di conseguenza è l'insieme delle parti dell'insieme di tutte le stringhe $2^2^*$. Un insieme delle parti di un insieme ha una cardinalità decisamente superiore: ha la stessa cardinalità dei numeri reali $|bb(R)|$ (potenza del continuo).

  Dato che esistono molti più problemi che programmi, allora molti problemi devono per forza non essere decidibili.
]

Possiamo creare il seguente insieme:

#figure(
  {
    set text(weight: "bold")
    let stroke_alpha = 150
    let fill_alpha = 50
    let big_dot = text(20pt)[$dot$]

    cetz.canvas({
      import cetz.draw: *

      // External box
      rect((0, 0), (rel: (10, 6)), name: "superset")
      content("superset.north-east", [$2^2^*$], anchor: "south-west")

      // Non decidibili
      rect(
        "superset.south-west",
        (rel: (4, 4)),
        stroke: rgb(70, 70, 70, stroke_alpha),
        fill: rgb(70, 70, 70, fill_alpha),
        name: "non_decidibili",
      )
      content("non_decidibili", [Non decidibili])

      // Invisible layout anchor element
      circle("superset", radius: 2.7, stroke: rgb(255, 0, 255, 0), name: "center_anchor")

      content("center_anchor.north-west", [#big_dot X], anchor: "south-east")
      content("center_anchor.north-east", [#big_dot Pari], anchor: "north-west")
      content("center_anchor.south-east", [#big_dot Primes], anchor: "south")
    })
  },
  caption: [Rappresentazione dei problemi decidibili e non decidibili],
)

/ Semidecidibili: esistono anche dei problemi semidecidibili, ovvero esistono degli algoritmi in grado di enumerare gli elementi dell'insieme, ma non esiste un algoritmo che è in grado di decidere un dato elemento.
  #informalmente[
    Questo è possibile perchè non è garantito che l'algoritmo *termini* sempre. Dato un input, l'algoritmo è garantito che termini solo per le risposte "vero", mentre non è in grado di determinare una risposta "falso" in tempo finito. Di conseguenza è possibile enumerare gli elementi veri, ma non è possibile sempre riconoscere un dato elemento.
  ]
  #teorema("Teorema di Rice")[
    Non si può decidere programmaticamente se un programma termina.
  ] <teorema-rice>

Tutti i problemi del corso, saranno decidibili.

== Complessità <complessita>

Sia $Pi$ un problema decidibile, possiamo chiederci quante risorse servono per risolverlo, ovvero la sua *complessità*.

Il concetto di risorsa tuttavia può essere vario (tempo, numero di istruzioni, spazio, ...). Formalmente, possiamo definire la *complessità* come:
- Dato un problema $Pi$
- Dato un algoritmo $A$ che risolve $Pi$ (assumendo che $A$ sia corretto)
- La risorsa che ci interessa è il tempo $T$ richiesto dall'algoritmo $A$ per l'input $x$:
$ forall x in I_Pi, quad T_(A)(x) $

=== Assunzione Worst-Case <assunzione-worst-case>

Considerare $T_(A)(x)$ è scomodo in quanto questa funzione dipende fortemente dalla dimensione dell'input specifico $x$. Conviene aggregare gli input in base alla loro *dimensione*, definendo $t_A$ come il tempo massimo impiegato da $A$ per input $x$ di dimensione $n$:
$ t_A : bb(N) -> bb(N), quad t_(A)(n) = max_(x in I_Pi, |x| = n) T_(A)(x) $

Tuttavia, essendo un assunzione abbiamo una *perdita di informazione*. All'interno della classe di input con dimensione $n$ potrebbero esserci alcuni input più "sfortunati" su cui $A$ impiega più tempo.

#esempio[
  // TODO: sostituire con grafico (y = tempo, x = taglia input) con un picco solo nel mezzo
  Dimensione input $n = 1500$.\
  Singoli input $x = 1.000.000, y = 100, z = 103, w = 89$ passi.
  $ t_(A)(n) = 1.000.000 $
  #informalmente[
    C'è solo un input "sfortunato", tutti gli altri funzionano "bene", magari l'input $x$ è anche molto raro, quindi l'algoritmo tende a funziona molto molto meglio che $1.000.000$.
  ]
]

=== Assunzione Avg-Case <assunzione-avg-case>

Un'altra possibilità è calcolare la media delle risorse impiegate per una certa taglia di input. Molto raramente è possibile fare il calcolo empirico, quindi è necessario fare uno studio, detto *Average Case Analysis*. Problemi di questa assunzione:
- lo studio del caso medio è molto difficile, spesso impossibile
- assunzione che tutti gli input siano *equiprobabili*

#attenzione[
  Quasi sempre viene utilizzata l'assunzione worst-case, anche se esistono esempi che sfruttano il caso medio.
  #esempio[
    Il quicksort ha complessità nel caso peggiore $O(n^2)$, mentre algoritmi come il mergesort o l'heapsort $O(n log n)$, ma nella pratica il quicksort è il più veloce, dato che nel caso medio performa molto meglio.
  ]
  #esempio[
    Sono stati trovati algoritmi polinomiali per risolvere i sistemi di equazioni dell'algoritmo del simplesso. Nonostante ciò si continuano ad usare gli algoritmi esponenziali, che però sono effettivamente esponenziali solo in rari casi.
  ]
]

Da qui in avanti useremo l'assunzione Worst-Case.

=== Assunzione asintotica <assunzione-asintotica>

La funzione $t$ si può comportare in maniera molto diversa per algoritmi diversi, come possiamo valutare quale algoritmo è "migliore"? Si utilizza *l'assunzione asintotica*, ovvero si valuta il tempo impiegato dall'algoritmo considerando *input di taglia infinita*. L'algoritmo migliore sarà quello che tende ad infinito meno rapidamente.

#nota[
  Si tratta comunque di un assunzione, in quanto un algoritmo si potrebbe comportare meglio su input di taglia ridotta rispetto al migliore asintoticamente.
]

#informalmente[
  La funzione $t$ può comportarsi in maniera molto diversa per algoritmi che risolvono lo stesso problema.

  Per input piccoli un algoritmo può essere molto migliore per poi peggiorare al crescere di $n$ ma tornare migliore con $n$ molto grandi.
  // TODO: disegnino funzioni che si intrecciano
]

== Complessità Strutturale e Algoritmica <complessita-strutturale-algoritmica>

Possiamo dividere la definizione di complessità in due categorie:

/ Algoritmica: "Quanto è complesso questo algoritmo $A$ che risolve $Pi$?"\
  Fissato un algoritmo $A$ che risolve un certo problema $Pi$, viene studiata la complessità dell'algoritmo utilizzando l'assunzione asintotica. Non si hanno informazioni sulla complessità del problema, dato che l'algoritmo non è detto sia il migliore.
/ Strutturale: "Quanto è complesso l'algoritmo meno complesso che risolve $Pi$?"\
  Stabilisce quanto costa, al minimo, risolvere un certo problema $Pi$. Al posto di classificare l'algoritmo, viene classificato direttamente il problema, dividendoli in classi di complessità.

#informalmente[
  / Algoritmica: viene studiata la complessità di un algoritmo esistente. Si cerca di trovare algoritmi più veloci, *abbassando* la complessità algoritmica.
  / Strutturale: non si immagina nemmeno un algoritmo che risolve il problema, ci si basa solamente sulla struttura del problema. Viene determinato, "a prescindere" dalle tecniche algoritmiche usate, quanto tempo si impiega a risolverlo. Si prova a dimostrare che serve almeno $x$ tempo, cercando di *alzare* questo bound, per avvicinarsi all'algoritmo migliore noto.
]

Questi due bound non coincidono _quasi_ mai, lasciando incertezza su quale sia la reale complessità di un certo problema. Lo scopo è *ridurre il gap* tra l'upper bound (abbassandolo) e il lower bound (alzandolo), in modo tale che la complessità per risolvere un problema $Pi$ sia data dalla complessità dell'algoritmo ottimo per $Pi$.

#esempio[
  Problema ordinamento di un array basato su confronti:

  - inizialmente il miglior algoritmo noto è il bubble sort, quindi upper bound $mb(O(n^2))$
    $ mb(O(n^2)) >= "ottimo" >= mr("lower") $
  - si può fare di meglio o è impossibile ordinare in meno di $O(n^2)$?
  - viene dimostrato che è impossibile ordinare in meno di $n$, dato che almeno una volta tutti gli elementi vanno guardati, quindi lower bound $mr(Omega(n))$
    $ mb(O(n^2)) >= "ottimo" >= mr(Omega(n)) $
  - viene poi scoperto il merge sort, abbassando l'upper bound a $mb(O(n log n))$
    $ mb(O(n log n)) >= "ottimo" >= mr(Omega(n)) $
  - si può fare di meglio o è impossibile ordinare in meno di $O(n log n)$?
  - viene dimostrato che è impossibile ordinare (basandosi su confronti) facendo meno di $n log n$ confronti (nel caso peggiore), portando il lower bound a $mr(Omega(n log n))$ _(dimostrazione del limite inferiore del decision tree)_
    $ mb(O(n log n)) = "ottimo" = mr(Omega(n log n)) $
  - problema dell'ordinamento "risolto", è impossibile fare meglio dato che la forbice si è chiusa.
]

#nota[
  Sono rarissimi i problemi in cui abbiamo chiuso la forbice, spesso perchè dimostrare un limite inferiore è molto complesso. Di questi problemi non conosciamo la "vera" complessità.
]
