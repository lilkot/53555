script_name("CallNoPhone")
script_author("lilkot")
script_version(2)
local sp  = require 'lib.samp.events'
local dlstatus = require('moonloader').download_status

local keys = {
	[1] = 2103,
	[2] = 2104,
	[3] = 2102,
	[4] = 2106,
	[5] = 2107,
	[6] = 2105,
	[7] = 2109,
	[8] = 2110,
	[9] = 2108,
	[0] = 2111,
	["call"] = 2096,
	["go"] = 2098
}


function update()
    local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- êóäà áóäåò êà÷àòüñÿ íàø ôàéëèê äëÿ ñðàâíåíèÿ âåðñèè
    downloadUrlToFile('https://raw.githubusercontent.com/lilkot/53555/master/CallNoPhone%20update', fpath, function(id, status, p1, p2) -- ññûëêó íà âàø ãèòõàá ãäå åñòü ñòðî÷êè êîòîðûå ÿ ââ¸ë â òåìå èëè ëþáîé äðóãîé ñàéò
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
      local f = io.open(fpath, 'r') -- îòêðûâàåò ôàéë
      if f then
        local info = decodeJson(f:read('*a')) -- ÷èòàåò
        updatelink = info.updateurl
        if info and info.latest then
          version = tonumber(info.latest) -- ïåðåâîäèò âåðñèþ â ÷èñëî
        if version > tonumber(thisScript().version) then -- åñëè âåðñèÿ áîëüøå ÷åì âåðñèÿ óñòàíîâëåííàÿ òî...
            lua_thread.create(goupdate) -- àïäåéò
        else -- åñëè ìåíüøå, òî
            update = false -- íå äà¸ì îáíîâèòüñÿ 
            sampAddChatMessage(('[Helper Update]:{FFFFFF} Ó âàñ ïîñëåäíÿÿ âåðñèÿ Helpera! Îáíîâëåíèå íå òðåáóåòñÿ!'),0x6495ED)
        end
        end
      end
    end
  end)
end

function goupdate()
    sampAddChatMessage(('[Helper Update]:{FFFFFF} Îáíàðóæåíî îáíîâëåíèå. AutoReload ìîæåò êîíôëèêòîâàòü. Îáíîâëÿþñü...'), 0x6495ED)
    sampAddChatMessage(('[Helper Update]:{FFFFFF} Òåêóùàÿ âåðñèÿ: '..thisScript().version..". Íîâàÿ âåðñèÿ: "..version), 0x6495ED)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- êà÷àåò âàø ôàéëèê ñ latest version
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        sampAddChatMessage(('[Helper Update]:{FFFFFF} Îáíîâëåíèå çàâåðøåíî!'), 0x6495ED)
        thisScript():reload()
    end
end)
end


function main()
    repeat wait(100) until isSampAvailable()
    update()
	sampRegisterChatCommand("call", scr)
	sampAddChatMessage("[Call No Phone]{1faee9} Çàãðóæåí {ffffff}[by lilkot]", 0xff2400)
	sampAddChatMessage("[Call No Phone]{1faee9} /call {ffffff}[Íîìåð]", 0xff2400)	-- Âûâîäèì ñîîáùåíèå â ÷àò
    wait(-1) -- Óñòàíàâëèâàåì áåñêîíå÷íîå îæèäàíèå
end

--Ñêèï äèàëîãà /phone [Âûáèðàåò ïåðâûé èç ñïèñêà]
function sp.onShowDialog(id, style, title, b1, b2, text)
	if id == 1000 then
			lua_thread.create(function()
			wait(1)
			sampCloseCurrentDialogWithButton(1) 
		end)
	end
end



function scr(param)
	local number = param:match("(%d+)")
	if tonumber(number) ~= " " then
		lua_thread.create(function()
			sampSendChat("/phone")
			sampSendDialogResponse(1000, 1, 0, 0)
			sampSendClickTextdraw(keys["go"])
function sp.onServerMessage(color, text) -- Óäàëåíèå õóéíè èç ÷àòà, êîãäà çâîíèøü ÷åðåç /call
	if text:find("Íîìåðà òåëåôîíîâ ãîñóäàðñòâåííûõ ñëóæá") and not text:find('ãîâîðèò') then
	return false
	end
	
	if text:find("111 -") and text:find('Ïðîâåðèòü áàëàíñ òåëåôîíà') then
	return false
	end

	if text:find("060 -") and text:find('Ñëóæáà òî÷íîãî âðåìåíè') then
	return false
	end
	
	if text:find("911 -") and text:find('Ïîëèöåéñêèé ó÷àñòîê') then
	return false
	end
	
	if text:find("912 -") and text:find('Ñêîðàÿ ïîìîùü') then
	return false
	end
	
	if text:find("913 -") and text:find('Òàêñè') then
	return false
	end
	
	if text:find("914 -") and text:find('Ìåõàíèê') then
	return false
	end

	if text:find("8828 -") and text:find('Ñïðàâî÷íàÿ öåíòðàëüíîãî áàíêà') then
	return false
	end
	
end
			parseNumber(number)
			sampSendClickTextdraw(keys["call"])
			sampAddChatMessage('[Call No Phone]{1faee9} Çâîíþ íà íîìåð - {ffffff}'..number, 0xff2400)
		end)
	end
end

function parseNumber(n)	
  local n = tostring(n)
  for i = 1, #n do
    number = n:sub(i, i)
		sampSendClickTextdraw(keys[tonumber(number)])
  end
end
