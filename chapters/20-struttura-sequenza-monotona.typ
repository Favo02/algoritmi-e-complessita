#import "../imports.typ": *

= Struttura Sequenza Monotona

== ADT

- *Input*: dati $n$ numeri naturali $x_0,dots,x_(n-1) in bb(N)$, con valore compreso in $[0,U)$, consideriamo una sequenza *monotona non decrescente*:
$ 0 <= x_0 <= x_1 <= ... <= x_(n-1) < underbrace(U, "universo") $
- *Primitiva*: dato un indice $i$, ottenere il valore $x_i$
- *Rappresentazione naive*: ogni intero viene memorizzato usando $log U$ bit

#informalmente[
  Le sequenze monotone sono molto utilizzate in diversi ambiti, ad esempio nel grafo di Webgraph:
  - ogni nodo viene numerato da $0$ a $U$
  - gli adiacenti di un vertice possono essere memorizzati come una sequenza monotona strettamente crescente
  - si possono scalare i valori, in modo tale da comprimere la sequenza in $[0,d]$, dove $d$ è il grado del vertice
]

== Rappresentazione quasi-succinta di Elias-Fano

#informalmente[
  Ogni numero viene diviso in parte significativa e meno significativa:
  - la parte meno significativa viene memorizzata così com'è (dato che cambia spesso e velocemente)
  - la parte più significativa cambia lentamente, quindi viene compressa. La compressione sfrutta la differenza tra la parte significativa del numero attuale e del precedente
]



L'obiettivo di Elias-Fano è bilanciare la dimensione delle due parti di #text(red)[bit significativi] e #text(blue)[meno significativi] di ogni numero per avvicinarsi all'ottimo teorico.
La rappresentazione in binario di ogni intero $x_i$ della sequenza viene divisa in:
- #text(blue)[$l$ bit meno significativi]: $ l = max(0, floor(log U/n)) "bit" $
- #text(red)[$h$ bit più significiativi]: $ h = ceil(log(U))-l "bit" $

Di queste due parti viene memorizzato:
- #text(blue)[Bit meno significativi]: vengono memorizzati così come sono, utilizzando $l$ bit per ogni $x_i$:
  $ l_i = x_i mod 2^l $
  #nota[
    Partendo da $x_i$, si può estrarre la parte meno significativa utilizzando il modulo per $2^l$.

    $x_i mod 2^l$ estrae gli ultimi $l$ bit di $x_i$ (*maschera bit a bit*).
  ]
- #text(red)[Bit più significativi]: viene memorizzata in unario la *differenza* rispetto alla parte significativa del numero precedente:
  $ u_i = floor(x_i/ 2^l) - floor(x_(i-1)/2^l) "in unario" $
  I vari $u_i$, che rappresentano i *gap* (differenze), sono tutti positivi (la minima differenza è $0$).
  Questi $u_i$ sono rappresentati in unario, ovvero $u_i$ zeri seguiti da un uno.
  #nota[
    Partendo da $x_i$, si può estrarre la parte più significativa utilizzando la divisione per $2^l$.

    $floor(x_i / 2^l)$ estrae tutti i bit tranne gli $l$ meno significativi (*shift a destra di $l$* posizioni).
  ]

