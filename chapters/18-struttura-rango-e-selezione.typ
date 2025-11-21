#import "../imports.typ": *

= Struttura di Rango e Selezione (Statica)

#attenzione[ 
  La versione presentata della struttura è *statica*, ovvero non è modificabile dopo la costruzione (in Java sarebbe immutabile).\
  È possibile solo interrogarla.

  Esiste anche la versione dinamica, che permette di cambiare dei valori del vettore o cambiare la dimensione del vettore.
  Non vedremo questa versione (che è completamente diversa).
]

== ADT
Definizione formale
- Input = Un vettore *$underline(b) in 2^n$*
- Primitive = *$"rank"_underline(b), "select"_underline(b): bb(N) -> bb(N)$*. Dove: 

  1. $forall p <= n, quad "rank"_underline(b)(p) =  |{i | i < p, b_i = 1}|$

  2. $forall k <= "rank"_underline(b)(n), quad "select"_underline(b)(k) = max { p | "rank"_underline(b)(p) <= k } $

#informalmente[
  La struttura presenta due primitive principali: 
  - *$"Rank(k)"$*= conta il numero di $1$ fino alla posizione che ci interessa (senza contare la posizione stessa).

  - *$"Select"(k)$*= ci dice dov'è situato il $k$-esimo uno. Ovvero la posizione massima in cui il rank è uguale al numero $k$ che ci interessa (coincidono con le posizioni degli uni).
]

