u=uHP32;
PY=bHP32;
%%
% remember to copy in 32 chunks
PX=PY'./u; % in parallel
PF=-f./u; % in parallel
PF(N+1)=1;
PX(N+1)=0;

for i=1:LognDepth
    %     disp([1 i]);
    OldPX=PX;
    OldPF=PF;
    for j=1:N % in parallel
        NextID=FIdxsX(i,j);
        PX(j)=OldPX(j)+OldPX(NextID)*PF(j);
        PF(j)=OldPF(j)*OldPF(NextID);
    end
end
% [RealX'; PX(1:N)]

disp(max(abs(RealX'-PX(1:N))./abs(RealX')));
disp([max(abs(A*PX(1:N)'-B)) max(abs(A*RealX-B))]);