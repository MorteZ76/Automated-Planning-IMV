(define (problem problem1-imv)
  (:domain problem1)

  ;; 1. WHAT EXISTS IN THIS LEVEL?
  (:objects
    ;; The Map Locations
    cryo-chamber anti-vibration-pods artifact-hall-alpha artifact-hall-beta maintenance-tunnel stasis-lab - location
    
    ;; The Entities
    curator-1 - robot  
    pod-1 pod-2 - pod  
    
    ;; The Artifacts 
    martian-core-sample - artifact  
    fragile-rock - artifact         
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

    ;; --- Robot Status ---
    (atl curator-1 maintenance-tunnel)
    
    ;; --- Pod Status ---
    (atl pod-1 anti-vibration-pods)
    (free-pod pod-1)
    (atl pod-2 anti-vibration-pods)
    (free-pod pod-2)

    ;; --- Artifact Properties and Locations ---
    ;; 1. Fragile Rock in Hall Beta
    (atl fragile-rock artifact-hall-beta)
    (free-artifact fragile-rock)
    (delicate fragile-rock)

    ;; 2. Martian Core Sample in Hall Alpha
    (atl martian-core-sample artifact-hall-alpha)
    (free-artifact martian-core-sample)
    (need-cooling martian-core-sample) 
  )

  ;; 3. WHAT IS THE WIN CONDITION?
  (:goal
    (and
      (atl fragile-rock stasis-lab)
      (atl martian-core-sample stasis-lab)
    )
  )
)