#esempio[
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== VETTORE b =====
      content((-4.5, 3.2), text(size: 11pt, weight: "bold")[$underline(b)$])
      
      // Indici sopra
      for i in range(7) {
        content((-3.7 + i * 0.8, 3.8), text(size: 9pt)[#i])
      }

      // Celle del vettore
      let values = (0, 1, 1, 0, 1, 0, 1)
      for i in range(7) {
        let x = -4 + i * 0.8
        rect((x, 3), (x + 0.7, 3.5), stroke: 2pt + black, fill: white)
        content((x + 0.35, 3.25), text(size: 11pt)[#values.at(i)])
      }

      content((3, 3.8), text(size: 11pt)[$m = 4$])
    
      // ===== TABELLA RANK =====
      content((-5, 1.8), text(size: 11pt, weight: "bold")[$p$])
      content((-3.5, 1.8), text(size: 11pt, weight: "bold")[$"rank"_underline(b)(p)$])

      // Valori della tabella rank
      let rank_values = ((0, 0), (1, 0), (2, 1), (3, 2), (4, 2), (5, 3), (6, 3), (7, 4))
      
      for i in range(8) {
        let (p, rank_val) = rank_values.at(i)
        let y = 1.3 - i * 0.4
        
        content((-5, y), text(size: 10pt)[#p])
        content((-3.5, y), text(size: 10pt)[#rank_val])
        
        // Rettangolo rosso per p=7
        if i == 7 {
          rect((-5.3, y - 0.15), (-4.7, y + 0.15), stroke: 2pt + red, fill: none)
          rect((-3.8, y - 0.15), (-3.2, y + 0.15), stroke: 2pt + red, fill: none)
        }
      }

      // Freccia di esempio
      line((-4.9, -1.5), (-3.9, -1.5), stroke: 2pt + red)
      line((-4.1, -1.4), (-3.9, -1.5), stroke: 2pt + red)
      line((-4.1, -1.6), (-3.9, -1.5), stroke: 2pt + red)

      // ===== TABELLA SELECT =====
      content((1, 1.8), text(size: 11pt, weight: "bold")[$k$])
      content((2.5, 1.8), text(size: 11pt, weight: "bold")[$"select"_underline(b)(k)$])

      // Valori della tabella select
      let select_values = ((0, 1), (1, 2), (2, 4), (3, 6), (4, 7))
      
      for i in range(5) {
        let (k, sel_val) = select_values.at(i)
        let y = 1.3 - i * 0.4
        
        content((1, y), text(size: 10pt)[#k])
        content((2.5, y), text(size: 10pt)[#sel_val])
        
        // Frecce per esempi
      
        
        // Rettangolo rosso per k=4
        if i == 4 {
          rect((0.7, y - 0.15), (1.3, y + 0.15), stroke: 2pt + red, fill: none)
          rect((2.2, y - 0.15), (2.8, y + 0.15), stroke: 2pt + red, fill: none)
        }
      }

      // Freccia di esempio inversa
      line((2.3, -0.3), (1.3, -0.3), stroke: 2pt + red)
      line((1.5, -0.0), (1.3, -0.3), stroke: 2pt + red)
      line((1.5, -0.6), (1.3, -0.3), stroke: 2pt + red)

      // Note esplicative
      content((0, -2), text(size: 10pt)[
        $"rank"_underline(b)(7) = 4$. Pos immediatamente dopo la fine, conta tutti gli uni nel vettore. 
      ])
      content((0, -2.5), text(size: 10pt)[
        $"select"_underline(b)(4) = 7$ #sym.arrow.r il 4° uno è in posizione 7
      ])
    }),
    caption: [
      Esempio di funzionamento delle primitive Rank e Select sul vettore $underline(b)$.
    ]
  )
]

Esistono due approcci possibili:
- *minimalista* = Il costruttore mette da parte il vettore $underline(b)$. Per rank e select si scorre l'intero vettore e si calcola al volo il risultato
  $ "spazio": n, "tempo": O(n) $

- *massimalista* = Il costruttore calcola le due tabelle di rank e select e butta via il vettore. Le tabelle hanno $n$ righe, dove ogni riga ha un valore compreso tra $0$ e $n$. Lo spazio occupato da ogni riga è *$log n$ bit*, in totale $n log n$ ciascuna
  $ "spazio": 2 n log(n), "tempo": O(1) $

Il *lower bound teorico* è *$n$*, quindi la struttura minimalista è l'ottimo, tuttavia è molto lenta.
La versione massimalista è veloce ma occupa molto spazio, non è nemmeno compatta.

#teorema("Proprietà")[
  $ forall k, quad "rank"("select"(k)) = k $
]

#teorema("Proprietà")[
  $ forall p, quad "select"("rank"(p)) >= p $

  In caso $b_p = 1$, allora è un uguale stretto:
  $ forall p, quad "select"("rank"(p)) = p $

  #nota()[
    Questa proprietà ci permette sempre di risalire al vettore originale
  ]
]

== Struttura di Jacobson per il Rango
 
 Supponiamo che il vettore $underline(b)$ abbia dimensione $n$, con *$n$ potenza di $2$*. Partendo dal vettore $underline(b)$ esso viene diviso in:
 - *$mb("Superblocchi")$* $(log(n))^2$ = Memorizza il numero di $1$ prima dell'inizio del superblocco
 - *$mo("Blocchi")$* $1/2 log(n)$= Memorizzano il numero di $1$ dall'inizio del superblocco fino all'inizio del blocco (escluso) 





#esempio[
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== VETTORE b completo =====
      content((-6.5, 3.0), text(size: 11pt, weight: "bold")[$underline(b)$])
      
      let total_start = -6
      let total_width = 12
      
      // Etichetta lunghezza totale
      line((total_start, 4.2), (total_start + total_width, 4.2), stroke: 1.5pt + black)
      line((total_start, 4.1), (total_start, 4.3), stroke: 1.5pt + black)
      line((total_start + total_width, 4.1), (total_start + total_width, 4.3), stroke: 1.5pt + black)
      content((0, 4.5), text(size: 10pt)[$n$])

      // ===== SUPERBLOCCHI =====
      let num_superblocks = 3
      let superblock_width = total_width / num_superblocks
      
      for sb in range(num_superblocks) {
        let sb_x = total_start + sb * superblock_width
        
        // Disegna il superblocco
        rect((sb_x, 2.5), (sb_x + superblock_width, 3.5), 
             stroke: 3pt + blue, fill: none)
        
        // ===== BLOCCHI dentro ogni superblocco =====
        let num_blocks = 4
        let block_width = superblock_width / num_blocks
        
        for b in range(num_blocks) {
          let b_x = sb_x + b * block_width
          
          // Disegna il blocco
          rect((b_x, 2.5), (b_x + block_width, 3.5), 
               stroke: 1.5pt + black, fill: white)
          
          // Riempi con pattern il primo blocco del secondo superblocco
          if sb == 1 and b == 0 {
            for j in range(3) {
              line((b_x + 0.1 + j * 0.25, 2.5), (b_x + 0.1 + j * 0.25, 3.5), 
                   stroke: 1pt + gray)
            }
          }
          
          // Evidenzia un blocco specifico (secondo blocco del secondo superblocco)
          if sb == 1 and b == 1 {
            rect((b_x, 2.5), (b_x + block_width, 3.5),
                 stroke: 3pt + orange, fill: yellow.lighten(80%))
          }
        }
      }
      
      // Etichetta superblocco
      content((total_start + superblock_width/2, 3.7), 
              text(size: 9pt, fill: blue, weight: "bold")[Superblocco])
      
      // Freccia lunghezza superblocco
      line((total_start, 2.2), (total_start + superblock_width, 2.2), 
           stroke: 2pt + blue)
      line((total_start, 2.1), (total_start, 2.3), stroke: 2pt + blue)
      line((total_start + superblock_width, 2.1), 
           (total_start + superblock_width, 2.3), stroke: 2pt + blue)
      content((total_start + superblock_width/2, 1.9), 
              text(size: 9pt, fill: blue)[$(log n)^2$])

      // Freccia verso blocco evidenziato
      let highlighted_x = total_start + superblock_width + superblock_width/4
      line((highlighted_x, 2.3), (highlighted_x, 1.5), stroke: 2pt + orange)
      line((highlighted_x - 0.1, 1.7), (highlighted_x, 1.5), stroke: 2pt + orange)
      line((highlighted_x + 0.1, 1.7), (highlighted_x, 1.5), stroke: 2pt + orange)
      
      content((highlighted_x, 1.2), 
              text(size: 9pt, fill: orange, weight: "bold")[Blocco])
      content((highlighted_x, 0.8), 
              text(size: 9pt, fill: orange)[$1/2 log n$])
    }),
    caption: [
      Struttura di Jacobson per Rank.
    ]
  )
]
#nota()[
  Con le informazioni contenute nei $mb("superblocchi")$ e $mo("blocchi")$, siamo in grado di ricostruire quasi interamente il rank. Manca solamente un informazione: il numero di $1$ dentro il blocco stesso.
]

