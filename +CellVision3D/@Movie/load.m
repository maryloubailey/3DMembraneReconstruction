function [ obj ]=load(obj,varargin)
%load movie
% 3/21/2015
% Yao Zhao

if ~exist(obj.filein,'file')
    warning('invalid movie data path');
    
    
else
    % ui select
    isUI=0;
    if nargin==1
        data=bfopen(obj.filein);
    else
        if isa(varargin{1},'function_handle')
            data=bfopen(obj.filein,varargin{:});
            isUI=1;
        elseif isa(varargin{1},'numeric')
            data=bfopenSelect(obj.filein,varargin{1});
        end
    end
    
    
    % load
    mov=data{1}(:,1);
    %     obj.fformat=data{1}(:,2);
    % meta data
    omeMeta1=data{4};
    %     obj.omeMeta=omeMeta1;
    try
        obj.pix2um=omeMeta1.getPixelsPhysicalSizeY(0).getValue();
    catch
        if isUI
            query=CellVision3D.UIPopupQuestion(...
                ['Can''t find the pixel information in the metadata',...
                'Please input the pixel size in microns:']);
            waitfor(query.getFigureHandle);
            obj.pix2um=str2double(query.getAnswer);
        else
            warning('no pixel to um information')
        end
    end
    try
        obj.vox2um=omeMeta1.getPixelsPhysicalSizeZ(0).getValue();
    catch
        if isUI
            query=CellVision3D.UIPopupQuestion(...
                ['Can''t find the voxel information in the metadata',...
                'Please input the interval between z slices in microns:']);
            waitfor(query.getFigureHandle);
            obj.vox2um=str2double(query.getAnswer);
        else
            warning('no voxel to um information');
        end
    end
    try
        obj.sizeX=omeMeta1.getPixelsSizeX(0).getValue();
        obj.sizeY=omeMeta1.getPixelsSizeY(0).getValue();
        obj.sizeZ=omeMeta1.getPixelsSizeZ(0).getValue();
    catch
        warning('incomplete or no image size information');
    end
    obj.numstacks=obj.sizeZ;
    obj.numframes=omeMeta1.getPixelsSizeT(0).getValue();
    
    
    for ichannel=1:obj.numchannels
        chooseind=mod(floor((0:length(mov)-1)/obj.numstacks),obj.numchannels)==ichannel-1;
        obj.channels(ichannel).load(mov(chooseind),obj);
    end
    
end


end