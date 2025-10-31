#import "../imports.typ": *

= Strutture dati

/ Abstract Data Type (ADT): astrazione del tipo di dato, specifica le primitive per accedere alla strutture dati
  #esempio[
    Le interfacce di Java.
    In Java sono molto povere, si può definire solo la segnatura.

    ```java
    Stack<T>
    void push(T x)
    T pop() throws NoSuchElementException
    T top() throws NoSuchElementException
    boolean isEmpty()
    ```

    In Java non si possono nemmeno definire i costruttori.


    In altri linguaggi, gli ADT possono essere descritti con ulteriori vincoli.

    Ad esempio, si possono specificare degli assiomi che ne descrivono il comportamento $forall alpha in T$:
    ```java
    Stack<T> s;
    ...
    s.push(alpha);
    assert s.top() == alpha;
    assert s.pop() == alpha;
    ```

    Vantaggi:
    - qualunque implementazione è sicuramente corretta, dato che gli assiomi funzionano da test
    - all'estremo, non serve nemmeno un'implementazione, è possibile generarla dagli assiomi
  ]

/ Implementazioni dell'ADT: lo stesso ADT si può implementare in modi diversi, ognuno con diversi tradeoff (sia temporali che spaziali)
  #esempio[
    In Java non si documentano i metodi di un'implementazione (dato che si ereditano dall'interfaccia), ma è importante aggiungere commenti sull'efficienza di questa implementazione (e.g. arraylist vs linkedlist)
  ]

#attenzione[
  Quando si parla di Struttura dati, si dovrebbe parlare solo di ADT, non dell'implementazione.
  Noi cercheremo di tenere separati i due concetti.
]

== Spazio occupato da un'implementazione: Information-Theoretical Lower Bound

Per ogni taglia $n$ (ovvero quanti elementi contiene), l'ADT ha un certo numero di valori possibili $v_n$

#esempio[
  Stack di $v_0$ contiene un solo elemnto, lo stack vuoto.

  Le altre taglie dipendono dal tipo di dato generico soggiacente $T$, ad esmepio in uno stack di booleani, $v_1 = 2$, $v_5 = 2^5$
]

Quanti elementi servono per rappresentare uno di quei valori?

Lo stack può avere vari stati possibili quando è di taglia $n$: $V_1, ... V_v_n$, ognuno di questi utilizza $b_1, ..., b_v_n$ bit.

#teorema("Teorema")[
  Teorema di Shannon:

  $ (sum_(i = 1)^(v_n) b_i) / (v_n) >= underbrace(log_2(sqrt(n)), Z_n) $

  #esempio[
    La struttura dati quando consideriamo valori di taglia $3$, ha $9$ stati possibili, quindi $v_3 = 9$.

    Questi valori di taglia $n$ li chiamiamo $0, 1, ..., 8$.

    Ma se ognuno di questi stati utilizza $b = 2$ bit, allora potremo al masasimo avere $2^2$ diversi stati, altrimenti per principio dei cassetti (della piccionaia) due stati hanno la stessa rappresentazione, impossibile.

    Quindi per rappresentare $9$ diversi valori, allora servono almeno $2^4$ bit.
  ]

  #attenzione[
    Questa cosa funzione anche per le dimensioni variabili, dato che la media deve essere superiore al logaritmo, se riusiamo a risparmiare su alcuni valori, allora dovremo per forza pagare di più su altri valori.

    #esempio[
      È impossibile inventare qualcosa che comprima e basta, esistono solo algoritmi che comprimono bene *qualcosa*, non tutto.
      Qualche immagine viene compressa bene, ma quel risparmio si va a pagare su determinate immagini che pagheremo di più, è impossibile andare sotto al teorema di shannon.
    ]
  ]

  #nota[
    Questa struttura dati super compressa $log_2(sqrt(n))$ ottina, esiste, ma non è detto quanto sia efficiente, magari è terribilmente inefficiente.
    Quindi è solo un lower bound, ma noi vogliamo anche l'efficienza.
  ]
]

Gli indici sono delle strutture che ci costruiamo per poter rispondere in maniera efficiente a delle query.

== Strutture compresse

Un'implementazione di un ADT occupa $D_n$ bit e necessariamente $D_n >= Z_n$

L'implementazione:
- implicita se $D_n = Z_n + O(1)$, ovvero una costante oltre il lower bound teorico
- succinta se $D_n = Z_n + o(Z_n)$, ovvero i bit extra devono crescere più lentamente di $Z_n$
- compatta se $D_n = O(Z_n)$ cresce quanto $Z_n$
a patto che la velocità di accesso sia paragonabile a una implementazione naive.

#nota[
  Le implementazioni naive ("normali/comuni", quelle che ci sono in giro) delle strutture dati non rientrano in nessuna di queste categorie, occupano molto spazio (di solito non interessa).
]

#nota[
  È molto facile implementare strutture succinte/compatte semplicemente sacrificando i tempi di accesso.
]

A cosa servono queste strutture?

Quando iniziamo a rappresentare cose molto molto grosse (come l'intero genoma umano, l'intero grafo di amicizie di facebook) e non ci stanno in memoria (spesso nemmeno sul disco) e quindi diventa super inefficiente (anche con cache).

Queste strutture efficienti sono fatte bottom-up, quindi partendo da qualcosa di semplice si vanno a costruire cose complesse

#attenzione[
  Strutture dati succinte e Metodi di compressione dei dati (zip, tar, codifiche audio/video) sono cose molto diverse.
  Prima di tutto molte codifiche per audio/video sono lossy (ovvero possono perdere informazione), quindi possono non rispettare il teorema di Shannon.

  Mentre per quelle lossless (tipo tar, zip) la chiara differenza è che la struttura dati viene usata così, mentre le compressioni prima di essere usati devono essere decompressi.
  Per le strutture dati, non esiste questo concetto di decompressione.
]

Esistono due tipi di strutture:
- strutture statiche: vengono costruite e poi si usano solo in lettura (non possono essere modificate)
- strutture dinamiche: possono essere modificate (e spesso sono trattate in maniera completamnete diverse da quelle statiche)
