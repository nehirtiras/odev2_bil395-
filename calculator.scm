; Scheme Hesap Makinesi
(define (display-help)
  (display "\nScheme Calculator - Kullanım Kılavuzu\n")
  (display "----------------------------------\n")
  (display "Temel İşlemler: (+ 5 3), (* 10 2), (/ 20 4)\n")
  (display "Değişken Atama: (define x (+ 5 3))\n")
  (display "Çıkış: (exit)\n\n"))

(define (start-calculator)
  (display-help)
  (let loop ()
    (display "> ")
    (let ((input (read)))
    (cond
      ((eq? input 'exit) (display "Çıkılıyor...\n"))
      ((eq? input 'help) (display-help) (loop))
      (else
       (let ((result (eval input (interaction-environment))))
         (display "= ")
         (display result)
         (newline)
         (loop))))))

; Ana programı başlat
(display "Scheme Hesap Makinesi Başlatılıyor...\n")
(start-calculator)
