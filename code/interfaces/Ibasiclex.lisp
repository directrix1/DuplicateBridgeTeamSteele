;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(interface Ibasiclex
  (sig split-at-delimiter (ds xs))
  (sig span (ps xs))
  (sig splitoff-prefix (ps xs))
  (sig splitoff-prefix-upr (ps xs))
  (sig splitoff-prefix-chr (tok-str xs))
  (sig split-on-token-gen (tok xs))
  (sig split-on-token-chr (tok xs))
  (sig split-on-token (tok xs))
)