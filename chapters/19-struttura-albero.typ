#import "../imports.typ": *

= Struttura Albero

== Nomenclatura

In *teoria dei grafi*, la nomenclatura standard è:
/ Albero: grafo non orientato, conesso ed aciclico (non necessariamente radicato)
/ Foresta: grafo non orientato ed aciclico (ogni componente connessa è un albero)

In *informatica*, la nomenclatura standard è:
/ Albero: struttura radicata aciclica dove ogni nodo ha dei figli.
  Assegnando una radice qualsiasi ad un albero secondo la _teoria dei grafi_, otteniamo un albero in _informatica_
/ Albero ordinato: albero in cui i figli di un nodo hanno un certo ordine
/ Albero binario: albero in cui ogni nodo ha esattamente $0$ o $2$ figli.

== ADT Albero Binario

Albero in cui ogni nodo ha esattamente $0$ o $2$ figli.

Definizione ricorsiva:
- Passo base: un nodo è un albero
- Passo ricorsivo: siano $T_1$ e $T_2$ due alberi binari, allora anche l'albero $T$ dove i due figli sono $T_1$ e $T_2$ è un albero binario

#figure(
  cetz.canvas(length: 0.8cm, {
    import cetz.draw: *

    let r = 0.3 // raggio nodo

    // Nodo radice
    circle((0, 0), radius: r, fill: white, stroke: black)
    content((0, 0), text(size: 10pt)[$r$])

    // Triangolo T1 (sinistro) - più simmetrico
    line((-2.5, -2.5), (-0.5, -2.5), stroke: black)
    line((-2.5, -2.5), (-1.5, -0.5), stroke: black)
    line((-0.5, -2.5), (-1.5, -0.5), stroke: black)
    content((-1.5, -1.5), text(size: 11pt, weight: "bold")[$T_1$])

    // Triangolo T2 (destro) - più simmetrico
    line((0.5, -2.5), (2.5, -2.5), stroke: black)
    line((0.5, -2.5), (1.5, -0.5), stroke: black)
    line((2.5, -2.5), (1.5, -0.5), stroke: black)
    content((1.5, -1.5), text(size: 11pt, weight: "bold")[$T_2$])

    // Collegamenti dalla radice ai triangoli
    line((-0.25, -0.15), (-1.5, -0.5), stroke: black)
    line((0.25, -0.15), (1.5, -0.5), stroke: black)

    // Etichette colorate
    content((-2.2, -0.2), [sx])
    content((2.2, -0.2), [dx])
  }),
  caption: [
    Albero binario con radice $r$ e due sottoalberi binari $T_1$ (figlio sinistro) e $T_2$ (figlio destro).
  ],
)
I nodi di un albero binario si dividono in:
- *interni*: nodi dell'albero che hanno dei figli
- *esterni*: le foglie dell'albero
#figure(
  cetz.canvas(length: 0.8cm, {
    import cetz.draw: *

    let r = 0.3 // raggio nodo

    // Lines
    line((-0.2, -0.2), (-1.3, -1.3), stroke: black)
    line((-1.65, -1.65), (-2, -2.2), stroke: black)
    line((-1.35, -1.65), (-1, -2.2), stroke: black)
    line((0.2, -0.2), (1.3, -1.3), stroke: black)
    line((1.35, -1.65), (1, -2.3), stroke: black)
    line((0.85, -2.65), (0.5, -3.2), stroke: black)
    line((1.15, -2.65), (1.5, -3.2), stroke: black)
    line((1.65, -1.65), (2, -2.2), stroke: black)

    // Nodo radice (interno)
    circle((0, 0), radius: r, fill: white, stroke: black)
    content((0, 0), text(size: 10pt)[$r$])

    // Sottoalbero sinistro
    circle((-1.5, -1.5), radius: r, fill: white, stroke: black)
    content((-1.5, -1.5), text(size: 9pt)[$i_1$])

    // Foglie del sottoalbero sinistro
    rect((-2.3, -2.8), (-1.7, -2.2), stroke: black, fill: white)
    content((-2, -2.5), text(size: 9pt)[$e_1$])

    rect((-1.3, -2.8), (-0.7, -2.2), stroke: black, fill: white)
    content((-1, -2.5), text(size: 9pt)[$e_2$])

    // Sottoalbero destro (interno)
    circle((1.5, -1.5), radius: r, fill: white, stroke: black)
    content((1.5, -1.5), text(size: 9pt)[$i_2$])

    // i3
    circle((1, -2.5), radius: r, fill: white, stroke: black)
    content((1, -2.5), text(size: 9pt)[$i_3$])

    // Figli di i3
    rect((0.2, -3.8), (0.8, -3.2), stroke: black, fill: white)
    content((0.5, -3.5), text(size: 9pt)[$e_3$])

    rect((1.2, -3.8), (1.8, -3.2), stroke: black, fill: white)
    content((1.5, -3.5), text(size: 9pt)[$e_5$])

    // Foglia e4
    rect((1.7, -2.8), (2.3, -2.2), stroke: black, fill: white)
    content((2, -2.5), text(size: 9pt)[$e_4$])
  }),
  caption: [
    Nodi di un albero binario: nodi interni (cerchi) con figli, e nodi esterni (rettangoli) che sono le foglie.
  ],
)

