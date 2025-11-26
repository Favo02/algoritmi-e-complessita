#import "../imports.typ": *

= Struttura di Rango e Selezione (Statica)

#attenzione[
  La versione presentata della struttura è *statica*, ovvero non è modificabile dopo la costruzione (immutabile).
  È possibile solo interrogarla.

  Esiste anche la versione dinamica, che permette di cambiare dei valori del vettore o cambiare la dimensione del vettore.
  Non vedremo questa versione (che è completamente diversa).
]

== ADT

Formalmente:
- Input: vettore binario $underline(b) in 2^n$ (di lunghezza $n$ e contenente $m$ uni)
- Primitive:
  - $"rank"_underline(b): bb(N) -> bb(N)$
  - $"select"_underline(b): bb(N) -> bb(N)$

  1. $forall p <= n, quad "rank"_underline(b)(p) = |{i space | space i < p and b_i = 1}|$

  2. $forall k <= "rank"_underline(b)(n), quad "select"_underline(b)(k) = max { p space | space "rank"_underline(b)(p) <= k }$

  #informalmente[
    - $"rank"(p)$ conta il numero di $1$ fino alla posizione $p$ (*non* inclusa).
    - $"select"(k)$ posizione massima il cui rank è uguale a $k$, ovvero l'indice del $(k+1)$-esimo uno.
  ]

  #attenzione[
    Entrambe le primitive hanno una entry _fittizia_:
    - $"rank"(n)$: rank dell'indice oltre la fine del vettore, restituisce il numero totale di $1$ ($= m$)
    - $"select"("rank"(n))$: equivalente a $"select"(m)$, indice del $(m+1)$-esimo uno, ma non esistendo abbastanza uni, viene restituita la fine del vettore, ovvero $n$.
  ]

