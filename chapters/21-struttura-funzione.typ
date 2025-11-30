#import "../imports.typ": *

= Struttura Funzione Statica (Dizionario, Mappa, Array associativo)

== Funzione di Hash

Una funzione di Hash è una funzione $h$ che mappa un elemento di un universo in un bucket:
$ h : underbrace(U, "universo") -> underbrace(m, "bucket") $

Proprietà di una funzione hash:
+ $h$ deve essere *facile da calcolare* (massimo in tempo $O(log(U))$, meglio se in $O(1)$)
+ la funzione occupi poco spazio
+ sia il più *iniettiva* possibile (spesso $|U| >> m$, quindi è impossibile che sia al $100%$ iniettiva).
  Sarebbe auspicabile che tutti i *bucket* abbiano più o meno la *stessa cardinalità*, quindi che ci siano *poche collisioni*

Nella maggior parte dei casi, non ci interessa che la funzione di hash $h$ si comporti bene su tutto l'universo $U$, ma solamente su un piccolo sottoinsieme $S$ (più piccolo del numero di bucket):
$
  S subset.eq U, quad |S| << |U|, quad |S| = n, quad n <= m
$
Vogliamo dunque che gli elementi di $S$ cadano in bucket distinti.
Questa proprietà non è esplicitata dato che $S$ *non* è *noto* a priori.

#esempio[
  Sia $h$ una funzione di hash che funziona perfettamente su tutti gli interi $in [0, 1000]$.
  La funzione divide il numero per $100$ e lo inserisce nel bucket corrispondente.

  Tuttavia nella pratica, vorremo hashare solamente i numeri da $0$ a $100$.
  La funzione $h$ li metterebbe tutti nello stesso bucket, funzionando malissimo.
]

=== Full-Randomness Assumption (SUHA)

Chiamata anche Simple Uniform Hashing Assumption (SUHA).

#teorema("Definizione")[
  Dati $U$ e $m$, si sceglie la funzione hash: $h : U -> m$ *uniformemente a caso*, ovvero che valgano:
  + *uniformità*: qualsiasi chiave $k$ ha la stessa probabilità di essere mappata in uno qualsiasi degli $m$ bucket
  + *indipendenza*: una mappatura è indipendente dalle mappature delle altre chiavi

  #attenzione[
    Si tratta di un'*assunzione impraticabile*.
    Tutte le funzioni di hash sono deterministiche, quindi bisognerebbe scegliere una funzione di hash diversa a caso ogni volta.

    Supponendo che ogni funzione di hash sia enumerabile, rimane il problema di come implementarle tutte.

    Una funzione di hash realmente casuale sarebbe un'enorme tabella di lookup, lo spazio occupato sarebbe esponenziale: $|U| log m$.
    Inoltre, la funzione di hash sarebbe anche lenta, dato che bisogna scorrere tutta la tabella linearmente per trovare l'elemento desiderato.
  ]
]

Nella pratica, vengono studiate alcune strutture assumendo la Full-Randomness Assumption.
I risultati ottenuti sotto l'assunzione vengono rilassati, misurandone il tasso di peggioramento.

#esempio[
  Supponiamo di voler hashare dei nomi di massimo $18$ caratteri e di avere a disposizione $14$ bucket:
  $ U = {a, b, ..., z}^(<=18), quad m = 14 $
  Solamente riempire la tabella che mappa ogni entry al suo bucket è impossibile, dato che ci sono $|U| = 26^18$ entry possibili.

  Per risparmiare spazio, non viene tenuta in memoria l'intera tabella, ma un *array di pesi* $w_1, w_2, ..., w_18$.
  Quando dobbiamo hashare un nome, ogni lettera del nome viene moltiplicata per il peso associato alla sua posizione.
  La funzione di hash diventa:
  $
    h("Claudio Bisio") = (sum_(i=1)^n w_i dot c_i) mod m
  $
  dove $c_i$ è il valore numerico della $i$-esima lettera e $n$ è la lunghezza del nome.

  L'*insieme di funzioni* implementabili è *molto ridotto*: solamente le funzioni ottenibili come combinazione lineare dei pesi.
  Questo viola la Full-Randomness Assumption, ma permette di memorizzare la funzione hash in spazio $O(18)$ invece di $O(26^18)$.
]

== ADT

