#import "../imports.typ": *

= Classi di Complessità

Studiando la complessità strutturale dei problemi, possiamo andare a suddividerli in diverse famigle, esse prendono il nome di classi di complessità.

#informalmente[
  Dati due algorimti che ci mettono $O(n^(1.81))$ e $O(n^(1.61))$ per risolvere un problema $Pi$, ai fini del corso essi sono equiparabili. Ci basterà sapere se il tempo di un algoritmo è: 
  - *Polinomiale*: va bene 
  - *Super-polinomiale* (più di un polinomio): non va bene 
]

== Problemi di Decisione

Andremo a classificare i problemi di decisione in tre classi: *P*, *NP* e *NP completi*.

=== Classe P

Insieme dei problemi $Pi$ di decisione che *ammettono un algoritmo polinomiale* che li risolve. 
Per determinare l'appartenenza di un problema a questa classe (*$Pi in P$*), dobbiamo dimostrare almeno una tra le seguenti condizioni: 
  - *L'upper bound di $Pi$ deve essere riconducibile ad un polinomio* (allora esiste un algorimto $A$ che risolve $Pi$ in tempo polinomiale), non è necessario chiudere il gap.
  - Dimostrare che il *lower bound* di $Pi$ *sia superpolinomiale*, in questo caso *$Pi in.not P$*


  #esempio[
    Problema *SAT*: data una formula booleana con variabili, and, not, or, decidere se esiste almeno un assegnamento di variabili in cui la formula risulta vera.
  
    $(x_1 or not x_2) and (x_4 or x_5 or x_6)$
    
    Al momento è *ignoto lo status di SAT*, non si sa se $"SAT" in P$ o $"SAT" in.not P$. Non si conoscono algoritmi ne lower buond super-polinomiali
  ]

=== Classe NP

Insieme dei problemi $Pi$ di decisione che *ammettono un algoritmo polinomiale non deterministico*.
  
#informalmente[  
  Il non determinismo può essere visto come l'aggiuntà di un istruzione magica di assegnamento $X = ?$ ad un programma. Durante l'esecuzione del programma esso si biforca:
  - primo ramo: assegna $X = 0$
  - secondo ramo: assegna $X = 1$
  
  Dato che è un problema di decisione, ogni ramo quando termina, stampa $mb("Si")$ o $mr("No")$. A questo punto tutti i rami vengono messi in *OR*. Se c'è almeno un $mb("Si")$, allora la soluzione del problema di decisione è $mb("SI")$.

  #idea[ //TODO aggiungere disegno
    - Python standard: $X in 2* -> A ->$ Si / No
    - Python "magico" (non deterministico): $x in 2* -> A ->$ Albero di risultati messi in OR
  ]
  
  Il progrmma *non deterministico è simulabile* attraverso diverse tecniche (eseguendo un ramo alla volta, èarallelismo, fork), il problema è che ci mette un *tempo arbitrariamente alto*. I rami d'esecuzione crescono in maniera esponenzialmente, anche fissando l'altezza dell'albero a polinomiale. Disponendo di infinite CPU si potrebbe risolvere in tempo polinomiale, senza ci vuole un tempo esponenziale.
]

#esempio[
  Per la risoluzione di *SAT* può essere utilizzato un algoritmo non deterministico: basta adoperare l'istruzione magica per ogni variabile. In totale ci sono $2^"numero variabili"$ rami, dove ogni ramo ha un altezza polinomiale. 

  Possiamo quindi affermare che *$"SAT" in "NP"$*
]

=== Problema P = NP

Possiamo osservare che *$P subset "NP"$*: basta non utilizzare l'istruzione magica negli algoritmi.

#attenzione[
  Tuttavia non è nota con certezza la natura dell'inclusione, ovvero se $P subset.eq "NP"$ o $P subset "NP"$.

  Ad oggi *l'ipotesi universalmente accettata* è che *$P != "NP"$* (assunzione che verrà fatta durante tutto il corso). 
]

=== Riduzione in tempo polinomiale

Siano $Pi_1, Pi_2 subset.eq 2^*$ due problemi di decisione, allora una *Riduzione polinomiale di $Pi_1$ a $Pi_2$* è una funzione $f$ tale che: 
  -  $f: 2^* -> 2^*, quad x in Pi_1 <-> f(x) in Pi_2$
  - $f$ calcolabile in tempo polinomiale
