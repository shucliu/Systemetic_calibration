function [ctrl errpred psinput]=ctrlpred(metamodel,parameters,datamatrix)

% Evaluate if the model data on which the metamodel is estimated is
% able to reproduce the data with zero error
% NAME 
%   ctrlpred
% PURPOSE 
%   Predict modeldata on which the metamodel has been estimated to.
% INPUTS 
%   The structure metamodel, parameters and datamatrix 
%   are used for the inpute of neelin_p. Addionally the parameter
%   matrix is read 
%
%   parameters.experiments:
%
%           Parameter matrix of experiments on which metamodel is
%           estimated
%
% OUTUTS 
%   Plot: Histogram of the difference between predicted and actual
%   model data 
% HISTORY 
% First version: 11.10.2013
% Modified: 17.03.2022
% AUTHOR  
%   Omar Bellprat (omar.bellprat@gmail.com)
%   Shuchang Liu (shuchang.liu@env.ethz.ch)


%--------------------------------------------------------------------
% READ Input values from structures
%--------------------------------------------------------------------

N=length(parameters)
%ds=2*N+4*N*(N-1)/2; % Number of fitted simulations in determined design
%%%%%%%%%%%%lsc
ds=size(parameters(1).experiments,1);
pmatrix=parameters(1).experiments(1:ds,:);

obsdata=datamatrix.obsdata;
stddata=datamatrix.stddata;
%--------------------------------------------------------------------
% COMPUTE Data for each parameter experiment
%--------------------------------------------------------------------

% Help variable to select all matrix dimensions if no score used
dd=ndims(datamatrix.refdata);
if dd>2
  for i=1:dd
    indd{i}=':';
  end
else
  indd=':';
end

ctrl=NaN([size(datamatrix.refdata),length(pmatrix)]); % Allocate data
psinput=NaN([length(pmatrix),1]); % Allocate data --lsc

piinput_sep=NaN([size(datamatrix.refdata),length(pmatrix)]); % Allocate data --lsc
psinput_sep=NaN([size(datamatrix.refdata),length(pmatrix)]); % Allocate data --lsc

for i=1:length(pmatrix)
  ctrl(indd{:},i)=neelin_p(metamodel,parameters,datamatrix,pmatrix(i,:));
  [piinput_sep(indd{:},i) psinput_sep(indd{:},i)]=pscalc_sep(ctrl(indd{:},i),obsdata,stddata);
  [dum psinput(i)]=(pscalc(ctrl(indd{:},i),obsdata,stddata));
end
    	
errpred=ctrl-datamatrix.moddata(indd{:},1:length(pmatrix));

figure;

for v=1:3
  errpredv=errpred(:,:,:,v,:);
  xlim([-100 50]);
  ylim([0 150]);
  histogram(errpredv(:),'BinWidth',2);
  hold on
end
set(gca,'Fontsize',12)
ylabel('Number of counts','Fontsize',14)
xlabel('Error of prediction','Fontsize',14)

title('Verification on design data','Fontsize',14)
hold off
