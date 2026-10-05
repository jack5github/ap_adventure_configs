local END_TRIGGER_ID = 1324

return {
	PostCfgLoad = function(self)
		if APADV_ENTRNAME == 'Octagonal Platform' then
			hook.Add('AcceptInput', 'CV2_PreventBarsFromExit', function(ent, input, activ, callr)
				if IsValid(callr) and callr:GetClass() == 'logic_auto' and ent:GetName() == 'overlays' then
					hook.Remove('AcceptInput', 'CV2_PreventBarsFromExit')
					return true
				end
			end)
		end
		ents.GetMapCreatedEntity(END_TRIGGER_ID):Fire('Kill')
	end,

	CfgUnload = function(self)
		hook.Remove('AcceptInput', 'CV2_PreventBarsFromExit')
	end
}
