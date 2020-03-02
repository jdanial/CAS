function displayImageAuxFn(app,axesHandles,dropDownHandle)
% displayImageAuxFn - (Auxillary function)
% display image in a figure.
%
% Syntax -
% displayImageAuxFn(app,axesHandles,dropDownHandle)
%
% Parameters -
% - app: CAS UI class.
% - axesHandles: handles to figures.
% - dropDownHandle: handle to drop down menu.

%% calculating fileId
fileId = strcmp(dropDownHandle.Value,dropDownHandle.Items);

%% extracting image
image = app.pr_particleData.file(fileId).imageAnnotated;

%% setting color
colormap(axesHandles,gray(255));

%% setting axis
axis(axesHandles,'equal');

%% displaying image
imagesc(axesHandles,image);

%% updating UI
drawnow;