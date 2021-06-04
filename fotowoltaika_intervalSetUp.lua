local sunset = tonumber(string.sub(tostring(CLU_310->czujnik_dnia_nocy->SunsetLocal),1,2))*60+tonumber(string.sub(tostring(CLU_310->czujnik_dnia_nocy->SunsetLocal),4,5))
local sunrise = tonumber(string.sub(tostring(CLU_310->czujnik_dnia_nocy->SunriseLocal),1,2))*60+tonumber(string.sub(tostring(CLU_310->czujnik_dnia_nocy->SunriseLocal),4,5))

Http_204->timer_sprawdzanie_fotowoltaiki->SetTime(math.floor((sunset-sunrise)*60000/290))

if(CLU_310->Time > CLU_310->czujnik_dnia_nocy->SunriseLocal and CLU_310->Time < CLU_310->czujnik_dnia_nocy->SunsetLocal) then
  Http_204->fotowoltaika_currentPowerFlow->SendRequest()
  Http_204->timer_sprawdzanie_fotowoltaiki->Start()
end