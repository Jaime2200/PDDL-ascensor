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

    ; Slots de capacidad (3 para el rápido, 2 para cada lento)
    s-fast-1 s-fast-2 s-fast-3
    s-b1-1 s-b1-2
    s-b2a-1 s-b2a-2
    s-b2b-1 s-b2b-2
    s-b3-1 s-b3-2
    - slot
  )

  (:init
    ; Posición inicial de ascensores
    (at-e fast    f0)
    (at-e slow-b1 f0)
    (at-e slow-b2a f4)
    (at-e slow-b2b f4)
    (at-e slow-b3 f8)

    ; Posición inicial de personas
    (at-p p0 f2)
    (at-p p1 f4)
    (at-p p2 f1)
    (at-p p3 f8)
    (at-p p4 f1)

    ; Slots -> ascensor (capacidades)
    (slot-of s-fast-1 fast)
    (slot-of s-fast-2 fast)
    (slot-of s-fast-3 fast)

    (slot-of s-b1-1 slow-b1)
    (slot-of s-b1-2 slow-b1)

    (slot-of s-b2a-1 slow-b2a)
    (slot-of s-b2a-2 slow-b2a)

    (slot-of s-b2b-1 slow-b2b)
    (slot-of s-b2b-2 slow-b2b)

    (slot-of s-b3-1 slow-b3)
    (slot-of s-b3-2 slow-b3)

    ; ---- Todos los slots empiezan LIBRES (para usar (free ...) en el dominio en vez de condiciones negativas) ----
    (free s-fast-1)
    (free s-fast-2)
    (free s-fast-3)
    (free s-b1-1)
    (free s-b1-2)
    (free s-b2a-1)
    (free s-b2a-2)
    (free s-b2b-1)
    (free s-b2b-2)
    (free s-b3-1)
    (free s-b3-2)

    ; ================================
    ;  MOVIMIENTOS PERMITIDOS (can-move)
    ; ================================

    ; --- Ascensor RÁPIDO: solo entre plantas pares ---
    (can-move fast f0 f2)  (can-move fast f2 f0)
    (can-move fast f2 f4)  (can-move fast f4 f2)
    (can-move fast f4 f6)  (can-move fast f6 f4)
    (can-move fast f6 f8)  (can-move fast f8 f6)
    (can-move fast f8 f10) (can-move fast f10 f8)
    (can-move fast f10 f12) (can-move fast f12 f10)

    ; --- LENTO Bloque 1 (0-4): movimientos entre contiguas ---
    (can-move slow-b1 f0 f1) (can-move slow-b1 f1 f0)
    (can-move slow-b1 f1 f2) (can-move slow-b1 f2 f1)
    (can-move slow-b1 f2 f3) (can-move slow-b1 f3 f2)
    (can-move slow-b1 f3 f4) (can-move slow-b1 f4 f3)

    ; --- LENTO Bloque 2 (4-8) - ascensor 1 ---
    (can-move slow-b2a f4 f5) (can-move slow-b2a f5 f4)
    (can-move slow-b2a f5 f6) (can-move slow-b2a f6 f5)
    (can-move slow-b2a f6 f7) (can-move slow-b2a f7 f6)
    (can-move slow-b2a f7 f8) (can-move slow-b2a f8 f7)

    ; --- LENTO Bloque 2 (4-8) - ascensor 2 ---
    (can-move slow-b2b f4 f5) (can-move slow-b2b f5 f4)
    (can-move slow-b2b f5 f6) (can-move slow-b2b f6 f5)
    (can-move slow-b2b f6 f7) (can-move slow-b2b f7 f6)
    (can-move slow-b2b f7 f8) (can-move slow-b2b f8 f7)

    ; --- LENTO Bloque 3 (8-12) ---
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
  ))
)

