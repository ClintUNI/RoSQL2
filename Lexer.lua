local Token = require("TokenClass")

Lexer = {}

local function OverToken(currentToken, listTokens)
	if currentToken:GetType() ~= "WHITESPACE" then
		table.insert(listTokens, currentToken)
	end
	return token.new(), listTokens
end

function Lexer.ParseCode(code)
	local allTokens = {}
	local currentToken = token.new()

	for i = 1, #code do
		local char = code:sub(i, i)
		if char == "(" or char == ")" or char == ',' then
			currentToken, allTokens = OverToken(currentToken, allTokens)
			currentToken:SetType("OPERATOR")
			currentToken:AppendToContent(char)
			currentToken, allTokens = OverToken(currentToken, allTokens)
		elseif char == '0' or char == '1' or char == "2" or char == "3" or char == "4" or char == "5" or char == "6" 
        or char == "7" or char == "8" or char == "9" then
			if currentToken:GetType() == "DOUBLE" then
				currentToken:AppendToContent(char)
			else
				currentToken:SetType("INT")
				currentToken:AppendToContent(char)
			end
		elseif char == '.' and currentToken.type == "INT" then
			currentToken:SetType("DOUBLE")
			currentToken:AppendToContent(char)
		elseif char == '"' or char == "'" then
			if currentToken:GetType() == "WHITESPACE" then
				currentToken:SetType("POSSIBLE_STRING")
			elseif currentToken:GetType() == "POSSIBLE_STRING" then
				currentToken:SetType("STRING")
				currentToken, allTokens = OverToken(currentToken, allTokens)
			end
		elseif char == ' ' then
			if currentToken:GetType() ~= "POSSIBLE_STRING" then
				currentToken, allTokens = OverToken(currentToken, allTokens)
			end
		else
			if currentToken:GetType() == "WHITESPACE" or currentToken:GetType() == "INT"
            or currentToken:GetType() == "DOUBLE" then
				currentToken, allTokens = OverToken(currentToken, allTokens)
				currentToken:SetType("IDENTIFIANT")
			end
			currentToken:AppendToContent(char)
		end
	end

	currentToken, allTokens = OverToken(currentToken, allTokens)

	for i = 1, #allTokens do
		token = allTokens[i]
		if token:GetType() == "IDENTIFIANT" and (token:GetContent() == "true" or token:GetContent() == "false") then
			token:SetType("BOOL")
		end
	end

	return allTokens
end

function Lexer.showTokens(tokensList: {})
	for i, aToken in pairs(tokensList) do
		print("i: " .. i .. ", ".. aToken:GetContent())
	end
end

return Lexer
