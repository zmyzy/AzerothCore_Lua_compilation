--- Azeroth Core Simple Character Tools lua script. 
--- Created by Poszer

local npcid = 500300;      --- Put your NPC ID ---
local fac_token = 34597;   --- Change Faction Cost (0 for no requirements)
local race_token = 34597;  --- Change Race Cost (0 for no requirements)
local name_token = 34597;  --- Change Name Cost (0 for no requirements)
local app_token = 34597;   --- Change Appearance Cost (0 for no requirements)

local function fr_gossip (unit, player, creature)
	player:GossipMenuAddItem(0, "|TInterface/ICONS/Achievement_character_human_female:35:35|tChange My Race", 0, 0)
	player:GossipMenuAddItem(0, "|TInterface/ICONS/Achievement_character_orc_male:35:35|tChange My Faction", 0, 1)
	player:GossipMenuAddItem(0, "|TInterface/ICONS/achievement_character_bloodelf_female:35:35|tChange My Appearance", 0, 2)
	player:GossipMenuAddItem(0, "|TInterface/ICONS/Achievement_character_gnome_male:35:35|tChange My Name", 0, 3)
  --player:GossipMenuAddItem(0, "|TInterface/ICONS/misc_arrowleft:35:35|tRemove my requests", 0, 4)
	player:GossipSendMenu(1, creature)
end

local function fr_selection (event,player,creature,sender,intid)
	if intid == 0 then
		if player:HasItem(race_token) == true or race_token == 0 then
			player:SetAtLoginFlag(128)
			player:SendAreaTriggerMessage("Relog to change your Race.")
			player:GossipComplete()
			if race_token ~= 0 then
				player:RemoveItem(race_token, 1)
			end
		else
		player:SendAreaTriggerMessage("You need 1x "..GetItemLink(race_token))
		end
	end

	
	if intid == 1 then
		if player:HasItem(fac_token) == true or fac_token == 0 then
			player:SetAtLoginFlag(64)
			player:SendAreaTriggerMessage("Relog to change your Faction.")
			player:GossipComplete()
			if fac_token ~= 0 then
				player:RemoveItem(fac_token, 1)
			end
		else
		player:SendAreaTriggerMessage("You need 1x "..GetItemLink(fac_token))
		end
	end
	
	
	if intid == 2 then
		if player:HasItem(app_token) == true or app_token == 0 then
			player:SetAtLoginFlag(8)
			player:SendAreaTriggerMessage("Relog to change your Appearance.")
			player:GossipComplete()
			if app_token ~= 0 then
				player:RemoveItem(app_token, 1)
			end
		else
		player:SendAreaTriggerMessage("You need 1x "..GetItemLink(app_token))
		end
	end
	if intid == 3 then
		if player:HasItem(name_token) == true or name_token == 0 then
			player:SetAtLoginFlag(1)
			player:SendAreaTriggerMessage("Relog to change your Name.")
			player:GossipComplete()
			if name_token ~= 0 then
				player:RemoveItem(name_token, 1)
			end
		else
		player:SendAreaTriggerMessage("You need 1x "..GetItemLink(name_token))
		end
	end
	
	--if intid == 4 then
	--player:SetAtLoginFlag(0)
	--player:SendAreaTriggerMessage("Requests removed")  -- NOT WORKING
	--player:GossipComplete()
	--end
end


RegisterCreatureGossipEvent(npcid, 1, fr_gossip)
RegisterCreatureGossipEvent(npcid, 2, fr_selection)
