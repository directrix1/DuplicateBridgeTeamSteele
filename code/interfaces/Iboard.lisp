;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
#| Team Steele
   Software Engineering I
   iBoard

   Software that creates a document object model from XML input.
|#

 (defconst *menu*
    (concatenate 'string
     "<table border="1" cellspacing="20">"
     "<tr>"
     "<th><a href="boards-no-trav.htm">Boards Without Travelers</a></th>"
     "<th><a href="boards-trav.htm">Boards With Travelers</a></th>"
     "<th><a href="rnk.htm">Rankings</a></th>"
     "<th><a href="psc.htm">Personal Score Cards</a></th>"
     "</tr>"
     "</table>"
     ))
(defconst *div-open-1* "<div class=\"")
  (defconst *div-open-2* "\">")
  (defconst *div-close* "</div>\n")
  (defconst *br* "<br />\n")
  (defconst *htmlhead* 
    (concatenate 'string
      "<html><head><style>"
      "body {background-color: white; color: black;}"
      ".board {clear: both; position: relative; top: 0px; left: 0px;"
      "width: 45em; height: 30em; border: none;"
      "margin: 1em 1em 0em; background-color: #f8f8f8;}\n"
      ".boardnum {position: absolute; left: 0em; top: 0em;}\n"
      ".N {position: absolute; height: 10em; width: 15em; left: 15em;"
      "top: 0em; border: dashed 1px black; background-color: white;}\n"
      ".S {position: absolute; height: 10em; width: 15em; left: 15em;"
      "top: 20em; border: dashed 1px black; background-color: white;}\n"
      ".E {position: absolute; height: 10em; width: 15em; left: 30em;"
      "top: 10em; border: dashed 1px black; background-color: white;}\n"
      ".W {position: absolute; height: 10em; width: 15em; left: 0em;"
      "top: 10em; border: dashed 1px black; background-color: white;}\n"
      ".dealer {text-align: center; font-weight: bold; color: blue;}\n"
      ".vulnerable {text-align: center; font-weight: bold; color: red;}\n"
      ".results {clear: none; float: left; width: 45em;"
      "margin: 0em 1em 1em;}\n"
      ".results tr * {border: 1px solid black; margin: 1px;}\n"
      "</style></head><body>"))
  (defconst *htmltail* "</body></html>")
  (defconst *tablehead*
    (concatenate 'string
      "<table class=\"results\"><tr>"
      "<th colspan=\"2\">Pairs</th>"
      "<th colspan=\"2\">Total Score</th>"
      "<th colspan=\"2\">Match Points</th>"
      "</tr><tr>"
      "<th>NS</th>"
      "<th>EW</th>"
      "<th>NS</th>"
      "<th>EW</th>"
      "<th>NS</th>"
      "<th>EW</th>"
      "</tr>"
      ))
  (defconst *tabletail* "</table>\n")
  
  
(interface Iboard
  
  
  ;(include-book "basiclex")
  ;(include-book "xmlminidom")
  ;(include-book "stringutils")
  
  ; gethandcards (xmlnodes) → returns concatenated list of strings composed
  ; of the concatenation of suite symbol in HTML and card characters from
  ; xmlnodes where xmlnodes is a list of Suite xml nodes
  (sig serializedhandcards (xmlnodes))
  
  ; gethands (xmlnodes vulnerable dealer) → returns concatenated list of divs
  ; with class set to hand direction from xmlnodes, where xmlnodes is a list
  ; of xmlnode, of type hand, adds “vulnerable” and “dealer” divs inside the
  ; divs as necessary, and adds the cards to each hand
  (sig serializedhands (xmlnodes vulnerable dealer))
  
  ;grabs the results for one board separately from the board information
  ;without html serialization  
  (sig getseparateresults (xmlnodes boardnum ns1 ew1))
  
  ;getseparateresults (xmlnodes) → serializes xmlnodes to a
  ;sequence of HTML tables corresponding to the seperate results
  ;for each player
  (sig getallseparateresults (xmlnodes))
  
  ;getresults (xmlnodes prefix postfix) → returns a string consisting of
  ; the concatenation of prefix, results table rows from each “Result” node,
  ; and postfix
  (sig serializedresults (xmlnodes))
  (con serializedresults-nil=string-append-prefix-postfix-thm
    (implies (and (stringp prefix) (stringp postfix))
             (string-equal (serializedresults nil prefix postfix)
                           (string-append prefix postfix))))
  (con serializedresults-nil-returns-a-string-thm
       (implies (and (stringp prefix) (stringp postfix))
                (stringp (serializedresults nil prefix postfix))))
  
  ;getboards (xmlnodes) → returns appended “board” class divs with their
  ; “results” tables from the xmlnode “Board” and “results” formatted to
  ; be rendered with the deal and results as required by description
  (sig serializedboards (xmlnodes trav-flag))
)
  
  
