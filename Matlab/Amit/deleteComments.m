function lines = deleteComments (lines, commentStr)
for i = 1:numel(lines)
    remarksInd = regexp(lines{i}, commentStr);
    if (~isempty(remarksInd))
       lines{i}(remarksInd(1):end) = [];
    end
end