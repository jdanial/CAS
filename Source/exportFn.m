function returnFlag = exportFn(app)
% exportFn() -
% exports data generated from CAS.mlapp.
%
% Syntax -
% exportFn(app).
%
% Parameters -
% - app: CAS UI class

%% initializing returnFlag
returnFlag = false;

%% obtaining export folder path
exportPath = app.pr_exportPath;
mkdir(exportPath);

%% displaying CAS progress
app.MsgBox.Value = sprintf('%s','Progress: export started.');
drawnow;

%% extracting number of files
numFiles = length(app.pr_particleData.file);

try
    
    %% looping through files
    for fileId = 1 : numFiles
        
        %% setting up CAS progress
        app.MsgBox.Value = sprintf('%s',['Progress: exporting data in file ' num2str(fileId) ' out of ' num2str(numFiles) '.']);
        drawnow;
        
        %% saving .txt raw data file
        rawDataWriterAuxFn(app,fileId,exportPath);
        
        %% saving .tif image
        image = app.pr_particleData.file(fileId).imageAnnotated;
        imwrite(image,fullfile(exportPath,[app.pr_fileList(fileId).name '_annotated.tif']));
    end
catch
    returnFlag = true;
    app.MsgBox.Value = sprintf('%s','Error: cannot write files to disk.');
    return
end

%% displaying CAS progress
app.MsgBox.Value = sprintf('%s','Progress: export complete.');
drawnow;
end

