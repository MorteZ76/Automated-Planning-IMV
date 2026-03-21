(define (problem problem4-temporal)
  (:domain problem4)

  (:objects
    cryo-chamber anti-vibration-pods artifact-hall-alpha artifact-hall-beta maintenance-tunnel stasis-lab - location
    curator-1 - robot  
    drone-1 - drone
    spot-c1 spot-c2 - spot
    spot-d1 - spot
    pod-1 pod-2 - pod  
    martian-core-sample fragile-rock heavy-meteorite - artifact      
  )

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

    ;; --- Location Properties (NEW STRIPS COMPLIANT) ---
    (low-pressure maintenance-tunnel) 
    (normal-pressure stasis-lab)
    (normal-pressure artifact-hall-alpha)
    (normal-pressure artifact-hall-beta)
    (normal-pressure anti-vibration-pods)
    (normal-pressure cryo-chamber)

    (cooling-destination cryo-chamber) 
    (safe-destination stasis-lab)      
    (unsafe-destination maintenance-tunnel)
    (unsafe-destination artifact-hall-alpha)
    (unsafe-destination artifact-hall-beta)
    (unsafe-destination anti-vibration-pods)
    (unsafe-destination cryo-chamber)

    ;; --- Agent Starting Locations & Status ---
    (atl curator-1 maintenance-tunnel)
    (available curator-1) 
    (no-pod curator-1)
    (sealing-off curator-1)

    (atl drone-1 maintenance-tunnel)
    (available drone-1)  

    ;; --- Slot Assignments & Status ---
    (belongs-to spot-c1 curator-1)
    (empty-spot spot-c1)
    (belongs-to spot-c2 curator-1)
    (empty-spot spot-c2)
    (belongs-to spot-d1 drone-1)
    (empty-spot spot-d1)

    ;; --- Pod Status ---
    (atl pod-1 anti-vibration-pods)
    (free-pod pod-1)
    (atl pod-2 anti-vibration-pods)
    (free-pod pod-2)

    ;; --- Artifact Properties and Locations ---
    (atl fragile-rock artifact-hall-beta)
    (free-artifact fragile-rock)
    (delicate fragile-rock)
    (cooled fragile-rock) ;; Doesn't need cooling, so it starts "cooled"

    (atl martian-core-sample artifact-hall-alpha)
    (free-artifact martian-core-sample)
    (need-cooling martian-core-sample)
    (normal-artifact martian-core-sample) 
    
    (atl heavy-meteorite artifact-hall-alpha)
    (free-artifact heavy-meteorite)
    (normal-artifact heavy-meteorite)
    (cooled heavy-meteorite)
  )

  (:goal
    (and
      (atl fragile-rock stasis-lab)
      (atl martian-core-sample stasis-lab)
      (atl heavy-meteorite stasis-lab)
    )
  )
)