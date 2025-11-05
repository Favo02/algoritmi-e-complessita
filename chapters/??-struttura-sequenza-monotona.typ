#import "../imports.typ": *

= Struttura Sequenza Monotona

== ADT

Abbiamo una sequenza monotona:
$ 0 <= x_0 <= x_1 <= ... <= x_(n-1) < U $

C'è una sola primitiva d'accesso: dato $i$, vogliamo sapere chi è $x_i$

Rappresentazione naive: scrivo ogni intero con $log U$ bit.

#informalmente[
  Questa cosa si può usare ad esempio in webgraph, come lista di adiancenza dei nodi di un grafo.
]

== Rappresentazione quasi-succinta di Elias-Fano

Dividiamo ogni intero in bit significativi e meno significativi.

I bit meno significativi li rappresentiamo esplciitamente:
$ l = max(0, floor(log U/n)) $
Lower parts:
- $l_0 = x_0 mod 2^l$
- $l_1 = x_1 mod 2^l$

Le parti significative le rappresentiamo esplciitamente in unario:
$ u_i = floor(x_i/ 2^l) - floor(x_(i-1)/2^l) $
Quindi scriviamoo $u_0$ zeri e un $1$, poi $u_1$ zero e un uno, ...

Spazio occupato:
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
