#import "../imports.typ": *

= Struttura Albero

== Nomenclatura

// TODO: spostare in primo capitolo?

Nomenclatura in teoria dei grafi:

/ Albero: grafo non orientato, conesso ed aciclico
/ Foresta: grafo non orientato ed aciclico (ogni componente connessa è un albero)

Nomenclatura in informatica:

/ Albero: struttura con una radice dove ogni nodo ha dei figli

  #nota[
    Se prendiamo un albero di teoria dei grafi e scegliamo un qualsiasi nodo, allora otteniamo un albero radicato (quindi nel senso di informatica)
  ]

/ Albero ordinato: albero in cui i figli di un nodo hanno un certo ordine

/ Albero binari: albero in cui ogni nodo ha $0$ o $2$ figli

  #teorema("Proprietà")[
    Il numero di nodi esterni $E$ (foglie) è il numero di nodi interni $I$ (nodi con figli) $+1$:
    $ |E| = |I| + 1 $

    #dimostrazione[
      Non lo dimostriamo, ma si può dimostrare facilmente per induzione strutturale:
      - lo si dimostra sull'albero banale
      - si fa un albero composto da albero banali
      - così via
    ]
  ]

== Struttura succinta per Albero Binario

=== Theoretical Lower Bound

Per poter dire che una struttura è compressa, allora dobbiamo dire qunato è il theoretical lower bound (teorema di shannon), quindi dobbiamo sapere quanti sono i possibili tipi di alberi con $n$ nodi interni

#teorema("Teorema")[
  Il numero di alberi con $n$ nodi intenri è $ C_n = 1/(n+1) binom(2n, n) $
  chiamato il numero di Catalano
]

#nota[
  È utile ricordare l'approssimazione di Stirling:
  $ x! approx sqrt(2 pi x) (x/e)^x $
]

Quindi il theoretical lower bound è
$ C_n approx ... = 1/(n+1) 1/(sqrt(pi n)) 2^(2n) approx 4^n / sqrt(pi n^3) $
Ovvero

$ log C_n approx 2n - O(log n) $

=== Rappresentazione

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

    Dato che i nodi sono contati da $0$, allora l'indice dei figli di $x$ sono $2 "rank"_underline(b)(x) + 1$ e $2 "rank"_underline(b)(x) + 2$.
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
