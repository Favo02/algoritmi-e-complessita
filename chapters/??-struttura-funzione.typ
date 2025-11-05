#import "../imports.typ": *

= Struttura Funzione (dizionario, mappa, array associativo)

== Funzione di Hash

$ h : underbrace(U, "universo") -> underbrace(m, "bucket") $

Proprietà che ci si aspetta siano vere:
+ $h$ sia facile da calcolare (si calcoli al massimo in tempo $O(log(U))$, meglio se in $O(1)$)
+ la funzione occupi poco spazio
+ il più iniettiva possibile (dato che $|U| >> m$, è impossibile sia iniettiva, quindi ci piacerebbe che tutti i bucket abbiano più o meno stessa cardinalità), quindi che ci siano poche collisioni

Ma nella maggior parte dei casi, però non interessa mettere tutto l'universo nei bucket, ma solo un piccolo sottoinsieme $S$:
$ S subset.eq U, quad |S| << |U|, quad |S| = n, quad n <= m $
Questa non è una proprietà esplicitata dato che $S$ non è noto a propri.

#esempio[
  Se la mia funzione di hash funziona perfettamente su tutti gli interi (divide in bucket tutti di dimensione simile), ma io voglio hashare solo i numeri da 0 a 100 e li mette tutti nello stesso bucket, allora nel mio caso fa schifo.
]

=== Full-Randomness Assumption

Dato $U$ e $m$, si sceglie $h : U -> m$ uniformemente a caso.

#attenzione[
  Questa cosa è inattuabile nella realtà.
  Facendo anche finta che ogni funzione di hash sia enumerabile, ma allora come facciamo a implementarle tutte?
  Se memorizziamo le tabelle che fanno corrispondere il valore al bucket, allora occupiamo una marea di spazio.
  Ma è anche lenta, dato che bisogna scorrere tutta la tabella linearmente per trovare l'elemento.
]

Quindi, di solito si studiano strutture assumendo la full Full-Randomness Assumption, ottenendo dei risultati e poi si rilassa e si vede quanto sono peggiorati i risultati.

Ad esempio, se vogliamo hashare uno nome di massimo 18 caratteri e 14 bucket:

$U = {a, b, ..., z}^(<=18), quad m = 14$

Solo riempire e cercare la tabella che mappa ogni entry al suo bucket è impossibile, dato che sono $|U|$ entry.

Quindi al posto di tenere l'intera tabella, allora tengo solo un array di pesi.
L'insieme di funzioni ottenibili è molto ridotto: solo le funzioni ottenimbili come combinazione lineare di pesi.

== ADT

Dato un universo $U$ e un $r > 0$, ho una funzione $f : S -> 2^r$ con $S subset.eq U$.

Quelli che vogliamo rappresentare è $S$.

#informalmente[
  La struttura dati che vogliamo rappresentare è un insieme di chiavi valori, dove le chiavi memorizzate sono $S$ (in un certo istante non avremo tutto l'universo memorizzato) e i valori sono dei valori rappresentabili con $2^r$ bit.
]

L'unica primitiva su questa struttura è il richiede il valore associato ad una chiave.

#attenzione[
  Non è possibile ottenere tutti i valori.
]

#esempio[
  $U = Sigma^(<= 100), quad Sigma = "ASCII"$

  Per ogni nome, memorizziamo il suo indirizzo.
  La nostra funzione $f$ memorizza per ogni entry i 320 bit riservati per il suo indirizzo.
]

== Struttura MWHC

$S subset.eq U, quad |S| = n, quad f : S -> 2^r$

Fisso un $m in bb(N)$ e due funzioni $h_0, h_! : U -> m$

A partire dalle funzioni, costruisco un grafo con $m$ nodi, da $0$ a $m-1$.
Per ogni elemento $s in S$, metto un lato tra i valori delle due funzioni random $(h_0(s), h_1(s))$, ottenendo $n$ lati.

Cose che non vanno bene:
+ il valore delle due funzioni corrisponde $h_0(x) = h_1(x)$
+ due chiavi diversi danno luogo allo stesso lato ${h_0(x), h_1(x)} = {h_0(y), h_1(y)} forall x, y in S, x != y$
+ c'è un ciclo

Se succede qualcuna di queste, allora butto via le due funzioni di hash e le cambio.

Il tempo necessario a fare questa cosa dipende da $m$, dato che con pochi nodi aumenta la probabilità che queste cose accadano.
Ma facendo crescere $m$ (non tantissimo), ci vuole poco tempo ad ottenere questa cosa.

È possibile vedere $G$ come un insieme di $n$ equazioni con $m$ incognite, dove ogni equazione è:
$ x_h_0("chiave") + x_h_1("chiave") mod 2^r = "valore" $

$ cases(x_h_0(s) + x_h_1(s) mod 2^r = f(x) forall s in S) $

Questo sistema di $n$ equzioni diofantee con $m$ incognite.
Se il grafo è aciclico, il sistema ha sicuramente una soluzione.

Una volta trovata la soluzione, viene memorizzata in un array.

Come si usa? Si fa esattamente quanto, si calcola
$ (x_h_0(s) + x_h_1(s)) mod 2^r = f(s) $

Bisogna scegliere bene $m$, per poter ottenere in tempo decente le tre proprietà necessarie.

#teorema("Teorema")[
  Se $m > 2.09n$ il grafo è quasi sempre aciclico.
  Il numero atteso di tentativi per ottenere un grafo aciclico è $2$.
]

Quindi scegliamo $m = 2.09n$.

Perchè l'aciclicità implica l'esistenza di una soluzione?

Generalizziamo, al posto di avere due funzioni di hash, ne abbiamo 3.
Quindi otteniamo un ipergrafo dove ogni lato è un iperlato che connette 3 lati.
Le prime due proprieà da rispettare rimangono ok, mentre l'aciclicità non è definita su un iperlato.

=== Pelabilità di un Ipergrafo

Un ipergrafo è pelabile se esiste un ordinamento dove compaiono tutti gli iperlati e per ogni iperlato viene scelto un suo vertice non ancora comparso in nessuna degli iperlati precedenti (questo vertice si chiama cardine/hinge).

#informalmente[
  Modo di ordinale i suoi iperlati e scegliere un suo vertice che compare in quell'iperlato in modo che quel vertice non compaia mai in nessun iperlato precedente.
]

La pelatura di un ipergrafo coincide esattamente con l'aciclicità di grafo.
Questa cosa ci permette di definire aciclicità su un ipergrafo.

=== Risolubilità

Se è aciclico/pelabile allora è risolubile.

Ad esempio su un ipergrafo di dimensione $3$.

Le sue equazioni sono fatte così allora (dato che un vertice non deve essere ancora apparso):
$
  cases(
    mr(x_0) + x_1 + x_2 = 25 quad mod 100,
    x_0 + mr(x_2) + x_4 = 37 quad mod 100, // TODO: qua x_2 non è libera, fixare
    x_1 + x_2 + mr(x_3) = 12 quad mod 100
  )
$

Dato che c'è sempre una variabile libera, allora è sempre possibile assegnare un valore a quella variabile in modo che rispetti le altre già assegnate.
