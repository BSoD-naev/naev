for _,a in ipairs (system.adjacentSystems("Gamma Polaris")) do
for _,b in ipairs (system.adjacentSystems(a) do 
for _,c in ipairs (system.adjacentSystems(b) do 
for _,d in ipairs (system.adjacentSystems(c) do 
for _,e in ipairs (system.adjacentSystems(d) do 
for _,f in ipairs (system.adjacentSystems(e) do 
for _,g in ipairs (system.adjacentSystems(f) do 
for _,h in ipairs (system.adjacentSystems(g) do 
system.setKnown(h,true)
jump.setKnown(g,h)
jump.setKnown(h,g)
end
system.setKnown(g,true)
jump.setKnown(f,g)
jump.setKnown(g,f)
end
system.setKnown(f,true)
jump.setKnown(e,f)
jump.setKnown(f,e)
end
system.setKnown(e,true)
jump.setKnown(d,e)
jump.setKnown(e,d)
end
system.setKnown(e,true)
jump.setKnown(d,e)
jump.setKnown(e,d)
end
system.setKnown(d,true)
jump.setKnown(c,d)
jump.setKnown(d,c)
end
system.setKnown(c,true)
jump.setKnown(b,c)
jump.setKnown(c,b)
end
system.setKnown(b,true)
jump.setKnown(a,b)
jump.setKnown(b,a)
end
system.setKnown(a,true)
jump.setKnown(a,"Gamma Polaris")
jump.setKnown("Gamma Polaris",a)
end