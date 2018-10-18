function string:split(sep) 
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do 
		local c = string.sub(self,pos,pos) --return a single char at pos
		if (c == "") then break end
		if (c == " ") then
			-- ignore spaces at the beginning
			pos = pos+1
		elseif (c == '"') then
			-- quoted value (ignore separator within)
			local txt = ""
			repeat
				local startp,endp = string.find(self,'^%b""',pos)
				txt = txt..string.sub(self,startp+1,endp-1)
				pos = endp + 1
				c = string.sub(self,pos,pos) 
				if (c == '"') then txt = txt..'"' end 
				-- check first char AFTER quoted string, if it is another
				-- quoted string without separator, then append it
				-- this is the way to "escape" the quote char in a quote. example:
				-- value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
			until (c ~= '"')
			table.insert(res,txt)
			assert(c == sep or c == "")
			pos = pos + 1
		else	
			-- no quotes used, just look for the first separator
			local startp,endp = string.find(self,sep,pos)
			if (startp) then 
				table.insert(res,string.sub(self,pos,startp-1))
				pos = endp + 1
			else
				-- no separator found -> use rest of string and terminate
				table.insert(res,string.sub(self,pos))
				break
			end 
		end
	end
	return res
end

function readCSV(path, sep)
	--[[--
	Function to read a csv file and return a table of it's content
	--]]--
    sep = sep or ','
    local contents = {}
    local file = assert(io.open(path, "r"),"Can't find CSV file at specified path")
    for line in file:lines() do
        fields = line:split(sep)
        table.insert(contents, fields)
    end
    file:close()
    return contents
end

--[[--
data = readCSV("../QuizOgByt/sample.csv")
print(data[15][1])
print(data[15][2])
--]]--
