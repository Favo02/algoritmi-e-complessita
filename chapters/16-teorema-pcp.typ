#import "../imports.typ": *

= Teorema PCP (picipi)

== Introduzione al teorema PCP

#informalmente()[
  Utilizzeremo il teorema PCP per dimostrare delle proprietà di Inapprossimabilità per quanto riguarda dei problemi di decisione. 
]

=== Macchine di Turing con oracolo

Per introdurre il teorema PCP, dobbiamo introdurre un nuovo modello di calcolo, ovvero le Macchine di Turing con oracolo. 


#figure(
  cetz.canvas({
    import cetz.draw: *

    // Macchina M (rettangolo principale)
    rect((-1, 0.5), (1, 2), stroke: 3pt + black, fill: gray.lighten(90%))
    content((0, 1.25), text(size: 14pt, weight: "bold")[$M$])

    // Input x
    line((-2.5, 1.25), (-1, 1.25), stroke: 2pt + black)
    line((-1.2, 1.35), (-1, 1.25), stroke: 2pt + black)
    line((-1.2, 1.15), (-1, 1.25), stroke: 2pt + black)
    content((-2, 1.6), text(size: 11pt)[$x in 2^*$])

    // Output YES
    line((1, 1.8), (2.5, 2.5), stroke: 2pt + black)
    line((2.3, 2.4), (2.5, 2.5), stroke: 2pt + black)
    line((2.35, 2.3), (2.5, 2.5), stroke: 2pt + black)
    content((2.8, 2.5), text(size: 11pt)[YES])

    // Output NO
    line((1, 0.8), (2.5, 0.2), stroke: 2pt + black)
    line((2.3, 0.3), (2.5, 0.2), stroke: 2pt + black)
    line((2.35, 0.4), (2.5, 0.2), stroke: 2pt + black)
    content((2.8, 0.2), text(size: 11pt)[NO])

    // Connessione all'oracolo (freccia verso il basso)
    line((0, 0.5), (0, -0.5), stroke: 2pt + black)
    line((-0.1, -0.3), (0, -0.5), stroke: 2pt + black)
    line((0.1, -0.3), (0, -0.5), stroke: 2pt + black)

    // Oracolo (rettangolo in basso)
    rect((-2, -1.5), (2, -0.5), stroke: 3pt + black, fill: yellow.lighten(80%))
    content((-0.9, -1), text(size: 12pt, weight: "bold")[Oracolo])
    content((0.8, -1), text(size: 11pt)[$w in 2^*$])

    // Query (linee verticali che rappresentano le posizioni interrogate)
    line((-1.2, -1.5), (-1.2, -2.2), stroke: 2pt + black)
    content((-1.2, -2.5), text(size: 9pt)[$i_1$])
    
    line((-0.4, -1.5), (-0.4, -2.2), stroke: 2pt + black)
    content((-0.4, -2.5), text(size: 9pt)[$i_2$])

    content((0.2, -2), text(size: 10pt)[$dots$])

    line((0.8, -1.5), (0.8, -2.2), stroke: 2pt + black)
    content((0.8, -2.5), text(size: 9pt)[$i_q$])

    // Etichetta "Stringa dell'oracolo"
    content((3.5, -1), text(size: 9pt, style: "italic")[Stringa dell'oracolo])
  }),
  caption: [
    Schema di una Macchina di Turing con oracolo.\ 
  ]
)
*Funzionamento*: 
- La macchina $M$ riceve in input una query $x in 2^*$. Essa viene scritta su un apposito nastro.

- Viene interrogato l'oracolo in *$q$* posizioni specifiche (*limitiamo l'accesso all'oracolo*). Le query $Q_i$ interrogano posizioni specifiche $i_j$ della stringa oracolica $w$, ottenendo risposte $b_j in {0,1}$. 

- L'albero delle interrogazioni si ramifica in base alle risposte, portando a una decisione finale YES/NO (foglie). L'output dipende da *$M(x,w)$*

  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== PARTE SINISTRA: NASTRO E ORACOLO =====
      
      // Titolo nastro
      content((-2, 3.2), text(size: 11pt, weight: "bold")[Nastro di Query])
        content((-4, 2.5), text(size: 11pt, weight: "bold")[$Q?$])
      
      // Celle del nastro
      for i in range(5) {
        let x = -3.5 + i * 0.9
        rect((x, 2.2), (x + 0.8, 2.8), stroke: 2pt + black, fill: white)
        if i == 0 {
          content((x + 0.4, 2.5), text(size: 10pt)[$i_1$])
        } else if i == 1 {
          content((x + 0.4, 2.5), text(size: 10pt)[$i_2$])
        } else if i == 2 {
          content((x + 0.4, 2.5), text(size: 10pt)[$i_3$])
        } else if i == 3 {
          content((x + 0.4, 2.5), text(size: 10pt)[$dots$])
        } else {
          content((x + 0.4, 2.5), text(size: 10pt)[$i_q$])
        }
      }

      // Titolo stringa oracolo
      content((-1.0, -0.2), text(size: 11pt, weight: "bold")[Stringa Oracolo $w$])
      
      // Celle della stringa oracolo
      for i in range(7) {
        let x = -3.5 + i * 0.7
        rect((x, 0.2), (x + 0.6, 0.7), stroke: 1.5pt + black, fill: yellow.lighten(80%))
        if i == 1 {
          content((x + 0.3, 0.45), text(size: 9pt)[$b_1$])
        } else if i == 3 {
          content((x + 0.3, 0.45), text(size: 9pt)[$b_2$])
        } else if i == 5 {
          content((x + 0.3, 0.45), text(size: 9pt)[$b_3$])
        } else {
          content((x + 0.3, 0.45), text(size: 8pt)[$dot$])
        }
      }

      // Frecce dalle query alla stringa oracolo
      line((-3.1, 2.2), (-2.9, 0.7), stroke: 2pt + blue)
      line((-2.95, 0.8), (-2.9, 0.7), stroke: 2pt + blue)
      line((-2.85, 0.8), (-2.9, 0.7), stroke: 2pt + blue)
      content((-2.6, 1.5), text(size: 9pt, fill: blue)[$Q_1$])

      line((-2.2, 2.2), (-2, 0.7), stroke: 2pt + blue)
      line((-2.05, 0.8), (-2, 0.7), stroke: 2pt + blue)
      line((-1.95, 0.8), (-2, 0.7), stroke: 2pt + blue)
      content((-1.7, 1.5), text(size: 9pt, fill: blue)[$Q_2$])

      line((-1.3, 2.2), (-1.1, 0.7), stroke: 2pt + blue)
      line((-1.15, 0.8), (-1.1, 0.7), stroke: 2pt + blue)
      line((-1.05, 0.8), (-1.1, 0.7), stroke: 2pt + blue)
      content((-0.8, 1.5), text(size: 9pt, fill: blue)[$Q_3$])

      // ===== PARTE DESTRA: ALBERO DELLE INTERROGAZIONI =====
      content((3.5, 3.2), text(size: 11pt, weight: "bold")[Albero delle Interrogazioni])

      // Radice (più grande)
      circle((3, 2.3), radius: 0.35, fill: white, stroke: 2pt + black)
      content((3, 2.3), text(size: 11pt)[$Q?$])

      // Primo livello (Q₀, Q₁)
      circle((1.8, 1), radius: 0.35, fill: white, stroke: 2pt + black)
      content((1.8, 1), text(size: 10pt)[$Q_0$])
      
      circle((4.2, 1), radius: 0.35, fill: white, stroke: 2pt + black)
      content((4.2, 1), text(size: 10pt)[$Q_1$])

      // Archi dal root
      line((2.85, 2.15), (2, 1.15), stroke: 2pt + black)
      content((1.8, 1.7), text(size: 10pt)[$b=0$])
      
      line((3.15, 2.15), (4, 1.15), stroke: 2pt + black)
      content((4.2, 1.7), text(size: 10pt)[$b=1$])

      // Secondo livello (sotto Q₁)
      circle((3.6, -0.2), radius: 0.35, fill: white, stroke: 2pt + black)
      content((3.6, -0.2), text(size: 9pt)[$Q_0^1$])
      
      circle((4.8, -0.2), radius: 0.35, fill: white, stroke: 2pt + black)
      content((4.8, -0.2), text(size: 9pt)[$Q_1^1$])

      // Archi secondo livello
      line((4.1, 0.85), (3.7, -0.05), stroke: 2pt + black)
      content((3.55, 0.4), text(size: 10pt)[$0$])
      
      line((4.4, 0.85), (4.7, -0.05), stroke: 2pt + black)
      content((4.75, 0.4), text(size: 10pt)[$1$])

      // Foglie (decisioni YES/NO) più grandi
      rect((3.2, -1.1), (4, -0.7), stroke: 2pt + green, fill: green.lighten(90%))
      content((3.6, -0.9), text(size: 9pt, fill: green, weight: "bold")[YES])
      
      rect((4.4, -1.1), (5.2, -0.7), stroke: 2pt + red, fill: red.lighten(90%))
      content((4.8, -0.9), text(size: 9pt, fill: red, weight: "bold")[NO])

      line((3.6, -0.4), (3.6, -0.7), stroke: 2pt + black)
      line((4.8, -0.4), (4.8, -0.7), stroke: 2pt + black)
    }),
  )

