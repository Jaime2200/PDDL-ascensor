; Solo cambio de situación inicial y objetivo
(define (problem practica1-edificio-inst1)
  (:domain edificio-ascensores)

  (:objects
    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 - floor
    p0 p1 p2 p3 p4 - person
    fast slow-b1 slow-b2a slow-b2b slow-b3 - elevator
    s-fast-1 s-fast-2 s-fast-3
    s-b1-1 s-b1-2
    s-b2a-1 s-b2a-2
    s-b2b-1 s-b2b-2
    s-b3-1 s-b3-2 - slot
  )

  (:init
    ; Ascensores (cambio posiciones)
    (at-e fast     f6)
    (at-e slow-b1  f1)
    (at-e slow-b2a f8)
    (at-e slow-b2b f4)
    (at-e slow-b3  f10)

    ; Personas (cambio orígenes)
    (at-p p0 f0)
    (at-p p1 f7)
    (at-p p2 f4)
    (at-p p3 f11)
    (at-p p4 f2)

    ; Slots -> ascensor
    (slot-of s-fast-1 fast) (slot-of s-fast-2 fast) (slot-of s-fast-3 fast)
    (slot-of s-b1-1 slow-b1) (slot-of s-b1-2 slow-b1)
    (slot-of s-b2a-1 slow-b2a) (slot-of s-b2a-2 slow-b2a)
    (slot-of s-b2b-1 slow-b2b) (slot-of s-b2b-2 slow-b2b)
    (slot-of s-b3-1 slow-b3) (slot-of s-b3-2 slow-b3)

    ; Todos libres
    (free s-fast-1) (free s-fast-2) (free s-fast-3)
    (free s-b1-1) (free s-b1-2)
    (free s-b2a-1) (free s-b2a-2)
    (free s-b2b-1) (free s-b2b-2)
    (free s-b3-1) (free s-b3-2)

    ; ========= can-move (igual que tu problema base) =========
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
    (at-p p0 f4)
    (at-p p1 f2)
    (at-p p2 f9)
    (at-p p3 f8)
    (at-p p4 f12)
  ))
)
