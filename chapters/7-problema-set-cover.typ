#import "../imports.typ": *

= Problema Set Cover [NPOc]

#informalmente[
  Esiste un universo di $n$ _punti_.
  Questi punti sono coperti da $m$ _aree_, ognuna avente un _costo_.
  Le aree possono sovrapporsi (non sono una partizione).

  L'obiettivo è comprare un insieme di aree, tale che tutti i punti siano coperti, minimizzando il costo totale.
]

- *$I_Pi$*:
  - $S_1, S_2, ..., S_m subset.eq 2^Omega, quad limits(union.big)_(i=1)^m S_i = Omega, quad |Omega| = n$: insiemi delle aree che unite coprono tutto l'universo (possono anche sovrapporsi)
  - $w_1, w_2, ..., w_m in bb(Q)^+$: costi delle aree
- *$"Amm"_Pi$* $= I subset.eq {1, ..., m}, quad limits(union.big)_(i in I) S_i = Omega$: un insieme di indici di aree che coprono tutti i punti
- *$C_Pi$*: somma dei costi delle aree selezionate
  $ w = sum_(i in I) w_i $
- *$t_Pi = min$*

#esempio[
  Esempio con $n=6$ punti e $m=4$ aree:
  - $Omega = {s_1, s_2, s_3, s_4, s_5, s_6}$
  - $S_1 = {s_1, s_2, s_4}$ con costo $w_1 = 3$
  - $S_2 = {s_3, s_5, s_6}$ con costo $w_2 = 4$
  - $S_3 = {s_4, s_5}$ con costo $w_3 = 2$
  - $S_4 = {s_5, s_6}$ con costo $w_4 = 5$

  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Disegna i punti
      let points = ((1.5, 4), (3, 4.5), (5, 4), (2, 2.5), (4.5, 2), (6.5, 3))
      for (i, pt) in points.enumerate() {
        circle(pt, radius: (0.1, 0.1), fill: black)
        content((pt.at(0) + 0.3, pt.at(1) + 0.2), text(size: 10pt, $s_#(i + 1)$))
      }

      // Area S₁ (ellisse blu)
      circle((2.25, 3.75), radius: (1.8, 1.5), stroke: blue, fill: blue.transparentize(80%))
      content((0, 4.8), text(size: 11pt, fill: blue, $S_1$))
      content((0, 4.3), text(size: 9pt, fill: blue, $w_1 = 3$))

      // Area S₂ (ellisse verde)
      circle((4.75, 3.25), radius: (2.2, 1.5), stroke: green, fill: green.transparentize(80%))
      content((7.4, 4.2), text(size: 11pt, fill: green, $S_2$))
      content((7.4, 3.7), text(size: 9pt, fill: green, $w_2 = 4$))

      // Area S₃ (rettangolo arancione)
      rect((1.5, 1.8), (5.5, 3.2), stroke: orange, fill: orange.transparentize(80%))
      content((1, 2.0), text(size: 11pt, fill: orange, $S_3$))
      content((1, 1.5), text(size: 9pt, fill: orange, $w_3 = 2$))

      // Area S₄ (ellisse rossa)
      circle((5.75, 2.5), radius: (1.6, 1.3), stroke: red, fill: red.transparentize(80%))
      content((7.5, 1.9), text(size: 11pt, fill: red, $S_4$))
      content((7.5, 1.4), text(size: 9pt, fill: red, $w_4 = 5$))
    }),
    caption: [Esempio di Set Cover],
  )

  Una soluzione ammissibile potrebbe essere $I = {1, 2, 4}$ con costo totale $w = 3 + 4 + 5 = 12$.
  La soluzione ottima è $I^* = {1, 2}$ con costo $w^* = 3 + 4 = 7$.
]

#teorema("Teorema")[
  *$ "SetCover" in "NPOc" $*
]

== Funzione Armonica

#nota[
  Per mostrare alcune proprietà di Set Cover, abbiamo bisogno di introdurre la funzione armonica.
]

