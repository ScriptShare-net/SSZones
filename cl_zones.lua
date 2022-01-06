local zonePoints = {}
local circles = {}
local draw = false
local zoneHeight = {}

zonePoints["debug"] = {}
zoneHeight["debug"] = 0

local function tableLength(tbl)
	local length = 0
	for n in pairs(tbl) do 
		length = length + 1 
	end
	return length
end

local function initiate()
	if not draw then
		draw = true
		while draw do
			Wait(1)
			local lastpoint
			for zone, points in pairs(zonePoints) do
				for k, v in pairs(points) do
					if not lastpoint then
						lastpoint = v
					else
						if zoneHeight[zone] > 0 then
							DrawPoly(lastpoint.x, lastpoint.y, lastpoint.z, lastpoint.x, lastpoint.y, lastpoint.z + zoneHeight[zone], v.x, v.y, v.z, 0, 255, 0, 100)
							DrawPoly(v.x, v.y, v.z, lastpoint.x, lastpoint.y, lastpoint.z + zoneHeight[zone], lastpoint.x, lastpoint.y, lastpoint.z, 0, 255, 0, 100)
							DrawPoly(lastpoint.x, lastpoint.y, lastpoint.z + zoneHeight[zone], v.x, v.y, v.z + zoneHeight[zone], v.x, v.y, v.z, 0, 255, 0, 100)
							DrawPoly(v.x, v.y, v.z, v.x, v.y, v.z + zoneHeight[zone], lastpoint.x, lastpoint.y, lastpoint.z + zoneHeight[zone], 0, 255, 0, 100)
						else
							DrawLine(lastpoint.x, lastpoint.y, lastpoint.z, v.x, v.y, v.z, 0, 255, 0, 100)
						end
						lastpoint = v
					end
				end
				if zoneHeight[zone] > 0 then
					DrawPoly(points[#points].x, points[#points].y, points[#points].z, points[#points].x, points[#points].y, points[#points].z + zoneHeight[zone], points[1].x, points[1].y, points[1].z, 0, 255, 0, 100)
					DrawPoly(points[1].x, points[1].y, points[1].z, points[#points].x, points[#points].y, points[#points].z + zoneHeight[zone], points[#points].x, points[#points].y, points[#points].z, 0, 255, 0, 100)
					DrawPoly(points[#points].x, points[#points].y, points[#points].z + zoneHeight[zone], points[1].x, points[1].y, points[1].z + zoneHeight[zone], points[1].x, points[1].y, points[1].z, 0, 255, 0, 100)
					DrawPoly(points[1].x, points[1].y, points[1].z, points[1].x, points[1].y, points[1].z + zoneHeight[zone], points[#points].x, points[#points].y, points[#points].z + zoneHeight[zone], 0, 255, 0, 100)
				else
					DrawLine(points[#points].x, points[#points].y, points[#points].z, points[1].x, points[1].y, points[1].z, 0, 255, 0, 100)
				end
				lastpoint = nil
			end
			for id, circle in pairs(circles) do
				print(id)
				DrawMarker(1, circle.center.x, circle.center.y, circle.center.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, circle.distance * 2, circle.distance * 2, circle.height, 0, 255, 0, 96, false, false, 2, nil, nil, false)
			end
			if not tableLength(zonePoints) and not tableLength(circles) then draw = false end
		end
	end
end

RegisterNetEvent("SSZones:AddZonePoint", function(coords)
	if not zonePoints["debug"] then zonePoints["debug"] = {} zoneHeight["debug"] = 0 end
	zonePoints["debug"][#zonePoints["debug"] + 1] = coords
	if not draw then
		initiate()
	end
end)

RegisterNetEvent("SSZones:SetHeight", function(height)
	zoneHeight["debug"] = height
end)

RegisterNetEvent("SSZones:FinishZone", function(identifier)
	zonePoints[identifier] = zonePoints["debug"]
	zoneHeight[identifier] = zoneHeight["debug"]
	zonePoints["debug"] = nil
	zoneHeight["debug"] = nil
end)

RegisterNetEvent("SSZones:DrawZone", function(identifier, points, height)
	zonePoints[identifier] = points
	zoneHeight[identifier] = height
	if not draw then
		initiate()
	end
end)

RegisterNetEvent("SSZones:HideZone", function(identifier)
	zonePoints[identifier] = nil
	zoneHeight[identifier] = nil
	if not zonePoints or #zonePoints > 0 then
		draw = false
	end
end)

RegisterNetEvent("SSZones:DrawCircle", function(identifier, coords, distance, height)
	if not draw then
		initiate()
	end
	circles[identifier] = {
		coords = coords,
		distance = distance,
		height = height,
	}
end)

RegisterNetEvent("SSZones:HideCircle", function(identifier, coords, distance, height)
	circles[identifier] = nil
end)
