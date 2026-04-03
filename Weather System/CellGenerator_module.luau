local CellGenerator = {}

local cellTemplate = game.ReplicatedStorage.CellTemplate
local baseSpot = Vector3.new(-46, 46, 8)

local function generateNewPosition()
	local randomOffset = Vector3.new(
		math.random(-30, 30),  -- X
		math.random(-10, 10),  -- Y
		math.random(-30, 30)   -- Z
	)
	return baseSpot + randomOffset
end

local function getPositionNear(position, radius)
	return position + Vector3.new(
		math.random(-radius, radius),
		math.random(-radius/3, radius/3),
		math.random(-radius, radius)
	)
end

function CellGenerator.Cell(howmanyspheres, weatherData)
	local stp = weatherData.Composites.STP
	local vtp = weatherData.Composites.VTP

	local previousPosition = nil

	for clones = 1, howmanyspheres do
		local newCell = Instance.new("Part")
		local ParticleEmitter=Instance.new("ParticleEmitter")
		newCell.Parent = workspace
		newCell.Name = "cell_" .. clones
		newCell.Shape = Enum.PartType.Ball
		newCell.Anchored = true
		newCell.Color=Color3.new(0.282353, 0.282353, 0.282353)
		ParticleEmitter.Parent=newCell
		ParticleEmitter.Shape="Sphere"
		ParticleEmitter.Rate=55
		
		-- Generate locations
		local cellPosition
		if previousPosition then
			-- Second and next cells are next to previous cells
			cellPosition = getPositionNear(previousPosition, 50)
		else
			-- First cell - random location around basespot
			cellPosition = generateNewPosition()
		end

		newCell.Position = cellPosition
		previousPosition = cellPosition  -- For next cell

		-- Cell_size
		if vtp > 5 then
			newCell.Size = Vector3.new(100, 80, 100)
		elseif stp > 2 then
			newCell.Size = Vector3.new(60, 50, 60)
		else
			newCell.Size = Vector3.new(30, 25, 30)
		end

		print("Cell location" .. clones .. ": " .. tostring(cellPosition))
	end
end

return CellGenerator