Funzione armonica:
$ H : bb(N)^+ -> bb(R) $
$ H(n) = sum_(i=1)^n 1/i $

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Imposta gli assi
    let x-min = 0
    let x-max = 7
    let y-min = 0
    let y-max = 2.5

    // Disegna gli assi
    line((x-min, 0), (x-max, 0), stroke: black + 0.8pt, mark: (end: ">"))
    line((0, y-min), (0, y-max), stroke: black + 0.8pt, mark: (end: ">"))

    // Etichette assi
    content((x-max - 0.1, -0.08), text(size: 10pt, $x$))
    content((-0.15, y-max - 0.05), text(size: 10pt, $y$))

    // Area sotto la curva (da x=1 a x=n)
    let n = 5
    let area-points = ()
    area-points.push((1, 0))
    for i in range(0, 100) {
      let x = 1 + (n - 1) * i / 99
      let y = 1 / x
      area-points.push((x, y))
    }
    area-points.push((n, 0))
    area-points.push((1, 0))

    // Riempi l'area sotto la curva
    line(..area-points, stroke: none, fill: blue.transparentize(80%))

    // Disegna la curva y = 1/x (inizia da x=1 per evitare divisione per 0)
    let curve-points = ()
    for i in range(-7, 80) {
      let x = 1 + (x-max - 1) * i / 79
      let y = 1 / x
      curve-points.push((x, y))
    }

    line(..curve-points, stroke: blue + 1.5pt)
    content((6, 1), text(size: 11pt, fill: blue, $f(x) = 1/x$))

    // Disegna i rettangoli per H(n) con n=5
    for i in range(1, n + 1) {
      let x-left = i - 1
      let x-right = i
      let height = 1 / i

      if i < n {
        // Rettangolo traslato
        rect(
          (x-left + 1, 0),
          (x-right + 1, height),
          stroke: (paint: green, dash: "dashed"),
          fill: green.transparentize(90%),
        )
      }

      // Rettangolo riempito
      let color = if i == 1 { red } else { orange }
      rect((x-left, 0), (x-right, height), stroke: color + 1pt, fill: color.transparentize(70%))

      // Etichetta con l'altezza
      content((x-left + 0.5, -0.5), text(size: 9pt, fill: color, $1/#i$))
    }

    // Etichette sull'asse x
    for i in range(0, n + 1) {
      content((i, -0.2), text(size: 9pt, $#i$))
      line((i, -0.02), (i, 0.02), stroke: black + 0.5pt)
    }
  }),
  caption: [Rappresentazione grafica della funzione armonica, somma dell'area dei rettangoli arancioni e rossi sotto la curva],
)

#teorema("Proprietà")[
  La funzione armonica è superiormente limitata da $1 +$ il logaritmo naturale di $n$:
  $ H(n) <= 1 + ln n $

  #dimostrazione[
    $
      H(n) & <= 1 + integral_1^n 1/x "dx" \
           & <= 1 + [ ln x ]_1^n \
           & <= 1 + ln n - ln 1 \
           & <= 1 + ln n space qed
    $

    #informalmente[
      L'integrale di $1/x$ è l'area sotto la curva blu, a partire da 1.
      Questa area è ovviamente superiore alle aree dei rettangoli arancioni (dato che manca la parte colorata di blu).

      Manca solo il primo rettangolo rosso, motivo per cui si somma $1$.
    ]
  ]
]

#teorema("Proprietà")[
  La funzione armonica è inferiormente limitata dal logaritmo naturale di $n+1$:
  $ ln(n+1) <= H(n) $

  #dimostrazione[
    $
      underbrace(integral_t^(t+1) 1/t "dt" = 1/t, "area del rettangolo verde") quad &>= quad underbrace(integral_t^(t+1) 1/x "dx", "area sotto la curva blu") \
      underbrace(H(n) = 1/1 + 1/2 + ... 1/n, "rettangoli") quad &>= quad underbrace(integral_1^2 1/x "dx" + integral_2^3 1/x "dx" + ... integral_n^(n+1) 1/x "dx", "curve") \
      H(n) quad &>= quad integral_1^(n+1) 1/x "dx" = [ln x]_1^(n+1) = ln (n+1) \
      H(n) quad &>= quad ln (n+1) space qed
    $

    #informalmente[
      Fissando la variabile di integrazione $t$, allora stiamo calcolando l'area di un rettangolo, nello specifico dei rettangoli tratteggiati verdi.

      Dato che l'estremo è quello sinistro e che la funzione decresce, allora il rettangolo (tratteggiato verde) sarà più grande della curva (blu) sottostante.
    ]
  ]
]