#figure(
  grid(
    columns: (auto, auto),
    row-gutter: 1em,
    column-gutter: 3em,
    align: center + horizon,

    // Vettore centrale
    grid.cell(
      colspan: 2,
      stack(
        dir: ttb,
        spacing: 0.5em,
        table(
          columns: 8,
          align: center,
          stroke: (x, y) => if y == 0 or x == 0 { none } else { 0.5pt + black },
          [],
          [#text(size: 8pt, fill: gray)[0]],
          [#text(size: 8pt, fill: gray)[1]],
          [#text(size: 8pt, fill: gray)[2]],
          [#text(size: 8pt, fill: gray)[3]],
          [#text(size: 8pt, fill: gray)[4]],
          [#text(size: 8pt, fill: gray)[5]],

          [#text(size: 8pt, fill: gray)[6]],

          [$underline(b)$], [0], [1], [1], [0], [1], [0], [1],
        ),
        text(size: 11pt)[$n = 7, m = 4$],
      ),
    ),

    // Tabella Rank (sinistra)
    table(
      columns: 2,
      align: center,
      stroke: 0.5pt + black,
      [*$p$*], [*$"rank"_underline(b)(p)$*],
      [0], [0],
      [1], [0],
      [2], [1],
      [3], [2],
      [4], [2],
      [5], [3],
      [6], [3],
      [7], [4],
    ),

    // Tabella Select (destra)
    table(
      columns: 2,
      align: center,
      stroke: 0.5pt + black,
      [*$k$*], [*$"select"_underline(b)(k)$*],
      [0], [1],
      [1], [2],
      [2], [4],
      [3], [6],
      [4], [7],
    ),
  ),
  caption: [
    Esempio di funzionamento delle primitive Rank e Select sul vettore $underline(b)$.
  ],
)

#teorema("Proprietà")[
  Il numero di uni (rank), prima dell'indice del $(k+1)$-esimo uno (select) è, ovviamente, $k$:
  $ forall k, quad "rank"("select"(k)) = k $
]

#teorema("Proprietà")[
  L'indice del $("numero di uni prima di" p +1)$-esimo uno (ovvero il prossimo uno) è almeno grande quanto $p$:
  $ forall p, quad "select"("rank"(p)) >= p $

  In caso $b_p = 1$, allora il xc$("numero di uni prima di" p +1)$-esimo uno è esattamente $p$, dato che il prossimo uno è lui stesso (rank non conta la posizione stessa):
  $ forall p, quad "select"("rank"(p)) = p $

  #nota[
    Questa proprietà ci permette sempre di risalire al vettore originale
  ]
]

Esistono due approcci possibili naive:

- *minimalista*: il costruttore mette da parte il vettore $underline(b)$.
  Per rank e select si scorre l'intero vettore e si calcola al volo il risultato:
  $ "spazio" = n, quad "tempo" = O(n) $

- *massimalista*: il costruttore calcola le due tabelle di rank e select e butta via il vettore.
  Le tabelle hanno $n$ righe, dove ogni riga ha un valore compreso tra $0$ e $n$.
  Lo spazio occupato da ogni riga è $log n$ bit, quindi ognui tabella occupa $n log n$
  $ "spazio" = 2 n log(n), quad "tempo" = O(1) $

Il *lower bound teorico* è $n$, quindi la struttura minimalista è l'ottimo, tuttavia è molto lenta.
La versione massimalista è veloce ma occupa molto spazio, non è nemmeno compatta.

== Struttura di Jacobson per il Rank

#attenzione[
  La struttura di Jacobson è utilizzabile solo per il rank, non supporta la select.
]

Partendo dal vettore $underline(b)$ di dimensione $n$, lo dividiamo in:

- *#text(blue)[Superblocchi]* di lunghezza $(log(n))^2$: memorizzano il numero di $1$ prima dell'inizio del superblocco (quindi escluso)
- *#text(orange)[Blocchi]* di lunghezza $1/2 log(n)$: memorizzano il numero di $1$ dall'inizio del superblocco fino all'inizio del blocco (escluso)

#figure(
  cetz.canvas({
    import cetz.draw: *

    let total_width = 12
    let total_start = -6
    let num_superblocks = 3
    let superblock_width = total_width / num_superblocks
    let num_blocks = 4
    let block_width = superblock_width / num_blocks

    // ===== VETTORE b =====
    content((total_start - 0.5, 3.0), text(size: 11pt, weight: "bold")[$underline(b)$])

    // Lunghezza totale n
    line((total_start, 5.0), (total_start + total_width, 5.0), stroke: 1.5pt + black)
    line((total_start, 4.9), (total_start, 5.1), stroke: 1.5pt + black)
    line((total_start + total_width, 4.9), (total_start + total_width, 5.1), stroke: 1.5pt + black)
    content((0, 5.3), text(size: 10pt)[$n$])

    // ===== BLOCCHI (arancione) =====
    for sb in range(num_superblocks) {
      let sb_x = total_start + sb * superblock_width

      for b in range(num_blocks) {
        let b_x = sb_x + b * block_width

        if sb == 1 and b == 2 {
          rect((b_x, 2.3), (b_x + block_width, 3.7), stroke: 2pt + orange, fill: orange.transparentize(85%))

          // Linea rank da superblocco
          line((sb_x, 2.0), (b_x, 2.0), stroke: (paint: orange, thickness: 1.2pt, dash: "dashed"))
          content(((sb_x + b_x) / 2, 1.75), text(size: 9pt, fill: orange)[nel blocco])

          // Etichetta lunghezza blocco (sotto il blocco evidenziato)
          let block_center = b_x + block_width / 2
          line((b_x, 2), (b_x + block_width, 2), stroke: 1.5pt + orange)
          line((b_x, 1.9), (b_x, 2.1), stroke: 1.5pt + orange)
          line((b_x + block_width, 1.9), (b_x + block_width, 2.1), stroke: 1.5pt + orange)
          content((block_center, 1.7), text(size: 9pt, fill: orange, weight: "bold")[$1/2 log n$])
        } else {
          rect((b_x, 2.3), (b_x + block_width, 3.7), stroke: 1pt + orange, fill: none)
        }
      }
    }

    // ===== SUPERBLOCCHI (blu) =====
    for sb in range(num_superblocks) {
      let sb_x = total_start + sb * superblock_width

      if sb == 2 {
        rect((sb_x, 2.3), (sb_x + superblock_width, 3.7), stroke: 2.5pt + blue, fill: blue.transparentize(85%))
      } else {
        rect((sb_x, 2.3), (sb_x + superblock_width, 3.7), stroke: 2pt + blue, fill: none)
      }

      // Linea rank globale
      line((total_start, 4.0), (sb_x, 4.0), stroke: (paint: blue, thickness: 1.5pt, dash: "dashed"))
    }
    content(((total_start + 2.5) / 2, 4.25), text(size: 9pt, fill: blue)[nel superblocco])

    // Etichetta lunghezza superblocco
    let sb_center = total_start + 2.5 * superblock_width
    line((sb_center - superblock_width / 2, 4), (sb_center + superblock_width / 2, 4), stroke: 1.2pt + blue)
    line((sb_center - superblock_width / 2, 4.1), (sb_center - superblock_width / 2, 3.9), stroke: 1.2pt + blue)
    line((sb_center + superblock_width / 2, 4.1), (sb_center + superblock_width / 2, 3.9), stroke: 1.2pt + blue)
    content((sb_center, 4.2), text(size: 9pt, fill: blue, weight: "bold")[$(log n)^2$])
  }),
  caption: [
    Struttura di Jacobson per Rank: il vettore è diviso in superblocchi (blu) e blocchi (arancione).
  ],
)

Con le informazioni contenute nei #text(blue)[superblocchi] e #text(orange)[blocchi], siamo in grado di ricostruire quasi interamente il rank.
Manca solamente un informazione: il numero di $1$ dentro il blocco stesso fino ad una certa posizione (offset interno al blocco).

Dato che ogni blocco è lungo esattamente $1/2 log n$, allora esistono $2^(1/2 log n)$ *tipi* di blocco.
Siccome le combinazioni sono poche, possiamo costruire una *tabella* di rank esplicita *per ogni tipo* di blocco.
Ogni tabella, deve memorizzare il numero di uni dall'inizio del blocco fino ad ogni posizione.

Questo tipo di tecnica prende il nome di #text(green)[*Four Russians Trick*].

=== Spazio occupato

#nota[
  Per facilità, assumeremo che la dimensione $n$ è una potenza di $2$.
]

