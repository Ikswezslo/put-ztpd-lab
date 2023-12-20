(: 5. 
for $z in doc("db/bib/bib.xml")/bib/book/author return $z//last 
:)

(: 6.
for $book in doc("db/bib/bib.xml")/bib/book
for $author in $book/author
for $title in $book/title
return
<ksiazka>
  {$author}
  {$title}
</ksiazka> 
:)

(: 7.
for $book in doc("db/bib/bib.xml")/bib/book
for $author in $book/author
for $title in $book/title
return
<ksiazka>
  <autor>
    {$author/last/text()}{$author/first/text()}
  </autor>
  <tytul>
    {$title/text()}
  </tytul>
</ksiazka> 
:)

(: 8.
for $book in doc("db/bib/bib.xml")/bib/book
for $author in $book/author
for $title in $book/title
return
<ksiazka>
  <autor>
    {$author/last/text() || ' ' || $author/first/text()}
  </autor>
  <tytul>
    {$title/text()}
  </tytul>
</ksiazka> 
:)

(: 9.
<wynik>
  {
    for $book in doc("db/bib/bib.xml")/bib/book
    for $author in $book/author
    for $title in $book/title
    return
    <ksiazka>
      <autor>
        {$author/last/text() || ' ' || $author/first/text()}
      </autor>
      <tytul>
        {$title/text()}
      </tytul>
    </ksiazka>
  }
</wynik> 
:)

(: 10.
<imiona>
  {
    for $author in doc("db/bib/bib.xml")/bib/book[title='Data on the Web']/author
    return 
    <imie>{$author/first/text()}</imie>
  }
</imiona> 
:)

(: 11.a
for $book in doc("db/bib/bib.xml")/bib/book[title='Data on the Web']
return
<DataOnTheWeb>{$book}</DataOnTheWeb> 
:)

(: 11.b
for $book in doc("db/bib/bib.xml")/bib/book where $book/title = 'Data on the Web'
return
<DataOnTheWeb>{$book}</DataOnTheWeb> 
:)

(: 12.
for $book in doc("db/bib/bib.xml")/bib/book where contains($book/title, 'Data')
return
<Data>
  {
    for $author in $book/author
    return <nazwisko>{$author/last/text()}</nazwisko>
  }
</Data> 
:)

(: 13.
for $book in doc("db/bib/bib.xml")/bib/book where contains($book/title, 'Data')
return
<Data>
  {$book/title}
  {
    for $author in $book/author
    return <nazwisko>{$author/last/text()}</nazwisko>
  }
</Data> 
:) 

(: 14.
for $book in doc("db/bib/bib.xml")/bib/book where count($book/author) <= 2
return
$book/title 
:)

(: 15.
for $book in doc("db/bib/bib.xml")/bib/book
return
<ksiazka>
  {$book/title}
  <autorow>{count($book/author)}</autorow>
</ksiazka> 
:)

(: 16.
let $book := doc("db/bib/bib.xml")/bib/book
return
<przedział>
  {min($book/@year)} - {max($book/@year)}
</przedział> 
:)

(: 17.
let $book := doc("db/bib/bib.xml")/bib/book
return
<różnica>
  {max($book/price) - min($book/price)}
</różnica> 
:) 

(: 18.
let $books := doc("db/bib/bib.xml")/bib/book
let $min_price := min($books/price)
return
<najtańsze>
{
  for $book in $books where $book/price = $min_price
  return
  <najtańsza>
    {$book/title}
    {$book/author}
  </najtańsza>
}
</najtańsze> 
:)

(: 19.
for $last in distinct-values(doc("db/bib/bib.xml")/bib/book/author/last)
return
<autor>
  <last>{$last}</last>
  {
    for $book in doc("db/bib/bib.xml")/bib/book where contains($book, $last)
    return
    $book/title
  }
</autor> 
:)

(: 20.
<wynik>
{
  for $play in collection("db/shakespeare")/PLAY
  return $play/TITLE
}
</wynik> 
:)


(: 21.
for $play in collection("db/shakespeare")/PLAY
where some $line in $play//LINE satisfies contains($line, 'or not to be')
return $play/TITLE 
:)

(: 22. :)
<wynik>
  {
    for $play in collection("db/shakespeare")/PLAY
    return 
    <sztuka tytul="{$play/TITLE}">
      <postaci>
        {count($play//PERSONA)}
      </postaci>
      <aktow>
        {count($play/ACT)}
      </aktow>
      <scen>
        {count($play//SCENE)}
      </scen>
    </sztuka>
  }
</wynik>
