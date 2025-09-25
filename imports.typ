#import "@preview/gentle-clues:1.2.0": *
#import "@preview/equate:0.3.2": *
#import "@preview/codly:1.3.0": *

// drawings
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.0"
#import "@preview/cetz-venn:0.1.4"

// colored math text
#let mg(body) = text(fill: olive, $#body$)
#let mm(body) = text(fill: maroon, $#body$)
#let mo(body) = text(fill: orange, $#body$)
#let mr(body) = text(fill: red, $#body$)
#let mp(body) = text(fill: purple, $#body$)
#let mb(body) = text(fill: blue, $#body$)

//pseudocode
#import "@preview/algorithmic:1.0.5"
#import algorithmic: style-algorithm, algorithm-figure
#show: style-algorithm

// colored boxes
#let nota(body) = { info(title: "Nota")[#body] }
#let attenzione(body) = { warning(title: "Attenzione")[#body] }
#let informalmente(body) = { idea(title: "Informalmente", accent-color: green)[#body] }
#let esempio(body) = { experiment(title: "Esempio", accent-color: purple)[#body] }
#let teorema(title, body) = { task(title: title, accent-color: eastern)[#body] }
#let dimostrazione(body) = { memo(title: "Dimostrazione")[#body] }

// first page and outline
#let frontmatter(title, subtitle, authors) = {
  align(left + horizon, block(width: 90%)[

    #text(3em)[*#title*]\
    #text(1.5em)[#subtitle]

    #authors.map(author => [
      #link("https://github.com/" + author.at(1))[
        #text(1.5em, author.at(0))
      ]
    ]).join([ -- ])\

    #text("Ultima modifica:")
    #datetime.today().display("[day]/[month]/[year]")
  ])

  pagebreak()

  outline(
    title: "Indice",
    indent: auto
  )
}

// temporary git review separator
#let appunti = {
  pagebreak()
  align(left + horizon, block(width: 90%)[
    #text(3em)[Appunti sistemati fino a qua.]
  ])

  v(1em)

  text(1.4em)[
    SE VANNO BENE E NON AVETE TOCCATO NULLA APPROVATE LA REVIEW SU GIT
  ]

  v(1em)

  text(1.4em)[
    MAGARI GUARDATE ANCHE I \/\/TODO
  ]
  pagebreak()
}
