% https://rivergages.mvr.usace.army.mil/WaterControl/stationinfo2.cfm?sid=01480
% https://rivergages.mvr.usace.army.mil/WaterControl/stationinfo2.cfm?sid=01160&fid=BTRL1
%load daily discharge
timeQw = readcell('mississippi_QT.xlsx','Sheet','BR_Discharge','Range','F2:F6341');
Qw = readmatrix('mississippi_QT.xlsx','Sheet','BR_Discharge','Range','E2:E6341');

%load dates for daily stage at Baton Rouge and Venice
timeStBR = readcell('mississippi_QT.xlsx','Sheet','BR_Stage','Range','A2:A12868');
timeStVe = readcell('mississippi_QT.xlsx','Sheet','venice_Stage','Range','A2:A12868');
%load daily stage at Baton Rouge and Venice
StBR = readmatrix('mississippi_QT.xlsx','Sheet','BR_Stage','Range','B2:B12868');
StVe = readmatrix('mississippi_QT.xlsx','Sheet','venice_Stage','Range','B2:B12868');

%interpolate daily data (nan)
temp = datetime(string(timeStBR));%cell2str, then str2datetime
tempTT = timetable(temp,StBR);
TT_StBR = retime(tempTT,'daily');

temp = datetime(string(timeStVe));%cell2str, then str2datetime
tempTT = timetable(temp,StVe);
TT_StVe = retime(tempTT,'daily');

t1 = datetime(string(timeStBR(1)));
t2 = datetime(string(timeStBR(end)));
temp = datetime(string(timeQw));%cell2str, then str2datetime
tempTT = timetable([t1;temp;t2],[nan;Qw;nan]);
TT_QwBR = retime(tempTT,'daily');

%duplicate discharge record for Venice
t1 = datetime(string(timeStVe(1)));
t2 = datetime(string(timeStVe(end)));
temp = datetime(string(timeQw));%cell2str, then str2datetime
tempTT = timetable([t1;temp;t2],[nan;Qw;nan]);
TT_QwVe = retime(tempTT,'daily');

%re-assign values from timetable
timeVe = datetime(string(TT_QwVe.Time));
timeBR = datetime(string(TT_QwBR.Time));

QwBR = TT_QwBR.Var1;
QwVe = TT_QwVe.Var1;

StBR = TT_StBR.StBR;
StVe = TT_StVe.StVe;
StVe(timeVe<'28-Jun-2015') = StVe(timeVe<'28-Jun-2015') - 1.84; % correct for datum adjustment

