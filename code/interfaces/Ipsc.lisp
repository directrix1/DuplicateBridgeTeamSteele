;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
#| Team Steele
   Software Engineering I
   iPSC

   Interface for the Personal Score Card Module mPSC
|#

(require "Ixmlminidom.lisp")

(in-package "ACL2")

(interface iPSC
  
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  (include "Ixmlminidom")
  
  
  ;Pulls the Personal Score Card data for all players, and put's them all
  ;into html table format
  ;XMLnodes format: Nodes format
  ;Output format: String, HTML formatted text comprising the score card
  ;    for one player pair
  (sig getPSC(xmlnodes))
  
  ;Pulls the Name Strings for a given Pair ID
  ;PairID format: (String Direction, String SectionNumber)
  ;Data format: Nodes format
  ;Output format: (String String), Names of the two players
  (sig getNameForID(pairid data))
  
  ;Pulls the match results for a given Pair ID
  ;PairID format: (String Direction, String SectionNumber)
  ;Results format: ?
  ;Output format: String, HTML formatted text comprising all the boards
  ;    for one player pair
  (sig getBoardsForPair(pairid results))
  
  (con getPSC-con1
       (implies ()
                ()))
  
  (con getNameForID-Gives-Two-Strings
       (implies (and (listp pairid)
                     (stringp (car pairid))
                     (stringp (cadr pairid))
                     (xml-isnodelist data))
                (let (output (getNameForID pairid data))
                  (and (listp output)
                       (equal (len output) 2)
                       (stringp (car output))
                       (stringp (cadr output))))))
  
  (con getBoardsForPair-con1
       (implies ()
                ())))
