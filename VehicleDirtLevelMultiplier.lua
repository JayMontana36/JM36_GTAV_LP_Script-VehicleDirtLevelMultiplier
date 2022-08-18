JM36.CreateThread(function()
	local GetVehicleDirtLevel = GetVehicleDirtLevel
	local SetVehicleDirtLevel = SetVehicleDirtLevel
	
	local math_min = math.min
	
	local Multiplier
	do
		local config = configFileRead("VehicleDirtLevelMultiplier.ini")
		local _Multiplier = tonumber(config.Multiplier or 0)
		Multiplier = (_Multiplier > 0 and _Multiplier) or 0.25
	end
	
	local Vehicle = Info.Player.Vehicle
	
	local LastVehicleId, LastVehicleDirtLevel
	
	local yield = JM36.yield
	while true do
		if Vehicle.IsIn then
			local Vehicle_Id = Vehicle.Id
			local VehicleDirtLevel = GetVehicleDirtLevel(Vehicle_Id)
			if Vehicle_Id ~= LastVehicleId then
				LastVehicleId = Vehicle_Id
				LastVehicleDirtLevel = VehicleDirtLevel
			end
			if VehicleDirtLevel > LastVehicleDirtLevel then
				VehicleDirtLevel = (VehicleDirtLevel - LastVehicleDirtLevel) * Multiplier
				LastVehicleDirtLevel = math_min(LastVehicleDirtLevel + VehicleDirtLevel, 15.0)
				SetVehicleDirtLevel(Vehicle_Id, LastVehicleDirtLevel)
			end
		end
		yield()
	end
end)