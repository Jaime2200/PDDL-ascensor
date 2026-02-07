; Se añaden nuevos pasajeros p5 y p6 + cambio de capacidad el ascensor fast pasa a 2 pasajeros de capacidad y el slowb1 pasa a 3 pasajeros.
(define (problem practica1-edificio-inst2)
  (:domain edificio-ascensores)

  (:objects
    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 - floor

    ; + nuevos pasajeros
    p0 p1 p2 p3 p4 p5 p6 - person

    fast slow-b1 slow-b2a slow-b2b slow-b3 - elevator

    ; Niveles de contador
    s0 s1 s2 s3 - count-level
  )

  (:init
    ; Ascensores
    (at-e fast     f0)
    (at-e slow-b1  f0)
    (at-e slow-b2a f6)
    (at-e slow-b2b f4)
    (at-e slow-b3  f8)

    ; Personas (incluyendo nuevas) - todas disponibles
    (at-p p0 f2)
    (available p0)
    (at-p p1 f4)
    (available p1)
    (at-p p2 f1)
    (available p2)
    (at-p p3 f8)
    (available p3)
    (at-p p4 f1)
    (available p4)
    (at-p p5 f7)
    (available p5)
    (at-p p6 f10)
    (available p6)

    ; Contador de pasajeros: todos comienzan en s0
    (count fast s0)
    (count slow-b1 s0)
    (count slow-b2a s0)
    (count slow-b2b s0)
    (count slow-b3 s0)

    ; Capacidad máxima (modificada)
    (max-capacity fast s2)      ; fast ahora puede llevar 2 pasajeros
    (max-capacity slow-b1 s3)   ; slow-b1 ahora puede llevar 3 pasajeros
    (max-capacity slow-b2a s2)
    (max-capacity slow-b2b s2)
    (max-capacity slow-b3 s2)

    ; Transiciones de contador
    (succ s0 s1)
    (succ s1 s2)
    (succ s2 s3)

    ; can-move (igual que base)
    (can-move fast f0 f2)  (can-move fast f2 f0)
    (can-move fast f2 f4)  (can-move fast f4 f2)
    (can-move fast f4 f6)  (can-move fast f6 f4)
    (can-move fast f6 f8)  (can-move fast f8 f6)
    (can-move fast f8 f10) (can-move fast f10 f8)
    (can-move fast f10 f12) (can-move fast f12 f10)

    (can-move slow-b1 f0 f1) (can-move slow-b1 f1 f0)
    (can-move slow-b1 f1 f2) (can-move slow-b1 f2 f1)
    (can-move slow-b1 f2 f3) (can-move slow-b1 f3 f2)
    (can-move slow-b1 f3 f4) (can-move slow-b1 f4 f3)

    (can-move slow-b2a f4 f5) (can-move slow-b2a f5 f4)
    (can-move slow-b2a f5 f6) (can-move slow-b2a f6 f5)
    (can-move slow-b2a f6 f7) (can-move slow-b2a f7 f6)
    (can-move slow-b2a f7 f8) (can-move slow-b2a f8 f7)

    (can-move slow-b2b f4 f5) (can-move slow-b2b f5 f4)
    (can-move slow-b2b f5 f6) (can-move slow-b2b f6 f5)
    (can-move slow-b2b f6 f7) (can-move slow-b2b f7 f6)
    (can-move slow-b2b f7 f8) (can-move slow-b2b f8 f7)

    (can-move slow-b3 f8 f9)   (can-move slow-b3 f9 f8)
    (can-move slow-b3 f9 f10)  (can-move slow-b3 f10 f9)
    (can-move slow-b3 f10 f11) (can-move slow-b3 f11 f10)
    (can-move slow-b3 f11 f12) (can-move slow-b3 f12 f11)
  )

  (:goal (and
    (at-p p0 f3)
    (at-p p1 f11)
    (at-p p2 f12)
    (at-p p3 f1)
    (at-p p4 f9)
    (at-p p5 f0)
    (at-p p6 f4)
  ))
)