#informalmente[
  La struttura dati che vogliamo rappresentare è un insieme di chiavi valori, dove le chiavi memorizzate sono $S$ (in un certo istante non avremo tutto l'universo $U$ memorizzato).
  Dato che la funzione è *statica*, la cardinalità di $S$ non cambia mai.
  Ogni chiave associa un valore rappresentabile con $r$ bit.
]

L'obiettivo è costruire una funzione $f$ che associa ad una chiave $s in S$, un valore rappresentabile con $r$ bit:
$ f : S -> underbrace(2^r, "valori rappresentabili"\ "con" r "bit") $
con $S subset.eq U$.
La struttura è *statica*, non possono essere modificate chiavi e valori.

*Primitiva* di accesso: data una chiave, vogliamo ottenere il suo valore (non è possibile il contrario e non è possibile elencare tutti i valori)

== Struttura MWHC (Minimal Weight Hypergraph Construction) <mwhc>

Dati:
- $U$ = universo
- $S subset.eq U$ insieme di chiavi, dove $|S| = n$
- $f : S -> 2^r$, funzione che associa ad ogni chiave un valore
- $m in bb(N)$ numero di bucket
- $h_0,h_1: U -> m$ due funzioni hash random

Andiamo a costruire un *grafo* dove:
- *nodi*: $m$ nodi da $0,dots,m-1$
- *archi*: per ogni elemento $s in S$ creo un lato tra $(h_0(s),h_1(s))$, quindi |S| archi

Durante la costruzione del grafo devono *valere* le seguenti proprietà:
+ $h_0(x) != h_1(x)$, altrimenti collegherei un vertice $x in S$ a se stesso, creando un loop
+ $forall x,y in S, x != y quad {h_0(x),h_1(x)} != {h_0(y),h_1(y)}$ chiavi diverse danno origine a lati diversi
+ aciclicità

Se una di queste proprietà smette di valere, *scarto* le due funzioni di hash e le riestraggo, ricominciando.

#nota[
  Il tempo necessario per la costruzione di $G$ dipende dal numero di *nodi* $m$.
  Più $m$ è grande meno tentativi saranno necessari per rispettare tutte le proprietà.
]

=== Grafo come Sistema di Equazioni Diofantee

È possibile vedere $G$ come un insieme di $n$ equazioni (numero chiavi) con $m$ incognite (numero bucket), dove ogni chiave corrisponde ad un *equazione* che eguaglia i *valori* delle due *funzioni di hash* (gli indici dei bucket) al *valore della funzione* da memorizzare:
$ x_(h_0("chiave")) + x_(h_1("chiave")) mod 2^r = "valore" $

Possiamo creare così un sistema di $n$ *equazioni diofantee* con $m$ incognite ($x_0,dots,x_(m-1)$):
$ forall s in S cases(x_(h_0(s)) + x_(h_1(s)) mod 2^r = f(s)) $

#nota[
  Un'equazione Diofantea è un'equazione in una o più incognite, i cui coefficienti sono numeri *interi*, e di cui si ricercano esclusivamente le soluzioni intere.
]

Se il grafo è *aciclico*, allora il sistema è *risolubile*.

La soluzione del sistema è un *array* $[x_0, ... x_(m-1)]$ di dimensione $m$ con valori compresi in ${0, dots, 2^r-1}$.
È sufficiente memorizzare *solo* questo array per calcolare il valore che corrisponde ad ogni chiave:
$ f(s) = (x_h_0(s) + x_h_1(s)) mod 2^r $

Questo vettore occupa $m log 2^r = m r$ bit.

