#import "../imports.typ": *

= Struttura Funzione Statica (dizionario, mappa, array associativo)

== Funzione di Hash

Una funzione di Hash e una funzione $h$ t.c: 
$ 
  h : underbrace(U, "universo") -> underbrace(m, "bucket")
$
Proprietà di una funzione hash:
+ $h$ deve essere *facile da calcolare* (massimo in tempo $O(log(U))$, meglio se in $O(1)$)
+ la funzione occupi poco spazio
+ sia il più *iniettiva* possibile (dato che $|U| >> m$, è impossibile che sia al $100%$ iniettiva). Sarebbe auspicabile che tutti i *bucket* abbiano più o meno la *stessa cardinalità*, quindi che ci siano *poche collisioni*

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

#informalmente[
  Una funzione che associa delle chiavi a dei valori.
  Non può essere cambiata.

  L'unica operazione che esiste è, data una chiave, ottenere il suo valore (non il contrario e non elencare tutti i valori).
]

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

$ cases(x_h_0(s) + x_h_1(s) mod 2^r = f(s) quad forall s in S) $

Questo sistema di $n$ equzioni diofantee con $m$ incognite.
Se il grafo è aciclico, il sistema ha sicuramente una soluzione.

Una volta trovata la soluzione, viene memorizzata in un array di $m r$ bit.

Come si usa? Si fa esattamente quanto, si calcola
$ (x_h_0(s) + x_h_1(s)) mod 2^r = f(s) $

=== Scelta di $m$

Bisogna scegliere bene $m$, c'è da fare un tradeoff:
- più piccolo è $m$, più la struttura è succinta (dato che il vettore occupa $m r$ bit)
- ma se è tanto piccolo, allora è difficile ottenere un grafo che rispetta le tre proprietà

#teorema("Teorema")[
  Se $m > 2.09n$ il grafo è quasi sempre aciclico.
  Il numero atteso di tentativi per ottenere un grafo aciclico è $2$.
]

Quindi scegliamo $m = 2.09n$.

SI può fare meglio di così? Si.
Se scegliamo solo due funzioni di hash, allora otteniamo un grafo normale.
Se scegliamo più di due funzioni di hash otteniamo un ipergrafo.
Questa cosa ci permette di abbassare $m$.

Generalizziamo, al posto di avere due funzioni di hash, ne abbiamo 3.
Quindi otteniamo un ipergrafo dove ogni lato è un iperlato che connette 3 lati.
Le prime due proprieà da rispettare rimangono ok, mentre l'aciclicità non è definita su un iperlato.

=== Pelabilità di un Ipergrafo (aciclicità)

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
    x_0 + x_2 + mr(x_4) = 37 quad mod 100,
    x_1 + x_2 + mr(x_3) = 12 quad mod 100
  )
  \
  = x_0 = 25, x_4 = 12, x_3 = 12
$

Dato che c'è sempre una variabile libera, allora è sempre possibile assegnare un valore a quella variabile in modo che rispetti le altre già assegnate.
Questa cosa è vera per ogni ipergrafo di qualsiasi dimensione (dimensione intesa come grandezza di un iperlato, in questo caso $3$, non numero di nodi).

=== Vantaggioso?

È vantaggioso usarare un ipergrafo ($k > 2$) al posto di un grafo ($k = 2$)?

#teorema("Teorema")[
  Per ogni $k >= 2$, esiste un $gamma_k$ tale che $forall m >= gamma_k n$ la costruizione del $k$-ipergrafo è pelabile (ovvero aciclico) e soddisfa le altre due condizioni quasi certamente (bastano pochi tentativi).
]

Nello specifico:
- $gamma_2 = 2.09$ (grafo normale)
- $gamma_3 = 1.23$ (ipergrafo)
- $gamma_(>= 4) > gamma_3$ (ipergrafi)

#informalmente[
  Quindi il miglior modo è scegliere $3$ funzioni di hash (cosa non scontata, poteva essere che aumentando la dimensione del grafo diminuiva).

  Quando questa tecnica è stata introdotta, questa cosa non era stata dimostrata, era solo sperimentale (provando con vari ipergrafi di dimensioni diverse).

  Più avanti è stata dimostrata, trovando una formula per $gamma_k$ e dimostrando che il minimo è in $3$.
]

=== Spazio occupato

Theoretical lower bound di $f : S -> 2^r$

Per $s$ fissato di cardinalità $n$, ci sono $(2^r)^n$ funzioni:
$ Z_n = log 2^(r n) = r n $

La nostra struttura (con $k = 3$) usa
$ D_n = gamma_3 n r = 1.23 n r $
quindi è compatta (un $O(n)$), non succinta.

=== Compressione dell'array

L'unica cosa che memorizziamo è la soluzione del sistema, ovvero un array $x$ di $m r$ bit.

#nota[
  In realtà abbiamo anche bisogno di memorizzare le due/tre funzioni di hash che usiamo.

  Questa cosa la trascuriamo dato che diciamo che le funzioni di hash occupano "poco spazio".
]

Il sistema è fatto così:
$
  cases((x_n_0(s) + x_n_1(s) + x_n_2(s)) = f(s) mod 2^r quad forall s in S)
$

Ma per come risolviamo il sistema (ovvero con la pelatura), allora pariamo da un array tutto a $0$ e assegnaimo per ogne equazione una sola variabile (lo spigolo/hinge).

Quindi nell'array ci sono $<= n$ variabili $x_i != 0$.

Al posto di memorizzare tutto l'array $x$, memorizziamo solo gli $<= n$ elementi non nulli e un array di $m$ bit con le loro posizioni.

Su questo array $m$ andremo ad usare una rank/select.
Se c'è uno zero sappiamo che è zero, altrimenti usiamo la rank e select per sapere dov'è nell'array dei soli valori non $0$.

Spazio utilizzato:

$
  underbrace(n r, "elementi non nulli") + underbrace(m, "array di bit") + underbrace(o(m), "rank/select su m") \
  = n r + gamma_3 n + o(gamma_3 n) \
  = n r + 1.23 n + o(n)
$

$ Z_n = n r $

Non è sempre convenienete la compressione:
- compressa: $n r + gamma_3 n + o(n)$
- non compressa: $n gamma_3 r$

Quando è conveniente?
$
  n r + gamma_3 n + cancel(o(n)) quad < quad n gamma_3 r \
  ... \
  r > 5
$

Conviene comprimere quando $r > 5$.

=== Uso della struttura

La struttura (compressa) contiene:
- le $3$ funzioni di hash
- $tilde(x)$ elementi non nulli
- $underline(b)$ vettore dove sono gli elementi non nulli
- rank/select su $underline(b)$

Quando diamo in pasto una stringa $s$, lui calcola $h_0(s), h_1(s), h_2(2)$ e risolve $(x_h_0(s) + x_h_1(s), x_h_2(s)) mod 2^r$ e lo restituisce.

Quindi la struttura non ha da nessuna parte dell'insieme $S$ (non lo memorizza da nessuna parte).

Ma questo causa che se gli diamo in pasto un qualsiasi elemento $in U \ S$, allora la struttura non può riconoscere che non è "valido", ma costruisce una risposta e la restituisce.

Se vogliamo essere certi che risponda solo per elementi $in S$?
