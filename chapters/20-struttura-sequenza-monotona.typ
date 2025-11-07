#import "../imports.typ": *

= Elias-Fano per le Sequenze Monotone

== ADT

- *Input*: dati $n$ numeri naturali $x_1,dots,x_(n-1) in bb(N)$, con valore compreso in $[0,U)$, consideriamo una sequenza *monotona non decrescente*:
$ 0 <= x_0 <= x_1 <= ... <= x_(n-1) < underbrace(U,"universo") $

- *Primitiva di accesso*: c'è una sola primitiva d'accesso: dato $i$, vogliamo sapere $x_i$

Rappresentazione naive: ogni intero viene scritto usando $log U$ bit.

#informalmente[
  Le sequenze monotone sono utilizzate in diversi ambiti

  Webgraph: 
  - Ogni nodo viene numerato da $o$ a $U$
  - I vicini di un vertice possono essere memorizzati come una sequenza monotona strettamente crescente
  - Si possono scalare i valori per un fattore $k$, in modo tale da comprimere l'intervallo da $[0,d]$, dove $d$ è il grado del vertice

  Documenti e indici per l'interrogazione
]

== Rappresentazione quasi-succinta di Elias-Fano

La rappresentazione in binario di ogni intero $x_i$ della sequenza viene diviso in $mr("bit significativi")$ e $mb("meno significativi")$.

Bit *$mb("meno significativi")$*. $l_0,dots,l_(n-1)$, essi vengono rappresentati esplcitamente : 
$ l = max(0,floor(log U/n)) $
Dove:
- $l_0 = x_0 mod 2^l$
- $l_1 = x_1 mod 2^l$
- $dots$
- $l_(n-1) = x_(n-1) mod 2^l$

#nota()[
  $x_i mod 2^l$, prende gli ultimi $l$ bit di $x_i$ (*maschera bit a bit*)
]

Bit *$mr("più significativi")$*. $u_0,dots,u_(n-1)$, essi vengono rappresentati esplicitamente in unario:
$ u_i = floor(x_i/ 2^l) - floor(x_(i-1)/2^l) $
Dove *$u_i$* è il *numero di zeri* della rappresentazione in unario, essi saranno *seguiti da un $1$*.

#nota()[
  $floor(x_i/ 2^l)$, prende tutti i bit tranne gli $l$ meno significativi, *shit a destra di $l$* posizioni.  
]

#import "../imports.typ": *

// ...existing code...

#esempio()[
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
      content((-3, y-input + box-height/2), align(right, text(size: 9pt, [
        Valori di input\
        $floor(log_2(32/5)) = 2 "bit"$\
        $U = 32, mb(l = 2)$
      ])))
      
      // Disegna boxes input
      for (i, val) in inputs.enumerate() {
        let x = i * spacing
        rect((x, y-input), (x + box-width, y-input + box-height), stroke: black)
        content((x + box-width/2, y-input + box-height/2), text(size: 10pt, str(val)))
      }
      
      // Binary representation
      let binary-high = ("1", "10", "10", "11", "1000")
      let binary-low = ("01", "00", "00", "11", "00")
      let y-binary = y-input - y-gap
      
      // Label binary
      content((-3.5, y-binary + box-height/2), align(right, text(size: 8pt, [
        I bit $mr("significativi")$ sono calcolati come:
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
        content((x + high-w/2, y-binary + box-height/2), text(size: 9pt, high))
        
        // Low bits
        rect((x + high-w + 0.08, y-binary), (x + high-w + 0.08 + low-w, y-binary + box-height), stroke: black, fill: rgb("#cce5ff"))
        content((x + high-w + 0.08 + low-w/2, y-binary + box-height/2), text(size: 9pt, low))
        
        // Freccia input -> binary
        line((x + box-width/2, y-input), (x + high-w/2, y-binary + box-height), mark: (end: ">"))
      }
      
      // Unary representation (concatenated)
      let unary-seq = ("01", "01", "1", "01", "000001")
      let y-unary = y-binary - y-gap
      let bit-w = 0.35
      
      // Disegna unary bits
      let x-pos = 0
      for (j, seq) in unary-seq.enumerate() {
        let seq-w = bit-w * seq.len()
        rect((x-pos, y-unary), (x-pos + seq-w, y-unary + box-height), 
             stroke: black, fill: rgb("#ffcccc"))
        content((x-pos + seq-w/2, y-unary + box-height/2), text(size: 8pt, seq))
        
        // Freccia verso unary
        line((j * spacing + 0.3, y-binary), (x-pos + seq-w/2, y-unary + box-height), 
             stroke: (dash: "dashed"), mark: (end: ">"))
        
        x-pos += seq-w
      }
      
      // Low bits concatenated
      let x-low = x-pos + 0.8
      content((x-low + 1.8, y-unary + box-height/2), align(left, text(size: 8pt, [Bit meno significativi\ concatenati])))
      
      x-pos = x-low
      for (j, low) in binary-low.enumerate() {
        let low-w = bit-w * low.len()
        rect((x-pos, y-unary), (x-pos + low-w, y-unary + box-height), 
             stroke: black, fill: rgb("#cce5ff"))
        content((x-pos + low-w/2, y-unary + box-height/2), text(size: 8pt, low))
        
        // Freccia verso low bits
        line((j * spacing + 0.75, y-binary), (x-pos + low-w/2, y-unary + box-height), 
             stroke: (dash: "dashed"), mark: (end: ">"))
        
        x-pos += low-w
      }
    }),
    caption: [Rappresentazione Elias-Fano di una sequenza monotona]
  )
]