#esempio[
  - bucket: $m = 4$ (indici $0,1,2,3$)
  - chiavi $S = {"mela", "pera", "kiwi"}$, $n = 3$
  - funzione da memorizzare:
    - $f("mela") = 10$
    - $f("pera") = 20$
    - $f("kiwi") = 5$
  - funzioni di hash $h_0, h_1$:
    - $h_0("mela") = 0, quad h_1("mela") = 1$
    - $h_0("pera") = 1, quad h_1("pera") = 2$
    - $h_0("kiwi") = 2, quad h_1("kiwi") = 3$

  Il grafo costruito:
  #figure(
    cetz.canvas({
      import cetz.draw: *

      let nodes = (
        (name: "0", pos: (0, 2), label: $0$),
        (name: "1", pos: (2, 2), label: $1$),
        (name: "2", pos: (4, 2), label: $2$),
        (name: "3", pos: (6, 2), label: $3$),
      )

      line((0, 2), (2, 2), stroke: blue + 1.2pt)
      content((1, 2.3), text(size: 10pt, [mela (10)]), fill: white, padding: 0.1)

      line((2, 2), (4, 2), stroke: red + 1.2pt)
      content((3, 2.3), text(size: 10pt, [pera (20)]), fill: white, padding: 0.1)

      line((4, 2), (6, 2), stroke: green.darken(20%) + 1.2pt)
      content((5, 2.3), text(size: 10pt, [kiwi (5)]), fill: white, padding: 0.1)

      for node in nodes {
        circle(node.pos, radius: 0.15, fill: white)
        content((node.pos.at(0), node.pos.at(1) + 0.5), node.label)
      }
    }),
  )

  Viene convertito nel sistema:
  $
    cases(
      x_0 + x_1 mod 100 = 10,
      x_1 + x_2 mod 100 = 20,
      x_2 + x_3 mod 100 = 5
    )
  $

  Che può essere risolto da $[10, 0, 20, -15]$, tutto quello che ci serve (oltre alle due funzioni di hash) per calcolare i valori della funzione da memorizzare:
  - $f("mela") = x[h_0("mela")] + x[h_1("mela")] quad = quad x[0] + x[1] = 10$
  - $f("pera") = x[h_0("pera")] + x[h_1("pera")] quad = quad x[1] + x[2] = 20$
  - $f("kiwi") = x[h_0("kiwi")] + x[h_1("kiwi")] quad = quad x[2] + x[3] = 5$
]

=== Parametro $m$

Una scelta fondamentale è il numero di bucket $m$.
È necessario effettuare un *tradeoff*:
- più $m$ è *piccolo* più la struttura è *succinta* (dato che il vettore occupa $m r$ bit)
- $m$ *tanto piccolo*, allora è *difficile* ottenere un grafo che rispetta le tre *proprietà* in tempi ragionevoli

#teorema("Teorema")[
  Se $m > 2.09n$ (dove $n = |S|$), il grafo $G$ è quasi sempre aciclico (il numero atteso di tentativi per ottenere un grafo $G$ aciclico è $2$).

  Il numero di bit per rappresentare una funzione di $n$ chiavi è
  $ 2.09 n r "bit" $
]

=== Generalizzazione su Dimensione $> 2$

Nella definizione precedente abbiamo scelto solamente due funzioni di hash random $h_0$ e $h_1$, quindi ogni lato connetteva due bucket, ottenendo un grafo di dimensione $2$ (un grafo "normale").

Se scegliessimo un numero $k > 2$ di *funzioni di hash* otterremmo un grafo di dimensione $k$, ovvero un *ipergrafo*, permettendoci di abbassare il parametro $m$ (quindi anche lo spazio occupato).

#nota[
  Un ipergrafo $H$ di dimensione $k$ è un grafo in cui un arco collega esattamente $k$ vertici (un grafo normale ha dimensione $k = 2$).

  Formalmente, $H(X,E)$ dove:
  - $X$: nodi
  - $E = {e subset.eq 2^X "t.c." |e| = k}$: *iperlati*, ogni iperlato $e in E$ è connesso a $k$ vertici

  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Definiamo i nodi (vertici)
      let nodes = (
        (name: "0", pos: (0, 0), label: $0$),
        (name: "1", pos: (2, 0), label: $1$),
        (name: "2", pos: (4, 0), label: $2$),
        (name: "3", pos: (1, 2), label: $3$),
        (name: "4", pos: (3, 2), label: $4$),
      )

      // Iperlato e₁ = {0, 1, 3} - linee blu
      bezier((0, 0), (2, 0), (0.5, 0.5), (1.5, 0.5), stroke: blue)
      bezier((2, 0), (1, 2), (1.7, 0.8), (1.3, 1.2), stroke: blue)
      bezier((1, 2), (0, 0), (0.8, 1.2), (0.2, 0.8), stroke: blue)
      content((1, 0.7), text(size: 11pt, $mb(e_1)$), fill: white, padding: 0.1)

      // Iperlato e₂ = {1, 2, 4} - linee rosse
      bezier((2, 0), (4, 0), (2.5, 0.5), (3.5, 0.5), stroke: red)
      bezier((4, 0), (3, 2), (3.7, 0.8), (3.3, 1.2), stroke: red)
      bezier((3, 2), (2, 0), (2.8, 1.2), (2.2, 0.8), stroke: red)
      content((3, 0.7), text(size: 11pt, $mr(e_2)$), fill: white, padding: 0.1)

      // Disegniamo i nodi
      for node in nodes {
        circle(node.pos, radius: 0.1, fill: black)
        content((node.pos.at(0) + 0.35, node.pos.at(1) + 0.2), node.label)
      }
    }),
    caption: [
      Esempio di ipergrafo con $k = 3$. $E = {{0, 1, 3}, {1, 2, 4}}$
    ],
  )
]

