local mdlscript=require(game.ReplicatedStorage.WeatherModuleScript)
--dont forget to add Atmosphere.Parent = Lighting and Clouds.Parent=Terrain
local atmosphere=game.Lighting.Atmosphere
local clouds=game.Workspace.Terrain:FindFirstChild("Clouds")

--Atmosphere_page
local function Atmosphere(temp, Td, pwat)
	if atmosphere.Haze then
		if temp == 20 and Td == 1 then -- desert
			atmosphere.Haze = 0.1
			atmosphere.Density = 0.1
		elseif temp == 20 and Td == 18 then -- heaven for tardigrada
			atmosphere.Haze = 0.8
			atmosphere.Density = 0.4
		else -- the usual calculation
			atmosphere.Haze = pwat * 0.5  -- pwat..
		end
	end

	if atmosphere.Density then
		atmosphere.Density = math.min(pwat * 0.3, 0.5)
	end
end

--Cloudls_page
local function Clouds()
	--cover
	local pwat = mdlscript.Measurements.PWAT	
	local tempDiff = mdlscript.Measurements.Temperature - mdlscript.Measurements.DewPoint

	-- Calculate coverage: from PWAT (normalize to 0-1)
	local coverFromPWAT = pwat / 1.5-- Divide by 1.5, because the max is usually 1.5-2.0

	-- Reduce the coverage if it is very dry (there is a big difference between T and Td)
	local drynessFactor = math.max(0, 1 - (tempDiff / 30)) -- When the difference is >30, the coverage tends to zero

	local finalCover = math.clamp(coverFromPWAT * drynessFactor, 0, 1)
	clouds.Cover = finalCover

	--Density
	local cape = mdlscript.Measurements.CAPE_total
	local lapse = (mdlscript.Measurements.LapseRate_0_3km + mdlscript.Measurements.LapseRate_3_6km) / 2

	-- CAPE affects density (we normalize it)
	local densityFromCape = math.min(cape / 3000, 1.0)
	-- Lapse Rate also adds density if > 7
	local lapseBonus = math.max(0, (lapse - 6) / 3)

	local finalDensity = math.clamp(densityFromCape + lapseBonus * 0.5, 0.2, 1.0)
	clouds.Density = finalDensity
end --Thanks for the function, ########

--calling CITY BOYY functions!
Clouds()
Atmosphere(mdlscript.Measurements.Temperature, mdlscript.Measurements.DewPoint, mdlscript.Measurements.PWAT)