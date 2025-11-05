#import "../imports.typ": *

= Struttura di Rango e Selezione (Statica)

== ADT

#informalmente[
  Rank: conta gli $1$ fino alla posizione che ci interessa (senza contare la posizione stessa).

  Select: posizione massima in cui il rank è uguale al numero che ci interessa (che coincidono con le posizioni degli uni).
]

Abbiamo un vettore $underline(b) in 2^n$

$ "rank"_underline(b), "select"_underline(b): bb(N) -> bb(N) $

$ forall p <= n, quad "rank"_underline(b)(p) ) |{i | i < p, b_i = 1}| $

$ forall k <= "rank"_underline(b)(n), quad "select"_underline(b)(k) = max { p | "rank"_underline(b)(p) <= k } $

#esempio[
  ...
]

#attenzione[
  Questa è una struttura statica, ovvero non è aggiornabile, è immutabile.
  È possibile solo interrogarla.

  Esiste anche la versione dinamica, che permette di cambiare dei valori del vettore o cambiare la dimensione del vettore.
  Non vedremo questa versione (che è completamente diversa da questa).
]

Due approcci possibili:
- minimalista: il costruttore mette da parte il vettore $underline(b)$ e basta, per rank e select si scorre l'intero vettore e si calcola al volo il risultato
  $ "spazio": n, "tempo": O(n) $
- massimalista: il costruttore calcola le due tabelle di rank e select e butta via il vettore.
  Le tabelle occupano $n$ righe e ogni riga ha un valore da $0$ a $n$, quindi ogni riga occupa $log n$ bit, in totale $n log n$ ciascuna
  $ "spazio": 2 n log(n), "tempo": O(1) $

Il lower bound teorico è $n$, quindi la struttura minimalista è l'ottimo, ma è molto lenta.
La versione massimalista è veloce ma occupa molto spazio, non è nemmeno compatta.

#teorema("Proprietà")[
  $ forall k, quad "rank"("select"(k)) = k $
]

#teorema("Proprietà")[
  $ forall p, quad "select"("rank"(p)) >= p $

  In caso $b_p = 1$, allora è un uguale stretto:
  $ forall p, quad "select"("rank"(p)) = p $
]

== Struttura di Jacobson per il Rango

Vettore $underline(b)$ di $n$ bit, lo dividiamo in:
- superblocchi, ognuno di lunghezza $(log(n))^2$
- ogni superblocco è diviso in blocchi di lunghezza $1/2 log n$

Dati memorizzati per ogni superblocco:
- numero di $1$ prima dell'inizio del superblocco

Dati memorizzati per ogni blocco:
- numero di $1$ dall'inizio del superblocco fino all'inizio del blocco escluso

Con questi due dati possiamo (quasi) ricostruire il rank, manca solo il numero di $1$ dentro il blocco stesso, che vedremo dopo.

Quanto spazio occupano queste due cose?
- superblocchi: la tabella ha $n / (log_n)^2$ righe, oguna di $log n$, quindi:
  $ n / (log_n)^2 log_n = n / (log n) = o(n) $
- blocchi: la tabella ha $n / (1/2 log n)$ righe, però il numero di $1$ è limitato, quindi si possono usare meno bit per ogni riga: $log((log n)^2)$:
  $ n / (1/2 log n) 2 log log n = o(n) $

Manca solo calcolare l'ultimo pezzo mancante, ovvero quanti uni ci sono dentro quel blocco.
Ma i tipi diversi di blocco sono "abbastanza" pochi, ovvero $2^(1/2 log n)$.

Costruiamo una tabella di rank esplicita per ogni tipo di blocco. Ogni tabella è fatta: quanti uni ci sono dall'inizio del blocco fino al ogni posizione, quinid hanno $1/2 log n$ righe, e ognuna deve tenere un intero lungo $log(1/2 log n)$.

In totale per la parte di 4 russians trick:
$
  underbrace(2^(1/2 log n), "numero tabelle") underbrace(1/2 log n log (1/2 log n), "singola tabella") \
  = sqrt(n) 1/2 log n log log sqrt(n) \
  = o(n)
