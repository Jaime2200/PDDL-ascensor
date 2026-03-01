(define (domain ascensores)

  (:requirements :strips :typing)

  (:types
      elevator
      floor
      passenger
  )

  (:predicates
      (at-e ?e - elevator ?f - floor)
      (at-p ?p - passenger ?f - floor)
      (in ?p - passenger ?e - elevator)
      (serves ?e - elevator ?f - floor)
  )

  ;; =========================
  ;; MOVER ASCENSOR
  ;; =========================

  (:action move-elevator
    :parameters (?e - elevator ?from - floor ?to - floor)
    :precondition (and
        (at-e ?e ?from)
        (serves ?e ?from)
        (serves ?e ?to)
    )
    :effect (and
        (at-e ?e ?to)
        (not (at-e ?e ?from))
    )
  )

  ;; =========================
  ;; SUBIR PASAJERO
  ;; =========================

  (:action board
    :parameters (?p - passenger ?e - elevator ?f - floor)
    :precondition (and
        (at-p ?p ?f)
        (at-e ?e ?f)
    )
    :effect (and
        (in ?p ?e)
        (not (at-p ?p ?f))
    )
  )

  ;; =========================
  ;; BAJAR PASAJERO
  ;; =========================

  (:action debark
    :parameters (?p - passenger ?e - elevator ?f - floor)
    :precondition (and
        (in ?p ?e)
        (at-e ?e ?f)
    )
    :effect (and
        (at-p ?p ?f)
        (not (in ?p ?e))
    )
  )

)
