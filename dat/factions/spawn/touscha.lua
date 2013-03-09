include("dat/factions/spawn/common.lua")


-- @brief Spawns the ships.
function spawn_ships ()
    local pilots = {}
    local r = rnd.rnd()

    -- Generate ships
    r = rnd.rnd()
    if r < 0.35 then
       scom.addPilot( pilots, "Touscha Peregrine", 25 );
       scom.addPilot( pilots, "Touscha Peregrine", 25 );
    elseif r < 0.75 then
       scom.addPilot( pilots, "Touscha Peregrine", 25 );
       scom.addPilot( pilots, "Touscha Peregrine", 25 );
       scom.addPilot( pilots, "Touscha Vanguard", 40 );
    else
       scom.addPilot( pilots, "Touscha Kestrel", 175 );
       scom.addPilot( pilots, "Touscha Vanguard", 40 );
       scom.addPilot( pilots, "Touscha Vanguard", 40 );
    end

    return pilots
end


-- @brief Creation hook.
function create ( max )
    local weights = {}

    -- Create weights for spawn table
    weights[ spawn_ships ] = 100
   
    -- Create spawn table base on weights
    spawn_table = scom.createSpawnTable( weights )

    -- Calculate spawn data
    spawn_data = scom.choose( spawn_table )

    return scom.calcNextSpawn( 0, scom.presence(spawn_data), max )
end


-- @brief Spawning hook
function spawn ( presence, max )
    local pilots

    -- Over limit
    if presence > max then
       return 5
    end
  
    -- Actually spawn the pilots
    pilots = scom.spawn( spawn_data )

    -- Calculate spawn data
    spawn_data = scom.choose( spawn_table )

    return scom.calcNextSpawn( presence, scom.presence(spawn_data), max ), pilots
end
