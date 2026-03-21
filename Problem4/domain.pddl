(define (domain problem4)
 (:requirements :strips :typing :durative-actions)
 (:types
  location object 
  pod artifact spot agent - object 
  robot drone - agent   
  )

 (:predicates
   (adjacent ?l1 ?l2 - location)       
   (low-pressure ?l - location) 
   (normal-pressure ?l - location)     ;; REPLACES (not low-pressure)
   (safe-destination ?l - location)    
   (unsafe-destination ?l - location)  ;; REPLACES (not safe-destination)
   (cooling-destination ?l - location) 
   (atl ?obj - object ?l - location)   
   (belongs-to ?s - spot ?ag - agent)  
   (empty-spot ?s - spot)              
   (holding ?s - spot ?a - artifact)   
   (free-pod ?p - pod)                 
   (pod-carried-by ?p - pod ?r - robot)
   (delicate ?a - artifact)  
   (normal-artifact ?a - artifact)     ;; REPLACES (not delicate)
   (need-cooling ?a - artifact)    
   (cooled ?a - artifact)              ;; REPLACES (not need-cooling)
   (free-artifact ?a - artifact)       
   (has-pod ?r - robot)  
   (no-pod ?r - robot)                 ;; REPLACES (not has-pod)
   (sealing-mode ?r - robot)       
   (sealing-off ?r - robot)            ;; REPLACES (not sealing-mode)
   (available ?ag - agent) 
   )

 ;; --- ACTIONS ---

 (:durative-action move-normal
     :parameters (?r - robot ?from ?to - location)
     :duration (= ?duration 10)
     :condition (and 
        (at start (available ?r))
        (at start (atl ?r ?from))
        (over all (adjacent ?from ?to))
        (over all (normal-pressure ?from)) 
        (over all (normal-pressure ?to)) 
     )
     :effect (and 
        (at start (not (available ?r)))
        (at start (not (atl ?r ?from)))
        (at end (atl ?r ?to))
        (at end (available ?r)) 
     )
 )

 (:durative-action move-sealing
     :parameters (?r - robot ?from ?to - location)
     :duration (= ?duration 15)
     :condition (and 
        (at start (available ?r))
        (at start (atl ?r ?from))
        (over all (adjacent ?from ?to))
        (over all (sealing-mode ?r))
     )
     :effect (and 
        (at start (not (available ?r)))
        (at start (not (atl ?r ?from)))
        (at end (atl ?r ?to))
        (at end (available ?r)) 
     )
 )

 (:durative-action move-drone
     :parameters (?d - drone ?from ?to - location)
     :duration (= ?duration 5)
     :condition (and 
        (at start (available ?d))
        (at start (atl ?d ?from))
        (over all (adjacent ?from ?to)) 
     )
     :effect (and 
        (at start (not (available ?d)))
        (at start (not (atl ?d ?from)))
        (at end (atl ?d ?to))
        (at end (available ?d)) 
     )
 )

 (:durative-action load-delicate-artifact
     :parameters (?a - artifact ?l - location ?r - robot ?s - spot)
     :duration (= ?duration 3)
     :condition (and 
        (at start (available ?r))
        (over all (atl ?r ?l)) 
        (at start (atl ?a ?l)) 
        (at start (free-artifact ?a))
        (at start (empty-spot ?s))
        (over all (delicate ?a)) 
        (over all (has-pod ?r))
        (over all (unsafe-destination ?l))
        (over all (belongs-to ?s ?r)) 
     )
     :effect (and 
        (at start (not (available ?r)))
        (at start (not (free-artifact ?a))) 
        (at start (not (atl ?a ?l))) 
        (at start (not (empty-spot ?s))) 
        (at end (holding ?s ?a)) 
        (at end (available ?r))
     )
 )

 (:durative-action load-normal-artifact
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :duration (= ?duration 2)
     :condition (and 
        (at start (available ?ag))
        (over all (atl ?ag ?l)) 
        (at start (atl ?a ?l)) 
        (at start (free-artifact ?a))
        (at start (empty-spot ?s))
        (over all (normal-artifact ?a)) 
        (over all (unsafe-destination ?l))
        (over all (belongs-to ?s ?ag)) 
     )
     :effect (and 
        (at start (not (available ?ag)))
        (at start (not (free-artifact ?a))) 
        (at start (not (atl ?a ?l))) 
        (at start (not (empty-spot ?s))) 
        (at end (holding ?s ?a))
        (at end (available ?ag)) 
     )
 )

 (:durative-action unload-artifact
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :duration (= ?duration 2)
     :condition (and 
        (at start (available ?ag))
        (at start (holding ?s ?a)) 
        (over all (atl ?ag ?l)) 
        (over all (safe-destination ?l)) 
        (over all (cooled ?a))
        (over all (belongs-to ?s ?ag)) 
     )
     :effect (and 
        (at start (not (available ?ag)))
        (at start (not (holding ?s ?a)))
        (at end (atl ?a ?l))
        (at end (empty-spot ?s)) 
        (at end (available ?ag))
     )
 )

 (:durative-action cooling
     :parameters (?a - artifact ?l - location ?ag - agent ?s - spot)
     :duration (= ?duration 6)
     :condition (and 
        (at start (available ?ag))
        (at start (need-cooling ?a))
        (over all (atl ?ag ?l)) 
        (over all (cooling-destination ?l))  
        (over all (holding ?s ?a)) 
        (over all (belongs-to ?s ?ag)) 
     )
     :effect (and 
        (at start (not (available ?ag)))
        (at end (not (need-cooling ?a)))
        (at end (cooled ?a))
        (at end (available ?ag)) 
     )
 )

 (:durative-action load-pod 
     :parameters (?p - pod ?l - location ?r - robot)
     :duration (= ?duration 4)
     :condition (and 
        (at start (available ?r))
        (at start (free-pod ?p)) 
        (at start (atl ?p ?l))
        (over all (atl ?r ?l)) 
        (over all (no-pod ?r))
     )
     :effect (and 
        (at start (not (available ?r)))
        (at start (not (free-pod ?p)))
        (at start (not (atl ?p ?l)))
        (at start (not (no-pod ?r)))
        (at end (has-pod ?r))  
        (at end (pod-carried-by ?p ?r)) 
        (at end (available ?r))
     )
 )

 (:durative-action unload-pod
     :parameters (?p - pod ?l - location ?r - robot)
     :duration (= ?duration 4)
     :condition (and 
        (at start (available ?r))
        (at start (pod-carried-by ?p ?r)) 
        (at start (has-pod ?r))
        (over all (atl ?r ?l)) 
     )
     :effect (and 
        (at start (not (available ?r)))
        (at start (not (pod-carried-by ?p ?r))) 
        (at start (not (has-pod ?r)))
        (at end (no-pod ?r))
        (at end (free-pod ?p)) 
        (at end (atl ?p ?l))
        (at end (available ?r)) 
     )
 )

 (:durative-action enable-sealing
     :parameters (?r - robot)
     :duration (= ?duration 1)
     :condition (and 
        (at start (available ?r))
        (at start (sealing-off ?r))
     )
     :effect (and 
        (at start (not (available ?r)))
        (at start (not (sealing-off ?r)))
        (at end (sealing-mode ?r))
        (at end (available ?r))
     )
 )

 (:durative-action disable-sealing
     :parameters (?r - robot)
     :duration (= ?duration 1)
     :condition (and 
        (at start (available ?r))
        (at start (sealing-mode ?r))
     )
     :effect (and 
        (at start (not (available ?r)))
        (at start (not (sealing-mode ?r)))
        (at end (sealing-off ?r))
        (at end (available ?r))
     )
 )
)