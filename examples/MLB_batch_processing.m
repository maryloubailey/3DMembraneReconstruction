%% setting up and load movie
%cen2
clear all;close all;clc;
addpath('./bioformats');
% select movie file
dirpaths={...
    ...'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\cut3',...
    ...'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\ade8',...
    ...'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\cen2',...
    ...'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\rap1',...
    'C:\Users\maryloubailey\Google Drive\Movie for analysis\particle_correlation_movies\cen2'...
    };
for idir = 1:length(dirpaths) %loop through all directory paths, in this case, only one 
    dirpath=dirpaths{idir}; %set dirpath to the directory path in specified cell
    % filename='cut3_lacOlacIGFP_sad1mcherry_30s_1hr_02_R3D.dv';
     %filename = 'ade3_lacOlacIGFP_sad1mcherry_30s_1hr_01_R3D.dv';
    files = dir(fullfile(dirpath,'*.dv')); %get .dv file (info) specified in dirpath
    filenames={files.name}; %get .dv filename
    % par for ifile=1:length(filenames);
    for ifile=2:length(filenames); %parse through .dv files, in this case only one
        movie=CellVision3D.Movie(fullfile(dirpath,filenames{ifile})); %sets up movie parameters for specific file, [] initially empty
        % display all possible channel types
        display(CellVision3D.Channel.getChannelTypes()) %packagename.classname.name; displays 'types'
        % set channels
        channellabel='lacO';
        %movie.setChannels sets channel names and types, doesn't output
        %properties?
        movie.setChannels('FluorescentParticle3D','loci',...
            'FluorescentParticle3D','SPB'...
           )
        % load movie to RAM
        movie.load(200) %shows movie parameters also
         
        %% initialize channel 1
        % get channel
        channel1 = movie.getChannel('loci'); %'loci' = label, returns channel with properties
        %all channel1.property are properties given/set up by getChannel function
        % set the size of object to 100
        channel1.lobject=3;
        % reset peak threshold, some of the particles are really dim,
        channel1.peakthreshold = .3;
        % reset minimum distance between particles
        channel1.mindist = 3;
        % initialize the movie - particle3d array with properties
        particle1 = channel1.init(1)
        % preview channel - figure
        channel1.view()
        
        %% initialize channel 2
        figure
        % get channel
        channel2 = movie.getChannel('SPB');
        % set the size of object to 100
        channel2.lobject=3;
        % reset peak threshold, some of the particles are really dim,
        channel2.peakthreshold = .2;
        % reset minimum distance between particles
        channel2.mindist = 3;
        % initialize the movie
        particle2 = channel2.init(1);
        % preview channel
        channel2.view();
        %% initialize channel 3
        % get channel
%         channel3 = movie.getChannel('cell body');
% %         % set the size of object to 100
% %         channel2.lobject=3;
% %         % reset peak threshold, some of the particles are really dim,
% %         channel2.peakthreshold = .3;
% %         % reset minimum distance between particles
% %         channel2.mindist = 3;
% %         % initialize the movie
%         contour = channel3.init(1);
%         % preview channel
%         channel3.view();
        
        %% construct cell
        % construct the cell only by membrane
        cells = CellVision3D.CellConstructor.constructCellsByParticles(particle1,particle2,15);
        % set filters to only select cells with two lacO found
        filter=CellVision3D.CellFilter('loci','FluorescentParticle3D_number',[1 1],...
            'SPB','FluorescentParticle3D_number',[1 1]);
%         apply filtter
        cells=filter.applyFilter(cells);
        % view result
        figure
        movie.view(cells);
        pause(0.1)
        %% reconstruct cell
%         run with images (slow)
%         f=figure('Position',[50 50 1200 600]);
%         % channel1.run(cells,[],f);
%         % run without images (fmuch faster)
%         channel1.run(cells);
%         channel2.run(cells);
        %%
        pause
        movie.save(1,[],cells);
       
    end
end
%%
dirpaths={...
    ...'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\cut3',...
    ...'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\ade8',...
    ...'C:\Users\Yao\Google Drive\Movie for analysis\particle_correlation_movies\cen2',...
    'C:\Users\maryloubailey\Google Drive\Movie for analysis\particle_correlation_movies\cen2',...
    };
for idir = 1:length(dirpaths)
    dirpath=dirpaths{idir};
    % filename='cut3_lacOlacIGFP_sad1mcherry_30s_1hr_02_R3D.dv';
    files = dir(fullfile(dirpath,'*.mat'));
    filenames={files.name};
    % par for ifile=1:length(filenames);
    for ifile=1:length(filenames);
        load(fullfile(dirpath,filenames{ifile}));
        % load movie to RAM
        movie.load();
        %% reconstruct cell
%         run with images (slow)
%         f=figure('fPosition',[50 50 1200 600]);
        % channel1.run(cells,[],f);
        % run without images (fmuch faster)
        movie.getChannel('loci').run(cells);
        movie.getChannel('SPB').run(cells);
        %%
        movie.save(1,[],cells);
    end
end
