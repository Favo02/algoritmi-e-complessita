#import "../imports.typ": *

= Algoritmi Probabilistici

Fin'ora abbiamo visto solo problemi risolti tramite algoritmi deterministici.
Il non determinismo (ad esempio delle classi NP), serve solo per definire quanto è difficile risovlere quel problema.
Le MdT non deterministiche non esistono e infatti non le sfruttavamo.

Adesso invece andiamo a considerare delle Macchine di Turing con una sorgente di bit casuali extra.
Questo di solito viene formalizzato come un nastro extra.

La macchina A rimane deterministica, ma può effettuare delle letture random dalla sorgente, quindi l'output non è più deterministico, dipende anche dalla sorgente random.

Questa cosa può essere modellata come una probabilità, ovvero quanto sia probabile ricevere un output $y$ dato un input $x$:
$ P_(A)(y | x) $

#nota[
  Le sorgenti di bit aleatori non esistono davvero.
  C'è anche una questione filosofica su cosa è una cosa random (ad esmepio, una moneta è random? se conoscessimo perfettamente il colpo chegli diamo, il peso della moneta, la rarefazione dell'aria allora sapremmo prevedere il risultato).

  I computer di oggi sono macchine strettamente deterministiche, non sono capaci di generare numeri casuali.

  La soluzione che usiamo è sfruttare le sorgenti di bit pseudocasuali, ovvero generatori che cercano di assomigliare a sorgenti casuali ma non sono veramente casuali.
]
