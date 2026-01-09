function TopHop.ScanMapStruct(arg)
    local currentMapID = C_Map.GetBestMapForUnit(arg);
    local mapTable = {}
    if(currentMapID) then
        local currentMapDetails = C_Map.GetMapInfo(currentMapID)
        if(currentMapDetails) then
            local currentMapType = currentMapDetails.mapType
            local iteratingParentMapId = currentMapID
            for i = currentMapType, 1, -1 do
                local tempDetails = C_Map.GetMapInfo(iteratingParentMapId)
                if (tempDetails and tempDetails.mapType == i) then
					local mapCoordX, mapCoordY = TopHop.MapPositionToXYWithMapId(arg, tempDetails.mapID)
                    local worldSize = C_Map.GetMapWorldSize(tempDetails.mapID)
                    mapTable[i] = C_Map.GetMapInfo(iteratingParentMapId) -- UiMapDetails
					mapTable[i].x = mapCoordX -- 0-100 coord of the related map level
					mapTable[i].y = mapCoordY -- 0-100 coord of the related map level
					mapTable[i].worldSize = worldSize -- size of the related map level
                    iteratingParentMapId = tempDetails.parentMapID
                else
                    mapTable[i] = {}
                end
            end
        end
    end
    return mapTable
end
function TopHop.MapPositionToXYWithMapId(arg, mapID)
	if mapID and arg then
		local mapPos = C_Map.GetPlayerMapPosition(mapID, arg)
		if mapPos then
			return mapPos:GetXY()
		end
	end
	return 0, 0
end
function TestAndPrintScanMapStruct(arg)
	local mapTypeEnum = {"Cosmic", "World", "Continent", "Zone", "Dungeon", "Micro", "Orphan"}
	local colorYellow = "\124cffffff00"
	local colorGrey = "\124cff808080"
	local colorGreen = "\124cff88ff88"
	local colorEnd = "\124r"
    local mapTable = TopHop.ScanMapStruct(arg)
    --DevTools_Dump(mapTable)
	print(colorGrey.."============================"..colorEnd)
	print(colorYellow.."Map Structure dump: "..colorEnd)
    for i = 1, #mapTable, 1 do
        if (mapTable[i] and mapTable[i].name) then
            print(colorGreen..mapTable[i].mapType.." - "..mapTypeEnum[i+1]..colorEnd..": "..mapTable[i].name.."("..mapTable[i].mapID..")".." - "..colorGreen.."Size: "..colorEnd..mapTable[i].worldSize)
            print(colorGreen.."X: "..colorEnd..mapTable[i].x..", "..colorGreen.."Y: "..colorEnd..mapTable[i].y)
            print("\n")
        else
            print(colorGreen..i.." - "..mapTypeEnum[i+1]..colorEnd..":")
        end
    end

	local worldPos = TopHop.GetWorldPositionXY(arg)
	print(colorGrey.."============================"..colorEnd)
	print(colorYellow.."World position: "..colorEnd)
	print(colorGreen.."X: "..colorEnd..worldPos.x..", "..colorGreen.."Y: "..colorEnd..worldPos.y)
	print("\n")
end
function TopHop.GetWorldPositionXY(arg)
	local mapID = C_Map.GetBestMapForUnit(arg);	
    if(arg and mapID) then
		local mapCoordX, mapCoordY = TopHop.MapPositionToXYWithMapId(arg, mapID)
		local continentId, worldCoord = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(mapCoordX, mapCoordY))
		if (worldCoord) then
			return worldCoord
		end
	end
	return CreateVector2D(0, 0)
end

--TestAndPrintScanMapStruct("player")
-- SAMPLE - Outputs to chat:


-- ============================
-- Map Structure dump:
-- 1 - World: Azeroth(947) - Size: 111420.3828125
-- X: 0.29619640111923, Y: 0.50560200214386
--
-- 2 - Continent: Kalimdor(12) - Size: 36799.796875
-- X: 0.58373230695724, Y: 0.42785310745239
--
-- 3 - Zone: Orgrimmar(85) - Size: 1739.375
-- X: 0.5221871137619, Y: 0.5812754034996
--
-- 4 - Dungeon:
-- 5 - Micro:
-- 6 - Orphan: Orgrimmar(86) - Size: 362.08984375
-- X: 0.69226765632629, Y: 0.49563205242157
--
-- ============================
-- World position:
-- X: 1812.6293945312, Y: -4414.6333007812
-- 