e si indica con *$Pi_1 <=_p Pi_2$* (Se trovo un algoritmo per $Pi_2$, lo trovo anche per $Pi_1$).

#informalmente[
  L'idea è dare un *ordine di difficoltà*, ovvero che *$Pi_1$ non è più difficile di $Pi_2$*. 
  
  Se sono in grado di trovare un algoritmo $A in P$ per $Pi_2$, allora posso usarlo anche per risolvere $Pi_1$, dato che anche la riduzione (la trasformazione di $P_2$ in $P_1$) è polinomiale.
]

#teorema("Proprietà")[ 
  Se $Pi_1 <=_p Pi_2, quad Pi_2 in P, quad => Pi_1 in P$
]
=== Classe NP-completi (NPc)

Un problema $Pi$ di decisione appartiene a NPc se: 
1. *$Pi in "NP"$*
2. *$forall Pi' in "NP", quad Pi' <=_p Pi$*

#informalmente[
  Un problema $Pi in "NPc"$ se: 
  1. $Pi$ $in$ NP
  2. Qualsiasi altro problema $Pi^' in$ NP è riducibile in tempo polinomiale a $Pi$
]

#teorema("Teorema di Cook")[
  *SAT è NP-completo* (la cosa interessante non è che sia SAT, ma che esista!)
]

#teorema("Crollario Teorema di Cook")[
  $"SAT" in P <==> P = "NP"$ (vale per ogni problema NPc).

]
#dimostrazione[
  Se avessimo un algoritmo polinomiale per SAT ($"SAT" in P $), allora dato che ogni altro problema $Pi^' in "NP"$ è riconducibile a SAT avremo anche un algorimto polinomiale per $Pi^'$. Di conseguenza $P="NP"$.
]

#nota[
- Se si trova una soluzione polinomiale per SAT, allora dimostriamo che *$P="NP"$*
- Se si trova un lower buond super-polinomiale per SAT, allora dimostriamo che *$P!="NP"$*
]

== Problemi di Ottimizzazione

Si tratta di una famiglia speciale di problemi (come quelli di ottimizzazione).

/ Un problema $Pi$ si dice di ottimizzazione se:
  - Insieme di *input* $I_Pi subset.eq 2^*$
  - *Funzione ammissibilità* *$"Amm"_Pi: I_Pi -> 2^2^* \\ {emptyset}$*. Associa ad ogni input un insieme non vuoto di possibili soluzioni: $"Amm"_(Pi)(x)$ (supponiamo ce ne sia almeno una). Capire se esiste una soluzione è un passo precedente (dato perscontato)
  - *Funzione obiettivo*: *$C_Pi : 2^* times 2^* -> bb(R)$*, essa assegna un valore $C_(Pi)(x, y), forall x in I_Pi, forall y in "Amm"_(Pi)(x)$. Assegna un valore ad ogni coppia di input e output ammissibile.
  - *Tipo del problema* *$t_Pi in { min, max }$*
  
  L'obiettivo è ottenere un algoritmo $A$ che dato un input $x in I_Pi$, fornisce una soluzione $y^* in "Amm"_(Pi)(x)$, tale che:
  *$ C_(Pi)(x, y^*) >=_max (<=_min) C_(Pi)(x, y'), quad forall y' in "Amm"_(Pi)(x) $*

  Vogliamo quindi la soluzione con costo massimo (o minimo) rispetto a tutte le altre soluzioni per un certo input $x$.

#nota[
  Si utilizza *$y^*$* per indicare una soluzione ammissibile, in quanto, dato un certo input $x$ ci possono essere più soluzione ammissibili. La funzione $C_(Pi)(x,y^*)$ restituisce lo stesso risultato.
]

#esempio[
  *MaxSAT* (Versione di ottimizazzione di SAT)

  - $I_Pi$: formule booleane in CNF
  - $"Amm"_(Pi)(x)$: assegnamenti di valori di verità per le variabili che compaiono in x
  - $C_(Pi)(x, y)$: numero di clausole della formula $x in I_Pi$ rese vere da $y$
  - $t_Pi = max$. Il massimo numero di formule rese vere da $y$. 

  Se esistesse un algoritmo $A$ polinomiale per MaxSAT, allora si potrebbe usare per decidere SAT. Ma dato che $"SAT" in "NPc" -> "MaxSat" in "NPOc"$

  #informalmente[
    Per decidere se un problema di ottimizzazione è risolvibile in tempo polinomiale, potrebbe essere utile ricondursi a proprietà applicabili/non applicabili studiate sui problemi di decisione.
  ]

  #nota[
    Ogni formula booleana in forma normale conguinta (CNF) è composta da: 
    - letterali: variabili o variabili negate,
    - clausole: letterali in or,
    - condizione logica: clausole legate in and tra di loro.
  ]
]
=== Classi di complessità