=== Spazio occupato

Quanto spazio occupano i $mb("superblocchi")$ e i $mo("blocchi")$.
- *$mb("Superblocchi")$*= La tabella ha $n / (log_n)^2$ righe, ognuna riga richiede $log n$ bit (valori che stanno in $overline(b)$), quindi:
  $ n / (log_n)^2 log_n = n / (log n) = mb(o(n)) $
- *$mo("Blocchi")$*= La tabella ha $n / (1/2 log n)$ righe, tuttavia il numero di $1$ è limitato (solo valori che stanno in un superblocco). Possono essere usati meno bit per ogni riga, $log((log n)^2)$:
  $ n / (1/2 log n) 2 log log n = mo(o(n)) $

Per completare la rappresentazione manca calcolare il numero di $1$ dall'inizio del blocco fino a una certa posizione (*offset interno al blocco*).
Tuttavia i *tipi* diversi di *blocco* sono *limitati*: 
$
  "Tipi di blocco" = 2^(1/2 log n)
$
Siccome le combinazioni sono poche, possiamo costruire una *tabella* di rank esplicita *per ogni tipo* di blocco. Le righe di ogni tabella contengono il numero di $1$ che ci sono dall'inizio del blocco fino alla fine di ogni possibile posizione. La tabella avrà la seguente dimensione:
- Numero di righe = $1/2 log n$ righe, 
- Lunghezza delle righe = ogni riga necessita di $log(1/2 log n)$ bit per rappresentare il contenuto.

Questo tipo di tecnica prende il nome di *$mg("Four-Russian-Trick")$*. In totale lo spazio occupato dalla tecnica è:
$
  underbrace(2^(1/2 log n), "numero tabelle") underbrace(1/2 log n dot log (1/2 log n), "singola tabella") \
  = underbrace(sqrt(n),"termine che cresce" \ "maggiormente") dot log(sqrt(n)) dot log (log sqrt(n)) \
  = mg(o(n))
$

#attenzione()[
  è necessario *conservare* anche il vettore *$underline(b)$* originale, per isolare i blocchi (Supponiamo si possa fare in tempo costante $->$ uso offset).
]

#nota[
  Si potrebbe tagliare l'implementazione e tenere solo $mb("superblocchi")$ e $mo("blocchi")$.

  Non usando $mg("fuor russians trick")$, è necessario scorrere il blocco per contare gli $1$, rendendo l'accesso non più costante ma logaritmico.\
  Avremo quindi un *tradeoff* sul tempo (comunque molto più efficiente di quella massimalista) ma molto più semplice.
]

Spazio *totale* utilizzato:
$ D_n = underbrace(n,"dim" underline(b)(n)) + mg(o(n)) = Z_n + o(Z_n) $
Si tratta dunque di una *struttura statica succinta per il rango* con accesso costante.

