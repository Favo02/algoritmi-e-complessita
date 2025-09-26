#import "imports.typ": *

// metadata
#let title = "Algoritmi e Complessità"
#let subtitle = "Università degli Studi di Milano - Informatica"
#let authors = (("Luca Favini", "Favo02"), ("Luca Corradini", "LucaCorra02"), ("Matteo Zagheno", "Tsagae"))

#set document(
  title: title,
  author: authors.map(author => author.at(0)),
)

// first page and outline
#frontmatter(title, subtitle, authors)

// various settings
#set terms(separator: [: ]) // terms list
#set heading(numbering: "1.1.") // heading numbering
#show: gentle-clues.with(breakable: true) // colored boxes
#show: codly-init.with() // codly setup
#show: equate.with(breakable: true) // equations settings
#show heading.where(level: 1): it => {
  // page break every chapter
  pagebreak()
  it
}
#set page(
  // header and footer
  numbering: "1",
  number-align: bottom + right,
  header: [
    #set text(8pt, style: "italic")
    #title
    #h(1fr)
    #context [
      #let headings = query(heading)
      #let current-page = here().page()
      #let filtered-headings = headings.filter(h => h.location().page() <= current-page)
      #if filtered-headings.len() > 0 [
        #let current-heading = filtered-headings.last()
        #if current-heading.numbering != none [
          #numbering(current-heading.numbering, ..counter(heading).at(current-heading.location())) #current-heading.body
        ] else [
          #current-heading.body
        ]
      ]
    ]
  ],
  footer: [
    #set text(8pt)
    _#authors.map(author => author.at(0)).join(", ") - #datetime.today().display("[day]/[month]/[year]")_
    #h(1fr)
    #context [#text(12pt)[#counter(page).display("1")]]
  ],
)

// content
#include "chapters/1-notazione.typ"
#include "chapters/2-problemi-e-algoritmi.typ"
#include "chapters/3-classi-di-complessita.typ"
#include "chapters/4-max-matching-load-balacing.typ"
