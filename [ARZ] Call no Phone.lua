script_name("CallNoPhone")
script_author("lilkot")
script_version(1)
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
    local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- куда будет качаться наш файлик для сравнения версии
    downloadUrlToFile('https://raw.githubusercontent.com/lilkot/53555/master/CallNoPhone%20update', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
      local f = io.open(fpath, 'r') -- открывает файл
      if f then
        local info = decodeJson(f:read('*a')) -- читает
        updatelink = info.updateurl
        if info and info.latest then
          version = tonumber(info.latest) -- переводит версию в число
        if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
            lua_thread.create(goupdate) -- апдейт
        else -- если меньше, то
            update = false -- не даём обновиться 
            sampAddChatMessage(('[Helper Update]:{FFFFFF} У вас последняя версия Helpera! Обновление не требуется!'),0x6495ED)
        end
        end
      end
    end
  end)
end

function goupdate()
    sampAddChatMessage(('[Helper Update]:{FFFFFF} Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...'), 0x6495ED)
    sampAddChatMessage(('[Helper Update]:{FFFFFF} Текущая версия: '..thisScript().version..". Новая версия: "..version), 0x6495ED)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        sampAddChatMessage(('[Helper Update]:{FFFFFF} Обновление завершено!'), 0x6495ED)
        thisScript():reload()
    end
end)
end


function main()
    repeat wait(100) until isSampAvailable()
    update()
	sampRegisterChatCommand("call", scr)
	sampAddChatMessage("[Call No Phone]{1faee9} Загружен {ffffff}[by lilkot]", 0xff2400)
	sampAddChatMessage("[Call No Phone]{1faee9} /call {ffffff}[Номер]", 0xff2400)	-- Выводим сообщение в чат
    wait(-1) -- Устанавливаем бесконечное ожидание
end

--Скип диалога /phone [Выбирает первый из списка]
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
function sp.onServerMessage(color, text) -- Удаление хуйни из чата, когда звонишь через /call
	if text:find("Номера телефонов государственных служб") and not text:find('говорит') then
	return false
	end
	
	if text:find("111 -") and text:find('Проверить баланс телефона') then
	return false
	end

	if text:find("060 -") and text:find('Служба точного времени') then
	return false
	end
	
	if text:find("911 -") and text:find('Полицейский участок') then
	return false
	end
	
	if text:find("912 -") and text:find('Скорая помощь') then
	return false
	end
	
	if text:find("913 -") and text:find('Такси') then
	return false
	end
	
	if text:find("914 -") and text:find('Механик') then
	return false
	end

	if text:find("8828 -") and text:find('Справочная центрального банка') then
	return false
	end
	
end
			parseNumber(number)
			sampSendClickTextdraw(keys["call"])
			sampAddChatMessage('[Call No Phone]{1faee9} Звоню на номер - {ffffff}'..number, 0xff2400)
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