Quanto spazio occupano i #text(blue)[superblocchi] e i #text(orange)[blocchi]?

- #text(blue)[*Superblocchi*]: la tabella ha $n / (log_n)^2$ righe, ogni riga può contenere un numero grande al massimo quanto $n$ (vettore di tutti $1$), quindi $log n$ per rappresentarlo:
  $ n / (log_n)^2 log_n = n / (log n) = mr(o(n)) $
- #text(orange)[*Blocchi*]: la tabella ha $n / (1/2 log n)$ righe, tuttavia il numero che ciascuna deve contenere è limitato, sono al massimo la grandezza del superblocco, ovvero $(log n)^2$, rappresentabili in $log((log n)^2)$ bit:
  $ n / (1/2 log n) log (log n)^2 = n / (1/2 log n) 2 log log n = mr(o(n)) $

  #nota[
    Proprietà dei logaritmi:
    $ log x^y = y log x $
    Ma non vale
    $ (log x)^y != y log x $
  ]
- #text(green)[*Four Russians Trick*]: esistono $2^(1/2 log n)$ tipi di blocchi, ognuna con dimensione:
  - numero di righe: $1/2 log n$, una per ogni posizione, fino alla lunghezza del blocco
  - grandezza di ogni riga: $log(1/2 log n)$ bit per rappresentare il contenuto
  In totale:
  $
    underbrace(2^(1/2 log n), "numero tabelle") dot underbrace(1/2 log n dot log (1/2 log n), "singola tabella")
    = 2^(log sqrt(n)) dot log(sqrt(n)) dot log (log sqrt(n)) \
    = sqrt(n) space log sqrt(n) space log log sqrt(n)
    = mr(o(n))
  $