#esempio[
  #figure(
    cetz.canvas(length: 1cm, {
      import cetz.draw: *

      // Parametri
      let box-height = 0.5
      let box-width = 0.8
      let spacing = 1.2
      let y-gap = 2.0

      // Input values
      let inputs = (5, 8, 8, 15, 32)
      let y-input = 4

      // Disegna label input
      content((-3, y-input + box-height / 2 - 0.5), align(right, text(size: 9pt, [
        Valori di input\
        $floor(log_2(32/5)) = 2 "bit"$\
        $U = 32, mb(l = 2)$
      ])))

      // Disegna boxes input
      for (i, val) in inputs.enumerate() {
        let x = i * spacing
        rect((x, y-input), (x + box-width, y-input + box-height), stroke: black)
        content((x + box-width / 2, y-input + box-height / 2), text(size: 10pt, str(val)))
      }

      // Binary representation
      let binary-high = ("1", "10", "10", "11", "1000")
      let binary-low = ("01", "00", "00", "11", "00")
      let y-binary = y-input - y-gap

      // Label binary
      content((-3, y-binary + box-height / 2 - 1), align(right, text(size: 9pt, [
        I bit #text(red)[significativi] sono calcolati come:
        - $u_0 = 1-0 = 1 "zeri"$
        - $u_1 = 2-1 = 1 "zeri"$
        - $u_2 = 2-2 = 0 "zeri"$
        - $u_3 = 3-2 = 1 "zeri"$
        - $u_4 = 8-3 = 5 "zeri"$
      ])))

      // Disegna boxes binary
      for (i, (high, low)) in binary-high.zip(binary-low).enumerate() {
        let x = i * spacing
        let high-w = 0.6
        let low-w = 0.3

        // High bits
        rect((x, y-binary), (x + high-w, y-binary + box-height), stroke: black, fill: rgb("#ffcccc"))
        content((x + high-w / 2, y-binary + box-height / 2), text(size: 9pt, high))

        // Low bits
        rect(
          (x + high-w + 0.08, y-binary),
          (x + high-w + 0.08 + low-w, y-binary + box-height),
          stroke: black,
          fill: rgb("#cce5ff"),
        )
        content((x + high-w + 0.08 + low-w / 2, y-binary + box-height / 2), text(size: 9pt, low))

        // Freccia input -> binary
        line((x + box-width / 2, y-input), (x + high-w / 2, y-binary + box-height), mark: (end: ">"))
      }

      // Unary representation (concatenated)
      let unary-seq = ("01", "01", "1", "01", "000001")
      let y-unary = y-binary - y-gap
      let bit-w = 0.35

      // Disegna unary bits
      let x-pos = 0
      for (j, seq) in unary-seq.enumerate() {
        let seq-w = bit-w * seq.len()
        rect((x-pos, y-unary), (x-pos + seq-w, y-unary + box-height), stroke: black, fill: rgb("#ffcccc"))
        content((x-pos + seq-w / 2, y-unary + box-height / 2), text(size: 8pt, seq))

        // Freccia verso unary
        line(
          (j * spacing + 0.3, y-binary),
          (x-pos + seq-w / 2, y-unary + box-height),
          stroke: (dash: "dashed"),
          mark: (end: ">"),
        )

        x-pos += seq-w
      }

      // Low bits concatenated
      let x-low = x-pos + 0.8
      content((x-low + 1.8, y-unary + box-height / 2), align(left, text(
        size: 8pt,
        [Bit meno significativi\ concatenati],
      )))

      x-pos = x-low
      for (j, low) in binary-low.enumerate() {
        let low-w = bit-w * low.len()
        rect((x-pos, y-unary), (x-pos + low-w, y-unary + box-height), stroke: black, fill: rgb("#cce5ff"))
        content((x-pos + low-w / 2, y-unary + box-height / 2), text(size: 8pt, low))

        // Freccia verso low bits
        line(
          (j * spacing + 0.75, y-binary),
          (x-pos + low-w / 2, y-unary + box-height),
          stroke: (dash: "dashed"),
          mark: (end: ">"),
        )

        x-pos += low-w
      }
    }),
    caption: [Rappresentazione Elias-Fano di una sequenza monotona],
  )
]

=== Spazio occupato

#nota[
  Serie telescopica:
  $
    s_n = sum_(k=1)^n A_(k+1)-A_k = A_(n+1)-A_1
  $
]

- Bit #text(blue)[meno significativi]: per ogni numero della sequenza $x_i$ con $i in 0,dots,n-1$ memorizziamo $l$ bit così come sono, di conseguenza lo spazio occupato è:
  $
    #text(blue)[$n dot l "bit"$]
  $