#nota()[
  L'Output della macchina *non* dipende solo dall'input $x in 2^*$, ma anche dalla stringa oracolica estratta $w in 2^*$.
]

#teorema("Teorema")[
  Un linguaggio binario $L subset.eq 2^*$ sta in $"NP"$ sse esiste una Macchina di Turing con oracolo $V$ (verificatore) t.c: 
  - $V(x,w)$ risponde in tempo polinomiale in $|x|$.
  - $forall x in 2^* space exists w in 2^*$ t.c $V(x,w)="YES" "sse" x in L$. Ovvero se $x in L$ esiste una stringa dell'oracolo $w$ che fa accettare $x$. Se $x in.not L$ non esiste alcuna stringa che lo fa accettare.

  #informalmente()[
    Andiamo a guardare tutte i rami di esecuzione dell'albero delle interrogazioni. La stringa oracolica *$w$* è la rappresentazione binaria di un *ramo* (traccia i valori restituiti da un istruzione magica). Quando chiediamo che esista una stringa $w$, stiamo chiedendo che ci sia un ramo dove l'input $x$ viene accettato.
  ] 
]

=== Macchine di Turing con oracolo e probabilistiche

Oltre all'oracolo questo modello di calcolo presenta anche un vettore di probabilità. 
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // Titolo
      content((0, 3.8), text(size: 12pt, weight: "bold")[Macchina di Turing Probabilistica con Oracolo])

      // Input x dall'alto
      line((0, 3), (0, 2.5), stroke: 2pt + black)
      line((-0.1, 2.7), (0, 2.5), stroke: 2pt + black)
      line((0.1, 2.7), (0, 2.5), stroke: 2pt + black)
      content((0.5, 3.2), text(size: 12pt)[$x in 2^*$])

      // Bit random dall'alto a sinistra
      line((-1.5, 2.8), (-0.8, 2.2), stroke: 2pt + purple)
      line((-0.9, 2.3), (-0.8, 2.2), stroke: 2pt + purple)
      line((-0.95, 2.1), (-0.8, 2.2), stroke: 2pt + purple)
      content((-2.2, 3.1), text(size: 11pt, fill: purple)[$r <= 2^*$ bit random])

      // Macchina V (rettangolo principale)
      rect((-1.2, 0.3), (1.2, 2.5), stroke: 3pt + black, fill: gray.lighten(90%))
      content((0, 1.4), text(size: 16pt, weight: "bold")[$V$])
      content((0, 0.8), text(size: 10pt)[$V(x,w,pi)$])

      // Output YES (destra alto)
      line((1.2, 2), (2.8, 2.8), stroke: 2pt + black)
      line((2.6, 2.7), (2.8, 2.8), stroke: 2pt + black)
      line((2.65, 2.6), (2.8, 2.8), stroke: 2pt + black)
      content((3.2, 2.8), text(size: 11pt)[YES])

      // Output NO (destra basso)
      line((1.2, 0.8), (2.8, 0.2), stroke: 2pt + black)
      line((2.6, 0.3), (2.8, 0.2), stroke: 2pt + black)
      line((2.65, 0.4), (2.8, 0.2), stroke: 2pt + black)
      content((3.2, 0.2), text(size: 11pt)[NO])

      // Connessione all'oracolo (freccia verso il basso)
      line((0, 0.3), (0, -0.5), stroke: 2pt + black)
      line((-0.1, -0.3), (0, -0.5), stroke: 2pt + black)
      line((0.1, -0.3), (0, -0.5), stroke: 2pt + black)
      content((0.7, -0.1), text(size: 9pt)[$q$ query])

      // Oracolo (rettangolo in basso)
      rect((-2, -1.8), (2, -0.5), stroke: 3pt + black, fill: yellow.lighten(80%))
      content((-1, -1.15), text(size: 12pt, weight: "bold")[Oracolo])
      content((0.8, -1.15), text(size: 11pt)[$w in 2^*$])

      // Query (linee verticali)
      line((-1.2, -1.8), (-1.2, -2.5), stroke: 2pt + blue)
      content((-1.2, -2.8), text(size: 9pt)[$i_1$])
      
      line((-0.4, -1.8), (-0.4, -2.5), stroke: 2pt + blue)
      content((-0.4, -2.8), text(size: 9pt)[$i_2$])

      content((0.2, -2.3), text(size: 10pt)[$dots$])

      line((0.8, -1.8), (0.8, -2.5), stroke: 2pt + blue)
      content((0.8, -2.8), text(size: 9pt)[$i_q$])

      // Risposta dall'oracolo
      line((1.5, -0.5), (1.5, 0.1), stroke: 2pt + blue)
      line((1.4, -0.1), (1.5, 0.1), stroke: 2pt + blue)
      line((1.6, -0.1), (1.5, 0.1), stroke: 2pt + blue)
      content((2.3, -0.2), text(size: 9pt, fill: blue)[risposte $b_j$])
    }),
    caption: [
      Schema di una Macchina di Turing probabilistica con oracolo.
    ]
  )
  Funzionamento: 
  - Il verificatore $V$ riceve input $x$, ed estrae $r <= 2^*$ bit random.
  - Intteroga l'oracolo in *$q$* posizioni (r_i), e restituisce YES o NO. 
  - La probabilità di accettazione di $x$, dipende da *tutte* le estrazioni random che portano a YES:
  $ P[v(x,w) = "YES"] = ({r | V(x,w,r) = "yes"}) $
  #nota()[
    L'output della macchina $V$ dipende da $V(x,w,r)$.
  ]











