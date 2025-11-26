#import "imports.typ": *

// metadata
#let title = "Algoritmi e Complessità"
#let subtitle = "Università degli Studi di Milano - Informatica Magistrale"
#let authors = (("Luca Favini", "Favo02"), ("Luca Corradini", "LucaCorra02"), ("Matteo Zagheno", "Tsagae"))
#let introduction = [
  #show link: underline
  = Dispensa di Algoritmi e Complessità

  Appunti del corso di #link("https://boldi.di.unimi.it/Corsi/AlgComp2025/")[_Algoritmi e Complessità_] (a.a. 2024/25), tenuto dal Prof. _Paolo Boldi_, Corso di Laurea in Informatica Magistrale, Università degli Studi di Milano.

  Realizzati da #(authors.map(author => [#link("https://github.com/" + author.at(1))[#text(author.at(0))]]).join([, ])), con il contributo di #link("https://github.com/Favo02/algoritmi-e-complessita/graphs/contributors")[altri collaboratori].

  Questi appunti sono open source: #link("https://github.com/Favo02/algoritmi-e-complessita")[github.com/Favo02/algoritmi-e-complessita] con licenza #link("https://creativecommons.org/licenses/by/4.0/")[CC-BY-4.0].
  Le contribuzioni e correzioni sono ben accette attraverso Issues o Pull Requests.

  Ultima modifica: #datetime.today().display("[day]/[month]/[year]").
]

#set document(
  title: title,
  author: authors.map(author => author.at(0)),
)

// first page and outline
#frontmatter(title, subtitle, authors, introduction)

// various settings
#set terms(separator: [: ]) // terms list
#set heading(numbering: "1.1.") // heading numbering
#set math.equation(numbering: none, supplement: "EQ") // equations numbering, off by default, active in teorema or dimostrazione blocks
#show: equate.equate.with(breakable: true, sub-numbering: true) // equations settings
#show: gentle-clues.gentle-clues.with(breakable: true) // colored boxes
#show: codly.codly-init.with() // code setup
#show link: underline // undeline links
#set figure(supplement: "Figura") // rename Figure to Figura

// page break every chapter
#show heading.where(level: 1): it => {
  pagebreak()
  it
}

// header and footer
#set page(
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

#part("Fondamenti")
#include "chapters/1-notazione.typ"
#include "chapters/2-problemi-e-algoritmi.typ"
#include "chapters/3-classi-di-complessita.typ"

#part("Algoritmi di Approssimazione")
#include "chapters/4-problema-max-bimatching.typ"
#include "chapters/5-problema-load-balancing.typ"
#include "chapters/6-problema-center-selection.typ"
#include "chapters/7-problema-set-cover.typ"
#include "chapters/8-problema-vertex-cover.typ"
#include "chapters/9-problema-congested-paths.typ"
#include "chapters/10-problema-tsp-metrico.typ"
#include "chapters/11-problema-knapsack.typ"

#part("Algoritmi Probabilistici")
#include "chapters/12-algoritmi-probabilistici.typ"
#include "chapters/13-problema-min-cut.typ"
#include "chapters/14-problema-set-cover.typ"
#include "chapters/15-problema-max-ek-sat.typ"

#part("Teoria della Complessità di Approssimazione")
#todo

#part("Strutture Dati Compresse")
#include "chapters/17-strutture-dati-compresse.typ"
#include "chapters/18-struttura-rango-e-selezione.typ"
