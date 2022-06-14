function moddata = read_model(expname)

const_param;

varn={'OLR','OSR','LHFL'};
varf={'OLR','OSR','LHFL'};

exppath=[simdir,expname,'/'];
% dim [year month regions variables]
moddata=NaN(nyear,nmonths,nregions,3);


for ii=1:3
    for r=1:nregions
        moddat=ncread([exppath,varf{ii},'_',num2str(r),'.nc'],varn{ii});
        %      if length(moddat) > 120
        if length(moddat) > nmonths
            display(['Too much data for ', expname, ' variable ', varf{ii}])
            %      elseif  length(moddat) < 120
            length(moddat)
        elseif  length(moddat) < nmonths
            display(['Too little data for ', expname, ' variable ', varf{ii}])
            length(moddat)
        end
	moddata(:,:,r,ii)=reshape(moddat(1,1,1:nmonths),nmonths,nyear)';
    end
end
%moddata(:,:,:,1)=moddata(:,:,:,1);
%moddata(:,:,:,3)=moddata(:,:,:,3)*100;
end


