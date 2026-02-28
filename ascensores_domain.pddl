(define (domain edificio-ascensores)
  (:requirements :strips :typing)
  (:types
    floor person elevator count-level
  )

  (:predicates
    ; Ubicaciones
    (at-e ?e - elevator ?f - floor)          ; ascensor e en planta f
    (at-p ?p - person ?f - floor)            ; persona p en planta f
    (in    ?p - person ?e - elevator)        ; persona p dentro de ascensor e

    ; Disponibilidad
    (available ?p - person)                  ; persona p está disponible (no en ascensor)

    ; Movimiento permitido
    (can-move ?e - elevator ?from - floor ?to - floor)

    ; Capacidad: contador de pasajeros por ascensor
    (count ?e - elevator ?c - count-level)   ; número actual de pasajeros en ascensor e
    (max-capacity ?e - elevator ?c - count-level) ; capacidad máxima del ascensor e

    ; Transiciones de contador
    (succ ?c1 ?c2 - count-level)             ; c2 es el siguiente nivel después de c1
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
    :parameters (?p - person ?e - elevator ?f - floor ?c1 ?c2 - count-level)
    :precondition (and
      (at-p ?p ?f)
      (available ?p)
      (at-e ?e ?f)
      (count ?e ?c1)           ; el ascensor tiene nivel c1 pasajeros
      (succ ?c1 ?c2)           ; c2 es el siguiente a c1 (y no es igual a capacidad máxima)
    )
    :effect (and
      (in ?p ?e)
      (not (available ?p))
      (not (at-p ?p ?f))
      (not (count ?e ?c1))
      (count ?e ?c2)           ; nivel aumenta de c1 a c2
    )
  )

  ; ========================
  ; BAJAR PASAJERO (DEBARK)
  ; ========================
  
  (:action debark
    :parameters (?p - person ?e - elevator ?f - floor ?c1 ?c2 - count-level)
    :precondition (and
      (in ?p ?e)
      (at-e ?e ?f)
      (count ?e ?c1)           ; el ascensor tiene nivel c1 pasajeros
      (succ ?c2 ?c1)           ; c1 es el siguiente a c2 (subiendo un nivel de pasajeros)
    )
    :effect (and
      (at-p ?p ?f)
      (available ?p)
      (not (in ?p ?e))
      (not (count ?e ?c1))
      (count ?e ?c2)           ; nivel disminuye de c1 a c2
    )
  )
)