Con *$3$ funzioni* di hash otteniamo un ipergrafo con $k = 3$.
Devono continuare a valere le proprietà elencate precedentemente:
+ $h_0(x) != h_1(x) != h_2(x)$
+ $forall x,y,z in S, space x != y, space y != z quad {h_0(x),h_1(x),h_2(x)} != {h_0(y),h_1(y),h_2(y)}$
+ #strike[aciclicità] pelabilità

#attenzione[
  L'aciclicità *non* ha senso su un ipergrafo, non vuol dire niente.

  L'aciclicità era usata per garantire la *risolubilità* del sistema ottenuto dal grafo.
  Per garantire la risolubilità si può usare la *pelabilità*.
]

=== Pelabilità di un Ipergrafo (peeling)

Un ipergrafo si dice *pelabile* (o _peelable_ o con _empty core_) se esiste un *ordinamento* dei suoi iperlati tale che, per ogni iperlato, esiste un vertice non ancora comparso in *nessuno* degli iperlati precedenti.
Questo vertice viene chiamato *cardine* o *hinge*.
$
  exists quad underbrace((e_0, e_1, ..., e_(n-1)), "iperlati"), quad underbrace((x_0, x_1, ..., x_(n-1)), "cardini") quad "t.c." \
  forall i in {0, ..., n-1}: quad x_i in e_i space and space x_i in.not union.big_(j=0)^(i-1) e_j
$

