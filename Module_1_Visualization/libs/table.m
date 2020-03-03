classdef (Sealed) table < tabular
%TABLE Table.
%   Tables are used to collect heterogeneous data and metadata into a single
%   container.  Tables are suitable for storing column-oriented or tabular data
%   that are often stored as columns in a text file or in a spreadsheet.  Tables
%   can accommodate variables of different types, sizes, units, etc.  They are
%   often used to store experimental data, with rows representing different
%   observations and columns representing different measured variables.
%
%   Use the TABLE constructor to create a table from variables in the MATLAB
%   workspace.  Use the readtable function to create a table by reading data
%   from a text or spreadsheet file.
%
%   The TABLE constructor can also be used to create tables without
%   providing workspace variables, by providing the size and variable
%   types.
%
%   Tables can be subscripted using parentheses much like ordinary numeric
%   arrays, but in addition to numeric and logical indices, you can use a
%   table's variable and row names as indices.  You can access individual
%   variables in a table much like fields in a structure, using dot
%   subscripting.  You can access the contents of one or more variables using
%   brace subscripting.
%
%   Tables can contain different kinds of variables, including numeric,
%   logical, character, string, categorical, and cell.  However, a table is
%   a different class than the variables that it contains.  For example,
%   even a table that contains only variables that are double arrays cannot
%   be operated on as if it were itself a double array.  However, using dot
%   subscripting, you can operate on a variable in a table as if it were a
%   workspace variable.  Using brace subscripting, you can operate on one
%   or more variables in a table as if they were in a homogeneous array.
%
%   A table T has properties that store metadata such as its variable and row
%   names.  Access or assign to a property using P = T.Properties.PropName or
%   T.Properties.PropName = P, where PropName is one of the following:
%
%   TABLE metadata properties:
%       Description          - A character vector describing the table
%       DimensionNames       - A two-element cell array of character vectors containing names of
%                              the dimensions of the table
%       VariableNames        - A cell array containing names of the variables in the table
%       VariableDescriptions - A cell array of character vectors containing descriptions of the
%                              variables in the table
%       VariableUnits        - A cell array of character vectors containing units for the variables
%                              in table
%       VariableContinuity   - An array containing a matlab.tabular.Continuity value for each table 
%                              variable, specifying whether a variable represents continuous or discrete 
%                              data values. You can assign 'unset', 'continuous', 'step', or 'event' to
%                              elements of VariableContinuity.
%       RowNames             - A cell array of nonempty, distinct character vectors containing names
%                              of the rows in the table
%       UserData             - A variable containing any additional information associated
%                              with the table.  You can assign any value to this property.
%       CustomProperties     - A container for user-defined per-table or per-variable custom 
%                              metadata fields.
%
%   TABLE methods and functions:
%     Construction and conversion:
%       table              - Create a table from workspace variables.
%       array2table        - Convert homogeneous array to table.
%       cell2table         - Convert cell array to table.
%       struct2table       - Convert structure array to table.
%       table2array        - Convert table to a homogeneous array.
%       table2cell         - Convert table to cell array.
%       table2struct       - Convert table to structure array.
%     Import and export:
%       readtable          - Create a table by reading from a file.
%       writetable         - Write a table to a file.
%       write              - Write a table to a file.
%     Size and shape:
%       istable            - True for tables.
%       size               - Size of a table.
%       width              - Number of variables in a table.
%       height             - Number of rows in a table.
%       ndims              - Number of dimensions of a table.
%       numel              - Number of elements in a table.
%       horzcat            - Horizontal concatenation for tables.
%       vertcat            - Vertical concatenation for tables.
%     Set membership:
%       intersect          - Find rows common to two tables.
%       ismember           - Find rows in one table that occur in another table.
%       setdiff            - Find rows that occur in one table but not in another.
%       setxor             - Find rows that occur in one or the other of two tables, but not both.
%       unique             - Find unique rows in a table.
%       union              - Find rows that occur in either of two tables.
%     Data manipulation and reorganization:
%       summary            - Print summary of a table.
%       addvars            - Insert new variables at a specified location in a table.
%       movevars           - Move table variables to a specified location.
%       removevars         - Delete the specified table variables.
%       splitvars          - Splits multi-column variables into separate variables.
%       mergevars          - Merges multiple variables into one multi-column variable or a nested table.
%       convertvars        - Converts table variables to a specified data type.
%       sortrows           - Sort rows of a table.
%       stack              - Stack up data from multiple variables into a single variable.
%       unstack            - Unstack data from a single variable into multiple variables.
%       join               - Merge two tables by matching up rows using key variables.
%       innerjoin          - Inner join between two tables.
%       outerjoin          - Outer join between two tables.
%       rows2vars          - Reorient rows to be variables of output table.
%       inner2outer        - Invert a nested table-in-table hierarchy.
%       ismissing          - Find elements in a table that contain missing values.
%       standardizeMissing - Insert missing data indicators into a table.
%     Computations on tables:
%       varfun             - Apply a function to variables in a table.
%       rowfun             - Apply a function to rows of a table.
%
%   Examples:
%
%      % Create a table from individual workspace variables.
%      load patients
%      patients = table(LastName,Gender,Age,Height,Weight,Smoker,Systolic,Diastolic)
%
%      % Select the rows for patients who smoke, and a subset of the variables.
%      smokers = patients(patients.Smoker == true, {'LastName' 'Gender' 'Systolic' 'Diastolic'})
%
%      % Convert the two blood pressure variables into a single variable.
%      patients.BloodPressure = [patients.Systolic patients.Diastolic];
%      patients(:,{'Systolic' 'Diastolic'}) = []
%
%      % Pick out two specific patients by the LastName variable.
%      patients(ismember(patients.LastName,{'Smith' 'Jones'}), :)
%
%      % Convert the LastName variable into row names.
%      patients.Properties.RowNames = patients.LastName;
%      patients.LastName = []
%
%      % Use the row names to pick out two specific patients.
%      patients({'Smith' 'Jones'},:)
%
%      % Add metadata to the table.
%      patients.Properties.Description = 'Simulated patient data';
%      patients.Properties.VariableUnits =  {''  'Yrs'  'In'  'Lbs'  ''  'mm Hg'};
%      patients.Properties.VariableDescriptions{6} = 'Systolic/Diastolic';
%      summary(patients)
%
%      % Create a new variable in the table from existing variables.
%      patients.BMI = (patients.Weight * 0.453592) ./ (patients.Height * 0.0254).^2
%      patients.Properties.VariableUnits{'BMI'} =  'kg/m^2';
%      patients.Properties.VariableDescriptions{'BMI'} = 'Body Mass Index';
%
%      % Sort the table based on the new variable.
%      sortrows(patients,'BMI')
%
%      % Make a scatter plot of two of the table's variables.
%      plot(patients.Height,patients.Weight,'o')
%
%      % Create tables from text and spreadsheet files
%      patients2 = readtable('patients.dat','ReadRowNames',true)
%      patients3 = readtable('patients.xls','ReadRowNames',true)
%
%      % Create a table from a numeric matrix
%      load tetmesh.mat
%      t = array2table(X,'VariableNames',{'x' 'y' 'z'});
%      plot3(t.x,t.y,t.z,'.')
%
%   See also TABLE, CATEGORICAL