- Bit #text(red)[più significativi] (MSB): differenza $u_i$ di ogni numero $x_i$ in unario:
  $
    "MSB" & <= sum_(i=0)^(n-1)underbrace((u_i+1), "unario") \
          & = sum_(i=0)^(n-1) (floor(x_i/2^l)-floor((x_(i-1))/2^l)+ mr(1)) \
          & = mr(n) + underbrace(sum_(i=0)^(n-1) (floor(x_i/2^l)-floor((x_(i-1))/2^l)), mr("serie telescopica")) \
          & = n + mr(floor(x_(n-1)/2^l) - underbrace((x_(0-1))/2^l, "il primo numero"\ "parte da 0")) \
          & = n + underbrace(floor(x_(n-1)/2^l), mr(x_n < U)) \
          & <= n + floor(U/2^l) \
          & <= n + underbrace(U/2^mr(l), l = floor(log(U/n))) \
          & <= n + U/2^mr(floor(log(U/n))) \
          & <= n + U/2^mr(log(U/n)-1) \
          & = n + U/(2^(log(U/n))/2) \
          & = n + (2U)/2^(log(U/n)) \
          & = n + (2U)/(U/n) \
          & = n + (2U dot n)/U \
          & = mr(3n "bit")
  $

Spazio *totale*:
$
  D_n & = mr(3n) + mb(n l) \
      & = 3n + n floor(log(U/n)) \
      & = 2n + n ceil(log(U/n))
$

=== Risposta alle query

Per rispondere ad una query, ovvero ricostruire $x_i$ dato l'indice $i$, dobbiamo:

+ Recuperare i bit #text(red)[più significativi] dalla rappresentazione unaria:

  la sequenza unaria può essere vista come una stringa binaria dove:
  - gli *zeri* rappresentano i valori $u_i$
  - gli *uni* servono da separatori

  Per trovare i bit più significativi di *$x_i$*:
  $
    "select"_underline("MSB")(i) = underbrace(i-1, "numero di 1" \ "prima dell'"i"-esimo") + underbrace(u_0 + u_1 + ... + u_(i), "somma degli zeri" \ "prima dell'"i"-esimo 1")
  $
  La funzione $"select"_underline("MSB")(i)$ restituisce la *posizione* dell'$i$-esimo bit $1$ nella stringa unaria, ovvero:
  - il numero di $1$ visti fino ad ora: $i-1$ (gli $1$ precedenti)
  - il numero di $0$ visti fino ad ora: $u_0 + u_1 + ... + u_(i)$

  Espandendo la formula:
  $
    "select"_underline("MSB")(i) & = i-1 + sum_(j=0)^(i) mr(u_j) \
    & = i-1 + underbrace(sum_(j=0)^(i) mr(floor(x_j/2^l) - floor((x_(j-1))/2^l)), "serie telescopica") \
    & = i-1+mr(floor(x_i/2^l))
  $

  Quindi, i bit #text(red)[più significativi] sono ottenuti come:
  $
    floor(x_i/2^l) = "select"_underline("MSB")(i) - i+1
  $

+ Recuperare i bit #text(blue)[meno significativi] dalla loro posizione esplicita:
  i bit #text(blue)[meno significativi] di $x_i$ sono memorizzati esplicitamente nella posizione:
  $ "posizione" = i dot l $
  Leggiamo $l$ bit consecutivi a partire dalla posizione $i dot l$ nell'array rappresentante i bit meno significativi.

+ Combinare le due parti per ottenere il valore completo:
  $
    x_i = underbrace(("select"_underline("MSB")(i) - i+1), mr("MSB")) dot 2^l + underbrace(mb("LSB"[i dot l : (i+1) dot l]), mb("LSB"))
  $

#nota[
  Grazie alla struttura dati rank/select sui bit, possiamo calcolare $"select"_underline("MSB")(i)$ in tempo $O(1)$, rendendo l'accesso a $x_i$ molto efficiente.
]

=== È compressa?

Per stabilire se la rappresentazione proposta è compressa ci serve stimare il theoretical lower bound.

