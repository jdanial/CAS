function rawDataWriterAuxFn(app,fileId,exportPath)
% rawDataWriterAuxFn- (Auxillary function)
% saves CAS data to .txt file.
%
% Syntax -
% rawDataWriterAuxFn(app,fileId,exportPath)
%
% Parameters -
% - app: CAS UI class.
% - fileId: file #.
% - exportPath: path to export file.

%% identifying text file name and path
textFileName = [app.pr_fileList(fileId).name '_stats.txt'];
textFilePath = exportPath;
textFullFile = fullfile(textFilePath,textFileName);
textFileHandle = fopen(textFullFile,'w');

%% extracting number of structures
numParticles = length(app.pr_particleData.file(fileId).stats);

%% summary statement
fprintf(textFileHandle,'%s\t%d\n','Number of particles indentified',numParticles);

%% line skipper
fprintf(textFileHandle,'\n');

%% local parameters labels
fprintf(textFileHandle,'%s\t%s\t%s\t%s\t%s\n',...
    'Area',...
    'Major axis length',...
    'Minor axis length',...
    'Diameter',...
    'Perimeter');

%% looping through particles
for particleId = 1 : numParticles
    fprintf(textFileHandle,'%f\t%f\t%f\t%f\t%f\n',...
        app.pr_particleData.file(fileId).stats(particleId).Area,...
        app.pr_particleData.file(fileId).stats(particleId).MajorAxisLength,...
        app.pr_particleData.file(fileId).stats(particleId).MinorAxisLength,...
        app.pr_particleData.file(fileId).stats(particleId).EquivDiameter,...
        app.pr_particleData.file(fileId).stats(particleId).Perimeter);
end

%% closing file
fclose(textFileHandle);

%% writing summary file
textFileName = 'Summary_stats.txt';
textFilePath = exportPath;
textFullFile = fullfile(textFilePath,textFileName);
if isfile('Summary_stats.txt')
    textFileHandle = fopen(textFullFile,'a');
else
    textFileHandle = fopen(textFullFile,'w');
    
    %% local parameters labels
    fprintf(textFileHandle,'%s\t%s\t%s\t%s\t%s\n',...
        'Area',...
        'Major axis length',...
        'Minor axis length',...
        'Diameter',...
        'Perimeter');
end

%% looping through particles
for particleId = 1 : numParticles
    fprintf(textFileHandle,'%f\t%f\t%f\t%f\t%f\n',...
        app.pr_particleData.file(fileId).stats(particleId).Area * (app.pr_particleData.pixelSize ^ 2),...
        app.pr_particleData.file(fileId).stats(particleId).MajorAxisLength * app.pr_particleData.pixelSize,...
        app.pr_particleData.file(fileId).stats(particleId).MinorAxisLength * app.pr_particleData.pixelSize,...
        app.pr_particleData.file(fileId).stats(particleId).EquivDiameter * app.pr_particleData.pixelSize,...
        app.pr_particleData.file(fileId).stats(particleId).Perimeter * app.pr_particleData.pixelSize);
end

%% closing file
fclose(textFileHandle);
