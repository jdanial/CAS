function populateDropDownAuxFn(listBoxHandle,dropDownHandle)
% populateDropDownAuxFn - (Auxillary function)
% populate a dropdown menu.
%
% Syntax -
% populateDropDownAuxFn(app)
%
% Parameters -
% - listBoxHandle: handle to list box.
% - dropDownHandle: handle to drop down menu.

%% populating drop down menu
dropDownHandle.Items = listBoxHandle.Value;
dropDownHandle.Value = dropDownHandle.Items{1};