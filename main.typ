// --- METADATA ---
#let title = "Corso di Template"
#let subtitle = "Università degli Studi di Milano - Informatica"
#let authors = (("Luca Favini", "Favo02"), ("Andrea Sacchi", "alsacchi"))

// --- TEMPLATE ---

#import "@preview/gentle-clues:1.2.0": *
#import "@preview/equate:0.3.2": *
#import "@preview/codly:1.3.0": *

// testo matematico colorato
#let mg(body) = text(fill: olive, $#body$)
#let mm(body) = text(fill: maroon, $#body$)
#let mo(body) = text(fill: orange, $#body$)
#let mr(body) = text(fill: red, $#body$)
#let mp(body) = text(fill: purple, $#body$)
#let mb(body) = text(fill: blue, $#body$)

// settings box colorati
#show: gentle-clues.with(breakable: true)

// settings equazioni
#show: equate.with(breakable: true)

// box colorati
#let nota(body) = { info(title: "Nota")[#body] }
#let attenzione(body) = { warning(title: "Attenzione")[#body] }
#let informalmente(body) = { tip(title: "Informalmente")[#body] }
#let dimostrazione(body) = { memo(title: "Dimostrazione")[#body] }

// codly setup
#show: codly-init.with()

#set document(
  title: title,
  author: authors.map(author => author.at(0)),
)

// prima pagina
#align(left + horizon, block(width: 90%)[

  #text(3em)[*#title*]\
  #text(1.5em)[#subtitle]

  #authors.map(author => [
    #link("https://github.com/" + author.at(1))[
      #text(1.5em, author.at(0))
    ]
  ]).join(text(", "))\

  #text("Ultima modifica:")
  #datetime.today().display("[day]/[month]/[year]")
])

#pagebreak()

// indice
#outline(
  title: "Indice",
  indent: auto
)

// numerazione titoli
#set heading(numbering: "1.1.")

// impostazioni pagine
#let numberingH(c)={
  if c.numbering != none {
    return numbering(c.numbering,..counter(heading).at(c.location()))
  }
  return ""
}

#let currentH(level: 1)={
  let elems = query(selector(heading).after(here()))

  if elems.len() != 0 and elems.first().location().page() == here().page() {
    return [#numberingH(elems.first()) #elems.first().body]
  } else {
    elems = query(selector(heading).before(here()))
    if elems.len() != 0 {
      return [#numberingH(elems.last()) #elems.last().body]
    }
  }
  return ""
}

#set page(
  numbering: "1",
  number-align: bottom + right,
  header: [
    #set text(8pt, style: "italic")
    #title
    #h(1fr)
    #context[_ #currentH() _]
  ],
  footer: [
    #set text(8pt)

    #context[
      _#authors.map(author => author.at(0)).join(", ") - #datetime.today().display("[day]/[month]/[year]")_
      #h(1fr)
      #text(12pt)[#counter(page).display("1")]
    ]
  ],
)

// --- CONTENUTO ---

= Capitolo 1 <capitolo-1>

#lorem(100)

== Box colorati <box-colorati>

#nota(lorem(20))<nota-1>
#informalmente(lorem(20))
#attenzione(lorem(20))
#dimostrazione(lorem(20))

== Matematica <matematica>

Inline: $3 = 1 + 2$

Non inline, colorata:

$ mr(3) &= mr(1 + 2) + mb(4 dot 0) \
  mr(3) &= mr(1 + 2) + cancel(mb(4 dot 0)) \
  mr(3) &= mr(3) $

== Elenchi <elenchi>

/ #lorem(1) : #lorem(5)
/ #lorem(1) : #lorem(5)
/ #lorem(1) : #lorem(5)

+ #lorem(4)
+ #lorem(4)
+ #lorem(4)

== Immagini <immagini>

#no-codly(
```Typst
#figure(
  image("./imgs/immagine-1.png", width: 80%),
  caption: [
    Esempio boxplot.
  ],
)
```)

== Codice <codice>

#codly(
  highlights: (
    (line: 4, start: 3, end: none, fill: red),
    (line: 5, start: 12, end: 21, fill: green),
    (line: 5, start: 25, fill: blue),
  ),
  annotations: (
    (
      start: 2,
      end: 3,
      content: block(
        width: 10em,
        "Caso base"
      )
    ),
  )
)
```python
def fib(n):
  if n <= 1:
    return n
  else:
    return fib(n - 1) + fib(n - 2)
print(fib(25))
```


== Link <link>

Link al `<tag>` #link(<matematica>)[matematica]
