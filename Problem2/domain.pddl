(define (domain problem2)
 (:requirements :strips :typing :adl)
 (:types
  location              ; * there are several zones, connected through the Maintenance Tunnel
  object                ; * any object, that can have a predicate location
  pod artifact spot agent - object ; * spots for capacity, agent for moving entities
  robot drone - agent   ; * robot and drone are specific types of agents
  )

 (:predicates
   (adjacent ?l1 ?l2 - location)       ; location ?l1 is adjacent to ?l2
   (low-pressure ?l - location)        ; location l has low pressure, so we need sealing mode
   (safe-destination ?l - location)    ; location l is the final safe destination
   (cooling-destination ?l - location) ; location l has cooling power
   (atl ?obj - object ?l - location)   ; object ?obj is at location ?l
   
   ;; CAPACITY PREDICATES (The Slot System)
   (belongs-to ?s - spot ?ag - agent)  ; links a specific spot to a specific agent
   (empty-spot ?s - spot)              ; is the spot available?
   (holding ?s - spot ?a - artifact)   ; which artifact is in this exact spot?

   ;; POD & ARTIFACT PREDICATES
   (free-pod ?p - pod)                 ; pod ?p is available
   (pod-carried-by ?p - pod ?r - robot); pod ?p is carried by robot ?r 
   (delicate ?a - artifact)            ; artifact ?a needs a pod to move (delicate item)
   (need-cooling ?a - artifact)        ; artifact ?a needs cooling
   (free-artifact ?a - artifact)       ; artifact ?a is available
   
   ;; ROBOT-SPECIFIC PREDICATES (Drones do not need these)
   (has-pod ?r - robot)                ; robot ?r has a pod
   (sealing-mode ?r - robot)           ; robot ?r is on sealing mode
   )

;; moves a robot, normally between two adjacent locations
 (:action move-normal
     :parameters (?r - robot ?from ?to - location)
     :precondition (and (adjacent ?from ?to)
                        (atl ?r ?from)
                        (not (low-pressure ?from)) (not (low-pressure ?to)) )
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

;; moves a drone (Drones fly, so they ignore low-pressure zones entirely)
 (:action move-drone
     :parameters (?d - drone ?from ?to - location)
     :precondition (and (adjacent ?from ?to) (atl ?d ?from))
     :effect (and (atl ?d ?to) 
                  (not (atl ?d ?from)) ))

;; loads a delicate artifact into a specific spot on a robot (Requires pod)
 (:action load-delicate-artifact
     :parameters (?a - artifact ?l - location ?r - robot ?s - spot)
     :precondition (and (atl ?r ?l) (atl ?a ?l) (free-artifact ?a)
                        (delicate ?a) (has-pod ?r)
                        (not (safe-destination ?l))
                        (belongs-to ?s ?r) (empty-spot ?s) )
     :effect (and (not (free-artifact ?a)) (not (atl ?a ?l)) 
                  (not (empty-spot ?s)) (holding ?s ?a) ))

;; loads a normal artifact into a specific spot on ANY agent (Robot or Drone)
 (:action load-normal-artifact
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :precondition (and (atl ?ag ?l) (atl ?a ?l) (free-artifact ?a)
                        (not (delicate ?a)) (not (safe-destination ?l))
                        (belongs-to ?s ?ag) (empty-spot ?s) )
     :effect (and (not (free-artifact ?a)) (not (atl ?a ?l)) 
                  (not (empty-spot ?s)) (holding ?s ?a) ))

;; unloads an artifact from a specific spot
 (:action unload-artifact
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :precondition (and (atl ?ag ?l) (safe-destination ?l) (not (need-cooling ?a))
                        (holding ?s ?a) (belongs-to ?s ?ag) )
     :effect (and (atl ?a ?l)
                  (empty-spot ?s) (not (holding ?s ?a)) ))

;; cool an artifact (NEW: Added the ?s - spot parameter!)
 (:action cooling
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :precondition (and (atl ?ag ?l) (cooling-destination ?l) (need-cooling ?a) 
                        (holding ?s ?a) (belongs-to ?s ?ag) )
     :effect (and (not (need-cooling ?a)) ))

;; loads a pod onto a robot (Pods don't use up artifact 'spots')
 (:action load-pod 
     :parameters (?p - pod ?l - location ?r - robot)
     :precondition (and (atl ?r ?l) (not (has-pod ?r))
                        (free-pod ?p) (atl ?p ?l) )
     :effect (and (has-pod ?r) (not (free-pod ?p)) 
                  (pod-carried-by ?p ?r) (not (atl ?p ?l)) ))

;; unloads a pod from a robot (Only if ALL its spots are empty)
 (:action unload-pod
     :parameters (?p - pod ?l - location ?r - robot)
     :precondition (and (atl ?r ?l) 
                        (pod-carried-by ?p ?r) 
                        (has-pod ?r)
                        
                        ;; Check every spot belonging to this robot
                        (forall (?s - spot)
                            (imply (belongs-to ?s ?r)
                                   (empty-spot ?s)))
                   )
     :effect (and (not (pod-carried-by ?p ?r)) 
                  (not (has-pod ?r))
                  (free-pod ?p) 
                  (atl ?p ?l) ))

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
