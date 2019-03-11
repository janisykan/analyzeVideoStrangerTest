function save2Excel()
clearvars
[filename,path] = uigetfile('*.mat','multiselect','on');

if ~iscell(filename)
    filename = {filename};
end

savePath = uigetdir(path,'Select Folder to Save');

for x = 1:size(filename,2)
    load([path,filename{x}],'TOTAL')
    tempTable = struct2table(TOTAL);
    saveName = [filename{x}(1:end-4),'.xlsx'];
    if exist([savePath,'\',saveName],'file')
        toContinue = questdlg([saveName,' already exists in this folder. What would you like to do?'],'Confirm Save As','Overwrite','Rename','Skip','Rename');
        switch toContinue
            case 'Overwrite'
                saveName = [savePath,'\',saveName];
            case 'Rename'
                tempName = [savePath,'\',saveName];
                [resultFile,resultPath] = uiputfile(tempName,'Save file name');
                saveName = [resultPath,resultFile];
            case 'Skip'
                continue
        end
    else
        saveName = [savePath,'\',saveName];
    end
    writetable(tempTable,saveName)
    clear saveName TOTAL tempTable
end