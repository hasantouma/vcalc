(lang dune 2.9)
;          ^^^
; When changing the version, don't forget to regenerate *.opam files
; by running [dune build].

(name vcalc)

(generate_opam_files true)

(maintainers "Hasan Touma")
(authors "Hasan Touma")
(source (github hasantouma/vcalc))

(package
  (name vcalc)
  (synopsis "Visual Calculator")
  (depends
    dune
    (ocaml
      (>= 4.02.3))
    ocamlgraph
    ounit2))
