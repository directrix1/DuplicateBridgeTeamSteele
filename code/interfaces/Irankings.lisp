(interface Irankings
  (sig getrankings (rankingnodes))
  (sig getcontestant (pairid rankingnodes))
  (con getrankings-delivers-string
    (implies (xml-isnodelist rankingnodes)
             (stringp (getrankings rankingnodes))))
  (con getcontestant-delivers-list-of-strings
    (implies (xml-isnodelist rankingnodes)
             (and (true-listp (getcontestant pairid rankingnodes))
                  (equal (len (getcontestant pairid rankingnodes)
                              (list "Pair No."
                                    "Players"
                                    "Strat"
                                    "Overall Rank (A, B, C)"
                                    "Section Rank (A, B, C)"
                                    "Matchpoint Score"
                                    "Percentage Score",
                                    "Masterpoint Award")))))))
