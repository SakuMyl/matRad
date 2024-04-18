classdef matRad_VoxelSquaredOverdosing < DoseObjectives.matRad_DoseObjective
% matRad_SquaredDeviation Implements a penalized least squares objective
%   See matRad_DoseObjective for interface description
%
% References 
%     -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015 the matRad development team.
%
% This file is part of the matRad project. It is subject to the license
% terms in the LICENSE file found in the top-level directory of this
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part
% of the matRad project, including this file, may be copied, modified,
% propagated, or distributed except according to the terms contained in the
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (Constant)
        name = 'Voxel Squared Overdosing';
        parameterNames = {'d^{max}'};
        parameterTypes = {'dose'};
    end
    
    properties
        parameters = {0};
        penalty = 1;
        dose = [];
    end
    
    methods
        function obj = matRad_VoxelSquaredOverdosing(penalty,dRef, voxels)
            
            %If we have a struct in first argument
            if nargin == 1 && isstruct(penalty)
                inputStruct = penalty;
                initFromStruct = true;
            else
                initFromStruct = false;
                inputStruct = [];
            end
            
            %Call Superclass Constructor (for struct initialization)
            obj@DoseObjectives.matRad_DoseObjective(inputStruct);
            
            %now handle initialization from other parameters
            if ~initFromStruct
                if nargin == 2
                    %obj.parameters{1} = dRef;
                    obj.dose = dRef;
                end
                if nargin == 3
                    obj.dose = dRef(voxels);
                end
                
                if nargin >= 1 && isscalar(penalty)
                    obj.penalty = penalty;
                end
            end
        end
   
        %% Calculates the Objective Function value
        function fDose = computeDoseObjectiveFunction(obj,dose)
            % deviation : dose minus prefered dose
            overdose = dose - obj.dose;
            overdose(overdose < 0) = 0;
            % claculate objective function
            fDose = obj.penalty/numel(dose) * (overdose'*overdose);
        end
        
        %% Calculates the Objective Function gradient
        function fDoseGrad   = computeDoseObjectiveGradient(obj,dose)
            % deviation : Dose minus prefered dose
            overdose = dose - obj.dose;
            overdose(overdose < 0) = 0;

            % calculate delta
            fDoseGrad = 2 * obj.penalty/numel(dose) * overdose;
        end
    end
    
end
