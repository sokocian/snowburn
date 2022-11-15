local primitives = require "primitives"

local function setColor(r,g,b,a)
    love.graphics.setColor(r/255, g/255, b/255, a and a/255)
end

local object_designs = {
	["tree"] = function(x, y, z)
	    setColor(56,48,46)
	    primitives.line(x,y,z, x,y-1.25,z)
	    primitives.circle(x,y,z, 0,0,0, 0.1,1,0.1)

	    setColor(71,164,61)
	    for i=1, math.pi*2, math.pi*2/3 do
	        local r = 0.35
	        --primitives.axisBillboard(1 + math.cos(i)*r, -0.5, 0 + math.sin(i)*r, 0,-1,0)
	        primitives.fullBillboard(x + math.cos(i)*r, y - 1, z + math.sin(i)*r)
	    end
	    primitives.fullBillboard(x, y-1.5, z)
	end
}

return object_designs