;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "Ixmlminidom.lisp")

(interface Irankings
  (include Ixmlminidom)
  (sig getrankings (rankingnodes))
  (sig getcontestants (section dir id rankingnodes))
  (con getrankings-delivers-string
    (implies (xml-isnodelist rankingnodes)
             (stringp (getrankings rankingnodes))))
  (con getcontestant-delivers-list-of-strings
    (implies (xml-isnodelist rankingnodes)
             (and (true-listp (getcontestants section dir id rankingnodes))
                  (equal (len (getcontestants section dir id rankingnodes)
                              (list "Pair No."
                                    "Players"
                                    "Strat"
                                    "Overall Rank (A, B, C)"
                                    "Section Rank (A, B, C)"
                                    "Matchpoint Score"
                                    "Percentage Score",
                                    "Masterpoint Award")))))))
