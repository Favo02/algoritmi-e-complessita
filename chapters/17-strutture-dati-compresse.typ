#import "../imports.typ": *

= Strutture dati

La nozione di "struttura dati" può essere divisa in due concetti:
- *ADT (abstract data type)*: astrazione del tipo di dato, specifica i valori esprimibili e le primitive per accedere alla struttura dati
- *Implementazione*: implementazione di un ADT

#attenzione[
  Quando si parla di struttura dati, si dovrebbe parlare solo di ADT, non dell'implementazione.
  Noi cercheremo di tenere separati i due concetti.
]

== ADT (abstract data type)

Specificazione astratta di un tipo di dati, in termini di comportamento esterno:
- valori possibili dei dati
- primitive per accedere e modellare i dati
- vincoli (assiomi) che valgono sempre: se sono completi (e lo strumento lo permette), è possibile generare un'implementazione a partire da questi assiomi.

#attenzione[
  Non viene in alcun modo specificato come viene implementata la struttura dati.
]

#esempio[
  Supponiamo di voler definire una struttura stack per un tipo di dati `T`.

  ```java
  Stack<T>
  void push(T x)
  T pop() throws NoSuchElementException
  T top() throws NoSuchElementException
  boolean isEmpty()
  ```

  #nota[
    La maggior parte dei linguaggi non sono propriamente indicati per esprimere degli ADT, dato che _"strizzano l'occhio all'implementazione"_ e/o non permettono di esprimere particolari vincoli.

    Ad esempio, in Java, non è possibile definire costruttori nelle interfacce.
    In altri linguaggi, gli ADT, possono essere descritti con ulteriori vincoli.
  ]

  Supponendo di essere in un linguaggio Java esteso, si possono specificare gli assiomi che ne descrivono il comportamento (vincoli) $forall alpha in T$ (che fungono da test delle implementazioni):
  ```java
  Stack<T> s;
  s.push(alpha);
  assert s.top() == alpha;
  assert s.pop() == alpha;
  ```
]

== Implementazione

Un dato ADT si può implementare in modi diversi, ognuno con diversi *tradeoff* (in termini di tempo, di spazio, di semplicità).

#esempio[
  In Java, l'ADT lista (interfaccia `List`) è implementato da diverse classi con diverse performance:
  - `LinkedList`: accesso random $O(n)$, append $O(1)$
  - `ArrayList`: accesso random $O(1)$, append $O(1) "ammortizzato"$

  #nota[
    Per questo motivo, non si documentano i metodi di un'implementazione (dato che si ereditano dall'interfaccia), ma è importante aggiungere commenti sull'efficienza di questa implementazione.
  ]
]

== Spazio occupato da un'implementazione: Information-Theoretical Lower Bound

Chiamiamo con $n$ la *taglia* di un ADT, ovvero il numero di elementi della struttura.
Per ogni taglia $n$, L'ADT avrà un certo numero di *valori possibili* $v_n$ di quella taglia.

#esempio[
  Stack di taglia $0$ contiene un solo elemento, lo stack vuoto, quindi $v_0 = 1$.

  Le altre taglie dipendono dal tipo di dato associato al generico $T$, ad esempio in uno stack di booleani, $v_1 = 2$, $v_5 = 2^5$.
]

Vogliamo misurare *quanti bit* servono per rappresentare uno dei valori di taglia $n$.
Indichiamo con $b_i$ il numero di bit occupati da un valore $V_i$.
- ${V_1, ..., V_v_n}$: valori di taglia $n$
- ${b_1, ..., b_v_n}$: bit utilizzati da ogni valore

=== Teorema di Shannon

