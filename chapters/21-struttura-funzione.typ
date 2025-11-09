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

Nella maggior parte dei casi, non ci interessa che la funzione di hash $h$ si comporti bene su tutto l'universo $U$, ma solamente su un piccolo sottoinsieme $S$:
$ 
  S subset.eq U, quad |S| << |U|, quad |S| = n, quad n <= m
$
Vogliamo dunque che gli elementi di $S$ cadano in bucket distinti. Questa *non* è una *proprietà esplicitata* dato che *$S$* *non* è *noto* a propri.

#esempio[
  Sia $h$ una funzione di hash che funziona perfettamente su tutti gli interi $in bb(N)$ (suddivisione in bucket di dimensione simile). Tuttavia nella pratica, vorremmo hashare solamente i numeri da $0$ a $100$. La funzione $h$ li metterebbe tutti nello stesso bucket (non ottimale).
]

=== Full-Randomness Assumption

#teorema("Definzione")[
  Dati $U$ e $m$, si sceglie la funzione hash: 
  $ h : U -> m $ 
  *uniformemente a caso*. 
  #informalmente()[
    Cioè stiamo chedendo che una funzione hash mappi ogni input a un output in modo uniforme e indipendente, come se si trattasse di una mappatura realmente casuale.
  ]
  #attenzione[
    Si tratta di un'*assunzione inpraticabile*. Supponendo che ogni funzione di hash sia enumerabile, rimane il problema di come implementarle tutte.\
    Se memorizzassimo le tabelle che fanno corrispondere il valore(input) al bucket, lo spazio occupato sarebbe esponenziale:
    *$
      |U| log m
    $*
    Inoltre, la funzione di hash sarebbe anche lenta, dato che bisogna scorrere tutta la tabella linearmente per trovare l'elemento desiderato.
  ]
]

Nella pratica, vengono studiate alcune strutture assumendo la full Full-Randomness Assumption. I risultati ottenuti sotto l'assunzione vengono rilassati, misurandone il tasso di peggioramento.

#esempio()[
  Supponiamo di voler hashare dei nomi di massimo $18$ caratteri e di avere a disposizione $14$ bucket:
  $ 
    U = {a, b, ..., z}^(<=18), quad m = 14
  $
  Solamente riempire e cercare la tabella che mappa ogni entry al suo bucket è impossibile, dato che ci sono $|U| = 26^18$ entry possibili.

  Per risparmiare spazio, non viene tenuta in memoria l'intera tabella, ma un *array di pesi* $w_1, w_2, ..., w_18, forall w_i <= m$. Quando dobbiamo hashare un nome come "Claudio Bisio", ogni lettera del nome viene moltiplicata per il peso associato alla sua posizione. La funzione di hash diventa:
  $
    h("Claudio Bisio") = (sum_(i=1)^n w_i dot c_i) mod m
  $
  dove $c_i$ è il valore numerico della $i$-esima lettera e $n$ è la lunghezza del nome.

  L'*insieme di funzioni* ottenibili è *molto ridotto*: solamente le funzioni ottenibili come combinazione lineare dei pesi. Questo viola la Full-Randomness Assumption, ma permette di memorizzare la funzione hash in spazio $O(18)$ invece di $O(26^18)$.
]

== ADT

L'obbiettivo è costruire una funzione $f$ cha associa ad una chiave $s in S$, una valore rappresentabile con $2^r$ bit.\

#informalmente[
  La struttura dati che vogliamo rappresentare è un insieme di chiavi valori, dove le chiavi memorizzate sono $S$ (in un certo istante non avremo tutto l'universo $U$ memorizzato). Ogni chiave associa un valore rappresentabile con $2^r$ bit.
]

Dato un universo $U$ e un $r > 0$, ho una funzione: 
$
  f : S -> 2^r
$
con $S subset.eq U$. Si tratta di una struttura *statica* (non possono essere modificate chiavi e valori)

*Primitiva* di accesso:
- Data una chiave, vogliamo ottenere il suo valore (non è possibile il contrario e non è possibile elencare tutti i valori)

#esempio[
  Dati: 
  - $U = Sigma^(<= 100), quad Sigma = "ASCII"$
  - $S = "insieme di nomi"$
  La funzione $f$ associa ad ogni nome un indirizzo.
]

== Struttura MWHC

Dati: 
- $U$ = universo
- $S subset.eq U$ insieme di chiavi, dove $|S| = n$
- $f : S -> 2^r$, funzione che associa ad ogni chiave un valore
- fissato $m in bb(N)$ e due funzioni hash random $h_0,h_1: U -> m$
Andiamo a costruire un *grafo* dove:  
 - *nodi* = $m$ nodi da $0,dots,m-1$.
 - *archi* = $n = |S|$ archi. Per ogni elemento $s in S$ creo un lato tra $(h_0(s),h_1(s))$. 

#attenzione()[
  Durante la costruzione del grafo devono *valere* le seguenti proprietà:  
  1. $h_0(x) eq.not h_1(x)$. altrimenti collegherei un vertice $x in S$ a se stesso, creado un loop  

  2. $forall x,y in S,x eq.not y space {h_0(x),h_1(x)} eq.not {h_0(y),h_1(y)} $. Stringhe (chiavi) diverse danno origine a lati diversi

  3. Il grafo $G$ deve essere aciclico

  Se una di queste proprietà smette di valere, scarto le due funzioni di hash e le riestraggo.
]

