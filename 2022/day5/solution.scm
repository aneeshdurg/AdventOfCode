(define input (open-input-file "input.txt"))

; list functions

(define (get-nth ls n)
  (if (= n 0) (car ls) (get-nth (cdr ls) (- n 1))))

(define (reverse-list ls)
  (define (reverse-helper ls acc)
      (if (null? ls) acc (reverse-helper (cdr ls) (cons (car ls) acc))))
  (reverse-helper ls '()))

; parsing diagram functions

(define (parse-stack-line stacks line)
  (define (update-stack line stack)
    (if (string-prefix? "   " line)
      stack

      (cons (substring line 1 (- (string-length line) 1)) stack)))

  (for-each (lambda (x)
         (let (
               (start (* x 4))
               (stack (vector-ref stacks x)))
           (let ((end (+ start 3)))
             (vector-set!
               stacks x
               (update-stack (substring line start end) stack))
             )
           )
         )
       (iota (vector-length stacks) 0))
  ())

(define (build-stacks)
  (define line (read-line input))
  ; get the number of stacks from the first line
  (define n (/ (+ (string-length line) 1) 4))
  (define stacks (make-vector n '()))
  (parse-stack-line stacks line)

  (define (build-stacks-helper stacks)
    (let ((line (read-line input)))
      (if (not (eof-object? line))
          (begin
            (if (string-prefix? " 1" line)
              ()

              (begin
                (parse-stack-line stacks line)
                (build-stacks-helper stacks))))
          ())))

  (build-stacks-helper stacks)

  (define (reverse-stacks stacks)
    (for-each (lambda (x) (vector-set! stacks x (reverse-list (vector-ref stacks x))))
              (iota (vector-length stacks) 0))
  )
  (reverse-stacks stacks)

  stacks)

; executing moves

(define (split-by-space str)
  (define (split-by-space-helper str ls)
    (let ((len (string-length str)))
      (if (= len 0)
        ls

        (let ((next_spc (string-find-next-char str #\ )))
          (if (not next_spc)
            (cons str ls)

            (let (
                  (current_word (substring str 0 next_spc))
                  (next_str (substring str (+ next_spc 1) len)))
              (split-by-space-helper next_str (cons current_word ls))))))))
  (reverse-list (split-by-space-helper str '()))
)

(define (move-stacks stacks src dst amt)
  (let (
        (src-stack (vector-ref stacks src))
        (dst-stack (vector-ref stacks dst)))
    (if (= amt 0) ()
      (begin
        (vector-set! stacks dst (cons (car src-stack) dst-stack))
        (vector-set! stacks src (cdr src-stack))
        (move-stacks stacks src dst (- amt 1))))))

; part2
(define (move-stacks-9001 stacks src dst amt)
  (define (get-n stack n)
    (define (get-n-helper stack n ls)
      (if (= n 0) ls (get-n-helper (cdr stack) (- n 1) (cons (car stack) ls))))
    (get-n-helper stack n '()))

  (define (remove-n stack n)
    (if (= n 0) stack (remove-n (cdr stack) (- n 1))))

  (define (apply-ls stack ls)
    (if (null? ls) stack (apply-ls (cons (car ls) stack) (cdr ls))))

  (let (
        (src-stack (vector-ref stacks src))
        (dst-stack (vector-ref stacks dst)))
    (if (= amt 0) ()
      (begin
        (vector-set! stacks dst (apply-ls dst-stack (get-n src-stack amt)))
        (vector-set! stacks src (remove-n src-stack amt))))))

(define (execute-moves stacks exec)
  (let ((line (read-line input)))
    (if (not (eof-object? line))
      (let ((words (split-by-space line)))
        (let (; move [amt] from [src] to [dst]
              (amt (string->number (get-nth words 1)))
              (src (- (string->number (get-nth words 3)) 1)) ; 1-index to 0 index
              (dst (- (string->number (get-nth words 5)) 1)))
          (begin
            (exec stacks src dst amt)
            (execute-moves stacks exec)
          )))

      ())))

; main

(define stacks (build-stacks))
(read-line input)

; (execute-moves stacks move-stacks)
(execute-moves stacks move-stacks-9001)
(define stack-tops (map (lambda (x) (string-ref (car (vector-ref stacks x)) 0)) (iota (vector-length stacks) 0)))
(write-line (list->string stack-tops))