Quando l'ipergrafo viene trasformato a sistema e viene trovato l'ordine di pelatura, esiste sempre una *variabile libera* (l'hinge) che ci permette di risolvere il sistema.

#esempio[
  #figure(
    grid(
      columns: 2,
      column-gutter: 2em,
      row-gutter: 1em,

      // Ipergrafo
      cetz.canvas({
        import cetz.draw: *

        // Definiamo i nodi (vertici)
        let nodes = (
          (name: "0", pos: (1.5, 0), label: $0$),
          (name: "1", pos: (3, 2.5), label: $1$),
          (name: "2", pos: (2, 3), label: $2$),
          (name: "3", pos: (4, 3.5), label: $3$),
          (name: "4", pos: (0.3, 2), label: $4$),
        )

        // Iperlato A = {0, 1, 2} - blu
        bezier((1.5, 0), (3, 2.5), (1.8, 2), stroke: blue + 1.2pt)
        bezier((3, 2.5), (2, 3), (2.4, 2.2), stroke: blue + 1.2pt)
        bezier((2, 3), (1.5, 0), (1.9, 2.0), stroke: blue + 1.2pt)
        content((2.1, 1.6), text(size: 11pt, $A$), fill: white, padding: 0.1)

        // Iperlato B = {1, 2, 3} - rosse
        bezier((3, 2.5), (2, 3), (2.7, 3), stroke: red + 1.2pt)
        bezier((2, 3), (4, 3.5), (2.7, 3), stroke: red + 1.2pt)
        bezier((4, 3.5), (3, 2.5), (3.5, 3.5), stroke: red + 1.2pt)
        content((3.1, 3.1), text(size: 11pt, $B$), fill: white, padding: 0.1)

        // Iperlato C = {0, 2, 4} - verdi
        bezier((1.5, 0), (0.3, 2), (1.5, 1.5), stroke: green.darken(20%) + 1.2pt)
        bezier((0.3, 2), (2, 3), (1.2, 2), stroke: green.darken(20%) + 1.2pt)
        bezier((2, 3), (1.5, 0), (1.3, 2), stroke: green.darken(20%) + 1.2pt)
        content((1.0, 1.8), text(size: 11pt, $C$), fill: white, padding: 0.1)

        // Disegniamo i nodi
        for node in nodes {
          circle(node.pos, radius: 0.1, fill: black)
          content((node.pos.at(0) + 0.35, node.pos.at(1) + 0.2), node.label)
        }
      }),

      // Tabella di pelatura
      align(horizon)[
        #table(
          columns: 2,
          align: center,
          [*Iperlato*], [*Cardine*],
          $A {0, 1, 2}$, $0$,
          $C {0, 2, 4}$, $4$,
          $B {1, 2, 3}$, $3$,
        )
      ],
    ),
    caption: [
      Esempio di ipergrafo pelabile con la sua sequenza di pelatura.
    ],
  )

  Scrivendo le equazioni di ogni iperlato e seguendo l'ordine di pelatura, otteniamo un sistema con $n$ equazioni e $m$ incognite:
  $
    cases(
      A & = mr(x_0) & + x_1 & + x_2 & + 0 & + 0 & = 25 quad mod 100,
      C & = x_0 & + 0 & + x_2 & + 0 & + mr(x_4) & = 37 quad mod 100,
      B & = 0 & + x_1 & + x_2 & + mr(x_3) & + 0 & = 12 quad mod 100
    )
  $
  Dove in rosso, sono marcati i #text(red)[cardini].
  Il cardine $i$-esimo indica la variabile libera che viene assegnata all'equazione $i$-esima.
  Risolvendo il sistema, partendo da $i=0$:
  - $x_0 = 25$ (dall'equazione $A$)
  - $x_4 = 37 - x_0 - x_2 = 37 - 25 - 0 = 12$ (dall'equazione $C$)
  - $x_3 = 12 - x_1 - x_2 = 12 - 0 - 0 = 12$ (dall'equazione $B$)

  Ottenendo la soluzione finale $[25, 0, 0, 12, 12]$.
]

#nota[
  Queste proprietà sono valide per ipergrafi di qualsiasi dimensione $k$ (dimensione intesa come grandezza di un iperlato, in questo caso $3$, non numero di nodi).
]

=== Dimensione $k$ ottima

Possiamo chiederci se sia vantaggioso usare un ipergrafo con dimensione $k > 2$, al posto di un grafo "standard" ($k = 2$).

#teorema("Teorema")[
  Per ogni $k >= 2$, esiste un $gamma_k$ tale che, per ogni $m >= gamma_k n$, la costruzione del $k$-ipergrafo è pelabile e rispetta le altre due proprietà quasi certamente.

  #informalmente[
    Per ogni dimensione $k$, esiste un bound di $m$ (numero di nodi del grafo, ovvero numero di bucket delle funzioni di hash) che ci garantisce di trovare un ipergrafo valido in pochi tentativi.
  ]
]

Nello specifico:
- $gamma_2 = 2.09$ (grafo normale)
- $gamma_3 = 1.23$ (ipergrafo)
- $gamma_(>= 4) > gamma_3$ (ipergrafi)

La *migliore* costruzione prevede di scegliere *$3$ funzioni di hash*.

#informalmente[
  Quando questa tecnica è stata introdotta, il numero minimo di funzione hash necessarie non era stato dimostrato, era solamente un risultato sperimentale (provando con vari ipergrafi di dimensioni diverse).

  Negli anni si è trovata una formula per $gamma_k$, dimostrando che il minimo è in $3$.
]

=== Spazio occupato

Per stabilire se la nostra rappresentazione sia succinta, dobbiamo andare a stimare il *theoretical lower bound* per una funzione statica:
$ f : S -> 2^r $

#dimostrazione[
  Dato l'insieme delle chiavi $S$ di cardinalità $n$, ci sono $(2^r)^n$ funzioni:
  $
    Z_n & = log (2^r)^n \
        & = log (2^(r n)) \
        & = r n
  $

  La struttura proposta (fissato $k=3$) utilizza:
  $ D_n = underbrace(gamma_3, m) n r = 1.23 n r $

  Si tratta di una *struttura compatta*, in quanto $D_n$ è un $O$ grande di $Z_n$.
]

=== Compressione dell'array

L'unica cosa che viene memorizzata dalla rappresentazione proposta è l'*array* soluzione del sistema, ovvero un array $x$ di $m r$ bit.

#nota[
  In realtà avremmo anche bisogno di memorizzare le due/tre funzioni di hash utilizzate.

  Nel calcolo dello spazio utilizzato viene trascurata la loro dimensione, supponiamo che le funzioni di hash occupino "poco spazio".
]

