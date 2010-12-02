;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
#| Team Steele
   Software Engineering I
   Mpsc
  
   Personal Score Card Module
|#
(require "../interfaces/Ipsc.lisp")
(require "../interfaces/Iboard.lisp")
(require "../interfaces/Irankings.lisp")
(require "../interfaces/Ixmlminidom.lisp")
(require "../interfaces/Ibasiclex.lisp")

(module Mpsc
  (import Iboard)
  (import Ixmlminidom)
  (import Irankings)
  (import Ibasiclex)
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  
  
  
  
  
  
  
  
  
  ;Pulls the Personal Score Card data for all players, and put's them all
  ;into html table format
  ;XMLnodes format: Nodes format
  ;Output format: String, HTML formatted text comprising the score card
  ;    for one player pair
  (defun getPSC(xmlnodes)
    (let* ((results (getallseparateresults (xmlnodes))))
      ()))
  
  ;Pulls the Name Strings for a given Pair ID
  ;PairID format: (String Direction, String SectionNumber)
  ;Data format: Nodes format
  ;Output format: (String String), Names of the two players
  (defun getNameForID(pairid data)
    ())
  
  ;;;
  ;;;
  (defun getBoardForPair(rbrds)
    (let* ((sbrd (cdar rbrds))
           (rest (cddr rbrds)))
    (concatenate 'string
              "<tr>"
              "<td>" (first sbrd) "</td>"
              "<td>" (second sbrd) "</td>"
              "<td>" (third sbrd) "</td>"
              "<td>" (fourth sbrd) "</td>"
              "</tr>"
            (getBoardForPair rest))))
    
  ;Pulls the match results for a given Pair ID
  ;PairID format: (String Direction, String SectionNumber)
  ;Results format: ?
  ;Output format: String, HTML formatted text comprising all the boards
  ;    for one player pair
  (defun getBoardsForPair(pairid section results) ;NOTE Direction decided in getPSC or above
    (let* ((bforp (assoc-equal (mv pairid section) results)))
    (getBoardForPair bforp)))
  
  ;;;
  ;;;
  (defun getAllPairs (results rankings)
    (let* ((ns (car results))
           (ew (cadr results))
           (nextns (car ns))
           (keyns (car nextns))
           (nextew (car ew))
           (keyew (car nextew))
           (restns (cdr ns))
           (restew (cdr ew)))
    (if (equal nextns nil)
        (concatenate 'string
                     *psctablehead*
                     ;get info from rankings
                     (getBoardsForPair (car keyew) (cadr keyew) ew)
                     *psctabletail*
                     (getAllPairs (list restns restew) rankings)
                     )
        (concatenate 'string
                     *psctablehead*
                     ;get info from rankings
                     (getBoardsForPair (car keyns) (cadr keyns) ns)
                     *psctabletail*
                     (getAllPairs (list restns restew) rankings)))))
    
  
  (export Ipsc))