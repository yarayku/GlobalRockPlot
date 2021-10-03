function cinfo = read_csvGUI(filename,hdr,end_remove)

% read_csv.m
% The functin read_csv.m, takes in the filename, number of headerlines, and
% the number of end lines to be removed, and returns a cell array of
% informaion.The file format is that, in addition to the hearders and
% footers, the data are separated by commas(csv stands for "comma-separated
% values").

% Whenever a comma is used within a phrase, it is enclosed in" ",e.g.,
% "94km NNW of Talkeetna, Alaska" -> 94km NNW of Talkeetna, Alaska (a cell)

% input information
% filename = string
% headerline = number
% end_remove = number
% Writeen by:Yaray Ku

%%
cinfo = {};
fid = fopen(filename);
cdata = textscan(fid,'%s','delimiter','\n','headerlines',hdr);
fclose(fid);
data = cdata{1};
WaitB = waitbar(0,['Reading ',filename],'Name','read_csv');
for k = 1:length(data) - end_remove
    
    line = data{k};
    if ~isempty(line) % process if not empty
        % find indx for bouble quotation
        indxDQ  = strfind(line,'"');
        % find indx for comma
        indxCO = strfind(line,',');
        
        invalid_indx = [];
        j = 1;
        while j < length(indxDQ)
            inval = find(indxCO>indxDQ(j)& indxCO<indxDQ(j+1));
            invalid_indx = [invalid_indx,inval];
            j = j+2;
        end
        
        % data = str_1 + str +str_fin
        indxCO(invalid_indx)=[]; % only valid comma indx
        
        % str_1
        cinfo{k,1} = line(1:indxCO(1)-1);
        % str
        for l = 1:length(indxCO)-1
            cinfo{k,l+1} = line(indxCO(l)+1:indxCO(l+1)-1);
        end
        % str_fin
        cinfo{k,l+2} = line(indxCO(end)+1:end); %(l+1) 
    end
    for n = 1:l+2
        indx=strfind(cinfo{k,n},'"');
        cinfo{k,n}(indx) = [];
    end
    waitbar(k/(length(data)-end_remove),WaitB);
end
close (WaitB);