#nota()[
  L'approccio di Jacob *lavora a livelli*. Le tabelle intermedie create contengono poche righe ma i valori contenuti sono grandi. Man mano che scendiamo di "livello" (da $mb("superblocchi")$ a $mo("blocchi"))$, la grandezza dei valori decresce.\ 
  Nell'ultimo "livello", andremo ad utilizzare il *four russians trick*:
  - il problema originale è stato ridotto talmente tanto da poter memorizzare tutte le possibili casistiche (tipi di blocchi).
]

== Struttura di Clark per la Select

Anche per questa primitiva vogliamo ottenere una *struttura statica succinta per l'operazione di select* con accesso costante.

*L'implementazione Naif* consiste nel memorizzare l'intera tabella di select; spazio occupato: 
$
  underbrace(n,"numero righe") dot underbrace(log n,"taglia valori")
$  




Lo spazio occupato è troppo. Anche in questo caso sfruttiamo una tecnica che *lavora per livelli*:

- $mr("I livello")$: memorizzo solamente le posizioni $p_1, ..., p_t$, ovvero le posizioni degli $1$ in posizioni multiple di *$log(n) log(log n)$*, quindi occupa $t / (log n log log n)$ righe (dove $t$ è il numero di $1$ nella tabella). Ogni riga contiene valori che occupano $log n$ bit. Totale:
  $
    underbrace(t / (log(n) log (log n)),"# righe") dot underbrace(log n,"bit") \
    underbrace(<=, mb(t <= n)) mb(n) / (log(n) log (log n)) log n \
    = n / (log(log n)) \
    = o(n)

    #esempio()[
      Se $n = 1024$ memoriziamo solo gli $1$ nelle posisizioni multiple di $ log(1024) dot log(log(1024)) = 30-"esimo uno"$
    ]
  $

- $mb("II livello")$: andiamo a salvare delel posizioni $p_i$, ognuna delle quali indica la posizione dell'$[i log(n)log(log(n))]-"esimo"$ bit a $1$ del vettore $underline(b)$. Consideriamo ora la *differenza* tra due elementi memorizzati nel primo livello:
  $ r_i = p_(i+1) - p_i $
  Per come funziona il livello I, la successione è crescente e non può essere più bassa del multiplo: 
  $ r_i >= log (n) log(log n) $
  *$r_i = p_(i+1)-p_i$* rappresenta la *densità* degli $1$. Devo considerare due sottocasi:
  - $mb("Caso II A")$: gli $1$ tra le due posizioni sono distribuiti in modo *sparso*:
    $ r_i >= (log(n) log(log n))^2 $
    Andiamo a *memorizziare esplicitamente la tabella di select*. Spazio occupato: 
    - Righe = gli $1$ da memorizzare sono quelli intermedi offset da $P_i$: $log(n) log(log(n))$ 
    - Valori = la posizione di ogni riga occupa al massimo: $log(r_i)$ bit.
    Spazio totale:
    $
      (log(n) log(log n)) log r_i
      &= (mb((log(n) log(log n))^2) log r_i) / (log(n) log(log n)) \
      &mb("Usando" r_i >= (log(n) log(log n))^2) \
      &<= (mb(r_i) log r_i) / (log(n) log(log n)) \
      & mr("Usando" r_i <= n)\
      &<= (r_i log mr(n)) / (log (n) log( log n)) \
      &<= (r_i) / (log(log n)) \
    $

  - $mb("Caso II B")$: gli uni sono *densi*: 
    $ r_i < (log(n) log(log n))^2 $
    *memorizziamo* solamente le *posizioni multiple* di $log(r_i) log(log n)$(analogamente al primo livello). Spazio utilizzato: 
    - Righe = se memorizzassimo tutte le posizioni sarebbe $log(n) log(log n)$, ma dato che ne memorizziamo meno, allora abbiamo $(log(n) log(log n)) / (log(r_i) log(log n))$ righe.
    - Valori = i valori di ogni riga occpuano $log(r_i)$ bit.
    $
      (log(n) log(log n)) / (log(r_i) log( log n)) log r_i \
      (log(n) log(log n)) / (log(log n)) \
      
      mb("Usando" r_i <= log(n) log(log n))\
      <= r_i / (log (log n))


    $
  Calcoliamo ora lo spazio totale occupato dal $mb("II livello")$ (non contando le posizioni di alcuni uni intermedi). In entrambi i sottocasi, occupiamo la stessa quantità:
    $ sum_(i=0)^(t/(log n log log n) - 1) (P_(i+1) - P_i) / (log log n) $
    dato che è una sommatoria telescopica, allora
    $ = (P_(t/(log n log log n)) - P_0) / (log log n) $
    il numeratore è la differenza tra l'ultimo uno e il primo uno, quidi:
    $ <= n / (log log n) = o(n) $

