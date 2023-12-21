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

function Token.new()
    local t = {}
    t.content = ""
    t.type = Types.WHITESPACE
    setmetatable(t, {__index = Token})
    return t
end

function Token.debug(self)
    return "\nTOKEN: "..self.content.."\n"..Types[self.type].."\n"
end

function Token.updateContent(self, newContent)
    self.content = newContent
end

function Token.appendContent(self, x)
    self.content = self.content..x
end

function Token.updateType(self, newType)
    if Types[newType] ~= nil then
        self.type = newType
    end
end

return Token
