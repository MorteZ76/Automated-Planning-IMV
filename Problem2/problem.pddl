
(define (problem problem2-imv)
  (:domain problem2)

  ;; 1. WHAT EXISTS IN THIS LEVEL?
  (:objects
    ;; The Map Locations
    cryo-chamber anti-vibration-pods artifact-hall-alpha artifact-hall-beta maintenance-tunnel stasis-lab - location
    
    ;; The Entities
    curator-1 - robot  
    drone-1 - drone
    
    ;; The Capacity Spots (2 for Curator, 1 for Drone)
    spot-c1 spot-c2 - spot
    spot-d1 - spot
    
    ;; The Pods
    pod-1 pod-2 - pod  
    
    ;; The Artifacts 
    martian-core-sample - artifact  ;; Needs cooling
    fragile-rock - artifact         ;; Delicate
    heavy-meteorite - artifact      ;; Normal (Added to test multi-carry!)
  )

  ;; 2. WHAT IS THE STARTING SITUATION?
  (:init
    ;; --- Map Connections ---
    (adjacent stasis-lab maintenance-tunnel)
    (adjacent maintenance-tunnel stasis-lab)

    (adjacent artifact-hall-alpha maintenance-tunnel)
    (adjacent maintenance-tunnel artifact-hall-alpha)

    (adjacent artifact-hall-beta maintenance-tunnel)
    (adjacent maintenance-tunnel artifact-hall-beta)

    (adjacent anti-vibration-pods maintenance-tunnel)
    (adjacent maintenance-tunnel anti-vibration-pods)

    (adjacent cryo-chamber maintenance-tunnel)
    (adjacent maintenance-tunnel cryo-chamber)

    ;; --- Location Properties ---
    (low-pressure maintenance-tunnel)  
    (cooling-destination cryo-chamber) 
    (safe-destination stasis-lab)      

    ;; --- Agent Starting Locations ---
    (atl curator-1 maintenance-tunnel)
    (atl drone-1 maintenance-tunnel)

    ;; --- Slot Assignments & Status ---
    ;; Assign spots to the curator and mark them empty
    (belongs-to spot-c1 curator-1)
    (empty-spot spot-c1)
    
    (belongs-to spot-c2 curator-1)
    (empty-spot spot-c2)

    ;; Assign spot to the drone and mark it empty
    (belongs-to spot-d1 drone-1)
    (empty-spot spot-d1)

    ;; --- Pod Status ---
    (atl pod-1 anti-vibration-pods)
    (free-pod pod-1)
    (atl pod-2 anti-vibration-pods)
    (free-pod pod-2)

    ;; --- Artifact Properties and Locations ---
    ;; 1. Fragile Rock in Hall Beta (Delicate)
    (atl fragile-rock artifact-hall-beta)
    (free-artifact fragile-rock)
    (delicate fragile-rock)

    ;; 2. Martian Core Sample in Hall Alpha (Hot)
    (atl martian-core-sample artifact-hall-alpha)
    (free-artifact martian-core-sample)
    (need-cooling martian-core-sample) 
    
    ;; 3. Heavy Meteorite in Hall Alpha (Normal)
    (atl heavy-meteorite artifact-hall-alpha)
    (free-artifact heavy-meteorite)
  )

  ;; 3. WHAT IS THE WIN CONDITION?
  (:goal
    (and
      (atl fragile-rock stasis-lab)
      (atl martian-core-sample stasis-lab)
      (atl heavy-meteorite stasis-lab)
    )
  )
)
