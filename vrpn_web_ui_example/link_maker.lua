
local function makeURL(a)
	local page_name = "'" .. a.page_name .. "'" or "'Default Page Name'"
	local urlstr = a.server .. '?title=' .. page_name .. '&buttons=['
	for _, button in ipairs(a.buttons) do
		local button_str = '("\'' .. button.button_name .. '\'",' .. button.button_number .. '),'
		urlstr = urlstr .. button_str
	end
	urlstr = urlstr .. ']'
	return urlstr
end


my_url = makeURL{
	server = "http://127.0.0.1:5000/dynamic/index.html",
	page_name = "Title of Page",
	buttons = {
		{button_name = "Button 1", button_number = 1},
		{button_name = "Button 2", button_number = 2},
		{button_name = "Button 3", button_number = 3},
		{button_name = "Button 4", button_number = 4},
		{button_name = "Button 5", button_number = 5},
	},
}

print(my_url)