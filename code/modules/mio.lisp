;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "../interfaces/iio.lisp")
(require "../interfaces/iBoard.lisp")
(require "../interfaces/Ixmlminidom.lisp")

(module mio
  
  
  ;boards-no-trav(bridgeXML state) Given a duplicate bridge XML file, gets
  ;the following information from each board listed in the XML file and 
  ;creates an HTML page with this information formatted into tables:
  ;Board numbers, dealer, vulnerable, and hands for each direction
  (defun boards-no-trav(bridgeXML state)
    (defun boards-trav(bridgeXML state)
    (mv-let
     (status state)
     (string-list->file
      (string-append "boards-no-trav" ".htm")
      (list
       *htmlhead*
       (serializedboards 
        (xml-getnodes (xml-getnode (xml-getnode 
                      (xml-readnode bridgeXML)
                      "Game") "HandRecords") "Board") '0)
       *htmltail*
       )
      state)
     (if (null status)
         (mv 'ok state)
         (mv 'error state)))))
  
  
  ;boards-trav(bridgeXML state) Given a duplicate bridge XML file, gets the
  ;same information as boards-no-trav as well as the travelers information 
  ;for each board, which includes the total score and matchpoints for all 
  ;pairs at that board. Creates HTML page with this information with the 
  ;board information and travelers information in separate tables.
  (defun boards-trav(bridgeXML state)
    (mv-let
     (status state)
     (string-list->file
      (string-append "boards-trav" ".htm")
      (list
       *htmlhead*
       (serializedboards 
        (xml-getnodes (xml-getnode (xml-getnode 
                      (xml-readnode bridgeXML)
                      "Game") "HandRecords") "Board") '1)
       *htmltail*
       )
      state)
     (if (null status)
         (mv 'ok state)
         (mv 'error state))))
  
  
  ;rankings(bridgeXML state) Given a duplicate bridge XML file, creates a 
  ;rankings table in an HTML file including each pairs ranking and various 
  ;other stats such as matchpoint and percentage score.
  (defun rankings(bridgeXML state)bridgeXML)
  
  
  ;personal-score-cards(bridgeXML state) Given a duplicate bridge XML file,
  ;creates an HTML file containing personal score cards for each pair, which
  ;includes information about each match they played an against whom.
  (defun personal-score-cards (bridgeXML state)bridgeXML)

  ;main(bridgeXML state) Given a duplicate bridge XML file, extracts
  ;appropriate information to create four 
  ;HTML pages that link together: boards, boards with travelers, rankings,
  ;and personal score card webpages.
  (defun main (bridgeXML state)
    (mv-let (contents status state)
          (file->string (string-append bridgeXML ".xml") state)
          (if (null status)
              (mv-let
               (bt bnt rnk psc state)
               (boards-trav contents)
               (boards-no-trav contents)
               (rankings contents)
               (personal-score-cards contents)
               )
              (mv 'error state)))))
  
  (export iio))