#teorema("Proprietà")[
  In un albero binario, il numero di foglie $E$ è il numero di nodi interni $I+1$:
  $ |E| = |I| + 1 $

  #dimostrazione[
    La dimostrazione è per *induzione* strutturale:
    - _Passo base 1_: albero con un solo nodo $|E| = 1, |I| = 0$
    - _Passo base 2_: albero banale con radice e due figli $|E| = 2, |I| = 1$
    - _Passo induttivo_: posso combinare i due passi base, il numero di nodi di ciascun tipo rimangono uguali tranne per la radice che diventa interno
      $ |E| = underbrace(2 dot 2, "sottoalberi") + underbrace(1-1, "radice non più esterno") = 4 $
      $ |I| = underbrace(2 dot 1, "sottoalberi") + underbrace(1, "radice ora interno") = 3 $
  ]
] <albero-binario-numero-nodi>

#teorema("Corollario")[
  In un albero il numero di nodi totale $n$:
  $ n = |E|+|I| $

  Possiamo scriverlo come:
  - $ n = |E| + |E| - 1 = 2|E|-1 $
  - $ n = |I|+1 + |I| = 2|I|+1 $
]

Le primitive definite su un albero binario sono:
- *children*: dato un nodo (non foglia), ottenere i figli
- *parent*: dato un nodo (non radice), ottenere il genitore

== Struttura compressa per Albero Binario

=== Theoretical Lower Bound

Per poter affermare che una struttura è compressa, allora dobbiamo quantificare il theoretical lower bound (teorema di Shannon).

Vogliamo stabilire quanti sono i possibili tipi di alberi binari con $n$ nodi interni, per poi stabilire quanti bit servono per poterli rappresentare distintamente tutti.

#teorema("Teorema")[
  Il numero di alberi binari con $n$ nodi interni è $ C_n = 1/(n+1) binom(2n, n) $
  chiamato il *numero di Catalano*.
]

