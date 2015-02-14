--[[

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License version 3 as
   published by the Free Software Foundation.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

--]]


include "dat/factions/standing/skel.lua"


-- Faction caps.
_fcap_kill       = 10 -- Kill cap
_fdelta_distress = {-1, 0} -- Maximum change constraints
_fdelta_kill     = {-5, 1} -- Maximum change constraints
_fcap_misn       = 30 -- Starting mission cap, gets overwritten
_fcap_misn_var   = "_fcap_thurion" -- Mission variable to use for limits
_fthis         = faction.get("Thurion")


function faction_hit( current, amount, source, secondary )
    return default_hit(current, amount, source, secondary)
end