La classificazione effettuata sui problemi di decisione può essere applicata anche ai problemi di ottimizzazione, suddividendo i problemi in base alla loro complessità strutturale. 

=== Classe PO

Un problema di ottimizzazione *$Pi in "PO"$* sse esiste un algoritmo $A$ che lo risolve in tempo polinomiale.

#attenzione[
  Dato un input ammissibile, l'algorimto $A$ deve trovare la soluzione *ottima* (o una delle soluzioni ottime in caso ne esistano più di una).
]

#nota[
  La classe $"PO"$ è molto rara, sopratutto in presenza di numerosi vincoli.
]

#informalmente[
  È l'equivalente della classe P per i problemi di ottimizzazione
]

=== Classe NPO

#informalmente[
  Equivalente alla classe NP. Tuttavia, in questo caso non può essere semplicemente introdotta l'istruzione magica per modellare il non determinismo. Ogni ramo di esecuzione non da una soluzione binaria, ma una soluzione ammissibile e "comporle" per trovare la migliore in termini di funzione obiettivo risulta non banale. 

  Il *non determinismo* non può essere descritto semplicemente da una macchina di Turing, ma viene introdotto un *oracolo*.
]

Un problema *$Pi in "NPo"$* se:
+ *$I_Pi in P$*: *decidere se un input $x$ è un valido impiega un tempo polinomiale*
+ Esiste un *polinomio Q* t.c: 
 1. *$forall x in I_Pi, quad forall y in "Amm"_(Pi)(x), quad |y| <= Q(|x|)$*
 2. *$ forall x in I_Pi, forall y in 2^*$, se $|y| <= Q(|x|)$, decidibile in tempo polinomiale se $y in "amm"_(Pi)(x)$*
+ la funzione *$C_Pi$* è *calcolabile in tempo polinomiale*


#informalmente[
  La definizione chiede che:
  1. decidere se un input $x$ è valido costa un tempo polinomiale
  2. gli output $y$ (le soluzioni) hanno una dimensione limitata, polinomiale rispetto alla dimensione dell'input
  3. data una soluzione $y$ per un certo input $x$ è verificabile in tempo polinomiale se essa è ammessa $y in "Amm"_(Pi)(x)$  
  4. la funzione di costo è calcolabile in tempo polinomiale

    #let algo_tree = diagram(
    spacing: (10pt, 4em), {
      // --- NODI ---
      let (x, box, error) = ((0,0), (0,1), (1,1))
      let (b1, b2, b3, b4) = ((-2,2), (2,2), (1,2), (-1,2))
      let (maxmin) = ((0,3))
  
      // Input in alto
      node(x, $x in I_Pi$)
  
      // Algoritmo (rettangolo)
      node(box,$"Algo"$, stroke: 1pt, shape: rect, width: 5em, height: 2.5em)
  
      // STOP & ERROR a destra
      node(error, $x in.not I_Pi$ + linebreak() + "STOP & ERROR")
  
      // Due rami verso il basso
      node(b1, $y in.not "Amm"_(Pi)(x)$ + linebreak() + "NO ,STOP")
      node(b3, $y in.not "Amm"_(Pi)(x)$ + linebreak() + "NO, STOP")
      node(b4, $y in "Amm"_(Pi)(x)$ + linebreak() + $"SI, "C_(Pi)(x,y)$)
      node(b2, $y in "Amm"_(Pi)(x)$ + linebreak() + $"SI," C_(Pi)(x,y)$)
  
      node(maxmin, "MAX / MIN")
  
      // --- ARCHI ---
      edge(x, box, "->")
      edge(box, error, "->")
      edge(box, b1, "->")
      edge(box, b2, "->")
      edge(box, b4, "->")
      edge(box, b3, "->")
      edge(b4, maxmin, "->")
      edge(b2, maxmin, "->")
    }
  )
  
  #algo_tree
  Funzionamento: 
  - 1 bit per volta viene generata qualunque sequenza di input $y in 2^*,|y|<= Q(|x|)$
  - Se $y$ è ammissibile, viene valutata la funzione obiettivo $C_(Pi)(x)$
  - Viene presa la funzione di costo min/max in base al tipo di problema
  
  Possibile in tempo polinomiale grazie ai vincoli imposti.
]