#attenzione[
  Per poter determinare il tipo di ogni blocco, è necessario *conservare* il vettore originale $underline(b)$.

  Supponiamo che isolare un blocco si possa fare in tempo costante.
]

#nota[
  Si potrebbe tagliare l'implementazione e tenere solo #text(blue)[superblocchi] e #text(orange)[blocchi].
  Non usando #text(green)[four russians trick], è necessario scorrere il blocco per contare gli $1$, rendendo l'accesso non più costante ma logaritmico.

  Avremo quindi un *tradeoff* sul tempo (comunque molto più efficiente della versione massimalista) ma molto più semplice.
]

Spazio *totale* utilizzato:
$ D_n = underbrace(n, "dim" underline(b)(n)) + mr(o(n)) = Z_n + o(Z_n) $
Si tratta dunque di una *struttura statica succinta per il rango* con tempo di accesso costante.

#informalmente[
  L'approccio di Jacob *lavora a livelli*:
  - le prime tabelle (superblocchi) contengono poche righe ma i valori contenuti sono grandi
  - scendendo di livello (blocchi), il numero di tabelle cresce ma i valori sono più piccoli
  - scendendo ulteriormente (four russians trick), il problema originale è stato ridotto talmente tanto da poter memorizzare tutte le possibili casistiche (tipi di blocchi).
]

== Struttura di Clark per la Select

#attenzione[
  La struttura di Clark è utilizzabile solo per la select, non supporta il rank.
]

Anche in questo caso sfruttiamo una tecnica che lavora per *livelli*:

- #text(red)[*I livello*]: memorizza solamente le posizioni degli $mr(1)$ in posizione multipla di $mr(log n log log n)$ (relativa al numero di uni) $P_1, ..., P_(t/(log n log log n))$.
  Il numero di posizioni da memorizzare dipende dal numero di uni $t <= n$, ed è uguale a $t/(log n log log n)$ (righe della tabella).
  Ognuna di queste posizioni (ovvero una riga della tabella), contiene al massimo il valore $n$ (vettore di tutti uni), quindi ogni riga occupa $log n$ bit.
  Spazio totale utilizzato dal #text(red)[livello I]:
  $
    underbrace(t / (log(n) log (log n)), "numero righe") dot underbrace(log n, "bit riga") quad &underbrace(<=, mr(t <= n)) quad mr(n) / (log(n) log (log n)) log n \
    & = n / (log(log n)) = o(n)
  $

  #attenzione[
    Non memorizziamo gli uni in posizione $log n log log n$ rispetto all'inizio del vettore, ma memorizziamo gli $(log n log log n)$-esimi uni (gli zeri non influiscono).
  ]

  #esempio[
    Con $n = 1024$ memoriziamo la posizione di un uno ogni $log 1024 dot log log 1024 approx 33$.
  ]

