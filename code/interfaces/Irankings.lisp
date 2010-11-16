;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "Ixmlminidom.lisp")

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