=== Problema di decisione associato ad un problema di ottimizzazione

Da un problema *$Pi$ di ottimizzazione vogliamo passare al problema $hat(Pi)$ di decisione associato*: 
- $Pi$ problema di ottimizzazione
- $hat(Pi)$ corrispettivo problema di decisione, così costruito:
 - *$I_hat(Pi) = I_Pi times bb(N)$*, coppie 
 - *$(x, k) in I_hat(Pi) -> "yes" "sse" C_(Pi)^*(x) >= (<=) k $*

#informalmente[
  Dato un input del problema $Pi$ e un numero $k$, il problema di decisione $hat(Pi)$ risponde "yes" sse la soluzione ottima $C_(Pi)(x)$ del problema di ottimizzazione è $>=$ o $<=$ di una certa *soglia $k$* (in base alla tipologia del problema $Pi$).
]

#esempio[
  Fissato $Pi ="MaxSat"$, definiamo il problema $hat(Pi)$ di ottimizzazione associato: 
  - $I_hat(Pi) = ("Formula CNF",k)$, con $k in bb(N)$
  Il problema di decisione $hat(Pi)$ risponde alla seguente domanda: esiste un assegnamento che rende vere $>= k$ clausole della formula?
]

#teorema("Teorema")[
  Dato un problema di ottimizzazione $Pi$ e il corispettivo problema di ottimizzazione $hat(Pi)$ associato: 
  - Se *$Pi in "PO", hat(Pi) in P$*
  - Se *$Pi in "NPO", hat(Pi) in "NP"$*
]


=== Classe NPOc

Dato un problema di ottimizzazione $Pi$ esso appartiene alla classe *$"NPOc"$* se: 
- *$Pi in "NPO"$*
- *$hat(Pi) in "NPc"$*, il problema di decisione associato è NP-completo

#esempio[
  $"MaxSat" in "NPOc"$, in quanto $hat("MaxSat") in "NPc"$. Se riuscissi a risolvere $"MaxSat"$ in tempo polinomiale, allora riuscirei anche a risolvere $hat("MaxSat")$. Basterebbe risolvere $"MaxSat"$ e ottenere il numero massimo di clausole soddisfacibili, diciamo $k_("opt")$, e poi confrontare tale numero con il $k$ dato in input al problema decisionale $hat("MaxSat")$. 
  
  Questo dimostrerebbe che se un problema $Pi$ in $"NPO"$ è risolvibile in tempo polinomiale, allora il suo problema decisionale $hat(Pi)$ associato è in $P$.
]

#teorema("Teorema")[
  Sia $Pi$ un problema di ottimizzazione.
  \ *Se $Pi in "NPOc"$, allora $Pi in.not "PO"$ a meno che $P = "NP"$*
]

#dimostrazione[
  *Assunzioni*: 
  - $Pi$ sia un problema di ottimizzazione di massimo $t_(Pi)=max$. 
  - $Pi in "NPOc"$
  - $hat(Pi) in "NPc"$

  *Per assurdo* suppongo che esista un algorimto *$A$ che risolva $Pi$ in tempo polinomiale*: 
  
  #let algo_diagram = diagram(
    spacing: (10pt, 4em),
    {
      let (x, a, y) = ((0,0), (3,0), (6,0))
  
      node(x, $x in I_Pi$)
      node(a, $A$, stroke: 1pt, shape: rect, width: 4em, height: 3em)
      node(y, $y^* "t.c" max{C_(Pi)(x,y^*)}$)
  
      edge(x, a, "->")
      edge(a, y, "->")
    }
  )
  #align(center, algo_diagram)
  Ovvero, $A$ calcola la soluzione ottima per un certo input $x$ in tempo polinomiale. \
  Consideriamo ora il *problema di decisione associato $hat(Pi)$*, definito come: 
  - $I_hat(Pi)=(x,k) in I_Pi times bb(N) $
  - Uso $A$ per calcolare la soluzione ottima $y^*$ e calcolo $C_(Pi)(x,y^*)$
  - Se $C_(Pi)(x,y^*) cases( 
        >= k & "out yes" \
        < k & "out no"
    )$
  Ma allora posso *risolvere il problema di decisione associato $hat(Pi)$ in tempo polinomiale*, *$hat(Pi) in P$*. Tuttavia abbiamo assunto che $hat(Pi) in "NPc"$, di conseguenza *è un assurdo*.\
  *Non si può risolvere $hat(Pi)$ in tempo polinomiale a meno che $P="NP"$*
]