- III livello (solo per il caso II B):
  $ r_i < (log n log log n)^2 $
  Se siamo tra $P_i$ e $P_(i+1)$ ma $r_i < (log n log log n)^2$, abbiamo memorizzato in modo esplciito solo le posisizioni $S_i^0, S_i^1, ..., S_i^((log n log log n)/(log r_i log log n))$ multiple di $log r_i log log n$

  Calcoliamo la differenza tra due posizioni $S$:
  $ overline(r_i^j) = s_i^(j+1) - s_i^j $

  + non può essere più piccola di $overline(r_i^j) >= log r_i log log n$
  + dato che siamo nel caso II B, $overline(r_i^j) <= r_i < (log n log log n)^2$

  Anche in questo livello abbiamo bisogno di distinguere in due casi:

  - Caso III A: gli uni sono sparsi: $overline(r_i^j) >= log overline(r_i^j) log r_i (log log n)^2$
    quindi memorizziamo esplicitamente le posizioni intermedie come offset da $S_i$
    Spazio occupato: dobbiamo memorizzare $log r_i log log n$ righe, oguna offset, quindi $log overline(r_i^j)$:
    $
      (log r_i log log n) log overline(r_i^j) \
      = (log r_i (log log n)^2 log overline(r_i^j)) / (log log n) \
      <= overline(r_i^j) / (log log n)
    $

  - Caso III B: $overline(r_i^j) < log overline(r_i^j) log r_i (log log n)^2$
    usiamo il four russians trick.
    Spazio occupato:

    Oss1:
    $
      log overline(r_i^j) <= log r_i \
      <= log (log n (log log n)^2) \
      = 2 log log n + 2 log log log \
      <= 4 log log n
    $

    Oss2:
    $ overline(r_i^j) < log overline(i^j) ... $

    Quindi abbiamo $ underbrace(2^overline(r_i^j), "numero tabelle") underbrace(overline(r_i^j), "righe") underbrace(log overline(r_i^j), "bit per tabella") \
    <= ...
    = o(n) $


#informalmente[
  La struttura di Clark per Select usa un approccio a **tre livelli gerarchici** per memorizzare efficientemente le posizioni degli `1`:

  *Livello I* ($mr("rosso")$): Memorizziamo solo le posizioni degli `1` multipli di $log n dot log log n$. Questo crea dei "checkpoint" sparsi che occupano poco spazio: $o(n)$.

  *Livello II* ($mb("blu")$): Tra due checkpoint consecutivi $P_i$ e $P_(i+1)$ ci sono esattamente $log n dot log log n$ bit a `1`. Calcoliamo la distanza fisica $r_i = P_(i+1) - P_i$ e distinguiamo:
  - *Caso II A* (zona sparsa): Se $r_i >= (log n dot log log n)^2$, gli `1` sono così distanti che conviene memorizzare esplicitamente tutte le loro posizioni.
  - *Caso II B* (zona densa): Se $r_i < (log n dot log log n)^2$, gli `1` sono troppo vicini. Usiamo di nuovo la tecnica del Livello I su scala ridotta: memorizziamo solo le posizioni multiple di $log r_i dot log log n$.
  
  In entrambi i sottocasi, lo spazio totale è $o(n)$ grazie alla sommatoria telescopica.

  *Livello III* ($mg("verde")$, solo per caso II B): Tra due posizioni $S_i^j$ e $S_i^(j+1)$ del Livello II, calcoliamo di nuovo la distanza $overline(r_i^j)$ e distinguiamo:
  - *Caso III A* (sparso): Se $overline(r_i^j) >= log overline(r_i^j) dot log r_i dot (log log n)^2$, memorizziamo esplicitamente le posizioni intermedie.
  - *Caso III B* (denso): Se $overline(r_i^j) < log overline(r_i^j) dot log r_i dot (log log n)^2$, usiamo il *Four Russians Trick*: costruiamo tabelle pre-calcolate per tutti i possibili pattern di bit in questo intervallo ridotto.

  L'idea chiave è **adattarsi alla densità locale**: zone sparse → memorizzazione esplicita, zone dense → sotto-campionamento ricorsivo o tabelle pre-calcolate.
]


