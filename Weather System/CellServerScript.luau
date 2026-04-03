--Modules
local WeatherData = require(game.ReplicatedStorage.WeatherModuleScript)
local CellGenerator = require(game.ReplicatedStorage.CellGenerator)
	
function spawnCellsFromWeather()
	local m = WeatherData.Measurements
	local c = WeatherData.Composites

	-- Count of cells are depends by PWAT and CAPE
	local cellCount = math.floor(m.CAPE_total / 1000) + math.floor(m.PWAT * 3)
	cellCount = math.clamp(cellCount, 1,100)

	print("Total cells" .. cellCount)
	
	CellGenerator.Cell(cellCount,WeatherData)
end

spawnCellsFromWeather()