== Classe PCP

- fissare due funzioni
- un verificatore per un linguaggio
  - prende in ingresos una stringa
  - effettua q query all'oracolo
  - estrae al massimo r bit random

#teorema("Teorema")[
  NP = PCP[O(log n), O(1)]
]

noi useremo un verificatore in forma normale:
+ la funzione $r$ (bit random) dice che se ne estrae esattamente quel numero (e non al massimo quel numero)
+ faccio esattamente quelle query (non al massimo)
+ le query sono indipendenti tra loro

== Inapprossimabilità di Max E 3 SAT mediante PCP

lemma...
(vogliamo dire che non esiste una 1+$overline(epsilon)$ approssimabile)

quel al più $k$ clausole si può trasformare in esattamente $k$ clausole (ripetendo alcune ckausole)

dimostrazione:

dimostriamo che non è approssimabile per qualche costante (non riusciamo a determinare la costante, ma dire che esista)

...

- Consideriamo una specifica srtinga $x$.
- Interroghiamo $q$ specifiche posizioni dell'oracolo.
- È possibile descrivere le interrogazioni come una funzione.
- QUesta funzione è possibile scriverla come una formula CNF.
- Un'altra CNF $Phi_x$ che mette in and tutte le singole CNF (che non ho capito perchè sono tante)
- il numero di clausole in questa formula grande è un polinomio

