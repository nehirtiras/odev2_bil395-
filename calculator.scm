(import (scheme base)
        (scheme write)
        (scheme read)
        (scheme process-context))

(define *variables* (make-eq-hashtable))

(define (display-help)
  (display "\n***Scheme Calculator***")

(define (eval-expr expr)
  (cond
    ((number? expr) expr)
    ((symbol? expr) 
     (let ((val (hashtable-ref *variables* expr #f)))
       (if val val (error "Tanımsız değişken:" expr))))
    ((pair? expr)
     (apply (eval (car expr) (interaction-environment))
            (map eval-expr (cdr expr))))
    (else (error "Geçersiz ifade:" expr))))

(define (handle-input input)
  (guard (ex ((error-object? ex)
              (display "Hata: ")
              (display (error-object-message ex))
              (newline)))
    (let ((result (eval-expr input)))
      (when (not (eq? input 'exit))
        (display "= ")
        (write result)
        (newline)
      result)))

(define (main)
  (display "Scheme Hesap Makinesi v2.0\n")
  (display-help)
  (let loop ()
    (display "> ")
    (let ((input (read)))
      (cond
        ((eof-object? input) (display "exit\n"))
        ((eq? input 'exit) (display "exit\n"))
        ((eq? input 'help) (display-help) (loop))
        (else
         (handle-input input)
         (loop))))))

(main)