#teorema("Teorema")[
  Servono almeno $2n - O(log n)$ bit per rappresentare un albero binario con $n$ nodi *interni*.

  Il theoretical lower bound è $2n$:
  $ Z_n = 2n $

  #dimostrazione[

    #nota[
      Proprietà utili:
      - Approssimazione di #text(red)[Stirling]:
        $ x! approx sqrt(2 pi x) (x/e)^x $ <albero-binario-stirling>
      - Definizione binomiale:
        $ binom(n, k) = n! / (k!(n-k)!) $
      - Proprietà esponenziali:
        $ mb(a^x/b^x = (a/b)^x) $
        $ mp(a^x / a^y = a^(x-y)) $
    ]

    Quindi il theoretical lower bound è:
    $
      C_n = 1/(n+1) binom(2n, n) = 1/(n+1) dot ((2n)!) / ((n)! dot (2n-n)!) = 1/(n+1) dot ((2n)!) / (n! dot n!)
    $
    Usando l'approssimazione di Stirling (#link-equation(<albero-binario-stirling>)) con $mr(x = 2n)$ e $mr(x = n)$:
    $
      C_n = 1/(n+1) dot (2n!) / ((n)!^2) & approx 1/(n+1) dot mr(sqrt(4 pi n) ((2n)/e)^(2n)) / mr((sqrt(2 pi n) (n/e)^n))^2 \
                                         & = 1/(n+1) dot (2 sqrt(pi n)((2n)/e)^(2n))/(2 pi n (n/e)^(2n)) \
                                         & = 1/(n+1) dot (sqrt(pi n)((2n)/e)^(2n)) / (pi n (n/e)^(2n)) \
                                         & = 1/(n+1) dot sqrt(pi n)/(pi n) dot (mb((2n)/e dot e/n))^(2n) \
                                         & = 1/(n+1) dot sqrt(pi n)/(pi n) dot 2^(2n) \
                                         & = 1/(n+1) dot mp((pi n)^(1/2)/(pi n)^1) dot 2^(2n) \
                                         & = 1/(n+1) dot (pi n)^(-1/2) dot 2^(2n) \
                                         & = 1/(n+1) dot 1/sqrt(pi n) dot 2^(2n) \
                                         & approx 4^n / (sqrt(pi n^3))
    $
    Il numero di bit minimo per rappresentare un albero binario è pari a:
    $
      log_2 C_n approx log_2(4^n/sqrt(pi n^3)) & = log_2(2^(2n))-log_2(1/sqrt(pi n^3)) \
                                               & = 2n dot 1 - log_2(1/sqrt(pi n^3)) \
                                               & approx 2n - O(log n) space qed
    $
  ]
]

=== Rappresentazione succinta

Vogliamo rappresentare un albero binario, considerando solamente la sua struttura, senza considerare dei dati che contiene (*dati ancillari*).

Ogni nodo è numerato, per livello di profondità e da sinistra verso destra (come li visiterebbe una *BFS*).
Creiamo un vettore di $2n+1$ elementi, dove $n$ è il numero di nodi interi:
- il vettore memorizza $1$ per i nodi interni e $0$ per le foglie
- usiamo inoltre una struttura rank/select
#nota[
  I figli sinistri saranno sempre di indice dispari, i figli destri saranno sempre di indice pari.
]

La rappresentazione richiede $2 n + 1 + o(2n +1) = 2n + o(n)$ bit: è *succinta*.