#nota()[
  Il tempo necessario per la *costruzione* di *$G$* *dipende* dal numero di *nodi $m$*. Più $m$ è grande più tentativi servono per non trovare una collisione. 
]
È possibile vedere $G$ come un insieme di $n = |S|$ equazioni con $m = "# nodi"$ incognite, dove ogni equazione è:
$ 
  underbrace(x_(h_0("chiave")) + x_(h_1("chiave")),"estremità del lato della chiave") mod 2^r = f("chiave") = "valore" 
$
Possiamo creare così un sistema di $n$ *equazioni diofantee* con $m$ incognite ($x_0,dots,x_(m-1)$).
$ 
  cases(
    x_(h_0(s)) + x_(h_1(s)) mod 2^r = f(s),
    dots,
    forall s in S
  ) 
$
Se il *grafo* è *aciclico* $=>$ il *sistema* è *risolubile*. La soluzione del sistema è un array di dimensione $m$ con valori compresi fra ${0,dots,r}$. Totale *$mr$ bit*\
Per ottenere il valore associato alla chaive $s in S$:
$ (x_h_0(s) + x_h_1(s)) mod 2^r = f(s) $

=== Scelta di $m$

Un parametro fondamentale è la grandezza di $m$, c'è da fare un *tradeoff*:
- $mb("più" m "è piccolo")$, più la struttura è succinta (dato che il vettore occupa $m r$ bit)
- ma se $m$ è tanto piccolo, allora è difficile ottenere un grafo che rispetta le tre proprietà in tempi ragionevoli

#teorema("Teorema")[
  Se *$m > 2.09n$* (dove $n = |S|$) il grafo $G$ è quasi sempre aciclico.\
  Il numero atteso di tentativi per ottenere un grafo $G$ aciclico è $2$.\
  Bastano $2.09 m r "bit"$
]

==== Generalizzazione

Nella definizione precendente abbiamo scelto solamente due funzioni di hash random $h_0 " e " h_1$ ottenendo un grafo normale.\
Se scegliessimo *più di due funzioni di hash* otterremmo un *ipergrafo*, permettendoci di abbassare il parametro $m$.\

#nota()[
  Un *ipergrafo* $H$ è un grafo in cui un arco può essere collegato a un qualunque numero di vertici. Formalmente, $H(X,E)$ dove: 
  - $X$= insieme di nodi
  - $E subset.eq P(X)backslash{emptyset}$ = insisme formato da sottoinsiemi non vuoti di $X$ chiamati iperarchi 

  #figure(
  cetz.canvas({
    import cetz.draw: *
    
    // Definiamo i nodi (vertici)
    let nodes = (
      (name: "v1", pos: (1, 3.5), label: $v_1$),
      (name: "v2", pos: (3.2, 4), label: $v_2$),
      (name: "v3", pos: (5.5, 3.8), label: $v_3$),
      (name: "v4", pos: (1.3, 0.8), label: $v_4$),
      (name: "v5", pos: (3.5, 1.5), label: $v_5$),
      (name: "v6", pos: (5, 1.3), label: $v_6$),
      (name: "v7", pos: (3.2, 0.2), label: $v_7$),
    )
    
    // e₁ = {v₁, v₂, v₃} - ovale giallo grande
    circle((3.5, 3.7), radius: (3.5, 1.8), 
           fill: yellow.lighten(50%), stroke: black + 1.5pt)
    
    // e₃ = {v₃, v₅, v₆} - ovale verde (semi-trasparente per vedere sovrapposizioni)
    circle((5, 2.2), radius: (2.3, 2.2), 
           fill: green.lighten(20%).transparentize(40%), stroke: black + 1.5pt)
    
    // e₂ = {v₂, v₃} - ovale rosa (semi-trasparente per vedere sovrapposizioni)
    circle((4.5, 3.9), radius: (2, 1.1), 
           fill: red.lighten(30%).transparentize(40%), stroke: black + 1.5pt)
    
    // e₄ = {v₄} - cerchio viola piccolo
    circle((1, 0.8), radius: 1.0, 
           fill: purple.lighten(60%), stroke: black + 1.5pt)
    
    // Disegniamo i nodi sopra gli iperlati
    for node in nodes {
      circle(node.pos, radius: 0.15, fill: black)
      content((node.pos.at(0) - 0.35, node.pos.at(1) - 0.1), node.label)
    }
    
    // Aggiungiamo le etichette degli iperlati
    content((1.5, 4.3), text(size: 12pt, $e_1$))
    content((4.4, 4.7), text(size: 12pt, $e_2$))
    content((6.5, 1.6), text(size: 12pt, $e_3$))
    content((0.4, 0.5), text(size: 12pt, $e_4$))
  }),
  caption: [
    Un esempio di ipergrafo con:\ 
    $X = {v_1, v_2, v_3, v_4, v_5, v_6, v_7}$ \
    $E = {e_1, e_2, e_3, e_4} = {{v_1, v_2, v_3}, {v_2, v_3}, {v_3, v_5, v_6}, {v_4}}$
  ]
)


]

Con $3$ funzioni hash otteniamo un ipergrafo, dove: 
 - ogni lato è un iperlato che connette 3 lati.
 - Le prime due proprieà da rispettare rimangono fattibili - la prorità di aciclicità non è definita su un iperlato.

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