#teorema("Proprietà")[
  Mettendo insieme le due proprietà, la funzione armonica è racchiusa:
  $ ln(n+1) <= H(n) <= 1+ln(n) $
]

== Algoritmo PricingSetCover

#pseudocode(
  [$R <- Omega$ #emph("// punti ancora da coprire")],
  [$I <- emptyset$ #emph("// aree selezionate")],
  [*While* $R != emptyset$],
  indent(
    [$i <-$ choose $in {1, ..., m} \\ I$ minimizing $w_i / (|S_i inter R|)$ #emph("// seleziona area che minimizza il prezzo")],
    [$I <- I union {i}$],
    [$R <- R \\ S_i$],
  ),
  [*Output* $I$],
  [*End*],
)

Durante l'esecuzione abbiamo utilizzato un *prezzo* (_pricing_).
Questo valore è definito *solo all'istante* in cui il punto sta *venendo coperto* da un'area $S_i$.
Per ogni punto $s$, definiamo il suo prezzo $c_s$ come il rapporto tra il _costo_ di un'area e il numero di punti non ancora coperti dell'area:
$ forall s in S_i inter R, quad c_s = w_i / (|S_i inter R|) $

#attenzione[
  Differenziamo:
  - *costo*: costo pagato per selezionare un'area, non varia durante l'esecuzione
  - *prezzo*: rapporto tra il _costo_ di un'area e il numero di punti non ancora coperti dell'area, cambia durante l'esecuzione (dato che il numero di punti non coperti di una certa area potrebbe diminuire) ed è definito solo nell'istante in cui un punto sta venendo coperto
]

#nota[
  L'algoritmo utilizza il prezzo su un'_area_, mentre lo abbiamo definito su un _punto_.
  Ma *tutti* i punti di una certa area, allo stesso istante, hanno lo *stesso prezzo*, di conseguenza minimizzare il rapporto per un'area o per un punto è equivalente.
]

#teorema("Teorema")[
  Il costo totale pagato $w$, è uguale alla somma dei prezzi di tutti i punti.
  $ w = sum_(s in Omega) c_s $

  #nota[
    Ricordiamo che il prezzo di un punto è definito solo nell'_istante_ in cui viene coperto da un'area, quindi il valore di $c_s$ non è ambiguo.
  ]

  #dimostrazione[
    Il costo totale pagato è, per definizione, la somma delle aree selezionate:
    $ w = sum_(i in I) mr(w_i) $

    Ma il costo di ogni area non è altro che la somma dei prezzi dei punti contenuti:
    $ = sum_mb(i in I) mr(sum_mb(s in S_i inter R) c_s) $

    #esempio[
      Se un'area $S$ costa $10$ e ha $5$ punti (non ancora coperti), allora il prezzo di ogni punto sarà $c_s = 10 / 5 = 2$. Sommandolo per ogni punto $limits(sum)_(s in S) c_s = 5 dot 2 = 10$.

      Nel caso in cui la stessa area avesse un punto già coperto (quindi $|S inter R| = 4$), allora funzionerebbe lo stesso:
      $c_s = 10 / 4 = 2.5, quad limits(sum)_(s in S) c_s = 4 dot 2.5 = 10$.
    ]

    Ma scorrere per ogni area $mb(i in I)$ tutti i punti non ancora presi $mb(s in S_i inter R)$, equivale a scorrere tutti i punti dell'universo $mg(s in Omega)$ (dato che per essere ammissibile una soluzione $I$ deve coprire tutti i punti):
    $ w = sum_(i in I) w_i = sum_(i in I) sum_(s in S_i inter R) c_s = mg(sum_(s in Omega) c_s) space qed $
  ]
] <teorema-somma-costi-totale-pagato>

