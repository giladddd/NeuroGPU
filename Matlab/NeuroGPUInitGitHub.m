global FTYPESTR;
FTYPESTR = 'float'; 
%AxonP = 'C:\Users\rben.KECK-CENTER\Documents\axon-gpu\';
cd('../');
BaseP = [pwd,'\'];
cd([BaseP,'Matlab']);
OptP = BaseP;
addpath(genpath(BaseP));
addpath(genpath([BaseP,'/Matlab']));

Model = 'Mainen';