Per come risolviamo il sistema (tramite la pelatura), partiamo da un array inizializzato a $0$ e man mano assegniamo per ogni equazione una sola variabile (quella libera, il cardine).
Di conseguenza, nell'array ci sono *$<= n$ variabili $x_i != 0$* (una per ognuna delle $n$ equazioni).

Sfruttando questa osservazione, al posto di memorizzare tutto l'array $x$, potremmo memorizzare solo gli $<= n$ elementi *non nulli* e un array $underline(b)$ di $m$ bit con le loro *posizioni*.

Sull'array $underline(b)$ andremo ad usare una *rank/select*:
- se $underline(b)_i = 0$, allora $x_i = 0$
- se $underline(b)_i = 1$, usiamo rank e select per risalire al valore di $x_i$ nell'array di variabili non nulle

#dimostrazione[
  Spazio utilizzato:
  $
    underbrace(n r, "elementi non nulli") + underbrace(m, "array di bit") + underbrace(o(m), "rank/select su m") \
    = n r + gamma_3 n + o(gamma_3 n) \
    = n r + 1.23 n + o(n)
  $
]

#attenzione[
  La compressione *non* è sempre *conveniente*:
  - soluzione non compressa = $gamma_3 n r$
  - soluzione compressa = $n r + gamma_3 n + o(n)$

  Quando conviene?
  $
    n r + gamma n + cancel(o(n)) quad & < quad n gamma r \
                        n r + gamma n & < n gamma r \
                (n r + gamma n)/mb(n) & < (n gamma r)/mb(n) \
                            r + gamma & < gamma r \
                                gamma & < gamma r - r \
                                gamma & < r(gamma - 1) \
                                    r & > gamma/(gamma - 1) approx 1.23/0.23 approx 5.35
  $
  Conviene *comprimere* quando $r > 5$.
]

=== Uso della struttura

La struttura (compressa) contiene:
- le $3$ funzioni di hash
- $tilde(x)$ elementi non nulli
- $underline(b)$ vettore dove sono gli elementi non nulli
- rank/select su $underline(b)$

Funzionamento:
- viene passata una chiave di cui ottenere il valore
- vengono calcolate le funzioni di hash $h_0, h_1, h_2$
- vengono estratti i valori dall'array corrispondenti ai risultati delle funzioni di hash
  - per fare ciò viene sfruttata la rank/select per sapere se la variabile vale $0$
  - in caso non valga zero, si accede a $tilde(x)$
- viene calcolato il risultato:
  $ f(s) = (x_(h_0(s)) + x_(h_1(s)) + x_(h_2(s))) mod 2^r $

#attenzione[
  La struttura *non memorizza* l'insieme delle chiavi $S$.

  Di conseguenza, se alla struttura diamo in pasto un qualsiasi elemento $in U in.not S$, non può riconoscere che l'input non è "valido", ma viene comunque costruita una risposta (stile _undefined behaviour_).

  Per lo stesso motivo, non è possibile accedere all'insieme di tutti i valori.
]

== Hash Minimale Perfetto (MPH)

Siano $S subset.eq U$ e $m in bb(N)$ fissati.

Una funzione di hash $quad h : U -> m quad$ si dice:
+ *perfetta* per $S$ se è iniettiva sul sottoinsieme $S$ di $U$:
  $ forall x, y in S, quad x != y => h(x) != h(y) $
  Questo implica che il numero di bucket sia maggiore della cardinalità di $S$:
  $ |S| <= m $
+ *minimale perfetta* se e solo se $h$ è perfetta e $|S| = m$

#esempio[
  Un possibile utilizzo di un hash minimale perfetto è enumerare gli elementi di $S$.

  Basta mettere tutti gli elementi in un array e indicizzarlo con $h$.
]

=== Prima costruzione: OPMPH (Order Preserving MPH)

Un modo banale di costruire un MPH è quello di *fissare* la funzione $h$ e poi *rappresentarla* tramite #link(<mwhc>)[MWHC].

Per fissare la funzione $h$ si intende associare ad ogni chiave un valore compreso tra $0$ e $n-1$.
Dato che siamo noi a scegliere questi valori, scegliamo anche l'*ordine* delle chiavi, da qui il nome Order Preserving MPH.

