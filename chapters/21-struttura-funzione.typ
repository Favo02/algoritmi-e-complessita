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
]<condizioni-grafo-aciclico>

#nota()[
  Il tempo necessario per la *costruzione* di *$G$* *dipende* dal numero di *nodi $m$*. Più $m$ è grande meno tentativi servono per non trovare una collisione. 
]
È possibile vedere $G$ come un insieme di *$n = |S|$ equazioni* con *$m = "# nodi"$ incognite*, dove ogni equazione è:
$ 
  underbrace(x_(h_0("chiave")) + x_(h_1("chiave")),"estremità del lato della chiave") mod 2^r = f("chiave") = "valore" 
$
Possiamo creare così un sistema di $n$ *equazioni diofantee* con $m$ incognite ($x_0,dots,x_(m-1)$):
$ 
  cases(
    x_(h_0(s)) + x_(h_1(s)) mod 2^r = f(s),
    dots,
    forall s in S
  ) 
$

#nota()[
  Un'equazione diofantea è un'equazione in una o più incognite, i cui coefficienti sono numeri interi, e di cui si ricercano esclusivamente le soluzioni intere.
]

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
  Bastano 
  *$
    2.09 n r "bit"
  $*
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
 - ogni lato è un iperlato che connette 3 vertici
 - Le prime due proprieà da rispettare rimangono fattibili
 - la prorità di aciclicità non è definita su un iperlato

=== Pelabilità di un Ipergrafo (aciclicità)

Un ipergrafo si dice *pelabile* se esiste un ordinamento dove compaiono tutti gli iperlati, dove per ogni iperlato viene scelto un suo vertice non ancora comparso in *nessuno* degli iperlati precedenti (questo vertice si chiama *cardine/hinge*). Deve esistere un ordinamento: 
$
  (e_0, x_0),(e_1,x_1),(e_(k-1),x_(k-1))\
  "Dove" e_i ="iperalti", space x_i="vertici"\
  "t.c" x_i in.not e_0 union dots union e_(i-1)
                                          
$

#informalmente[
  Si tratta di un modo di ordinale gli iperlati. Viene scelto un vertice che compare in un certo iperlato. In questo modo, tale vertice non potrà mai comparire in nessun iperlato precedente.
]

=== Risolubilità

#nota()[
  La *pelatura* di un ipergrafo *coincide* esattamente con *l'aciclicità di un grafo*.
  Questa proprietà ci permette di definire l'aciclicità su un ipergrafo.
]

#esempio()[
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
        
        // Disegniamo i nodi
        for node in nodes {
          circle(node.pos, radius: 0.15, fill: black)
          content((node.pos.at(0) + 0.35, node.pos.at(1) + 0.2), node.label)
        }
        
        // Iperlato A = {0, 1, 2} - frecce
        line((1.5, 0) ,(3, 2.5), stroke: blue + 1.2pt)
        line((3, 2.5),(2.4, 2.3),(2, 3), stroke: blue + 1.2pt)
        line((2, 3), (1.5, 0), stroke: blue + 1.2pt)
        content((2.2, 1.8), text(size: 11pt, $A$), fill: white, padding: 0.1)
        
        // Iperlato B = {1, 2, 3} - frecce
        line((3, 2.5), (2, 3), stroke: red + 1.2pt)
        line((2, 3), (4, 3.5), stroke: red + 1.2pt)
        line((4, 3.5), (3, 2.5), stroke: red + 1.2pt)
        content((3, 3.0), text(size: 11pt, $B$), fill: white, padding: 0.1)
        
        // Iperlato C = {0, 2, 4} - frecce
        line((1.5, 0),(1.4, 1.8),(2, 3), stroke: green.darken(20%) + 1.2pt)
        line((2, 3), (0.5, 2), stroke: green.darken(20%) + 1.2pt)
        line((0.5, 2), (1.5, 0), stroke: green.darken(20%) + 1.2pt)
        content((1.0, 1.7), text(size: 11pt, $C$), fill: white, padding: 0.1)
      }),
      
      // Tabella di pelatura
      align(horizon)[
        #table(
          columns: 3,
          align: center,
          [*Iperlato*], [*Cardine*], [*Ordine*],
          $A$, $0$, $1$,
          $C$, $4$, $2$,
          $B$, $3$, $3$,
        )
      ]
    ),
    caption: [
      Esempio di ipergrafo pelabile con la sua sequenza di pelatura. \
      Gli iperlati sono: $A = {0, 1, 2}$, $B = {1, 2, 3}$, $C = {0, 2, 4}$
    ]
  )
  Scrivendo le equazioni di ogni iperlato e sequendo l'ordine di pelatura, otteniamo un sistema con $n = |S|$ equazioni e $m = #"nodi"$ incognite: 
  $
    cases(
      A &= mr(x_0) &+ x_1 &+ x_2 &+ " - " &+ " - " = 25 quad mod 100,
      C &= x_0 &+ " - " &+ x_2 &+ " - " &+ mr(x_4) = 37 quad mod 100,
      B &= " - " &+ x_1 &+ x_2 &+ mr(x_3) &+ " - " = 12 quad mod 100
    )
    \
  $
  Dove in rosso, sono marcati i $mr("cardini")$. il cardine $i$-esimo mi dice la variabile libera che possa assegnare all'equazione $i$-esima. Risolvendo il sitema, partendo da $i=0$:
  - $x_0 = 25$
  - $x_4 = 12.$ In quanto $underbrace(25,x_0) + 12  = 37$
  - $x_3$ = 12

  Dato che *c'è sempre una variabile libera*, allora è sempre possibile assegnare un valore a quella variabile in modo che rispetti le altre già assegnate.
    #figure(
    cetz.canvas({
      import cetz.draw: *
      
      // Array principale
      let values = (25, 0, 0, 12, 12)
      let x-start = 0
      let cell-width = 1
      let cell-height = 0.6
      
      // Disegna le celle dell'array
      for (i, val) in values.enumerate() {
        let x = x-start + i * cell-width
        rect((x, 0), (x + cell-width, cell-height), stroke: black + 1pt)
        content((x + cell-width/2, cell-height/2), text(size: 11pt, str(val)))
      }
      
      // Etichette sotto l'array
      for i in range(5) {
        let x = x-start + i * cell-width
        content((x + cell-width/2, -0.4), text(size: 10pt, $x_#i$))
      }
    }),
    caption: [Spluzione finale del sistema]
  )
  Lo *spazio* occupato dall'array che rappresenta la soluzione è *$m r$ bit*
]

