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
]<teormea-l-in-np>

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
      content((-2.2, 3.1), text(size: 11pt, fill: purple)[$r in 2^*$ bit random])

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
  - Il verificatore $V$ riceve input $x$, ed estrae $r in 2^*$ bit random.
  - Intteroga l'oracolo in *$q$* posizioni (r_i), e restituisce YES o NO. 
  - La probabilità di accettazione di $x$, dipende da *tutte* le estrazioni random che portano a YES:
  $ P[v(x,w) = "YES"] = ({r | V(x,w,r) = "yes"}) $
  #nota()[
    L'output della macchina $V$ dipende da $V(x,w,r)$.
  ]

== Classe PCP

Siano $r,q$ due funzioni: *$r,q: bb(N) -> bb(N)$*.\
La classe $"PCP"[r,q] subset.eq 2^(2^*)$ è la classe dei linguaggi $L subset.eq 2^*$ t.c esiste un probabilistc checker $V$ t.c: 
1. $V$ lavora in tempo polinomiale
2. $V$ effettua al più $q(|x|)$ query
3. $V$ estrae al più $r(|x|)$ bit random
4. Sia $x in 2^*$, una stringa di bit: 
   $
     cases(
      "Se" mb( x in L) "allora" exists w in 2^* "t.c" P[V(x,w)="YES"]=1,
      "Se" mr(x in.not L) "allora" forall w in 2^* P[V(x,w)="YES"]<1/2 
     )
   $

  #attenzione()[
    Se $x in L$, deve esistere una stringa oracolica $w in 2^*$ tale che il verificatore accetti sempre, *indipendentemente dalla stringa random $R$* che capita di estrarre.
  ]

