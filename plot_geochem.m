%   plot_geochem.m
%   This program visualizes geochemical data through GUI.
%   November 09, 2016.
%   Last Modified: November 27, 2016.
%   written by:Yaray Ku

%% dealcim
global cdir R coast cfileList nComp rpos indxSample iposComp cCompList
cdir = uigetdir;
% get the file names
filedata = dir(cdir);
nameall = {filedata.name};
name = {};
for n = 1:length(nameall)
    if ~strcmpi(nameall{n}(1),'.') 
        if strcmpi(nameall{n}(end-3:end),'.csv')
        name{end+1} = nameall{n};
        end
    end
end
cfileList = ['None',name];

% get coastline information
cfilename = 'coast.dat';            % filename
coastline = textread(cfilename,'%s','delimiter','>');
Nan_indx = find(cellfun('isempty',coastline)); % invalid indx
coastline(Nan_indx) = {'NaN NaN'};
coast = str2num(char(coastline));


% [cfile cpath] = uigetfile('*.csv','Select file');
% read .csv file
% [cfile cpath] = uigetfile('*.csv','Select file');
% filename = [cpath cfile]
% HE = inputdlg({'Enter the headerline number to be remove','Enter the tail lines number to be removed'});
% nhr = str2num(HE{1});  % number of header lines
% ntail = str2num(HE{2});  % number of tail lines
% cinfo = read_csvGUI(filename,nhr,ntail);
% 
% % save cell matrix in .mat file
% [s_cfile s_cpath] = uiputfile('*.mat','Save in .mat file');
% save([s_cpath s_cfile],'cinfo');
% 
% % return the data
% [cCompList nComp rpos R] = extract_compounds(cinfo);
%% call plot_geochem_GUI
plot_geochem_GUI
