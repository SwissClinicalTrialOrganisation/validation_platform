#show: scto_typst_template.with(
$if(title)$
  title: "$title$",
$endif$
$if(subtitle)$
  subtitle: "$subtitle$",
$endif$
$if(toc)$
  toc: $toc$,
$endif$
$if(date)$
  date: "$date$",
$endif$
$if(release_date)$
  release_date: "$release_date$",
$endif$
$if(integral)$
  integral: "$integral$",
$endif$
$if(paper-size)$
  paper-size: "$paper-size$",
$endif$
$if(heading)$
$if(heading-numbering)$
  heading-numbering: "$heading-numbering$",
$endif$
$else$
  heading-numbering: "1.1.1",
$endif$
)
