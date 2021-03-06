function planes(metamodel,parameters,datamatrix,ctrl,psinput)

% Plot performance planes for each parameter pair predicted
% by the metamodel
%
% NAME 
%   planes
%
% PURPOSE 
%
%   Predict performance surface for a parameter pairs between
%   the design points to visualize performance non-linearities.
%
% INPUTS 
%
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
%  pi:      Performance index for all data points 
%  ps:      PS value for each simulation
% HISTORY 
% First version: 11.10.2013
% Modified: 17.03.2022
% AUTHOR  
%   Omar Bellprat (omar.bellprat@gmail.com)
%   Shuchang Liu (Shuchang.liu@env.ethz.ch)

%--------------------------------------------------------------------
% READ Input values from structures
%--------------------------------------------------------------------

N=length(parameters); % Number of model parameters
refp=parameters(1).default; % Default modelparameters
range={parameters.range}; % Parameter ranges
refd=datamatrix.refdata; % Reference data
sd=size(datamatrix.refdata);
pmatrix=parameters(1).experiments;
obsdata=datamatrix.obsdata;
stddata=datamatrix.stddata;
%--------------------------------------------------------------------
% DEFINE Additional needed vectors
%--------------------------------------------------------------------

prd=([206 81 77]-50)./255;
pbd=([184 210 237]-100)./255;
% Hotcold colormap
hotcold=[linspace(pbd(1),1,100)' linspace(pbd(2),1,100)' linspace(pbd(3),1,100)';...
         linspace(1,prd(1),100)' linspace(1,prd(2),100)' linspace(1,prd(3),100)'];

cmin=0.1; % Minimum contourlevel range 
cmax=1; % Minimum contourlevel range 
colorsc=linspace(cmin, cmax,200);

acc=20;  % Number of contourlevel intervals
planefit=zeros(sd);

% Compute index vector for all possible pairs
pqn=allcomb(1:N,1:N);

cnt=1;
for i=1:length(pqn)
  if pqn(i,1)>=pqn(i,2)
   cind(cnt)=i;
   cnt=cnt+1;
  end
end
pqn(cind,:)=[];

% Division of panels in the plot
di=N*(N-1)/2; %Number of interactions

dv=divisor(di);
pn1=dv(floor(length(dv)/2));
pn2=di/pn1; pm=[pn1,pn2];

%--------------------------------------------------------------------
% DEFINE Plot characteristics
%--------------------------------------------------------------------

for i=1:size(pqn,1)
  xgrid=linspace(range{pqn(i,1)}(1),range{pqn(i,1)}(2),acc);
  ygrid=linspace(range{pqn(i,2)}(1),range{pqn(i,2)}(2),acc);
  
  [X Y]=meshgrid(xgrid,ygrid);
  xstarp=repmat(refp,[acc^2,1]);
  xstarp(:,pqn(i,1))=X(:);
  xstarp(:,pqn(i,2))=Y(:);

  for j=1:length(xstarp)
    qfit=neelin_p(metamodel,parameters,datamatrix,xstarp(j,:));
    if strcmp(datamatrix.score,'ps')==1
      [pi ps]=pscalc(qfit,obsdata,datamatrix.stddata);
      PStmp(j)=ps;
    end
  end

  subplot(max(pm),min(pm),i)
  PSplanes=reshape(PStmp,[acc acc]);
  [ch ch]=contourf(X,Y,PSplanes,20);
  hold on
  xl=get(gca,'Xlim');
  yl=get(gca,'ylim');
 
%%%%%%%%%%%%%%%%%use original parameter values as ticklabels
  xticks(linspace(min(X(:)),max(X(:)),6));
  xticklabels({trans_param(linspace(min(X(:)),max(X(:)),6),parameters(pqn(i,1)).name,parameters)});
  yticks(linspace(min(Y(:)),max(Y(:)),6));
  yticklabels({trans_param(linspace(min(Y(:)),max(Y(:)),6),parameters(pqn(i,2)).name,parameters)});
%%%%%%%%%%%%%%%%%%lsc

  xlabel(parameters(pqn(i,1)).name_tex,'Fontsize',12)
  ylabel(parameters(pqn(i,2)).name_tex,'Fontsize',12)

  colormap(hotcold);
  caxis([cmin cmax]);

%%%%%%%%%%%%%%add point of input simulation
  dx=0; dy=0.05;
  for t=1:8
	switch t
	   case 1
		index = (pqn(i,1)-1)*2+1;
	   case 2
		index = (pqn(i,1)-1)*2+2;
	   case 3
		index = (pqn(i,2)-1)*2+1;
	   case 4
		index = (pqn(i,2)-1)*2+2;
	   case 5
		index = 2*N+i;
	   case 6
		index = 2*N+size(pqn,1)+i;
	   case 7
		index = 2*N+2*size(pqn,1)+i;
	   case 8
		index = 2*N+3*size(pqn,1)+i;
	end
	plot(pmatrix(index,pqn(i,1)),pmatrix(index,pqn(i,2)),'b*');
	[dum psinp] = pscalc(datamatrix.moddata(:,:,:,:,index),obsdata,stddata);
	text(pmatrix(index,pqn(i,1))+dx,pmatrix(index,pqn(i,2))+dy,cellstr([num2str(round(psinput(index),2)) ' (' num2str(round(psinp,2)) ')'])); %%%the original ps before metamodel
  end
%%%%%%%%%%%%%%%%%%%%add point of default and validation simulation
  default = parameters(1).default;
  plot(default(pqn(i,1)),default(pqn(i,2)),'b*');

  mmdefault = neelin_p(metamodel,parameters,datamatrix,default);
  [dum psdefault] = pscalc(mmdefault,obsdata,stddata);
  [dum psinpref] = pscalc(datamatrix.refdata,obsdata,stddata);
  text(default(pqn(i,1))+dx,default(pqn(i,2))+dy,cellstr([num2str(round(psdefault,2)) ' (' num2str(round(psinpref,2)) ')']));
  
%%%%%%%%%%%%%%%%%lsc
end

%ax=axes('Visible','off');
cb=colorbar('location','southoutside');
zlab = get(cb,'ylabel');
set(zlab,'String','PS','Fontsize',12); 
caxis([cmin cmax]);
%set(ax,'Position',[0.1 0.1 0.8 0.2],'Fontsize',12)
set(gcf,'PaperPosition',[1 1 15 8])
print('-f1','-depsc','planes')
