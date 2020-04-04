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
    local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- ���� ����� �������� ��� ������ ��� ��������� ������
    downloadUrlToFile('https://raw.githubusercontent.com/lilkot/53555/master/CallNoPhone%20update', fpath, function(id, status, p1, p2) -- ������ �� ��� ������ ��� ���� ������� ������� � ��� � ���� ��� ����� ������ ����
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
      local f = io.open(fpath, 'r') -- ��������� ����
      if f then
        local info = decodeJson(f:read('*a')) -- ������
        updatelink = info.updateurl
        if info and info.latest then
          version = tonumber(info.latest) -- ��������� ������ � �����
        if version > tonumber(thisScript().version) then -- ���� ������ ������ ��� ������ ������������� ��...
            lua_thread.create(goupdate) -- ������
        else -- ���� ������, ��
            update = false -- �� ��� ���������� 
            sampAddChatMessage(('[Helper Update]:{FFFFFF} � ��� ��������� ������ Helpera! ���������� �� ���������!'),0x6495ED)
        end
        end
      end
    end
  end)
end

function goupdate()
    sampAddChatMessage(('[Helper Update]:{FFFFFF} ���������� ����������. AutoReload ����� �������������. ����������...'), 0x6495ED)
    sampAddChatMessage(('[Helper Update]:{FFFFFF} ������� ������: '..thisScript().version..". ����� ������: "..version), 0x6495ED)
    wait(300)
    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- ������ ��� ������ � latest version
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        sampAddChatMessage(('[Helper Update]:{FFFFFF} ���������� ���������!'), 0x6495ED)
        thisScript():reload()
    end
end)
end


function main()
    repeat wait(100) until isSampAvailable()
    update()
	sampRegisterChatCommand("call", scr)
	sampAddChatMessage("[Call No Phone]{1faee9} �������� {ffffff}[by lilkot]", 0xff2400)
	sampAddChatMessage("[Call No Phone]{1faee9} /call {ffffff}[�����]", 0xff2400)	-- ������� ��������� � ���
    wait(-1) -- ������������� ����������� ��������
end

--���� ������� /phone [�������� ������ �� ������]
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
function sp.onServerMessage(color, text) -- �������� ����� �� ����, ����� ������� ����� /call
	if text:find("������ ��������� ��������������� �����") and not text:find('�������') then
	return false
	end
	
	if text:find("111 -") and text:find('��������� ������ ��������') then
	return false
	end

	if text:find("060 -") and text:find('������ ������� �������') then
	return false
	end
	
	if text:find("911 -") and text:find('����������� �������') then
	return false
	end
	
	if text:find("912 -") and text:find('������ ������') then
	return false
	end
	
	if text:find("913 -") and text:find('�����') then
	return false
	end
	
	if text:find("914 -") and text:find('�������') then
	return false
	end

	if text:find("8828 -") and text:find('���������� ������������ �����') then
	return false
	end
	
end
			parseNumber(number)
			sampSendClickTextdraw(keys["call"])
			sampAddChatMessage('[Call No Phone]{1faee9} ����� �� ����� - {ffffff}'..number, 0xff2400)
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
