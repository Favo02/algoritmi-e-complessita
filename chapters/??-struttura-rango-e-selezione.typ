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

In totale:
$
  underbrace(2^(1/2 log n), "numero tabelle") underbrace(1/2 log n log (1/2 log n), "singola tabella") \
  = sqrt(n) 1/2 log n log log sqrt(n) \
  = o(n)
$

Il vettore va tenuto proprio per poter usare questo trick, per poter isolare i blocchi.

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
