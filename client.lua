-- # Calculatrice en RageUI v2 by. General Zod (Bilal)\
local CalculatorDisplay = RageUI.CreateMenu("Calculatrice v1", "By. General Zod")
CalculatorDisplay.EnableMouse = false

RegisterCommand("debugCalc", function() -- Debug expression courrante
    debug = getExp(exp)
    core(currentEntry)
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~g~[DEBUG Calculator]\n~b~Expresion courrante :\n"..debug)
    DrawNotification(true, false)
end, false)

function addIntoExp(terme)
    exp = exp..terme
end

function getExp(lastEXP) 
    expToReturn = ""
    for i, j in pairs(currentEntry) do
        if(i == 100 | i == 200 | i == 300 | i == 400) then
            expToReturn = lastEXP..Operator[i]
        else
            expToReturn = lastEXP..j
        end
    end

    expToReturn = string.sub(expToReturn, 1, (string.len(expToReturn)-1))

    return expToReturn
end

function checkExpression(exp) 
    -- Si l'expression commence par )
    if(string.find(exp, ")") == 1) then
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~) ne peut pas etre mis au debut d'une expression")
        DrawNotification(true, false)
        result = 0
        return false
    end

    -- Si l'expression commence par ( sans rien apres
    if(exp == "(") then 
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~( ne peut pas etre solitaire")
        DrawNotification(true, false)
        result = 0
        return false
    end

    -- Si une parenthese n'est pas ferme
    if(string.find(exp, "%(") ~= nil) then
        if(string.find(exp, ")") == nil) then
            SetNotificationTextEntry("STRING")
            AddTextComponentString("~r~Vous n'avez pas fermer une parenthese")
            DrawNotification(true, false)
            result = 0
            return false
        else
            return true
        end
    end

    -- Si ) ne balade dans l'expression pour rien
    if(string.find(exp, ")") ~= nil) then
        if(string.find(exp, "%(") == nil) then
            SetNotificationTextEntry("STRING")
            AddTextComponentString("~r~) se balade dans votre expression pour rien")
            DrawNotification(true, false)
            result = 0
            return false
        else
            return true
        end
    end

    -- ENCORE NON FONCTIONNEL : Detection des '()' et des ')('
    -- Si l'expression contient )( (ex : 1+(3')('3)) normalement correct ici mais pas dans ce code
    -- if(string.find(exp, ")(") ~= nil) then
    --     print("detect !!!!!!!!!!!!!!!!!")
    --     SetNotificationTextEntry("STRING")
    --     AddTextComponentString("~r~)( se balade dans votre expression")
    --     DrawNotification(true, false)
    --     result = 0
    --     return false
    -- end

    -- Si l'expression contient () vide
    -- if(string.find(exp, "%()", 1, true) ~= nil) then
    --     SetNotificationTextEntry("STRING")
    --     AddTextComponentString("~r~Vous devez entrer des valeurs dans les ()")
    --     DrawNotification(true, false)
    --     result = 0
    --     return false
    -- end

    -- Si l'expression contient plusieurs fois (+, /, *, --) d'affile (malgres que le -- fonctionne)
    if(string.find(exp, "++", 1, true) ~= nil or string.find(exp, "**", 1, true) ~= nil or string.find(exp, "//", 1, true) ~= nil or string.find(exp, "--", 1, true)) then
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~ les doubles : -, +, *, / ne sont pas traitable")
        DrawNotification(true, false)
        result = 0
        return false
    end

    -- Si l'expression commence par -, +, *, / (sans parenthese pour encadrer le terme)
    if(string.find(exp, "-") == 1 or string.find(exp, "+") == 1 or string.find(exp, "/") == 1 or string.find(exp, "*") == 1) then
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~Veuillez mettre des parentheses si - est au debut\nRappel : /, * ne sont pas des indices")
        DrawNotification(true, false)
        result = 0
        return false
    end

    -- Division par 0 si une division (ex : 2+1/0 ou 2/0)
    if(string.find(exp, "/0") ~= nil or string.find(exp, "0/") ~= nil) then
        SetNotificationTextEntry("STRING")
        AddTextComponentString("~r~Divison par 0 impossible")
        DrawNotification(true, false)
        result = 0
        return false
    end

    return true
end

function core(stock)
    for c, v in pairs(stock) do 
        terms = terms..tostring(v)
    end

    if(checkExpression(terms) == false) then
        return "failed"
    end

    calculator = assert(load("return " .. terms)) -- Transformer la chaine en operation arithmetique
    result = calculator()
    if(result == nil) then
        result = 0
    end
    print("[Derniere Operation] => "..terms.. " = "..result)
    return result -- Resultat final (int)
end

function reset()
    result = 0
    exp = ""
    expToReturn = ""
    terms = ""

    for k in pairs (currentEntry) do
        currentEntry[k] = nil
    end
end

function RageUI.PoolMenus:Menus()
	CalculatorDisplay:IsVisible(function(Items) -- A mettre dans votre pool
        Items:AddSeparator("Nombres")
        Items:AddList("Nombre : ", {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, ListIndexNumber, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            -- n+1 a chaque fois 0 = [1], 1 = [2] etc...

			if(onListChange) then
                ListIndexNumber = Index
			end

            if(onSelected) then
                addIntoExp(Number[ListIndexNumber])
                table.insert(currentEntry, tonumber(Number[ListIndexNumber]))
            end
		end)

        Items:AddSeparator("Operateurs")
        Items:AddList("Operateur : ", {"+", "-", "/", "x"}, ListIndexOperator, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            -- [100] = +, [200] = -, [300] = /, [400] = x (*)
			if(onListChange) then
                ListIndexOperator = Index
			end

            if(onSelected) then
                addIntoExp(Operator[ListIndexOperator*100])
                table.insert(currentEntry, Operator[ListIndexOperator*100])
            end
		end)

        Items:AddSeparator("Parentheses")
        Items:AddList("Parenthese : ", {"(", ")"}, ListIndexParenthese, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
            -- [100] = +, [200] = -, [300] = /, [400] = x (*)
			if(onListChange) then
                ListIndexParenthese = Index
			end

            if(onSelected) then
                addIntoExp(Parenthese[ListIndexParenthese])
                table.insert(currentEntry, Parenthese[ListIndexParenthese])
            end
		end)


        Items:AddSeparator(" ")
        Items:AddButton("~g~Calculer", " ", { IsDisabled = false }, function(onSelected) 
            if(onSelected) then
                if(core(currentEntry) == "failed") then
                    SetNotificationTextEntry("STRING")
                    AddTextComponentString("~r~Calcul faux")
                    DrawNotification(true, false)
                    reset()
                else
                    SetNotificationTextEntry("STRING")
                    AddTextComponentString("~g~Resultat :\n= "..result)
                    DrawNotification(true, false)
                    reset()
                end
            end
        end)

        Items:AddButton("~r~Reinitialiser", " ", { IsDisabled = false }, function(onSelected) -- Efface l'expression courrante
            if(onSelected) then
                SetNotificationTextEntry("STRING")
                AddTextComponentString("~r~Reinitialisation de la calculatrice...")
                DrawNotification(true, false)
                reset()
            end
        end)

        Items:AddButton("~b~Expression : "..getExp(exp), " ", { IsDisabled = true }, function(onSelected) end) -- Affiche l'expression courrante
	end, function(Panels) end)
end

Keys.Register("K", "K", "Calculatrice", function() -- Defini sur la touche K
	RageUI.Visible(CalculatorDisplay, not RageUI.Visible(CalculatorDisplay))
end)

Citizen.CreateThread(function() 
    print("------- [Calculator] -------")
    print("par. "..owner)
    print(discord)
    print("Contactez moi sur discord en cas de probleme !")
    Citizen.Wait(1000)
    print("all done.")
end)