#nota[
  - *$"PCP"[0,0] = P$*. L'oracolo e la sorgente di bit random sono inutilizzabili. L'output dipende solo dall'input $V(x) = y$, se $x in L$ viene accettato dal verificatore. 

  - *$"PCP"[0,"Poly"] = "NP"$*. Posso accedere all'oracolo solo un numero polinomiale di volte e non possono essere estratti bit random. 
]

 #teorema("Teorema")[
    *$"NP" = "PCP"["O"(log n), O(1)]$*.\
    Per la definizione di PCP, dato un qualunque linguaggio $L in "NP"$: 
    $
      exists underbrace(q in bb(N),"costante"), exists underbrace(r(n) in O(log n),"funzione logaritmica") "t.c" L in "PCP"[r(n),q]
    $
    Il linguaggio $L$ è accettato da un classificatore $V$ che usa $q$ interrogazioni all'oracolo e un numero logaritmico di bit random (è una sorta di *trade-off*). 

    #informalmente()[
      Il verificatore $V$ presenta un *trade-off* fra randomness e non determinismo. Con una quantità di bit random logaritmica sono in grado di ridurre il numero di query all'oracolo a una costante.

      La probabilità è *esponenzialmente* più forte del non determinismo.    
    ]
  ]
  Per costruire un verificatore in grado di riconoscere il linguaggio $L in "NP"$ useremo un verificatore in forma normale (è possibile ricondurre un qualsiasi verificatore $V[O(log(n)),O(1)]$ che opera in forma normale). 

  === Verificatori in forma normale

  Sia $L in 2^(2*)$ un linguaggio, $L in "PCP"[r(n),q]$. Esiste un verificatore $V$ in grado di accettare $L$, costruito nel seguente modo: 
  - $V$ prende in input una query $x in 2^*$
  - $V$ estrae $<= r(n)$ bit random, chiamo con $R$ la stringa estratta, $R in 2^r(|x|)$ bit.
  - $V$ accede al oracolo un numero $<= q$ di volte. Dato $(x,R)$, il verificatore decide di interrogare $q$ posizioni specifice dell'oracolo $i_1(x,R), dots, i_q (x,R)$




  #nota[ 
    I bit random $R$ servono per "amplificare" la distinzione tra istanze "YES" e "NO". Provando tutte le possibili estrazioni random, trasformiamo una garanzia probabilistica in una garanzia deterministica sulla soddisfacibilità della CNF. 
  ]

  #nota()[
    Faremo le seguenti *assunzioni*:
    1. Assumiamo che il verificatore $V$ legga *essattamente* $q$ bit dall'oracolo $w$ e estrae *esattamente* $2^r(n)$ bit random. Si tratta di un assunzione *wrost-case* (passo da $<=$ ad $=$)

    2. Posso assumere che tutti i bit randomo vengano estratti all'inizio. Dopo aver letto l'input il verificatore $V$ estraee $R in 2^(r(n))$

    3. Posso assumere che le $q$ posizione della stringa oracolica $w$ lette  da $V$ siano *fisse* e dipendenti solo da *$x$* e da *$R$*.
    #dimostrazione()[ //TODO RINCONTROLLARE
      Inizialmente ci troviamo nella seguente situazione. 
      #figure(
        cetz.canvas({
          import cetz.draw: *

          // Input e stringa random in alto
          content((0, 5.9), text(size: 11pt)[$x in 2^* \ R in 2^(r(n))$])
          line((0, 5.3), (0, 4.8), stroke: 2pt + black)
          line((-0.1, 5), (0, 4.8), stroke: 2pt + black)
          line((0.1, 5), (0, 4.8), stroke: 2pt + black)


          // Livello 0: radice
          rect((-1, 4.3), (1, 4.8), stroke: 2pt + black, fill: gray.lighten(90%))
          content((0, 4.55), text(size: 11pt, weight: "bold")[$W_(i_1)(x,R)$])

          // Archi dal livello 0 al livello 1
          line((-0.5, 4.3), (-2, 3.3), stroke: 2pt + black)
          content((-1.5, 3.9), text(size: 10pt)[$0$])
          
          line((0.5, 4.3), (2, 3.3), stroke: 2pt + black)
          content((1.5, 3.9), text(size: 10pt)[$1$])

          // Livello 1: due nodi
          rect((-3, 2.8), (-1, 3.3), stroke: 2pt + black, fill: gray.lighten(90%))
          content((-2, 3.05), text(size: 10pt)[$W_(i_2^0)(x,R)$])

          rect((1, 2.8), (3, 3.3), stroke: 2pt + black, fill: gray.lighten(90%))
          content((2, 3.05), text(size: 10pt)[$W_(i_2^1)(x,R)$])

          // Archi dal livello 1 al livello 2 (sinistra)
          line((-2.5, 2.8), (-3.5, 1.8), stroke: 2pt + black)
          content((-3.2, 2.4), text(size: 9pt)[$0$])
          
          line((-1.5, 2.8), (-0.5, 1.8), stroke: 2pt + black)
          content((-0.8, 2.4), text(size: 9pt)[$1$])

          // Archi dal livello 1 al livello 2 (destra)
          line((1.5, 2.8), (0.5, 1.8), stroke: 2pt + black)
          content((0.8, 2.4), text(size: 9pt)[$0$])
          
          line((2.5, 2.8), (3.5, 1.8), stroke: 2pt + black)
          content((3.2, 2.4), text(size: 9pt)[$1$])

          // Livello 2: quattro nodi (rappresentati)
          rect((-4.5, 1.3), (-2.5, 1.8), stroke: 2pt + black, fill: gray.lighten(90%))
          content((-3.5, 1.55), text(size: 9pt)[$W_(i_3)^(00)(x,R)$])

          rect((-1.5, 1.3), (0.5, 1.8), stroke: 2pt + black, fill: gray.lighten(90%))
          content((-0.5, 1.55), text(size: 9pt)[$W_(i_3)^(01)(x,R)$])

          // Puntini per indicare continuazione
          content((0, 0.8), text(size: 14pt)[$dots.v$])

          // Livello q (foglie) - alcuni esempi
          rect((-5, -0.5), (-3.5, 0), stroke: 2pt + black, fill: gray.lighten(90%))
          content((-4.25, -0.25), text(size: 9pt)[$W_(i_q)(x,R)$])

          rect((-2, -0.5), (-0.5, 0), stroke: 2pt + black, fill: gray.lighten(90%))
          content((-1.25, -0.25), text(size: 9pt)[$W_(i_q)(x,R)$])

          rect((0.5, -0.5), (2, 0), stroke: 2pt + black, fill: gray.lighten(90%))
          content((1.25, -0.25), text(size: 9pt)[$W_(i_q)(x,R)$])

          rect((3, -0.5), (4.5, 0), stroke: 2pt + black, fill: gray.lighten(90%))
          content((3.75, -0.25), text(size: 9pt)[$W_(i_q)(x,R)$])

          // Etichetta profondità
          line((5, 4.5), (5, -0.25), stroke: 2pt + black)
          line((4.9, 4.4), (5, 4.5), stroke: 2pt + black)
          line((5.1, 4.4), (5, 4.5), stroke: 2pt + black)
          content((5.5, 2), text(size: 11pt)[$q$])

        }),
        caption: [
          Albero delle interrogazioni del *verificatore adattivo*.\
          Le posizioni dell'$i$-esima query che vengono interrogate dipendono dal risultato \ delle *$i-1$ query precedenti*.\
          $W_(i_2)^0$ = chiedo la posizione $i_2$ suppendo che la query precedente abbia avuto risposta $0$. 
        ]
      )
      Siccome *l'albero* delle interrogazioni è *alto $q$* (costante) e ogni nodo ha al massimo $2$ figli, l'abero ha al massimo *$2^q$ foglie*. Possiamo collezionare tutte le possibili posizioni dell'oracolo che vengono interrogate lungo un qualsiasi ramo, ci sono al massimo *$overline(q) = 2^q$* posizioni distinte (numero di nodi interni). Per questo scopo utilizziamo una DFS o BFS. Il risultato di questa operazione è un *oracolo non adattivo* in cui: 
      - Inizialmente vengono collezionate tutte le $overline(q) = 2^q$ possibili interrogazioni.
      - L'oracolo viene interrogato $2^q$ volte, tuttavia siccome $q=O(1)$, anche $overline(q) = O(1)$  
      - Successivamente viene simulata l'esecuzione usando le risposte già collezionate.

      Il costo di questa operazione è una crescita esponenziale del numero di query (rimane una costante) 


      #esempio()[
      #figure(
        cetz.canvas({
          import cetz.draw: *

          // Input e stringa random in alto
          content((-1, 5.8), text(size: 11pt)[$q = 3$])
          content((1, 5.8), text(size: 11pt)[$x, R$])
          
          line((0, 5.3), (0, 4.8), stroke: 2pt + black)
          line((-0.1, 5), (0, 4.8), stroke: 2pt + black)
          line((0.1, 5), (0, 4.8), stroke: 2pt + black)

          // Livello 0: radice
          rect((-1.2, 4.1), (1.2, 4.8), stroke: 2pt + black, fill: gray.lighten(90%))
          content((0, 4.45), text(size: 12pt, weight: "bold")[$W_(13)$ ?])

          // Archi dal livello 0 al livello 1
          line((-0.6, 4.1), (-3, 2.9), stroke: 2pt + black)
          content((-2.2, 3.6), text(size: 11pt)[$0$])
          
          line((0.6, 4.1), (3, 2.9), stroke: 2pt + black)
          content((2.2, 3.6), text(size: 11pt)[$1$])

          // Livello 1: due nodi
          rect((-4.2, 2.2), (-1.8, 2.9), stroke: 2pt + black, fill: gray.lighten(90%))
          content((-3, 2.55), text(size: 11pt, weight: "bold")[$W_(17)$ ?])

          rect((1.8, 2.2), (4.2, 2.9), stroke: 2pt + black, fill: gray.lighten(90%))
          content((3, 2.55), text(size: 11pt, weight: "bold")[$W_(42)$ ?])

          // Archi dal livello 1 al livello 2 (sinistra)
          line((-3.6, 2.2), (-4.5, 0.8), stroke: 2pt + black)
          content((-4.2, 1.6), text(size: 10pt)[$0$])
          
          line((-2.4, 2.2), (-1.5, 0.8), stroke: 2pt + black)
          content((-1.8, 1.6), text(size: 10pt)[$1$])

          // Archi dal livello 1 al livello 2 (destra)
          line((2.4, 2.2), (1.5, 0.8), stroke: 2pt + black)
          content((1.8, 1.6), text(size: 10pt)[$0$])
          
          line((3.6, 2.2), (4.5, 0.8), stroke: 2pt + black)
          content((4.2, 1.6), text(size: 10pt)[$1$])

          // Livello 2 (foglie): quattro nodi
          rect((-5.5, 0.1), (-3.5, 0.8), stroke: 2pt + black, fill: white)
          content((-4.5, 0.45), text(size: 11pt)[$W_41$])

          rect((-2.5, 0.1), (-0.5, 0.8), stroke: 2pt + black, fill: white)
          content((-1.5, 0.45), text(size: 11pt)[$W_33$])

          rect((0.5, 0.1), (2.5, 0.8), stroke: 2pt + black, fill: white)
          content((1.5, 0.45), text(size: 11pt)[$W_12$])

          rect((3.5, 0.1), (5.5, 0.8), stroke: 2pt + black, fill: white)
          content((4.5, 0.45), text(size: 11pt)[$W_64$])

          // Etichetta profondità sulla destra
          line((6.2, 4.5), (6.2, 0.45), stroke: 2pt + black)
          line((6.1, 4.4), (6.2, 4.5), stroke: 2pt + black)
          line((6.3, 4.4), (6.2, 4.5), stroke: 2pt + black)
          content((6.7, 2.5), text(size: 12pt)[$q$])

          // Nota in basso
          content((0, -0.7), text(size: 10pt)[
            Ogni foglia $W_i$ rappresenta una posizione specifica dell'oracolo
          ])
          content((0, -1.2), text(size: 10pt)[
            interrogata al termine del cammino di $q$ query
          ])
        }),
        caption: [
          Albero delle interrogazioni con $q=3$ query. Dato $(x,R)$ fissi, il verificatore interroga parallelamente $2^q$ posizioni.
        ]
      )
      ]


    ]
  ]<verificatore-forma-normale>

