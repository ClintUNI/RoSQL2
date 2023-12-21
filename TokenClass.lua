Types = {
	WHITESPACE = "WHITESPACE",
	IDENTIFIANT = "IDENTIFIANT",
	INT = "INT",
	DOUBLE = "DOUBLE",
	POSSIBLE_STRING = "POSSIBLE_STRING",
	STRING = "STRING",
	BOOL = "BOOL",
	OPERATOR = "OPERATOR"
}

Token = {}
Token.__index = Token

function Token.new()
    local self: { [string]: any } = setmetatable({}, Token)

    local content: string = ""

    local type: string = Types.WHITESPACE

    function self:SetType(newType: string)
        type = Types[newType] or type
    end

    function self:GetType(): string
        return type
    end
    
    function self:SetContent(newContent: string)
        content = newContent
    end

    function self:AppendToContent(additionalContent: string)
        content = content .. additionalContent
    end

    function self:GetContent(): string
        return content
    end

    return self
end

function Token.debug(self)
    return "\nTOKEN: " .. self:GetContent() .. "\n" .. Types[self:GetType()] .. "\n"
end


return Token