#esempio[
  #figure(
    grid(
      columns: 2,
      column-gutter: 2em,
      row-gutter: 1em,

      // Colonna sinistra: albero
      cetz.canvas(length: 0.8cm, {
        import cetz.draw: *

        let r = 0.3 // raggio nodi circolari
        let box-size = 0.5 // dimensione rettangoli foglie

        // Archi
        line((-0.2, 3.8), (-1.3, 3), stroke: black) // 0-1
        line((0.2, 3.8), (1.3, 3), stroke: black) // 0-2
        line((-1.7, 2.6), (-2.3, 1.8), stroke: black) // 1-3
        line((-1.3, 2.6), (-0.7, 1.8), stroke: black) // 1-4
        line((-0.7, 1.4), (-1.3, 0.6), stroke: black) // 4-5
        line((-0.3, 1.4), (0.3, 0.6), stroke: black) // 4-6
        line((-1.7, 0.2), (-2.1, -0.6), stroke: black) // 5-7
        line((-1.3, 0.2), (-0.9, -0.6), stroke: black) // 5-8
        line((0.3, 0.2), (-0.1, -0.6), stroke: black) // 6-9
        line((0.7, 0.2), (1.1, -0.6), stroke: black) // 6-10

        // ===== ALBERO =====
        content((0, 5), text(size: 11pt, weight: "bold")[$T$])

        // Livello 0: radice
        circle((0, 4), radius: r, fill: white)
        content((0, 4), text(size: 9pt)[$0$])

        // Livello 1
        circle((-1.5, 2.8), radius: r, fill: white)
        content((-1.5, 2.8), text(size: 9pt)[$1$])

        rect(
          (1.5 - box-size / 2, 2.8 - box-size / 2),
          (1.5 + box-size / 2, 2.8 + box-size / 2),
          stroke: black,
          fill: white,
        )
        content((1.5, 2.8), text(size: 9pt)[$2$])

        // Livello 2
        rect(
          (-2.5 - box-size / 2, 1.6 - box-size / 2),
          (-2.5 + box-size / 2, 1.6 + box-size / 2),
          stroke: black,
          fill: white,
        )
        content((-2.5, 1.6), text(size: 9pt)[$3$])

        circle((-0.5, 1.6), radius: r, fill: white)
        content((-0.5, 1.6), text(size: 9pt)[$4$])

        // Livello 3
        circle((-1.5, 0.4), radius: r, fill: white)
        content((-1.5, 0.4), text(size: 9pt)[$5$])

        circle((0.5, 0.4), radius: r, fill: white)
        content((0.5, 0.4), text(size: 9pt)[$6$])

        // Livello 4: foglie
        rect(
          (-2.2 - box-size / 2, -0.8 - box-size / 2),
          (-2.2 + box-size / 2, -0.8 + box-size / 2),
          stroke: black,
          fill: white,
        )
        content((-2.2, -0.8), text(size: 9pt)[$7$])

        rect(
          (-0.8 - box-size / 2, -0.8 - box-size / 2),
          (-0.8 + box-size / 2, -0.8 + box-size / 2),
          stroke: black,
          fill: white,
        )
        content((-0.8, -0.8), text(size: 9pt)[$8$])

        rect(
          (-0.2 - box-size / 2, -0.8 - box-size / 2),
          (-0.2 + box-size / 2, -0.8 + box-size / 2),
          stroke: black,
          fill: white,
        )
        content((-0.2, -0.8), text(size: 9pt)[$9$])

        rect(
          (1.2 - box-size / 2, -0.8 - box-size / 2),
          (1.2 + box-size / 2, -0.8 + box-size / 2),
          stroke: black,
          fill: white,
        )
        content((1.2, -0.8), text(size: 9pt)[$10$])
      }),

      // Colonna destra: vettore e informazioni
      align(horizon)[
        #align(center)[
          #text(size: 11pt, weight: "bold")[$underline(b)$]
          #table(
            columns: 11,
            align: center + horizon,
            stroke: 0.5pt + black,
            inset: 5pt,
            // Riga indici
            [0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10],
            // Riga valori
            [1], [1], [0], [0], [1], [1], [1], [0], [0], [0], [0],
          )
        ]
      ],
    ),
    caption: [
      Rappresentazione succinta di un albero binario con $n=5$ nodi interni (quindi $11$ nodi totali). I nodi interni (cerchi rossi) corrispondono a $1$ nel vettore, le foglie (rettangoli) a $0$.
    ],
  )
]

=== Primitiva child

Dato un certo nodo $x$, accedere ai figli di $x$.

Per accedere ai figli di $x$, chiamati $x'$ e $x''$, dobbiamo sapere quanti nodi hanno indice più piccolo di $x'$.
Chiamiamo $T'$ il sottoalbero contenente tutti questi nodi.

Per conoscere la quantità di nodi di $T'$ dobbiamo sapere quanti nodi hanno dei figli prima di $x'$.
Questi non sono altro che tutti i nodi visitati prima di $x$, ovvero:
- tutti i nodi ai livelli precedenti di $x$
- i nodi allo stesso livello di $x$ ma più a sinistra

