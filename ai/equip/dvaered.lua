--[[
-- @brief Does dvaered pilot equipping
--
--    @param p Pilot to equip
--]]
function equip_dvaered( p )
   -- Get ship info
   local shiptype, shipsize = equip_getShipBroad( p:ship():class() )

   -- Split by type
   if shiptype == "military" then
      equip_dvaeredMilitary( p, shipsize )
   else
      equip_generic( p )
   end
end


function icmb( t1, t2 )
   t = {}
   for _,v in ipairs(t1) do
      t[ #t+1 ] = v
   end
   for _,v in ipairs(t2) do
      t[ #t+1 ] = v
   end
   return t
end


function equip_forwardDvaLow ()
   return { "Vulcan Gun", "Shredder" }
end
function equip_forwardDvaMed ()
   return { "Shredder", "Mass Driver MK2", "Mass Driver MK3" }
end
function equip_forwardDvaHig ()
   return { "Railgun", "Repeating Railgun" }
end
function equip_turretDvaLow ()
   return { "Turreted Gauss Gun", "Turreted Vulcan Gun" }
end
function equip_turretDvaMed ()
   return { "Turreted Vulcan Gun" }
end
function equip_turretDvaHig ()
   return { "Railgun Turret" }
end
function equip_rangedDva ()
   return { "Mace Launcher" }
end
function equip_secondaryDva ()
   return { "Mace Launcher" }
end



--[[
-- @brief Equips a dvaered military type ship.
--]]
function equip_dvaeredMilitary( p, shipsize )
   local primary, secondary, medium, low, apu
   local use_primary, use_secondary, use_medium, use_low
   local nhigh, nmedium, nlow = p:ship():slots()

   -- Defaults
   medium      = { "Civilian Jammer" }
   secondary   = { }
   apu         = { }

   -- Equip by size and type
   if shipsize == "small" then
      local class = p:ship():class()

      -- Scout
      if class == "Scout" then
         primary        = equip_forwardLow ()
         use_primary    = rnd.rnd(1,#nhigh)
         medium         = { "Generic Afterburner", "Milspec Jammer" }
         use_medium     = 2
         low            = { "Solar Panel" }

      -- Fighter
      elseif class == "Fighter" then
         primary        = equip_forwardDvaLow()
         use_primary    = nhigh-1
         secondary      = equip_secondaryDva()
         use_secondary  = 1
         medium         = equip_mediumLow()
         low            = equip_lowLow()
         apu            = equip_apuLow()

      -- Bomber
      elseif class == "Bomber" then
         primary        = equip_forwardDvaLow()
         secondary      = equip_rangedDva()
         use_primary    = rnd.rnd(1,2)
         use_secondary  = nhigh - use_primary
         medium         = equip_mediumLow()
         low            = equip_lowLow()
         apu            = equip_apuLow()
      end

   elseif shipsize == "medium" then
      primary        = icmb( equip_forwardDvaMed(), equip_turretDvaMed() )
      secondary      = equip_secondaryDva()
      use_secondary  = rnd.rnd(1,2)
      use_primary    = nhigh - use_secondary
      medium         = equip_mediumLow()
      low            = equip_lowMed()
      apu            = equip_apuMed()

   else -- "large"
      primary        = icmb( equip_turretDvaHig(), equip_forwardDvaHig() )
      secondary      = equip_secondaryDva()
      use_primary    = nhigh-2
      use_secondary  = 2
      medium         = equip_mediumHig()
      low            = equip_lowHig()
      apu            = equip_apuHig()
   end
   equip_ship( p, false, primary, secondary, medium, low, apu,
               use_primary, use_secondary, use_medium, use_low )
end