Spazio utilizzato:
$ D_n = n underbrace(r, "fino a" 2^r) + gamma n + o(n) = n underbrace(log n, 2^log n = n) + gamma n + o(n) $

Esistono esattamente $n!$ modi di associare le chiavi ai valori, quindi il theoretical lower bound è:
$ Z_n = log n! approx n log n $

La struttura è *compatta*.

#attenzione[
  Abbiamo però risolto un problema molto più complesso, ovvero abbiamo voluto *decidere noi l'ordine* delle chiavi.
  Ma per essere minimale perfetto basta un *ordine qualsiasi*.

  Esistono diversi casi:
  - ordine *scelto*: Order Preserving Minimal Perfect Hash (OPMPH)
  - ordine *lessicografico*: Monotone Minimal Perfect Hash (MMPH)
  - ordine *qualsiasi*: Minimal Perfect Hash (MPH)

  $ Z_"MPH" < Z_"MMPH" < Z_"OPMPH" $
]

=== Seconda costruzione: variante di MWHC

Non ci interessa l'ordine delle chiavi, va bene uno qualsiasi.

Quando costruiamo MWHC, abbiamo un sistema di equazioni.
Ogni equazione eguaglia i risultati delle funzioni di hash al valore della funzione che stiamo codificando:
$ x_h_0(s) + x_h_1(s) + x_h_2(s) = underbrace(f(s), "valore") $

Possiamo decidere noi quel valore.
Dato che vogliamo una hash *iniettiva*, dobbiamo usare qualcosa che non appare mai più di una volta.
L'*hinge* $k$, per definizione, rispetta questa caratteristica.
$ x_h_0(s) + x_h_1(s) + x_h_2(s) = h_(k)(s) $

#attenzione[
  Tramite questo metodo otteniamo una funzione di hash perfetta ma *non minimale*: per come funziona MWHC, il numero di bucket è $m = gamma n >= n$ ($gamma = 1.23$), di conseguenza gli hinge utilizzati potrebbero eccedere $n$ e lasciare dei buchi.
]

Spazio occupato:
$
  n r + gamma n + o(n) & = n log m + gamma n + o(n) \
                       & = n log (gamma n) + gamma n + o(n) \
                       & = n log n + n log gamma + gamma n + o(n)
$

#nota[
  La grandezza degli elementi del vettore da memorizzare (soluzione del sistema) dipende dalla grandezza dei valori delle equazioni.

  Andando a ridurre i valori delle equazioni, riduciamo anche i bit necessari per ogni elemento del vettore che verrà memorizzato.
]

_Ottimizzazione_: al posto di utilizzare come valore l'_intero_ hinge, andiamo solo a specificare da *quale delle tre funzioni* deriva.
Ora il valore occupa solo $2$ bit.
$ x_h_0(s) + x_h_1(s) + x_h_2(s) = k $


Spazio occupato:
$ n r + gamma n + o(n) = 2 n + gamma n + o(n) $

#attenzione[
  Anche questa funzione è perfetta ma non *minimale* per lo stesso motivo di prima: l'output è nel range $[0, m-1]$ con $m = gamma n > n$.
]

Possiamo andare a scalare i valori ottenuti dal range $[0, m-1]$ al range $[0, n-1]$, rendendo la funzione *minimale perfetta*.
Sfruttiamo una *rank/select* per fare ciò:
- creiamo un vettore binario lungo $m$
- mettiamo a $1$ i risultati della funzione di hash (ci saranno esattamente $n$ uni)
- andiamo a effettuare l'operazione di rank per sapere il valore compresso nell'intervallo $[0, n-1]$

#nota[
  Questa tecnica è generale e molto potente.

  Dato che la funzione (perfetta) restituisce un output più sparso di quello che ci serve, comprimiamo questo output usando un vettore di bit e una rank/select. Cioè stiamo andando a *ignorare* il contenuto dei *bucket vuoti* (nessuna chiave in essi)
]

#esempio()[
  Supponiamo di avere $3$ amici ($n=3$) che entrano in un cinema con $5$ posti ($m=5$), numerati da $0$ a $4$.
  L'algoritmo di hash assegna loro i posti in modo sparso per evitare collisioni:
  - I posti assegnati sono: $0, 2, 4$
  - I posti $1$ e $3$ sono vuoti.
  
  L'obiettivo (minimalità) è fare rispondere $0, 1, 2$ (come se fossero seduti vicini, senza buchi). Per scalare i valori basta che ogni persona conti il numero di persone sedure prima di se stesso. L'operazione di Rank fa esattamente questo conteggio.
]

