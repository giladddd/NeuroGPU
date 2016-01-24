function parseNrnInitmodelNewWithCellArrs (modLines, suffix, isPointProcess, ppInSegments, numOfSegs,...
    numConstsPerModelPerSeg, numConstsPerModelAllSeg,...
    numVarsPerModelPerSeg, numVarsPerModelAllSegs,...
     varValueMap, varsAndConstsNames, compSegsIndexArr)
%Function Name: parseNrnInitmodel
%INPUT: cell arr representing mod file line, the model's suffix.
%OUTPUT: No output. parse the mod file lines and generates the
%nrnInitModel_ function.

def_generalMatlabStr;
def_generalNmodlStr;
INDEX_STR = 'ind';

firstLine = ['function [' CONSTS_PER_MODEL_PER_SEG_STR ', ' CONSTS_PER_MODEL_ALL_SEG_STR ', ' ...
    VARS_PER_MODEL_PER_SEG_STR ', ' VARS_PER_MODEL_ALL_SEG_STR ', ' VARS_ALL_MODEL_PER_SEG_STR '] = '...
    NRN_INITMODEL_STR suffix ' (' CONSTS_ALL_MODEL_ALL_SEG_STR ', ' VARS_ALL_MODEL_PER_SEG_STR ', '...
    HAS_MODEL_VAR_STR ', ' V_PER_SEG_STR ', ' NUM_SEGS_STR ')'];



%consts and vars initialization line based on the mdl/global csv files.

%initialize constsPerModelPerSeg & varsPerModelPerSeg
constOrVarArrStr{1} = CONSTS_PER_MODEL_PER_SEG_STR;
constOrVarArrStr{2} = VARS_PER_MODEL_PER_SEG_STR;

numOfComps = size(compSegsIndexArr,1);
for varTypeInd=1:2
    varsStr = varsAndConstsNames.(constOrVarArrStr{varTypeInd});
    numOfVars = numel(varsStr);
    assignValueLines{varTypeInd} = cell(numOfVars*numOfComps, 1);
    for varNameInd=1:numOfVars
        varName = varsStr(varNameInd);
        varIndexInInitmodelFile = [char(varName) Consts.VAR_INDEX_SUFFIX_STR];
        varNameWithSuffix = [char(varName) '_' suffix];
        if (~isfield(varValueMap, varNameWithSuffix))
            continue;
        end
        for compInd = 1:numOfComps
            compStartSegStr =  num2str(compSegsIndexArr(compInd,Consts.COMP_START_SEG_IND));
            compEndSegStr = num2str(compSegsIndexArr(compInd,Consts.COMP_END_SEG_IND));
            valueForComp = varValueMap.(varNameWithSuffix)(compInd);
            %if this compartment doesn't contain this model than skip this
            %line
            if isnan(valueForComp)
                continue;
            end
            varValueForCompStr = num2str(valueForComp);
            newLineIndex = (varNameInd-1)*numOfComps+compInd;
            line = [constOrVarArrStr{varTypeInd} '(' compStartSegStr ':' compEndSegStr ...
                ', ' varIndexInInitmodelFile ') = ' varValueForCompStr];
            assignValueLines{varTypeInd}{newLineIndex} = line;

        end
    end
end

%initialize constsPerModelAllSeg & varsPerModelAllSeg
constOrVarArrStr{3} = CONSTS_PER_MODEL_ALL_SEG_STR;
constOrVarArrStr{4} = VARS_PER_MODEL_ALL_SEG_STR;

for varTypeInd=3:4
    varsStr = varsAndConstsNames.(constOrVarArrStr{varTypeInd});
    numOfVars = numel(varsStr);
    assignValueLines{varTypeInd} = cell(numOfVars, 1);
    for varNameInd=1:numOfVars
        varName = varsStr(varNameInd);
        varIndexInInitmodelFile = [char(varName) Consts.VAR_INDEX_SUFFIX_STR];
        varNameWithSuffix = [char(varName) '_' suffix];
        if (~isfield(varValueMap, varNameWithSuffix))
            continue;
        end
            %go through all comps if this var/consts is related to a
            %specific model that on a special compartment
            for compInd=1:numOfComps
               valueForComp = varValueMap.(varNameWithSuffix)(compInd);
               if (~isnan(valueForComp))
                   break;
               end
            end
            %if var is nan for al compartment than something is not good so
            %don't make a line. this shouldn't happen
            if (isnan(valueForComp))
                   continue;
            end
            varValueForCompStr = num2str(valueForComp);
            newLineIndex = varNameInd;
            line = [constOrVarArrStr{varTypeInd} '(' varIndexInInitmodelFile ') = ' varValueForCompStr];
            assignValueLines{varTypeInd}{newLineIndex} = line;
    end
end

%unite all the lines for all the var types
totalAssignValueLines = [assignValueLines{1}; assignValueLines{2}; ...
                       assignValueLines{3}; assignValueLines{4}; ];                   
