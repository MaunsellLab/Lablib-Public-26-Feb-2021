function events = readLLFile(option, arg, figNum1, figNum2)%%   events = readLLFile(option, arg, figNum1, figNum2)%%   Read a Lablib data file using event definitions.%%   option = 'h' opens file arg with PPC byte ordering and returns events up to first trial%   option = 'i' opens file arg with Intel byte ordering and returns events up to first trial%   option = 't' returns events for trial arg of previously opened file%   option = 'c' closes the data file (if open)%%   figuNum1 and figNum2 are optional figure numbers for displaying%   detailed event data.  If a trial has a lot of events, these windows may%   take several seconds to be displayed.%%   If an explicit path is part of the file name (i.e,%   /Data/test/lablibFile.dat), then the program only searches the explicit%   directory for the file.  If no explicit path is provided, then%   the program searches the current directory and then the standard location%   for Lablib data files in /Data/* where * is the first letter of the file name.%%   The first time a Lablib data file is opened, the program will take a long time to%   count and process all the events.  The event information is then stored%   in an intermediate file fileName_fileInfo.mat.  Subsequent Lablib data file opens%   will then be much faster.  Use the 'H' option to force a fresh load and%   bypass the intermediate file (see below).%%   At this time, however, trial reads are relatively slow (a few seconds%   each).%%%   EXAMPLES%%%   header = readLLFile('h', 'nwaab01.dat', 1, 2);%%   Open data file nwaab01.dat and return events before the  trial into header.  This%   also displays the detailed event information and header events in%   figures 1 and 2.%%%   trial = readLLFile('t', 10, 2);%%   Read trial 10 and returns events into trial.  Also displays all%   of trial 10 events and data in figure 2.%%%   Read trial 55 with no event data displayed.%%   trial = readLLFile('t', 55);%%%%   OTHER OPTIONS%%   For debugging, the following options are useful%%   option = 'H' same as 'h' but forces the creation of new fileName_fileInfo.mat%   option = 'f' return the fileInfo structure for debugging%%%%   ISSUES%%   With the new intel based macs, there could be potential problems with byte ordering.%   This script can handle either PPC or intel byte ordering, but this%   does not currently automatically check which platform is%   present in the data file.%%   8 aug 06   epc%%   17 aug 06  epc%%   11 April 07 epc Added ability to read arbitrary arrays of structures, added byte order to options,%   now produces more detailed header and event windows with all the data%   displayed.%%   6 may 07   epc  Fixed a minor bug involving arrays.  Added a wait bar%   when displaying the events in a trial.	persistent fileInfo    	if nargin == 2		figNum1 = 0;		figNum2 = 0;	elseif nargin == 3		figNum2 = 0;	end	switch option		case {'h','H', 'i', 'I'}			if ~isempty(fileInfo)				% close existing data file				fclose(fileInfo.fid);				fileInfo = [];			end			% open file			fileName = arg;			if option == 'h'				forceReadFileFlag = 0;				byteOrder = 'b';			elseif option == 'H'				forceReadFileFlag = 1;				byteOrder = 'b';			elseif option == 'i'				forceReadFileFlag = 0;				byteOrder = 'l';			elseif option == 'I'				forceReadFileFlag = 1;				byteOrder = 'l';			end						% red header and event definitions			fileInfo = readLLBinaryHeader(fileName, figNum1, forceReadFileFlag, byteOrder);			% read events up to first trial			[events, unbundledEvents] = readEventsInRange(fileInfo, 1, fileInfo.trialEventBounds(1,1)-1);			events.fileName = fileInfo.fileName;			events.pathName = fileInfo.pathName;			events.format = fileInfo.formatVersion;			events.date = fileInfo.date;			events.time = fileInfo.time;			events.numberOfTrials = fileInfo.trialCount;			if figNum2 > 0				displayEvents(unbundledEvents, events, fileInfo, 1, 'h', figNum2);			end		case 't'			if isempty(fileInfo)				% no file is open				error('no LL data file is currently open');			end			trialNumber = arg;			if isempty(trialNumber < 1 || trialNumber > fileInfo.trialCount)				error('bad trial number');			end			% read events for trial			[events, unbundledEvents] = readEventsInRange(fileInfo, fileInfo.trialEventBounds(trialNumber,1), fileInfo.trialEventBounds(trialNumber,2));			events.fileName = fileInfo.fileName;			events.date = fileInfo.date;			events.time = fileInfo.time;			events.trialNumber = trialNumber;			if figNum1 > 0				displayEvents(unbundledEvents, events, fileInfo, fileInfo.trialEventBounds(trialNumber,1), 't', figNum1);			end		case 'c'			if ~isempty(fileInfo)				% close existing data file				fclose(fileInfo.fid);				fileInfo = [];			end			events = [];		case 'f'			if ~isempty(fileInfo)				% close existing data file				fclose(fileInfo.fid);				fileInfo = [];			end			% open file			fileName = arg;			events = readLLBinaryHeader(fileName, figNum1);		otherwise			error('bad input option');	endendfunction [fid, fileName, pathName] = openLLDataFile(fullFileName, byteOrder)% Check if there is a path in fullFileName.% If not check if file is in current dirctory or /Data/*/fileName where * is the first letter of the% file name.	% is there a path in the file name?	%slashIndex = strfind(fullFileName, '/');	slashIndex = strfind(fullFileName, filesep);	machform = byteOrder;	if ~isempty(slashIndex)		% parse out explicit path		pathName = fullFileName(1 : slashIndex(end));		fileName = fullFileName(slashIndex(end) + 1 : end);		% try to open with explicit path		%fid = fopen(fullFileName,'r');		fid = fopen(fullFileName,'r',machform);		if fid == -1			% didn't find file in explicit path			error(['Could not open file' fileName ' in path ' pathName]);		end	else		% no explicit path given.  Try current directory		%currentDirectoryPath = [pwd '/'];		currentDirectoryPath = [pwd, filesep];		pathName = currentDirectoryPath;		fileName = fullFileName;		%fid = fopen(fileName,'r');		fid = fopen(fileName,'r',machform);		if fid == -1			% didn't find file in current directory,  Now look in the			% standard place /Data/*			firstLetter = fileName(1);			pathName = ['/Data/' firstLetter '/'];			%fid = fopen([pathName fileName],'r');			fid = fopen([pathName fileName],'r',machform);			if fid == -1				pathName = ['/Users/Shared/Data/' firstLetter '/' fileName([2 3]) '/'];				%fid = fopen([pathName fileName],'r');				fid = fopen([pathName fileName],'r',machform);				% didn't find file in data directory,  Now look in the				% other standard data directory: /Users/Shared/Data				if fid == -1					error(['Could not open file ' fileName ' in current dirctory ' currentDirectoryPath ' or standard data directory']);				end			end		end	endend% where fileInfo is constructedfunction fileInfo = readLLBinaryHeader(fullFileName, figNum1, forceReadFileFlag, byteOrder)global longIntFormat longUIntFormat	[fid, fileName, pathName] = openLLDataFile(fullFileName, byteOrder);	fileInfoName = [pathName fileName(1 : end-4) '_fileInfo.mat'];			if forceReadFileFlag == 0		try			fileInfoAvailableFlag = 1;			load(fileInfoName);		catch			fileInfoAvailableFlag = 0;		end	else		fileInfoAvailableFlag = 0;	end	if fileInfoAvailableFlag		% we loaded fileInfo so return		if figNum1 > 0			displayEventInfo(fileInfo, figNum1);		end		return;	end	% construct fileInfo	fileInfo.fileName = fileName;	fileInfo.pathName = pathName;	fileInfo.fid = fid;	fileInfo.byteOrder = byteOrder;	a = fread(fileInfo.fid,7);  % 8 bytes of header	fileInfo.formatVersion = str2double(char(a(3:7)'));	if fileInfo.formatVersion < 6.1		error(['No data definitions in ' fileName]);    end    if (fileInfo.formatVersion >= 6.3)        fileInfo.bits = 64;        longIntFormat = 'int64';        longUIntFormat = 'uint64';    else        fileInfo.bits = 32;        longIntFormat = 'int32';        longUIntFormat = 'uint32';    end	fileInfo.numberOfDefinedEvents = fread(fileInfo.fid, 1, longIntFormat);	for i = 1 : fileInfo.numberOfDefinedEvents        		stringLength = fread(fileInfo.fid,1,'int8');		fileInfo.eventDefs(i).name = char((fread(fileInfo.fid, stringLength))');		fileInfo.eventDefs(i).number = i;		fileInfo.eventDefs(i).dataBytes = fread(fileInfo.fid,1, longIntFormat);		fileInfo.eventDefs(i).errors = {};        %i        %fileInfo        		% recursively read data definitions		fileInfo.eventDefs(i).dataDef = readLLBinaryDataDef(fileInfo.fid, []);	end	stringLength = fread(fileInfo.fid,1,'int8');	fileInfo.date = char((fread(fileInfo.fid,stringLength))');	stringLength = fread(fileInfo.fid,1,'int8');	fileInfo.time = char((fread(fileInfo.fid,stringLength))');	fileInfo.startOfData = ftell(fileInfo.fid);	fseek(fileInfo.fid, 0, 'eof');	fileInfo.sizeOfFile = ftell(fileInfo.fid);	fileInfo = makeDataStructDef(fileInfo);	fileInfo = countEvents(fileInfo);	fileInfo = countTrials(fileInfo);	% save fileInfo for faster loading next time	save(fileInfoName, 'fileInfo');	if figNum1 > 0		displayEventInfo(fileInfo, figNum1);	endendfunction displayEventInfo(fileInfo, figNum)    if figNum == 0        return;    end    % display file info    str = {};    str{1} = [fileInfo.fileName '  ' fileInfo.date '  ' fileInfo.time];    str{2} = [int2str(fileInfo.numberOfEvents) ' events    ' int2str(fileInfo.trialCount) ' trials'];    str{3} = [' Code                        Name       Number     Type    Bytes  Fields  Warnings'];    for i = 1 : fileInfo.numberOfDefinedEvents        if isempty(fileInfo.eventDefs(i).errors)            errorString = '';        else            errorString = fileInfo.eventDefs(i).errors{1};        end        str{3+i} = sprintf('%4d %32s %7d %10s   %4d    %3d     %s', i-1, fileInfo.eventDefs(i).name, fileInfo.eventCount(i), ...            fileInfo.eventDefs(i).dataDef(1).typeName, fileInfo.eventDefs(i).dataBytes, length(fileInfo.eventDefs(i).dataStruct), errorString);    end    str{end+1} = ' ';    for i = 1 : fileInfo.numberOfDefinedEvents                str{end+1} = '----------------------------';        str{end+1} = ' ';        str{end+1} = [int2str(i-1) ' ' fileInfo.eventDefs(i).name];        str{end+1} = ' ';                if ~isempty(fileInfo.eventDefs(i).dataStruct(1).fieldNames)                        for j = 1 : length(fileInfo.eventDefs(i).dataStruct)                fieldString = fileInfo.eventDefs(i).dataStruct(j).fieldNames{1};                for k = 2 : length(fileInfo.eventDefs(i).dataStruct(j).fieldNames);                    fieldString = [fieldString '.' fileInfo.eventDefs(i).dataStruct(j).fieldNames{k}];                end                if fileInfo.eventDefs(i).dataStruct(j).elements == 1                    str{end+1}=['    ' fieldString ' = ' fileInfo.eventDefs(i).dataStruct(j).type '                 [offset=' int2str(fileInfo.eventDefs(i).dataStruct(j).offsetBytes) '  total=' int2str(fileInfo.eventDefs(i).dataStruct(j).elementBytes) ']'];                elseif fileInfo.eventDefs(i).dataStruct(j).elements > 1                    str{end+1}=['    ' fieldString ' = ' fileInfo.eventDefs(i).dataStruct(j).type '[' int2str(fileInfo.eventDefs(i).dataStruct(j).elements) ']                  [offset=' int2str(fileInfo.eventDefs(i).dataStruct(j).offsetBytes) '  element=' int2str(fileInfo.eventDefs(i).dataStruct(j).elementBytes) '  total=' int2str(fileInfo.eventDefs(i).dataStruct(j).elementBytes * fileInfo.eventDefs(i).dataStruct(j).elements) ']'];                else                    str{end+1}=['    ' fieldString ' = ' fileInfo.eventDefs(i).dataStruct(j).type '[variable length]                    [offset=' int2str(fileInfo.eventDefs(i).dataStruct(j).offsetBytes) '  element=' int2str(fileInfo.eventDefs(i).dataStruct(j).elementBytes) '  total=variable]'];                end            end        else            str{end+1} = ['    no data'];        end        str{end+1} = ' ';    end        figure(figNum);    clf;    set(gcf,'Units' , 'normalized', 'Position', [.2, .4, .2, .6], 'ToolBar', 'none',...        'MenuBar', 'none', 'NumberTitle', 'off', 'Name', [fileInfo.fileName '  event definitions']);    uicontrol('Style', 'listbox', 'String', str, 'Units', 'normalized', ...        'Position', [.02 .02 .96 .96], 'FontSize', 10, 'FontName', 'FixedWidth', 'Value', 3);    drawnow;endfunction displayEvents(unbundledEvents, events, fileInfo, firstEvent, hOrT, figNum)%%   display every event and data%%   It can be slow to render the window.    if hOrT == 'h'        wbs = 'header';    else        wbs = ['trial ' int2str(events.trialNumber)];    end	h = waitbar(0,['Creating event window for ' wbs '...']);	waitBarUpdateRate = 250;	nextWaitBarUpdate = waitBarUpdateRate;    % display file info    str = {};    str{1} = [events.fileName '  ' events.date '  ' events.time];    if hOrT == 'h'        str{2} = ['Header contains ' int2str(length(unbundledEvents)) ' events'];    else        str{2} = ['Trial ' int2str(events.trialNumber) ' contains ' int2str(length(unbundledEvents)) ' events'];    end    str{end+1} = ['  Number  Code                        Name       Time'];    for i = 1 : length(unbundledEvents)        eventNumber = firstEvent-1+i;        code = fileInfo.eventCodes(eventNumber);        str{end+1} = sprintf('%7d  %4d %32s  %d', eventNumber, code-1, fileInfo.eventDefs(code).name, unbundledEvents{i}.timeMS);        str{end+1} = ' ';                 if ~isempty(fileInfo.eventDefs(code).dataStruct(1).fieldNames)                  for j = 1 : length(fileInfo.eventDefs(code).dataStruct)                                  x = 'unbundledEvents{i}';                 for k = 1 : length(fileInfo.eventDefs(code).dataStruct(j).fieldNames)                     x = [x '.' fileInfo.eventDefs(code).dataStruct(j).fieldNames{k}];                 end                 eval(['v=' x ';']);                                  fieldString = fileInfo.eventDefs(code).dataStruct(j).fieldNames{1};                 for k = 2 : length(fileInfo.eventDefs(code).dataStruct(j).fieldNames);                     fieldString = [fieldString '.' fileInfo.eventDefs(code).dataStruct(j).fieldNames{k}];                 end                 switch fileInfo.eventDefs(code).dataStruct(j).type                                      case {'int16', 'int32', 'int64', 'uchar'}                    str{end+1}=['        ' fieldString ' = ' int2str(v(:)')];                 case {'float32', 'float64'}                    str{end+1}=['        ' fieldString ' = ' num2str(v(:)')];                 case 'char'                    str{end+1}=['        ' fieldString ' = ' v];                 end             end         else            str{end+1} = ['        no data'];        end        str{end+1} = ' ';        str{end+1} = '----------------------------';        str{end+1} = ' ';                if i == nextWaitBarUpdate			waitbar(i / length(unbundledEvents),h);			nextWaitBarUpdate = nextWaitBarUpdate + waitBarUpdateRate;		end    end        waitbar(1,h,['Drawing event window for ' wbs '...this may take a few moments']);    figure(figNum);    clf;    set(gcf,'Units' , 'normalized', 'Position', [.42, .4, .2, .6], 'ToolBar', 'none',...        'MenuBar', 'none', 'NumberTitle', 'off', 'Name', [fileInfo.fileName '  ' wbs]);    uicontrol('Style', 'listbox', 'String', str, 'Units', 'normalized', ...        'Position', [.02 .02 .96 .96], 'FontSize', 10, 'FontName', 'FixedWidth', 'Value', 3);    drawnow;        	close(h);endfunction dataDef = readLLBinaryDataDef(fid, dataDef)%% Recursively read data definitions global longIntFormat longUIntFormat 	i = length(dataDef) + 1        	stringLength = fread(fid,1,'int8')    	dataDef(i).typeName = char((fread(fid, stringLength))');	stringLength = fread(fid,1,'int8');	dataDef(i).dataName = char((fread(fid, stringLength))');	dataDef(i).offsetBytes = fread(fid, 1, longUIntFormat);	dataDef(i).elements = fread(fid, 1, longIntFormat);	dataDef(i).elementBytes = fread(fid, 1, longUIntFormat);	dataDef(i).tags = fread(fid, 1, longUIntFormat);	for j = 1 : dataDef(i).tags		dataDef = readLLBinaryDataDef(fid, dataDef);    end    if ~isempty(dataDef)        dataDef(i).typeName    endendfunction fileInfo = makeDataStructDef(fileInfo)%%   This routine creates the data structure we use to read an event.  It%   creates a cell array of field names and the total offset bytes for each%   field.%%   Offsets were a bit trickey because it appears LL defines them as%   relative to the current structure.%%   For some events, there are bytes left over after we read the%   data.  These extra bytes are not saved.    for i = 1 : fileInfo.numberOfDefinedEvents        dataStruct.fieldNames = {};        dataStruct.tagList = [];        dataStruct.dataFieldCount = 0;        dataStruct.structOffsetBytes = [];        dataStruct.offsetBytes = -1;        dataStruct.dataBytes = -1;        prefixFieldNames = {};        dataStructIndex = 1;        dataDefIndex = 1;        structOffsetBytes = 0;        [fileInfo.eventDefs(i).dataStruct, prefixFieldNames, dataStructIndex, dataDefIndex] = ...            extractDataStructDef(dataStruct, fileInfo.eventDefs(i).dataDef, prefixFieldNames, dataStructIndex, dataDefIndex, structOffsetBytes);    end%     for i = 1 : fileInfo.numberOfDefinedEvents%         printEventDef(fileInfo.eventDefs(i))%     endendfunction [dataStruct, prefixFieldNames, dataStructIndex, dataDefIndex, structOffsetBytes] = extractDataStructDef(dataStruct, dataDef, prefixFieldNames, dataStructIndex, dataDefIndex, structOffsetBytes)global longIntFormat    if dataDefIndex > length(dataDef)        return;    end    switch dataDef(dataDefIndex).typeName        case 'struct'            tags = dataDef(dataDefIndex).tags;            elements = dataDef(dataDefIndex).elements;                         prefixFieldNames = [prefixFieldNames {dataDef(dataDefIndex).dataName}];            prefixFieldNamesStart = prefixFieldNames;                        offsetBytes = dataDef(dataDefIndex).offsetBytes;            structOffsetBytesStart = structOffsetBytes + offsetBytes;            dataDefIndexThisStruct = dataDefIndex;                        dataDefIndex = dataDefIndex + 1;            dataDefIndexStart = dataDefIndex;                        for i = 1 : elements                % recursively build dataStruct template for this struct                % this loops through all the elements for arrays of structs                                prefixFieldNames = prefixFieldNamesStart;                dataDefIndex = dataDefIndexStart;                structOffsetBytes = structOffsetBytesStart + (i-1) * dataDef(dataDefIndexThisStruct).elementBytes;                                if elements > 1                    prefixFieldNames{end} = [prefixFieldNames{end} '(' int2str(i) ')'];                end                                for j = 1 : tags                    % this loops through all the fields of the struct                    [dataStruct, dummyPrefixFieldNames, dataStructIndex, dataDefIndex, structOffsetBytes] = ...                        extractDataStructDef(dataStruct, dataDef, prefixFieldNames, dataStructIndex, dataDefIndex, structOffsetBytes);                end            end            structOffsetBytes = structOffsetBytesStart - offsetBytes;                        return;        case 'no data'            dataDefIndex = dataDefIndex + 1;            return;                 otherwise            % we have actual data                        if dataDef(dataDefIndex).elements == -1 && ~isempty(dataStruct(dataStructIndex).fieldNames)                error('no variable length data allowed in structs');            end                            dataStruct(dataStructIndex).fieldNames = [prefixFieldNames {parseDataName(dataDef(dataDefIndex).dataName)}];                        %dataStruct(dataStructIndex).fieldNames = [prefixFieldNames {dataDef(dataDefIndex).dataName}];            switch dataDef(dataDefIndex).typeName                case 'short'                    dataStruct(dataStructIndex).type = 'int16';                case 'long'                    dataStruct(dataStructIndex).type = longIntFormat;                case 'float'                    dataStruct(dataStructIndex).type = 'float32';                case 'double'                    dataStruct(dataStructIndex).type = 'float64';                case 'boolean'                    dataStruct(dataStructIndex).type = 'uchar';                case {'char', 'string'}                    dataStruct(dataStructIndex).type = 'char';                otherwise                    error([dataDef(dataDefIndex).typeName ' not a recognized data type']);            end                        dataStruct(dataStructIndex).offsetBytes = structOffsetBytes + dataDef(dataDefIndex).offsetBytes;            dataStruct(dataStructIndex).elements = dataDef(dataDefIndex).elements;            dataStruct(dataStructIndex).elementBytes = dataDef(dataDefIndex).elementBytes;                        dataStructIndex = dataStructIndex + 1;            dataDefIndex = dataDefIndex + 1;            return;    endendfunction printEventDef(eventDefs)    disp('-------------------------');    eventDefs        disp('dataDefs=');    disp(' ' );    for j = 1 : length(eventDefs.dataDef)        disp([eventDefs.dataDef(j).typeName ' ' eventDefs.dataDef(j).dataName ...            ' offsetBytes=' num2str(eventDefs.dataDef(j).offsetBytes) ' elements=' num2str(eventDefs.dataDef(j).elements) ...            ' elementBytes=' num2str(eventDefs.dataDef(j).elementBytes) ' tags=' num2str(eventDefs.dataDef(j).tags)]);    end    if isfield(eventDefs,'dataStruct')        disp(' ');        disp('dataStruct=');        disp(' ' );        for i = 1 : length(eventDefs.dataStruct)            if ~isempty(eventDefs.dataStruct(i).fieldNames)                fieldString = eventDefs.dataStruct(i).fieldNames{1};                for j = 2 : length(eventDefs.dataStruct(i).fieldNames);                    fieldString = [fieldString '.' eventDefs.dataStruct(i).fieldNames{j}];                end                disp([fieldString ' type=' eventDefs.dataStruct(i).type ' elements=' int2str(eventDefs.dataStruct(i).elements) ' offsetBytes=' int2str(eventDefs.dataStruct(i).offsetBytes) ' elementBytes=' int2str(eventDefs.dataStruct(i).elementBytes)]);            end        end    end    disp(' ');end% function dataNames = parseDataName(nameString)% %% % convert c data name to a matlab friendly cell array data name.  For% % example, "a[1].b" produces {'a(1)' 'b'}% % 	% convert [] to ()% % 	nameString = strrep(nameString,'[','(');% 	nameString = strrep(nameString,']',')');% % 	% increment array indices% % 	iopen = findstr(nameString, '(');% 	iclose = findstr(nameString, ')');% % 	if ~isempty(iopen)% % 		k = 1;% 		for j = 1 : length(iopen)% 			nstring = nameString(iopen(j)+1 : iclose(j)-1);% 			if isempty(nstring)% 				error('isempty(nstring)');% 			end% 			n = sscanf(nstring,'%d');% 			n = n + 1;% 			nameString = sprintf('%s%d%s', nameString(1:iopen(j)), n, nameString(iclose(j) : end));% % 		end% 	end% % 	% separate field names% % 	i = findstr(nameString, '.');% % 	if ~isempty(i)% % 		dataNames = {};% 		k = 1;% 		for j = i% 			dataNames = [dataNames {nameString(k : j-1)}];% 			k = j+1;% 		end% 		dataNames = [dataNames {nameString(i(end)+1 : length(nameString))}];% % 	else% 		dataNames = {nameString};%     end% % endfunction nameString = parseDataName(nameString)%% convert c data name to a matlab friendly cell array data name.  For% example, "a[1].b" produces {'a(1)' 'b'}    nameStringIn = nameString;	% convert [] to ()	nameString = strrep(nameString,'[','(');	nameString = strrep(nameString,']',')');    	% increment array indices	iopen = findstr(nameString, '(');	iclose = findstr(nameString, ')');	if ~isempty(iopen)		k = 1;		for j = 1 : length(iopen)			nstring = nameString(iopen(j)+1 : iclose(j)-1);			if isempty(nstring)				error('isempty(nstring)');			end			n = sscanf(nstring,'%d');			n = n + 1;			nameString = sprintf('%s%d%s', nameString(1:iopen(j)), n, nameString(iclose(j) : end));		end    end        %disp(['parseDataName ' nameStringIn ' --> ' nameString]);endfunction fileInfo = countEvents(fileInfo)global longUIntFormat 	h = waitbar(0,['Counting events in ' fileInfo.fileName '...']);	waitBarUpdateRate = 10000;	nextWaitBarUpdate = waitBarUpdateRate;	fileInfo.eventCount = zeros(1, fileInfo.numberOfDefinedEvents);	fileInfo.eventDataLoc = zeros(1, 10e6);	fileInfo.eventCodes = zeros(1, 10e6);	fileInfo.numberOfEvents = 0;    byteOffset = fileInfo.bits / 8;	if fileInfo.numberOfDefinedEvents < 2^8		fileInfo.codeType = 'uint8';	elseif fileInfo.numberOfDefinedEvents < 2^16		fileInfo.codeType = 'uint16';	else		fileInfo.codeType = longUIntFormat;	end	fseek(fileInfo.fid, fileInfo.startOfData, 'bof');	numberOfEventTypes = length(fileInfo.eventDefs);	while feof(fileInfo.fid) == 0		code = fread(fileInfo.fid,1,fileInfo.codeType) + 1;		if isempty(code) || feof(fileInfo.fid)			break;		end		if code < 1 || code > numberOfEventTypes			error(['Bad event code = ' int2str(code)]);		end		fp = ftell(fileInfo.fid);		if fileInfo.eventDefs(code).dataBytes == 0			% no data			fseek(fileInfo.fid, byteOffset, 'cof');		elseif fileInfo.eventDefs(code).dataBytes == -1			% variable data			dataBytes = fread(fileInfo.fid, 1, longUIntFormat);			fseek(fileInfo.fid, dataBytes + byteOffset, 'cof');		else			% fixed length data			fseek(fileInfo.fid, fileInfo.eventDefs(code).dataBytes + byteOffset, 'cof');		end		if feof(fileInfo.fid)			break;		end		fileInfo.eventCount(code) = fileInfo.eventCount(code) + 1;		fileInfo.numberOfEvents = fileInfo.numberOfEvents + 1;		fileInfo.eventDataLoc(fileInfo.numberOfEvents) = fp;		fileInfo.eventCodes(fileInfo.numberOfEvents) = code;		if fileInfo.numberOfEvents == nextWaitBarUpdate			waitbar(fp / fileInfo.sizeOfFile,h,['Counting events in ' fileInfo.fileName '... ' int2str(fileInfo.numberOfEvents)]);			nextWaitBarUpdate = nextWaitBarUpdate + waitBarUpdateRate;		end	end	waitbar(1,h, ['Counting events in ' fileInfo.fileName '... ' int2str(fileInfo.numberOfEvents)]);	fileInfo.eventDataLoc(fileInfo.numberOfEvents + 1 : end) = [];	fileInfo.eventCodes(fileInfo.numberOfEvents+1 : end) = [];	close(h);endfunction fileInfo = countTrials(fileInfo)	h = waitbar(0,['Counting trials in ' fileInfo.fileName '...']);	waitBarUpdateRate = 10000;	nextWaitBarUpdate = waitBarUpdateRate;	fileInfo.trialStartEventCode = [];	fileInfo.trialEndEventCode = [];	for i = 1 : length(fileInfo.eventDefs)		if strcmp(fileInfo.eventDefs(i).name, 'trialStart')			fileInfo.trialStartEventCode = i;		elseif strcmp(fileInfo.eventDefs(i).name, 'trialEnd')			fileInfo.trialEndEventCode = i;		end	end	if isempty(fileInfo.trialStartEventCode)		error('No trialStart events found in this data file');	end	if isempty(fileInfo.trialEndEventCode)		error('No trialEnd events found in this file');	end	inTrialFlag = 0;	fileInfo.trialCount = 0;	fileInfo.trialEventBounds = zeros(1e5,2);	for i = 1 : fileInfo.numberOfEvents		if ~inTrialFlag && fileInfo.eventCodes(i) == fileInfo.trialStartEventCode			trialStartEvent = i;			inTrialFlag = 1;		elseif inTrialFlag && fileInfo.eventCodes(i) == fileInfo.trialEndEventCode			inTrialFlag = 0;			fileInfo.trialCount = fileInfo.trialCount + 1;			fileInfo.trialEventBounds(fileInfo.trialCount, :) = [trialStartEvent i];		elseif inTrialFlag && fileInfo.eventCodes(i) == fileInfo.trialStartEventCode			error('two trialStart events found with no intervening trialEnd event bewteen them');			% JHRM pointed out that trialEnd events can occur outside a trial			% we no longer treat this as an error			%elseif ~inTrialFlag && fileInfo.eventCodes(i) == fileInfo.trialEndEventCode			%error('trialEnd found with no trialStart');		end		if i == nextWaitBarUpdate			waitbar(i / fileInfo.numberOfEvents,h, ['Counting trials in ' fileInfo.fileName '... ' int2str(fileInfo.trialCount)]);			nextWaitBarUpdate = nextWaitBarUpdate + waitBarUpdateRate;		end	end	waitbar(1,h, ['Counting trials in ' fileInfo.fileName '... ' int2str(fileInfo.trialCount)]);	fileInfo.trialEventBounds(fileInfo.trialCount + 1 : end, :) = [];	close(h);endfunction [events, unbundledEvents] = readEventsInRange(fileInfo, firstEvent, lastEvent)% read event dataglobal longUIntFormat	eventCodeList = fileInfo.eventCodes(firstEvent : lastEvent);	e = cell(1,length(eventCodeList));	for i = 1 : length(eventCodeList)		unbundledEvents{i} = [];		eventDef = fileInfo.eventDefs(eventCodeList(i));		fseek(fileInfo.fid, fileInfo.eventDataLoc(firstEvent+i-1), 'bof');		if eventDef.dataBytes == 0			% no data		elseif eventDef.dataBytes == -1			% variable data			dataBytes = fread(fileInfo.fid,1, longUIntFormat);			unbundledEvents{i} = readVariableLengthEventData(fileInfo.fid, dataBytes, unbundledEvents{i}, eventDef);		else			% fixed length data			unbundledEvents{i} = readFixedLengthEventData(fileInfo.fid, unbundledEvents{i}, eventDef);		end		unbundledEvents{i}.timeMS = fread(fileInfo.fid,1, longUIntFormat);	end	% bundle events	events = [];	for code = unique(eventCodeList)		eventLoc = find(code == eventCodeList);		eventName = fileInfo.eventDefs(code).dataDef(1).dataName;		if strcmp(fileInfo.eventDefs(code).dataDef(1).typeName, 'struct')			% bundle structure			events.(eventName).timeMS = zeros(length(eventLoc), 1);			for i = 1 : length(eventLoc)				index = eventLoc(i);				events.(eventName).data(i) = unbundledEvents{index}.(eventName);				events.(eventName).timeMS(i) = unbundledEvents{index}.timeMS;			end		elseif strcmp(fileInfo.eventDefs(code).dataDef(1).typeName,'string')			% bundle string			events.(eventName).data = cell(length(eventLoc), 1);			events.(eventName).timeMS = zeros(length(eventLoc), 1);			for i = 1 : length(eventLoc)				index = eventLoc(i);				events.(eventName).data{i} = unbundledEvents{index}.(eventName);								events.(eventName).timeMS(i) = unbundledEvents{index}.timeMS;			end		elseif strcmp(fileInfo.eventDefs(code).dataDef(1).typeName,'no data')			% bundle event times only			events.(eventName).timeMS = zeros(length(eventLoc), 1);			for i = 1 : length(eventLoc)				events.(eventName).timeMS(i) = unbundledEvents{eventLoc(i)}.timeMS;			end		else			% bundle other non-structure event			events.(eventName).data = [];			events.(eventName).timeMS = zeros(length(eventLoc), 1);			for i = 1 : length(eventLoc)				index = eventLoc(i);				events.(eventName).data = [events.(eventName).data ; unbundledEvents{index}.(eventName)];				events.(eventName).timeMS(i) = unbundledEvents{index}.timeMS;			end		end	endendfunction event = readVariableLengthEventData(fid, dataBytes, event, eventDef)	if strcmp(eventDef.dataStruct(1).type, 'char')		v = char((fread(fid, dataBytes / eventDef.dataStruct(1).elementBytes, eventDef.dataStruct(1).type))');	else		v = fread(fid, dataBytes / eventDef.dataStruct(1).elementBytes, eventDef.dataStruct(1).type);	end	event = assignStruct(event, eventDef.dataStruct(1).fieldNames, v);endfunction event = readFixedLengthEventData(fid, event, eventDef)	fp = ftell(fid);	for i = 1 : length(eventDef.dataStruct)		fseek(fid, fp + eventDef.dataStruct(i).offsetBytes, 'bof');		if strcmp(eventDef.dataStruct(i).type, 'char')			v = char((fread(fid, eventDef.dataStruct(i).elements, eventDef.dataStruct(i).type))');		else			v = fread(fid, eventDef.dataStruct(i).elements, eventDef.dataStruct(i).type);		end		if ~strcmp(eventDef.dataStruct(i).fieldNames{1},'junk')			event = assignStruct(event, eventDef.dataStruct(i).fieldNames, v);		end	endendfunction s = assignStruct(s, fn, v)% perform dynamic field allocation	if length(fn) > 10		s = stringAssignStruct(s,fn,v);	else		try			switch length(fn)				case 0					s = [];				case 1					s.(fn{1}) = v;				case 2					s.(fn{1}).(fn{2}) = v;				case 3					s.(fn{1}).(fn{2}).(fn{3}) = v;				case 4					s.(fn{1}).(fn{2}).(fn{3}).(fn{4}) = v;				case 5					s.(fn{1}).(fn{2}).(fn{3}).(fn{4}).(fn{5}) = v;				case 6					s.(fn{1}).(fn{2}).(fn{3}).(fn{4}).(fn{5}).(fn{6}) = v;				case 7					s.(fn{1}).(fn{2}).(fn{3}).(fn{4}).(fn{5}).(fn{6}).(fn{7}) = v;				case 8					s.(fn{1}).(fn{2}).(fn{3}).(fn{4}).(fn{5}).(fn{6}).(fn{7}).(fn{8}) = v;                case 9					s.(fn{1}).(fn{2}).(fn{3}).(fn{4}).(fn{5}).(fn{6}).(fn{7}).(fn{8}).(fn{9}) = v;                case 10					s.(fn{1}).(fn{2}).(fn{3}).(fn{4}).(fn{5}).(fn{6}).(fn{7}).(fn{8}).(fn{9}).(fn{10}) = v;			end		catch			s = stringAssignStruct(s,fn,v);		end	endendfunction s = stringAssignStruct(s,fn,v)%% the above dynamic field allocation does not like arrays such as% a(1).b etc.  Thus we have to use strings which are probably% slower.	x = 's';	for i = 1 : length(fn)		x = [x '.' fn{i}];    end%    disp([x '=v;']);    	eval([x '=v;']);end