=== Spazio occupato
- lwoer bit: $ln$
- upper bit: $<= sum_(i=0)^(n-1) (u_i + 1) = ... <= n + floor(U/2^l) <= n + U / 2^floor(log U/n) ... = 3n$

In totale: $ D_n = ln + 3n = 3n + n floor(log U/n) $

Ma come rispondiamo alla query (ovvero come ricostruiamo l'intero)?

quando facciamo $ "select"_underline(b)(i) = i-1 + u_0 + u_1 + ... u_(i-1) $

Quindi la parte più significativa del numero è: $"select"_underline(b)(i) - i + 1$, poi la parte meno significativa è memorizzata esplicicamente

=== È succinta?

Ci serve conoscere il theoretical lower bound, per poter capire se è succinta o meno.

Quinid, dati $n$ e $U$, dobbiamo sapere quante sono le sequenze monotone valide.

Una sequenza ordinata si può vedere come un multiinsieme (insiem perchè l'ordine è fissato, multi perchè un intero ci può essere più volte).
Quindi il numero di multiinsiemi di cardinalità $n$.

Un altro modo è trovare il numero di soluzioni intere non negative dell'equazione $c_0 + c_1 + ... + c_(u-1) = n$ (ovvero contare quante volte appare ogni elemento).

Un altro modo è rappresentare con una stringa stars & bars `***|||***|**||***` con $n$ asterischi e $U-1$ barre (quindi dire la cardinalità di ogni elemento con asterischi, separanzo ongi elemento con delle barre).
Tutte queste stringhe sono di lunghezza $U+n-1$, ma sappiamo anche quante sono le barre, quindi sappiamo in quanti modi possiamo costruire queste stringhe:
- $binom(U-n-1, U-1) = (U-n-1)! / (n! (U-1)!)$ scegliendo dove mettere le barre
- $binom(U-n-1, n)$ sceglieno dove mettere gli asterischi (i due risultati sono uguali!)

Quindi $Z_n = log(binom(U+n-1, n))$

Applicando la formula $log binom(A, B) approx B log (A/B) + (A-B) log (A / (A-B))$ con $A = U+n-1$ e $B = n$

$ Z_n approx n log (U+n-1)/n + (U-1) log underbrace((U+n-1)/(U-1), approx 1) $

Noi assumiamo che $n << U$, ovvero che il numero di elementi della sequenza sia molto più piccolo rispetto al limite dell'universo.
Questa cosa è ragionevole, ad esempio nel caso d'uso webgraph, il numero di link di una pagina sono molto molto molto meno rispetto al numero di pagine dell'intero web.

Raccogliendo $U/n$
$
  approx n log (U+n-1)/n = n log (U/n (1 + n/U - 1/U)) \
  = n log U/n + n log (1 + mr(n/U - 1/U))
$

Dato che $x approx log (1+mr(x))$
$ approx n log U/n + (n^2)/U $

Assumendo ancora che $n^2 << U$ (ancora ragionevole, i link di una pagina sono una decina, rispetto ai miliardi di pagine del web):
$ approx n log (U/n) $

Dato che la nostra struttura dati occupa:
$ D_n approx 3n + n ceil(log U/n) $
allora abbiamo una struttura succinta.

Però abbiamo fatto i conti con delle assunzioni e approssimazioni, non è sempre vero che è succinta.
Nella pratica però lo è (dato che molto raramente $n -> U$).

#nota[
  Per sapere se una struttura è succinta, ci serve il theoretical lower bound.
  Ma spesso è questa la parte difficile di dimostrare, dato che è difficile trovarlo e calcolarlo.
]