=== Theoretical Lower Bound

L'obiettivo è calcolare il *limite inferiore teorico* per rappresentare una MPH.

/ Separazione: data una funzione hash minimale perfetta $h : U -> n$, diciamo che $h$ *separa* un insieme $S subset.eq U$ con $|S| = n$ se $h$ è iniettiva su $S$ (ovvero è una MPH per $S$).

  #informalmente[
    Una funzione $h$ separa un insieme $S$ quando mappa tutti gli elementi di $S$ in bucket diversi, senza collisioni.
  ]

  #nota[
    Procedimento opposto: data una MPH fissata $h : U -> n$, possiamo costruire *tutti* gli insiemi $S$ che $h$ separa:
    - per ogni bucket $k in {0, ..., n-1}$, prendiamo esattamente un elemento da $h^(-1)(k)$ (l'antiimmagine di $k$)
    - otteniamo un insieme $S$ di $n$ elementi che viene separato da $h$

    La controimmagine di un bucket $k$ (scritta come $h^{-1}(k)$) è l'insieme di tutte le chiavi dell'universo $U$ che finiscono in quel bucket.


  ]

/ $n$-sistema: consideriamo una *famiglia* di $t$ funzioni di hash:
  $ H = {h_0, h_1, ..., h_(t-1)} $

  Questa famiglia $H$ è un *$n$-sistema* se è in grado di gestire *qualsiasi* insieme di $n$ chiavi:
  $ forall S subset.eq U, space |S| = n, quad exists space i in {0, ..., t-1} "tale che" h_i "separa" S $

  #informalmente[
    Un $n$-sistema è una famiglia di funzioni di hash "universale": per qualunque insieme di $n$ chiavi, almeno una delle funzioni della famiglia lo separa (è iniettiva su di esso).
  ]

Chiamiamo $H_(U)(n)$ la *cardinalità minima* di un $n$-sistema, ovvero quante funzioni servono nel caso peggiore.

Il theoretical lower bound per rappresentare una MPH è:
$ Z_n = log H_(U)(n) $

#nota[
  Se abbiamo bisogno di almeno $H_(U)(n)$ funzioni diverse, allora per memorizzare "quale funzione stiamo usando" servono almeno $log H_(U)(n)$ bit.
]

/ Quanti insiemi dobbiamo coprire?:
  Tutti i possibili sottoinsiemi di $U$ con cardinalità $n$:
  $ binom(U, n) "insiemi" $

/ Quanti insiemi separa una singola funzione?:
  Una funzione $h : U -> n$ separa un insieme $S$ se mappa ogni elemento in un bucket diverso.
  Nel caso peggiore, ogni bucket ha circa $U/n$ elementi nella controimmagine.

  Il numero di insiemi separati da $h$ (quindi senza collisioni) è circa:
  $ v = product_(k=0)^(n-1) |h^(-1)(k)| approx (U/n)^n $

  #nota()[
    La controimmagine ci dice quante scelte abbiamo per ogni posizione. Per sapere quanti insiemi totali possiamo formare, dobbiamo moltiplicare le possibilità per ogni bucket. Ogni contro immagine avra crica dimensione $U/n$
  ]

/ Quante funzioni servono per coprire tutti gli insiemi?:
  Dobbiamo coprire $binom(U, n)$ insiemi, e ogni funzione copre al massimo $v$ insiemi.
  $
        H_(U)(n) & >= binom(U, n) / v \
                 & >= binom(U, n) / ((U/n)^n) \
     ln H_(U)(n) & >= n + O(ln n) \
    log H_(U)(n) & >= (ln H_(U)(n)) / (ln 2) \
                 & >= n / (ln 2) + O(ln n)
  $

$ Z_n >= 1.44 n + O(ln n) $

La seconda costruzione ottimizzata con rank/select usa:
$
  underbrace(2n, "array valori") + underbrace(gamma n, "vettore bit") + underbrace(o(n), "rank/select")
  & = 2n + 1.23n + o(n) = 3.23n + o(n)
$

La struttura è *compatta*.

#nota[
  Esistono strutture più sofisticate che si avvicinano di più al limite teorico, ma sono significativamente più complesse da implementare e utilizzare.
]