#teorema("Teorema")[
  Per ogni area, la somma dei prezzi dei punti contenuti (nell'istante in cui sono stati coperti) è limitata superiormente dalla funzione armonica:

  $ forall k in m, quad sum_(s in S_k) c_s <= H(|S_k|) dot w_k $

  #attenzione[
    Dato che i prezzi dei punti contenuti cambiano durante l'esecuzione, i vari punti potrebbero avere prezzi diversi quando sono stati coperti.
  ]

  #dimostrazione[
    Senza perdita di generalità (vale per ogni $k$), scegliamo un $k in m$.

    L'area $mb(S_k)$ ha cardinalità $d$ ed è composta dai punti:
    $ S_k = {s_1, s_2, ..., s_d} $

    Questi punti sono ordinati _(a blocchi)_ in ordine di copertura, ovvero $s_i$ è stato coperto prima (o allo stesso istante) di $s_(i+1) space forall i in d$.
    $
      S_k = {
        underbrace(s_1\, s_2\, s_3, "coperti" \ "all'istante" f),
        underbrace(s_4\, s_5, f' > f),
        underbrace(s_6\, s_7\, s_8\, s_9, f'' > f'),
        underbrace(s_10, f''' > f'')
      }
    $

    Per ogni $j in {1, ..., d}$, ci sarà un'iterazione in cui viene scelta un'area $mr(S_overline(k))$ che copre $s_j$. In questo istante:
    - tutti i blocchi prima di $j$ sono stati *già coperti*
    - il blocco $j$ sta venendo coperto _(*non* lo è ancora)_
    - tutti i blocchi  dopo $j$ devono essere *ancora* coperti

    Quindi l'insieme dei punti ancora da coprire, contiene _almeno_ tutti i punti dopo $s_j$:
    $ R supset.eq {s_j, ..., s_d} $

    Il numero di punti dell'area ancora da coprire è quindi almeno il numero di punti da $s_j$ in poi:
    $ |S_k inter R| >= d-j+1 $ <set-cover-punti-da-coprire-sj>
    #nota[
      Non è $=$ ma è $>=$ dato che potrebbero esserci dei punti prima di $j$ appartenenti allo stesso _gruppo_, che vengono coperti allo stesso istante di $s_j$.
    ]

    Dato che l'algoritmo greedy sceglie prima l'area $mr(S_overline(k))$ che l'area $mb(S_k)$ (se così non fosse, non potrebbe esistere un istante in cui viene coperto il punto $s_j$ da $S_overline(k)$ dato che sarebbe già coperto da $S_k$), allora il prezzo (il rapporto) della prima deve essere più piccolo della seconda.
    Ma il prezzo dell'area $mr(S_overline(k))$ non è altro che il prezzo di $c_s_j$:
    $ c_s_j = mr(w_overline(k) / (|S_overline(k) inter R|)) <= mb(w_k / (|S_k inter R|)) $

    Per #link-equation(<set-cover-punti-da-coprire-sj>), $mg(|S_k inter R|) >= mp(d-j+1)$, quindi:
    $ c_s_j <= w_k / mg(|S_k inter R|) <= w_k / mp(d-j+1) $

    Dato che questo ragionamento vale per ogni $j$ e, ricordando che $mm(|S_k| = d)$:
    $
      sum_mm(s in S_k) c_s & <= sum_mm(j=1)^mm(d) w_k / (d-j+1) \
                           & <= w_k sum_(j=1)^d 1 / (d-j+1) \
                           & <= w_k (1/d + 1/(d-1) + ... + 1/1 ) \
                           & <= w_k H(d) \
                           & <= w_k H(|S_k|) space qed
    $
  ]
] <teorema-somma-prezzi-funzione-armonica>

#teorema("Teorema")[
  L'algoritmo $"PricingSetCover"$ è una *$H(M)$-approssimazione*, dove $M$ è la cardinalità massima di un'area, $M = limits(max)_k |S_k|$.

  #dimostrazione[
    Riscrivendo il #link-teorema(<teorema-somma-prezzi-funzione-armonica>):
    $
      forall k, quad w_k dot H(|S_k|) & underbrace(>=, #link-teorema(<teorema-somma-prezzi-funzione-armonica>)) sum_(s in S_k) c_s \
      w_k & >= (limits(sum)_(s in S_k) c_s) / H(|S_k|)
    $
    Dato che $M$ è definito come il massimo di tutte le cardinalità, allora:
    $
      forall k, quad mr(w_k) & >= (limits(sum)_(s in S_k) c_s) / H(|S_k|) >= mr((limits(sum)_(s in S_k) c_s) / H(M))
    $ <set-cover-hm-approssimazione-oss-a>

    Sia $I^*$ la soluzione ottima, allora il suo costo $w^*$ è la somma dei costi delle aree selezionate:
    $ w^* = sum_(i in I^*) w_i $ <set-cover-hm-approssimazione-sol-ottima>

    Dato che #link-equation(<set-cover-hm-approssimazione-oss-a>) vale per ogni $k$, allora vale anche:
    $
      w^* = sum_(i in I^*) mr(w_i) quad & >= quad (limits(sum)_(i in I^*) mr(limits(sum)_(s in S_i) c_s))/mr(H(M))
    $ <set-cover-hm-approssimazione-oss-c>

    La doppia sommatoria $limits(sum)_(i in I^*) limits(sum)_(s in S_i)$ scorre tutti i punti, ma potrebbe considerarne alcuni più volte, dato che scorre tutti i punti $in S_i$ a prescindere se siano stati già presi.
    Quindi è grande almeno quanto lo scorrere tutti i punti dell'universo almeno una volta $s in Omega$:

    $
      mb(sum_(i in I^*) sum_(s in S_i) c_s) >= sum_(s in Omega) c_s underbrace(=, #link-teorema(<teorema-somma-costi-totale-pagato>)) mb(w)
    $ <set-cover-hm-approssimazione-oss-b>

    Mettendo tutto insieme:
    $
      w^*
      quad underbrace(=, #link-equation(<set-cover-hm-approssimazione-sol-ottima>)) quad
      sum_(i in I^*) w_i
      quad underbrace(>=, #link-equation(<set-cover-hm-approssimazione-oss-c>)) quad
      mb(limits(sum)_(i in I^*) limits(sum)_(s in S_i) c_s) / H(M)
      quad underbrace(>=, #link-equation(<set-cover-hm-approssimazione-oss-b>)) quad
      mb(w) / H(M)
    $

    $
       w^* quad & >= quad w/H(M) \
      H(M) quad & >= quad w/w^* space qed
    $
  ]
]

#teorema("Corollario")[
  Asintoticamente, $"PricingSetCover"$ è una $O(ln n)$-approssimazione.

  #dimostrazione[
    Ricordiamo che $M = limits(max)_k |S_k|, quad n = |Omega|, quad H(n) approx ln(n)$.

    La cardinalità massima di un'area è, ovviamente, minore o uguale alla cardinalità dell'universo, $M <= n$:
    $
      max_k |S_k| & <= |Omega| \
                M & <= n \
             H(M) & <= H(n) \
             H(M) & = O(ln n) space qed
    $
  ]
]

== Strettezza dell'analisi

Per dimostrare che l'analisi effettuata sia stretta, presentiamo un input _pessimo_ che arriva esattamente al bound di approssimazione:
- esistono $n$ punti nell'universo $Omega$
- esistono due aree _verticali_ che coprono ciascuna $n/2$ punti e che costano $1+epsilon$
- esistono infinite aree _orizzontali_ che coprono ciascuna $n/2^i$ punti (con $i in bb(N) \\ {0}$), metà della prima area verticale, metà della seconda area verticale, di costo $1$

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Area verticale sinistra V₁ (copre n/2 punti, costo 1+ε)
    rect((1, 0), (2.8, 6), stroke: blue + 2pt, fill: blue.transparentize(80%))
    content((1.9, 0.3), text(size: 11pt, fill: blue, $n/2$))
    content((1.9, 6.35), text(size: 9pt, fill: blue, $"costo" = 1+epsilon$))

    // Area verticale destra V₂ (copre n/2 punti, costo 1+ε)
    rect((3.2, 0), (5, 6), stroke: green + 2pt, fill: green.transparentize(80%))
    content((4.1, 0.3), text(size: 11pt, fill: green, $n/2$))
    content((4.1, 6.35), text(size: 9pt, fill: green, $"costo" = 1+epsilon$))

    // Prima area orizzontale H₁ (copre n/2 punti, costo 1)
    rect((0.5, 3.8), (5.5, 5.8), stroke: red + 1.5pt, fill: red.transparentize(85%))
    content((1.9, 4.8), text(size: 11pt, fill: red, $n/4$))
    content((4.1, 4.8), text(size: 11pt, fill: red, $n/4$))
    content((6.2, 4.8), text(size: 8pt, fill: red, $"costo" = 1$))

    // Seconda area orizzontale H₂ (copre n/4 punti, costo 1)
    rect((0.5, 2.3), (5.5, 3.6), stroke: orange + 1.5pt, fill: orange.transparentize(85%))
    content((1.9, 3.0), text(size: 11pt, fill: orange, $n/8$))
    content((4.1, 3.0), text(size: 11pt, fill: orange, $n/8$))
    content((6.2, 3.0), text(size: 8pt, fill: orange, $"costo" = 1$))

    // Terza area orizzontale H₃ (copre n/8 punti, costo 1)
    rect((0.5, 1.6), (5.5, 2.1), stroke: purple + 1.5pt, fill: purple.transparentize(85%))
    content((1.9, 1.85), text(size: 8pt, fill: purple, $n\/16$))
    content((4.1, 1.85), text(size: 8pt, fill: purple, $n\/16$))
    content((6.2, 1.85), text(size: 8pt, fill: purple, $"costo" = 1$))

    // Quarta area orizzontale H₄ (copre n/16 punti, costo 1)
    rect((0.5, 1.14), (5.5, 1.4), stroke: maroon + 1.5pt, fill: maroon.transparentize(85%))
    content((1.9, 1.27), text(size: 8pt, fill: maroon, $n\/32$))
    content((4.1, 1.27), text(size: 8pt, fill: maroon, $n\/32$))
    content((6.2, 1.27), text(size: 8pt, fill: maroon, $"costo" = 1$))

    // Linee tratteggiate per indicare la continuazione
    content((1.9, 0.9), text(size: 10pt, fill: black, $...$))
    content((4.1, 0.9), text(size: 10pt, fill: black, $...$))
  }),
  caption: [Esempio pessimo per Set Cover, due aree verticali disgiunte (costo $1+epsilon$) vs sequenza di aree orizzontali che si dimezzano progressivamente (costo $1$)],
)

Esecuzione dell'algoritmo:
- Iterazione 1: scegliere tra:
  - _verticale_: prezzo $(1 + epsilon) / (n\/2)$
  - _orizzontale_: prezzo $1 / (n\/2)$ $quad <==$ scelto
- Iterazione 2:
  - _verticale_: prezzo $(1 + epsilon) / ((n\/2) - (n\/4)) = (1+epsilon)/(n\/4)$
  - _orizzontale_: prezzo $1 / (n\/4)$ $quad <==$ scelto
- Si continua così $log n$ volte

Di conseguenza la soluzione trovata è:
$ w = underbrace(log n, "aree"\ "selezionate") dot underbrace(1, "costo"\ "di"\ "ogni"\ "area") $
mentre la soluzione ottima sarebbe scegliere le due aree verticali
$ w^* = 2 + 2 epsilon $
con rapporto di approssimazione:
$ w/w^* = (log n) / (2 + 2 epsilon) = Omega(log n) space qed $

#teorema("Teorema")[
  *$ "SetCover" in log"-APX" $*
]

#teorema("Teorema")[
  *$ "Se P" != "NP", quad "SetCover" in.not "APX" $*
]