== Inapprossimabilità di *$"Max"E_3"SAT"$* mediante PCP

#teorema("Lemma")[
  Data una funzione booleana $phi$:
  $ 
    phi : 2^({x_1,dots,x_k}) -> 2 = {0,1}
  $
  Allora $phi$ si può scrivere come una *CNF* con al più $2^k$ clausole, ognuna con esattamente $k$ letterali 

  #esempio()[
    Andiamo a creare tutte le possibili combinazioni di assegnamenti: 
    #figure(
      table(
        columns: 5,
        align: center,
        table.header(
          [$x_1$], [$x_2$], [$x_3$], [Clausola], [Valore],
        ),
        [$0$], [$0$], [$0$], [$(x_1 or x_2 or x_3)$], [$0$],
        [$0$], [$0$], [$1$], [$(x_1 or x_2 or overline(x_3))$], [$1$],
        [$0$], [$1$], [$0$], [$(x_1 or overline(x_2) or x_3)$], [$1$],
        [$0$], [$1$], [$1$], [$(x_1 or overline(x_2) or overline(x_3))$], [$1$],
        [$1$], [$0$], [$0$], [$(overline(x_1) or x_2 or x_3)$], [$1$],
        [$1$], [$0$], [$1$], [$(overline(x_1) or x_2 or overline(x_3))$], [$1$],
        [$1$], [$1$], [$0$], [$(overline(x_1) or overline(x_2) or x_3)$], [$1$],
        [$1$], [$1$], [$1$], [$(overline(x_1) or overline(x_2) or overline(x_3))$], [$1$],
      ),
      caption: [
        Tabella di verità per una formula CNF con $k=3$ variabili. Ogni riga mostra un assegnamento e la clausola corrispondente. La formula CNF completa è la congiunzione di tutte le clausole: $(x_1 or x_2 or x_3) and ... and (overline(x_1) or overline(x_2) or overline(x_3))$.
      ]
    )
  ]
]<lemma-formula-booleana>

