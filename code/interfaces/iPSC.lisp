(interface iPSC
  (sig getPSC(xmlnodes))
  (con getPSC-con1
       (implies ()
                ()))
  (sig getNameForID(pairid data))
  (con getNameForID-con1
       (implies ()
                ()))
  (sig getBoardsForPair(pairid results))
  (con getBoardsForPair-con1
       (implies ()
                ())))
