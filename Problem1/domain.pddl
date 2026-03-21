(define (domain problem1)
 (:requirements :strips :typing )
 (:types
  location              ; * there are several zones, connected through the Maintenance Tunnel
  object                ; * any object, that can have a predicate location
  pod - object          ; * two antivibration pods, for delicate items
  robot - object        ; * a single robot that can move and carry at most one artifact
  artifact - object     ; * objects to be moved, different initial locations, destinations and type
  )

 (:predicates
   (adjacent ?l1 ?l2 - location)       ; location ?l1 is adjacent ot ?l2
   (low-pressure ?l - location)        ; location l has low pressure, so we need sealing mode
   (safe-destination ?l - location)    ; location l is the final safe destination
   (cooling-destination ?l - location) ; location l has cooling power
   (atl ?obj - object ?l - location)   ; object ?obj is at location ?l
   (free-pod ?p - pod)                 ; pod ?p is available
   (pod-carried-by ?p - pod ?r - robot); pod ?p is carried by robot ?r 
   (delicate ?a - artifact)            ; artifact ?a needs a pod to move (delicate item)
   (need-cooling ?a - artifact)        ; artifact ?a needs cooling (alpha artifacts)
   (free-artifact ?a - artifact)       ; artifact ?a is available
   (artifact-carried-by ?a - artifact ?r - robot) ; artifact ?a is carried by robot ?r 
   (has-pod ?r - robot)                ; robot ?r has a pod
   (sealing-mode ?r - robot)           ; robot ?r is on sealing mode
   (carrying ?r - robot)               ; robot ?r is carrying an artifact
   (carrying-artifact ?r - robot ?a - artifact)               ; robot ?r is carrying the ?a artifact

   )

;; moves a robot, normally between two adjacent locations
 (:action move-normal
     :parameters (?r - robot ?from ?to - location)
     :precondition (and (adjacent ?from ?to)
                        (atl ?r ?from)
                        (not (low-pressure ?from)) (not (low-pressure ?to))  )
     :effect (and (atl ?r ?to) 
                (not (atl ?r ?from)) ))

;; moves a robot, sealing between two adjacent locations
(:action move-sealing
     :parameters (?r - robot ?from ?to - location)
     :precondition (and (adjacent ?from ?to)
                        (atl ?r ?from)
                        (sealing-mode ?r))
     :effect (and (atl ?r ?to) 
                (not (atl ?r ?from)) ))

;; loads a delicate artifact on an empty robot
 (:action load-delicate-artifact
     :parameters (?a - artifact ?l - location ?r - robot)
     :precondition (and (atl ?r ?l) (not (carrying ?r))
                        (atl ?a ?l) (free-artifact ?a)
                        (delicate ?a) (has-pod ?r)
                        (not (safe-destination ?l)) )
     :effect (and (carrying-artifact ?r ?a) (carrying ?r) 
                (not (free-artifact ?a)) (artifact-carried-by ?a ?r) 
                (not (atl ?a ?l))  ))

;; loads a normal artifact on an empty robot
 (:action load-normal-artifact
     :parameters (?a - artifact ?l - location ?r - robot)
     :precondition (and (atl ?r ?l) (not (carrying ?r))
                        (atl ?a ?l) (free-artifact ?a)
                        (not (delicate ?a)) (not (safe-destination ?l)) )
     :effect (and (carrying-artifact ?r ?a) (carrying ?r)
                (not (free-artifact ?a)) (artifact-carried-by ?a ?r) 
                (not (atl ?a ?l)) ))


;; unloads an artifact on a location, and the artifact... well it's not free anymore.
 (:action unload-artifact
     :parameters (?a - artifact ?l - location ?r - robot)
     :precondition (and (carrying-artifact ?r ?a) (atl ?r ?l)
                        (safe-destination ?l) (not (need-cooling ?a)) )
     :effect (and (not (carrying ?r)) (not (carrying-artifact ?r ?a)) 
                (atl ?a ?l) (not (artifact-carried-by ?a ?r)) ))

;; cool an artifact
 (:action cooling
     :parameters (?a - artifact ?l - location ?r - robot)
     :precondition (and (carrying-artifact ?r ?a) (atl ?r ?l)
                        (cooling-destination ?l) (need-cooling ?a) )
     :effect (and (not (need-cooling ?a)) ))

;; loads a pod on an empty robot
 (:action load-pod 
     :parameters (?p - pod ?l - location ?r - robot)
     :precondition (and (atl ?r ?l) (not (has-pod ?r))
                        (free-pod ?p) (atl ?p ?l) (not (carrying ?r)) )
     :effect (and (has-pod ?r) (not (free-pod ?p)) 
                (pod-carried-by ?p ?r) (not (atl ?p ?l)) ))

;; unloads a pod from a robot
 (:action unload-pod
     :parameters (?p - pod ?l - location ?r - robot)
     :precondition (and (atl ?r ?l) (not (carrying ?r))
                        (pod-carried-by ?p ?r) (has-pod ?r) )
     :effect (and (not(pod-carried-by ?p ?r)) (not(has-pod ?r))
                (free-pod ?p) (atl ?p ?l) ))

;; Turns ON the robot's sealing mode so it can survive low pressure
 (:action enable-sealing
     :parameters (?r - robot)
     :precondition (not (sealing-mode ?r))
     :effect (sealing-mode ?r))

 ;; Turns OFF the robot's sealing mode
 (:action disable-sealing
     :parameters (?r - robot)
     :precondition (sealing-mode ?r)
     :effect (not (sealing-mode ?r)))

 )
