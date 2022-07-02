owner = "General Zod"
discord = "Bilaal#7175"

-- Calculatrice
ListIndexNumber = 1 -- Ou le curseur va etre dans Nombres
ListIndexOperator = 1 -- Ou le curseur va etre dans Operateurs
ListIndexParenthese = 1 -- Ou le curseur va etre dans Parenthese

-- Pour les listes
Operator = { --Index*100
    [100] = "+",
    [200] = "-",
    [300] = "/",
    [400] = "*"
}

Number = { -- n+1
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4,
    [6] = 5,
    [7] = 6,
    [8] = 7,
    [9] = 8,
    [10] = 9
}

Parenthese = {
    [1] = "(",
    [2]  = ")"
}

-- relatif aux enregistrement pour calcul
currentEntry = {} -- Stockage des termes dans un tableau
result = 0 -- Resultat a l'appuie sur "Calculer"
exp = "" -- Expression entiere
expToReturn = "" -- Expression entiere v2
terms = "" -- Contenant du terms a calculer
i = 1 -- boucle