#teorema("Teorema")[
  Esiste un $overline(epsilon) > 0 "t.c"$ $"MaxCNFSat"$ non è $1-overline(epsilon)$-approssimabile, a meno che $"P"="NP"$.

  #informalmente()[
    Stiamo dicendo che esiste una costante positiva $overline(epsilon)$ al di sotto della quale è impossibile approssimare  $"MaxCNFSat"$
  ]
  #dimostrazione()[
    Sia $L$ un linguaggio, dove $L in "Npc"$ (quindi $L$ è uno dei problemi più difficili in $"NP"$). Di conseguenza: 
    $ L in "NP" = "PCP"[r(n),1] $ 
    per qualche $r(n) in O(log(n))$ e $q in bb(N)$.\
    Sia $V$ un verificatore in forma normale per $L$. $V$ per il lemma #link-teorema(<verificatore-forma-normale>), può essere descritto come segue: 
    1. Fissato l'input $x in 2^*$
    2. Fissati i bit estratti $R in 2^(r(|x|))$

    Per una specifica estrazione $R$, $V$ intteroga l'oracolo $w$ in *$q$* posizioni indipendenti ${i_1 (x,R),dots,i_q (x,R)}$ e accetta o rifiuta (in base alla risposta dell'oracolo): 
    $
      phi(w_(i_1(x,R)),dots,w_(i_q (x,R)) ) in 2
    $
    Siccome la stringa oracolica $w$ è una funzione booleana, per il lemma #link-teorema(<lemma-formula-booleana>), $phi$ è descrivibile come una formula $phi_(x,R)$ CNF nelle variabili $w_(i_1(x,R)),dots,w_(i_q (x,R))$ con un numero di clausole $<=2^q$ di $q$ letterali:
    #esempio()[
      $ 
        "Per" q = 3\
        phi_(x,R) = (w_3 or w_7 or not w_8) and (w_3 or not w_7 or w_8)
      $
    ]
    Chiamiamo con $Phi_x$ la congiunzione di più formule $phi_(x,R)$ per tutte le *posssibil sequenze* di *bit random $R$*:
    $
      Phi_x = underbrace(and.big_(R in 2^(r(|x|))) phi_(x,R),"And di CNF")
    $
    #nota()[
      $R$ è una stringa appartenente all'insieme di tutte le possibili stringhe binarie di lunghezza $r(n)$: 
      $
        R in {0,1}^(r(n))
      $
    ]


    Dove: 
      1. $Phi_x$ è fatta da clausole con $q$ letterali ciascuna
      2. $Phi_x$ contiene un numero di clauosole pari a : 
      $
        underbrace(mb(2^q),"clausole di "phi_(x,R)) dot underbrace(mr(2^r(|x|)), "clausole di "Phi_x) &= 2^(q+r(|x|))\
                             &= 2^(q+O(log |x|))\
                             &= "Poly"(|x|)
      $
      Esiste quindi un polinomio *$P(|x|)$* per cui $Phi$ contiene esattamente $|P(x)|$ clausole.

      #informalmente()[
        Ogni $phi_(x,R)$ rappresenta una "traccia di esecuzione" del verificatore con una specifica estrazione random $R$. La forma $Phi_x$ è soddisfacibile se e solo se esiste una stringa dell'oracolo $w$ che fa accettare il verificatore per ogni possibile estrazione random. 
      ]
      Possiamo ora collegarci al linguaggio $L$:
      - Se $mb(x in L)$ = $V$ deve essere tale per cui esiste una stringa oracolica $w$ che fa accettare con probabilità $1$. *Tutte* le $phi_(x,R)$ devono essere soddisfatte $=>$ *$Phi_x$ è soddisfacibile*. Esiste quindi un assegnamento che *soddisfa* tutte le *$P(|x|)$ clauosle* di $Phi_x$. Chiamo con *$t_x^*$* tale quantità: 
      $
        mb(t_x^* = P(|x|))
      $ 

      - se $mr(x in.not L)$ =  $V$ deve essere tale per cui ogni stringa $w$ fa accettare $x$ con probabilità $< 1/2$. Ogni $w$ *non* soddisfa almeno metà delle $phi_(x,R)$ clauosole di $Phi_x$:
      $
        "Ogni" w "non soddisfa" >= 2^r(|x|)/2 "delle" underbrace(phi_(x,R),2^q "clausole") "clausole"
      $
        Voglio ora stimare il numero di clausole totali non soddisfatte: 
      $
        forall w "soddisfa" &< underbrace(P(|x|),2^q dot 2^r(|x|) "clausole")- 2^r(|x|)/2 "clausole"\
                            & mb(2^(r(|x|)) = P(|x|)/2^q) \
                            &= P(|x|) - (mb(P(|x|)/2^q) / 2)\
                            &= P(|x|) - P(|x|)/(2^q dot 2)\
                            &= P(|x|) - P(|x|)/2^(q+1)
                  
      $
        Riscrivendo la disequazione per $,mb(t_x^*)$:
      $
        mb(t_x^*) <= P(|x|)-P(|x|)/2^(q+1)\
        mb("Raccogliamo" P(|x|))\
        t_x^* <= P(|x|)(1-1/2^(q+1))\
        mb("Scegliendo il tasso di approx." overline(epsilon) = 1/2^(q+1))\
        mr(t_x^* <= P(|x|)(1-overline(epsilon)))
      $
    Riassumendo: 
    - $"Se" x in L$ = $mb(t_x^* = P(|x|))$
    - $"Se" x in.not L$ = $mr(t_x^* <= P(|x|)(1-1/(2^q+1)))$

    Supponiamo per *assurdo* che ci sia un algoritmo di ottimizzazione $A$ che fornisce una $(1+overline(epsilon))$-approssimazione per $"MaxCNFSat"$. Chiamiamo con $overline(t)$ la soluzione prodotta da $A$ che approssima $t^*$. L'algoritmo $A$ fornisce una approssimazione pari a: 
    $
      ((t^*))/(overline(t)) &<= 1 + overline(epsilon) \
      overline(t) &>= t^* / (1+overline(epsilon))
    $
    Di conseguenza: 
    - $"Se" mr(x in L)$, la formula è completamente soddisfacibile $t^*=P(|x|)$: 
      $ overline(t)>= t^* /(1+overline(epsilon)) = P(|x|)/(1+overline(epsilon)) = mr(A_x) $ 

    - $"Se" mb(x in.not L)$, non è possibile soddisfare tutte le clausole, ne fallisce una frazione fissa $overline(epsilon)$:
     $ overline(t) &<= t^*\ 
                   &<= P(|x|)(1-overline(epsilon)) = mb(B_x) $

    Vogliamo dimostrare che $mb(B_x)$ e $mr(A_x)$ *sono separati*, ci riusciamo per $mb(B_x) < mr(A_x)$ , in questo modo guardando la soluzione $overline(t)$ riusciamo a capire in che caso simao, risolvendo così il problema. Se valesse:
    $
      mb(B_x) >= mr(A_x)\
      P(|x|)(1-overline(epsilon)) >= P(|x|)/(1+overline(epsilon))\
      mb("Dividiamo per" P(|x|))\
      (1-overline(epsilon)) >= 1/(1+overline(epsilon))\
       mb("Moltiplichiamo per" (1+overline(epsilon)))\
      (1+overline(epsilon))(1-overline(epsilon)) >= 1\
      1-overline(epsilon)^2 >= 1\
      -overline(epsilon)^2 >= 0\
      underbrace(overline(epsilon)^2,"siccome" overline(epsilon)^2 >=0 \ "sempre") <= 0 => overline(epsilon) = 0 "impossibile" space qed 
    $
    impossibile in quanto avevamo definito $overline(epsilon) = 1/2^(q+1)$, di conseguenza $mb(B_x) < mr(A_x)$.\
    Questo signifca che $A_x$ e $B_x$ sono distinguibili, potrei decidere *l'appartenenza* o meno di $x$ al linguaggio $L$ in *tempo polinomiale*. Siccome *$L in "NPc"$* questo è un assurdo $qed$



  ]
]