- #text(blue)[*II livello*]: consideriamo ora la *distanza* tra due elementi consecutivi memorizzati dal primo livello.
  Per come funziona il livello I, la distanza tra questi due elementi è per forza grande almeno quanto il $log n log log n$ (ma potrebbe essere più grande se ci sono $0$ in mezzo):
  $ r_i = P_(i+1) - P_i >= log n log log n $
  Chiamiamo $r_i$ la *densità* degli $1$ e andiamo a considerare due sottocasi.

  - #text(blue)[*Caso II A*]: gli uni tra le due posizioni sono distribuiti in modo *sparso*:
    $ r_i >= (log n log log n)^2 $

    Dato che sono pochi, allora andiamo a memorizziare *esplicitamente* le posizioni degli uni intermedi, come offset da $P_i$.
    Dimensione della tabella:
    - _Righe_: gli $1$ sono esattamente $log n log log n$
    - _Valori_: offset relativo a $P_i$, quindi la distanza massima tra due $P_i$, $log(r_i)$ bit.
    Spazio totale:
    $
      log(n) log(log n)) log r_i underbrace(=, "moltiplico/divido per" \ log(n) log(log(n))) & (mb((log(n) log(log n))^2) log r_i) / mb(log(n) log(log n)) \
      underbrace(<=, r_i >= (log n log log n)^2) space & (mb(r_i) log r_i) / (log(n) log(log n)) \
      underbrace(<=, r_i <= n) space quad quad & (r_i log mb(n)) / (log (n) log(log n)) \
      <= quad quad quad & (r_i) / (log(log n)) \
    $

  - #text(blue)[*Caso II B*]: gli uni tra le due posizioni sono *densi*:
    $ r_i < (log n log log n)^2 $

    Ulteriore livello, memorizziamo solamente le posizioni degli uni *multipli* di $mb(log r_i log log n)$ (analogamente al primo livello) all'interno dell'intervallo $[P_i, P_(i+1))$.
    Spazio utilizzato:
    - _Righe_: memorizziamo una posizione ogni $(log r_i log log n)$, rispetto alle $(log n log log n)$ totali, quindi $(log(n) log(log n)) / (log(r_i) log(log n))$ righe
    - _Valori_: offset relativo a $P_i$, quindi la distanza massima tra due $P_i$, $log(r_i)$ bit
    Spazio totale:
    $
      (log(n) log(log n)) / (log(r_i) log(log n)) log r_i = quad quad
      mb(log(n) log(log n)) / (log(log n)) \
      underbrace(<=, r_i >= log n log log n) mb(r_i) / (log (log n))
    $

  Spazio totale occupato dal #text(blue)[*livello II*] (entrambi i sottocasi occupano la stessa quantità di spazio) per memorizzare gli uni intermedi tra $P_i$ e $P_(i+1)$:
  $
    mb("Livello II") & <= r_i/(log(log n)) = (P_(i+1)-P_i)/(log(log n)) quad forall i \
                     & <= sum_(i=0)^(t/(log n log log n) - 1) (P_(i+1) - P_i) / (log (log n)) \
      quad quad quad & underbrace(=, "è una serie"\ "telescopica") mb(P_(t/(log n log log n)) - P_0) / (log (log n)) \
                     & <= mb(n) / (log (log n)) = o(n) \
  $

