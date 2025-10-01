#import "../imports.typ": *

= Problema Set Cover [NPOc]

#informalmente[
  Esiste un universo di $n$ _punti_.
  Questi punti sono coperti da $m$ _aree_, ognuna avente un _costo_.
  Le aree possono sovrapporsi (non sono una partizione).

  L'obiettivo è minimizzare il totale costo delle aree _comprate_ coprendo tutti i punti.
]

- $I_Pi$:
  - $S_1, S_2, ..., S_m subset.eq 2^Omega, quad limits(union.big)_(i=1)^m S_i = Omega$: insiemi delle aree che unite coprono tutto l'universo (possono anche sovrapporsi)
  - $w_1, w_2, ..., w_m in bb(Q)^+$: costi delle aree
- $"Amm"_Pi = I subset.eq {1, ..., m}, quad limits(union.big)_(i in I) S_i = Omega$: un insieme di indici di aree che coprono tutti i punti
- $C_Pi$: somma dei costi delle aree selezionate
  $ w = sum_(i in I) w_i $
- $t_Pi = min$

#teorema("Teorema")[
  *$ "SetCover" in "NPOc" $*
]

// TODO: disegno

== Funzione Armonica

#todo
// TODO: finire funzione armonica

Per dimostrare alcune proprietà di Set Cover, abbiamo bisogno di introdurre la funzione armonica e alcune sue proprietà.

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

Durante l'esecuzione abbiamo utilizzato il *prezzo* (_pricing_).
Questo valore è definito *solo all'istante* in cui il punto sta *venendo coperto* da un'area $S_i$.
Per ogni punto $c_s$, definiamolo come il rapporto tra il _costo_ di un'area e il numero di punti non ancora presi dell'area:
$ forall s in S_i inter R, quad s_c = w_i / (|S_i inter R|) $

#attenzione[
  Differenziamo:
  - *costo*: costo pagato per selezionare un area, non varia durante l'esecuzione
  - *prezzo*: rapporto tra il _costo_ di un'area e il numero di punti non ancora presi dell'area, cambia durante l'esecuzione (dato che il numero di punti non presi di una certa area potrebbe diminuire)
]

#nota[
  L'algoritmo utilizza il prezzo su un'_area_, mentre lo abbiamo definito su un _punto_.
  Ma *tutti* i punti di una certa area (allo stesso istante) hanno lo *stesso prezzo*, di conseguenza minimizzare il rapporto per un'area o per un punto è equivalente.
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
      Se un'area $S$ costa $10$ e ha $5$ punti (non ancora coperti), allora il prezzo di ogni punto sarà $c_s = 10 / 5 = 2$. Ma sommandolo per ogni punto $sum_(s in S) c_s = 5 dot 2 = 10$.

      In caso la stessa area avesse un punto già coperto (quindi $|S \\ R| = 4$), allora funzionerebbe lo stesso:
      $c_s = 10 / 4 = 2.5, quad sum_(s in S) c_s = 4 dot 2.5 = 10$.
    ]

    Ma scorrere per ogni area $mb(i in I)$ tutti i punti non ancora presi $mb(s in S_i inter R)$, equivale a scorrere tutti i punti dell'universo $mg(s in Omega)$:
    $ w = sum_(i in I) w_i = sum_(i in I) sum_(s in S_i inter R) c_s = mg(sum_(s in Omega) c_s) space qed $
  ]
]

#teorema("Teorema")[
  Per ogni area, la somma dei prezzi dei punti contenuti è limitata superiormente dalla funzione armonica:

  $ forall k in m, quad sum_(s in S_k) c_s <= H(|S_k|) dot w_k $

  #attenzione[
    Dato che i prezzi dei punti contenuti cambiano durante l'esecuzione, i vari punti potrebbero avere prezzo quando sono stati coperti diversi.
  ]

  #dimostrazione[
    Senza perdita di generalità (vale per ogni $k$), scegliamo un $k in m$.

    L'area $S_k$ ha cardinalità $d$ ed è composta dai punti:
    $ S_k = {s_1, s_2, ..., s_d} $

    Questi punti sono ordinati _(a blocchi)_ in ordine di copertura, ovvero $s_i$ è stato coperto prima (o allo stesso istante) di $s_(i+1) space forall i in d$.
  ]
]
