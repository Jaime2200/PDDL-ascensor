(define (problem practica1-edificio)
  (:domain edificio-ascensores)

  (:objects
    ; Plantas
    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 - floor

    ; Personas
    p0 p1 p2 p3 p4 - person

    ; Ascensores
    fast           ; ascensor rápido (pares)
    slow-b1        ; lento bloque 1 (0-4)
    slow-b2a       ; lento 1 bloque 2 (4-8)
    slow-b2b       ; lento 2 bloque 2 (4-8)
    slow-b3        ; lento bloque 3 (8-12)
    - elevator

    ; Niveles de contador de pasajeros
    s0 s1 s2 s3 - count-level
  )

  (:init
    ; Posición inicial de ascensores
    (at-e fast    f0)
    (at-e slow-b1 f0)
    (at-e slow-b2a f4)
    (at-e slow-b2b f4)
    (at-e slow-b3 f8)

    ; Posición inicial de personas - todas disponibles
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

    ; Contador de pasajeros: todos comienzan en s0 (vacíos)
    (count fast s0)
    (count slow-b1 s0)
    (count slow-b2a s0)
    (count slow-b2b s0)
    (count slow-b3 s0)

    ; Capacidad máxima de cada ascensor
    (max-capacity fast s3)      ; fast puede llevar hasta 3 pasajeros
    (max-capacity slow-b1 s2)   ; los lentos pueden llevar hasta 2
    (max-capacity slow-b2a s2)
    (max-capacity slow-b2b s2)
    (max-capacity slow-b3 s2)

    ; Transiciones de contador (s0 -> s1 -> s2 -> s3)
    (succ s0 s1)
    (succ s1 s2)
    (succ s2 s3)

    ; ================================
    ;  MOVIMIENTOS PERMITIDOS (can-move)
    ; ================================

    ; --- Ascensor RÁPIDO: solo entre plantas pares ---
    (can-move fast f0 f2) (can-move fast f2 f0)
    (can-move fast f0 f4) (can-move fast f4 f0)
    (can-move fast f0 f6) (can-move fast f6 f0)
    (can-move fast f0 f8) (can-move fast f8 f0)
    (can-move fast f0 f10) (can-move fast f10 f0)
    (can-move fast f0 f12) (can-move fast f12 f0)

    (can-move fast f2 f4) (can-move fast f4 f2)
    (can-move fast f2 f6) (can-move fast f6 f2)
    (can-move fast f2 f8) (can-move fast f8 f2)
    (can-move fast f2 f10) (can-move fast f10 f2)
    (can-move fast f2 f12) (can-move fast f12 f2)

    (can-move fast f4 f6) (can-move fast f6 f4)
    (can-move fast f4 f8) (can-move fast f8 f4)
    (can-move fast f4 f10) (can-move fast f10 f4)
    (can-move fast f4 f12) (can-move fast f12 f4)

    (can-move fast f6 f8) (can-move fast f8 f6)
    (can-move fast f6 f10) (can-move fast f10 f6)
    (can-move fast f6 f12) (can-move fast f12 f6)

    (can-move fast f8 f10) (can-move fast f10 f8)
    (can-move fast f8 f12) (can-move fast f12 f8)

    (can-move fast f10 f12) (can-move fast f12 f10)

    ; --- LENTO Bloque 1 (0-4): movimientos entre contiguas ---
    (can-move slow-b1 f0 f1) (can-move slow-b1 f1 f0)
    (can-move slow-b1 f0 f2) (can-move slow-b1 f2 f0)
    (can-move slow-b1 f0 f3) (can-move slow-b1 f3 f0)
    (can-move slow-b1 f0 f4) (can-move slow-b1 f4 f0)

    (can-move slow-b1 f1 f2) (can-move slow-b1 f2 f1)
    (can-move slow-b1 f1 f3) (can-move slow-b1 f3 f1)
    (can-move slow-b1 f1 f4) (can-move slow-b1 f4 f1)

    (can-move slow-b1 f2 f3) (can-move slow-b1 f3 f2)
    (can-move slow-b1 f2 f4) (can-move slow-b1 f4 f2)

    (can-move slow-b1 f3 f4) (can-move slow-b1 f4 f3)

    ; --- LENTO Bloque 2 (4-8) - ascensor 1 ---
    (can-move slow-b2a f4 f5) (can-move slow-b2a f5 f4)
    (can-move slow-b2a f4 f6) (can-move slow-b2a f6 f4)
    (can-move slow-b2a f4 f7) (can-move slow-b2a f7 f4)
    (can-move slow-b2a f4 f8) (can-move slow-b2a f8 f4)

    (can-move slow-b2a f5 f6) (can-move slow-b2a f6 f5)
    (can-move slow-b2a f5 f7) (can-move slow-b2a f7 f5)
    (can-move slow-b2a f5 f8) (can-move slow-b2a f8 f5)

    (can-move slow-b2a f6 f7) (can-move slow-b2a f7 f6)
    (can-move slow-b2a f6 f8) (can-move slow-b2a f8 f6)

    (can-move slow-b2a f7 f8) (can-move slow-b2a f8 f7)

    ; --- LENTO Bloque 2 (4-8) - ascensor 2 ---
    (can-move slow-b2b f4 f5) (can-move slow-b2b f5 f4)
    (can-move slow-b2b f4 f6) (can-move slow-b2b f6 f4)
    (can-move slow-b2b f4 f7) (can-move slow-b2b f7 f4)
    (can-move slow-b2b f4 f8) (can-move slow-b2b f8 f4)

    (can-move slow-b2b f5 f6) (can-move slow-b2b f6 f5)
    (can-move slow-b2b f5 f7) (can-move slow-b2b f7 f5)
    (can-move slow-b2b f5 f8) (can-move slow-b2b f8 f5)

    (can-move slow-b2b f6 f7) (can-move slow-b2b f7 f6)
    (can-move slow-b2b f6 f8) (can-move slow-b2b f8 f6)

    (can-move slow-b2b f7 f8) (can-move slow-b2b f8 f7)

    ; --- LENTO Bloque 3 (8-12) ---
    (can-move slow-b3 f8 f9) (can-move slow-b3 f9 f8)
    (can-move slow-b3 f8 f10) (can-move slow-b3 f10 f8)
    (can-move slow-b3 f8 f11) (can-move slow-b3 f11 f8)
    (can-move slow-b3 f8 f12) (can-move slow-b3 f12 f8)

    (can-move slow-b3 f9 f10) (can-move slow-b3 f10 f9)
    (can-move slow-b3 f9 f11) (can-move slow-b3 f11 f9)
    (can-move slow-b3 f9 f12) (can-move slow-b3 f12 f9)

    (can-move slow-b3 f10 f11) (can-move slow-b3 f11 f10)
    (can-move slow-b3 f10 f12) (can-move slow-b3 f12 f10)

    (can-move slow-b3 f11 f12) (can-move slow-b3 f12 f11)
  )

  (:goal (and
    (at-p p0 f3)
    (at-p p1 f11)
    (at-p p2 f12)
    (at-p p3 f1)
    (at-p p4 f9)
  ))
)