#nota()[
  Le proprietà descritte in precedenza sono vere per un ipergrafo di qualsiasi dimensione (dimensione intesa come grandezza di un iperlato, in questo caso $3$, non numero di nodi).
]



=== Ipergrafo vantaggioso?

Possiamo chiederci se sia vantaggioso usarare un ipergrafo con dimensione $k > 2$, al posto di un grafo "standard" ($k = 2$).

#teorema("Teorema")[
  Per ogni $k >= 2$, esiste un $gamma_k$ t.c: 
  $
    forall underbrace(m,"numero nodi") >= gamma_k underbrace(n,|S|) "la costruizione del" k"-ipergrafo è pelabile"
    
  $
  Il grafo così costruito soddisfa anche le altre due condizioni (bastano pochi tentativi).
]
Nello specifico:
- $gamma_2 = 2.09$ (grafo normale)
- $gamma_3 = 1.23$ (ipergrafo)
- $gamma_(>= 4) > gamma_3$ (ipergrafi)

#informalmente[
  La *migliore* costruzione prevede di scegliere *$3$ funzioni di hash* (non scontato, potevano diminuire).

  Quando questa tecnica è stata introdotta, il numero minimo di funzione hash necessarie non era stato dimostrato, era solamente un risultato sperimentale (provando con vari ipergrafi di dimensioni diverse).

  Negli anni si è trovata una formula per $gamma_k$, dimostrando che il minimo è in $3$.
]

=== Spazio occupato

Per stabilire se la nostra rappresentazione sia succinta, dobbiamo andare a stimare il *theoretical lower bound* per una funzione dizionario: 
$ f : S -> 2^r $

#dimostrazione()[
  Dato l'insieme delle chiavi $S = |n|$, ci sono $(2^r)^n$ funzioni: 
  $
    Z_n &= log (2^r)^n\
        &= log (2^(r n))\
        &= r n
  $
  La struttura proposta (fissato $k=3$) utilizza: 
  $ D_n = underbrace(gamma_3 n,>=m) r = 1.23 n r $
  Si tratta di una *struttura compatta*, in quanto $D_n$ è un $O$ grande di $Z_n$
]

=== Compressione dell'array

L'unica cosa che memorizzia la rappresentazione utilizzata è l'array della soluzione del sistema, ovvero un array $x$ di *$m r$ bit*.

#nota[
  In realtà avremmo anche bisogno di memorizzare le due/tre funzioni di hash utilizate.

  Nel calcolo dello spazio utilizzato andiamo a trascurare la loro dimensione, supponiamo che le funzioni di hash occupino "poco spazio".
]
Il sistema è costruito nel seguente modo:
$
  cases(
    (x_(h_0(s)) + x_(h_1(s)) + x_(h_2(s))) = f(s) mod 2^r,
    dots,
    forall s in S
  )
$
Tuttavia, per come risolviamo il sistema (tramite la pelatura), partiamo da un array inizializzato a $0$ e man mano assegnaimo per ogni equazione una sola variabile (cardine/hinge).\
Nell'array ci sono *$<= n$ variabili* *$x_i != 0$* (un hinge per ognuna delle $n$ equazioni).

Sfruttando questa osservazione, al posto di memorizzare tutto l'array $x$, potremmo memorizzare solo gli *$<= n$ elementi non nulli* e un *array $underline(b)$* di *$m$ bit* con le loro posizioni.

