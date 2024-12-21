#lang racket

(provide (rename-out [µ-read read]
                     [µ-read-syntax read-syntax]))

(require "image-pack-unpack.rkt")

(define read-µ
  (let* ([validate-and-unpack
          (lambda (v src)
            (if (bytes? v)
                (with-handlers ([exn:fail?
                                 (lambda (e) (error "unable to decode, check using `unpack`:" v))])
                  (unpack v))
                (error "µ must be followed by a byte string, not" v)))])
    (case-lambda
      [(ch in)
       (validate-and-unpack (read in) (object-name in))]
      [(ch in src line col pos)
       (validate-and-unpack (read in) src)])))

(define (make-µ-readtable)
  (make-readtable (current-readtable)
                  #\µ 'non-terminating-macro read-µ))

(define (µ-read in)
  (parameterize ([current-readtable (make-µ-readtable)])
    (read in)))

(define (µ-read-syntax src in)
  (parameterize ([current-readtable (make-µ-readtable)])
    (read-syntax src in)))
   