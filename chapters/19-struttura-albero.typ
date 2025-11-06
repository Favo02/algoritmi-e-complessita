#import "../imports.typ": *

= Struttura Albero

== Nomenclatura

Nomenclatura in teoria dei grafi:

/ Albero: grafo non orientato, conesso ed aciclico
/ Foresta: grafo non orientato ed aciclico (ogni componente connessa è un albero)

Nomenclatura in informatica:

/ Albero: struttura radicata dove ogni nodo ha dei figli

  #nota[
    Se prendiamo un albero stando alla definizione di teoria dei grafi e scegliamo un qualsiasi nodo, allora otteniamo un albero radicato (quindi nel senso di informatica)
  ]

/ Albero ordinato: albero in cui i figli di un nodo hanno un certo ordine

/ Albero binari: albero in cui ogni nodo ha $0$ o $2$ figli. Definizione ricorsiva:
- Passo base = un nodo è un albero
- Passo ricorsivo = Siano $T_1$ e $T_2$ due alberi binari, allora anche $T$ è un albero:

#figure(
  cetz.canvas(length: 0.8cm, {
    import cetz.draw: *

    // Nodo radice
    circle((0, 0), radius: 0.15, fill: white, stroke: 2pt + black)
    content((0, 0), text(size: 9pt)[$r$])

    // Triangolo T1 (sinistro)
    line((-1.5, -0.8), (-0.8, -2), stroke: 2pt + black)
    line((-0.8, -2), (-2.2, -2), stroke: 2pt + black)
    line((-2.2, -2), (-1.5, -0.8), stroke: 2pt + black)
    content((-1.5, -1.5), text(size: 11pt, weight: "bold")[$T_1$])

    // Triangolo T2 (destro)
    line((1.5, -0.8), (2.2, -2), stroke: 2pt + black)
    line((2.2, -2), (0.8, -2), stroke: 2pt + black)
    line((0.8, -2), (1.5, -0.8), stroke: 2pt + black)
    content((1.5, -1.5), text(size: 11pt, weight: "bold")[$T_2$])

    // Collegamenti dalla radice ai triangoli
    line((0, -0.15), (-1.5, -0.8), stroke: 2pt + black)
    line((0, -0.15), (1.5, -0.8), stroke: 2pt + black)

    // Etichette
    content((-1.7, -0.4), text(size: 8pt)[figlio sx])
    content((1.7, -0.4), text(size: 8pt)[figlio dx])
  }),
)
Dove:
- *$mr("Nodi interni")$* = Sono i nodi dell'albero che hanno un figlio
- *$mb("Nodi esterni")$* = Sono le foglie dell'albero.

  #teorema("Proprietà")[
    In un albero binario, Il numero di foglie $E$ è il numero di nodi interni $I$ (nodi con figli) $+1$:
    $ |E| = |I| + 1 $

    #dimostrazione[
      La dimostrazione è per *induzione strutturale*:
      - *Passo base* = Albero con un solo nodo $|E| = 1, |I| = 0 space qed$
      - *Passo induttivo* = ALbero $T$ con due sottoalberi $T_1$ e $T_2$.
      $
        |E(T)| = |E(T_1)| + |E(T_2)|\
        mb("Siccome" |E(T_1)| < |E(T)| "uso ipotesi induttiva")\
        |E(T)| = underbrace(|I(T_1)|+1+|I(T_2)|, I(T))+1\
        |E(T)| = |I(T)| + underbrace(1, "radice di" T) space qed
      $
    ]
  ]
  #nota()[
    In un albero il numero di nodi totale $n$ è dato da:
    $ n = |E|+|I| $
    Possiamo scriverlo come:
    $
      n & = |E| + |E| - 1 = 2|E|-1 \
      n & = |I|+1 + |I| = 2|I|+1
    $
  ]

== Struttura succinta per Albero Binario

=== Theoretical Lower Bound

Per poter affermare che una struttura è compressa, allora dobbiamo quantificare il theoretical lower bound (teorema di shannon). Vogliamo stabilire quanti sono i possibili tipi di alberi binari con *$n$ nodi interni*

#teorema("Teorema")[
  Il numero di alberi binari con $n$ nodi intenri è $ C_n = 1/(n+1) binom(2n, n) $
  chiamato il *numero di Catalano*
]


