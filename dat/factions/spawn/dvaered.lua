--[[

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License version 3 as
   published by the Free Software Foundation.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

--]]


include("dat/factions/spawn/common.lua")


-- @brief Spawns a small patrol fleet.
function spawn_patrol ()
    local pilots = {}
    local r = rnd.rnd()

    if r < 0.5 then
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Ancestor", 20 );
    elseif r < 0.8 then
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Ancestor", 20 );
    else
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Ancestor", 20 );
        scom.addPilot( pilots, "Dvaered Phalanx", 45 );
    end

    return pilots
end


-- @brief Spawns a medium sized squadron.
function spawn_squad ()
    local pilots = {}
    local r = rnd.rnd()

    if r < 0.5 then
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Ancestor", 20 );
        scom.addPilot( pilots, "Dvaered Vigilance", 70 );
    elseif r < 0.8 then
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Ancestor", 20 );
        scom.addPilot( pilots, "Dvaered Vigilance", 70 );
    else
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Phalanx", 45 );
        scom.addPilot( pilots, "Dvaered Vigilance", 70 );
    end

    return pilots
end


-- @brief Spawns a capship with escorts.
function spawn_capship ()
    local pilots = {}

    -- Generate the capship
    scom.addPilot( pilots, "Dvaered Goddard", 120 )

    -- Generate the escorts
    r = rnd.rnd()
    if r < 0.5 then
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Ancestor", 20 );
    elseif r < 0.8 then
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Ancestor", 20 );
        scom.addPilot( pilots, "Dvaered Phalanx", 45 );
    else
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Vendetta", 25 );
        scom.addPilot( pilots, "Dvaered Vigilance", 70 );
    end

    return pilots
end


-- @brief Creation hook.
function create ( max )
    local weights = {}

    -- Create weights for spawn table
    weights[ spawn_patrol  ] = 100
    weights[ spawn_squad   ] = math.max(1, -80 + 0.80 * max)
    weights[ spawn_capship ] = math.max(1, -500 + 1.70 * max)
   
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
