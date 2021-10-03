function [cCompList nComp rpos R] = extract_compounds(R)
%  This function extracts names of compounds given a header information for
%  geochemidal data .csv file obtained from PetDB (or any file in that
%  format).  The requirement is that the compound names must begin in
%  columns following "Material" column and end before "Latitude". 
%  This code will also check for number of entries for each compound and
%  will not return the compound nammovee if there are no samples availble.
%  This code will also return latitude and longitude vector and if asked,
%  returns truncated R array (with empty cells populated by NaN).
%       Inputs: R = cell array containing data from PetDB-style .csv file
%                   with the first row corresponding to the header line
%       Output: cCompList = cell array containing different compounds for
%                           which there is at least one observation
%                           available (first entry is 'None')
%               nComp = numerical vector containing the column number of 
%                       corresponding compound
%               rpos = structure containing latitude (rpos.lat) and
%                      longitude (rpos.lon) as numerical vectors
%               R = R cell array with the first row and columns after
%                   latitude removed (empty cells replaced by NaN)
%   Usage: [cCompList nComp rpos R] = extract_compounds(R)
%  November 10, 2015.
%  Last Modified:  November 10, 2015.
%   Miaki Ishii

cheader = R(1,:);  % get header line

% get positions of important columns
indx = cellfun('isempty',strfind(cheader,'Material'));
nmat = find(~indx);  % position of 'Material' column
indx = cellfun('isempty',strfind(cheader,'Latitude'));
nlat = find(~indx);  % position of 'Latitude' column

% define latitude and longitude vectors
rpos.lat = str2num(char(R(2:end,nlat)));  % latitude vector
rpos.lon = str2num(char(R(2:end,nlat+1)));  % longitude vector

% build compound list (only those with available entries)
cCompList = {'None'};  % empty/default compound name
nComp = [0];  % vector containing relevant column values
ipos = 1;  % initial counter value
for k = nmat+1:nlat-1  % loop over columns of interest
    indx = find(~cellfun('isempty',R(2:end,k)));
    rtmp = str2num(char(R(indx+1,k)));
    if (~isempty(rtmp))  % if there are relevant entries
        ipos = ipos + 1;  % advance
        cCompList{ipos} = [cheader{k}, ' (', num2str(numel(rtmp)),')'];
        % add compound name with # of samples
        nComp(ipos) = k;  % add compound index
    end  % if (~isempty(rtmp))
end % for k = ncol.mat+1:ncol.lat-1

R = R(2:end,1:nlat-1);  % remove the header line and trailing columns

% replace all empty cells with NaN
indx = find(cellfun('isempty',R));  % get indices of empty cells
R(indx) = {'NaN'};  % replace all empty R cells with 'NaN'


end
