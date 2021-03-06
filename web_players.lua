function HandleRequest_Players ( Request )

	-- Define the content variable.
	local Content = ""

	-- If a player needed to be kicked, kick them.
	if (Request.Params["players-kick"] ~= nil) then
		local KickPlayerName = Request.Params["players-kick"]
		cRoot:Get():ForEachWorld(    -- For each world...
			function(World)
				World:QueueTask(         -- ... queue a task...
					function(a_World)
						World:DoWithPlayer(KickPlayerName,  -- ... to walk the playerlist...
							function (a_Player)
								a_Player:GetClientHandle():Kick("You were kicked from the game!")  -- ... and kick the player
							end
						)
					end
				)
			end
		)
	end
	
	-- Count all the players in the root.
	local playerCount = 0
	local playerCountCallback = function ( Player )
		playerCount = playerCount + 1
	end
	cRoot:Get():ForEachPlayer( playerCountCallback )
	
	Content = Content .. "<p>Total Players: " .. playerCount .. "</p>"
	
	-- Count the numbers of players per-world.
	local perWorldPlayersCallback = function ( World )
	
		-- Name the world:
		Content = Content .. "<h4>" .. cWebAdmin:GetHTMLEscapedString( World:GetName() ) .. "</h4>"
	
		-- Create a table for players to sit in.
		Content = Content .. "<table>"
	
		-- Go through the players in the world and add them to the table.
		local PlayerNum = 0
		local AddPlayerToTable = function( Player )
			PlayerNum = PlayerNum + 1
			Content = Content .. "<tr>"
			Content = Content .. "<td style='width: 10px;'>" .. PlayerNum .. ".</td>"
			Content = Content .. "<td>" .. cWebAdmin:GetHTMLEscapedString( Player:GetName() ) .. "</td>"
			Content = Content .. "<td><a href='?players-kick=" .. cWebAdmin:GetHTMLEscapedString( Player:GetName() ) .. "'>Kick</a></td>"
			Content = Content .. "</tr>"
		end
		World:ForEachPlayer( AddPlayerToTable )
	
		if PlayerNum == 0 then
			Content = Content .. "<tr><td>None</td></tr>"
		end
		
		Content = Content .. "</table>"
		Content = Content .. "<br>"
		
	end
	cRoot:Get():ForEachWorld( perWorldPlayersCallback )
	
	return Content
	
end
