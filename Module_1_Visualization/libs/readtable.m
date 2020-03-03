function t = readtable(location,varargin)
%READTABLE Create a table by reading from a file.
%   Use the READTABLE function to create a table by reading column-oriented 
%   data from a file stored at a LOCATION. READTABLE can automatically determine 
%   the file format from its extension as described below.
%
%   T = READTABLE(LOCATION) creates a table by reading from a file stored at
%       LOCATION, where LOCATION can be one of these:
%       - For local files, LOCATION must be a full path that contains
%         a filename and file extension. LOCATION can also be a relative path
%         to the current directory, or to a directory on the MATLAB path.
%         For example, to import a file on the MATLAB path
%            T = readtable('patients.xls');
%       - For remote files, LOCATION must be a full path using an internationalized
%         resource identifier (IRI). For example, to import a remote file from
%         Amazon S3 cloud specify the full IRI for the file:
%            T = readtable('s3://bucketname/path_to_file/my_table.xls');
%         For more information on accessing remote data, see "Read Remote Data"
%         in the documentation.
%
%   T = READTABLE(LOCATION,'FileType',FILETYPE) specifies the file type, where
%   FILETYPE is one of 'text' or 'spreadsheet'.
%
%   T = READTABLE(LOCATION,OPTS) creates a table by reading from a file stored 
%   at LOCATION using the supplied ImportOptions OPTS. OPTS specifies variable 
%   names, selected variable names, variable types, and other information regarding 
%   the location of the data.
%
%   For example, import a sub-set of the data in a file:
%       opts = detectImportOptions('patients.xls') opts.SelectedVariableNames =
%       {'Systolic','Diastolic'} T = readtable('patients.xls',opts)
%
%   READTABLE reads data from different file types as follows:
%
%   .txt, .dat, .csv:  Delimited text file.
%
%          Reading from a delimited text file creates one variable in T for each
%          column in the file. Variable names are taken from the first row of the
%          file. By default, the variables created are either double, if the entire
%          column is numeric, datetime, duration, or text. If data in a column cannot be 
%          converted to numeric, datetime or duration, the column is imported as text.
%          READTABLE converts empty fields in the file to either NaN
%          (for a numeric or duration variable), NaT (for a datetime variable), or the empty 
%          character vector or string (for a text variables). Insignificant whitespace 
%          in the file is ignored.
%
%          Use the following optional parameter name/value pairs to control how data
%          are read from a delimited text file:
%
%          'Delimiter'     The delimiter used in the file. Can be any of ' ',
%                          '\t', ',', ';', '|' or their corresponding names 'space',
%                          'tab', 'comma', 'semi', or 'bar'. If unspecified,
%                          READTABLE detects the delimiter automatically.
%
%          'ReadVariableNames'  A logical value that specifies whether or not
%                          the first row (after skipping HeaderLines) of the file is
%                          treated as variable names. If unspecified, READTABLE
%                          detects the presence of variable names automatically.
%
%          'ReadRowNames'  A logical value that specifies whether or not the
%                          first column of the file is treated as row names. Default
%                          is false. If the 'ReadVariableNames' and 'ReadRowNames'
%                          parameter values are both true, the name in the first
%                          column of the first row is saved as the first dimension
%                          name for the table.
%
%          'TreatAsEmpty'  One or more text values to be treated as the empty
%                          in a numeric column. This may be a character vector, a
%                          cell array of character vectors, or string array. Table 
%                          elements corresponding to these are set to NaN. 'TreatAsEmpty' 
%                          only applies to numeric columns in the file, and numeric
%                          literals such as '-99' are not accepted.
%
%          'HeaderLines'   The number of lines to skip at the beginning of the
%                          file. If unspecified, READTABLE detects the number of
%                          lines to skip automatically.
%
%          'Format'        A format specifier to define the columns in the file,
%                          as accepted by the TEXTSCAN function. Type
%                          "help textscan" for information about format strings and
%                          additional parameters. Specifying the format can
%                          significantly improve speed for some large files. If
%                          unspecified, READTABLE detects the format automatically.
%
%          'DateLocale'    The locale that READTABLE uses to interpret month and
%                          day names in datetime text read with the %D format
%                          specifier. LOCALE must be a character vector or scalar
%                          string in the form xx_YY. See the documentation for
%                          DATETIME for more information.
%
%          'Encoding'      The character encoding scheme associated with the
%                          file. It must be 'system' or a name or alias for an
%                          encoding scheme. READTABLE supports the same character
%                          encodings as FOPEN. Some examples are 'UTF-8', 'latin1',
%                          'US-ASCII', and 'Shift_JIS'. If the 'Encoding' parameter
%                          value is 'system', then READTABLE uses your system's
%                          default encoding.
%
%                          See the documentation for FOPEN for more information.
%
%          'TextType'      The output type of text variables. Text variables are
%                          those with %s, %q, or %[...] formats. It can have either
%                          of the following values:
%                             'char'   - Return text as a cell array of
%                                        character vectors.
%                             'string' - Return text as a string array.
%
%          'DatetimeType'  The output type of date variables. The possible values
%                          are:                         
%                              'datetime' - Return dates as MATLAB datetimes.
%                              'text'     - Return dates as text.
%
%          'DurationType'  The output type of time variables. The possible
%                          values are:
%                              'duration' - Return time data as MATLAB durations.
%                              'text'     - Return time data as text.
%
%   .xls, .xlsx, .xlsb, .xlsm, .xltm, .xltx, .ods:  Spreadsheet file.
%
%          Reading from a spreadsheet file creates one variable in T for each column
%          in the file. By default, the variables created are either double, datetime or text.
%          Variable names are taken from the first row of the spreadsheet.
%
%          Use the following optional parameter name/value pairs to control how data
%          are read from a spreadsheet file:
%
%          'ReadVariableNames'  A logical value that specifies whether or not
%                          the first row of the specified region of the file is
%                          treated as variable names. Default is true.
%
%          'ReadRowNames'  A logical value that specifies whether or not the
%                          first column of specified region of the file is treated as
%                          row names. Default is false. If the 'ReadVariableNames'
%                          and 'ReadRowNames' parameter values are both true, the
%                          name in the first column of the first row is saved as the
%                          first dimension name for the table.
%
%          'TreatAsEmpty'  One or more text values to be treated as an empty cell
%                          in a numeric column. This may be a character vector, a
%                          cell array of character vectors, or string array. Table
%                          elements corresponding to these are set to NaN.
%                          'TreatAsEmpty' only applies to numeric columns in the
%                          file, and numeric literals such as '-99' are not accepted.
%
%          'Sheet'         The sheet to read, specified as the worksheet name,
%                          or a positive integer indicating the worksheet index.
%
%          'Range'         A character vector or scalar string that specifies a
%                          rectangular portion of the worksheet to read, using the
%                          Excel A1 reference style. If the spreadsheet contains
%                          figures or other non-tabular information, you should use
%                          the 'Range' parameter to read only the tabular data. By
%                          default, READTABLE reads data from a spreadsheet
%                          contiguously out to the right-most column that contains
%                          data, including any empty columns that precede it. If the
%                          spreadsheet contains one or more empty columns between
%                          columns of data, use the 'Range' parameter to specify a
%                          rectangular range of cells from which to read variable
%                          names and data. An empty character vector ('') signifies
%                          all data in the sheet.
%
%          'UseExcel'      A logical value that specifies whether or not to read the 
%                          spreadsheet file using Microsoft(R) Excel(R) for Windows(R). Set 
%                          'UseExcel' to one of these values: 
%                               true  -  Opens an instance of Microsoft
%                                        Excel to read (or write) the file.
%                                        This is the default setting for
%                                        Windows systems with Excel
%                                        installed.
%                               false -  Does not open an instance of
%                                        Microsoft Excel to read (or write)
%                                        the file. Using this setting may
%                                        cause the data to be written
%                                        differently for files with live
%                                        updates (e.g. formula evaluation
%                                        or plugins).
%
%          'TextType'      The output type of text variables. It can have either of
%                          the following values:
%                             'char'   - Return text as a cell array of
%                                        character vectors. 
%                             'string' - Return text as a string array.
%
%          'DatetimeType'  The output type of datetime variables. The possible values
%                          are:
%                              'datetime'     - Return dates as MATLAB datetimes. 
%                              'text'         - Return dates as text.
%                              'exceldatenum' - Return dates as Excel serial day date numbers.
%
%   Parameters which are also accepted with import options. These may have slightly
%   different behavior when used with import options:
%
%       T = readtable(LOCATION, OPTS, ...parameters...)
%
%         'ReadVariableNames' true - Reads the variable names from
%                                    opts.VariableNamesRange/VariableNamesLine location.
%                            false - Uses variable names from the import options.
%                                       
%         'ReadRowNames'      true - Reads the row names from the
%                                    opts.RowNamesRange/RowNameColumn location.
%                            false - Does not import row names.
%
%       Text only parameters:
%         'DateLocale'     Override the locale used when importing dates.
%         'Encoding'       Override the encoding defined in import options.
%
%       Spreadsheet only parameters:
%         'Sheet'          Override the sheet value in the import options.
%         'UseExcel'       No difference.
%
%
%   See also WRITETABLE, TABLE, DETECTIMPORTOPTIONS, TEXTSCAN.

%   Copyright 2012-2018 The MathWorks, Inc.

t = table.readFromFile(location,varargin);