#figure(
  cetz.canvas(length: 0.8cm, {
    import cetz.draw: *

    let r = 0.3 // raggio nodi

    // Grande triangolo che rappresenta l'intero albero T
    line((4, 0), (0, 5), stroke: black + 1pt)
    line((-4, 0), (4, 0), stroke: black + 1pt)
    line((-4, 0), (0, 5), stroke: black + 1pt)

    // Etichetta dell'albero
    content((0, 5.5), text(size: 11pt, weight: "bold")[$T$])

    // Sottoalbero T' (area grigia)
    merge-path(fill: gray.lighten(70%), stroke: gray + 1.5pt, close: true, {
      line((0, 5), (2.4, 2))
      line((2.4, 2), (-0.8, 2))
      line((-0.8, 2), (-0.8, 1))
      line((-0.8, 1), (-3.2, 1))
    })

    content((-2, 2.8), text(size: 12pt, weight: "bold", fill: gray.darken(30%))[$T'$])

    // Collegamenti da x ai suoi figli
    line((0.7, 2.75), (-0.15, 1.8), stroke: red + 1pt)
    line((0.9, 2.75), (1.8, 1.8), stroke: red + 1pt)

    // Nodo x
    circle((0.8, 3.0), radius: r, fill: blue.lighten(80%), stroke: blue + 1.5pt)
    content((0.8, 3.0), text(size: 10pt, fill: blue, weight: "bold")[$x$])

    // Figli di x: x' (sinistro) e x'' (destro)
    circle((-0.2, 1.5), radius: r, fill: red.lighten(80%), stroke: red + 1.5pt)
    content((-0.2, 1.5), text(size: 10pt, fill: red, weight: "bold")[$x'$])

    circle((1.8, 1.5), radius: r, fill: red.lighten(80%), stroke: red + 1.5pt)
    content((1.8, 1.5), text(size: 10pt, fill: red, weight: "bold")[$x''$])
  }),
  caption: [
    Calcolo degli indici dei figli di $x$: il sottoalbero $T'$ (area grigia) contiene tutti i nodi visitati prima del figlio sinistro $x'$ di $x$.
  ],
)

Possiamo calcolare questa quantità conoscendo il numero di nodi interni di $T'$ sfruttando la proprietà #link-teorema(<albero-binario-numero-nodi>).
$ |"nodi" T'| = 2 |"nodi interni" T'| + 1 = 2 "rank"_underline(b)(x) + 1 $

Dato che i nodi sono numerati a partire da $0$, allora gli indici dei figli di $x$ sono:
- $2 "rank"_underline(b)(x) + 1$
- $2 "rank"_underline(b)(x) + 2$.

=== Primitiva parent

Il padre di un nodo $x$ è quel nodo $p$ tale che:
$
  "Parent"(x) = cases(
    "left-child"(p) & = x,
    "right-child"(p) & = x
  )
$

Possiamo espandere le primitive child:
$
  "Parent"(x) & = cases(
                  2"rank"(p)+1 & = x,
                  2"rank"(p)+2 & = x
                ) \
              & = cases(
                  "rank"(p) & = (x-1)/2,
                  "rank"(p) & = (x-2)/2
                ) \
    "rank"(p) & = floor((x-1)/2) \
$
Sapendo che rank e select si annullano (#link-teorema(<rank-select-operazioni-inverse>)) in caso $b_p = 1$ (e $p$ lo è dato che ha figli), possiamo applicare la select da entrambe le parti:
$
  "select"("rank"(p)) & = "select"(floor((x-1)/2)) \
                    p & = "select"(floor((x-1)/2))
$

=== Dati ancillari

La struttura mostra un modo per memorizzare la struttura dell'albero.
Solitamente, insieme all'albero, vogliamo anche memorizzare i dati contenuti nei nodi dell'albero, ovvero i dati ancillari.

- Dati ancillari solo su *nodi interni*: memorizzati in un array lungo quanto il numero di nodi interni dell'albero:
  - Usare una *select* per sapere dato un nodo dove sarà il suo dato ancillare
  - Usare una *rank* per sapere dato un dato a che nodo corrisponde

- Dati ancillari anche sulle *foglie*: memorizzati in un array della stessa lunghezza di $b$ (numero totale di nodi), ogni cella dell'array contiene il dato di quel nodo

== Biiezioni fra Alberi Binari, Alberi Generali e Foreste

#nota[
  Una biiezione tra due insiemi $X$ e $Y$ è una relazione binaria tale che ad ogni elemento di $X$ corrisponde *uno ed uno solo* elemento di $Y$ (e viceversa).
]

/ $B_n$: insieme alberi binari con $n$ nodi *interni*
/ $F_n$: insieme delle foreste ordinate (foresta in cui le radici dei singoli alberi sono ordinate) con $n$ nodi
/ $T_n$: insieme degli alberi generali con $n$ nodi
/ $D_n$: parola di Dyck con $n$ parentesi aperte

#nota[
  Non esiste l'albero vuoto (dato che deve avere una radice), ma esiste la foresta vuota.
]

=== Lift

La *foresta* ordinata viene trasformata in un *albero*, aggiungendo una radice che connette tutte le radici.

$ phi : F_n -> T_(n+1) $

#figure(
  cetz.canvas(length: 0.7cm, {
    import cetz.draw: *

    let r = 0.2 // raggio nodo radice

    // ===== FORESTA F_n (sinistra) =====
    content((-5, 4), text(size: 11pt, weight: "bold")[Foresta $F_n$])

    // Albero T1
    line((-6.5, 0.5), (-5, 0.5), stroke: black)
    line((-6.5, 0.5), (-5.75, 2.5), stroke: black)
    line((-5, 0.5), (-5.75, 2.5), stroke: black)
    content((-5.75, 1.3), text(size: 10pt, weight: "bold")[$T_1$])

    // Albero T2
    line((-4.3, 0.5), (-2.8, 0.5), stroke: black)
    line((-4.3, 0.5), (-3.55, 2.5), stroke: black)
    line((-2.8, 0.5), (-3.55, 2.5), stroke: black)
    content((-3.55, 1.3), text(size: 10pt, weight: "bold")[$T_2$])

    // Puntini
    content((-2, 1.5), text(size: 12pt)[$dots.c$])

    // Albero Tk (più distanziato)
    line((-0.5, 0.5), (1, 0.5), stroke: black)
    line((-0.5, 0.5), (0.25, 2.5), stroke: black)
    line((1, 0.5), (0.25, 2.5), stroke: black)
    content((0.25, 1.3), text(size: 10pt, weight: "bold")[$T_k$])

    // ===== FRECCIA LIFT =====
    content((2.5, 2.5), text(size: 11pt, weight: "bold")[$phi$ (Lift)])
    line((1.5, 1.5), (3.5, 1.5), stroke: black)
    line((3.35, 1.65), (3.5, 1.5), stroke: black)
    line((3.35, 1.35), (3.5, 1.5), stroke: black)

    // ===== ALBERO T_(n+1) (destra) =====
    content((7, 4), text(size: 11pt, weight: "bold")[Albero $T_(n+1)$])

    // Nodo radice aggiunto
    circle((7, 3.2), radius: r, fill: white, stroke: black)
    content((7, 3.2), text(size: 8pt, fill: black)[$r$])

    // Collegamenti dalla radice ai sottoalberi
    line((7, 3), (5.5, 2.5), stroke: black)
    line((7, 3), (7, 2.5), stroke: black)
    line((7, 3), (8.75, 2.5), stroke: black)

    // Albero T1
    line((5, 0.5), (6, 0.5), stroke: black)
    line((5, 0.5), (5.5, 2.5), stroke: black)
    line((6, 0.5), (5.5, 2.5), stroke: black)
    content((5.5, 1.3), text(size: 10pt, weight: "bold")[$T_1$])

    // Albero T2
    line((6.5, 0.5), (7.5, 0.5), stroke: black)
    line((6.5, 0.5), (7, 2.5), stroke: black)
    line((7.5, 0.5), (7, 2.5), stroke: black)
    content((7, 1.3), text(size: 10pt, weight: "bold")[$T_2$])

    // Puntini
    content((8, 1.5), text(size: 12pt)[$dots.c$])

    // Albero Tk (più distanziato)
    line((8.25, 0.5), (9.25, 0.5), stroke: black)
    line((8.25, 0.5), (8.75, 2.5), stroke: black)
    line((9.25, 0.5), (8.75, 2.5), stroke: black)
    content((8.75, 1.3), text(size: 10pt, weight: "bold")[$T_k$])
  }),
  caption: [
    Operazione di Lift.
  ],
)

=== First child next sibling (FCNS)

Una foresta ordinata (o un albero generale, non necessariamente binario) viene trasformata in un albero *binario*.
$ psi : F_n -> B_n $

Per ogni nodo $v$ nella foresta:
- Il figlio sinistro di $v$ nell'albero binario corrisponde al *primo figlio* di $v$ nella foresta
- Il figlio destro di $v$ nell'albero binario corrisponde al *prossimo fratello* (next sibling) di $v$ nella foresta

#figure(
  cetz.canvas({
    import cetz.draw: *

    let r = 0.3 // raggio nodi

    // ===== ALBERO GENERALE (sinistra) =====
    content((-4, 4), text(size: 11pt, weight: "bold")[Albero generale (o foresta)])

    // Nodo radice r
    circle((-4, 3), radius: r, fill: white, stroke: black)
    content((-4, 3), text(size: 10pt)[$r$])

    // Figli a, b, c
    circle((-5.5, 1.5), radius: r, fill: white, stroke: black)
    content((-5.5, 1.5), text(size: 10pt)[$a$])

    circle((-4, 1.5), radius: r, fill: white, stroke: black)
    content((-4, 1.5), text(size: 10pt)[$b$])

    circle((-2.5, 1.5), radius: r, fill: white, stroke: black)
    content((-2.5, 1.5), text(size: 10pt)[$c$])

    // Collegamenti dalla radice ai figli
    line((-4, 2.7), (-5.5, 1.8), stroke: black)
    line((-4, 2.7), (-4, 1.8), stroke: black)
    line((-4, 2.7), (-2.5, 1.8), stroke: black)

    // Figli di b: d, e
    circle((-4.7, 0), radius: r, fill: white, stroke: black)
    content((-4.7, 0), text(size: 10pt)[$d$])

    circle((-3.3, 0), radius: r, fill: white, stroke: black)
    content((-3.3, 0), text(size: 10pt)[$e$])

    line((-4, 1.2), (-4.7, 0.3), stroke: black)
    line((-4, 1.2), (-3.3, 0.3), stroke: black)

    // ===== FRECCIA FCNS =====
    content((0, 3), text(size: 11pt, weight: "bold")[$psi$ (FCNS)])
    line((-1.5, 2.5), (1.5, 2.5), stroke: black)
    line((1.35, 2.65), (1.5, 2.5), stroke: black)
    line((1.35, 2.35), (1.5, 2.5), stroke: black)

    // ===== ALBERO BINARIO (destra) =====
    content((4.5, 4), text(size: 11pt, weight: "bold")[Albero binario])

    // Nodo radice r
    circle((4.5, 3), radius: r, fill: white, stroke: black)
    content((4.5, 3), text(size: 10pt)[$r$])

    // Nodo a (figlio sinistro di r = primo figlio)
    circle((3.5, 2), radius: r, fill: white, stroke: blue)
    content((3.5, 2), text(size: 10pt)[$a$])
    line((4.35, 2.75), (3.65, 2.25), stroke: blue)

    // Nodo b (figlio destro di a = fratello successivo)
    circle((4.5, 1), radius: r, fill: white, stroke: red)
    content((4.5, 1), text(size: 10pt)[$b$])
    line((3.65, 1.75), (4.35, 1.25), stroke: red)

    // Nodo d (figlio sinistro di b = primo figlio di b)
    circle((3.5, 0), radius: r, fill: white, stroke: blue)
    content((3.5, 0), text(size: 10pt)[$d$])
    line((4.35, 0.75), (3.65, 0.25), stroke: blue)

    // Nodo e (figlio destro di d = fratello successivo)
    circle((4.5, -1), radius: r, fill: white, stroke: red)
    content((4.5, -1), text(size: 10pt)[$e$])
    line((3.65, -0.25), (4.35, -0.75), stroke: red)

    // Nodo c (figlio destro di b = fratello successivo)
    circle((5.5, 0), radius: r, fill: white, stroke: red)
    content((5.5, 0), text(size: 10pt)[$c$])
    line((4.65, 0.75), (5.35, 0.25), stroke: red)
  }),
  caption: [
    Trasformazione FCNS (First Child Next Sibling): i nodi sinistri sono i #text(blue)[figli], i nodi destri sono #text(red)[fratelli] del nodo attuale.
  ],
)

