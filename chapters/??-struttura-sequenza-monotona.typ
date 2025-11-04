#import "../imports.typ": *

= Struttura Sequenza Monotona

== ADT

Abbiamo una sequenza monotona:
$ 0 <= x_0 <= x_1 <= ... <= x_(n-1) < U $

C'è una sola primitiva d'accesso: dato $i$, vogliamo sapere chi è $x_i$

Rappresentazione naive: scrivo ogni intero con $log U$ bit.

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
