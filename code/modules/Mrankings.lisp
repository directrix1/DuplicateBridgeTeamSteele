;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "../interfaces/Ixmlminidom.lisp")
(require "../interfaces/Irankings.lisp")

(module Mrankings
  (import Ixmlminidom)
  
  (include-book "io-utilities" :dir :teachpacks)
  
  ; Gets the matchpointtotal for a contestant as a rational
  (defun getmatchpointtotal (node)
    (str->rat (xml-gettext (xml-getnode node "MatchPointTotal"))))
  
  ; Insert function adapted from *site*
  (defun insert-sorted (a lst)
    (if (or (endp lst)
            (>= (getmatchpointtotal a)
                (getmatchpointtotal (car lst))))
        (cons a lst)
        (cons (car lst) (insert-sorted a (cdr lst)))))

  ; This function sorts the contestants by MatchPointTotal
  (defun sortcontestants (unsortedcontestants)
    (if (null unsortedcontestants)
        nil
        (let* ((contestant (car unsortedcontestants))
                (rest (cdr unsortedcontestants)))
          (insert-sorted contestant (sortcontestants rest)))))
  
  (defun sortmvranks (ranks mvs)
    (if (null ranks)
        mvs
        (let ((rank (car ranks))
              (rest (cdr ranks)))
          (mv-let (a b c)
                  mvs
                  (sortmvranks
                    rest
                    (mv
                     (if (equal (xml-getattribute rank "Strat") "A")
                         (xml-gettext rank)
                         a)
                     (if (equal (xml-getattribute rank "Strat") "B")
                         (xml-gettext rank)
                         b)
                     (if (equal (xml-getattribute rank "Strat") "C")
                         (xml-gettext rank)
                         c)))))))
  
  (defun serializedcontestants (contestants)
    (if (null contestants)
        ""
        (let* ((contestant (car contestants))
               (rest (cdr contestants))
               (pairno (xml-getattribute contestant "ID"))
               (players (xml-getnodes contestant "Player"))
               (player1 (xml-gettext (xml-getnode (car players) "Name")))
               (player2 (xml-gettext (xml-getnode (cadr players) "Name")))
               (strat (xml-getattribute contestant "Strat"))
               (sectionranks (xml-getnodes contestant "SectionRank"))
               (overallranks (xml-getnodes contestant "OverallRank"))
               (matchpoint (xml-gettext
                            (xml-getnode contestant "MatchpointTotal")))
               (percentage (xml-gettext
                            (xml-getnode contestant "Percentage")))
               (mpvalue (xml-gettext (xml-getnode contestant "Award")))
               (masterpoint (if (equal mpvalue "")
                                "&nbsp;"
                                mpvalue)))
          (concatenate 'string
                       "<tr>"
                       "<td>" pairno "</td>"
                       "<td>" player1 " - " player2 "</td>"
                       "<td>" strat "</td>"
                       (mv-let (a b c)
                               (sortmvranks sectionranks
                                            (mv "&nbsp;" "&nbsp;"
                                                "&nbsp;" ))
                         (concatenate 'string
                                      "<td>" a "</td>"
                                      "<td>" b "</td>"
                                      "<td>" c "</td>"))
                       (mv-let (a b c)
                         (sortmvranks overallranks
                                      (mv "&nbsp;" "&nbsp;" "&nbsp;" ))
                         (concatenate 'string
                                      "<td>" a "</td>"
                                      "<td>" b "</td>"
                                      "<td>" c "</td>"))
                       "<td>" matchpoint "</td>"
                       "<td>" percentage "</td>"
                       "<td>" masterpoint "</td>"
                       "</tr>"
                       (serializedcontestants rest)))))
  
  ; XXX rankingnodes is a bad misnomer.  rankingnodes should definitely
  ; *not* be a list of Rankings nodes.  At a minimum, we need the Section
  ; nodes, too.
  (defun serializedrankings (rankingnodes)
    (if (null rankingnodes)
        ""
        (let* ((ranking (car rankingnodes))
               (rest (cdr rankingnodes))
               (unsortedcontestants (xml-getnodes
                                      (xml-getnode ranking "Rankings")
                                      "Contestants"))
               (contestanthtml (serializedcontestants
                                 (sortcontestants unsortedcontestants))))
          (concatenate 'string
                       *rktablehead*
                       contestanthtml
                       *rktabletail*
                       (serializedrankings rest)))))

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

  (defun bfsfindnodes (nodes nodename)
    ; Build a dummy node that looks like xmlminidom, so we can act like
    ; nodes are rooted there as children, and we can just use xml-getnodes
    ; on it.
    (let* ((dummyroot (mv "dummyroot" nil nodes))
           (maybes (xml-getnodes dummyroot nodename)))
        (if maybes
            ; We found them
            maybes
            ; There were no nodes.  Look deeper.
            (bfsfindnodes (gluekids nodes) nodename))))
  
  ; sectionnodes should be a list of Section nodes
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

  ; nodes should be a list of Contestants nodes
  (defun findspecificcontestants (nodes id)
    (if nodes
      (let* ((current (car nodes)))
        (if (equal (xml-getattribute current "ID") id)
            current
            (findspecificcontestants (cdr nodes) id)))
      nil))

  ; For the two players in a Contestants element, delivers a string in the
  ; form "Alice - Bob".
  (defun getcontestants (section dir id rankingnodes)
    (let* ((section (findspecificsection (bfsfindnodes rankingnodes
                                                       "Section")
                                         section
                                         dir))
           (contestants (findspecificcontestants
                          (bfsfindnodes (list section) "Contestants")
                          id))
           (players (xml-getnodes contestants "Player")))
      (concatenate 'string
                   (xml-gettext (car players))
                   " - "
                   (xml-gettext (cadr players)))))

  (export Irankings))
