#lang racket

(provide [all-defined-out])

(require 2htdp/image)

(define 3x3-rr (rectangle 3 3 "solid" "red"))
(define rr (rectangle 30 20 "solid" "red"))
(define gc (circle 20 "solid" "green"))
(define rr/gc (overlay rr gc))
