#show: article.with(
  $if(title)$
  title: [$title$],
  $endif$
  $if(subtitle)$
    subtitle: [$subtitle$],
  $endif$
  $if(by-author)$
    authors: (
  $for(by-author)$
  $if(it.name.literal)$
      ( name: [$it.name.literal$],
        affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$],
        email: [$it.email$] ),
  $endif$
  $endfor$
      ),
  $endif$
  $if(date)$
    date: [$date$],
  $endif$
  meta-json: `$meta-json$`
)
