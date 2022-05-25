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


simdir='./5para_4months/';
obsdir='./5para_4months/obs/';

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

% Parameter ranges (min,max)

%%%transform for smoother fit --lsc
range={[log10(1e8*(qi0n-qi0n)/(qi0x-qi0n)+2.50e1) log10(1e8*(qi0x-qi0n)/(qi0x-qi0n)+2.50e1)]; 
    [log10(1e8*(tur_lenn-tur_lenn)/(tur_lenx-tur_lenn)+1.01e6) log10(1e8*(tur_lenx-tur_lenn)/(tur_lenx-tur_lenn)+1.01e6)]; 
    [log10(1e8*(clc_diagn-clc_diagn)/(clc_diagx-clc_diagn)+6e7) log10(1e8*(clc_diagx-clc_diagn)/(clc_diagx-clc_diagn)+6e7)];
    [log10(1e8*(rat_sean-rat_sean)/(rat_seax-rat_sean)+5.98e6) log10(1e8*(rat_seax-rat_sean)/(rat_seax-rat_sean)+5.98e6)];
    [log10(1e8*(cloud_numn-cloud_numn)/(cloud_numx-cloud_numn)+2.43e9) log10(1e8*(cloud_numx-cloud_numn)/(cloud_numx-cloud_numn)+2.43e9)];}; 
orirange={[qi0n qi0x];[tur_lenn tur_lenx];[clc_diagn clc_diagx];[rat_sean rat_seax];[cloud_numn cloud_numx];};


%%% experiments for addtional experiments
%lhsdata={};
