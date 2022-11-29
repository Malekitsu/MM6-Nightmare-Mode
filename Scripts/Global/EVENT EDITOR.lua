--AEC=Assign Event by Click
function AEC(facetId, event)
	local f = Map.Facets[facetId]
--	if f.HasData then
		Map.FacetData[f.DataIndex].Event = event
		f.TriggerByClick = true
--	else
--		print("No data for facet " .. facetId)
--	end
end

--AES=Assign Event by Step
function AES(facetId, event)
	local f = Map.Facets[facetId]
--	if f.HasData then
		Map.FacetData[f.DataIndex].Event = event
		f.TriggerByStep = true
--	else
--		print("No data for facet " .. facetId)
--	end
end