#teorema("Teorema")[
  Il theoretical lower bound è $2n$, servono *almeno $2n-O(log n)$ bit* per rappresentare un *albero binario* con *$n$ nodi interni*.
]
#dimostrazione()[

  #nota[
    Proprietà utili:
    - Approssimazione di $mr("Stirling")$:
      $ x! approx sqrt(2 pi x) (x/e)^x $
    - Definizione binomiale:
      $ binom(n, k) = n! / k!(n-k)! $
  ]<Proprietà-utili-alberi>
  Quindi il theoretical lower bound è:
  $
    C_n = 1/(n+1) binom(2n, n) underbrace(=, "def binomiale") 1/(n+1) dot (2n!) / ((n)! dot (2n-n)!) = 1/(n+1) dot (2n!) / ((n)! dot (n)!)
  $
  Usando Stirling #link-teorema(<Proprietà-utili-alberi>) con $mr(x = 2n)$ e $mr(x = n)$:
  $
    C_n = 1/(n+1) dot (2n!) / ((n)!^2) & approx 1/(n+1) dot mr(sqrt(4 pi n) ((2n)/e)^(2n)) / mr((sqrt(2 pi n) (n/e)^n))^2 \
                                       & = 1/(n+1) dot (2 sqrt(pi n)((2n)/e)^(2n))/(2 pi n (n/e)^(2n)) \
                                       & = 1/(n+1) dot (sqrt(pi n)((2n)/e)^(2n)) / (pi n (n/e)^(2n)) \
                                       & mb(a^x/b^x = (a/b)^x) \
                                       & = 1/(n+1) dot sqrt(pi n)/(pi n) dot mb((2n)/e dot e/n)^(2n) \
                                       & = 1/(n+1) dot sqrt(pi n)/(pi n) dot 2^(2n) \
                                       & mb(a^x / a^y = a^(x-y)) \
                                       & = 1/(n+1) dot mb((pi n)^(1/2)/(pi n)^1) dot 2^(2n) \
                                       & = 1/(n+1) dot (pi n)^(-1/2) dot 2^(2n) \
                                       & = 1/(n+1) dot 1/sqrt(pi n) dot 2^(2n) \
                                       & approx 4^n / (sqrt(pi n^3))
  $
  Il numero di bit minimo per rappresentare un albero binario è pari a:
  $
    log_2 C_n approx log_2(4^n/sqrt(pi n^3)) & = log_2(2^2n)-log_2(1/sqrt(pi n^3)) \
                                             & = 2n dot 1 - log_2(1/sqrt(pi n^3)) \
                                             & approx 2n - O(log n) space qed
  $


]

=== Rappresentazione succinta

Vogliamo rappresentare un albero binario, in questo caso rappresentermo solamente la sua struttura. Nel conto totale dello spazio non terremo conto dei dati che contiene (*dati ancillari*).

L'idea è quella di numerari i nodi livello per livello da sinistra verso destra (*BFS*). Creiamo un vettore di $2n+1$ elementi, dove $n$ è il numero di nodi interi:
- il vettore memorizza $1$ per i nodi interni e $0$ per le foglie.
- usiamo inoltre una struttura rank/select.

La rappresentazione richiede *$2n + o(n)$ bit è succinta*.

