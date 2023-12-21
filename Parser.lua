local Lexer = require("Lexer")
local Token = require("TokenClass")

local parser = {}

local function create_table_instruction(listTokens) -- CREATE TABLE <name> (<value> <domain of the value>, ...)
    local create_table = {}

    if #listTokens < 5 then
        return "Missing arguments ! Minimum of the instruction is: 'CREATE TABLE <name of your table> ()'"
    end

    if listTokens[3]:GetType() ~= "IDENTIFIANT" then
        return "Write like a classic text for the name of your table !"
    end

    local tableName = listTokens[3]

    if listTokens[4]:GetType() ~= "OPERATOR" and listTokens[4]:GetContent() ~= "(" then
        return "Open '()' to give your possible values"
    end

    create_table["name"] = tableName:GetContent()
    create_table["values"] = {}

    local index = 5
    while listTokens[index]:GetType() ~= "OPERATOR" and listTokens[index]:GetContent() ~= ")" do
        if not listTokens[index] then
            return "Give a name to your value"
        end
        local valueName = listTokens[index]:GetContent()
        index = index + 1

        if not listTokens[index] then
            return "Give a domain to ".. valueName
        end
        local valueDomain = listTokens[index]:GetContent()
        index = index + 1

        local separator = listTokens[index]:GetContent()
        if separator ~= "," and #listTokens > index+1 and listTokens[index+1]:GetContent() ~= ")" then
            return "You have to put ',' after giving the value and his domain"
        end

        create_table["values"][valueName] = {}
        create_table["values"][valueName]["name"] = valueName
        create_table["values"][valueName]["domain"] = valueDomain

        if listTokens[index]:GetContent() == ")" then
            break
        end

        index = index + 1
    end

    return create_table
end

function parser.run(tokensList)
    if tokensList[1]:GetContent() == "CREATE" and tokensList[2]:GetContent() == "TABLE" then
        return create_table_instruction(tokensList)
    elseif tokensList[1]:GetContent() == "INSERT" and tokensList[2]:GetContent() == "INTO" then
        return insert_into_instruction(tokensList)
    else
        return "This instruction does not exist!"
    end
end



function insert_into_instruction(listTokens) -- INSERT INTO <name of the table> VALUES (*/<id>, <value>, ...)
    local insert_table = {}

    if #listTokens < 9 then
        return "Missing arguments ! Minimum of the instruction is: 'INSERT INTO <name of the table> VALUES (*/<id>, <value>)'"
    end

    if listTokens[3]:SetType() ~= "IDENTIFIANT" then
        return "Write the valid table name !"
    end

    local tableName = listTokens[3]

    insert_table["table_target"] = tableName:GetContent()

    if listTokens[4]:GetContent() ~= "VALUES" then
        return "You have to specify 'VALUES' after giving the table"
    end

    if listTokens[5]:GetContent() ~= "OPERATOR" and listTokens[4]:GetContent() ~= "(" then
        return "Open '()' to give your default values"
    end


    if listTokens[6]:GetContent() ~= "INT" and listTokens[6]:GetContent() ~= "*" then
        return "Give the target -> '*' for every players or give the ID of the Player"
    end

    if listTokens[7]:GetContent() ~= "," then
        return "You have to put ',' after giving the ID or '*'"
    end

    insert_table["target"] = listTokens[6]:GetContent()
    insert_table["values"] = {}

    local index = 8
    while listTokens[index]:GetType() ~= "OPERATOR" and listTokens[index]:GetContent() ~= ")" do
        if not listTokens[index] then
            return "Give the value"
        end

        if listTokens[index]:GetType() ~= "STRING"
        and listTokens[index]:GetType() ~= "INT"
        and listTokens[index]:GetType() ~= "DOUBLE"
        and listTokens[index]:GetType() ~= "BOOL"
        then
            return "Give a correct value !"
        end

        local currentValue = listTokens[index]:GetContent()
        table.insert(insert_table["values"], currentValue)
        index = index + 1

        local separator = listTokens[index]:GetContent()
        if separator ~= "," and #listTokens > index+1 and listTokens[index+1]:GetContent() ~= ")" then
            return "You have to put ',' after giving the value"
        end

        if listTokens[index]:GetContent() == ")" then
            break
        end

        index = index + 1
    end

    return insert_table
end

function parser.show(t, indent)
    indent = indent or 0
    for cle, valeur in pairs(t) do
        if type(valeur) == "table" then
            print(string.rep("  ", indent) .. cle .. ":")
            parser.show(valeur, indent + 1)
        else
            print(string.rep("  ", indent) .. cle .. ": " .. tostring(valeur))
        end
    end
end


return parser
