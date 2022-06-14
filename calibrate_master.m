% Master file for CCLM calibration suite eample for documentation
% on methodology
% NAME
%   calmo.m
% PURPOSE
%   Definitions for calibration, I/O of data, calling routines
% HISTORY
%   First version: 11.10.2013
%   Modified: 17.03.2022 by Shuchang Liu (shuchang.liu@env.ethz.ch)
% AUTHOR
%   Omar Bellprat (omar.bellprat@gmail.com)
%   Shuchang Liu (Shuchang.liu@env.ethz.ch)
% Three data structures are defined:
%
% - Parameters: Contains all default parameter information
%               and settings of experiments
%
% - Datamatrix: Contains all data of experiments and validation
%               runs. Defines if a score is computed out of the
%               data or if directly a score is read
%
% - Metamodel:  Contains the metamodel parameters which are fitted
%
%
%  This script you run to get the OPT set of parameters. When you hav got
%  the OPT set of parameters, you run the calibrate_master_OPT.m script
%
%
%--------------------------------------------------------------------
% DEFINE Calibration structures (Parameters,Datamatrix,Metamodel)
%--------------------------------------------------------------------

clear all; close all;
% Add polyfitn library
addpath('PolyfitnTools')

% To run the testcase with the data that already exist, you can load this
% file:
OPT_matfile='opt';
%OPT_matfile='opt_4months_5para_cloud_num1e5';
rOPT_matfile='./data/opt';

% Otherwise, you first have to run with optrun=false; to get the OPT
% parameters. Make sure you're saving the run with you OPT-parameters OPT_matfile='calibration_OPT_';

% When you have done the simulation, you set optrun=true; and load the
% correct OPT_matfile. 


optrun=true; % only set this to true if you are running after having the OPT run
%optrun=false; % only set this to false if you are running the calibration for the first time. Remember to make the directory data

%OPT_matfile='calibration_OPT_';


% file with constants for the simlations. Needs to be set depending on
% the experiemntal design
const_param;

parameters=struct('name',paramn,'range',range','default',default,'name_tex',paramnt,'orirange',orirange');

expval=create_neelin_exp(parameters); % Experiment values to fit metamodel

parameters=struct('name',paramn,'range',range','default',default,'experiments', ...
    expval,'name_tex',paramnt,'orirange',orirange');

load('stddata_2016_avg.mat');
iv=iv_n; stdobs=stdobs_n; err=err_n;

%% Description see Bellprat et al. 2012
% iv: std of ensemble of five initial pertubations
% stdobs:interannual std for the reference obs
% err: std for three different obs dataset
%%

% If only the last five years are used in the calibration

iv=iv(nyearstart:nyearend,:,:,:); stdobs=stdobs(nyearstart:nyearend,:,:,:); err=err(nyearstart:nyearend,:,:,:);

stddata=sqrt(err.^2+iv.^2+stdobs.^2);
% Define Datamatrix

moddata=[];
obsdata=[];
refdata=[];
variables={4,'OLR','OSR','LHFL'}; % Index of variables in moddata,
% and name of each model variable
% if no score data used
scoren='ps'; % If scoren [], no computation of score assumed
% and data values corresponding to score values

datamatrix=struct('moddata',moddata,'refdata',refdata,'obsdata', obsdata,'stddata',stddata,'score',scoren);

%-----------------------------------------------------------------
% READ DATA
%-----------------------------------------------------------------

read_data;
datamatrix.moddata=moddata; datamatrix.refdata=refdata; datamatrix.obsdata=obsdata;

datamatrix.variables={4,'OLR [W/m2]','OSR [W/m2]','LHFL [W/m2]'};

if optrun
    datamatrix.optdata=optdata;
    eval(['load ' rOPT_matfile ';' ])
    histplot_opt(lhscore,datamatrix)
    
else
    
        %-----------------------------------------------------------------
        % FIT METAMODEL
        %-----------------------------------------------------------------
        %
        
        metamodel=neelin_e_lsc(parameters,datamatrix,iv);
        
        %-----------------------------------------------------------------
        % VALIDATION METAMODEL
        %-----------------------------------------------------------------
        
        %%  Visualize performance landscape for each parameter pair
        %%  between all experiments

         [ctrl errpred psinput]=ctrlpred(metamodel,parameters,datamatrix);
         planes(metamodel,parameters,datamatrix,ctrl,psinput);
        
	%-----------------------------------------------------------------
        % OPTIMIZATION OF PARAMETERS
        %-----------------------------------------------------------------
        
        % The validated metamodel can now be used to find optimal parameter
        % values and to perform a perfect model experiment.
        
        % (1) Find optimal model parameters using a latin hypercube
        % optimisation
        
%        lhacc=3000000;
        lhacc=30;
        % Number of experiments to sample parameter space, for
        % means of speed a low number of parameter combinations
        % is used.
        
        
        
        % lhscore: Modelscore for all experiments;
        % lhexp: Latin hypercube parameter experiments
        % popt: Parameter setting with highest score
       
        [lhscore lhexp popt pi]=lhopt(metamodel,parameters,datamatrix,lhacc);
        
        %% (2) Plot performance range covered  by the metamodel and compare to
        %% reference simulation
       
        %histplot_opt(lhscore,datamatrix)
	histplot_ref(lhscore,datamatrix)
        
        %% (3) Plot optimised parameter distributions
        errm=0.015; % Uncertainty of the metamodel, is currently set from
        % experience, needs to be computed from error of
        % independent simulations
       
        optparam(parameters,lhscore,lhexp,popt,errm)
	
        oripopt=zeros(size(popt));	
	for tt=1:size(popt,1)
	   for i=1:N
   	      oripopt(tt,i) = trans_param(popt(tt,i),parameters(i).name,parameters)
	   end
	end
        eval(['save data/' OPT_matfile '.mat lhexp lhscore metamodel popt oripopt pi'])
end