%delete empty lines and transpose
totalAssignValueLines = totalAssignValueLines(~cellfun('isempty',totalAssignValueLines)).';
              


parameterBlockLines = getBlock(PARAMETER_BLOCK_STR, modLines, OPEN_BLOCK_MOD_STR, CLOSE_BLOCK_MOD_STR);
parameterBlockLines = regexprep(parameterBlockLines, PARAMETER_BLOCK_STR, '');
parameterBlockLines = deleteUselessLines(parameterBlockLines);

initialBlockLines = getBlock(INITIAL_BLOCK_STR, modLines, OPEN_BLOCK_MOD_STR, CLOSE_BLOCK_MOD_STR);
initialBlockLines = regexprep(initialBlockLines, INITIAL_BLOCK_STR, '');
initialBlockLines = deleteUselessLines(initialBlockLines);

parameterBlockLines = deleteUnits(parameterBlockLines);

outputVarsStr = [VARS_PER_MODEL_PER_SEG_STR '(' INDEX_STR ', ' ALL_DIMENSION_STR ' ), ' VARS_PER_MODEL_ALL_SEG_STR ', ' VARS_ALL_MODEL_PER_SEG_STR '(' INDEX_STR ', ' ALL_DIMENSION_STR ' )'];
inputVarsStr = [outputVarsStr ', ' CONSTS_PER_MODEL_PER_SEG_STR ', '...
    CONSTS_PER_MODEL_ALL_SEG_STR ', ' CONSTS_ALL_MODEL_ALL_SEG_STR];

PPLines = {};
if(strcmp(suffix,'stim'))
    fidTopo = fopen('../../../../Neuron/printCell/Amit/Output/64T.csv');
    cd('../../../../Matlab');   %readForkTopology neeeds the current folder to be matlab.
    [Neuron ~] = ReadKForkTopology(fidTopo);
    cd('Amit/Parsing Utils/Parsed Funcs');  %retrun to the current folder for the output files.

    numOfComps = numel(ppInSegments);
    for compInd=1:numOfComps;
        if (isempty(ppInSegments{compInd}))
           continue 
        end
        %for every segments that contain a stim inside the compartment
        numOfSegsWithStimInComp = numel(ppInSegments{compInd}(1,:));
        for i=1:numOfSegsWithStimInComp
            segInd = ppInSegments{compInd}(1,i);
            PPLines{end+1}=['constsPerModelPerSeg(' num2str(segInd) ', del_index) = ' num2str(ppInSegments{compInd}(2,i))];
            PPLines{end+1}=['constsPerModelPerSeg(' num2str(segInd) ', dur_index) = ' num2str(ppInSegments{compInd}(3,i))];
            PPLines{end+1}=['constsPerModelPerSeg(' num2str(segInd) ', amp_index) = ' num2str(ppInSegments{compInd}(4,i))];
            PPLines{end+1}=['constsPerModelPerSeg(' num2str(segInd) ', area_index) = ' num2str(Neuron.Areas(compInd))];
        end
        
    end
end

segsLoopOpenLine = cellstr(['for ' INDEX_STR '=1:' NUM_SEGS_STR]);   
segsLoopBody{1} =  ['if (' HAS_MODEL_VAR_STR '(' INDEX_STR '))'];
segsLoopBody{2} =  ['[' outputVarsStr '] = ' INITIAL_LOCAL_FUNC_NAME_STR '(' inputVarsStr ', ' V_PER_SEG_STR '(' INDEX_STR '))'];
segsLoopBody{3} = 'end';
segsLoopCloseLine = cellstr('end');

initialLocalFuncFirstLine = cellstr(['function [' VARS_OUTPUT_STR '] = '...
    INITIAL_LOCAL_FUNC_NAME_STR '(' VARS_INPUT_STR ', ' V_STR ')']);

definingConstsLines =[];
definingConstsLines{1} = [DEF_CONSTS_PER_MODEL_PER_SEG suffix ';'];
definingConstsLines{2} = [DEF_CONSTS_PER_MODEL_ALL_SEGS suffix ';'];
definingConstsLines{3} = [DEF_CONSTS_ALL_MODELS_ALL_SEGS ';'];  
definingConstsLines{4} = [DEF_VARS_PER_MODEL_PER_SEG suffix ';']; 
definingConstsLines{5} = [DEF_VARS_PER_MODEL_ALL_SEGS suffix ';'];  
definingConstsLines{6} = [DEF_VARS_ALL_MODELS_PER_SEG ';'];  

definingVarsAndConstsArrays = [];
definingVarsAndConstsArrays{1} = [CONSTS_PER_MODEL_PER_SEG_STR...
    ' = zeros(' int2str(numOfSegs) ', ' int2str(numConstsPerModelPerSeg) ')'];
definingVarsAndConstsArrays{2} = [CONSTS_PER_MODEL_ALL_SEG_STR...
    ' = zeros(1, ' int2str(numConstsPerModelAllSeg) ')'];