#nota[
  La trasformazione *preserva* la cardinalità:
  $ |T_(n+1)| = |F_n| = |B_n| = C_n $

  Il numero di _foreste ordinate_ con $n$ nodi (che è uguale al numero di _alberi generali_ con $n$ nodi) è uguale al numero di _alberi binari_ con $n$ nodi interni, entrambi sono pari al _numero di catalano_.
]

=== Parole di Dyck

Una foresta (o albero generico) viene trasformata in una parola di Dyck.

Formalmente:
- $Sigma = {(,)}$: alfabeto composto solo da parentesi aperta e chiusa
- $s in Sigma^*$ è una parola di Dyck se:
  + il numero di parentesi aperte $\#_\($ è uguale al numero di parentesi chiuse $\#_\)$
  + $forall$ prefisso $v$ di $w$, $\#_\( v >= \#_\) v$, ovvero se le parentesi sono bilanciate

$ alpha : F_n -> D_n $

Definizione della biiezione $alpha$ ricorsiva:
- _Caso base_: $alpha(emptyset) = epsilon$ (foresta vuota)
- _Passo ricorsivo_: per una foresta $F$ composta da $T_1, dots, T_k$ alberi, inseriamo delle #text(red)[parentesi] che racchiudono l'albero e procediamo ricorsivamente:
  $ alpha(F) = mr(\() space alpha(T_1) space dots space alpha(T_k) space mr(\)) $