Sia $t^*_x$ il masasimo numero di clausole soddisfacibili in $Phi_x$

/ Primo caso: se $x in L, exists w$ (stringa di bit) che fa accettare con probabilità $1$
  i $w$ sono come degli assegnamenti di valori di verità delle clausole CNF, quinid è riscrivibile come $exists$ assegnamento che rende vere tutte le singole clausole, quindi rende vera la CNF $Phi_x$

  $ t_x^* = P(|x|) $

/ Secondo caso: se $x in.not L, forall w$ fa accettare con probabilità $< 1/2$
  Cioè, $forall w$, non siddisfa $>= 2^r(|x|) / 2$ delle $phi_(x,r)$.
  Queste $phi$ sono fatte da $2^q$ clausole

  Qualunque sia $w$, allora non riesco a rendere vero almeno una delle clausole di almeno metà delle $phi$ CNF

  $forall w$ non siddisfa $>=$ ...

  Questo era il numero di clausole non soddisfacibili, quindi il contrario, ovvero quelle soddisfacibili è al massimo:
  $ t_x^* <= P(|x|) - ... $


Adesso dobbiamo chiudere la dimostraszione per assurdo con un $overline(epsilon)$

$ overline(epsilon) = ... $

SUpponiamo per assurdo che ci sia un algoritmo di ottimizazione $A$ che fornisce una $(1+overline(epsilon))$-approssimazione di MaxCNFSAT

Questo algoritmo al posto di prendere in pasto il riconoscitore prende in pasto una CNF prodotta da questo riconoscitore e restituisce $overline(t)$, un'approssimazione di $t^*$

