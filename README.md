# What

Racket enables you to embed images in the document source. The moment you do, however, the file becomes a different format. In particular, this format is no longer textual, which means it doesn't work well with tools like `grep`, git, etc.

A natural solution is to store images outside the file. This is a perfectly good solution, but *sometimes* it's useful to have a single self-contained file with all of its "assets".

This library provides a "reader extension" to address this problem. Using `#reader "image-reader.rkt" …` makes the subsequent expression (in `…`) use this special reader extension. The reader extension is invoked using the `µ` reader key (on a Mac, you can easily type this as Command-m). The `µ` must be followed by a uuencoded byte-string following a certain format. The reader then automatically turns this into an image value.

The best way to understand the difference is to look at these two files side-by-side:

* [examples](examples.rkt)
* [examples as images](examples-as-images)

The latter (which you can't view outside DrRacket) has embedded images visible *as images* in DrRacket. The former has the same images embedded using this reader. The images are not meaningful without rendering, but *everything else* in the file is readable by all our usual tools (including outside DrRacket). It's worth noting that an embedded image is a (byte-)string, and hence can be skipped/copied/etc. using standard s-expression editor operations.

# How

There are two parts to using this library: embedding images and using them.

* To use them, follow the examples in [the examples file](examples.rkt).

* To embed them, you could try to understand the format specified below. However, it would be a lot simpler to run

```
(require "image-pack-unpack.rkt")
(pack <image>)
```

This will produce a byte-string. This is what you paste into your source file. For instance, you might have

```
(require 2htdp/image)
(require "image-pack-unpack.rkt")
(pack (circle 1 "solid" "red"))
```
This will produce the following byte-string:
```
#"AgL/AADF/wAAw/8AAMP/AADC"
```
You only need the above program to produce the byte string.

You can then embed this byte string in a source program (which is presumably a completely different module), as follows:

```
#reader "image-reader.rkt" µ#"AgL/AADF/wAAw/8AAMP/AADC"
```
(Note the `µ`!) When you run this, you will get a tiny red dot!

Of course, in the example above, we generated the little dot image programmatically; at that point we could just use the program instead of embedding its output (unless it would take a very long time to run…). 

Consider instead [this file](packing-example.rkt)–which, again, you *can't* usefully view except inside DrRacket, that being the point of this library—which runs `pack` on an embedded instance of the Racket "running man" image to produce a byte-string. This is how we obtained the byte-string to embedded in [the examples file](examples.rkt). Once we've embedded the byte-string, we no longer need the original program (except for future modifications): all the information is in the byte-string.

# Errors

The error-handling code is crap. I ran out of time to understand all the ins-and-outs of `read` vs `read-syntax` errors and how to make everything pretty. People are welcome to fix that (and to correspondingly improve the tests).

# Extensions

This [packer](image-pack-unpack.rkt) produces single-line output. This has the virtue of not producing a large block of text, at the cost of making extremely wide lines. This was an intentional decision, but it could cause problems in some contexts. It would be nice to extend the packer to take flags that let the user determine whether they want wide or tall packed text.

There is nothing *image*-specific about this. It could embed *any* binary datum. This particular pack/unpack duo is image-centric: images have a height and width, and this is recorded in the byte-string.
