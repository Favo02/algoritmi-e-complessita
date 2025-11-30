#import "@preview/gentle-clues:1.2.0" // colored boxes
#import "@preview/equate:0.3.2" // better equations
#import "@preview/cetz:0.4.0" // drawings
#import "@preview/fletcher:0.5.8" // diagrams
#import "@preview/cetz-venn:0.1.4" // venn diagrams
#import "@preview/lovelace:0.3.0": indent, pseudocode // pseudocode
#import "@preview/codly:1.3.0" // code
#import "@preview/pinit:0.2.2" // relative positioned arrows

// colored math text
#let mg(body) = text(fill: green, $#body$)
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
#let frontmatter(title, subtitle, authors, introduction) = {
  align(center + horizon, block(width: 90%)[

    #text(3em)[*#title*]
    #block(above: 1.5em)[#text(1.3em)[#subtitle]]
    #block(below: 0.8em)[#(
      authors.map(author => [#link("https://github.com/" + author.at(1))[#author.at(0)]]).join([, ])
    )]
    #text(0.8em)[Ultima modifica: #datetime.today().display("[day]/[month]/[year]")]
  ])

  pagebreak()

  // Info section
  set heading(numbering: none, bookmarked: false, outlined: false)
  [#introduction]

  show outline.entry.where(
    level: 1,
  ): it => {
    if it.element.numbering == none and it.element.outlined {
      v(0.5em)
      text(1.1em)[*#it*]
    } else {
      it
    }
  }

  outline(
    title: "Indice",
    indent: auto,
  )
}

// part counter and function
#let part-counter = counter("part")
#let part(title) = {
  part-counter.step()

  // Add to outline without numbering in the document flow
  align(center + horizon)[
    #context {
      let part-num = numbering("I", part-counter.get().first())
      heading(level: 1, numbering: none, outlined: true, bookmarked: true)[
        Parte #part-num: #title
      ]
    }
  ]
}

// todo warning
#let todo = {
  emoji.warning
  [*TODO: questa sezione è in attesa di conferma, potrebbe non essere corretta/completa*]
  emoji.warning
}