- $A_x$: $x in L => t^* = P(|x|)$
- $B_x$: $x in.not L => t^* <= P(|x|)(1 - 1/(2^...))$

Vogliamo mostrare che i due casi sono disgiunti e nello specifico che $B_x < A_x$, quindi guardando l'approssimazione capire in che caso siamo. Per assurdo:

se $B_x >= A_X$, allora
$ P(|x|) ... $
impossibile dato che $overline(epsilon)$ deve essere $= 0$, quindi otterremmo una $1$-approssimazione, ovvero l'ottimo, impossibile.

Dato $x$ possiamo decidere in tempo polinomiale se $x$ sta in $L$, allora potremmo decidere $L$, sarebbe in $P$. Ma per ipotesi $L in "NPc"$, quindi assurdo, $qed$.

== Inapprossimabilità di MaxIndependentSet

Problema MaxIndependentSet:
- input $G(V,E)$ non orientato
- sol amm: il contrario di una clique: nessun lato del grafo che ha le due estremità dell'insieme $X$
  $ X subset V "indipendenti", quad E inter binom(X, 2) = emptyset $
- funz ob: $|X|$
- tipo: max

#teorema("Teorema")[
  Per ogni $epsilon > 0$, il problema MaxIndependentSet non è $(2-epsilon)$-approssimabile (in tempo polinomiale, se $"P" != "NP"$)

  #dimostrazione[
    Sia $L subset.eq 2^*$ un linguaggio NP-completo

    $L in "PCP"[r(n), q]$ per una specifica funzione $r(n) in O(log n)$ e $q in bb(N)$.

    Sia $V$ un verificatore per $L$.


    Invece che costruire una formula, costruiamo un grafo $G_x$:
    - vertici: $x$-configurazioni, ovvero una coppia:
      $ (R, {i_1 : b_1, ... i_q : b_q}) $
      ovvero una specifica stringa estratta e le posizioni sulla specifica stringa interrogate all'oracolo e le rispettive risposte
      - $R$ è la stringa estratta da $V$
      - $i_1, ..., i_q$ sono le posizioni interrogate su input $x$ e stringa random $R$
      - $b_q, ..., b_q$ sono le risposte dell'oracolo (ovvero i valori della stringa in quelle posizioni)

      Abbiamo esattamente questo numero di vertici:
      $ |V| <= 2^r(|x|) dot 2^q $
    - lati: c'è un lato tra $(R, {...})$ e $(R', {...})$ se e solo se le configurazioni sono incompatibili, cioè
      - $R = R'$
      - oppure $exists k, k'$ tale che $i_k = i'_k'$ e $b_k != b'_k'$

    #teorema("Fatto")[
      Se $x in L, G_x$ ha un insieme indipendente di cardinalità $>= 2^r(|x|)$

      #dimostrazione[
        $exists w$ che fa accettare con probabilità $1$.
        Prendiamo tutte le configurazioni accettanti compatibili con $w$.
        Queste configurazioni non hanno lati che le collegano (dato che sono compatibili).

        Quindi questo è un insieme indipendente, dato che devo accettare con probabilità $1$, la sua cardinalità deve essere $2^r(|x|)$
      ]
    ]

    #teorema("Fatto")[
      Se $x in.not L$, ogni insieme indipendente di $G_x$ ha cardinalità $<= 2^(r(|x|)-1)$

      #dimostrazione[
        Per assurdo, sia $S subset.eq V_G_x$ un inieme indipendente con $|S| > 2^(r(|x|)-1)$.
        Quindi esiste un $w$ compatibile con tutte le configurazioni.
        Accetto con probabilità $> 1/2$, impossibile, $qed$.
      ]
    ]

    #informalmente[
      Quindi, se $x in L$, allora c'è un insieme indipendente grosso, altrimenti è piccolo (queste due cosi sono disgiunte).
    ]

    Sia $t_x^*$ la cardinalità del MaxIndependentSet per $G_x$:
    - se $x in L => t^*_x >= 2^(r(|x|))$
    - se $x in.not L => t_x^* < 2^(r(|x|))/2$

    Adesso supposiamo che esista un algoritmo che restituisce un $overline(t)$ approssimato, con $overline(t) >= t^* / (2-epsilon)$.

    Guardando i due casi dinsgiunti:
    - $x in L => overline(t) >= t^* / (2-epsilon) >= ...$
    - $x in.not L => overline(t) <= t^* / (2-epsilon) <= ...$
  ]
]
