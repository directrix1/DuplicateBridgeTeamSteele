;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "../interfaces/Ixmlminidom.lisp")
(require "../interfaces/Irankings.lisp")

(module Mrankings
  (import Ixmlminidom)
  ; XXX rankingnodes is a bad misnomer.  rankingnodes should definitely
  ; *not* be a list of Rankings nodes.  At a minimum, we need the Section
  ; nodes, too.
  (defun getrankings (rankingnodes)
    nil)
  ; Approach, use xml-getnodes on rankingnodes in a BFS fashion until we
  ; hit the Section nodes.  Start trying to find the Section node whose
  ; SectionLabel and Direction attributes match section and dir,
  ; respectively.  Use xml-getnodes for Contestants on that section, and
  ; find the Contestants node whose ID attribute matches id....
  (defun getcontestants (section dir id rankingnodes)
    nil)
  (export Irankings))
