include("scripts/prng.lua")

nebulae = {
   "nebula01.png",
   "nebula02.png",
   "nebula03.png",
   "nebula04.png",
   "nebula05.png",
   "nebula06.png",
   "nebula07.png",
   "nebula08.png",
   "nebula09.png",
   "nebula10.png",
   "nebula11.png",
   "nebula12.png",
   "nebula13.png",
   "nebula14.png",
   "nebula15.png",
   "nebula16.png",
   "nebula17.png",
   "nebula18.png",
   "nebula19.png",
   "nebula20.png",
   "nebula21.png",
   "nebula22.png",
   "nebula23.png",
   "nebula24.png",
   "nebula25.png",
   "nebula26.png",
   "nebula27.png",
   "nebula28.png",
   "nebula29.png",
   "nebula30.png",
   "nebula31.png",
   "nebula32.png",
   "nebula33.png",
   "nebula34.png"
}


function background ()

   -- We can do systems without nebula
   local sys = system.cur()
   local nebud, nebuv = sys:nebula()
   if nebud > 0 then
      return
   end

   -- Start up PRNG based on system name for deterministic nebula
   local sys = system.cur()
   prng.initHash( system.name(sys) )

   -- Set up parameters
   local path  = "gfx/bkg/"
   local nebula = nebulae[ prng.range(1,#nebulae) ]
   local img   = tex.open( path .. nebula )
   local w,h   = img:dim()
   local r     = prng.num() * sys:radius()/2
   local a     = 2*math.pi*prng.num()
   local x     = r*math.cos(a)
   local y     = r*math.sin(a)
   local move  = 0.1 + prng.num()*0.4
   local scale = 1 + (prng.num()*0.5 + 0.5)*((2000+2000)/(w+h))
   if scale > 1.9 then scale = 1.9 end
   bkg.image( img, x, y, move, scale )


end



