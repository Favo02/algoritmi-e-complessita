#import "../imports.typ": *

= Algoritmi Probabilistici

Fin'ora nel corso abbiamo visto solamente problemi risolvibili tramite algoritmi deterministici.\
Il non determinismo (ad esempio delle classi NP), serve solo per definire quanto è difficile risovlere un certo problema. Infatti, le macchine di Turing non deterministiche non esistono

=== Modello di calcolo non deterministico

Andiamo ora a presentare un nuovo modello di calcolo, al fine di formalizzare il concetto di non determinismo.\
Tale modello di calcolo consiste in una macchina di Turing classica con l'aggiunta di una sorgente di bit casuali extra. La macchina rimane deterministica, ma può legge dal nastro un bit casuale con $p = 1/2$.\
#nota()[
  Il comportamente della macchina non dipende più solamente dall'input e dall'output, ma anche dal valore del bit letto.
] 

La macchia modella dunque una *distribuzione di probabilà sui possibili output*, ovvero quanto è probabile ricevere un output $y$ dato un input $x$:
$ P_(A)(y | x) $

#nota()[
  Per un certo $x$ fissato, la macchina potrebbe produrre output $y$ diversi 
]

#nota[
  Le sorgenti di bit aleatori non esistono davvero nella pratica: 
  - Questione filosofica: cosa vuol dire che un evento è probabile (è possibile determinarne l'esito a priori?)
  - I computer sono macchine strettamente deterministiche, non sono capaci di generare numeri casuali.

  La soluzione adottata nella pratica è sfruttare le sorgenti di bit pseudocasuali.
]
