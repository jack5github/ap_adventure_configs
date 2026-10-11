if game.GetMap() ~= 'hr_horrorween_1' then return end
hook.Add('EntityKeyValue', 'HW_DisableAntiCheat', function(ent, key, val)
	if ent:GetClass() ~= 'lua_run' or key ~= 'Code' then return end
	if --Scripts that block apAdventure testing
			string.StartsWith(val, 'function GAMEMODE') or
			val == 'for i,ply in pairs(player.GetAll()) do if (ply:IsValid()) then ply:GodDisable( ) end end' or
			val == 'local function DisableContextMenu( ply, property, ent ) if (ply:IsValid()) then return false else return true end end hook.Add( [[CanProperty]], [[DisableContextMenu]], DisableContextMenu )' or
			val == 'local function DisableNoclip( ply ) return false end hook.Add( [[PlayerNoClip]], [[DisableNoclip]], DisableNoclip )' or
			--Script that produces in-game Lua errors
			val == 'for i, ply in pairs(player.GetAll()) do if (ply:IsValid()) then ply:ConCommand([[mat_colorcorrection 1]]) end end' then
		return ''
	end
end)
