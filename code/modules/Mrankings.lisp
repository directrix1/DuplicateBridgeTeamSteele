;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "../interfaces/Ixmlminidom.lisp")
(require "../interfaces/Irankings.lisp")

(module Mrankings
  (import Ixmlminidom)
  (defun getrankings (rankingnodes)
    )
  (defun getcontestants (section dir id rankingnodes)
    )
  (export Mpsc))