#figure(
  cetz.canvas({
    import cetz.draw: *

    let r = 0.30 // raggio nodi

    // ===== ALBERO GENERALE (alto) =====
    content((0, 6.5), text(size: 11pt, weight: "bold")[Foresta $F$])

    // Radice A
    circle((0, 5.8), radius: r, fill: white, stroke: black)
    content((0, 5.8), text(size: 10pt)[$A$])

    // Primo livello: B, C, D
    let level1 = (
      ((-2.5, 4.2), $B$),
      ((0, 4.2), $C$),
      ((2.5, 4.2), $D$),
    )

    for (pos, label) in level1 {
      circle(pos, radius: r, fill: white, stroke: black)
      content(pos, text(size: 10pt)[#label])
      line((0, 5.5), (pos.at(0), pos.at(1) + 0.3), stroke: black)
    }

    // Sottoalbero B: E, F
    circle((-3, 2.5), radius: r, fill: white, stroke: black)
    content((-3, 2.5), text(size: 10pt)[$E$])
    line((-2.5, 3.9), (-3, 2.8), stroke: black)

    circle((-2, 2.5), radius: r, fill: white, stroke: black)
    content((-2, 2.5), text(size: 10pt)[$F$])
    line((-2.5, 3.9), (-2, 2.8), stroke: black)

    // Sottoalbero D: H
    circle((2.5, 2.5), radius: r, fill: white, stroke: black)
    content((2.5, 2.5), text(size: 10pt)[$H$])
    line((2.5, 3.9), (2.5, 2.8), stroke: black)

    // ===== FRECCIA VERSO BASSO =====
    line((0, 1.8), (0, 1.0), stroke: black)
    line((-0.1, 1.15), (0, 1.0), stroke: black)
    line((0.1, 1.15), (0, 1.0), stroke: black)
    content((0.7, 1.4), text(size: 10pt, weight: "bold")[$alpha$])

    // ===== PASSI COSTRUZIONE PAROLA DI DYCK =====
    content((0, 0.3), text(size: 11pt, weight: "bold")[Costruzione parola di Dyck])

    content((0, -1.2), align(center)[
      $ mr("(") space mp(alpha(B)) space mb(alpha(C)) space mo(alpha(D)) space mr(")") $

      $
        ( space mp("(") space alpha(E) space alpha(F) space mp(")") space mb("()") space mo("(") space alpha(H) space mo(")") space )
      $

      $
        ( space ( space "()" space "()" space ) space () space ( space "()" space ) space )
      $
    ])
  }),
  caption: [
    Esempio di trasformazione $alpha : F_n -> D_n$.
  ],
)

#nota[
  Traduciamo ricorsivamente ogni foresta ad una parola di Dyck:
  *$ |D_n| = |F_n| = C_n $*
]

#attenzione[
  Questa struttura a parentesi rappresenta solo l'albero, senza dati ancillari.
  Per memorizzare dei dati ancillari bisogna portarsi dietro un array con informazioni sulle parentesi aperte (complicato).
]
