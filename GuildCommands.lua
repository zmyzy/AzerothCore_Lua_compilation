--- Scripts created by Poszer ---
--- What this script do: It's only for Guild Leaders (Owners). Actually they can summon guild member, send warning in middle of screen, send notifications and etc. ) ---
--- Config Start ---
local GSCD = 30 -- Summon Cooldown in seconds 
local ItemID = 36747 -- Your item ID ( In this case i'll use Surge Needle Teleporter item, you can put other if you want )
--- Config End ---

local GuildSummonCD = {}

function GuildTool_OnGossip(event, plr, item)
	if(plr:IsInGuild()) then
		if(plr:GetGUIDLow() == plr:GetGuild():GetLeader():GetGUIDLow()) then
			plr:GossipMenuAddItem(1, "Guild Notifications", 0, 2)
			plr:GossipMenuAddItem(1, "Guild Management", 0, 3)
			plr:GossipSendMenu(1, item, 1)
		else
			plr:SendBroadcastMessage("You are not the leader of this Guild!")
		end
	else
		plr:SendBroadcastMessage("You are not in a guild!")
	end
end
 
function GuildTool_OnSubGossip(event, plr, item, sender, intid, code)
	local Name = plr:GetName()
	local Guild = plr:GetGuild()

	if(GSCD >= 60) then
		GSCD_Timer = GSCD/60
		GSCD_Type = "Minutes"
	elseif(GSCD < 60) then
		GSCD_Timer = GSCD
		GSCD_Type = "Seconds"
	end
 
	if(intid == 1) then
		GuildTool_OnGossip(event, plr, item)
	end

	if(intid == 2) then -- Notification
		plr:GossipMenuAddItem(1, "Guild Chat Notification", 0, 10, 1, "Insert Guild Chat Notification into the code box.")
		plr:GossipMenuAddItem(1, "Guild Warning Notification", 0, 11, 1, "Insert Guild Warning Notification into the code box.")
		plr:GossipMenuAddItem(0, "[Back]", 0, 1)
		plr:GossipSendMenu(1, item)
	end

	if(intid == 3) then -- Management
		plr:GossipMenuAddItem(1, "Summon ALL Guild Members", 0, 12, 0, "Are you sure you want to summon ALL guild members?")
		plr:GossipMenuAddItem(1, "Summon a Guild Member", 0, 20, 1, "Insert Players name into the code box.")
		plr:GossipMenuAddItem(1, "Invite Player to Guild", 0, 13, 1, "Insert Players name into the code box.")
		plr:GossipMenuAddItem(1, "Promote New Guildmaster", 0, 15, 1, "Insert New Guildmaster's name into the code box.")
		plr:GossipMenuAddItem(1, "Disband Guild", 0, 16, 1, "To disband your guild, type DISBAND into the code box.")
		plr:GossipMenuAddItem(1, "[Back]", 0, 1)
		plr:GossipSendMenu(1, item)
	end

	if(intid == 10 or intid == 11) then
		for k, v in pairs(GetPlayersInWorld()) do
			print("Reach on: "..intid)
			local pCode = code
			if (v:GetGuildId() == plr:GetGuildId()) then
				if(intid == 10) then
					v:SendBroadcastMessage("|cFF33FF33[Guild Notification]: |cFFFFFFFF"..pCode.."")
				elseif(intid == 11) then
					v:SendAreaTriggerMessage("|cFF33FF33[Guild Warning]: |cFFFFFFFF"..pCode.."")
				end
			end
		end
		plr:GossipComplete()
	end

	if(intid == 12) then
		if GuildSummonCD[plr:GetName()] ~= nil and ((os.clock()-GuildSummonCD[plr:GetName()])) <= GSCD then
			plr:SendAreaTriggerMessage("|cFFFF0000You must wait "..GSCD_Timer.." "..GSCD_Type.." before using this function!")
			plr:GossipComplete()
		else
			GuildSummonCD[plr:GetName()] = os.clock()
			for k, v in pairs(GetPlayersInWorld()) do
				if (v:GetGuildId() == plr:GetGuildId()) then
					if(v:GetGUIDLow() ~= v:GetGuild():GetLeader():GetGUIDLow()) then
						v:Teleport(plr:GetMapId(), plr:GetX(), plr:GetY(), plr:GetZ(), plr:GetO())
						v:SendBroadcastMessage("You have been summoned by your Guild Master!")
					else
						plr:SendBroadcastMessage("All guild members have been summoned.")
					end
				end
			end
			plr:GossipComplete()
		end
	end
 
	if(intid == 13) or (intid == 14) or (intid == 15) then
		for k, v in pairs(GetPlayersInWorld()) do
			if(v:GetName() == code) then
				if(intid == 13) then
					if(v:IsInGuild() == true) and (v:GetGuildId() ~= plr:GetGuildId()) then
						plr:SendBroadcastMessage(code.." is already in a guild!")
					elseif(v:IsInGuild() == true) and (v:GetGuildId() == plr:GetGuildId()) then
						plr:SendBroadcastMessage(code.." is already in your guild!")
					elseif(v:IsInGuild() == false) and (v:GetName() == code) then
						plr:SendGuildInvite(v)
					end
				elseif(intid == 14) then
					if(v:GetGuildId() == plr:GetGuildId()) then
						plr:GetGuild():DeleteMember(v)
					elseif(v:GetGuildId() ~= plr:GetGuildId()) then
						plr:SendBroadcastMessage(code.." is not in your guild, or is not online.")
					end
				elseif(intid == 15) then
					if(v:IsInGuild() ~= true) or (v:GetGuildId() ~= plr:GetGuildId()) then
						plr:SendBroadcastMessage(code.." is not in your guild!")
					elseif(v:IsInGuild() == true) and (v:GetGuildId() == plr:GetGuildId()) then
						plr:GetGuild():SetLeader(v)
						plr:RemoveItem(ItemID, 1)
						plr:SendBroadcastMessage("You have promoted "..code.." to the new owner of "..plr:GetGuildName()..".")
						v:GetGuild():ChangeMemberRank(plr, 1)
						v:SendBroadcastMessage("Congratulations! You are now the new owner of "..plr:GetGuildName().."!")
						v:AddItem(ItemID, 1)
					end
				end
			end
		end
		plr:GossipComplete()
	end

	if(intid == 16) then
		local pCode = "DISBAND"
		if(code == pCode) then
			plr:GetGuild():Disband()
		else
			plr:SendBroadcastMessage("You did not type DISBAND into the code box.")
		end
		plr:GossipComplete()
	end
	
	if(intid == 17) or (intid == 18) then
		local pCode = code
			local GoldC = pCode*10000
		if(intid == 17) then
			if(tonumber(plr:GetGuild():GetBankMoney()) < GoldC) then
				plr:SendBroadcastMessage("Your guild bank does not have "..pCode.." Gold!")
			else
				plr:GetGuild():WithdrawBankMoney(plr, GoldC)
				plr:SendBroadcastMessage("You have successfully withdrawn "..pCode.." Gold from the Guild Bank.")
			end
		elseif(intid == 18) then
			if(plr:GetCoinage() < GoldC) then
				plr:SendBroadcastMessage("You do not have "..pCode.." Gold!")
			else
				plr:GetGuild():DepositBankMoney(plr, GoldC)
				plr:SendBroadcastMessage("You have successfully deposited "..pCode.." Gold to the Guild Bank.")
			end
		end
		plr:GossipComplete()
	end
	
	if(intid == 21) then
		plr:SendBroadcastMessage("Your Guild Bank contains "..tonumber(plr:GetGuild():GetBankMoney()/10000).." Gold.")
	end
	
	if(intid == 19) then
		for k, v in pairs(GetPlayersInWorld()) do
			local pCode = code
			if v:GetGuild():GetLeader() ~= nil then
				gLeader = v:GetGuild():GetLeader()
			else
				gLeader = "Guildmaster Offline"
			end
			if(v:GetName() == pCode) then
				if(v:IsInGuild() == true) then
					plr:SendBroadcastMessage("|cFF33FF33Player's Name:|cFFFFFFFF "..v:GetName().."")
					plr:SendBroadcastMessage("|cFF33FF33Player's Guild:|cFFFFFFFF "..v:GetGuildName().."")
					plr:SendBroadcastMessage("|cFF33FF33Player's Guildmaster:|cFFFFFFFF "..gLeader:GetName().."")
					plr:SendBroadcastMessage("|cFF33FF33Guild's Member Count:|cFFFFFFFF "..tonumber(v:GetGuild():GetMemberCount()).."")
				else
					plr:SendBroadcastMessage("|cFF33FF33Player's Name:|cFFFFFFFF "..v:GetName().."")
					plr:SendBroadcastMessage("|cFF33FF33Player's Guild:|cFFFFFFFF N/A")
				end
			end
		end
		plr:GossipComplete()
	end
	
	if(intid == 20) then
		for k, v in pairs(GetPlayersInWorld()) do
			if(v:GetName() == code) then
				if(v:GetGuildId() == plr:GetGuildId()) then
					v:Teleport(plr:GetMapId(), plr:GetX(), plr:GetY(), plr:GetZ(), plr:GetO())
					v:SendBroadcastMessage("You have been summoned by your Guild Master!")
				else
					plr:SendBroadcastMessage(""..pCode.." is not in your guild!")
				end
			end
		end
	end
end

RegisterItemGossipEvent(ItemID, 1, GuildTool_OnGossip)
RegisterItemGossipEvent(ItemID, 2, GuildTool_OnSubGossip)
