#import "@preview/gentle-clues:1.2.0" // colored boxes
#import "@preview/equate:0.3.2" // better equations
#import "@preview/cetz:0.4.0" // drawings
#import "@preview/fletcher:0.5.8" // diagrams
#import "@preview/cetz-venn:0.1.4" // venn diagrams
#import "@preview/lovelace:0.3.0": indent, pseudocode // pseudocode
#import "@preview/codly:1.3.0" // code

// colored math text
#let mg(body) = text(fill: olive, $#body$)
#let mm(body) = text(fill: maroon, $#body$)
#let mo(body) = text(fill: orange, $#body$)
#let mr(body) = text(fill: red, $#body$)
#let mp(body) = text(fill: purple, $#body$)
#let mb(body) = text(fill: blue, $#body$)

// colored boxes
#let nota(body) = { gentle-clues.info(title: "Nota")[#body] }
#let attenzione(body) = { gentle-clues.warning(title: "Attenzione")[#body] }
#let informalmente(body) = { gentle-clues.idea(title: "Informalmente", accent-color: green)[#body] }
#let esempio(body) = { gentle-clues.experiment(title: "Esempio", accent-color: purple)[#body] }

#let dimostrazione(body) = {
  set math.equation(numbering: "(1.1)", supplement: "EQ") // activate math numbering
  gentle-clues.memo(title: "Dimostrazione")[#body]
}

#let teoremi-counter = counter("teorema")
#let teorema(title, body) = {
  set math.equation(numbering: "(1.1)", supplement: "EQ") // activate math numbering
  teoremi-counter.step()
  gentle-clues.task(
    title: title + "  " + emph("(THM " + context (teoremi-counter.display()) + ")"),
    accent-color: eastern,
  )[#body]
}

// link to theorem
#let link-teorema(label) = {
  underline(link(label, "THM " + context (1 + teoremi-counter.at(locate(label)).first())))
}
// link to section
#let link-section(label) = {
  underline(link(label, context (
    numbering(heading.numbering, ..counter(heading).at(locate(label))) + " " + query(label).first().body
  )))
}
// link to equation
#let link-equation(label) = underline(ref(label))

// first page and outline
#let frontmatter(title, subtitle, authors) = {
  align(left + horizon, block(width: 90%)[

    #text(3em)[*#title*]\
    #text(1.5em)[#subtitle]

    #(
      authors
        .map(author => [
          #link("https://github.com/" + author.at(1))[
            #text(1.5em, author.at(0))
          ]
        ])
        .join([ -- ])
    )\

    #text("Ultima modifica:")
    #datetime.today().display("[day]/[month]/[year]")
  ])

  pagebreak()

  outline(
    title: "Indice",
    indent: auto,
  )
}

// todo warning
#let todo = {
  emoji.warning
  [*TODO: questa sezione è in attesa di conferma, potrebbe non essere corretta/completa*]
  emoji.warning
}
