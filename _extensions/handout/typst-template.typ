#let article(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  meta-json: (),
  doc,
  ) = {
  
  // parse metadata from meta-json
  let meta = json(bytes(meta-json.text))
  let course-title = meta.at("course-title", default: none)
  let course-term = meta.at("course-term", default: none)

  // set basic formatting
  import "@preview/fontawesome:0.5.0": *

  let mycolor = rgb("#00a082")

  set page(
    paper: "a4",
    margin: (top: 3cm, bottom: 2.5cm, left: 2.5cm, right: 3cm),
    header-ascent: 40%,
    header: [
      #set text(size: 0.9em)
      #course-title, #course-term \
      #authors.map(a => [#a.name]).join(" & ")
      ]
  )

  set text(
    font: "Source Sans 3",
    size: 11pt
  )

  set par(
    leading: 0.65em,
    spacing: 1.65em
  )

  show heading: set text(weight: "regular")

  show heading.where(level: 1): it => {
    set text(size: 22pt, weight: "regular", fill: mycolor)
    set par(leading: 0.5em, spacing: 1.5em)
    set block(below: 1em)
    it
  }
  show heading.where(level: 2): it => {
    set text(fill: mycolor, size: 16pt, weight: "regular")
    set par(leading: 0.55em, spacing: 1.55em)
    set block(below: 0.775em, above: 1.55em)
    it
  }
  show heading.where(level: 3): it => {
    set text(size: 1em, weight: "semibold")
    it
  }

  show strong: it => {
    set text(weight: "semibold", fill: mycolor)
    it.body
  }

  [= #meta.title]
  if "subtitle" in meta [#meta.subtitle]

  doc

  if "schedule" in meta [
    // #v(1em)
    #text(fill: mycolor, weight: "semibold")[== Sitzungsablauf]
    #set text(size: 0.9em)
    #set par(spacing: 0.55em)
    // #text(fill: mycolor, size: 14pt, weight: "semibold")[Ablauf]
    #set par(spacing: 1.5em)
    #let formats = (
      "Impuls": fa-person-chalkboard(),
      "Präsentation": fa-person-chalkboard(),
      "Diskussion": fa-comments(),
      "Gespräch": fa-comments(),
      "Einzelarbeit": fa-person-dress(),
      "Partnerarbeit": fa-user-group(),
      "Gruppenarbeit": fa-people-group(),
      "Wiederholung": fa-repeat(),
    )

    #for x in meta.schedule {

      grid(
        columns: (30pt, 5fr, 2fr),
        inset: (left: 0em, right: 0.5em, y: 0.5em),
        align: (left, left, right),
        grid.header(
          [*#x.time'*], [*#x.title*], [*#x.format #formats.at(x.format, default: none)*],
        ),
        grid.hline(stroke: 0.5pt + mycolor),
        ..if "goals" in x {(
          [*#fa-bullseye()*], 
          grid.cell(
            colspan: 2,
            if type(x.goals) == array { x.goals.join(", ") }
            else { x.goals }
          )
        )},
        ..if "material" in x {(
          [*#fa-toolbox()*], 
          grid.cell(
            colspan: 2,
            x.material.join(", ")
          )
        )},
        ..if "description" in x {(
          [*#fa-forward()*], 
          grid.cell(
            colspan: 2,
            eval(x.description, mode: "markup")
          )
        )},
      )
    } 

  ]
}