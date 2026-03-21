(define (domain problem4)
 (:requirements :strips :typing :durative-actions)
 (:types
  location pod artifact spot agent - object
  robot drone - agent
  )

 (:predicates
   (adjacent ?l1 ?l2 - location)
   (low_pressure ?l - location)
   (normal_pressure ?l - location)
   (safe_destination ?l - location)
   (unsafe_destination ?l - location)
   (cooling_destination ?l - location)
   (atl_ag ?ag - agent ?l - location)
   (atl_art ?a - artifact ?l - location)
   (atl_pod ?p - pod ?l - location)
   (belongs_to ?s - spot ?ag - agent)
   (empty_spot ?s - spot)
   (holding ?s - spot ?a - artifact)
   (free_pod ?p - pod)
   (pod_carried_by ?p - pod ?r - robot)
   (delicate ?a - artifact)
   (normal_artifact ?a - artifact)
   (need_cooling ?a - artifact)
   (cooled ?a - artifact)
   (free_artifact ?a - artifact)
   (has_pod ?r - robot)
   (no_pod ?r - robot)
   (sealing_mode ?r - robot)
   (sealing_off ?r - robot)
   (available ?ag - agent)
   )

 (:durative-action move_normal
     :parameters (?r - robot ?from ?to - location)
     :duration (= ?duration 10)
     :condition (and
        (at start (available ?r))
        (at start (atl_ag ?r ?from))
        (at start (adjacent ?from ?to))
        (at start (normal_pressure ?from))
        (at start (normal_pressure ?to))
     )
     :effect (and
        (at start (not (available ?r)))
        (at start (not (atl_ag ?r ?from)))
        (at end (atl_ag ?r ?to))
        (at end (available ?r))
     )
 )

 (:durative-action move_sealing
     :parameters (?r - robot ?from ?to - location)
     :duration (= ?duration 15)
     :condition (and
        (at start (available ?r))
        (at start (atl_ag ?r ?from))
        (at start (adjacent ?from ?to))
        (at start (sealing_mode ?r))
     )
     :effect (and
        (at start (not (available ?r)))
        (at start (not (atl_ag ?r ?from)))
        (at end (atl_ag ?r ?to))
        (at end (available ?r))
     )
 )

 (:durative-action move_drone
     :parameters (?d - drone ?from ?to - location)
     :duration (= ?duration 5)
     :condition (and
        (at start (available ?d))
        (at start (atl_ag ?d ?from))
        (at start (adjacent ?from ?to))
     )
     :effect (and
        (at start (not (available ?d)))
        (at start (not (atl_ag ?d ?from)))
        (at end (atl_ag ?d ?to))
        (at end (available ?d))
     )
 )

 (:durative-action load_delicate_artifact
     :parameters (?a - artifact ?l - location ?r - robot ?s - spot)
     :duration (= ?duration 3)
     :condition (and
        (at start (available ?r))
        (at start (atl_ag ?r ?l))
        (at start (atl_art ?a ?l))
        (at start (free_artifact ?a))
        (at start (empty_spot ?s))
        (at start (delicate ?a))
        (at start (has_pod ?r))
        (at start (unsafe_destination ?l))
        (at start (belongs_to ?s ?r))
     )
     :effect (and
        (at start (not (available ?r)))
        (at start (not (free_artifact ?a)))
        (at start (not (atl_art ?a ?l)))
        (at start (not (empty_spot ?s)))
        (at end (holding ?s ?a))
        (at end (available ?r))
     )
 )

 (:durative-action load_normal_artifact
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :duration (= ?duration 2)
     :condition (and
        (at start (available ?ag))
        (at start (atl_ag ?ag ?l))
        (at start (atl_art ?a ?l))
        (at start (free_artifact ?a))
        (at start (empty_spot ?s))
        (at start (normal_artifact ?a))
        (at start (unsafe_destination ?l))
        (at start (belongs_to ?s ?ag))
     )
     :effect (and
        (at start (not (available ?ag)))
        (at start (not (free_artifact ?a)))
        (at start (not (atl_art ?a ?l)))
        (at start (not (empty_spot ?s)))
        (at end (holding ?s ?a))
        (at end (available ?ag))
     )
 )

 (:durative-action unload_artifact
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :duration (= ?duration 2)
     :condition (and
        (at start (available ?ag))
        (at start (holding ?s ?a))
        (at start (atl_ag ?ag ?l))
        (at start (safe_destination ?l))
        (at start (cooled ?a))
        (at start (belongs_to ?s ?ag))
     )
     :effect (and
        (at start (not (available ?ag)))
        (at start (not (holding ?s ?a)))
        (at end (atl_art ?a ?l))
        (at end (empty_spot ?s))
        (at end (available ?ag))
     )
 )

 (:durative-action cooling
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :duration (= ?duration 6)
     :condition (and
        (at start (available ?ag))
        (at start (need_cooling ?a))
        (at start (atl_ag ?ag ?l))
        (at start (cooling_destination ?l))
        (at start (holding ?s ?a))
        (at start (belongs_to ?s ?ag))
     )
     :effect (and
        (at start (not (available ?ag)))
        (at end (not (need_cooling ?a)))
        (at end (cooled ?a))
        (at end (available ?ag))
     )
 )

 (:durative-action load_pod
     :parameters (?p - pod ?l - location ?r - robot)
     :duration (= ?duration 4)
     :condition (and
        (at start (available ?r))
        (at start (free_pod ?p))
        (at start (atl_pod ?p ?l))
        (at start (atl_ag ?r ?l))
        (at start (no_pod ?r))
     )
     :effect (and
        (at start (not (available ?r)))
        (at start (not (free_pod ?p)))
        (at start (not (atl_pod ?p ?l)))
        (at start (not (no_pod ?r)))
        (at end (has_pod ?r))
        (at end (pod_carried_by ?p ?r))
        (at end (available ?r))
     )
 )

 (:durative-action unload_pod
     :parameters (?p - pod ?l - location ?r - robot)
     :duration (= ?duration 4)
     :condition (and
        (at start (available ?r))
        (at start (pod_carried_by ?p ?r))
        (at start (has_pod ?r))
        (at start (atl_ag ?r ?l))
     )
     :effect (and
        (at start (not (available ?r)))
        (at start (not (pod_carried_by ?p ?r)))
        (at start (not (has_pod ?r)))
        (at end (no_pod ?r))
        (at end (free_pod ?p))
        (at end (atl_pod ?p ?l))
        (at end (available ?r))
     )
 )

 (:durative-action enable_sealing
     :parameters (?r - robot)
     :duration (= ?duration 1)
     :condition (and
        (at start (available ?r))
        (at start (sealing_off ?r))
     )
     :effect (and
        (at start (not (available ?r)))
        (at start (not (sealing_off ?r)))
        (at end (sealing_mode ?r))
        (at end (available ?r))
     )
 )

 (:durative-action disable_sealing
     :parameters (?r - robot)
     :duration (= ?duration 1)
     :condition (and
        (at start (available ?r))
        (at start (sealing_mode ?r))
     )
     :effect (and
        (at start (not (available ?r)))
        (at start (not (sealing_mode ?r)))
        (at end (sealing_off ?r))
        (at end (available ?r))
     )
 )
)
