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

  ;Pulls the Name Strings for a given Pair ID
  ;PairID format: (String Direction, String SectionNumber)
  ;Data format: Nodes format
  ;Output format: (String String), Names of the two players
  (defun getNameForID (pairid data) nil)

  ;;;
  ;;;
  (defun getBoardForPair (rbrds gamenode section dir)
    (if (null rbrds)
        ""
        (let* ((sbrd (car rbrds))
               (rest (cdr rbrds))
               (id (second sbrd))
               (players (getcontestants section dir id (list gamenode))))
          (concatenate 'string
                       "<tr>"
                       "<td>" (first sbrd)  "</td>"    ; boardnum
                       "<td>" section id    "</td>"    ; vs. info
                       "<td>" players       "</td>"    ; names
                       "<td>" (third sbrd)  "</td>"    ; score
                       "<td>" (fourth sbrd) "</td>"    ; matchpoints
                       "</tr>"
                       (getBoardForPair rest gamenode section dir)))))

  ;Pulls the match results for a given Pair ID
  ;PairID format: (String Direction, String SectionNumber)
  ;Results format: ?
  ;Output format: String, HTML formatted text comprising all the boards
  ;    for one player pair
  (defun getBoardsForPair (pairid section results gamenode dir)
    (let* ((bforp (assoc-equal (mv pairid section) results)))
      (getBoardForPair (cdr bforp) gamenode section dir)))

  ;;;
  ;;;
  (defun getAllPairs (results gamenode)
    (let* ((ns (car results))
           (ew (cadr results))
           (nextns (car ns))
           (keyns (car nextns))
           (nextew (car ew))
           (keyew (car nextew))
           (restns (cdr ns))
           (restew (cdr ew)))
      (if (null nextew)
          ""
          (if (null nextns)
              (concatenate 'string
                           *psctablehead*
                           ;get info from gamenode
                           (getBoardsForPair (car keyew)
                                             (cadr keyew)
                                             ew
                                             gamenode
                                             "N-S") ; The *opponents'* dir.
                           *psctabletail*
                           (getAllPairs (mv ns restew) gamenode))
              (concatenate 'string
                           *psctablehead*
                           ;get info from gamenode
                           (getBoardsForPair (car keyns)
                                             (cadr keyns)
                                             ns
                                             gamenode
                                             "E-W")
                           *psctabletail*
                           (getAllPairs (mv restns ew) gamenode))))))

  ;Pulls the Personal Score Card data for all players, and put's them all
  ;into html table format
  ;XMLnodes format: Nodes format
  ;Output format: String, HTML formatted text comprising the score card
  ;    for one player pair
  (defun serializedPSC (gamenode boardnodes)
    (let* ((results (getAllSeparateResults boardnodes)))
      (getAllPairs results gamenode)))

  (export Ipsc))
