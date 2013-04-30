--[[

Touscha standard Bounty mission

Author: Ambience

]]--
include "missions/touscha/rand_sys.lua"
include "scripts/jumpdist.lua"
include "scripts/numstring.lua"

lang =  naev.lang()
if lang == "es" then
else -- English

  misn_title = "Bounty on %s-class %s ship"
  misn_reward = "%d credits"
  misn_desc = "Someone has placed a bounty on the ship known as the %s, last seen in the %s system."

  title = {}
  text = {}
  title[1] = "Mercenary work"
  title[2] = "Mission Success"
  text[1] = [[A person has come to the Touscha world in search of a mercenary willing to take out a %s-class ship, known as the %s. They are willing to pay out %d credits for the job. This may be a good job.]]
  text[2] = [[You get their attention and offer your services.]]
  text[3] = [[Your client is impressed; he pays your reward and thanks you for the job.]]

  OSD_msg = {}
  OSD_msg[1] = "Head to %s and take out the %s."
  OSD_msg[2] = "Return to %s to recieve your payment."

  msg = {}
  msg[1] = "Well done. Return to %s for your payment."
  msg[2] = "By letting your target leave the system, you have failed. Failure is not tolerable."
end

--Possible factions that could be targeted by the player
target_faction = {}
target_faction[1] = "Independent"
target_faction[2] = "Civilian"
target_faction[3] = "Trader"
target_faction[4] = "Pirate"
target_faction[5] = "Empire"

--Possible ships that could be the player's target, sorted by faction
--The *_base arrays are used for determining ship class with ship.class()
ships_ind = {}
ships_ind_base = {}
  ships_ind[1] = "Independent Gawain"
  ships_ind_base[1] = "Gawain"
  ships_ind[2] = "Independent Hyena"
  ships_ind_base[2] = "Hyena"
ships_civ = {}
ships_civ_base = {}
  ships_civ[1] = "Civilian Llama"
  ships_civ_base[1] = "Llama"
  ships_civ[2] = "Civilian Gawain"
  ships_civ_base[2] = "Gawain"
  ships_civ[3] = "Civilian Hyena"
  ships_civ_base[3] = "Hyena"
ships_tra = {}
ships_tra_base = {}
  ships_tra[1] = "Trader Llama"
  ships_tra_base[1] = "Llama"
  ships_tra[2] = "Trader Gawain"
  ships_tra_base[2] = "Gawain"
  ships_tra[3] = "Trader Quicksilver"
  ships_tra_base[3] = "Quicksilver"
  ships_tra[4] = "Trader Mule"
  ships_tra_base[4] = "Mule"
  ships_tra[5] = "Trader Rhino"
  ships_tra_base[5] = "Rhino"
ships_pir = {}
ships_pir_base = {}
  ships_pir[1] = "Pirate Hyena"
  ships_pir_base[1] = "Hyena"
  ships_pir[2] = "Pirate Shark"
  ships_pir_base[2] = "Pirate Shark"
  ships_pir[3] = "Pirate Ancestor"
  ships_pir_base[3] = "Pirate Ancestor"
  ships_pir[4] = "Pirate Admonisher"
  ships_pir_base[4] = "Pirate Admonisher"
ships_emp = {}
ships_emp_base = {}
  ships_emp[1] = "Empire Shark"
  ships_emp_base[1] = "Empire Shark"
  ships_emp[2] = "Empire Lancelot"
  ships_emp_base[2] = "Empire Lancelot"
  ships_emp[3] = "Empire Admonisher"
  ships_emp_base[3] = "Empire Admonisher"
  ships_emp[4] = "Empire Pacifier"
  ships_emp_base[4] = "Empire Pacifier"

--Possible names for targeted ships
ships_names = {}
ships_names[1] = "Blind Jump"
ships_names[2] = "Lost Hope"
ships_names[3] = "Hakoi Dawn"
ships_names[4] = "Legacy"
ships_names[5] = "Hound's Tooth"
ships_names[6] = "Crude Death"



--creates the mission

