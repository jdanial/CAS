function returnFlag = detectFn(app)
% detectFn() -
% detect diffraction-limited blobs in Field of View
%
% Syntax -
% detectFn(app).
%
% Parameters -
% - app: CAS UI class

%% initializing returnFlag
returnFlag = false;

%% issuing initial error statements
if isempty(app.pr_exportPath)
    returnFlag = true;
    app.MsgBox.Value = sprintf('%s','Error: no path is selected.');
    return;
end
if isempty(app.pr_fileList)
    returnFlag = true;
    app.MsgBox.Value = sprintf('%s','Error: no image files available.');
    return;
end

inputFiles = readListBoxAuxFn(app.ListBox,app.pr_fileList);

%% reading number of files
numFiles = numel(inputFiles);

%% displaying SAS progress
app.MsgBox.Value = sprintf('%s','Progress: detection started.');
drawnow;

%% initializing struct
app.pr_particleData = struct();

%% initializing roiWidth
roiWidth = 5;

%% reading pixelsize;
app.pr_particleData.pixelSize = app.PixelSizeEditField.Value;

%% looping through files
for fileId = 1 : numFiles
    
    %% extracting file path
    if numFiles == 1
        fileName = inputFiles.name;
        fileFolder = inputFiles.folder;
    else
        fileName = inputFiles(fileId).name;
        fileFolder = inputFiles(fileId).folder;
    end
    filePath = fullfile(fileFolder,fileName);
    
    %% reading first frame
    try
        image = padarray(imread(filePath),[10 10]);
    catch
        returnFlag = true;
        app.MsgBox.Value = sprintf('%s',['Error: cannot read image file (' fileName ').']);
        return;
    end

    %% detecting micro calcifications
    imageThreshold = image > 5;
    imagePartRet = xor(bwareaopen(imageThreshold,round(1 / (app.pr_particleData.pixelSize ^ 2))),bwareaopen(imageThreshold,round(10 / (app.pr_particleData.pixelSize ^ 2))));
    cc = bwconncomp(imagePartRet);
    stats = regionprops(cc,'all');

    %% looping through particles
    for particleId = 1 : size(stats,1)
        
        %% assigning ROI pixels
        for x = round(stats(particleId).Centroid(1)) - roiWidth : round(stats(particleId).Centroid(1)) + roiWidth
            for y = round(stats(particleId).Centroid(2)) - roiWidth : round(stats(particleId).Centroid(2)) + roiWidth
                if abs(x - round(stats(particleId).Centroid(1))) == roiWidth || ...
                        abs(y - round(stats(particleId).Centroid(2))) == roiWidth
                    image(y,x) = max(max(image));
                end
            end
        end
    end
    
    %% trasferring data to UI property
    app.pr_particleData.file(fileId).stats = stats;
    app.pr_particleData.file(fileId).imageAnnotated = image;
end

%% displaying progress
app.MsgBox.Value = sprintf('%s','Progress: detection complete.');
drawnow;
end