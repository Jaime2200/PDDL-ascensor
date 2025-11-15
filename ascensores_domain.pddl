(define (domain edificio-ascensores)
  (:requirements :strips :typing)
  (:types
    floor person elevator slot
  )

  (:predicates
    ; Ubicaciones
    (at-e ?e - elevator ?f - floor)          ; ascensor e en planta f
    (at-p ?p - person ?f - floor)            ; persona p en planta f
    (in    ?p - person ?e - elevator)        ; persona p dentro de ascensor e

    ; Movimiento permitido
    (can-move ?e - elevator ?from - floor ?to - floor)

    ; Capacidad (usamos ahora occupied y free como complementarios)
    (slot-of  ?s - slot ?e - elevator)
    (occupied ?s - slot)
    (free     ?s - slot)                     ; slot libre (nuevo predicado)
    (assigned ?p - person ?s - slot)
  )

  ; ========================
  ; MOVER ASCENSOR
  ; ========================
  (:action move-elevator
    :parameters (?e - elevator ?from - floor ?to - floor)
    :precondition (and
      (at-e ?e ?from)
      (can-move ?e ?from ?to)
    )
    :effect (and
      (at-e ?e ?to)
      (not (at-e ?e ?from))
    )
  )

  ; ========================
  ; SUBIR PASAJERO (BOARD)
  ; ========================
  (:action board
    :parameters (?p - person ?e - elevator ?f - floor ?s - slot)
    :precondition (and
      (at-p ?p ?f)
      (at-e ?e ?f)
      (slot-of ?s ?e)
      (free ?s)                     ; antes se usaba (not (occupied ?s))
    )
    :effect (and
      (in ?p ?e)
      (occupied ?s)
      (assigned ?p ?s)
      (not (at-p ?p ?f))
      (not (free ?s))               ; cuando se ocupa, deja de estar libre
    )
  )

  ; ========================
  ; BAJAR PASAJERO (DEBARK)
  ; ========================
  (:action debark
    :parameters (?p - person ?e - elevator ?f - floor ?s - slot)
    :precondition (and
      (in ?p ?e)
      (at-e ?e ?f)
      (slot-of ?s ?e)
      (assigned ?p ?s)
      (occupied ?s)
    )
    :effect (and
      (at-p ?p ?f)
      (free ?s)                    ; vuelve a quedar libre
      (not (in ?p ?e))
      (not (occupied ?s))
      (not (assigned ?p ?s))
    )
  )
)
