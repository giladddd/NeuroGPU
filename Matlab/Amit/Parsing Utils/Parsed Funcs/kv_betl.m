function [betl] = kv_betl(varsPerModelPerSeg, varsPerModelAllSeg,varsAllModelPerSeg, constsPerModelPerSeg, constsPerModelAllSeg, constsAllModelAllSeg, v,zetal,gml,vhalfl)
Def_ConstsPerModelPerSeg_kv;
Def_ConstsPerModelAllSegs_kv;
Def_VarsPerModelPerSeg_kv;
Def_VarsPerModelAllSegs_kv;
Def_VarsAllModelsPerSeg;
Def_ConstsAllModelsAllSegs;
betl = exp(1.e-3*constsPerModelAllSeg(zetal_index)*constsPerModelAllSeg(gml_index)*(v-constsPerModelAllSeg(vhalfl_index))*9.648e4/(8.315*(273.16+constsAllModelAllSeg(celsius_index)))) ;