function create ()

  --setting some variables

  ship_faction = target_faction[rnd.rnd(1,5)]

  if ship_faction == "Independent" then
    local ship_num = rnd.rnd(1,2)
    ship_type = ships_ind[ship_num]
    ship_base = ships_ind_base[ship_num]
  elseif ship_faction == "Civilian" then
    local ship_num = rnd.rnd(1,3)
    ship_type = ships_civ[ship_num]
    ship_base = ships_civ_base[ship_num]
  elseif ship_faction == "Trader" then
    local ship_num = rnd.rnd(1,5)
    ship_type = ships_tra[ship_num]
    ship_base = ships_tra_base[ship_num]
  elseif ship_faction == "Pirate" then
    local ship_num = rnd.rnd(1,4)
    ship_type = ships_pir[ship_num]
    ship_base = ships_pir_base[ship_num]
  elseif ship_faction == "Empire" then 
    local ship_num = rnd.rnd(1,4)
    ship_type = ships_emp[ship_num]
    ship_base = ships_emp_base[ship_num]
  end
  
  ship_name = ships_names[rnd.rnd(1,6)]

  ship_sys = getDestSys()

  ship_class = ship.class(ship.get(ship_base))
  
  if ship_class == "Yacht" then
    ship_reward = 20000
  elseif ship_class == "Luxury Yacht" then
    ship_reward = 30000
  elseif ship_class == "Courier" then 
    ship_reward = 30000
  elseif ship_class == "Fighter" then
    ship_reward = 60000
  elseif ship_class == "Bomber" then 
    ship_reward = 75000
  elseif ship_class == "Corvette" then
    ship_reward = 100000
  elseif ship_class == "Destroyer" then 
    ship_reward = 180000
  elseif ship_class == "Armoured Transport" then
    ship_reward = 65000
  elseif ship_class == "Freighter" then
    ship_reward = 50000
  else
    ship_reward = 50000
  end

  --setting up the mission

  misn_marker1 = misn.markerAdd(ship_sys, "computer")

  misn.setTitle(misn_title:format(ship_class, ship_faction))

  misn.setDesc(misn_desc:format(ship_name, system.name(ship_sys)))

  misn.setReward(misn_reward:format(ship_reward))

end


--run upon mission acceptance

function accept()

  misn_success = 0

  misn.accept()

  misn_base = planet.name(planet.cur())

  misn.osdCreate(title[1], {OSD_msg[1]:format(system.name(ship_sys), ship_name), OSD_msg[2]:format(misn_base)})

  enter_hook = hook.enter("sys_enter")



end

--gets the list of destination systems where your target can reside.
--essentally gets all systems within four jumps of the current system, excluding the current one.


count = 1

function getDestSys()

systems = {}

for _,s in ipairs (system.adjacentSystems(system.cur())) do
  sysRedundanceCheck(s)
  for _,t in ipairs (system.adjacentSystems(s)) do
    sysRedundanceCheck(t)
    for _,u in ipairs (system.adjacentSystems(t)) do
      sysRedundanceCheck(u)
      for _,v in ipairs (system.adjacentSystems(u)) do
        sysRedundanceCheck(v)
      end
    end
  end
end

return systems[rnd.rnd(1,table.getn(systems))]

end


--Helps with getDestSys

function sysRedundanceCheck(sys)  
  
  for _,c in ipairs (systems) do 
    if sys == c then
      flag = 1
    end
    if sys == system.cur() then
      flag = 1
    end
  end
  if flag == 0 then
    systems[count] = sys
    count = count + 1
  else
    flag = 0
  end

end


--Checks if you've arrived in the right system, and launches action sequence if you are.

function sys_enter ()

  if (system.cur() == ship_sys) then

    --choose where our target appears
    jumpsInSys = system.adjacentSystems(system.cur())
    ship_jump = jumpsInSys[rnd.rnd(1,table.getn(jumpsInSys))]

    --adds the ship
    ship_ai = string.lower(ship_faction)
    ship_pilot = pilot.add(ship_type, ship_ai, ship_jump)
    pilot.rename(ship_pilot[1], ship_name)
    pilot.setHostile(ship_pilot[1])
    pilot.setVisplayer(ship_pilot[1])
    pilot.setHilight(ship_pilot[1])

    --add some hooks
    hook.pilot(ship_pilot[1], "exploded", "ship_destroyed")
    hook.pilot(ship_pilot[1],"jump", "ship_escaped")
  
  end

end
    
    
--Once the ship has been destroyed

function ship_destroyed ()

  --flags the mission as a success
  misn_success = 1

  --tells the player they can return
  player.msg(msg[1]:format(misn_base))
  misn.osdActive(2)
  misn.markerRm(misn_marker1)
  land_hook = hook.land("land")

end


--If the ship escapes you

function ship_escaped ()

  --informs the player of their failure
  player.msg(msg[2])
  misn.osdDestroy()
  misn.markerRm(misn_marker1)
  misn.finish(false)

end

function land()

  --if the mission was a success
  if misn_success == 1 then
    --and if you're back at your base
    if planet.cur() == planet.get(misn_base) then
      --get your reward
      tk.msg(title[2], text[3])
      player.pay(ship_reward)
      misn.osdDestroy()
      misn.finish(true)
    end
  end
end
