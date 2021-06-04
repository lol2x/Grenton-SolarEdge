local resp = Http_204->fotowoltaika_currentPowerFlow->ResponseBody

Http_204->SolarEdge_GRID = resp.siteCurrentPowerFlow.GRID.currentPower
Http_204->SolarEdge_PV = resp.siteCurrentPowerFlow.PV.currentPower
Http_204->SolarEdge_LOAD = resp.siteCurrentPowerFlow.LOAD.currentPower
if (resp.siteCurrentPowerFlow.connections[1].from == "LOAD" and resp.siteCurrentPowerFlow.connections[1].to == "Grid") then
	if (CLU_310->pompa_ciepla_1->Value == 0 and CLU_310->pompa_ciepla_2->Value == 0 and Http_204->SolarEdge_GRID > 0.4 and Http_204->SolarEdge_GRID < 1) then
		CLU_310->pompa_ciepla_1->SwitchOn(0)
	elseif (CLU_310->pompa_ciepla_1->Value == 0 and CLU_310->pompa_ciepla_2->Value == 0 and Http_204->SolarEdge_GRID > 1.7) then
		CLU_310->pompa_ciepla_2->SwitchOn(0)
	elseif (CLU_310->pompa_ciepla_1->Value == 1 and CLU_310->pompa_ciepla_2->Value == 0 and Http_204->SolarEdge_GRID > 1) then
		CLU_310->pompa_ciepla_2->SwitchOn(0)
	end
Http_204->SolarEdge_isExportingToGrid = true
else
	if(CLU_310->pompa_ciepla_2->Value == 1 and Http_204->SolarEdge_GRID < 1) then
		CLU_310->pompa_ciepla_1->SwitchOn(0)
	else
		CLU_310->pompa_ciepla_1->SwitchOff(0)
		CLU_310->pompa_ciepla_2->SwitchOff(0)
	end
Http_204->SolarEdge_isExportingToGrid = false
end