#teorema("Crollario")[
  Eiste un $overline(epsilon) > 0$ t.c $"Max"E_3"Sat"$ non è $(1+overline(epsilon))$-approssimabile in tempo polinomiale, a meno che $"P" = "NP"$.

  #nota()[
    Nella pratica sappiamo che esiste una $8/7+overline(epsilon)$-approssimazione.
  ]
]


== Inapprossimabilità di MaxIndependentSet

#informalmente()[
  Dato un grafo non orientato, vogliamo trovare il più grande insieme di vertici $X$ tale che nessuno di questi vertici $v in X$ sia collegato tra loro da un lato.
]

#esempio([
  #figure(
    cetz.canvas({
      import cetz.draw: *

      // ===== LIVELLO SUPERIORE =====
      
      // GRAFO ORIGINALE
      content((-6, 3.8), text(size: 12pt, weight: "bold")[Grafo $G$])

      // Vertici
      circle((-7, 2.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-7.4, 2.5), text(size: 10pt)[$v_1$])

      circle((-5, 3), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-5, 3.4), text(size: 10pt)[$v_2$])

      circle((-6, 1.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-6.4, 1.5), text(size: 10pt)[$v_3$])

      circle((-4, 2), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-3.6, 2), text(size: 10pt)[$v_4$])

      circle((-5, 0.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-5, 0.1), text(size: 10pt)[$v_5$])

      // Lati
      line((-6.85, 2.5), (-5.15, 3), stroke: 2pt + black)      // v1-v2
      line((-6.9, 2.4), (-6.1, 1.6), stroke: 2pt + black)      // v1-v3
      line((-5.85, 1.5), (-4.15, 2), stroke: 2pt + black)      // v3-v4
      line((-5.1, 2.9), (-4.1, 2.1), stroke: 2pt + black)      // v2-v4
      line((-5.9, 1.4), (-5.1, 0.6), stroke: 2pt + black)      // v3-v5
      line((-4.1, 1.9), (-5, 0.6), stroke: 2pt + black)        // v4-v5

      // SOLUZIONE NON INDIPENDENTE
      content((-1, 3.8), text(size: 12pt, weight: "bold")[Non Indipendente])
      content((1.5, 3.4), text(size: 10pt, fill: red)[${v_1, v_2, v_3}$ ✗])

      // Vertici
      circle((-2, 2.5), radius: 0.15, fill: red.lighten(70%), stroke: 2pt + red)
      content((-2.4, 2.5), text(size: 10pt)[$v_1$])

      circle((0, 3), radius: 0.15, fill: red.lighten(70%), stroke: 2pt + red)
      content((0, 3.4), text(size: 10pt)[$v_2$])

      circle((-1, 1.5), radius: 0.15, fill: red.lighten(70%), stroke: 2pt + black)
      content((-1.4, 1.5), text(size: 10pt)[$v_3$])

      circle((1, 2), radius: 0.15, fill: white, stroke: 2pt + black)
      content((1.4, 2), text(size: 10pt)[$v_4$])

      circle((0, 0.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((0, 0.1), text(size: 10pt)[$v_5$])

      // Lati
      line((-1.85, 2.5), (-0.15, 3), stroke: 3pt + red)        // v1-v2 PROBLEMA!
      line((-1.9, 2.4), (-1.1, 1.6), stroke: 2pt + black)      // v1-v3
      line((-0.85, 1.5), (0.85, 2), stroke: 2pt + black)       // v3-v4
      line((-0.1, 2.9), (0.9, 2.1), stroke: 2pt + black)       // v2-v4
      line((-0.9, 1.4), (-0.1, 0.6), stroke: 2pt + black)      // v3-v5
      line((0.9, 1.9), (0, 0.6), stroke: 2pt + black)          // v4-v5

      content((-1.5, 0.8), text(size: 9pt, fill: red)[
        $v_1$ e $v_2$ \ collegati!
      ])

      // ===== LIVELLO INFERIORE =====
      
      // INSIEME INDIPENDENTE
      content((-6, -0.5), text(size: 12pt, weight: "bold")[Insieme Indipendente])
      content((-6, -1.2), text(size: 10pt, fill: green)[${v_1, v_4}$ ✓])

      // Vertici
      circle((-7, -2), radius: 0.15, fill: green.lighten(70%), stroke: 2pt + green)
      content((-7.4, -2), text(size: 10pt)[$v_1$])

      circle((-5, -1.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-5, -1.1), text(size: 10pt)[$v_2$])

      circle((-6, -3.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-6.4, -3.5), text(size: 10pt)[$v_3$])

      circle((-4, -3), radius: 0.15, fill: green.lighten(70%), stroke: 2pt + green)
      content((-3.6, -3), text(size: 10pt)[$v_4$])

      circle((-5, -4.5), radius: 0.15, fill: white, stroke: 2pt + black)
      content((-5, -4.9), text(size: 10pt)[$v_5$])

      // Lati
      line((-6.85, -2), (-5.15, -1.5), stroke: 2pt + black)    // v1-v2
      line((-6.9, -2.1), (-6.1, -3.4), stroke: 2pt + black)    // v1-v3
      line((-5.85, -3.5), (-4.15, -3), stroke: 2pt + black)    // v3-v4
      line((-5.1, -1.6), (-4.1, -2.9), stroke: 2pt + black)    // v2-v4
      line((-5.9, -3.6), (-5.1, -4.4), stroke: 2pt + black)    // v3-v5
      line((-4.1, -3.1), (-5, -4.4), stroke: 2pt + black)      // v4-v5

      content((-5.5, -5.3), text(size: 9pt, fill: green)[
        Nessun lato tra $v_1$ e $v_4$!
      ])

      
    
    }),
    caption: [
      Esempio di MaxIndependentSet. Un insieme è indipendente se nessun vertice è collegato ad un altro. L'obiettivo è trovare l'insieme indipendente di cardinalità massima.
    ]
  )
])

