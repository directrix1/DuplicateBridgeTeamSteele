;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
#| Team Steele
   Software Engineering I
   Ixmlminidom

   Software that creates a document object model from XML input.
|#

(defconst *whitespace*
  (list (code-char 32)
        (code-char 10)
        (code-char 9)
        (code-char 11)
        (code-char 12)
        (code-char 13)
        (code-char 27)))
(defconst *endtagname* (cons #\> (cons #\/ *whitespace*)))
(defconst *endattrname* (cons #\= *whitespace*))
  
(interface Ixmlminidom
  (sig xml-unescape (escapedchars))
  (sig xml-readnodeproperties (xmlchars))
  (sig xml-skipdontcares (xmlchars))
  (sig xml-readnodes (xmlchars))
  (sig xml-readnode (xmlchars))
  (sig xml-getnodes (node nodename))
  (sig xml-getdeepnodes (node nodename))
  (sig xml-getnode (node nodename))
  (sig xml-getdeepnode (node nodename))
  (sig xml-getattribute (node attributename))
  (sig xml-gettext (node))
  (sig xml-isattribute (attribute))
  (sig xml-isattributelist (attributes))
  (sig xml-isnode (node))
  (sig xml-isnodelist (nodes))
  
  (con xml-unescape-returns-string
       (implies (standard-char-listp x)
                (stringp (xml-unescape x))))
  (con xml-skipdontcares-lessthanequal-xmlchars
       (imlies (and (standard-char-listp x)
                    (equal (length x) y))
               (<= (xml-skipdontcares x) y)))
  (con xml-getnodes-returns-nodes
       (implies (and
                 (stringp y)
                 (xml-isnode x))
                (xml-isnodelist (xml-getnodes y x))))
  (con xml-getnodes-returns-children
       (implies (and
                 (xml-isnode x)
                 (> (length (caddr x)) 0)
                 (equal node (car (caddr x)))
                 (equal y (car node))
                 (stringp y)
                 )
                (let ((res (xml-getnodes y x)))
                (and
                 (> (length res) 0)
                 (equal node (car res))))))
  (con xml-getdeepnodes-returns-nodes
       (implies (and
                 (stringp y)
                 (xml-isnode x))
                (xml-isnodelist (xml-getdeepnodes y x))))
  (con xml-getnode-returns-node-or-nil
       (implies (and
                 (xml-isnode x)
                 (stringp y))
                (let ((res (xml-getnode x y)))
                  (or
                   (null res)
                   (xml-isnode res)))))
  (con xml-getdeepnode-returns-node-or-nil
       (implies (and
                 (xml-isnode x)
                 (stringp y))
                (let ((res (xml-getdeepnode x y)))
                  (or
                   (null res)
                   (xml-isnode res)))))
  (con xml-getattribute-returns-string
       (implies (and
                 (xml-isnode x)
                 (stringp y))
                (stringp (xml-getattribute x y))))
  (con xml-gettext-returns-string
       (implies (xml-isnode x))
                (stringp (xml-gettext x)))
)
