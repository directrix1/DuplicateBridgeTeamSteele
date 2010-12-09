;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "Ixmlminidom.lisp")

(defconst *rktablehead*
  (concatenate 'string
  "<table class=\"results\">"
  "<tr>"
  "<th rowspan=\"2\">Pair No.</th>"
  "<th rowspan=\"2\">Players</th>"
  "<th rowspan=\"2\">Strat / Flight</th>"
  "<th colspan=\"3\">Section Rank</th>"
  "<th colspan=\"3\">Overall Rank</th>"
  "<th rowspan=\"2\">Matchpoint Score</th>"
  "<th rowspan=\"2\">Percentage Score</th>"
  "<th rowspan=\"2\">Masterpoint Award</th>"  
  "</tr>"
  "<tr>"
  "<th>A</th>"
  "<th>B</th>"
  "<th>C</th>"
  "<th>A</th>"
  "<th>B</th>"
  "<th>C</th>"
  "</tr>"
  ))
(defconst *rktabletail*
  "</table>")

(interface Irankings
  (include Ixmlminidom)
  (sig getmatchpointtotal (node))
  (sig sortcontestants (unsortedcontestants))
  (sig sortmvranks (ranks mvs))
  (sig serializedrankings (rankingnodes))
  ;(sig serializedrankingsheader (gamenodes))
  (sig getcontestants (section dir id sections))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Contracts
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (con getmatchpointtotal-returns-real
    (implies (xml-isnode mpnode)
             (real (getmatchpointtotal mpnode))))
  (con sortcontestants-returns-list
  (con getrankings-delivers-string
    (implies (xml-isnodelist rankingnodes)
             (listp (sortcontestants rankingnodes))))
  (con sortmvranks-returns-three
    (implies (xml-isnodelist rankingnodes)
             (eq 3 (len (sortmvrankings rankingnodes (mv nil nil nil))))))
  (con serializedrankings-delivers-string
    (implies (xml-isnodelist rankingnodes)
             (stringp (serializedrankings rankingnodes))))
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
