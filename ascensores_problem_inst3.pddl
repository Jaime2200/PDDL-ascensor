;Se añaden nuevos ASCENSORES fast-3 de capacidad de 3 y otro de capacidad de 1.
(define (problem practica1-edificio-inst3)
  (:domain edificio-ascensores)

  (:objects
    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 - floor

    p0 p1 p2 p3 p4 - person

    ; + nuevos ascensores
    fast fast-3 slow-b1 slow-b2a slow-b2b slow-b2c slow-b3 - elevator

    ; Niveles de contador
    s0 s1 s2 s3 - count-level
  )

  (:init
    ; Ascensores (posiciones iniciales)
    (at-e fast     f0)
    (at-e fast-3   f3)
    (at-e slow-b1  f0)
    (at-e slow-b2a f4)
    (at-e slow-b2b f8)
    (at-e slow-b2c f6)
    (at-e slow-b3  f12)

    ; Personas (origen) - todas disponibles
    (at-p p0 f2)
    (available p0)
    (at-p p1 f4)
    (available p1)
    (at-p p2 f1)
    (available p2)
    (at-p p3 f8)
    (available p3)
    (at-p p4 f11)
    (available p4)

    ; Contador de pasajeros: todos comienzan en s0
    (count fast s0)
    (count fast-3 s0)
    (count slow-b1 s0)
    (count slow-b2a s0)
    (count slow-b2b s0)
    (count slow-b2c s0)
    (count slow-b3 s0)

    ; Capacidad máxima de cada ascensor
    (max-capacity fast s3)      ; fast puede llevar 3 pasajeros
    (max-capacity fast-3 s2)    ; fast-3 puede llevar 2 pasajeros
    (max-capacity slow-b1 s2)   ; los lentos pueden llevar 2
    (max-capacity slow-b2a s2)
    (max-capacity slow-b2b s2)
    (max-capacity slow-b2c s1)  ; slow-b2c solo 1 pasajero
    (max-capacity slow-b3 s2)

    ; Transiciones de contador
    (succ s0 s1)
    (succ s1 s2)
    (succ s2 s3)

    ; ==============================
    ; can-move
    ; ==============================

    ; fast (pares) igual que base
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
