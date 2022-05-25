%% File with constnt settings for CCLM calibration suite
%
%% directories:
%  -- simdir
%  -- obsdir
%%  calibration time period
%  --nmonths
%  --nyear
%  --nyearstart
%  --nyearend
%% Parameters, simulations and domains
%  --nparam
%  --nsim
%  --expid
%  --paramn
%  --paramnt
%  --default param
%  --range of param
%% Independent simulations
%  --nind
%  --valdata


%simdir='/hymet/ssilje/cosmopompa_calibration/modeloutput/output_2005-2009/';
%obsdir='/hymet/ssilje/cosmopompa_calibration/observations_2005-2009/';

simdir='5para_4months/';
obsdir='5para_4months/obs/';

global nmonths
global nyear

% Define the size of the data for metamodel
nmonths=4; % Number of months
nyear=1;
nregions=28;

% For the internal variability stddata_2000-2009.mat

% This is for selecting years from multiyear dataset
nyearstart=1;
nyearend=1;


nparam=5; %number of parameters
nsim=50; %number of simulations
nlhs=0; %if you want to use addtional experiments for metamodel, add here
expid={'qi0','tur_len','clc_diag','rat_sea','cloud_num'};
% Define Parameters
paramn={'qi0','tur_len','clc_diag','rat_sea','cloud_num'};
paramnt={'qi0','tur\_len','clc\_diag','rat\_sea','cloud\_num'};


%%% To reduce the chances of typing in wrong numbers, copy in from
%%% INPUT_ORG in the input folder.
tur_len=100.0;
qi0=5E-6;
clc_diag=0.5;
rat_sea=20.0;
cloud_num=5e8;
%%% To reduce the chances of typing in wrong numbers, copy in the line from
%%% the script generate_input.m here:
tur_lenn=60.0;
tur_lenx=500.0;
qi0n=0;
qi0x=0.01;
clc_diagn=0.2;
clc_diagx=1;
rat_sean=1;
rat_seax=100;
cloud_numn=1e7;
cloud_numx=1e9;
% Default parameters
%%%transform for smoother fit --lsc
default={[log10(1e8*(qi0-qi0n)/(qi0x-qi0n)+2.50e1) log10(1e8*(tur_len-tur_lenn)/(tur_lenx-tur_lenn)+1.01e6) log10(1e8*(clc_diag-clc_diagn)/(clc_diagx-clc_diagn)+6e7) log10(1e8*(rat_sea-rat_sean)/(rat_seax-rat_sean)+5.98e6) log10(1e8*(cloud_num-cloud_numn)/(cloud_numx-cloud_numn)+2.43e9)]};
%default={[log10(1e8*(qi0-qi0n)/(qi0x-qi0n)+2.50e1) log10(1e8*(tur_len-tur_lenn)/(tur_lenx-tur_lenn)+1.98e5)]};

% Parameter ranges (min,max)

%%%transform for smoother fit --lsc
range={[log10(1e8*(qi0n-qi0n)/(qi0x-qi0n)+2.50e1) log10(1e8*(qi0x-qi0n)/(qi0x-qi0n)+2.50e1)]; 
    [log10(1e8*(tur_lenn-tur_lenn)/(tur_lenx-tur_lenn)+1.01e6) log10(1e8*(tur_lenx-tur_lenn)/(tur_lenx-tur_lenn)+1.01e6)]; 
    [log10(1e8*(clc_diagn-clc_diagn)/(clc_diagx-clc_diagn)+6e7) log10(1e8*(clc_diagx-clc_diagn)/(clc_diagx-clc_diagn)+6e7)];
    [log10(1e8*(rat_sean-rat_sean)/(rat_seax-rat_sean)+5.98e6) log10(1e8*(rat_seax-rat_sean)/(rat_seax-rat_sean)+5.98e6)];
    [log10(1e8*(cloud_numn-cloud_numn)/(cloud_numx-cloud_numn)+2.43e9) log10(1e8*(cloud_numx-cloud_numn)/(cloud_numx-cloud_numn)+2.43e9)];}; 
orirange={[qi0n qi0x];[tur_lenn tur_lenx];[clc_diagn clc_diagx];[rat_sean rat_seax];[cloud_numn cloud_numx];};
%orirange={[qi0n qi0x];[tur_lenn tur_lenx];};

nind=0; % number of independent simulations
%%% Matrix of independent simulations for validating the metamodel
% The independent runs can be generated by this function:
%[xexp]=create_validation_experiments(parameters,lhacc)
valdata={[2.9919 5.8308 0.5049 6.7894 0];};

%%% experiments for addtional experiments
%lhsdata={[7.5874  7.4938  0.34813 7.479];[5.9369  7.1558  0.74313 7.9472];[5.1116  5.4657  0.54563 7.7911];[3.4611  7.8318  0.94063 7.1669];[4.2863  6.8178  0.44688 7.3229];[2.6358  6.4798  0.24938 7.0108];[1.8106  6.1417  0.64438 7.6351];[6.7621  5.8037  0.84187 6.8547];[5.9369  5.4657  0.34813 7.9472];[6.7621  7.4938  0.64438 7.7911];[2.6358  6.4798  0.74313 7.479];[5.1116  6.1417  0.24938 6.8547];[3.4611  5.8037  0.94063 7.3229];[1.8106  7.8318  0.44688 7.1669];[4.2863  7.1558  0.54563 7.6351];[7.5874  6.8178  0.84187 7.0108];};