%   Copyright 2012-2018 The MathWorks, Inc.

    properties(Constant, Access='protected')
        % Constant properties are not persisted when serialized
        propertyNames = table.getPropertyNamesList;
        defaultDimNames = matlab.internal.tabular.private.metaDim.dfltLabels;
        dispRowLabelsHeader = false;
        emptyPropertiesObj = matlab.tabular.TableProperties; % Used by getProperties, setProperties
    end
    
    properties(Access='protected')
        % * DO NOT MODIFY THIS LIST OF NON-TRANSIENT INSTANCE PROPERTIES *
        % Declare any additional properties in the Transient block below,
        % and add proper logic in saveobj/loadobj to handle persistence
        data = cell(1,0);
    end
    
    properties(Transient, Access='protected')
        % Create the metaDim with dim names backwards compatibility turned on
        metaDim = matlab.internal.tabular.private.metaDim(2,table.defaultDimNames,true);
        rowDim  = matlab.internal.tabular.private.rowNamesDim(0);
        varDim  = matlab.internal.tabular.private.varNamesDim(0);
        
        % 'Properties' will appear to contain this, as well as the per-row, per-var,
        % and per-dimension properties contained in rowDim, varDim. and metaDim,
        arrayProps = tabular.arrayPropsDflts;
    end
        
    methods
        function t = table(varargin)
        %TABLE Create a table from workspace variables or with a given size.
        %   T = TABLE(VAR1, VAR2, ...) creates a table T from the workspace
        %   variables VAR1, VAR2, ... .  All variables must have the same number
        %   of rows.
        %
        %   T = TABLE('Size', [N M], 'VariableTypes', {'type1', ..., 'typeM'}) 
        %   creates a table with the given size and variable types. Each
        %   variable in T has N rows to contain data that you assign later.
        %
        %   T = TABLE(..., 'VariableNames', {'name1', ..., 'name_M'}) creates a
        %   table containing variables that have the specified variable names.
        %   The names must be valid MATLAB identifiers, and unique.
        %
        %   T = TABLE(..., 'RowNames', {'name1', ..., 'name_N'}) creates a table
        %   that has the specified row names.  The names need not be valid MATLAB
        %   identifiers, but must be unique.
        %
        %   Tables can contain variables that are built-in types, or objects that
        %   are arrays and support standard MATLAB parenthesis indexing of the form
        %   var(i,...), where i is a numeric or logical vector that corresponds to
        %   rows of the variable.  In addition, the array must implement a SIZE method
        %   with a DIM argument, and a VERTCAT method.
        %
        %
        %   Examples:
        %      % Create a table from individual workspace variables.
        %      load patients
        %      patients = table(LastName,Gender,Age,Height,Weight,Smoker,Systolic,Diastolic)
        %      patients.Properties.Description = 'Simulated patient data';
        %      patients.Properties.VariableUnits =  {''  ''  'Yrs'  'In'  'Lbs'  ''  'mm Hg'  'mm Hg'};
        %
        %   See also READTABLE, CELL2TABLE, ARRAY2TABLE, STRUCT2TABLE.
            import matlab.internal.datatypes.isText
            import matlab.internal.datatypes.isIntegerVals
            import matlab.internal.datatypes.parseArgsTabularConstructors
        
            if nargin == 0
                % Nothing to do
            else
                % Count number of data variables and the number of rows, and
                % check each data variable.
                [numVars,numRows] = tabular.countVarInputs(varargin);
                
                if numVars < nargin
                    pnames = {'Size' 'VariableTypes' 'VariableNames'  'RowNames' };
                    dflts =  {    []              {}              {}          {} };
                    partialMatchPriority = [0 0 1 0]; % 'Var' -> 'VariableNames' (backward compat)
                    try
                        [sz, vartypes, varnames,rownames,supplied] ...
                            = parseArgsTabularConstructors(pnames, dflts, partialMatchPriority, varargin{numVars+1:end});
                    catch ME
                        % The inputs included a 1xM char row that was interpreted as the
                        % start of param name/value pairs, but something went wrong. If
                        % all of the preceding inputs had one row, the WrongNumberArgs
                        % or BadParamName (when the unrecognized name was first among
                        % params) errors suggest that the char row might have been
                        % intended as data. Suggest alternative options in that case.
                        errIDs = {'MATLAB:table:parseArgs:WrongNumberArgs' ...
                                  'MATLAB:table:parseArgs:BadParamNamePossibleCharRowData'};
                        if any(strcmp(ME.identifier,errIDs))
                            if strcmp(ME.identifier,'MATLAB:table:parseArgs:BadParamNamePossibleCharRowData')
                                % parseArgsTabularConstructors throws BadParamNamePossibleCharRowData
                                % to indicate when the bad param name was first, replace that.
                                ME = ME.cause{1};
                            end
                            if (numVars == 0) || (numRows == 1)
                                pname1 = varargin{numVars+1}; % always the first char row vector
                                cause = MException(message('MATLAB:table:ConstructingFromCharRowData',pname1));
                                ME = ME.addCause(cause);
                            end
                        end
                        throw(ME);
                    end
                else
                    supplied.Size = false;
                    supplied.VariableTypes = false;
                    supplied.VariableNames = false;
                    supplied.RowNames = false;
                end
                
                if supplied.Size % preallocate from specified size and var types
                    if numVars > 0
                        % If using 'Size' parameter, cannot have data variables as inputs
                        error(message('MATLAB:table:InvalidSizeSyntax'));                    
                    elseif ~isIntegerVals(sz,0) || ~isequal(numel(sz),2)
                        error(message('MATLAB:table:InvalidSize'));
                    end
                    sz = double(sz);
                    
                    if sz(2) == 0
                        % If numVars is 0, VariableTypes must be empty (or not supplied)
                        if ~isequal(numel(vartypes),0)
                            error(message('MATLAB:table:VariableTypesAndSizeMismatch'))
                        end
                    elseif ~supplied.VariableTypes
                        error(message('MATLAB:table:MissingVariableTypes'));
                    elseif ~isText(vartypes,true) % require list of names
                        error(message('MATLAB:table:InvalidVariableTypes'));
                    elseif ~isequal(sz(2), numel(vartypes))
                        error(message('MATLAB:table:VariableTypesAndSizeMismatch'))
                    end
                    
                    numRows = sz(1); numVars = sz(2);
                    vars = tabular.createVariables(vartypes,sz);
                    
                    if ~supplied.VariableNames
                        % Create default var names, which never conflict with
                        % the default row times name.
                        varnames = t.varDim.dfltLabels(1:numVars);
                    end
                    
                else % create from data variables
                    if supplied.VariableTypes
                        % VariableTypes may not be supplied with data variables
                        error(message('MATLAB:table:IncorrectVariableTypesSyntax'));
                    end
                    
                    vars = varargin(1:numVars);
                    
                    if supplied.RowNames
                        if numVars == 0, numRows = length(rownames); end
                    else
                        rownames = {};
                    end

                    if ~supplied.VariableNames
                        % Get the workspace names of the input arguments from inputname
                        varnames = repmat({''},1,numVars);
                        for i = 1:numVars, varnames{i} = inputname(i); end
                        % Fill in default names for data args where inputname couldn't
                        empties = cellfun('isempty',varnames);
                        if any(empties)
                            varnames(empties) = t.varDim.dfltLabels(find(empties)); %#ok<FNDSB>
                        end
                        % Make sure default names or names from inputname don't conflict
                        varnames = matlab.lang.makeUniqueStrings(varnames,{},namelengthmax);
                    end
                end
                t = t.initInternals(vars, numRows, rownames, numVars, varnames);
                
                % Detect conflicts between the var names and the default dim names.
                t.metaDim = t.metaDim.checkAgainstVarLabels(varnames);
            end
        end % table constructor
    end % methods block
    
    methods(Hidden) % hidden methods block
        write(t,filename,varargin)
    end
            
    methods(Hidden, Static)
        % This function is for internal use only and will change in a
        % future release.  Do not use this function.
        t = readFromFile(filename,args)
        
        function t = empty(varargin)
        %EMPTY Create an empty table.
        %   T = TABLE.EMPTY() creates a 0x0 table.
        %
        %   T = TABLE.EMPTY(NROWS,NVARS) or T = TABLE.EMPTY([NROWS NVARS]) creates an
        %   NROWSxNVARS table.  At least one of NROWS or NVARS must be zero.
        %
        %   See also TABLE, ISEMPTY.
            if nargin == 0
                t = table();
            else
                sizeOut = size(zeros(varargin{:}));
                if prod(sizeOut) ~= 0
                    error(message('MATLAB:table:empty:EmptyMustBeZero'));
                elseif length(sizeOut) > 2
                    error(message('MATLAB:table:empty:EmptyMustBeTwoDims'));
                else
                    % Create a 0x0 table, and then resize to the correct number
                    % of rows or variables.
                    t = table();
                    if sizeOut(1) > 0
                        t.rowDim = t.rowDim.lengthenTo(sizeOut(1));
                    end
                    if sizeOut(2) > 0
                        t.varDim = t.varDim.lengthenTo(sizeOut(2));
                        t.data = cell(1,sizeOut(2)); % assume double
                    end
                end
            end
        end
        
        % Called by cell2table, struct2table
        function t = fromScalarStruct(s)
            % This function is for internal use only and will change in a
            % future release.  Do not use this function.
            
            % Construct a table from a scalar struct
            vnames = fieldnames(s);
            p = length(vnames);
            if p > 0
                n = unique(structfun(@(f)size(f,1),s));
                if ~isscalar(n)
                    error(message('MATLAB:table:UnequalFieldLengths'));
                end
            else
                n = 0;
            end
            t = table.init(struct2cell(s)',n,{},p,vnames);
        end
        
        function t = init(vars, numRows, rowLabels, numVars, varnames, varDimName)
            % INIT creates a table from data and metadata.  It bypasses the input parsing
            % done by the constructor, but still checks the metadata.
            % This function is for internal use only and will change in a future release.  Do not
            % use this function.
            t = table();
            t = t.initInternals(vars, numRows, rowLabels, numVars, varnames);
            if nargin == 6
                t.metaDim = t.metaDim.setLabels(varDimName,2);
            end
        end
    end % hidden static methods block
        
    methods(Access = 'protected')
        function b = cloneAsEmpty(a) %#ok<MANU>
            %CLONEASEMPTY Create a new empty table from an existing one.
%             if strcmp(class(a),'table') %#ok<STISA>
                b = table();
%             else % b is a subclass of table
%                 b = a; % respect the subclass
%                 % leave b.metaDim alone
%                 b.rowDim = b.rowDim.createLike(0);
%                 b.varDim = b.varDim.createLike(0);
%                 b.data = cell(1,0);
%                 leave b.arrayProps alone
%             end
        end
        
        function errID = throwSubclassSpecificError(obj,msgid,varargin)
            % Throw the table version of the msgid error, using varargin as the
            % variables to fill the holes in the message.
            errID = throwSubclassSpecificError@tabular(obj,['table:' msgid],varargin{:});
            if nargout == 0
                throwAsCaller(errID);
            end
        end
        
        function rowLabelsStruct = summarizeRowLabels(~)
            % SUMMARIZEROWLABELS is called by summary method to get a struct containing
            % a summary of the row labels.
            
            % Empty for table
            rowLabelsStruct = struct;
        end
        
        function printRowLabelsSummary(~,~)
            % PRINTROWLABELSSUMMARY is called by summary method to print the row labels
            % summary. No-op for table.
        end
        
        % used by varfun and rowfun
        function id = specifyInvalidOutputFormatID(~,funName)
            id = "MATLAB:table:" + funName + ":InvalidOutputFormat";
        end
    end
    
    methods(Access = 'private', Static)
        t = readTextFile(file,args)
        t = readXLSFile(xlsfile,args)
        
        function propNames = getPropertyNamesList()
            % Need to manage CustomProperties which are stored in two different
            % places.
            arrayPropsMod = tabular.arrayPropsDflts;
            arrayPropsMod = rmfield(arrayPropsMod, 'TableCustomProperties');
            arrayPropsMod = fieldnames(arrayPropsMod);
            propNames = [arrayPropsMod; ...
                matlab.internal.tabular.private.metaDim.propertyNames; ...
                matlab.internal.tabular.private.varNamesDim.propertyNames; ...
                matlab.internal.tabular.private.rowNamesDim.propertyNames; ...
                'CustomProperties'];
        end
    end
    
    %%%%% PERSISTENCE BLOCK ensures correct save/load across releases %%%%%
    %%%%% Properties and methods in this block maintain the exact class %%%
    %%%%% schema required for TABLE to persist through MATLAB releases %%%%
    properties(Access='private')
        % ** DO NOT EDIT THIS LIST OR USE THESE PROPERTIES INSIDE TABLE **
        % These properties mirror the pre-R2016b internal representation, which was also
        % the external representation saved to mat files. Post-R2016b saveobj and loadobj
        % continue to use them as the external representation for save/load compatibility
        % with earlier releases.
        ndims;
        nrows;
        rownames;
        nvars;
        varnames;
        props;
        
        
    end
    
    properties(Constant, Access='protected')
        % Version of this table serialization and deserialization format.
        % This is used for managing forward compatibility. Value is saved
        % in 'versionSavedFrom' when an instance is serialized.
        %
        %   1.0 : 13b. first shipping version
        %   2.0 : 16b. re-architecture for tabular
        %   2.1 : 17b. added continuity
        %   2.2 : 18a. added serialized field 'incompatibilityMsg' to support 
        %              customizable 'kill-switch' warning message. The field
        %              is only consumed in loadobj() and does not translate
        %              into any table property.
        %   3.0 : 18b. added 'CustomProps' and 'VariableCustomProps' via
        %              tabular/saveobj to preserve per-table and per-variable
        %              custom properties
        version = 3.0;
    end
    
    methods(Hidden)
        function tsave = saveobj(t)
            % this saveobj is designed for 2D table only
            assert(t.metaDim.length==2);
            
            tsave = t;
            
            % The .data property is not transient, it will always be be saved. The other
            % (metadata) properties are transient, their values are saved by copying to
            % the corresponding (non-transient) properties of the external representation.
            tsave.ndims = t.metaDim.length;
            tsave.nrows = t.rowDim.length;
            tsave.nvars = t.varDim.length;
            tsave.rownames = t.rowDim.labels;
            tsave.varnames = t.varDim.labels;
            
            % .props is a scalar struct to contain any remaining metadata.
            % At load time, table ignores any field it does not recognize.
            % Additional data that needs to be persisted shall be packaged
            % and attached to tsave.props as one of its fields, such as:
            %
            %     tsave.props.serializedObj
            %
            % Also add corresponding deserialization logic in loadobj below
            tsave.props = saveobj@tabular(t,tsave.props);            
            tsave.props = t.setCompatibleVersionLimit(tsave.props, 1.0);
            tsave.props.VersionSavedFrom = tsave.props.versionSavedFrom; % DO NOT change: must be maintained to preserve 16b-17b compatibility
            
            tsave.props.Description = t.arrayProps.Description;
            tsave.props.DimensionNames = t.metaDim.labels;
            tsave.props.UserData = t.arrayProps.UserData;
            tsave.props.VariableDescriptions = t.varDim.descrs;
            tsave.props.VariableUnits = t.varDim.units;
           
            if isenum(t.varDim.continuity)
                tsave.props.VariableContinuity = cellstr(t.varDim.continuity);
            else
                tsave.props.VariableContinuity = {}; % [] saved as {} to keep it consistent with above
            end
        end
    end
    
    methods(Hidden, Static)
        function t = loadobj(s)            
            % s might be a table, or it might be a scalar struct. In either case, copy its
            % data into an empty table, then copy its metadata from the external
            % representation into the current class schema.
            t = table();
            
            % Handle cases where variables data fail to load correctly
            s = tabular.handleFailedToLoadVars(s, s.nrows, s.nvars, s.varnames);
            
            % Return an empty instance if current version is below the
            % minimum compatible version of the serialized object
            serialized_props = s.props;
            if isfield(serialized_props,'VersionSavedFrom') && ...
                    serialized_props.VersionSavedFrom>=2.2 && ...
                    t.isIncompatible(serialized_props, 'MATLAB:table:IncompatibleLoad')
                return;
            end            
            
            % Restore core data
            t.data = s.data;

            % Avoid calling setDescription and setUserData for performance, as their values
            % are ASSUMED to be valid coming from a MAT file
            t.arrayProps.Description = s.props.Description;
            t.arrayProps.UserData    = s.props.UserData;
            
            % Pre-R2016b tables (i.e. no 'VersionSavedFrom' field) might have DimensionNames
            % that do not satisfy current requirements to support new dot subscripting
            % functionality added in R2016b. To allow loading such existing tables, modify
            % any invalid names and warn. See metaDim class for details. This is only
            % an issue for tables saved pre-2016b, newer versions with out-of-model
            % DimensionNames could not have been created to begin with. Even for pre-2016b,
            % the defaults met those requirements so the names would have had to have been
            % set explicitly.
            if isfield(s.props,'VersionSavedFrom') % post-R2016b table
                t.metaDim = t.metaDim.initWithCompatibility(s.ndims, s.props.DimensionNames);
            else % pre-R2016b table
                dimNames = s.props.DimensionNames;
                if strcmp(dimNames(2),'Variable')
                    % If the second dim name is the old default, assume it has never been changed,
                    % probably never even looked at, and update it to the current default to make it
                    % consistent with the new design. Otherwise, leave it alone.
                    dimNames(2) = t.defaultDimNames(2);
                end

                dimNames  = t.metaDim.fixLabelsForCompatibility(dimNames);
                t.metaDim = t.metaDim.initWithCompatibility(2, dimNames);
                t.metaDim = t.metaDim.checkAgainstVarLabels(s.varnames);
            end
            
            % Pre-R2016b, a 0x0 cell for rownames implicitly indicated no row names, while a 0x1
            % indicated a 0xN table _with_ row names. R2016b-on use rowDim.hasLabels explicitly,
            % which gets set correctly here as false and true, respectively, in those two cases.
            if isequal(s.rownames,{})
                t.rowDim = t.rowDim.init(s.nrows);
            else
                t.rowDim = t.rowDim.init(s.nrows, s.rownames);
            end

            % Restore variable-dimension & metaData
            if ~isfield(s.props,'VersionSavedFrom') || s.props.VersionSavedFrom <= 2.0
                t.varDim = t.varDim.init(s.nvars, ...
                                     s.varnames, ...
                                     s.props.VariableDescriptions, ...
                                     s.props.VariableUnits);
            elseif (s.props.VersionSavedFrom >= 2.1) && (s.props.VersionSavedFrom < 3.0)
                t.varDim = t.varDim.init(s.nvars, ...
                                     s.varnames, ...
                                     s.props.VariableDescriptions, ...
                                     s.props.VariableUnits, ...
                                     s.props.VariableContinuity);
            else % s.props.VersionSavedFrom >= 3.0
                t.arrayProps.TableCustomProperties = s.props.CustomProps;
                t.varDim = t.varDim.init(s.nvars, ...
                                     s.varnames, ...
                                     s.props.VariableDescriptions, ...
                                     s.props.VariableUnits, ...
                                     s.props.VariableContinuity, ...
                                     s.props.VariableCustomProps);
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%% END PERSISTENCE BLOCK %%%%%%%%%%%%%%%%%%%%%%%%
end % classdef


% function v = createVariables(types,sz)
%     % Clean up and replace known types with default fill values  
%     % Tag on empty method and eval
%     types = strcat(types,'.empty(1,0)'); % need to create with 1 row so repmat works
%     types(cellfun(@(s) strcmp(s,'cellstr.empty(1,0)'),types)) = {'{''''}'}; % special case for cellstr
%     v = cell(size(types));
%     for ii = 1:numel(types)
%         v{ii} = eval(types{ii});
%     end
%     
%     % Replace empties with fill values for known types
%     v = cellfun(@fillDefaultValues,v,'UniformOutput',false);
%     v = cellfun(@(x)repmat(x,sz(1),1),v,'UniformOutput',false);
% end
% 
% function c = fillDefaultValues(val)
%     % Replace empties with default values for known types
%     if isstring(val)
%         c = string(missing);
%     elseif isnumeric(val)
%         c = zeros(1,1,'like',0);
%     elseif iscategorical(val)
%         c = categorical(missing);
%     elseif isdatetime(val)
%         c = NaT;
%     elseif isduration(val)
%         c = duration(missing);
%     elseif ischar(val)
%         c = char.empty(1,0);
%     else
%         c = val;
%     end
% end