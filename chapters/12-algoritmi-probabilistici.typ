#import "../imports.typ": *

= Algoritmi Probabilistici

Finora nel corso abbiamo visto solamente problemi risolvibili tramite algoritmi *deterministici*.
Il non determinismo (ad esempio nelle definizioni di classi NP) serve solo per definire quanto è *difficile risolvere* un certo problema, ma questo non determinismo non è mai sfruttato da algoritmi implementabili.
Infatti, le macchine di Turing non deterministiche (come definite nelle definizioni di classi NP) non esistono e quindi non le possiamo usare nella pratica.

== Modello di calcolo probabilistico

Andiamo ora a presentare un nuovo modello di calcolo, al fine di introdurre il concetto di *algoritmi probabilistici*.

Tale modello di calcolo consiste in una classica macchina di Turing, con l'aggiunta di un ulteriore input: una sorgente di *bit casuali* (aleatori).
La macchina di per sé rimane deterministica, il non determinismo è dato dalla lettura dal nastro casuale, ogni bit ha una probabilità di essere $1$ pari a $1/2$.

La macchina $A$ modella, dunque, una *distribuzione di probabilità* sui possibili *output*, ovvero quanto è probabile ricevere un output $y$ dato un input $x$:
$ P_A (y | x) $

#informalmente[
  Il comportamento della macchina non dipende più solamente dall'input, ma anche dal valore dei bit casuali letti.
  Dato che questa sorgente è aleatoria, diverse esecuzioni con lo stesso input $x$ potrebbero portare a diversi output $y$.
]

#nota[
  Le sorgenti di bit aleatori non esistono davvero nella pratica.

  Innanzitutto bisogna definire cosa significa casuale: conoscendo perfettamente il contesto, allora è sempre possibile determinare con certezza il risultato.

  #esempio[
    Conoscendo il peso della moneta, la densità dell'aria, il vento e la forza applicata al lancio, anche il lancio di una moneta è deterministico in linea di principio, basta fare perfettamente i calcoli della traiettoria.
  ]

  In secondo luogo, i computer sono macchine strettamente deterministiche, non sono capaci di generare numeri casuali.
  Quando hanno bisogno di bit casuali si affidano ad algoritmi deterministici che simulano sorgenti casuali.
  Questa generazione è chiamata generazione di bit *pseudocasuali*.

  Noi ignoreremo entrambi questi problemi, assumendo l'esistenza di una sorgente di bit casuali, dove ogni bit ha probabilità di essere $1$ pari a $1/2$.
]
