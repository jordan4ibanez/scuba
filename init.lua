--todo: air tank

scuba = {
  huds = {}
}

scuba.set = function(defs)
	if scuba.huds[defs.player][1] == nil then
      local hud_id=defs.player:hud_add({
        hud_elem_type = "image",
        position = {x = 0.5, y = 0.5},
        scale = {
          x = -100,
          y = -100
        },
        text = "scuba.png"
      })
      scuba.huds[defs.player][1] = hud_id;
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

--if there's no armor slots, player has to hold the item to use it
if minetest.get_modpath("3d_armor") == nil then
	minetest.register_globalstep(function(dtime)
		for _,player in ipairs(minetest.get_connected_players()) do
			if player:get_wielded_item():to_table() ~= nil then
				if player:get_wielded_item():to_table().name == "scuba:scuba_helmet" then
					scuba.set({
						player = player
					})
					player:set_breath(10)
				else
					scuba.del({
						player = player
					})
				end
			end
		end
	end)
end


minetest.register_on_joinplayer(function (player)
  scuba.huds[player] = {}
end)

minetest.register_craftitem("scuba:scuba_helmet", {
	description = "Scuba Helmet",
	inventory_image = "scuba.png",
})
