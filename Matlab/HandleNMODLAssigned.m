StartI=regexp(OneBigLine,'ASSIGNED\W*{');
StartI=min(StartIs(StartIs>StartI));
EndI=min(EndIs(EndIs>StartI));
AssignedStr=OneBigLine(StartI+1:EndI-1);
TmpLines=regexprep(AssignedStr,'\(.*?\)',' ');
ToksC=regexp(TmpLines,'\s*','split');
AllAssigned=ToksC(cellNumel(ToksC)>0)';

StartI=regexp(OneBigLine,'STATE\W*{');
StartI=min(StartIs(StartIs>StartI));
EndI=min(EndIs(EndIs>StartI));
StatesStr=OneBigLine(StartI+1:EndI-1);
ToksC= regexp(StatesStr,'\s*','split');
AllState=ToksC(cellNumel(ToksC)>0)';
if(isempty(AllState))
    AllStateLine=zeros(1,0);
    AllStateLineSeg='';
else
    AllStateLine=strcat('float@&', AllState);
    AllStateLine=strcat(AllStateLine,',');
    AllStateLine=[AllStateLine{:}];
    AllStateLine=strrep(AllStateLine,'@',' ');
    AllStateLine=AllStateLine(1:end-1);
    AllStateLineSeg=strcat('StatesM[',num2str(((1:numel(AllState))-1+StateStartVal)'));
    AllStateLineSeg=strcat(AllStateLineSeg,'][seg] ,');
    AllStateLineSeg=AllStateLineSeg';
    AllStateLineSeg=AllStateLineSeg(:)';
    AllStateLineSeg=strrep(AllStateLineSeg,'@',' ');
    AllStateLineSeg=AllStateLineSeg(1:end-1);
end

AssignedLine=find(strhas(Lines,'PARAMETER'));
StartL=AssignedLine;
EndL=min(EndLines(EndLines>StartL));
TmpLines=regexprep(Lines((StartL+1):(EndL-1)),'\(.*\)',' ');
TmpLines=regexprep(TmpLines,'<.*>',' ');
TmpLines=regexprep(TmpLines,'\s*','');
TmpLines=TmpLines(strhas(TmpLines,'='));
AllParameters=cell(1,numel(TmpLines));
for i=1:numel(TmpLines)
    AllParameters{i}=strtok(TmpLines{i},'=');
end
GlobalParamI=find(ismember(AllParameters,NeuronS.Global));
NonGlobalParamI=find(~ismember(AllParameters,NeuronS.Global));
CParamLines=cell(numel(GlobalParamI),1);
for i=1:numel(GlobalParamI)
    CParamLines{i}=[FTYPESTR ' ' TmpLines{GlobalParamI(i)} ';'];
end
GlobalsNotPredefined=setdiff( NeuronS.Global,AllParameters);
for i=1:numel(GlobalsNotPredefined)
    CParamLines{end+1}=[FTYPESTR ' ' GlobalsNotPredefined{i} ';'];
end
AllParameters=[AllParameters GlobalsNotPredefined];

AllParamLine='';
AllParamLineSeg='';
AllParamLineDeclare='';
AllParamLineCall='';
if(~isempty(AllParameters(NonGlobalParamI)))
    AllParamLine=strcat('float@', AllParameters(NonGlobalParamI));
    AllParamLine=strcat(AllParamLine,',');
    AllParamLine=[AllParamLine{:}];
    AllParamLine=strrep(AllParamLine,'@',' ');
    AllParamLine=AllParamLine(1:end-1);

    AllParamLineSeg=strcat('ParamsM[',num2str(((1:numel(NonGlobalParamI))-1+ParamStartVal)'));
    AllParamLineSeg=strcat(AllParamLineSeg,'][comp],');
    AllParamLineSeg=AllParamLineSeg';
    AllParamLineSeg=AllParamLineSeg(:)';
    AllParamLineSeg=strrep(AllParamLineSeg,'@',' ');
    AllParamLineSeg=AllParamLineSeg(1:end-1);
    AllParamLineDeclare=[',' AllParamLine];

    AllParamLineCall=strcat(AllParameters(NonGlobalParamI),',');
    AllParamLineCall=[AllParamLineCall{:}];
    AllParamLineCall=strrep(AllParamLineCall,'@',' ');
    AllParamLineCall=AllParamLineCall(1:end-1);
end

StateParamSeperator='';
if(~isempty(AllStateLine))
    StateParamSeperator=',';
end
ParamGlobalSeperator='';
if(~isempty(AllParamLine))
    ParamGlobalSeperator=',';
end

if(~exist('AllReadsNoReversals','var'))
    return;
end

OnlyRead='';
OnlyReadSeg='';
if(~isempty(NeuronS.OnlyReadsNoReversals))
    OnlyRead=strcat(', float>',NeuronS.OnlyReadsNoReversals);
    OnlyRead=strrep(OnlyRead,'>',' ');
    OnlyReadSeg=strcat(strcat(', ',NeuronS.OnlyReadsNoReversals),'[ seg ]');
    OnlyRead=[OnlyRead{:}];
    OnlyReadSeg=[OnlyReadSeg{:}];
end
WriteNoCurrent='';
WriteNoCurrentSeg='';
if(~isempty(NeuronS.WritesNoCurrents))
    WriteNoCurrent=strcat(', float &',NeuronS.WritesNoCurrents);
    WriteNoCurrentSeg=strcat(strcat(', ',NeuronS.WritesNoCurrents),'[ seg ]');
    WriteNoCurrent=[WriteNoCurrent{:}];
    WriteNoCurrentSeg=[WriteNoCurrentSeg{:}];
end
AdditionalWrites='';
AdditionalWritesSeg='';
AdditionalWritesC=setdiff(intersect(NeuronS.Writes,AllReadsNoReversals),NeuronS.WritesNoCurrents);
if(~isempty(AdditionalWritesC))
    AdditionalWrites=strcat(', float &',AdditionalWritesC);
    AdditionalWritesSeg=strcat(strcat(', ',AdditionalWritesC),'[ seg ]');
    AdditionalWrites=[AdditionalWrites{:}];
    AdditionalWritesSeg=[AdditionalWritesSeg{:}];
end

StatesAndParamsStr=[StateParamSeperator AllStateLine ParamGlobalSeperator AllParamLine OnlyRead WriteNoCurrent AdditionalWrites];
StatesAndParamsStrSeg=[StateParamSeperator AllStateLineSeg ParamGlobalSeperator AllParamLineSeg OnlyReadSeg WriteNoCurrentSeg AdditionalWritesSeg];
StatesAndParamsStrSeg=AddModelNameToFunctions(StatesAndParamsStrSeg,AllReadsNoReversals,ExtraStatesTrg);
Locals=setdiff(AllAssigned,['celsius' 'v' AllState' AllParameters Reads Writes]);
LocalsC{CurModI}=Locals';