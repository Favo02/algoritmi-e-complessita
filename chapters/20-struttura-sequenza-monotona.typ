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
Dove *$u_i$* è il *numero di zeri* della rappresentazione in unario, essi saranno *seguiti da un $1$*. Tale differenza è al minimo zero (sequenza non decrescente).

#nota()[
  $floor(x_i/ 2^l)$, prende tutti i bit tranne gli $l$ meno significativi, *shift a destra di $l$* posizioni.  
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

#nota()[
  Serie telescopica: 
  $
    s_n = sum_(k=1)^n A_(k+1)-A_k = A_(n+1)-A_1
  $
]

- bit $mb("meno significativi")$.
  Per ogni numero della sequenza $x_i$ con $i in 0,dots,n-1$ memorizziamo $l$ bit cosi come sono, di conseguenza lo spazio occupato è: 
  $
    mb(n dot l "bit")
  $

- bit $mr("più significativi")$. Scriviamo gli MSB di ogni numero $x_i$ in unario, dove $u_i$ è il numero di zeri: 
$
  H &<= sum_(i=0)^(n-1)abs(u_i+1) \
    &= sum_(i=0)^(n-1) abs(floor(x_i/2^l)-floor((x_i-1)/2^l)+ mr(1))\
    &= underbrace(mr(n),"i vari 1" \ "si sommano") + sum_(i=0)^(n-1) abs(floor(x_i/2^l)-floor((x_i-1)/2^l))\
    & mb("Serie telescopica")\
    &= n + mb(floor(x_(n-1)/2^l)- underbrace((x_0-1)/2^l,=0))\
    &= n + floor(x_(n-1)/2^l)\
    & mb("Al massimo" x_n "ha valore" U)\
    &<= n + floor(U/2^l)\
    &<= n + U/2^mb("l") \
    & mb("Ricordando che" l = floor(log(U/n)))\
    &<= n + U/2^mb(floor(log(U/n)))\
     &mb("Suppongo che" U/n "non sia potenza di 2")\
    &<= n + U/2^mb(log(U/n)-1)\
    &= n + U/(2^(log(U/n))/2)\
    &= n + (2U)/2^(log(U/n))\
    &= n + (2U)/(U/n)\
    &= n + (2U dot n)/U\
    &= mr(3n "bit")
$
Costo *totale*: 
$
  D_n &= mr(3n)+mb(n l)\
      &= 3n + n floor(log(U/n))\
      &= n dot (2+floor(log(U/n)))
$

=== Risposta alle query

Per rispondere ad una query, ovvero ricostruire $x_i$ dato l'indice $i$, dobbiamo:

1. Recuperare i bit $mr("più significativi")$ dalla rappresentazione unaria
2. Recuperare i bit $mb("meno significativi")$ dalla loro posizione esplicita
3. Combinare le due parti per ottenere il valore completo

==== Trovare bit più significativi

Trovare i bit $mr("più significativi")$.
La sequenza unaria può essere vista come una stringa binaria dove:
  - Gli $mr("zeri")$ rappresentano i valori $u_i$
  - Gli $mr("uni")$ servono da separatori

  Per trovare i bit più significativi di *$x_i$*:
  $
  "select"_underline(b)(i) = underbrace(i-1,"numero di 1" \ "prima dell' "i"-esimo") + underbrace(u_0 + u_1 + ... + u_(i-1),"somma degli zeri" \ "prima dell' "i"-esimo 1")
  $

#nota()[
  La funzione $"select"_underline(b)(i)$ restituisce la *posizione* dell'$i$-esimo bit $1$ nella stringa unaria.
  
  Questa posizione codifica:
  - Il numero di $1$ visti fino ad ora: $i-1$ (gli $1$ precedenti)
  - Il numero di $0$ visti fino ad ora: $u_0 + u_1 + ... + u_(i-1)$
]
Espandendo la formula:
$
  "select"_underline(b)(i) &= i-1 + sum_(j=0)^(i-1) mb(u_j)\
                           &= i-1+sum_(j=0)^(i-1) mb(floor(x_j/2^l) - floor((x_j-1)/2^l))\
                           &= mb("Serie telescopica")\
                           &= i-1+mb(floor(x_i/2^l))                    
$
Alla fine, i bit $mr("più significativi")$ sono ottenuti come: 
$
  floor(x_i/2^l) = "select"_underline(b)(i) - i+1                
$

==== Trovare bit meno significativi
I bit $mb("meno significativi")$ di $x_i$ sono memorizzati esplicitamente nella posizione:
$
"posizione" = i dot l
$
Leggiamo $l$ bit consecutivi a partire dalla posizione $i dot l$ nell'array rappresentante i bit meno significativi.

==== Ricostruzione completa

Il valore finale è:
$
x_i = underbrace(("select"_underline(b)(i+1) - i), mr("MSB")) dot 2^l + underbrace(mb("LSB"[i dot l : (i+1) dot l]), mb("LSB"))
$

Dove $mb("LSB"[i dot l : (i+1) dot l])$ indica i bit dalla posizione $i dot l$ alla posizione $(i+1) dot l - 1$ nella stringa dei bit meno significativi.

#nota()[
  Grazie alla struttura dati rank/select sui bit, possiamo calcolare $"select"_underline(b)(i)$ in tempo $O(1)$, rendendo l'accesso a $x_i$ molto efficiente.
]

=== È succinta?
Per stabilire se la rappresentazione proposta è succinta ci serve stimare il theoretical lower bound.

Dati $n$ e $U$, vogliamo contare il *numero di sequenze monotone valide*: 
$
  0 <= x_0 <= x_1 <= dots <= x_(n-1) < U
$
Valgono inoltre le seguenti biiezioni: 
1. Una sequenza ordinata si può vedere come un *multiinsieme* (insiemi perchè l'ordine è fissato, multi perchè un intero ci può essere più volte). Vogliamo stabilire il numero di multiinsiemi su ${0,1,dots,U-1}$ di cardinalità $n$.

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
