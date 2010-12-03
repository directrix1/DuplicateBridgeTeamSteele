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

  ; Given a list of nodes, glue all nodes' children together in one big
  ; list; i.e., if the nodes are rooted in some tree where they're at depth
  ; k, then take all of the nodes at depth k+1 (cousins or siblings to one
  ; another), and put them into a list together.
  (defun gluekids (nodes)
    (if (consp nodes)
      (mv-let (nodename atts kids)
              (car nodes)
              (concatenate 'list kids (gluekids (cdr nodes))))
      nil))

  (defun findsectionnodes (nodes)
    ; Build a dummy node that looks like xmlminidom, so we can act like
    ; nodes are rooted there as children, and we can just use xml-getnodes
    ; on it.
    (let* ((dummyroot (mv 'dummyroot nil nodes))
           (maybesections (xml-getnodes dummyroot 'Section)))
        (if maybesections
            ; We found them
            maybesections
            ; There were no Section nodes.  Look deeper.
            (findsectionnodes (gluekids nodes)))))
  
  ; sectionnodes should be a list of section nodes
  (defun findspecificsection (sectionnodes label dir)
    (if sectionnodes
      ; linear search!
      (let* ((current (car sectionnodes)))
        (if (and (equal (xml-getattribute current "SectionLabel")
                        label)
                 (equal (xml-getattribute current "Direction")
                        dir))
            current
            (findspecificsection (cdr sectionnodes) label dir)))
      nil))

  ; Approach: use xml-getnodes on rankingnodes in a BFS fashion until we
  ; hit the Section nodes.  Start trying to find the Section node whose
  ; SectionLabel and Direction attributes match section and dir,
  ; respectively.  Use xml-getnodes for Contestants on that section, and
  ; find the Contestants node whose ID attribute matches id....
  (defun getcontestants (section dir id rankingnodes)
    (let* ((section (findspecificsection (findsectionnodes rankingnodes)
                                         section
                                         dir)))
      nil))
  (export Irankings))