$

Il vettore va tenuto proprio per poter usare questo trick, per poter isolare i blocchi.

#nota[
  Jacobson usa come grandezza $1/2 log n$.
  Questo $1/2$ quando facciamo i conti diventa una radice ($n^(1/2)$).
  Quindi si potrebbe usare un qualsiasi numero $< 1$ in modo da mantenere questa funzione un $o(n)$.
]

Anche poter estrarre il blocco (quindi fare una sottosequenza del vettore originale), assumiamo si faccia in tempo costante, ma non è scontato.

#nota[
  Si può tagliare l'implementazione e tenere solo superblocchi e blocchi.

  A questo punto, senza fuor russians trick bisogna scorrere il blocco per contare gli $1$, rendendo l'accesso non più costante ma logaritmico.

  Quindi tradeoff sul tempo (comunque molto più efficiente di quella massimalista) ma molto più semplice.
]

Spazio totale utilizzato:
$ D_n = n + o(n) = Z_n + o(Z_n) $
quindi è una struttura statica succinta per il rango con accesso costante

== Generalizziamo

Abbiamo usato due cose:
- lavorare a livelli:
  tabella di poche righe di valori grandi (superblocchi), poi tabelle con valori più picocli (blocchi). per poi arrivare ad un livello molto piccolo e si può usare il four russians trick

- four russians trick:
  Questa cosa di ridurre il porblema talmente tanto da poter memorizzare tutte le possibili casi.

  Questo trick si usa molto spesso nelle strutture succinte, si chiama Trucco dei quattro russi (Four Russians Trick).

== Struttura di Clark per la Select

Se memorizzassimo la tabella intera, occuperebbe $n log n$ bit, quindi troppi.

Andiamo a memorizzare la tabella a livelli:

- I livello $P_1, ..., P_t$: memorizzo solo gli $1$ in posizioni multiple di $log n log log n$, quindi occupa (dove $t$ è il numero di $1$ nella tabella) $t / (log n log log n)$ righe, ognuna grande $log n$, quindi:
  $
    t / (log n log log n) log n \
    underbrace(<=, t <= n) n / (log n log log n) log n \
    = n / (log log n) \
    = o(n)
  $

- II livello: chiamiamo $r_i = P_(i+1) - P_i$, ovvero da differenza tra due elementi memorizzati nel primo livello.
  Per come funziona il livello I, allora: $r_i >= log n log log n$

  - Caso II A: gli $1$ tra le due posizioni sono molto sparsi:
    $ r_i >= (log n log log n)^2 $
    quindi memorizziamo esplicitamente le posizioni degli $log n log log n$ uni intermedi, come offset da $P_i$.
    Spazio occupato: questi uni intermedi sono $log n log log n$ ed ognuno è al massimo grande come $r_i$ (quindi occupa $log r_i$ bit):
    $
      (log n log log n) log r_i \
      = ((log n log log n)^2 log r_i) / (log n log log n) \
      <= (r_i log r_i) / (log n log log n) \
      <= (r_i log n) / (log n log log n) \
      ...
    $

  - Caso II B: gli uni sono densi, $ r_i < (log n log log n)^2 $
    quindi memorizziamo solo le posizioni multiple di $log r_i log log n$ (analogamente al primo livello), chiamate $S_i^0, s_i^1, ...$
    Se memorizzassimo tutto sarebbe $log n log log n$, ma dato che ne memorizziamo meno, allora abbiamo $(log n log log n) / (log r_i log log n)$ righe della tabella.
    Ognuna, dato che memorizziamo l'offset, allora ognuno è tra $0$ e $r_i$, quindi:
    $
      (log n log log n) / (log r_i log log n) log r_i \
      <= r_i / (log log n)
    $

  - Spazio occupato II livello (senza terzo livello caso II B):
    Mancano ancora degli uni intermedi, ma iniziamo a calcolare lo spazio totale: in entrambi i sottocasi, occupiamo la stessa quantità:
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
