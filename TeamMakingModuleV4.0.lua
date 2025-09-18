local Sensitivity = 0
local module = {}

module.BestMatch = function(PlayerTable)
	
	
	local NameTable = {}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
	local function CreateNamesTable()
		for i,v in pairs(PlayerTable) do
			table.insert(NameTable,i)
		end
		return NameTable
	end
	
	local function factorial(n)
			if (n == 0) then
				return 1
			else
				return n * factorial(n - 1)
			end
	end
			
	local function shallowCopy(original)
		local copy = {}
		for key, value in pairs(original) do
			copy[key] = value
		end
		return copy
	end
	
	CreateNamesTable()
	
	--Makes sure number is even
	local x = 0
	for i, v in pairs(PlayerTable) do
		x += 1
	end

	local IsOdd = false
	
	if x % 2 ~= 0 then
		x += 1
		IsOdd = true
	end	
	
		--Combinations
		local Comination1 = factorial(x)
		local Combination2 = factorial(x/2)
		local Combination3 = factorial( (x)-(x/2) )
		local formula = (Comination1) / (Combination2*Combination3)
		
		--Create Starting Table
		local BaseTable = {}
		for i = 1, x,1 do
			table.insert(BaseTable,i,i)
		end
		
		local TableA = {}
		local TableB = {}
		for i = 1, x/2,1 do
			table.insert(TableA,i,i)
			table.insert(TableB,i,i+x/2)
		end
		
		local function Sum(Table)
			local Num = 0
			for i,v in pairs(Table) do
				if (v == x and IsOdd)  then else
					local PlrName =NameTable[v] 
					Num += PlayerTable[PlrName]
				end
			end
			return Num
		end
		
		local function DifferenceFunct()
			local Diff = math.abs(Sum(TableA) - Sum(TableB))
			return Diff
		end
		
		local function CreateTableB()
			TableB = shallowCopy(BaseTable)
			for i,v in pairs(TableA) do
				table.remove(TableB,table.find(TableB,v))
			end
		end
		
		local function GetNextCombination()
			local function IfLastIsX(PosReciprocal)
				 if  TableA[#TableA-PosReciprocal] == x-PosReciprocal then
					IfLastIsX(PosReciprocal + 1)
				 else
					TableA[#TableA-PosReciprocal] = TableA[#TableA-PosReciprocal] + 1
					local z = 1
					for i = (#TableA-PosReciprocal)+1 ,#TableA,1 do
						TableA[i]  = TableA[#TableA-PosReciprocal] + z	
						z+= 1
					end
				 end
			end
			IfLastIsX(0)
			--TableA is Made, Make Table B
			CreateTableB()			
		end
		
		 local cont = true
		 local Difference = DifferenceFunct()
		 if Difference <= Sensitivity then
			cont = false
		end
		
		local Options = {}
		while #Options < ((formula / 2) - 1) and cont do
			table.insert(Options,{Difference,shallowCopy(TableA)})
			GetNextCombination() 	
			Difference = DifferenceFunct()
			if  Difference <= Sensitivity then
				--Found a Combination 
				cont = false
			end
		end	
-------------After cycling through all combinations-------------		
		local function ConvertTable(tbl)
			for i,v in pairs(tbl) do
				if v == x and IsOdd then 
					table.remove(tbl,table.find(tbl,v))
				else
					tbl[i] = NameTable[v] 
				end
			end
		end
		
		local function Final()
			CreateTableB()
			ConvertTable(TableA)
			ConvertTable(TableB)
			return TableA,TableB,Difference
		end
		
		if cont == false then
			return Final()
		else
			table.insert(Options,{Difference,shallowCopy(TableA)})
			local Lowest = math.huge
			local LowestIndex
			for i,v in pairs(Options) do
				if v[1] < Lowest then
					LowestIndex = i
					Lowest = v[1]
				end
			end
			TableA = Options[LowestIndex][2]
			Difference = Options[LowestIndex][1]
			return Final()
		end
end--function BestMatch
return module