#dimostrazione[
  Dati $n$ e $U$, vogliamo contare il *numero di sequenze monotone valide*:
  $
    0 <= x_0 <= x_1 <= dots <= x_(n-1) < U
  $

  Valgono le seguenti biiezioni:
  + Una sequenza ordinata si può vedere come un *multiinsieme* (insiemi perché l'ordine non è importante dato che è sempre fissato, multi perché un intero ci può essere più volte).
    Ci interessa il numero di multiinsiemi su ${0,1,dots,U-1}$ di cardinalità $n$.

  + Un multiinsieme a sua volta può essere visto come un'*equazione* di $U$ incognite, dove ogni incognita indica quante volte compare quell'elemento.
    Vogliamo quindi trovare le soluzioni non negative dell'equazione:
    $ c_0 + c_1 + ... + c_(U-1) = n $

  + Per la tecnica *Stars and Bars*, andiamo a rappresentare l'equazione come una stringa composta da due caratteri $Sigma = ("*","|")$ (star e bar).
    Dove:
    - $"*"$ = sono in totale $n$ e rappresentano $c_i$, ovvero la cardinalità con cui un certo numero compare nella sequenza.
    - $"|"$ = $U-1$ separatori (per separare $U$ bucket)

    #informalmente[
      Le barre rappresentano la separazione tra i vari bucket.
      Dentro ogni bucket ci possono essere $0$ o più elementi (le star).

      Ad esempio $"*|**||*"$ rappresenta 1 elemento di tipo $0$, 2 elementi di tipo $1$, 0 elementi di tipo $2$ e 1 elemento di tipo $3$.
      Nel nostro caso il multiinsieme ${0, 1, 1, 3}$.

      Fissando il numero di $"*"$, si fissa $n$, ovvero la cardinalità dell'insieme, ovvero la lunghezza della sequenza monotona.
    ]

    Le stringhe così create avranno una lunghezza pari a $underbrace(U-1, "bars") + underbrace(n, "stars")$.
    Andare a contare tutte le *permutazioni* di questa stringa è come calcolare il numero di multiinsiemi quindi il numero di sequenze:
    $
      underbrace(binom(U+n-1, U-1), "disposizioni delle" \ "barre") & = (U+n-1)! / ((U-1)!((U+n-1) - (U-1))!) \
      & = ((U+n-1)!) / ((U-1)! (n)!) = underbrace(binom(U+n-1, n), "disposizioni degli" \ "asterischi")
    $

  In conclusione:
  $ Z_n = log(binom(U+n-1, n)) $
  Applicando la proprietà:
  $
    log binom(A, B) approx B log (A/B) + (A-B) log (A / (A-B))
  $
  con $mr(A = U+n-1)$ e $mb(B = n)$, otteniamo:
  $
    Z_n & approx mb(n) log (mr(U+n-1))/mb(n) + (mr(U+n-1)-mb(n)) log (mr(U+n-1))/(mr(U+n-1)-mb(n)) \
        & = n log((U+n-1)/n) + (U-1) log((U+n-1)/(U-1))
  $

  Assumiamo che $n << U$, ovvero che il numero di elementi è molto più piccolo dell'universo (cosa molto realistica).
  $
    & = n log((U+n-1)/n) + (U-1) log(underbrace((U+n-1)/(U-1), mb(approx 1))) \
    & approx n log((U+n-1)/n)+(U-1)underbrace(log(1), =0) \
    & approx n underbrace(log((U+n-1)/n), "raccogliamo" mb(U/n)) \
    & = n log(mb(U/n) dot (1+n/U-1/U)) \
    & = n log(U/n)+n underbrace(log(1+n/U-1/U), mb(log(1+x) approx x)) \
    & approx n log U/n + n (mb(n/U - 1/U)) \
    & approx n log U/n + underbrace(mb((n^2)/U), n^2 << U -> approx 0) \
    & approx n log U/n
  $
  #nota[
    L'assunzione che $n << U$ è realistica. Ad esempio consideriamo $n$ come le amicizie di un utente su Facebook e $U$ come il numero di utenti di Facebook.
  ]

  In conclusione:
  $
    Z_n approx n log (U/n)
  $

  Dato che la nostra struttura dati occupa:
  $ D_n approx underbrace(3n, o(Z_n)) + underbrace(n ceil(log U/n), Z_n) $
  allora abbiamo una *struttura succinta* $space qed$.

  #attenzione[
    Da un punto di vista teorico, abbiamo fatto i conti con delle assunzioni ($n << U$) e approssimazioni, non è sempre vero che la struttura è succinta.
    Tuttavia nella pratica lo è, dato che molto raramente accade che $n -> U$.
  ]
]

