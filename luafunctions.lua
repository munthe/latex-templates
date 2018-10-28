require("readCSV")

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

function genCardcontent (number)
	return "Kort" .. number 
end

-- print(loadColors("colors.csv",4))
