db_path = arg[2] or "sample.csv"
number = arg[3] or 1
colorsPath = "colors.csv"

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
    local contents = {len=0}
    local file = assert(io.open(path, "r"),"Can't find CSV file at specified path")
    for line in file:lines() do
		if (line == "") then break end -- Stop reading after first empty line
        fields = line:split(sep)
        table.insert(contents, fields)
		contents.len = contents.len + 1 
    end
    file:close()
    return contents
end

function loadColors(path,number_of_colors,format)
	-- Read colors from CSV file and return a string with definecolor latex commnads
	format = format or "HTML"
	number_of_colors = number_of_colors or 1
	local colors = readCSV(path)
	local res = ""
	local names = ""
	for i = 2, number_of_colors+1 do
		res = res .. ("\\definecolor{" .. colors[i][1] .. "}{" .. format .. "}{" .. colors[i][2] .. "}\n")
		names = names .. "{" .. colors[i][1] .. "},"
	end
	res = res .. "\\def\\farver{" .. names:sub(1, -2) .. "}"
	return res
end

function organizeData(rawdb)
	-- Organizes the database ready for typesetting
	-- db.len is the number of cards
	-- db.'ColumnName'.type is the content type
	-- db.'ColumnName'[#] is the content
	local orgdb = { len = rawdb.len-2, fields={} }
    for i, v in ipairs(rawdb[1]) do
		orgdb[rawdb[1][i]] = {type = rawdb[2][i]}
		orgdb.fields[i] = rawdb[1][i]
		for j=3,rawdb.len do
			table.insert( orgdb[rawdb[1][i]], rawdb[j][i] )
		end
    end
	return orgdb
end

-- Read data from csv file located in db_path, and organize it in table data.
db = organizeData( readCSV( db_path ) )

function db:genContent ()
	-- Method to generate card content, returns latex code
	self.row = self.row or 1 --initiate at first data row
	local latex = ""
	for i,v in ipairs(db.fields) do
		if self[v][self.row] then
			if v:find("Lower") then latex = latex .. "\\tcblower " end
			latex = latex .. "\\"..db[v].type.."{"..self[v][self.row].."}" 
		end
	end
	self.row = self.row + 1
	return latex
end


