#import "../imports.typ": *

= Strutture dati

La nozione di "struttura dati" può essere divisa in due concetti: 
- *ADT (abstract data type)* = Astrazione del tipo di dato, specifica le primitive per accedere alla struttura dati 
- *Implementazione* = Implementazione di una struttura dati

== ADT (abstract data type)
  #esempio[
    Supponiamo di voler andare a definire una struttura stack per un tipo di dati $<T>$.
    ```java
    Stack<T>
    void push(T x)
    T pop() throws NoSuchElementException
    T top() throws NoSuchElementException
    boolean isEmpty()
    ```
    Tuttavia, in Java non è possibile definire i costruttori nell'interfaccia. In altri linguaggi, gli ADT possono essere descritti con ulteriori vincoli.\
    Ad esempio, si possono specificare degli assiomi che ne descrivono il comportamento (vincoli) $forall alpha in T$:
    ```java
    Stack<T> s;
    ...
    s.push(alpha);
    assert s.top() == alpha;
    assert s.pop() == alpha;
    ```
    *Vantaggi*:
    - qualunque implementazione è sicuramente corretta. Gli assiomi funzionano da test
    - possibilità di generare il codice relativo all'implementazione a partire dagli assiomi (ovviamente devono essere completi)
  ]

== Implementazione

Un dato ADT si può implementare in modi diversi, ognuno con diversi *tradeoff* (sia temporali che spaziali)
  #esempio[
    In Java non si documentano i metodi di un'implementazione (dato che si ereditano dall'interfaccia), ma è importante aggiungere commenti sull'efficienza di questa implementazione (e.g. arraylist vs linkedlist)
  ]

#attenzione[
  Quando si parla di struttura dati, si dovrebbe parlare solo di ADT, non dell'implementazione.
  Noi cercheremo di tenere separati i due concetti.
]

== Spazio occupato da un'implementazione: Information-Theoretical Lower Bound

Chiamiamo con $n$ la "taglia" di un ADT, ovvero il numero di elementi della struttura. *Per ogni taglia $n$*, L'ADT avrà un certo numero di *valori possibili $v_n$*. 

#esempio[
  Stack di $v_0$ contiene un solo elemento, lo stack vuoto.

  Le altre taglie dipendono dal tipo di dato associato al generico $T$, ad esmepio in uno stack di booleani, $v_1 = 2$, $v_5 = 2^5$
]

Vogliamo andare a stimare *quanti bit* servono per rappresentare uno di quei valori. 
Nel caso dello stack, esso può avere vari stati possibili con una taglia $n$: 
 - ${V_1, ... V_v_n}$
- ${b_1, ..., b_v_n}$, ogni stato utilizza $b_i$ bit

=== Teorema di Shannon

#teorema("Teorema")[
  Il teorema di Shannon fornisce un *lower bound* al numero medio di bit per rappresentare una struttura di taglia $n$ con $v_n$ valori possibili:
  $ 
  (sum_(i = 1)^(v_n) b_i) / (v_n) >= log_2(sqrt(n)) = mr(Z_n) 
  $

  #esempio[
     Sia $n = 3$ la taglia della struttura dati:
      - numero di stati possibili è $V_(v_n) = 9$ 
      - i possibili valori sono $v_3 = 9$. Chiamiamo con $0, 1, ..., 8$ i possibili valori di $v_n$.\
    Se per ognuno di questi valori utilizzassimo $b = 2$ bit per rappresentarli, potremo avere al massimo $2^2$ stati, altrimenti, per principio della piccionaia due stati avrebbero la stessa rappresentazione, impossibile.

    Per rappresentare $9$ valori diversi, allora servono almeno $4$ bit per rappresentare ogni elemento. In totale $2^4$ bit.
  ]

  #attenzione[
    Il teorema funziona anche per strutture dati di *dimensione variabile*. Dato che la media dei bit necessari per ogni elemento deve essere superiore al logaritmo, se riusiamo a risparmiare su alcuni valori, allora dovremmo per forza pagare di più su altri valori.

    #esempio[
      È impossibile creare una struttura dati in grado di comprimere qualsiasi valore possibile nello spazio. Esistono solo algoritmi che comprimono bene *qualcosa*, non tutto.
      
      In un algoritmo di compressione per le immagini, ad esempio, qualche immagine viene compressa bene, ma il risparmio guadagnato dalla compressione ottima su determinate istanze, si perde con immagini su cui l'algoritmo non lavora bene.
    ]
  ]

  #nota[
    Per ogni tipologia di struttura dati esiste la rispettiva versione super compressa $log_2(sqrt(n))$ *ottima* in termini di spazio. Tuttavia non è detto che sia la versione più efficiente (parametro che terremo in considerazione). 
  ]
]

== Strutture compresse

Una *implementazione* di un ADT che occupa $D_n$ bit, si dice *compressa sse*: 
$ 
  D_n >= Z_n 
$ 

In particolare, l'implementazione si dice:
- *implicita* $=> D_n = Z_n + O(1)$. Ovvero una costante oltre il lower bound teorico

- *succinta* $=> D_n = Z_n + o(Z_n)$. Ovvero i bit di spazio extra devono crescere più lentamente di $Z_n$

- *compatta* $=> D_n = O(Z_n)$. Cresce quanto $Z_n$

#attenzione()[
  é molto facile creare delle strutture compatte andando a diminuire i tempi di accesso, tuttavia vogliamo che la velocità di accesso sia paragonabile a una implementazione NAIF.
]

#nota[
  Le implementazioni naive ("normali/comuni", quelle che ci sono in giro) delle strutture dati non rientrano in nessuna di queste categorie, occupano molto spazio (di solito non interessa).
]

Esistono due tipi di strutture dati:
- *strutture statiche* = dopo la costruzione vengono utilizzate solamente in lettura (non possono essere modificate)
- *strutture dinamiche* = possono essere modificate anche dopo la costruzione. Spesso sono trattate in maniera completamente diversa da quelle statiche.

Le strutture compresse vengono principalmente utilizzate quando la mole di valori da contenere è molto grande (come l'intero genoma umano, l'intero grafo di amicizie di facebook). Le implementazione NAIF non starebbero nemmeno in memoria (spesso neanche sul disco), diventando super inefficienti.

Un'ulteriore obbiettivo delle strutture compresse è quello di sfruttare al meglio la cache. 

#attenzione[
  Strutture dati succinte e Metodi di compressione dei dati (zip, tar, codifiche audio/video) sono tecniche *molto diverse*:
  - Molte codifiche per audio/video sono *lossy* (ovvero possono perdere informazione), quindi possono non rispettare il teorema di Shannon.

  - Per le codifiche *lossless* (tipo tar, zip) la differenza è che le strutture dati compresse vengono usata così come sono. Le compressioni prima di essere usate hanno bisogno di uno step aggiuntivo, la decompressione.
  Per le strutture dati il concetto di decompressione non eiste.
]


