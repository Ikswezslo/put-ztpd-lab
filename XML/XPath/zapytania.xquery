let $path := ''
return doc($path)

(:27.:)
(:return doc($path)/SWIAT/KRAJE/KRAJ:)

(:28.:)
(:return doc($path)/SWIAT/KRAJE/KRAJ[starts-with(NAZWA, 'A')]:)

(:29.:)
(:return doc($path)/SWIAT/KRAJE/KRAJ[starts-with(NAZWA, substring(STOLICA, 1, 1))]:)

(:32.:)
(:return doc($path)//NAZWISKO:)

(:33.:)
(:return doc($path)/ZESPOLY/ROW[NAZWA='SYSTEMY EKSPERCKIE']//NAZWISKO:)

(:34.:)
(:return count(doc($path)/ZESPOLY/ROW[ID_ZESP='10']//ROW):)

(:35.:)
(:return doc($path)//PRACOWNICY/ROW[ID_SZEFA='100']/NAZWISKO:)

(:36.:)
(:return sum(doc($path)/ZESPOLY/ROW[ID_ZESP=//PRACOWNICY/ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP]//PLACA_POD):)