Formalmente:
- *$I_pi$* = $G(V,E)$ non orientato
- *$"Amm"_pi$* = il contrario di una clique, un insieme di vertici $X$, dove nessun lato del grafo che ha le due estremità in esso. 
  $ X subset.eq V "indipendenti", quad E inter binom(X, 2) = emptyset $
- *$C_pi$* = $|X|$
- *$t_pi$* = $max$

#teorema("Teorema")[
  Per ogni $epsilon > 0$: 
  $
  "MaxIndependentSet non è" (2-epsilon)-"approssimabile"
  $ 
  in tempo polinomiale, se $"P" != "NP"$
  #dimostrazione[
    Sia $L subset.eq 2^*$ un linguaggio NP-completo, allora :
    $ 
      L in "PCP"[r(n), q]
    $ 
    per una specifica funzione $r(n) in O(log n)$ e $q in bb(N)$.\
    Sia $V$ un verificatore in forma normale per $L$. Invece che costruire una formula, costruiamo un grafo *$G_x$* *per ogni* input possibile *$x in 2^*$*:
    - *Vertici*= $x$-configurazioni (ammissibili), ovvero una coppia:
      $ (R, {i_1 : b_1, ... i_q : b_q}) $
      Dove:
      - $R in 2^r(|x|)$ = è la stringa estratta da $V$
      - ${i_1, ..., i_q} in bb(N)$ = sono le posizioni interrogate con input $x$ e stringa random $R$ fissati
      - ${b_1, ..., b_q} in 2 = {0,1}$ = sono le risposte dell'oracolo (ovvero i valori della stringa in quelle posizioni)

      Il numero di vertici è pari a:
      $ mb(|V| <= 2^r(|x|) dot 2^q) $
    - *Lati*= Dati due vertici $(R, {i_1=b_1,dots,i_q=b_q}) in V$ e $(R', {i_1=b_1,dots,i_q=b_q})in V$, esiste un *arco* se e solo se le *configurazioni* sono *incompatibili*, cioè
      - $R eq.not R'$ //Todo verificare se != o =
      - oppure $exists k, k'$ tale che $i_k = i'_k'$ e $b_k != b'_k'$. Insieme di interrogazione uguale ma risposte dell'oracolo diverse.

    #attenzione()[
      Anche se i vertici sono $|V| <= 2^r(|x|) dot 2^q$, nell'insieme indipendente il numero massimo di *vertici selezionabili* è uno per ogni "gruppo" $R$ (al massimo *$2^(r(|x|))$*). Non possiamo prendere due vertici che usano la stessa stringa random $R$ (incompatibili). 
    ]

      #esempio()[
        configurazioni incompatibili:
        $
          (001,{3:0,mr(4:1),7:3})\
          (010,{13:0,mr(4:0),17:1})
        $
      ]

      #informalmente()[
        configurazioni indipendenti significa che non ci può essere una stringa dell'oracolo compatibile con entrambe le stringhe, *non possono coesistere* nello stesso universo.
      ]

    #teorema("Fatto")[
      Se *$x in L, G_x$* ha un insieme indipendente di cardinalità *$>= 2^r(|x|)$*

      #dimostrazione[
        $exists w$ che fa accettare con probabilità $1$.
        Prendiamo *tutte* le *configurazioni* accettanti *compatibili* con *$w$*.
        Queste configurazioni non hanno lati che le collegano (dato che sono compatibili).

        L'insieme di tali configurazioni è un insieme indipendente, dato che devo accettare con probabilità $1$, la sua cardinalità deve essere $2^r(|x|) space qed$

        #nota()[
          L'insieme di vertici ha dimensione $>= 2^r(|x|)$, in quanto per un qualunque $R$ devo accettare.
        ]
      ]
    ]<indipendent-sat-fatto-1>

    #teorema("Fatto")[
      Se *$x in.not L$*, ogni insieme indipendente di $G_x$ ha cardinalità $<= 2^(r(|x|)-1)$

      #dimostrazione[
        Per *assurdo*, sia $S subset.eq V_G_x$ un inieme indipendente dove: 
        $ 
        |S| > 2^(r(|x|)-1)
        $
        $S$ è un insieme di configurazioni al cui interno non ci possono essere configurazioni incompatibili tra loro. Si può costruire un $w$ compatibile con tutti i vertici di $S$. Di conseguenza, $w$ viene accettato in tutte le configurazioni, stiamo accettando con probabilità $> 1/2$, ma per definizione è *impossibile* $qed$.
      ]
    ]<indipendent-sat-fatto-2>

    #informalmente[
      Se $x in L$, allora c'è un insieme indipendente di taglia grande, altrimenti avrà uan dimensione ridotta (queste due casistiche sono disgiunte).
    ]
    Sia *$t_x^*$* la cardinalità del MaxIndependentSet per $G_x$:
    - se $mb(x in L) underbrace(=>,#link-teorema(<indipendent-sat-fatto-1>)) t^*_x >= 2^(r(|x|))$

    - se $mr(x in.not L) underbrace(=>,#link-teorema(<indipendent-sat-fatto-2>)) t_x^* < 2^(r(|x|)-1) = 2^(r(|x|))/2$

    Adesso supposiamo per *assurdo* che esista un algoritmo $A$ in grado di restituire una soluzione $overline(t)$ approssimata, con:
    $ 
      overline(t) >= t^* / (2-epsilon)
    $
    Guardiamo ora i due casi dinsgiunti:
    - Se $mb(x in L)$: 
      $
        overline(t) >= t^* / (2-epsilon) underbrace(>=,#link-teorema(<indipendent-sat-fatto-1>)) 2^(r(|x|)) / (2-epsilon) > 2^(r(|x|)) / 2
      $

    - Se $mr(x in L)$:
      $
        overline(t) <= t^* < 2^(r(|x|))/2
      $
      Tuttavia riusciremo a risolvere in tempo polinomaile il problema MaxIndependentSet guardando la soluzione $overline(t)$, questo è un *assurdo* in quanto *$L in "Npc"$*
  ]
]