== Algoritmi di Approssimazione

Come osservato in precedenza per i problemi di decisione, non si può "scendere a patti", essendo la risposta binaria o si sa quella giusta oppure no. 

Per quanto riguarda i *problemi di ottimizzazione*, si può *scendere a compromessi per quanto riguarda l'ottimalità della soluzuione* trovata da un algorimto. Lo scopo di questa approssimazione è trovare degli algorimti in grado di produrre soluzioni più velocemente (polinomiali).
Dunque, *gli algoritmi di approssimazione dato un certo input forniscono un output ammissibile ma sub-ottimo*.

#attenzione[
  *Non useremo mai euristiche*, ovvero approssimazioni che ogni tanto funzionano e ogni tanto no. *Siamo sempre in grado di determinare con precisione di quanto la soluziome sub-ottima si discosta dall'ottimo*.
]

=== Rapporto di appossimazione

Dati: 
- $Pi$ problema di ottimizzazione
- $A$ algoritmo t.c: 
  #let algo_diagram = diagram(
    spacing: (10pt, 4em),
    {
      let (x, a, y) = ((0,0), (3,0), (6,0))
  
      node(x, $x in I_Pi$)
      node(a, $A$, stroke: 1pt, shape: rect, width: 4em, height: 3em)
      node(y, $hat(y) in "Amm"_(Pi)(x)$)
  
      edge(x, a, "->")
      edge(a, y, "->")
    }
  )
  #align(center, algo_diagram)

- $R_(A)(x)$ ovvero il *rapporto di approssimazione*:

  $ R_(A)(x) = max((c_(Pi)(x, overline(y))) / (c_(Pi)(x, y^*)), (c_(Pi)(x, y^*)) / (c_(Pi)(x, overline(y)))) >= 1 $

  Questo rapporto vale sia se il problema era un problema di massimizzazione che di minimizzazione. 
  $ R_A(x) = cases(
   = 0 & "La soluzione" hat(y) "è ottima" \
   >= 1 & "La soluzione" hat(y) "è sub-ottima"
  ) $

  #esempio[
    - se $R = 2$ e $t_(Pi) = max$, allora la soluzione sarà la metà dell'ottimo
    - se $R = 2$ e $t_(Pi) = min$, allora la soluzione sarà il doppio dell'ottimo
  ]

Si dice che *$A$ è una $alpha$-approssimazione* sse $forall x in I_Pi$,
*$ R_(A)(x) >= alpha, quad alpha >= 1 $*

*Più alfa è grande* più *all'algoritmo è permesso* sbagliare, producendo una *soluzione che si discosta maggiormente dall'ottimo*. 

=== Classe APX

Si tratta di problemi di ottimizzazione approssimabili con un tasso entro una costante. Può essere definita come segue: 
*$ "APX" = union_(alpha >= 1) alpha-"APX" $*

#nota[
  fissando $a=1$, otteniamo la classe $1-"APX" = P$
]


#informalmente[
  Ci saranno problemi "difficili" dove non potremo più approssimare ad una costate, ma anche l'approssimazione cresce col crescere dell'input
]

=== PTAS e FPTAS

/ PTAS: Polynomial-Time Approximation Scheme. La crescita del tempo è esponenziale sul decrescere di epsilon.

$ Pi (x in I_(Pi), epsilon > 1) $

#informalmente[
  Algoritmi che prendono in input anche il tasso di approssimazione che vogliamo. Questi sono meglio degli algoritmi APX, dato che possiamo decidere noi quanto vogliamo (quindi anche meno della costante $alpha$).
]

#nota[
  Non ci sono condizioni su quanto epsilon intacca il tempo di esecuzione. Quasi sempre, abbassando epsilon allora esplode il tempo necessario.
]

#attenzione[
  Non è possibile chiedere l'ottimo, ma espsilon strettamente maggiore di 1
]

/ FPTAS: Fully Polynomial-Time Approximation Scheme

La crescita non è esponenziale su epsilon, ma è anche polinomiale sulla decrescita di espilon.

#nota[
  Questi problemi sono quasi problemi PO.
]
