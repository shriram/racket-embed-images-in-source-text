#lang racket

(provide pack unpack)

(require 2htdp/image)
(require base64)
(require rackunit)

(define (pack i)
  (base64-encode
   (list->bytes
    (list* (image-width i)
           (image-height i)
           (apply append
                  (map (lambda (c)
                         (list (color-red c)
                               (color-green c)
                               (color-blue c)
                               (color-alpha c)))
                       (image->color-list i)))))))

(define (unpack ip)
  (let* ([bl (bytes->list (base64-decode ip))]
         [ln (first bl)]
         [wd (second bl)]
         [payload (rest (rest bl))]
         [converted (let loop ([rem payload])
                      (if (empty? rem)
                          empty
                          (let ([r (first rem)]
                                [g (second rem)]
                                [b (third rem)]
                                [alpha (fourth rem)])
                            (cons (color r g b alpha)
                                  (loop (rest (rest (rest (rest rem)))))))))])
    (color-list->bitmap converted ln wd)))

(module+ test

  (require "test-images.rkt")

  (define p0 (pack 3x3-rr))
  (define p1 (pack rr))
  (define p2 (pack gc))
  (define p3 (pack rr/gc))

  (check-equal? (unpack p0) 3x3-rr)
  (check-equal? (unpack p1) rr)
  (check-equal? (unpack p2) gc)
  )
