(define (problem practica1-edificio-inst3)
  (:domain edificio-ascensores-v2)

  (:objects
    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 - floor
    p0 p1 p2 p3 p4 - person
    fast fast-3 slow-b1 slow-b2a slow-b2b slow-b2c slow-b3 - elevator
  )

  (:init
    (at-e fast f0)
    (at-e fast-3 f3)
    (at-e slow-b1 f0)
    (at-e slow-b2a f4)
    (at-e slow-b2b f8)
    (at-e slow-b2c f6)
    (at-e slow-b3 f12)

    ; Personas
    (at-p p0 f2) (available p0)
    (at-p p1 f4) (available p1)
    (at-p p2 f1) (available p2)
    (at-p p3 f8) (available p3)
    (at-p p4 f11) (available p4)

    ; Cargas iniciales
    (= (load fast) 0)
    (= (load fast-3) 0)
    (= (load slow-b1) 0)
    (= (load slow-b2a) 0)
    (= (load slow-b2b) 0)
    (= (load slow-b2c) 0)
    (= (load slow-b3) 0)

    ; Capacidades
    (= (max-load fast) 3)
    (= (max-load fast-3) 2)
    (= (max-load slow-b1) 2)
    (= (max-load slow-b2a) 2)
    (= (max-load slow-b2b) 2)
    (= (max-load slow-b2c) 1)
    (= (max-load slow-b3) 2)

    ; Movimientos permitidos
    (can-move fast f0 f2)  (can-move fast f2 f0)
    (can-move fast f2 f4)  (can-move fast f4 f2)
    (can-move fast f4 f6)  (can-move fast f6 f4)
    (can-move fast f6 f8)  (can-move fast f8 f6)
    (can-move fast f8 f10) (can-move fast f10 f8)
    (can-move fast f10 f12) (can-move fast f12 f10)

    ; NUEVO rápido: fast-3 solo múltiplos de 3 (0-3-6-9-12)
    (can-move fast-3 f0 f3)  (can-move fast-3 f3 f0)
    (can-move fast-3 f3 f6)  (can-move fast-3 f6 f3)
    (can-move fast-3 f6 f9)  (can-move fast-3 f9 f6)
    (can-move fast-3 f9 f12) (can-move fast-3 f12 f9)

    ; Lento bloque 1 (0-4)
    (can-move slow-b1 f0 f1) (can-move slow-b1 f1 f0)
    (can-move slow-b1 f1 f2) (can-move slow-b1 f2 f1)
    (can-move slow-b1 f2 f3) (can-move slow-b1 f3 f2)
    (can-move slow-b1 f3 f4) (can-move slow-b1 f4 f3)

    ; Lento bloque 2 (4-8) - b2a
    (can-move slow-b2a f4 f5) (can-move slow-b2a f5 f4)
    (can-move slow-b2a f5 f6) (can-move slow-b2a f6 f5)
    (can-move slow-b2a f6 f7) (can-move slow-b2a f7 f6)
    (can-move slow-b2a f7 f8) (can-move slow-b2a f8 f7)

    ; Lento bloque 2 (4-8) - b2b
    (can-move slow-b2b f4 f5) (can-move slow-b2b f5 f4)
    (can-move slow-b2b f5 f6) (can-move slow-b2b f6 f5)
    (can-move slow-b2b f6 f7) (can-move slow-b2b f7 f6)
    (can-move slow-b2b f7 f8) (can-move slow-b2b f8 f7)

    ; NUEVO lento bloque 2 (4-8) - b2c (contiguas, dentro del bloque)
    (can-move slow-b2c f4 f5) (can-move slow-b2c f5 f4)
    (can-move slow-b2c f5 f6) (can-move slow-b2c f6 f5)
    (can-move slow-b2c f6 f7) (can-move slow-b2c f7 f6)
    (can-move slow-b2c f7 f8) (can-move slow-b2c f8 f7)

    ; Lento bloque 3 (8-12)
    (can-move slow-b3 f8 f9)   (can-move slow-b3 f9 f8)
    (can-move slow-b3 f9 f10)  (can-move slow-b3 f10 f9)
    (can-move slow-b3 f10 f11) (can-move slow-b3 f11 f10)
    (can-move slow-b3 f11 f12) (can-move slow-b3 f12 f11)
  )

  (:goal (and
    (at-p p0 f9)
    (at-p p1 f12)
    (at-p p2 f4)
    (at-p p3 f1)
    (at-p p4 f0)
  ))
)
