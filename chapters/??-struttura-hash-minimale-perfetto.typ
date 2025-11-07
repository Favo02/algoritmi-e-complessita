#import "../imports.typ": *

= Struttura Hash Minimale Perfetto (MPH)

Sia $S subset.eq U$ e $m in bb(N)$ fissato.

Una funzione di hash $ h : U -> m $ si dice:
+ *perfetta* per $S$ se "non ha conflitti su $S$", ovvero è iniettiva su quel sottoinsieme
  $
    forall x, y in S, quad x != y => h(x) != h(y) \
    => |S| <= m
  $
+ *minimale perfetta* sse perfetta e $|S| = m$

== Utilità

A cosa servono?

Supponiamo di avere $S subset.eq U$ e $h : U -> n$ minimale perfetta per $S$.

Se vogliamo ad esempio enumerare gli elementi di $S$, allora possiamo semplicemente metterli in un array e indicizzare questo array con $h$.

== Costruzione

Si può costruire una funzione minimale perfetta? Si

=== Primo modo: ORMPH

Fissa $h$ a priori e usa MWHC.
Ovvero semplicemente enumera tutte le chiavi di $S$, associandogli un indice qualsiasi tra $0$ e $n-1$.
Esistono esattamente $n!$ ordini possibili.

Order reserving minimal perfect hash (ORMPH):
fissiamo in che ordine vogliamo le chiavi

Poi memorizza questo valore con MWHC.

Quindi servono
$
  n r + gamma n + o(n) => \
  n log n + gamma n + o(n)
$

$Z_n = log n! approx n log n$ quindi è succinta.
Però abbiamo risolto un problema molto più complesso, ovvero abbiamo voluto decidere noi l'ordine delle chiavi.
Ma per essere minimale perfetto basta un ordine qualsiasi.

$ Z_"MPH" < Z_"OPMPH" $

Esiste anche un caso intermedio:
- non voglio un ordine qualsiasi (MPH)
- ma non voglio un ordine che scelgo io (OPMPH)
- vogliamo come ordine l'ordine lessicografico: Monotone Minimal Perfect Hash (MMPH)

$ Z_"MPH" < Z_"MMPH" < Z_"OPMPH" $


=== Secondo modo: variante di MWHC

Non ci interessa l'ordine delle chiavi, va bene uno qualsiasi

Quando costruiamo MWHC, abbiamo un sistema di equazioni.
Ma fino a quando non lo risolviamo, non abbiamo ancora deciso cosa c'è a destra dell'equazione.
L'unica cosa che lo sappiamo è esiste un hinge, ovvero un indice che non è mai apparso prima.

Quindi possiamo mettere a destra dell'equazione l'indice dello hinge, che è, per definizione, mai usato prima.

Così abbiamo fissa una perfect hash (non minimale), dato che avremo solo $n$ valori (indici degli hinge) tra $0$ e $m-1$ e non esattamente $m$.
La chiamiamo $tilde(h)$.

Spazio occupato da $tilde(h)$:
$
  n r + gamma n + o(n) \
  = n log m + gamma n + o(n) \
  = n log (gamma n) + gamma n + o(n) \
  = n log n + n log gamma + gamma n + o(n)
$

Ma non abbiamo bisogno di mettere come valore il valore dell'hinge.
Possiamo mettere direttamente l'hinge. ??????

Ovvero quale funzione di hash (tra le 3 usate) ha dato quel valore ???????

$tilde(s) = h_((x_h_0(s))) ...$

Adesos occupiamo:
$
  n r + gamma n + o(n) \
  = 2 n + gamma n + o(n)
$

Ma questa cosa non è ancora minimale (abbiamo $n$ valori):

quindi facciamo un vettore di $m$ bit e mettiamo a $1$ i valori output della funzione perfetta e poi facciamo una rank/select su questa cosa.

#nota[
  Questa tecnica è generale e molto potente.

  Dato che la funzione (perfetta) restituisce un output più sparso di quello che ci serve, comprimiamo questo output usando un vettore di bit e una rank/select.
]

== Information Theoretical Lower Bound

Calcolare quante sono le MPH con chiavi nell'universo $U$?
$ h : U -> n $

Per ogni $s$ fatto scegliendo esattamente un $x in h^(-1)(k) forall k in {0, ..., n-1}$ allora $h$ è minimale perfetta per $S$.
Si dice che $h$ separa $S$.

Se ci viene dato un insieme di funzioni:
$ H = {h_0, h_1, ..., h_(t-1)} $
$H$ è un $n$-sistema se $forall S subset.eq U quad |S| n$, $exists i = 0, ..., t-1$ tale che $h_i$ separa $S$.

#informalmente[
  Se troviamo un $n$-sistema, allora abbiamo trovato un insieme di funzioni di hash che per qualsiasi cardinalità di insieme possiamo trovare una funzione minimale perfetta.
]

Quanto è grande il più piccolo $n$-sistema?

Chiamiamo $H_U(n)$ la cardinalità del più piccolo $n$-sistema.
$ Z_n = log H_U(n) $

Quandi sono gli insiemi di carinalità? $binom(U, n)$

Ogni funzione di hash separi al massimo $v$ insiemi di cardinalità $n$.
$ v approx (U/n)^n $

Dato che vogliamo separare $H_U(n)$ insiemi ed esistono $binom(U, n)$ funzioni, ma ognuna separa al massimo $v$, allora deve:
$ H_U(n) >= binom(U, n) / v $

Quindi
$ H_U(n) >= binom(U, n)/(U / n)^n $

$
  ln H_U(n) >= n + O(ln n) \
  log H_U(n) = (ln H_U(n)) / (ln 2) \
  >= n / (ln 2) + O (ln n) \
  = 1.44 n + O(ln n)
$

Quindi il theoretical lower bound è $Z_n$:
$ Z_n >= 1.44 n + O(ln n) $

Noi abbiamo usato
$ 2 n + gamma n + o (n) + gamma n + o(n) $

Quindi è compatta.