#esempio[
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== ALBERO =====
      content((-5, 4), text(size: 11pt, weight: "bold")[$T$])

      // Nodi (cerchi per interni, rettangoli per foglie)
      // Nodo 0 (radice)
      circle((-2, 3.5), radius: 0.25, fill: white, stroke: 2pt + red)
      content((-2, 3.5), text(size: 9pt)[$0$])

      // Nodo 1
      circle((-3, 2.5), radius: 0.25, fill: white, stroke: 2pt + red)
      content((-3, 2.5), text(size: 9pt)[$1$])

      // Foglia 2
      rect((-1.3, 2.3), (-0.7, 2.7), stroke: 2pt + black, fill: white)
      content((-1, 2.5), text(size: 9pt)[$2$])

      // Foglia 3
      rect((-4.3, 1.3), (-3.7, 1.7), stroke: 2pt + black, fill: white)
      content((-4, 1.5), text(size: 9pt)[$3$])

      // Nodo 4
      circle((-2, 1.5), radius: 0.25, fill: white, stroke: 2pt + red)
      content((-2, 1.5), text(size: 9pt)[$4$])

      // Nodo 5
      circle((-3, 0.5), radius: 0.25, fill: white, stroke: 2pt + red)
      content((-3, 0.5), text(size: 9pt)[$5$])

      // Nodo 6
      circle((-1, 0.5), radius: 0.25, fill: white, stroke: 2pt + red)
      content((-1, 0.5), text(size: 9pt)[$6$])

      // Foglia 7
      rect((-3.8, -0.7), (-3.2, -0.3), stroke: 2pt + black, fill: white)
      content((-3.5, -0.5), text(size: 9pt)[$7$])

      // Foglia 8
      rect((-2.5, -0.7), (-1.9, -0.3), stroke: 2pt + black, fill: white)
      content((-2.2, -0.5), text(size: 9pt)[$8$])

      // Foglia 9
      rect((-1.5, -0.7), (-0.9, -0.3), stroke: 2pt + black, fill: white)
      content((-1.2, -0.5), text(size: 9pt)[$9$])

      // Foglia 10
      rect((-0.3, -0.7), (0.3, -0.3), stroke: 2pt + black, fill: white)
      content((0, -0.5), text(size: 9pt)[$10$])

      // Archi
      line((-2, 3.35), (-3, 2.65), stroke: 2pt + black) // 0-1
      line((-2, 3.35), (-1, 2.6), stroke: 2pt + black) // 0-2
      line((-3, 2.35), (-4, 1.7), stroke: 2pt + black) // 1-3
      line((-3, 2.35), (-2, 1.65), stroke: 2pt + black) // 1-4
      line((-2, 1.35), (-3, 0.65), stroke: 2pt + black) // 4-5
      line((-2, 1.35), (-1, 0.65), stroke: 2pt + black) // 4-6
      line((-3, 0.35), (-3.5, -0.3), stroke: 2pt + black) // 5-7
      line((-3, 0.35), (-2.2, -0.3), stroke: 2pt + black) // 5-8
      line((-1, 0.35), (-1.2, -0.3), stroke: 2pt + black) // 6-9
      line((-1, 0.35), (0, -0.3), stroke: 2pt + black) // 6-10

      // ===== VETTORE b E INFORMAZIONI =====
      content((3, 4), text(size: 11pt)[$n = 5$])
      content((3, 3.5), text(size: 10pt)[\#nodi = $2n+1 = 11$])

      // Indici sopra il vettore
      for i in range(11) {
        content((1.22 + i * 0.5, 3), text(size: 8pt)[#i])
      }

      // Vettore b
      content((0.5, 2.5), text(size: 11pt, weight: "bold")[$underline(b)$])
      let b_values = (1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0)
      for i in range(11) {
        let x = 1 + i * 0.5
        rect((x, 2.2), (x + 0.45, 2.7), stroke: 2pt + black, fill: white)
        content((x + 0.225, 2.45), text(size: 10pt)[#b_values.at(i)])
      }

      content((3, 1.8), text(size: 10pt)[in aggiunta il costo perRANK/SELECT])

      // Spazio totale
      content((3, 1.2), text(size: 11pt)[
        $2n+1 + o(2n+1)$
      ])
      content((3.5, 0.75), text(size: 11pt)[$= 2n + o(n)$])

      content((3.5, 0.3), text(size: 10pt, fill: green.darken(20%))[Succinta!])
    }),
    caption: [
      Rappresentazione succinta di un albero binario con $n=5$ nodi interni (quindi $n=11$ nodi totali).\
      Il vettore $underline(b)$ memorizza $1$ per i nodi interni e $0$ per le foglie.\
      Con una struttura rank/select, la rappresentazione richiede *$2n + o(n)$ bit
      è succinta*.
    ],
  )
]

#nota[
  I figli sinistri saranno sempre di indice dispari, i figli destri saranno sempre di indice pari.
]

=== Navigare l'albero

Con questa struttura, vogliamo poter navigare l'albero, per ogni nodo:
+ capire se è una foglia: facile, basta guardare il vettore di bit
+ se non è foglia, sapere chi sono i figli:

=== Primitiva child

Dato un certo nodo $x$, vogliamo sapre qual'è il figlio destro o sinistro di $x$.

#figure(
  cetz.canvas({
    import cetz.draw: *

    // Triangolo grande (albero completo) - punta in alto
    line((-3, -2), (3, -2), stroke: 2pt + black) // base
    line((-3, -2), (0, 3), stroke: 2pt + black) // lato sx
    line((3, -2), (0, 3), stroke: 2pt + black) // lato dx

    // ===== ALBERO T' (parte sinistra evidenziata) =====
    content((-1.0, 2.8), text(size: 11pt, weight: "bold")[$T'$])

    // Linea verticale che separa T'
    line((1.25, 1.0), (-1.25, 1.0), stroke: 2pt + red)

    // Nodi interni in T' (cerchietti blu)
    for i in range(3) {
      let y = 2.5 - i * 0.6
      let x = 0 + i * 0.25
      circle((x, y), radius: 0.1, fill: blue, stroke: none)
    }

    // ===== NODO x E SUOI FIGLI =====

    // Nodo x (evidenziato)
    circle((0, 1.5), radius: 0.2, fill: white, stroke: 3pt + red)
    content((0, 1.5), text(size: 9pt, fill: red)[$x$])

    // Figlio sinistro (sotto)
    circle((-1.0, 0.3), radius: 0.15, fill: black, stroke: 2pt + black)
    line((-0.9, 0.5), (-0.2, 1.5), stroke: 2pt + black)
    content((-0.7, -0.2), text(size: 9pt)[$2"rank"_underline(b)(x)+1$])

    // Figlio destro (sotto)
    circle((.9, 0.3), radius: 0.15, fill: black, stroke: 2pt + black)
    line((0.2, 1.50), (0.9, 0.30), stroke: 2pt + black)
    content((0.8, -0.5), text(size: 9pt)[$2"rank"_underline(b)(x)+2$])

    // ===== ETICHETTE E SPIEGAZIONI =====

    content((2.5, 1.5), text(size: 10pt, weight: "bold")[$T$])
    content((2.5, 1), text(size: 9pt)[
      Albero completo
    ])
  }),
  caption: [
    $T'$ contiene tutti i nodi con indice minore di $x$.
  ],
)

Vogliamo stabilire i figli di $x$ in un albero $T$.
Considerando il sottoalbero $mr(T')$ che comprende tutti i nodi dello stesso livello di $x$ e tutti i nodi dei livelli precedenti.

Il numero di nodi interni di $mr(T')$:
- nodi interni di $T$ con indici $< x$
- equivale al numero di $1$ in $underline(b)$ di indici $<x$ = *$"rank"_underline(b)(x)$*

Quindi il numero di nodi di $T'$ è uguale a $2$ volte il numero di nodi interni di $T'$:
*$ 
  2|T'(I)|+1 = 2"rank"_underline(b)(x) + 1 
$*
Dato che i nodi sono numerati a partire da $0$, allora l'indice dei figli di $x$ sono: 
  - $2 "rank"_underline(b)(x) + 1$
  - $2 "rank"_underline(b)(x) + 2$.

=== Primitiva parent 
+ se non è la radice, sapere il genitore:
  #informalmente[
    il genitore di $x$ è un  nodo $p$ tale che $2 "rank"_underline(b)(x) + 1 = x$ oppure $2 "rank"_underline(b)(x) + 2 = x$

    Quindi $ "rank"_underline(b)(x) + 1/2 = x/2 \ "rank"_underline(b)(x) + 1 = x/2 $

    $
      "rank"_underline(b)(x) = floor(x/2 - 1/2) \ ... \
      "select"...
    $
  ]

=== Dati ancillari

Di solito, insieme all'albero vogliamo dei dati memorizzati nei nodi di questo albero

/ Dati ancillari anche sulle foglie: teniamo un array della stessa lunghezza di $b$, con in ogni nodo il dato di quel nodo

/ Dati ancillari solo su nodi interni: terniamo un array lungo quanto solo i nodi interni:
  - usare una select per sapere da un nodo dove sarà il suo dato ancillare
  - usare una rank per sapere da un dato a che nodo corrisponde

== Biiezioni fra Alberi Binari, Alberi Generali e Foreste

/ $B_n$: insieme alberi binari con $n$ nodi *interni*
/ $F_n$: insieme delle foreste ordinate (foresta in cui le radici dei singoli alberi sono ordinate) con $n$ nodi
/ $T_n$: insieme degli alberi generali con $n$ nodi
/ $D_n$: parola di Dyck con $n$ parentesi aperte

#nota[
  Non esiste l'albero vuoto (dato che deve avere una radice), ma esiste la foresta vuota.
]

#nota[
  Cos'è una biiezione? Isomorfismo qualcosa doppio (?) // TODO
]

=== Lift

$ phi : F_n -> T_(n+1) $
trasformiamo la foresta ordinata in un albero solo banalmente aggiungendo un nodo che connette tutte le radici. Questa cosa si chiama lift.
// TODO: disegno

=== First child next sibling (FCNS)

$ psi : F_n -> B_n $
$ psi(emptyset) = "singolo nodo" $
// TODO: disegno

$ |T_(n+1)| = |F_n| = |B_n| = C_n $

=== Parole di Dyck

- $Sigma = {(,)}$
- $s in Sigma^*$ è una parola di Dyck se:
  + il numero di parentesi aperte $\#_\($ è uguale al numero di parentesi chiuse $\#_\)$
  + $forall v$ prefisso di $w$, $\#_\( v >= \#_\) v$

$ alpha : F_n -> D_n $
// TODO disegno

Traduciamo ricorsivamente ogni foresta ad una parola di Dyck

$ |D_n| = |F_n| = C_n $

#attenzione[
  Questa struttura a parentesi rappresenta solo l'alberi, senza dati ancillari.
  Se vogliamo anche dati ancillari bisogna portarsi a dietro un array con informazioni sulle parentesi aperte (complicato).
]
