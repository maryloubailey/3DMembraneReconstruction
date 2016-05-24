function [ channeltypes, channelclassnames,descriptions ] = getChannelTypes(  )
%get all possible channel types for the package
% 3/27/2016 Yao Zhao

%% class meta data of movie
meta=metaclass(CellVision3D.HObject); %class
packagemeta=meta.ContainingPackage;   %package: classlist, functionlist, packagelist
classlist = packagemeta.ClassList;    %class array with properties
classnames = {classlist.Name};        %1x48 class list, i.e. CellVision3D.Movie, CellVision3D.HObject
channelclassnames = ...
    classnames(cellfun(@(x)~isempty(strfind(x,'CellVision3D.Channel')),classnames)); %make cell of only the channel class names from the initial cell, classnames
channeltypes=cellfun(@(x)x(21:end),channelclassnames,'UniformOutput',0); %cell of channel types
channeltypes{strcmp(channeltypes,'')}='None';
descriptions=cell(size(channeltypes));

isStable = true(size(channeltypes));
for iChannelType=1:length(descriptions)
    switch channeltypes{iChannelType}
        case'None'
        descriptions{iChannelType}='skip this channel';
        case 'BrightfieldContour3D'
            descriptions{iChannelType}='brightfield cells';
        case 'FluorescentParticle3D'
            descriptions{iChannelType}='fluorescent particles';
        case 'FluorescentMembrane3DSpherical'
            descriptions{iChannelType} = 'fluorescent membranes';
        case 'FluorescentMembrane3D'
            descriptions{iChannelType} = 'fluorescent membranes, any shape';
            isStable(iChannelType)=false;
        otherwise 
            descriptions{iChannelType}='can''t find description';
    end
end

channeltypes=channeltypes(isStable);
channelclassnames=channelclassnames(isStable);
descriptions=descriptions(isStable);
end

