;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
#| Team Steele
   Software Engineering I
   Txmlminidom

   Software that creates a document object model from XML input.
|#

(require "../interfaces/Ixmlminidom.lisp")
(require "../modules/Mxmlminidom.lisp")
(require "../modules/Mbasiclex.lisp")

(module Txmlminidom
  (import Ixmlminidom)
  
  (include-book "testing" :dir :teachpacks)
  
  (defconst
    *Oface*
    "<bob><slidell id=\"porter\">123<jumptoconclusions /></slidell></bob>")
  
  (check-expect
   (xml-getattribute
    (xml-getnode
     (xml-readnode *Oface*)
     "slidell") "id")
   "porter")
  
  (check-expect
   (xml-gettext
    (xml-readnode *Oface*))
   "123"))

(link Test
      (Mbasiclex Mxmlminidom Txmlminidom))

(invoke Test)