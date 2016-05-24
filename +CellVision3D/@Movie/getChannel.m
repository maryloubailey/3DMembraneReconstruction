function [ channel ] = getChannel( obj, varargin )
% set channel information for Movie
% 3/21/2015
% Yao Zhao

if nargin==2 %for 2 input arguments
    channelname=varargin{1}; %set channel name to first input argument, object
    if isa(channelname,'char') %if channel name is a character array == 1
        channelID=(strcmp(channelname,{obj.channels.label})); %set channelID to 1 if name matches input argument name
    elseif isa(channelname,'numeric') %if channel name is a number, set channelID to that number
        channelID=channelname;
    else
        error('unsupported channelname type');
    end
    
    channel=obj.channels(channelID); %now return channel as obj.channels(channelID)
elseif nargin ==1 %for only one input argument
    channel=obj.channels; %channels - pointer, property defined in movie
end

end

