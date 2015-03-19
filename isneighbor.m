function val = isneighbor(trajStat_1,trajStat_2)
    if abs(trajStat_1.x - trajStat_2.x)<=1 && abs(trajStat_1.y - trajStat_2.y)<=1
        val = true;
    else
        val = false;
    end
end