function [dmatrix]=neelin_p(metamodel,parameters,datamatrix,pvector)
% Forecast using regression metamodel as described in Neelin et al. (2010) PNAS
% NAME 
%   neelin_p
% PURPOSE 
%   Predict data using the metamodel for a parameter matrix
% INPUTS 
%   From the structure metamodel, parameters and datamatrix the following fields are
%   processed (mind the same naming in the input)
%   
%   metamodel.a:
%
%          Vector of linear terms of the metamodel [...,N,1] additional
%          data dimensions possible (ex:a~[Regions,Variables,Time,N,1])
%
%   metamodel.B: 
%
%           Matrix of quadratic and interactions terms [...,N,N] additional
%           data dimensions possible (ex:a~[Regions,Variables,Time,N,N])
%
%   parameters.range:
%
%            Range of values for each paramter to normalize the
%            scale.
%
%   parameters.default:
%
%            Default values of parameters to center the scale
%
%   datamatrix.reffdata:
%
%            Modeldata of when using default parameter values to 
%            to center the datamatrix
%
%   pvector: Parameter values for one experiment with the
%            dimension of [N,1] N=Number parameters
% OUTUTS 
%   dmatrix: Predicted data for parameter experiment
% HISTORY 
% First version: 11.10.2013
% AUTHOR  
%   Omar Bellprat (omar.bellprat@gmail.com)
% NOTE 
% Currently routine does only allow to compute one experiment at
% the time, could possibly changed by adapting matrix operations.


%--------------------------------------------------------------------
% READ Input values from structures
%--------------------------------------------------------------------

N=length(parameters); % Number of model parameters
refp=parameters(1).default; % Default modelparameters
range={parameters.range}; % Parameter ranges
refd=datamatrix.refdata; % Reference data


%--------------------------------------------------------------------
% CHECK Input consistency
%--------------------------------------------------------------------

if ~exist('pvector','var')
  error('Please give parameter matrix as input')
end

% Help variable to access datastructure
dd=ndims(datamatrix.refdata);
if dd>2
  for i=1:dd
    indd{i}=':';
  end
end

if length(pvector) > N
   error(['Parameter vector wrongly specified, only one set of' ...
	  ' parameters allowed'])
elseif length(pvector)<N
  error(['Number of parameters in parameter matrix does not agree' ...
	 ' with a and B'])
end

%Normalize parameter values by the total range

for i=1:N
  varp(i)=abs(diff(range{i}));
end

indent=1.5;
pvector=roundn((pvector-refp)./varp,-3);;

%--------------------------------------------------------------------
% ALLOCATE Output variables
%--------------------------------------------------------------------
nd=prod(size(refd));
dmatrix=NaN(nd,1);
%--------------------------------------------------------------------
% COMPUTE Data for each parameter experiment
%--------------------------------------------------------------------
for i=1:nd
   dmatrix(i)=polyvaln(metamodel.fit{i},pvector);
end;
dmatrix=reshape(dmatrix,size(refd))+refd;

