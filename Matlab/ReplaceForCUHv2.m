callToInitStrCU=strrep(callToInitStr,'InitModel','CuInitModel');
callToDerivStrCU=strrep(callToDerivStr,'DerivModel','CuDerivModel');
callToBreakStrCU=strrep(callToBreakStr,'BreakpointModel','CuBreakpointModel');
callToBreakDVStrCU=strrep(callToBreakDVStr,'BreakpointModel','CuBreakpointModel');
% callToKineticStrCU=strrep(callToKineticStr,'KineticModel','CuKineticModel');
callToInitStrCU=strrep(callToInitStrCU,'TheMMat','InMat');
callToDerivStrCU=strrep(callToDerivStrCU,'TheMMat','InMat');
callToBreakStrCU=strrep(callToBreakStrCU,'TheMMat','InMat');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'TheMMat','InMat');
%callToKineticStrCU=strrep(callToKineticStrCU,'TheMMat','InMat');
callToInitStrCU=strrep(callToInitStrCU,'InMat.boolModel','cBoolModel');
callToDerivStrCU=strrep(callToDerivStrCU,'InMat.boolModel','cBoolModel');
callToBreakStrCU=strrep(callToBreakStrCU,'InMat.boolModel','cBoolModel');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'InMat.boolModel','cBoolModel');
%callToKineticStrCU=strrep(callToKineticStrCU,'InMat.boolModel','cBoolModel');

callToInitStrCU=strrep(callToInitStrCU,'seg+','PIdx_ ## VARILP +');
callToDerivStrCU=strrep(callToDerivStrCU,'seg+','PIdx_ ## VARILP +');
callToBreakStrCU=strrep(callToBreakStrCU,'seg+','PIdx_ ## VARILP +');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'seg+','PIdx_ ## VARILP +');
%callToKineticStrCU=strrep(callToKineticStrCU,'seg+','PIdx_ ## VARILP +');
callToInitStrCU=strrep(callToInitStrCU,'V[seg]','v_ ## VARILP');
callToDerivStrCU=strrep(callToDerivStrCU,'dt, V[seg]','dt, v_ ## VARILP');
callToBreakStrCU=strrep(callToBreakStrCU,'sumCurrents, sumConductivity, V[seg]','sumCurrents_ ## VARILP , sumConductivity_ ## VARILP,v_ ## VARILP ');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'sumCurrentsDv, sumConductivityDv, V[seg]+0.001','sumCurrentsDv_ ## VARILP , sumConductivityDv_ ## VARILP ,v_ ## VARILP +0.001');
%callToKineticStrCU=strrep(callToKineticStrCU,'sumCurrents, sumConductivity, V[seg]','sumCurrents_ ## VARILP , sumConductivity_ ## VARILP,v_ ## VARILP ');
callToInitStrCU=strrep(callToInitStrCU,'StatesM','ModelStates_ ## VARILP');
callToDerivStrCU=strrep(callToDerivStrCU,'StatesM','ModelStates_ ## VARILP');
callToBreakStrCU=strrep(callToBreakStrCU,'StatesM','ModelStates_ ## VARILP');
%callToKineticStrCU=strrep(callToKineticStrCU,'StatesM','ModelStates_ ## VARILP');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'StatesM','ModelStates_ ## VARILP');
callToInitStrCU=strrep(callToInitStrCU,'ParamsM[ ','p');
callToDerivStrCU=strrep(callToDerivStrCU,'ParamsM[ ','p');
callToBreakStrCU=strrep(callToBreakStrCU,'ParamsM[ ','p');
%callToKineticStrCU=strrep(callToKineticStrCU,'ParamsM[ ','p');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'ParamsM[ ','p');
callToInitStrCU=strrep(callToInitStrCU,'ParamsM[','p');
callToDerivStrCU=strrep(callToDerivStrCU,'ParamsM[','p');
callToBreakStrCU=strrep(callToBreakStrCU,'ParamsM[','p');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'ParamsM[','p');
%callToKineticStrCU=strrep(callToKineticStrCU,'ParamsM[','p');
callToInitStrCU=strrep(callToInitStrCU,'[comp] ','');
callToDerivStrCU=strrep(callToDerivStrCU,'[comp] ','');
callToBreakStrCU=strrep(callToBreakStrCU,'[comp] ','');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'[comp] ','');
%callToKineticStrCU=strrep(callToKineticStrCU,'[comp] ','');
callToInitStrCU=strrep(callToInitStrCU,'[seg] ','');
callToDerivStrCU=strrep(callToDerivStrCU,'[seg] ','');
callToBreakStrCU=strrep(callToBreakStrCU,'[seg] ','');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'[seg] ','');
%callToKineticStrCU=strrep(callToKineticStrCU,'[seg] ','');
callToInitStrCU=strrep(callToInitStrCU,'][comp]','_ ## VARILP ');
callToDerivStrCU=strrep(callToDerivStrCU,'][comp]','_ ## VARILP ');
callToBreakStrCU=strrep(callToBreakStrCU,'][comp]','_ ## VARILP ');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'][comp]','_ ## VARILP ');
%callToKineticStrCU=strrep(callToKineticStrCU,'][comp]','_ ## VARILP ');

callToInitStrCU=strrep(callToInitStrCU,'[ comp ]','');
callToDerivStrCU=strrep(callToDerivStrCU,'[ comp ]','');
callToBreakStrCU=strrep(callToBreakStrCU,'[ comp ]','');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'[ comp ]','');
%callToKineticStrCU=strrep(callToKineticStrCU,'[ comp ]','');

callToInitStrCU=strrep(callToInitStrCU,'[ seg ]','');
callToDerivStrCU=strrep(callToDerivStrCU,'[ seg ]','');
callToBreakStrCU=strrep(callToBreakStrCU,'[ seg ]','');
callToBreakDVStrCU=strrep(callToBreakDVStrCU,'[ seg ]','');
%callToKineticStrCU=strrep(callToKineticStrCU,'[ seg ]','');