definingVarsAndConstsArrays{3} = [VARS_PER_MODEL_PER_SEG_STR...
    ' = zeros(' int2str(numOfSegs) ', ' int2str(numVarsPerModelPerSeg) ')'];
definingVarsAndConstsArrays{4} = [VARS_PER_MODEL_ALL_SEG_STR...
    ' = zeros(1, ' int2str(numVarsPerModelAllSegs) ')'];

%OLD
% mainFuncLines = [firstLine definingConstsLines definingVarsAndConstsArrays...
%     PPLines parameterBlockLines segsLoopOpenLine segsLoopBody segsLoopCloseLine];

%switched parameterBlockLines that appear to define all the consts/vars
%with the new assignValueLines that are based properly on the mdl/global
%files
mainFuncLines = [firstLine definingConstsLines definingVarsAndConstsArrays...
    PPLines totalAssignValueLines segsLoopOpenLine segsLoopBody segsLoopCloseLine];

localFuncLines = [initialLocalFuncFirstLine definingConstsLines initialBlockLines];
%addSemiColon needs to work on each function seperately.
mainFuncLines = addSemicolon(mainFuncLines, [NRN_INITMODEL_STR suffix]);
localFuncLines = addSemicolon(localFuncLines, INITIAL_LOCAL_FUNC_NAME_STR);
% if-else statements will only occur in the intial block therefore only in
% the localFuncLines (see example below)
localFuncLines = parseControlFlow(localFuncLines, 1, 1, numel(localFuncLines),...
    numel(localFuncLines{numel(localFuncLines)}));

allLines = [mainFuncLines localFuncLines];
% allLines = parseControlFlow(allLines, 1, 1, numel(allLines), numel(allLines{numel(allLines)}));
allLines = parseBuiltInFunctions(allLines);

%allLines = parseAllTypesVariablesForInitmodelNewWithCellArrs(allLines,
%suffix, globalCellArr, mdlCellArr); this line was deleted since changed to
%reading from the mdl/global csv files.
allLines = parseAllTypesVariables(allLines, suffix);  

%delete curly brackets
allLines=regexprep(allLines,'{|}','')';
%delete leading spaces and empty lines
allLines = identLines(allLines);

FNOut=[NRN_INITMODEL_STR suffix '.m'];
fid=fopen(FNOut,'w');
for i=1:numel(allLines)
    fprintf(fid,'%s\n',allLines{i});
end
fprintf(fid,'\n');
fclose(fid);

%                         @@@@@  allLines - example  @@@@@@
%
%
% function [varsForModelForSeg, varsForModelAllSegs] = NrnInitModel_hh(varsForModelForSeg,...            #firstLine - BEGIN (mainFuncLines)
%     varsForModelAllSegs, constsForModelForSeg, constsAllModelsAllSegs, vs, nSegs)        #firstLine - END
% Def_ConstsPerModelPerSeg_hh;                                                                           #definingConstsLines - BEGIN
% Def_VarsPerModelPerSeg_hh;
% Def_VarsPerModelAllSegs_hh;
% Def_ConstsAllModelsAllSegs;                                                                            #definingConstsLines - END
% constsForModelForSeg(gnabar) = .12;                                                                    #parametsBlockLines - BEGIN   
% constsForModelForSeg(gkbar) = .036;
% constsForModelForSeg(gl) = .0003;
% constsForModelForSeg(el) = -54.3;                                                                      #parameterBlockLines - END
% for ind = 1:nSegs                                                                                        #segsLoopOpenLine
% [varsForModelForSeg, varsForModelAllSegs] =initial(varsForModelForSeg,..                               #segsLoopBody
%       varsForModelAllSegs, constsForModelForSeg, constsAllModelsAllSegs, vs(ind));
% end                                                                                                    #segsLoopCloseLine
% function [varsForModelForSeg, varsForModelAllSegs] = initial...                                        #initialLocalFuncFirstLine (localFuncLines)
%   (varsForModelForSeg,varsForModelAllSegs, constsForModelForSeg, constsAllModelsAllSegs, vs)
% Def_ConstsPerModelPerSeg_hh;                                                                           #definingConstsLines - BEGIN
% Def_VarsPerModelPerSeg_hh;
% Def_VarsPerModelAllSegs_hh;
% Def_ConstsAllModelsAllSegs;                                                                            #definingConstsLines - END
% [varsForModelForSeg, varsForModelAllSegs] = hh_rates(varsForModelForSeg,...                            #initialBlockLines - BEGIN
% varsForModelAllSegs, constsForModelForSeg, constsAllModelsAllSegs, v)
% varsForModelPerSeg(m_index)=varsForModelAllSegs(minf_index);
% varsForModelPerSeg(h_index)=varsForModelAllSegs(hinf_index);
% varsForModelPerSeg(n_index)=varsForModelAllSegs(ninf_index);                                           #initialBlockLines - END