Sull'array $underline(b)$ andremo ad usare una *rank/select*: 
 - Se $underline(b)[i] = 0$, allora incognta del sistema $x_i = 0$ zero, 
 - Se $underline(b)[i] = 1$, usiamo rank e select per risalire al valore di $x_i$ nell'array $x$ della soluzione.

#dimostrazione()[
  Spazio utilizzato: 
  $
    underbrace(n r, "elementi non nulli") + underbrace(m, "array di bit") + underbrace(o(m), "rank/select su m") \
    = n r + gamma_3 n + o(gamma_3 n) \
    = n r + 1.23 n + o(n)
  $

  $ Z_n = n r $
]

#attenzione()[
  La *compressione non* è *sempre conveniente*
  - *soluzione compressa* = $n r + gamma_3 n + o(n)$
  - *soluzione non compressa* = $n gamma_3 r$

  Quando conviene?
  $
    n r + gamma n + cancel(o(n)) quad &< quad n gamma r \
                        n r + gamma n &< n gamma r \
                        &mb("Divido per n")\
                        (n r + gamma n)/mb(n) &< (n gamma r)/mb(n)\
                        r + gamma &< gamma r\
                        gamma &< gamma r - r\
                        gamma &< r(gamma - 1)\
                        r &> gamma/(gamma - 1) approx 1.23/0.23 approx 5.35
  $
  Conviene *comprimere* quando *$r > 5$*.
]

=== Uso della struttura

La struttura (compressa) contiene:
- le $3$ funzioni di *hash*
- *$tilde(x)$* elementi non nulli
- *$underline(b)$* vettore dove sono gli elementi non nulli
- *rank/select* su $underline(b)$

#esempio()[
#figure(
  cetz.canvas({
    import cetz.draw: *
    
    // Box principale della struttura
    rect((0, 0), (6, 4), stroke: black + 1.5pt, radius: 0.3)
    
    // Titolo: h₀, h₁, h₂
    content((3, 3.5), text(size: 11pt, $h_0, h_1, h_2$))
    
    // Array x̃ (elementi non nulli)
    let x-start = 1.5
    let cell-width = 0.6
    let y-array = 2.5
    
    content((1, y-array), text(size: 10pt, $tilde(x)$))
    for i in range(5) {
      rect((x-start + i * cell-width, y-array - 0.3), 
           (x-start + (i + 1) * cell-width, y-array + 0.3), 
           stroke: black + 1pt)
    }
    
    // Array b (bit vector)
    let y-b = 1.5
    content((1, y-b), text(size: 10pt, $underline(b)$))
    
    // Celle con valori 0, 1
    let b-values = (0, 0, 1, 0, 1)
    for (i, val) in b-values.enumerate() {
      let fill-color = if val == 1 { gray.lighten(50%) } else { white }
      rect((x-start + i * cell-width, y-b - 0.3), 
           (x-start + (i + 1) * cell-width, y-b + 0.3), 
           stroke: black + 1pt, fill: fill-color)
      content((x-start + i * cell-width + cell-width/2, y-b), 
              text(size: 9pt, str(val)))
    }
    
    // RS(b) - Rank/Select
    content((3, 0.6), text(size: 10pt, $"RS"(underline(b))$))
    
    // Freccia input: s ∈ U
    line((-1.5, 2), (0, 2), mark: (end: ">"), stroke: black + 1.2pt)
    content((-2.5, 2), text(size: 11pt, $s in U$))
    
    // Freccia output: f(s)
    line((6, 2), (7.5, 2), mark: (end: ">"), stroke: black + 1.2pt)
    content((8.2, 2), text(size: 11pt, $f(s)$))
    
    // Formule sotto
    content((3, -0.8), text(size: 10pt, $h_0(s), h_1(s), h_2(s)$))
    content((3, -1.5), text(size: 10pt, 
      $(x_(h_0(s)) + x_(h_1(s)) + x_(h_2(s))) mod 2^r$))
  }),
  caption: [
    Schema di utilizzo della struttura MWHC: data una chiave $s in U$, \
    si calcolano gli hash $h_0(s), h_1(s), h_2(s)$ e si sommano i corrispondenti \
    valori dall'array $tilde(x)$ (usando $underline(b)$ con rank/select) per ottenere $f(s)$
  ]
)
]
Funzionamento: 
- Quando diamo in pasto una stringa $s in S$, vengono calcolate: 
 $ h_0(s), h_1(s), h_2(2) $
 succsivamente si risolve l'equazione:
$ f(s) = (x_(h_0(s)) + x_(h_1(s)), x_(h_2(s))) mod 2^r $

#nota()[
  La struttura *non memorizza* l'insieme *$S$*. Di conseguenza, se alla struttura diamo in pasto un qualsiasi elemento $in U in.not S$, non può riconoscere che è un input non è "valido", andando a costruire una riposta.
]