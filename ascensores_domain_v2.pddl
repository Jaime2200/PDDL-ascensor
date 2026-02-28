(define (domain edificio-ascensores-v2)
  (:requirements :strips :typing :adl :fluents)
  (:types
    floor person elevator
  )

  (:predicates
    (at-e ?e - elevator ?f - floor)
    (at-p ?p - person ?f - floor)
    (in ?p - person ?e - elevator)
    (available ?p - person)
    (can-move ?e - elevator ?from - floor ?to - floor)
  )

  (:functions
    (load ?e - elevator)
    (max-load ?e - elevator)
  )

  (:action move-elevator
    :parameters (?e - elevator ?from - floor ?to - floor)
    :precondition (and (at-e ?e ?from) (can-move ?e ?from ?to))
    :effect (and (at-e ?e ?to) (not (at-e ?e ?from)))
  )

  (:action board
    :parameters (?p - person ?e - elevator ?f - floor)
    :precondition (and
        (at-p ?p ?f)
        (available ?p)
        (at-e ?e ?f)
        (< (load ?e) (max-load ?e))
    )
    :effect (and
        (in ?p ?e)
        (not (available ?p))
        (not (at-p ?p ?f))
        (increase (load ?e) 1)
    )
  )

  (:action debark
    :parameters (?p - person ?e - elevator ?f - floor)
    :precondition (and
        (in ?p ?e)
        (at-e ?e ?f)
        (> (load ?e) 0)
    )
    :effect (and
        (at-p ?p ?f)
        (available ?p)
        (not (in ?p ?e))
        (decrease (load ?e) 1)
    )
  )
)