#teorema("Teorema")[
  Il teorema di Shannon fornisce un *lower bound* al numero medio di bit per rappresentare una struttura di taglia $n$ con $v_n$ valori possibili:
  $ Z_n quad = quad (limits(sum)_(i = 1)^(v_n) b_i) / (v_n) >= log_2(v_n) $

  #informalmente[
    Per poter rappresentare tutti i valori distinti, ciascun valore deve avere una codifica unica.
    Se due valori condividessero la stessa rappresentazione, risulterebbero indistinguibili.
  ]

  #esempio[
    Sia $n = 3$ la taglia della struttura dati:
    - numero di stati possibili è $v_3 = 9$
    Se per ognuno di questi valori utilizzassimo $b = 2$ bit per rappresentarli, potremmo avere al massimo $2^2 = 4$ stati distinti. Altrimenti, per il principio della piccionaia, due stati avrebbero la stessa rappresentazione.

    Per rappresentare $9$ valori diversi, servono almeno $log_2(9) approx 3.17$, quindi almeno $4$ bit per ogni elemento.
  ]

  #attenzione[
    Il teorema funziona anche per strutture dati di *dimensione variabile*.
    Questo significa che se la media dei bit necessari per ogni elemento deve essere superiore al logaritmo, allora se riusciamo a risparmiare su alcuni valori, dovremmo per forza pagare di più su altri valori.

    #esempio[
      È impossibile creare una struttura dati in grado di comprimere in maniera ottima qualsiasi valore dell'universo dei valori.
      Esistono solo algoritmi che comprimono bene *qualcosa*, non tutto.

      In un algoritmo di compressione per le immagini, ad esempio, qualche immagine viene compressa bene, ma il risparmio guadagnato dalla compressione ottima su determinate istanze, si perde con immagini su cui l'algoritmo non lavora bene.
    ]
  ]

  #nota[
    Per ogni tipologia di struttura dati esiste la rispettiva versione compressa che occupa $log_2(v_n)$ bit, *ottima* in termini di spazio.
    Tuttavia non è detto che questa versione sia abbastanza *efficiente* dal punto di vista computazionale per essere utilizzabile in pratica.
  ]
]

== Strutture compresse

Una *implementazione* di un ADT che occupa $D_n$ bit, si dice *compressa* se e solo se $D_n$ è vicino al lower bound teorico $Z_n$.

In particolare, l'implementazione si dice:
- *implicita* se $D_n = Z_n + O(1)$: occupa solo una costante di bit oltre il lower bound teorico
- *succinta* se $D_n = Z_n + o(Z_n)$: lo spazio extra cresce più lentamente di $Z_n$
- *compatta* se $D_n = O(Z_n)$: cresce proporzionalmente al bound teorico $Z_n$

Pur rimanendo *efficiente* quanto l'implementazione naive in termini di tempo di accesso.

#attenzione[
  È semplice ottenere implementazioni molto compatte a scapito dei tempi di accesso.
  Per questo motivo imponiamo che le prestazioni di accesso rimangano confrontabili con quelle di un'implementazione naive.
]

#nota[
  Le implementazioni naive (o "standard") solitamente non rientrano in queste classificazioni: occupano molto spazio (dato che nei PC moderni la memoria raramente è un problema).
]

Esistono due tipi di strutture dati:
- *strutture statiche*: dopo la costruzione vengono utilizzate solamente in lettura (non possono essere modificate)
- *strutture dinamiche*: possono essere modificate anche dopo la costruzione, sono spesso trattate in maniera completamente diversa da quelle statiche.

Le strutture compresse vengono principalmente utilizzate quando la mole di valori da contenere è molto grande (ad esempio l'intero genoma umano o l'intero grafo di amicizie di Facebook).
Le implementazioni naive non starebbero nemmeno in memoria (spesso neanche sul disco), diventando impraticabili.

Un ulteriore obiettivo delle strutture compresse è quello di sfruttare al meglio la cache, dato che occupando meno spazio è possibile cachare più cose.

#attenzione[
  _Strutture dati compresse_ e _Metodi di compressione dei dati_ (zip, tar, codifiche audio/video) sono tecniche *molto diverse*:
  - Molte codifiche per audio/video sono *lossy* (ovvero possono perdere informazione), quindi possono non rispettare il teorema di Shannon.

  - Per le codifiche *lossless* (tipo tar, zip) la differenza è che le strutture dati compresse vengono usate direttamente così come sono.
    I dati compressi, invece, richiedono uno step aggiuntivo di decompressione prima di poter essere utilizzati.

  Per le strutture dati il concetto di decompressione non esiste, sono sempre in uno "stato utilizzabile".
]
