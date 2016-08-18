--todo: air tank

scuba = {
  huds = {}
}

scuba.set = function(defs)
	--set the scuba hud
	if scuba.huds[defs.player][1] == nil then
		local hud_id=defs.player:hud_add({
		hud_elem_type = "image",
		position = {x = 0.5, y = 0.5},
		scale = {
			x = -101,
			y = -101
			},
			text = "scuba.png"
		})
		scuba.huds[defs.player][1] = hud_id;
	elseif not string.match(armor["textures"][defs.player:get_player_name()].armor, "scuba_helmet.png") then
		local player = defs.player
		local armor_texture = armor["textures"][player:get_player_name()].armor
		armor_texture = armor_texture.."^scuba_helmet.png"
		armor["textures"][player:get_player_name()].armor = armor_texture
		armor.update_player_visuals(armor,player)
		
		--attempt to update the preview
		local preview = armor["textures"][player:get_player_name()].preview
		print(dump(armor["textures"][player:get_player_name()]))
		
		preview = preview.."^scuba_helmet.png"
		
		armor["textures"][player:get_player_name()].preview = preview
		
		
	end
	
end

scuba.add = function (defs)
  defs.darkness = math.max(defs.darkness + #scuba.huds[defs.player], 0)
  scuba.set(defs)
end
scuba.del = function(defs)
	if scuba.huds[defs.player][1] ~= nil then
		-- removing huds
		defs.player:hud_remove(scuba.huds[defs.player][1])
		scuba.huds[defs.player][1] = nil
	end
end
scuba.remove = function (defs)
  defs.darkness = math.max(defs.darkness + #scuba.huds[defs.player], 0)
  scuba.del(defs)
end

--make this do something more efficient
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local inv = player:get_inventory()
		for i=1, 6 do
			local stack = inv:get_stack("armor", i)
			local item = stack:get_name()
			if item == "scuba:scuba_helmet" then
				scuba.set({player = player})
				player:set_breath(10)
				return
			end
		end
		scuba.del({player = player})
	end
end)

minetest.register_on_joinplayer(function (player)
  scuba.huds[player] = {}
end)

minetest.register_craftitem("scuba:scuba_helmet", {
	description = "Scuba Helmet",
	inventory_image = "scuba_item.png",
})
