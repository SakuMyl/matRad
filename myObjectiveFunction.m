function f = myObjectiveFunction(d, cst)
% References
%   -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2016 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize f
f = 0;

for  i = 1:size(cst,1)

    % Only take OAR or target VOI.
    if ~isempty(cst{i,4}{1}) && ( isequal(cst{i,3},'OAR') || isequal(cst{i,3},'TARGET') )

        % loop over the number of constraints for the current VOI
        for j = 1:numel(cst{i,6})

            objective = cst{i,6}{j};

            if ~isa(objective, 'DoseObjectives.matRad_DoseObjective')
                objective = matRad_DoseOptimizationFunction.createInstanceFromStruct(objective);
            end
            if isa(objective, 'DoseObjectives.matRad_VoxelSquaredDeviation')
                objective.dose = objective.dose(cst{i,4}{j});
            end

            % only perform gradient computations for objectives
            d_i = d(cst{i,4}{1});
            f = f + objective.computeDoseObjectiveFunction(d_i);

        end

    end

end
