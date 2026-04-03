-- Weather :3
local WeatherData = {
	Measurements = {
		-- Values
		Temperature = 0,
		DewPoint = 0,
		CAPE_1km = 0,
		CAPE_3km = 0,
		CAPE_total=0,
		SRH_3km = 0,
		SRH_1km = 0,
		PWAT = 0,
		LapseRate_0_3km = 0,
		LapseRate_3_6km = 0,
		WindSpeed = {},
		WindDir = {},
	},
	Composites = {
		STP = 0,
		VTP = 0,
		SCP = 0,
		DCAPE = 0,
	}
}

-- generating
function WeatherData.generateAll()
	-- generate temp and dewpoint
	WeatherData.Measurements.Temperature = math.random(10, 40)
	WeatherData.Measurements.DewPoint = math.random(-10, 30)

	--fix dewpoint
	WeatherData:fixDewPoint()

	-- if cape1km > cape_3km
	WeatherData.Measurements.CAPE_total = math.random(500, 4500)
	local cape1km = math.random(
		math.floor(WeatherData.Measurements.CAPE_total * 0.1),   -- ìin 10%
		math.floor(WeatherData.Measurements.CAPE_total * 0.4)    -- max 40%
	)
	WeatherData.Measurements.CAPE_1km = cape1km
	WeatherData.Measurements.CAPE_3km = math.random(
		math.floor(WeatherData.Measurements.CAPE_total * 0.3),
		math.floor(WeatherData.Measurements.CAPE_total * 0.7)
	)

	-- SRH
	WeatherData.Measurements.SRH_3km = math.random(400, 700)
	local max1km = WeatherData.Measurements.SRH_3km
	local min1km = math.floor(max1km * 0.3)
	WeatherData.Measurements.SRH_1km = math.random(min1km,max1km)

	-- PWAT
	WeatherData.Measurements.PWAT = math.random(0, 200) / 100

	-- Gradiens
	WeatherData.Measurements.LapseRate_0_3km = math.random(0, 100) / 10
	WeatherData.Measurements.LapseRate_3_6km = math.random(0, 90) / 10

	-- Wind
	WeatherData:generateWinds()
end

function WeatherData:fixDewPoint()
	if self.Measurements.DewPoint > self.Measurements.Temperature then
		self.Measurements.DewPoint = self.Measurements.Temperature - math.random(1, 5)
	end
end

function WeatherData:generateWinds()
	local baseSpeed = math.random(5, 15)
	local baseDir = math.random(160, 220)

	self.Measurements.WindSpeed = {}
	self.Measurements.WindDir = {}

	for i = 1, 5 do
		self.Measurements.WindSpeed[i] = math.floor(baseSpeed * (1 + (i-1)*0.3) + math.random(-2, 5))
		self.Measurements.WindDir[i] = (baseDir + (i-1)*15 + math.random(-5, 10)) % 360
	end
end

-- generateall function
WeatherData:generateAll()

return WeatherData
