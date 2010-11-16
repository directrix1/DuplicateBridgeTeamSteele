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
)
