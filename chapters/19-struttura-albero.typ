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
      - *Passo base* = Albero con un solo nodo $|E| = 1, |I| = 0 space  qed$
      - *Passo induttivo* = ALbero $T$ con due sottoalberi $T_1$ e $T_2$.
      $
        |E(T)| = |E(T_1)| + |E(T_2)|\
        mb("Siccome" |E(T_1)| < |E(T)| "uso ipotesi induttiva")\
        |E(T)| = underbrace(|I(T_1)|+1+|I(T_2)|,I(T))+1\
        |E(T)| = |I(T)| + underbrace(1,"radice di" T) space qed
      $
    ]
  ]
  #nota()[
    In un albero il numero di nodi totale $n$ è dato da: 
    $ n = |E|+|I| $
    Possiamo scriverlo come: 
    $
      n &= |E| + |E| - 1 = 2|E|-1\
      n &= |I|+1 + |I| = 2|I|+1 
    $
  ]

== Struttura succinta per Albero Binario

=== Theoretical Lower Bound

Per poter affermare che una struttura è compressa, allora dobbiamo quantificare il theoretical lower bound (teorema di shannon). Vogliamo stabilire quanti sono i possibili tipi di alberi binari con *$n$ nodi interni* 

#teorema("Teorema")[
  Il numero di alberi binari con $n$ nodi intenri è $ 
    C_n = 1/(n+1) binom(2n, n) 
  $
  chiamato il *numero di Catalano*
]

#nota[
  Proprietà utili:
  - Approssimazione di Stirling:
    $ x! approx sqrt(2 pi x) (x/e)^x $
  - Definizione binomiale: 
    $ binom(n,k) = n! / k!(n-k)! $
]<Proprietà-utili-alberi>

Quindi il theoretical lower bound è: 
$ 
  C_n = 1/(n+1) binom(2n, n) = 1/(n+1) dot (2n!) / ((n)! dot (2n-n)!) = 1/(n+1) dot (2n!) / ((n)! dot (n)!) 
$
Usando Stirling #link-teorema(<Proprietà-utili-alberi>) con $x = 2n$ e $x = n$:
$
  C_n = 1/(n+1) dot (2n!) / ((n)!^2) &approx 1/(n+1) dot (sqrt(4 pi n) ((2n)/e)^(2n)) / (sqrt(2 pi n) (n/e)^n)^2\
                                    &= 1/(n+1) dot (2 sqrt( pi n)((2n)/e)^(2n))/(2 pi n (n/e)^(2n))\
                                    &= 1/(n+1) dot (sqrt(pi n)((2n)/e)^(2n)) / (pi n (n/e)^(2n))\
                                    &mb(a^x/b^x = (a/b)^x)\
                                    &= 1/(n+1) dot sqrt(pi n)/(pi n) dot mb((2n)/e dot e/n)^(2n)\
                                    &= 1/(n+1) dot sqrt(pi n)/(pi n) dot 2^(2n)\
                                    &mb(a^x / a^y = a^(x-y))\
                                    &= 1/(n+1) dot mb((pi n)^(1/2)/(pi n)^1) dot 2^(2n)\
                                    &= 1/(n+1) dot (pi n)^(-1/2) dot 2^(2n)\
                                    &= 1/(n+1) dot 1/sqrt(pi n) dot 2^(2n)\
                                    &approx 4^n / (sqrt(pi n^3))                
$
Il numero di bit minimo per rappresentare un albero binario è pari a: 
$
  log_2 C_n approx log_2(4^n/sqrt(pi n^3)) &= log_2(2^2n)-log_2(1/sqrt(pi n^3))\
                                           &= 2n dot 1 - log_2(1/sqrt(pi n^3))\
                                           &approx 2n - O(log n) space qed
                                        
$
#nota()[
  Il theoretical lower bound è $2n$, servono *almeno $2n$ bit* per rappresentare un *albero binario* con *$n$ foglie*.
]

=== Rappresentazione succinta

Numeriamo i nodi da $0$ come farebbe una BFS, questo è il nome del nodo

#nota[
  I figli sinistri saranno sempre indici dispari, i figli pari saranno sempre indici pari.
]

Possiamo memorizzare l'albero memorizzando un vettore che memorizza se un nodo è interno o esterno, e una struttura di rank/select su questo vettore:
$ underbrace(2n+1, "array") + underbrace(o(2n+1), "rank/select") = 2n + o(n) $

quindi succinto

=== Navigare l'albero

Con questa struttura, dobbiamo poter navigare l'albero, quinid per ogni nodo:
+ capire se è una foglia: facile, basta guardare il vettore di bit
+ se non è foglia, sapere chi sono i figli:
  #informalmente[
    // TODO: disegno

    per capire i figli di $x$ in un albero $T$ iniziamo considerando il sottoalbero $T'$ che comprende tutti i nodi del livello stesso a sinistra e tutti i livelli precedenti.

    Il numero di nodi interni di $T'$: nodi interni di $T$ con indici minori di $x$, quindi il numero di $1$ in $underline(b)$ di indici $<x = "rank"_underline(b)(x)$

    Quindi il numero di nodi di $T'$ è uguale a $2$ volte il numero di nodi interni di $T'$, quindi $2 "rank"_underline(b)(x) + 1$.

    Dato che i nodi sono contati da $0$, allor a l'indice dei figli di $x$ sono $2 "rank"_underline(b)(x) + 1$ e $2 "rank"_underline(b)(x) + 2$.
  ]
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
