(define (problem ascensores-prob)
  (:domain ascensores)

  (:objects

      ;; Ascensores
      slow-b1 slow-b2a slow-b2b slow-b3 fast - elevator

      ;; Plantas
      f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 - floor

      ;; Pasajeros (ejemplo)
      p0 p1 p2 p3 p4 - passenger
  )

  (:init

      ;; Posición inicial ascensores
      (at-e slow-b1 f0)
      (at-e slow-b2a f4)
      (at-e slow-b2b f8)
      (at-e slow-b3 f8)
      (at-e fast f0)

      ;; =========================
      ;; SERVES
      ;; =========================

      ;; slow-b1 (0–4)
      (serves slow-b1 f0)
      (serves slow-b1 f1)
      (serves slow-b1 f2)
      (serves slow-b1 f3)
      (serves slow-b1 f4)

      ;; slow-b2a (4–8)
      (serves slow-b2a f4)
      (serves slow-b2a f5)
      (serves slow-b2a f6)
      (serves slow-b2a f7)
      (serves slow-b2a f8)

      ;; slow-b2b (4–8)
      (serves slow-b2b f4)
      (serves slow-b2b f5)
      (serves slow-b2b f6)
      (serves slow-b2b f7)
      (serves slow-b2b f8)

      ;; slow-b3 (8–12)
      (serves slow-b3 f8)
      (serves slow-b3 f9)
      (serves slow-b3 f10)
      (serves slow-b3 f11)
      (serves slow-b3 f12)

      ;; fast (pares)
      (serves fast f0)
      (serves fast f2)
      (serves fast f4)
      (serves fast f6)
      (serves fast f8)
      (serves fast f10)
      (serves fast f12)

      ;; =========================
      ;; Pasajeros iniciales
      ;; =========================

      (at-p p1 f0)
      (at-p p2 f3)

  )

  (:goal
    (and
      (at-p p0 f3)
      (at-p p1 f11)
      (at-p p2 f12)
      (at-p p3 f1)
      (at-p p4 f9)
    )
  )

)

