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
	--[[-- Organizes the database ready for typesetting
	db.len is the number of cards
	each column is saved in db[1=FrontUpper,2=FronterLower][CardNumber]
		.type is the content type
		[rowNumber] is the content
	--]]--
	local orgdb = { len = rawdb.len-2 }
	local field = 0
	local number = 1
	orgdb.numOfCards = 0		
    for i, v in ipairs(rawdb[1]) do -- Looping through each column of data
		-- Order fields, so they are typeset in the right order
		if rawdb[1][i]:find("FrontUpper") then field = 1
			elseif rawdb[1][i]:find("FrontLower") then field = 2
			elseif rawdb[1][i]:find("BackUpper") then field = 3
			elseif rawdb[1][i]:find("BackLower") then field = 4
		end 
--		orgdb.numOfFields = 0
--		if orgdb.numOfFields < field then orgdb.numOfFields = field end
		-- detects if several columns of data for different cards is present
		number = tonumber( rawdb[1][i]:match('%d+') ) or 1 -- find the current number
		if orgdb.numOfCards < number then orgdb.numOfCards = number end
		if not orgdb[field] then orgdb[field] = {} end
		orgdb[field][number] = {type = rawdb[2][i]} -- Add type of data in the field
		for j=3,rawdb.len do -- Loop through all the rows
			table.insert( orgdb[field][number], rawdb[j][i] )
		end
    end
	return orgdb
end

-- Read data from csv file located in db_path, and organize it in table data.
db = organizeData( readCSV( db_path ) )

function db:genContent ()
	-- Method to generate card content, returns latex code
	self.row = self.row or 1 --initiate at first data row
	self.number = self.number or 1 
	local latex = ""
	if self[1] and self[1][self.number] and self[1][self.number][self.row] then
		--if upper field exists for current card, generate latex
		latex = latex .. "\\"..self[1][self.number].type.."{"..self[1][self.number][self.row].."}"
	end
	if self[2] and self[2][self.number] and self[2][self.number][self.row] then
		--if lower field exists for current card, generate latex
		latex = latex .. "\\tcblower "
		latex = latex .. "\\"..self[2][self.number].type.."{"..self[2][self.number][self.row].."}"
	end
	if self.number < self.numOfCards then --increment number, if there are more cards
		self.number = self.number + 1		
	else -- otherwiser, reset number and increment row
		self.number = 1
		self.row = self.row + 1
	end
	return latex
end
--[[--
print("db",db)

print("db[1]",db[1])

print("db[1][1]",db[1][1])

print("db[1][1].type",db[1][1].type)

for q,w in ipairs(db[1][1]) do
	print("for db[1][1]",q,w)
end

print("db[1][1][1]",db[1][1][1])
--]]--