- #text(orange)[*III livello*] solo per il caso II B, quindi gli uni sono densi:
  $ r_i < (log n log log n)^2 $
  Di questi uni, ne abbiamo memorizzati solo alcuni, quelli multipli di $log r_i log log n$, ovvero:
  $
    S_i^0, S_i^1, ..., S_i^((log(n) log(log n))/(log(r_i) log(log n)))
  $
  Abbiamo dunque un intervallo $[S_i^j, S_i^(j+1))$ che contiene $(log r_i log log n)$ uni.
  Chiamiamo la *differenza* tra due posizioni $S_i$ consecutive $overline(r_i^j)$:
  $ overline(r_i^j) = S_i^(j+1) - S_i^j $

  Questa differenza è:
  + $overline(r_i^j) >= log r_i log log n$
  + dato che siamo nel caso #text(blue)[II B], $space overline(r_i^j) <= r_i < (log n log log n)^2$

  Quindi:
  $ log r_i log log n <= overline(r_i^j) <= r_i < (log n log log n)^2 $

  Anche in questo livello abbiamo bisogno di distinguere in due casi:
  - #text(orange)[*Caso III A*]: gli uni sono *sparsi*:
    $ overline(r_i^j) >= log overline(r_i^j) log r_i (log log n)^2 $
    Dato che sono pochi, allora *memorizziamo esplicitamente* le posizioni come offset da $S_i$.
    Dimensione e spazio tabella:
    - _Righe_: memorizziamo $log r_i log log n$ posizioni
    - _Colonne_: offset da $overline(r_i^j)$, quindi $log overline(r_i^j)$ bit
    Spazio totale:
    $
      (log r_i log log n) log overline(r_i^j) & underbrace(=, "moltiplico/divido per" \ log log n) (log r_i mo((log log n)^2) log overline(r_i^j)) / mo(log log n) \
      quad quad & underbrace(=, r_i^j >= mo(log r_i (log log n)^2 log overline(r_i^j)))
      <= mo(overline(r_i^j)) / (log log n)
    $

  - #text(orange)[*Caso III B*]: gli uni sono *densi*:
    $ overline(r_i^j) < log overline(r_i^j) log r_i (log log n)^2 $
    usiamo il *four russians trick*.

    Lo spazio occupato:

    #teorema("Oss1")[
      Dato che siamo nel #text(blue)[sottocaso II B] (il #text(orange)[livello III] esiste solo in questo caso), allora:

      $
                        overline(r_i^j) <= r_i & < (log n log log n)^2 \
        mo(log) overline(r_i^j) <= mo(log) r_i & <= mo(log) (log n (log log n)^2) \
                                               & = 2 log log n + 2 log log log n \
                                               & <= 4 log log n
      $
    ] <clark-oss1>

    #teorema("Oss2")[
      Siccome siamo nel caso #text(orange)[III B], allora vale:
      $
        overline(r_i^j) < log overline(r_i^j) log r_i (log log n)^2
      $
      Di conseguenza usando #link-teorema(<clark-oss1>):
      $
        overline(r_i^j) &< underbrace(log overline(r_i^j), <= 4 log log n) dot underbrace(log r_i, <= 4 log log n) dot (log log n)^2\
        &<= 16(log log n)^2 (log log n)^2\
        &= 16(log log n)^4
      $
    ] <clark-oss2>

    Usando il four russians trick, il numero di bit utilizzati è pari a:
    $
      &<= underbrace(2^overline(r_i^j), "numero tabelle") dot underbrace(overline(r_i^j), "righe") dot underbrace(log overline(r_i^j), "bit per valore") \
      &underbrace(<=, #link-teorema(<clark-oss2>)) 2^mb(16(log log n)^4) dot mb(16(log log n)^4) dot log mb(16(log log n)^4) = o(n)
    $

#informalmente[
  La struttura di Clark per Select usa un approccio a *tre livelli gerarchici* per memorizzare efficientemente le posizioni degli uni:

  + #text(red)[*Livello I*]: memorizziamo solo le posizioni degli `1` multipli di $log n log log n$.
    Questo crea dei "checkpoint" sparsi che occupano poco spazio: $o(n)$.

  + #text(blue)[*Livello II*]: tra due checkpoint consecutivi $P_i$ e $P_(i+1)$ ci sono esattamente $log n log log n$ bit a `1`.
    Calcoliamo la distanza fisica $r_i = P_(i+1) - P_i$ e distinguiamo:
    - #text(blue)[*Caso II A*] (*sparso*): se $r_i >= (log n dot log log n)^2$, gli `1` sono così distanti che conviene memorizzare esplicitamente tutte le loro posizioni.
    - #text(blue)[*Caso II B*] (*denso*): se $r_i < (log n dot log log n)^2$, gli `1` sono troppo vicini.
      Usiamo di nuovo la tecnica del Livello I su scala ridotta: memorizziamo solo le posizioni multiple di $log r_i log log n$.

    In entrambi i sottocasi, lo spazio totale è $o(n)$ grazie alla sommatoria telescopica.

  + #text(orange)[*Livello III*] (solo per caso II B): tra due posizioni $S_i^j$ e $S_i^(j+1)$ del Livello II, calcoliamo di nuovo la distanza $overline(r_i^j)$ e distinguiamo:
    - #text(orange)[*Caso III A*] (*sparso*): se $overline(r_i^j) >= log overline(r_i^j) log r_i (log log n)^2$, memorizziamo esplicitamente le posizioni intermedie.
    - #text(orange)[*Caso III B*] (*denso*): se $overline(r_i^j) < log overline(r_i^j) log r_i (log log n)^2$, usiamo il *Four Russians Trick*: costruiamo tabelle pre-calcolate per tutti i possibili pattern di bit in questo intervallo ridotto.

  L'idea chiave è adattarsi alla densità locale:
  - zone sparse: memorizzazione esplicita
  - zone dense: sotto-campionamento ricorsivo (livelli I, II) o tabelle pre-calcolate (livello III).
]


