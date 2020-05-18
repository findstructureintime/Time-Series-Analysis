function c = makecform(varargin)
%MAKECFORM Create a color transformation structure.
%   C = MAKECFORM(TYPE) creates the color transformation structure, C,
%   that defines the color space conversion specified by TYPE.  To
%   perform the transformation, pass the color transformation structure
%   as an argument to the APPLYCFORM function.  TYPE should be one of
%   these character vectors:
%
%       'lab2lch'   'lch2lab'   'upvpl2xyz'   'xyz2upvpl'
%       'uvl2xyz'   'xyz2uvl'   'xyl2xyz'     'xyz2xyl'
%       'xyz2lab'   'lab2xyz'   'srgb2xyz'    'xyz2srgb'
%       'srgb2lab'  'lab2srgb'  'srgb2cmyk'   'cmyk2srgb'
%
%   (The color space table below defines these abbreviations.)
%
%   For the xyz2lab and lab2xyz transforms, you can optionally specify the value
%   of the reference white point.  Use the syntax C =
%   MAKECFORM(TYPE,'WhitePoint',WP), where WP is a 1-by-3 vector of XYZ values
%   scaled so that Y = 1.  The default is whitepoint('ICC').  You can use the
%   WHITEPOINT function to create the WP vector.
%
%   For the srgb2lab, lab2srgb, srgb2xyz, and xyz2srgb transforms, you can
%   optionally specify the adapted white point using the syntax C =
%   MAKECFORM(TYPE, 'AdaptedWhitePoint', WP).  As above, WP is a row vector
%   of XYZ values scaled so that Y = 1.  If not specified, the default
%   adapated white point is whitepoint('ICC').  NOTE: To get answers
%   consistent with some published sRGB equations, specify
%   whitepoint('D65') for the adapted white point.
%
%   The srgb2cmyk and cmyk2srgb transforms convert data between sRGB
%   IEC61966-2.1 and "Specifications for Web Offset Publications" (SWOP)
%   CMYK. You can optionally specify the rendering intent for this type of
%   transform.  Use the syntax: 
%
%       C = MAKECFORM('srgb2cmyk', 'RenderingIntent', INTENT) 
%       C = MAKECFORM('cmyk2srgb', 'RenderingIntent', INTENT) 
%
%   where INTENT must be one of these character vectors:
%
%       'AbsoluteColorimetric'  'Perceptual'  
%       'RelativeColorimetric'  'Saturation'
%
%   'Perceptual' is the default rendering intent.  See the MAKECFORM
%   reference page for more information about rendering intents.
%
%   C = MAKECFORM('adapt', 'WhiteStart', WPS, 'WhiteEnd', WPE, 'AdaptModel',
%   MODELNAME) creates a linear chromatic-adaptation transform.  WPS and
%   WPE are row vectors of XYZ values, scaled so that Y = 1, specifying
%   the starting and ending white points.  MODELNAME is either 'vonKries'
%   or 'Bradford' and specifies the type of chromatic-adaptation model to
%   be employed.  If 'AdaptModel' is not specified, it defaults to
%   'Bradford'.
%
%   C = MAKECFORM('icc', SRC_PROFILE, DEST_PROFILE) creates a color
%   transformation based on two ICC profiles.  SRC_PROFILE and
%   DEST_PROFILE are ICC profile structures returned by ICCREAD. 
%
%   C = MAKECFORM('icc', SRC_PROFILE, DEST_PROFILE,
%   'SourceRenderingIntent', SRC_INTENT, 'DestRenderingIntent',
%   DEST_INTENT) creates a color transformation based on two ICC color
%   profiles.  SRC_INTENT and DEST_INTENT specify the rendering intent
%   corresponding to the source and destination profiles.  (See the table
%   above for the list of rendering intent character vectors.)
%   'Perceptual' is the default rendering intent for both source and
%   destination.
%
%   CFORM = MAKECFORM('clut', PROFILE, LUTTYPE) creates a color transform
%   based on a Color Lookup Table (CLUT) contained in an ICC color
%   profile.  PROFILE is an ICC profile structure returned by ICCREAD.
%   LUTTYPE specifies which CLUT in the PROFILE structure is to be used.
%   It may be one of these character vectors: 
%
%       'AToB0'    'AToB1'    'AToB2'    'AToB3'    'BToA0'   
%       'BToA1'    'BToA2'    'BToA3'    'Gamut'    'Preview0'
%       'Preview1' 'Preview2'
%
%   and defaults to 'AToB0'.
%
%   CFORM = MAKECFORM('mattrc', MATTRC, 'Direction', DIR) creates a color
%   transform based on the structure MATTRC, containing an RGB-to-XYZ
%   matrix and RGB Tone Reproduction Curves.  MATTRC is typically the
%   'MatTRC' field of an ICC profile structure returned by ICCREAD, based
%   on tags contained in an ICC color profile.  DIR is either 'forward' or
%   'inverse' and specifies whether the MatTRC is to be applied in the
%   forward (RGB to XYZ) or inverse (XYZ to RGB) direction. 
%
%   CFORM = MAKECFORM('mattrc', PROFILE, 'Direction', DIR) creates a color
%   transform based on the 'MatTRC' field of the given ICC profile
%   structure PROFILE.  DIR is either 'forward' or 'inverse' and specifies
%   whether the MatTRC is to be applied in the forward (RGB to XYZ) or
%   inverse (XYZ to RGB) direction. 
%
%   CFORM = MAKECFORM('mattrc', PROFILE, 'Direction', DIR,
%   'RenderingIntent', INTENT) is similar, but adds the option of
%   specifying the rendering intent.  INTENT must be one of the character
%   vectors:
%
%       'RelativeColorimetric' [default]
%       'AbsoluteColorimetric'
%
%   When 'AbsoluteColorimetric' is specified, the colorimetry is referenced
%   to a perfect diffuser, rather than to the Media White Point of the
%   profile.
%
%   CFORM = MAKECFORM('graytrc', PROFILE, 'Direction', DIR) creates a
%   monochrome transform based on a single-channel Tone Reproduction
%   Curve contained as the 'GrayTRC' field of the ICC profile structure
%   PROFILE.  DIR is either 'forward' or 'inverse' and specifies whether
%   the transform is to be applied in the forward (device to PCS) or
%   inverse (PCS to device) direction.  ("Device" here refers to the
%   grayscale signal communicating with the monochrome device.  "PCS" is
%   the Profile Connection Space of the ICC profile and can be either XYZ
%   or Lab, depending on the 'ConnectionSpace' field in PROFILE.Header.)
%
%   CFORM = MAKECFORM('graytrc', PROFILE, 'Direction', DIR,
%   'RenderingIntent', INTENT) is similar, but adds the option of
%   specifying the rendering intent.  INTENT must be one of the character
%   vectors:
%
%       'RelativeColorimetric' [default]
%       'AbsoluteColorimetric'
%
%   When 'AbsoluteColorimetric' is specified, the colorimetry is referenced
%   to a perfect diffuser, rather than to the Media White Point of the
%   profile.
%
%   CFORM = MAKECFORM('named', PROFILE, SPACE) creates a transform
%   from color names to color-space coordinates.  PROFILE must be
%   a profile structure for a Named Color profile (with a NamedColor2
%   field).  SPACE is either 'PCS' or 'Device'.  The 'PCS' option is
%   always available and will return Lab or XYZ coordinates, depending
%   on the 'ConnectionSpace' field in PROFILE.Header, in 'double'
%   format.  The 'Device' option, when active, will return device
%   coordinates, the dimension depending on the 'ColorSpace' field
%   in PROFILE.Header, also in 'double' format.  
%
%   For more information about 'clut' transformations, see Section 6.5.7
%   of ICC.1:2001-04 (Version 2) or Section 6.5.9 of ICC.1:2001-12 (Version 4).  
%   For more information about 'mattrc' transformations, see Section 6.3.1.2
%   ICC.1:2001-04 or ICC.1:2001-12.  These specifications are available
%   at www.color.org.
%
%
%   Color space abbreviations
%   -------------------------
%
%       Abbreviation   Description
%
%       xyz            1931 CIE XYZ tristimulus values (2 degree observer)
%       xyl            1931 CIE xyY chromaticity values (2 degree observer)
%       uvl            1960 CIE uvL values
%       upvpl          1976 CIE u'v'L values
%       lab            1976 CIE L*a*b* values
%       lch            Polar transformation of L*a*b* values; c = chroma
%                          and h = hue
%       srgb           Standard computer monitor RGB values 
%                          (IEC 61966-2-1)
%
%   Example
%   -------
%   Convert RGB image to L*a*b*, assuming input image is sRGB.
%
%       rgb = imread('peppers.png');
%       cform = makecform('srgb2lab');
%       lab = applycform(rgb, cform);
%
%   See also APPLYCFORM, LAB2DOUBLE, LAB2UINT8, LAB2UINT16, WHITEPOINT,
%            XYZ2DOUBLE, XYZ2UINT16, ISICC, ICCREAD, ICCWRITE.

%   Copyright 2002-2017 The MathWorks, Inc.

narginchk(1, Inf);
args = matlab.images.internal.stringToChar(varargin);

valid_strings = {'lab2lch', 'lch2lab', ...
    'upvpl2xyz', 'xyz2upvpl',...
    'uvl2xyz', 'xyz2uvl', ...
    'xyl2xyz', 'xyz2xyl', ...
    'xyz2lab', 'lab2xyz', ...
    'srgb2xyz', 'xyz2srgb', ...
    'srgb2lab', 'lab2srgb', ...
    'srgb2cmyk', 'cmyk2srgb', ...
    'clut', 'mattrc', 'graytrc', 'icc', 'named', 'adapt', ...
    'makeabsolute', 'makeblackfix'};

transform_type = validatestring(args{1}, valid_strings, mfilename, ...
                           'TRANSFORMTYPE', 1);

switch lower(transform_type)
  case {'lab2lch', 'lch2lab', 'upvpl2xyz', 'xyz2upvpl',...
        'uvl2xyz', 'xyz2uvl', 'xyl2xyz', 'xyz2xyl'}
    c = make_simple_cform(args{:});
  case {'xyz2lab', 'lab2xyz'}
    c = make_xyz2lab_or_lab2xyz_cform(args{:});
  case 'clut'
    c = make_clut_cform(args{2:end});
  case 'mattrc'
    c = make_mattrc_cform(args{2:end});
  case 'graytrc'
    c = make_graytrc_cform(args{2:end});
  case 'named'
    c = make_named_cform(args{2:end});
  case 'icc'
    c = make_icc_cform(args{2:end});
  case 'adapt'
      c = make_adapt_cform(args{:});
  case 'makeabsolute'
    c = make_absolute_cform(args{2:end});
  case 'makeblackfix'
    c = make_blackpoint_cform(args{2:end});
  case {'srgb2xyz', 'xyz2srgb'}
    c = make_srgb2xyz_or_xyz2srgb_cform(args{:});
  case 'srgb2lab'
    c = make_srgb2lab_cform(args{:});
  case 'lab2srgb'
    c = make_lab2srgb_cform(args{:});
  case 'srgb2cmyk'
    c = make_srgb2swop_cform(args{:});
  case 'cmyk2srgb'
    c = make_swop2srgb_cform(args{:});
end

%------------------------------------------------------------
function c = make_simple_cform(varargin)
% Build a simple cform structure

% Check for valid input
narginchk(1, 1);
validateattributes(varargin{1},{'char'},{'nonempty'},mfilename,'TRANSFORMTYPE',1);
xform = lower(varargin{1});

% Construct a look up table for picking atomic functions
cinfo = {'lab2lch', @lab2lch, 'lab','lch';
         'lch2lab', @lch2lab,'lch','lab';
         'upvpl2xyz', @upvpl2xyz,'upvpl','xyz';
         'xyz2upvpl',@xyz2upvpl,'xyz','upvpl';
         'uvl2xyz', @uvl2xyz, 'uvl', 'xyz';
         'xyz2uvl', @xyz2uvl,'xyz','uvl';
         'xyl2xyz', @xyl2xyz,'xyl','xyz';
         'xyz2xyl', @xyz2xyl,'xyz','xyl'};

persistent function_table;
if isempty(function_table)
    for k = 1:size(cinfo,1)
        s.function = cinfo{k,2};
        s.in_space = cinfo{k,3};
        s.out_space = cinfo{k,4};
        function_table.(cinfo{k,1}) = s;
    end
end

t = function_table.(xform);
c = assigncform(t.function,t.in_space,t.out_space,'double',struct);

%----------------------------------------------------------
function c = make_xyz2lab_or_lab2xyz_cform(varargin)

wp = parseWPInputs('WhitePoint', varargin{:});

cdata.whitepoint = wp;

% Construct a look up table for picking atomic functions
cinfo = {'lab2xyz', @lab2xyz, 'lab','xyz';
         'xyz2lab', @xyz2lab,'xyz','lab'};

persistent labxyz_function_table;
if isempty(labxyz_function_table)
    for k = 1:size(cinfo,1)
        s.function = cinfo{k,2};
        s.in_space = cinfo{k,3};
        s.out_space = cinfo{k,4};
        labxyz_function_table.(cinfo{k,1}) = s;
    end
end

xform = lower(varargin{1});
t = labxyz_function_table.(xform);

c = assigncform(t.function,t.in_space,t.out_space,'double',cdata);

%----------------------------------------------------------
function c = make_srgb2swop_cform(varargin)

% Check input args
narginchk(1, 3);

if nargin == 2
    error(message('images:makecform:wrongNumInputs'));
end

% Set default rendering intents
args.renderingintent = 'perceptual';

% Get Rendering intent information if it's given
valid_property_strings = {'renderingintent'};
valid_value_strings = {'perceptual','relativecolorimetric', 'saturation',...
                    'absolutecolorimetric'};
if nargin > 1
    
        prop_string = validatestring(varargin{2}, valid_property_strings, ...
                                mfilename, 'PARAM', 2);
        value_string = validatestring(varargin{3}, valid_value_strings, ...
                                mfilename, 'PARAM', 3);
        args.(prop_string) = value_string;   
end

sRGB_profile = load_sRGB_profile();
swop_profile = load_swop_profile();


c = makecform('icc', sRGB_profile, swop_profile, 'SourceRenderingIntent',...
              args.renderingintent, 'DestRenderingIntent',args.renderingintent);
          
%----------------------------------------------------------
function c = make_swop2srgb_cform(varargin)

% Check input args
narginchk(1, 3);

if nargin == 2
    error(message('images:makecform:wrongNumInputs'));
end

% Set default rendering intents
args.renderingintent = 'perceptual';

% Get Rendering intent information if it's given
valid_property_strings = {'renderingintent'};
valid_value_strings = {'perceptual','relativecolorimetric', 'saturation',...
                    'absolutecolorimetric'};
if nargin > 1
    
        prop_string = validatestring(varargin{2}, valid_property_strings, ...
                                mfilename, 'PARAM', 2);
        value_string = validatestring(varargin{3}, valid_value_strings, ...
                                mfilename, 'PARAM', 3);
        args.(prop_string) = value_string;   
end


sRGB_profile = load_sRGB_profile();
swop_profile = load_swop_profile();

c = makecform('icc', swop_profile, sRGB_profile, 'SourceRenderingIntent',...
              args.renderingintent, 'DestRenderingIntent',args.renderingintent);

%----------------------------------------------------------
function c = make_srgb2lab_cform(varargin)

wp = parseWPInputs('AdaptedWhitePoint', varargin{:});

srgb2xyz = makecform('srgb2xyz', 'AdaptedWhitePoint', wp);
xyz2lab = makecform('xyz2lab', 'WhitePoint', wp);
cdata.cforms = {srgb2xyz, xyz2lab};
c = assigncform(@applycformsequence, 'rgb', 'lab', 'double', cdata);

%----------------------------------------------------------
function c = make_lab2srgb_cform(varargin)

wp = parseWPInputs('AdaptedWhitePoint', varargin{:});

xyz2srgb = makecform('xyz2srgb', 'AdaptedWhitePoint', wp);
lab2xyz = makecform('lab2xyz', 'WhitePoint', wp);
cdata.forms = {lab2xyz, xyz2srgb};
c = assigncform(@applycformsequence, 'lab', 'rgb', 'double', cdata);

%------------------------------------
function wp = parseWPInputs(param_name, varargin)

narginchk(2, 4);

switch nargin
  case 2
    wp = whitepoint;
  case 3
    error(message('images:makecform:paramValueIncomplete'))
  case 4
    valid_strings = {param_name};
    wp = parseWPInput(varargin{2}, varargin{3}, valid_strings, 'WP', 2);
end

%------------------------------------
function wp = parseWPInput(propname, propvalue, valid_strings, varname, varpos)

narginchk(5, 5);

if isempty(propname) || isempty(propvalue)
    wp = whitepoint;
else
    validatestring(propname, valid_strings, mfilename, 'PROPERTYNAME', varpos);
    wp = propvalue;
    validateattributes(wp, {'double'}, ...
                    {'real', '2d', 'nonsparse', 'finite', 'row', 'positive'}, ...
                    mfilename, varname, varpos + 1);
    if size(wp, 2) ~= 3
        error(message('images:makecform:invalidWhitePointData'))
    end
end

%------------------------------------------------------------
function c = make_clut_cform(profile,luttype)

narginchk(1, 2);

if nargin < 2
    luttype = 'AToB0';
end

% Check for valid input arguments
if ~isicc(profile)
    error(message('images:makecform:invalidProfileNotICC'))
end
valid_luttag_strings = {'AToB0','AToB1','AToB2','AToB3','BToA0','BToA1','BToA2',....
                    'BToA3','Gamut','Preview0','Preview1','Preview2'};

luttype = validatestring(luttype, lower(valid_luttag_strings), ...
                        mfilename, 'LUTTYPE', 3);

% Handle Abstract Profile as special case
if strcmp(profile.Header.DeviceClass, 'abstract')
    luttype = 'atob0';
end

% Since absolute rendering uses the rel. colorimetric tag, re-assign
% luttype and set a flag.
is_a2b3 = false;
is_b2a3 = false;
L = length(luttype);
if strncmpi(luttype,'atob3',L)
    luttype = 'atob1';
    is_a2b3 = true;
elseif strncmpi(luttype,'btoa3',L)
    luttype = 'btoa1';
    is_b2a3 = true;
end

% Get case sensitive luttag string
luttype_idx = strmatch(luttype,lower(valid_luttag_strings),'exact');
luttype = valid_luttag_strings{luttype_idx};

% Check that the profile actually has the luttag
if ~isfield(profile,luttype)
    error(message('images:makecform:invalidLutTag'))
end

c_fcn = @applyclut;
luttag = profile.(luttype);
cdata.luttag = luttag;

% Figure out input/output colorspaces based on the name of the luttag

starts_in_pcs = {'BToA0','BToA1','BToA2','BToA3','Gamut'};
starts_in_device_space = {'AToB0','AToB1','AToB2','AToB3'};
starts_and_ends_in_pcs = {'Preview0','Preview1','Preview2'};

switch luttype
  case starts_in_pcs
    inputcolorspace = profile.Header.ConnectionSpace;
    outputcolorspace = profile.Header.ColorSpace;
  case starts_in_device_space
    inputcolorspace = profile.Header.ColorSpace;
    outputcolorspace = profile.Header.ConnectionSpace;
  case starts_and_ends_in_pcs
    inputcolorspace = profile.Header.ConnectionSpace;
    outputcolorspace = inputcolorspace;
end

% Special case:  Abstract Profile has A2B0, but starts and ends in PCS.
if strcmp(profile.Header.DeviceClass, 'abstract')
    inputcolorspace = outputcolorspace;    % PCS -> PCS
end

if strcmpi(inputcolorspace, 'xyz')
    cdata.isxyzin = true;
else
    cdata.isxyzin = false;
end
if strcmpi(outputcolorspace, 'xyz')
    cdata.isxyzout = true;
else
    cdata.isxyzout = false;
end

% Set up encoding 
if luttag.MFT == 1      % mft1
    encoding = 'uint8';
elseif luttag.MFT <= 4  % mft2, mAB , mBA 
    encoding = 'uint16';
else
    error(message('images:makecform:unsupportedTagType'))
end

% Make a sequence of cforms if they ask for absolute rendering
if is_a2b3
    % First insert the clut
    clut_cform = assigncform(c_fcn,inputcolorspace, outputcolorspace,encoding,cdata);
    seq_cdata.sequence.clut_cform = clut_cform;
    
    % Then insert the makeabsolute cform
    absolute_cform = makecform('makeabsolute',profile.Header.ConnectionSpace,'double',...
                               profile.MediaWhitePoint,whitepoint);
    seq_cdata.sequence.convert_absolute = absolute_cform;
    
    % Make an icc sequence
    c = assigncform(@applyiccsequence,inputcolorspace,outputcolorspace,'uint16',seq_cdata);
elseif is_b2a3
    % First insert the makeabsolute cform
    clut_cform = assigncform(c_fcn,inputcolorspace, outputcolorspace,encoding,cdata);
    absolute_cform = makecform('makeabsolute',profile.Header.ConnectionSpace,'double',...
                               whitepoint,profile.MediaWhitePoint);
    seq_cdata.sequence.convert_absolute = absolute_cform;
    
    % Then insert the clut
    seq_cdata.sequence.clut_cform = clut_cform;
    
    % Make an icc sequence
    c = assigncform(@applyiccsequence,inputcolorspace,outputcolorspace,'uint16',seq_cdata);
else
    % Just make a clut cform
    c = assigncform(c_fcn, inputcolorspace, outputcolorspace, encoding, cdata);
end

% ------------------------------------------------------------

function c = make_mattrc_cform(varargin)

narginchk(3, 5);

% Check Profile or MatTRC argument
if isicc(varargin{1})
    pf = varargin{1};
    if isfield(pf, 'MatTRC') && isstruct(pf.MatTRC)
       mattrc = pf.MatTRC;
    else
        error(message('images:makecform:missingMattrc'))
    end
elseif isstruct(varargin{1})
    mattrc = varargin{1};
    pf = [];
else
    error(message('images:makecform:invalidArgument'))
end

% Replace v. 4 fieldnames with v. 2 fieldnames
if isfield(mattrc, 'RedMatrixColumn')
    mattrc.RedColorant = mattrc.RedMatrixColumn;
end
if isfield(mattrc, 'GreenMatrixColumn')
    mattrc.GreenColorant = mattrc.GreenMatrixColumn;
end
if isfield(mattrc, 'BlueMatrixColumn')
    mattrc.BlueColorant = mattrc.BlueMatrixColumn;
end

if ~is_valid_mattrc(mattrc)
    error(message('images:makecform:invalidMattrc'))
end

% Check direction arguments
valid_propname_strings = {'direction'};
valid_propvalue_strings = {'forward', 'inverse'};
validatestring(varargin{2}, valid_propname_strings, ...
                    mfilename, 'PROPERTYNAME', 2);
direction = validatestring(varargin{3}, valid_propvalue_strings, ...
                         mfilename, 'PROPERTYVALUE', 3);
                     
% Check (optional) rendering-intent arguments                     
if nargin == 4
    error(message('images:makecform:paramValueIncomplete'))
elseif nargin > 4
    valid_propname_strings = {'renderingintent'};
    valid_propvalue_strings = {'relativecolorimetric', ...
                               'absolutecolorimetric'};
    validatestring(varargin{4}, valid_propname_strings, ...
                    mfilename, 'PROPERTYNAME', 4);
    intent = validatestring(varargin{5}, valid_propvalue_strings, ...
                          mfilename, 'PROPERTYVALUE', 5);         
else
    intent = 'relativecolorimetric';
end

% Assign correct atomic function and color spaces,
% depending on direction.
if strcmp(direction, 'forward')
    c_fcn = @applymattrc_fwd;
    space_in = 'rgb';
    space_out ='xyz';
else
    c_fcn = @applymattrc_inv;
    space_in = 'xyz';
    space_out = 'rgb';
end

cdata.MatTRC = mattrc;

% Make a sequence of cforms for absolute rendering
if strcmpi(intent, 'absolutecolorimetric')
    if isempty(pf)
        error(message('images:makecform:absoluteRequiresProfile'))
    else
        mwp = pf.MediaWhitePoint;
    end
    mattrc_cform = assigncform(c_fcn, space_in, space_out, 'double', cdata);
    
    if strcmpi(direction, 'forward')    % mattrc followed by makeabsolute
        seq_cdata.sequence.mattrc_cform = mattrc_cform;
        absolute_cform = makecform('makeabsolute', 'XYZ', 'double',...
                                   mwp, whitepoint);
        seq_cdata.sequence.convert_absolute = absolute_cform;
    else                                % makeabsolute followed by mattrc
        absolute_cform = makecform('makeabsolute', 'XYZ','double',...
                                   whitepoint, mwp); 
        seq_cdata.sequence.convert_absolute = absolute_cform;
        seq_cdata.sequence.mattrc_cform = mattrc_cform;
    end
    
    % Make "icc" sequence
    c = assigncform(@applyiccsequence, space_in, space_out, ...
                    'uint16', seq_cdata);
else
    % Make simple mattrc cform
    c = assigncform(c_fcn, space_in, space_out, 'double', cdata);
end

%------------------------------------------------------------

function c = make_graytrc_cform(varargin)

narginchk(3, 5);
pf = varargin{1};
if ~isicc(pf)
    error(message('images:makecform:invalidProfileNotICC'))
end

if ~isfield(pf, 'GrayTRC')
    error(message('images:makecform:missingGraytrc'))
else
    graytrc = pf.GrayTRC;
end

invalidGraytrc = isempty(graytrc) || ...
    ~(isa(graytrc, 'uint16') || isa(graytrc, 'struct'));
if invalidGraytrc 
    error(message('images:makecform:invalidGraytrc'))
end

% Check direction arguments
valid_propname_strings = {'direction'};
valid_propvalue_strings = {'forward', 'inverse'};
validatestring(varargin{2}, valid_propname_strings, ...
             mfilename, 'PROPERTYNAME', 2);
direction = validatestring(varargin{3}, valid_propvalue_strings, ...
                         mfilename, 'PROPERTYVALUE', 3);
                     
% check (optional) rendering-intent arguments                     
if nargin == 4
    error(message('images:makecform:paramValueIncomplete'))
elseif nargin > 4
    valid_propname_strings = {'renderingintent'};
    valid_propvalue_strings = {'relativecolorimetric', ...
                               'absolutecolorimetric'};
    validatestring(varargin{4}, valid_propname_strings, ...
                 mfilename, 'PROPERTYNAME', 4);
    intent = validatestring(varargin{5}, valid_propvalue_strings, ...
                          mfilename, 'PROPERTYVALUE', 5);
else
    intent = 'relativecolorimetric';
end                  

% Assign correct atomic function and color spaces,
% depending on direction.
if strcmp(direction, 'forward')
    c_fcn = @applygraytrc_fwd;
    space_in = 'gray';
    space_out = pf.Header.ConnectionSpace;
else
    c_fcn = @applygraytrc_inv;
    space_in = pf.Header.ConnectionSpace;
    space_out = 'gray';
end

cdata.GrayTRC = graytrc;
cdata.ConnectionSpace = pf.Header.ConnectionSpace;

% Make a sequence of cforms for absolute rendering
if strcmpi(intent, 'absolutecolorimetric')
    graytrc_cform = assigncform(c_fcn, space_in, space_out, 'double', cdata);
    mwp = pf.MediaWhitePoint;
    
    if strcmpi(direction, 'forward')    % graytrc followed by makeabsolute
        seq_cdata.sequence.graytrc_cform = graytrc_cform;
        absolute_cform = makecform('makeabsolute', cdata.ConnectionSpace, ...
                                   'double', mwp, whitepoint);
        seq_cdata.sequence.convert_absolute = absolute_cform;
    else                                % makeabsolute followed by graytrc
        absolute_cform = makecform('makeabsolute', cdata.ConnectionSpace, ...
                                   'double', whitepoint, mwp); 
        seq_cdata.sequence.convert_absolute = absolute_cform;
        seq_cdata.sequence.graytrc_cform = graytrc_cform;
    end
    
    % Make "icc" sequence
    c = assigncform(@applyiccsequence, space_in, space_out, ...
                    'uint16', seq_cdata);
else
    % Make simple graytrc cform
    c = assigncform(c_fcn, space_in, space_out, 'double', cdata);
end
%------------------------------------------------------------

function c = make_named_cform(varargin)

narginchk(1, 2);

pf = varargin{1};

if ~isfield(pf, 'NamedColor2')
    error(message('images:makecform:missingNamedColor2'))
elseif ~isfield(pf.NamedColor2, 'NameTable')
    error(message('images:makecform:missingNameTable'))
else
    cdata.NameTable = pf.NamedColor2.NameTable;
end

cdata.Space = varargin{2};

c_fcn = @applynamedcolor;
space_in = 'char';
if strcmpi(cdata.Space, 'pcs')
    space_out = pf.Header.ConnectionSpace;
elseif strcmpi(cdata.Space, 'device')
    space_out = pf.Header.ColorSpace;
else
    error(message('images:makecform:invalidInputData'))
end
    
c = assigncform(c_fcn, space_in, space_out, 'name', cdata);

%------------------------------------------------------------

function c = make_icc_cform(varargin)

narginchk(2, 6);

% Set default rendering intents
args.sourcerenderingintent ='perceptual';
args.destrenderingintent = 'perceptual';

% Get rendering intent information if it's given
valid_property_strings = {'sourcerenderingintent', 'destrenderingintent'};
valid_value_strings = {'perceptual', 'relativecolorimetric', 'saturation',...
                    'absolutecolorimetric'};
if nargin > 2
    for k=3:2:nargin
        prop_string = validatestring(varargin{k}, valid_property_strings, ...
                                mfilename, 'PROPERTYNAME', k);
        value_string = validatestring(varargin{k+1}, valid_value_strings, ...
                                mfilename, 'PROPERTYVALUE', k+1);
        args.(prop_string) = value_string;
    end
end

source_intent_num = int2str(strmatch(args.sourcerenderingintent,valid_value_strings)-1); 
dest_intent_num = int2str(strmatch(args.destrenderingintent,valid_value_strings)-1); 

% Get the source profile
source_pf = varargin{1};
if ~isicc(source_pf)
    error(message('images:makecform:invalidSourceProfile'))
end
if strcmp(source_pf.Header.DeviceClass, 'device link')
    error(message('images:makecform:invalidSourceProfileDeviceLink'))
end

% Get the destination profile
dest_pf = varargin{2};
if ~isicc(dest_pf)
    error(message('images:makecform:invalidDestinationProfile'))
end
if strcmp(dest_pf.Header.DeviceClass, 'device link')
    error(message('images:makecform:invalidDestinationProfileDeviceLink'))
end

% Flags that are used later to determine connection space
source_isMatTRC = false;
dest_isMatTRC = false;

% Select transform from source profile according to priority rule
first_try = strcat('AToB', source_intent_num);
second_try = strcat('MatTRC');
if isfield(source_pf, first_try)
    source_cform = makecform('clut', source_pf, first_try);
elseif strcmp(first_try, 'AToB3') && isfield(source_pf, 'AToB1')
    source_cform = makecform('clut', source_pf, 'AToB1');
elseif isfield(source_pf, 'AToB0')   % fallback strategy: perceptual
    source_cform = makecform('clut', source_pf, 'AToB0');
elseif isfield(source_pf, second_try) 
    source_isMatTRC = true;
    source_cform = makecform('mattrc',source_pf.(second_try),'Direction','forward');
elseif isfield(source_pf, 'GrayTRC')
    source_cform = makecform('graytrc', source_pf, 'Direction', 'forward');
else
    error(message('images:makecform:missingAToBxMatTRCGrayTRC'))
end

% Select transform from destination profile according to priority rule
first_try = strcat('BToA', dest_intent_num);
second_try = strcat('MatTRC');
if isfield(dest_pf,first_try)
    dest_cform = makecform('clut', dest_pf, first_try);
elseif strcmp(first_try, 'BToA3') && isfield(dest_pf, 'BToA1')
    dest_cform = makecform('clut', dest_pf, 'BToA1');
elseif isfield(dest_pf, 'BToA0')
    dest_cform = makecform('clut', dest_pf, 'BToA0');
elseif strcmp(dest_pf.Header.DeviceClass, 'abstract') && ...
        isfield(dest_pf, 'AToB0')
    dest_cform = makecform('clut', dest_pf, 'AToB0');
elseif isfield(dest_pf,second_try) 
    dest_isMatTRC = true;
    dest_cform = makecform('mattrc',dest_pf.(second_try),'Direction','inverse');
elseif isfield(dest_pf, 'GrayTRC')
    dest_cform = makecform('graytrc', dest_pf, 'Direction', 'inverse');
else
    error(message('images:makecform:invalidDestProfile'))
end

% Set flags for absolute-colorimetric rendering.
% Make sure the user didn't ask for absolute on the source and relative on
% the destination profile. In any event, if the destination is absolute,
% the entire path is absolute.    
source_absolute = strncmp(args.sourcerenderingintent, ...
                          'absolutecolorimetric',...
                          length(args.sourcerenderingintent));
dest_absolute = strncmp(args.destrenderingintent, ...
                          'absolutecolorimetric',...
                          length(args.destrenderingintent));
if source_absolute && ~dest_absolute
    error(message('images:makecform:invalidRenderingIntents'))
else
    path_is_absolute = dest_absolute;
end

% Check to see if PCS's match. If not, the PCS's will have to be
% reconciled with a third cform that connects the two. 
source_pcs_is_xyz = source_isMatTRC || ...
    strcmp(deblank(lower(source_pf.Header.ConnectionSpace)), 'xyz');
dest_pcs_is_xyz = dest_isMatTRC || ...
    strcmp(deblank(lower(dest_pf.Header.ConnectionSpace)), 'xyz');
needs_gendermender = (source_pcs_is_xyz ~= dest_pcs_is_xyz);

% Check for mismatch in PCS interpretation due to profile version mismatch
% (non-colorimetric intents only).  Reference-medium black point has Y = 0
% in Version 2 (and preceding) and has Y = 0.0034731 in Version 4.
L = length(args.destrenderingintent);
if strncmp(args.destrenderingintent, 'perceptual', L) || ...
   strncmp(args.destrenderingintent, 'saturation', L)
    source_version = sscanf(source_pf.Header.Version(1), '%d%');
    dest_version = sscanf(dest_pf.Header.Version(1), '%d%');
    if source_version <= 2 && dest_version > 2
        upconvert_blackpoint = 1;  % convert version 2 to version 4
    elseif source_version > 2 && dest_version <= 2
        upconvert_blackpoint = -1; % convert version 4 to version 2
    else
        upconvert_blackpoint = 0;  % no mismatch, no conversion
    end
else
    upconvert_blackpoint = 0;  % colorimetric intent, no conversion
end

% Now construct the sequence of cforms to be packed into the cdata
% of this main cform. The sequence might require some xyz2lab or lab2xyz
% cforms to accommodate a mismatch in PCSs between the profiles. In
% addition, a 'makeabsolute' cform may be inserted if the user asks for
% the absolute rendering intent.

% Put the source profile first in the sequence. It's always first.
cdata.sequence.source = source_cform;

% Set sequence encoding to fixed value of 'uint16'.  MathWorks developers - 
% see correspondence from Bob Poe in devel/ip/ipt/tech_refs/makecform. 
sequence_encoding = 'uint16';

% Do PCS corrections preferentially in XYZ, as needed.
if source_pcs_is_xyz

    % Insert a cform to convert to absolute if needed. 
    if path_is_absolute
        absolute_cform = makecform('makeabsolute', 'xyz', 'double',...
                               source_pf.MediaWhitePoint, dest_pf.MediaWhitePoint);
        cdata.sequence.convert_absolute = absolute_cform;
        
    % Insert a cform to convert black point if needed.
    elseif upconvert_blackpoint ~= 0
        fix_black_cform = makecform('makeblackfix', 'xyz', 'double', ...
                               upconvert_blackpoint);
        cdata.sequence.fix_black = fix_black_cform;
    end
end
    
% Insert a lab2xyz or xyz2lab if needed
if needs_gendermender
    if source_pcs_is_xyz
        fix_pcs_cform = makecform('xyz2lab', 'whitepoint', whitepoint); 
    else  
        fix_pcs_cform = makecform('lab2xyz', 'whitepoint', whitepoint);
    end
    cdata.sequence.fix_pcs = fix_pcs_cform;
    
    % Do PCS corrections preferentially in XYZ, as needed.
    if dest_pcs_is_xyz

        % Insert a cform to convert to absolute if needed.
        if path_is_absolute
            absolute_cform = makecform('makeabsolute', 'xyz', 'double',...
                                   source_pf.MediaWhitePoint,dest_pf.MediaWhitePoint);
            cdata.sequence.convert_absolute = absolute_cform;
        
        % Insert a cform to convert black point if needed.
        elseif upconvert_blackpoint ~= 0 
            fix_black_cform = makecform('makeblackfix', 'xyz', 'double', ...
                                   upconvert_blackpoint);
            cdata.sequence.fix_black = fix_black_cform;
        end
    end
end

% If neither PCS is XYZ, resort to Lab conversions as needed.
if ~source_pcs_is_xyz && ~dest_pcs_is_xyz
    
    % Insert absolute conversion if needed.
    if path_is_absolute
        absolute_cform = makecform('makeabsolute', 'lab', 'double',...
                               source_pf.MediaWhitePoint,dest_pf.MediaWhitePoint);
        cdata.sequence.convert_absolute = absolute_cform;
        
    % Insert black-point conversion if needed.
    elseif upconvert_blackpoint ~= 0
        fix_black_cform = makecform('makeblackfix', 'lab', 'double', ...
                               upconvert_blackpoint);
        cdata.sequence.fix_black = fix_black_cform;
    end
end

% Insert the destination profile into the sequence.
cdata.sequence.destination = dest_cform;

% Assign c_fcn
c_fcn = @applyiccsequence;

% Make the main cform
c = assigncform(c_fcn,source_pf.Header.ColorSpace,dest_pf.Header.ColorSpace,...
                sequence_encoding,cdata);

%------------------------------------------------------------
function c = make_adapt_cform(varargin)

% Check input args:
narginchk(5, 7);

% Get white-point XYZs, starting and ending:
wps = parseWPInput(varargin{2}, varargin{3}, {'WhiteStart'}, 'WPS', 2);
wpe = parseWPInput(varargin{4}, varargin{5}, {'WhiteEnd'}, 'WPE', 4);

% Get chromatic-adaptation-model name:
if nargin < 6
    adapttype = 'bradford';
else
    validatestring(varargin{6}, {'AdaptModel'}, mfilename, 'PROPERTYNAME', 6);
    if nargin < 7
        adapttype = 'bradford';
    else
        adapttype = validatestring(varargin{7}, {'VonKries' 'Bradford'}, ...
                                mfilename, 'MODELNAME', 7);
    end
end

% Get adaptation-model matrix (XYZ -> primaries):
if strcmpi(adapttype, 'Bradford')
    chad = [ 0.8951  0.2664  -0.1614; ...
            -0.7502  1.7135   0.0367; ...
             0.0389 -0.0685   1.0296 ];
elseif strcmpi(adapttype, 'VonKries')
    chad = [ 0.40024   0.70760  -0.08081; ...
            -0.22630   1.16532   0.04570; ...
             0.0       0.0       0.91822 ];
else
    error(message('images:makecform:AdaptModelNotSupported', adapttype))
end

% Convert white points from XYZ to primaries:
rgbs = wps * chad';
rgbe = wpe * chad';

% Construct chromatic-adaptation matrix:
rgbscale = diag(rgbe ./ rgbs);
cdata.adapter = chad \ rgbscale * chad;

% Construct cform:
c = assigncform(@applychad, 'XYZ', 'XYZ', 'double', cdata);

%------------------------------------------------------------
function c = make_absolute_cform(cspace,encoding,source_wp,dest_wp)
% This is a private cform. It is only constructed under the hood. No doc for
% this type of cform needed.

cdata.colorspace = cspace;
cdata.source_whitepoint = source_wp;
cdata.dest_whitepoint = dest_wp;
c = assigncform(@applyabsolute,cspace,cspace,encoding,cdata);

%------------------------------------------------------------
function c = make_blackpoint_cform(cspace, encoding, upconvert_blackpoint)
% This is a private cform. It is only constructed under the hood. No doc for
% this type of cform needed.

cdata.colorspace = cspace;
cdata.upconvert = upconvert_blackpoint;
c = assigncform(@applyblackpoint, cspace, cspace, encoding, cdata);

%------------------------------------------------------------
function c = make_srgb2xyz_or_xyz2srgb_cform(varargin)

wp = parseWPInputs('AdaptedWhitePoint', varargin{:});

sRGB_profile = load_sRGB_profile();

if strcmpi(varargin{1}, 'srgb2xyz')
    direction = 'forward';
else
    direction = 'inverse';
end

main_cform = makecform('mattrc', sRGB_profile.MatTRC, 'Direction', direction);
if isequal(wp, whitepoint('D50'))
    c = main_cform;
else
    if strcmp(direction, 'forward')
        adapt = makecform('adapt', 'WhiteStart', whitepoint('D50'), ...
                          'WhiteEnd', wp, ...
                          'AdaptModel', 'Bradford');
        cdata.cforms = {main_cform, adapt};
        c = assigncform(@applycformsequence, 'rgb', 'xyz', 'double', cdata);
    else
        adapt = makecform('adapt', 'WhiteStart', wp, ...
                          'WhiteEnd', whitepoint('D50'), ...
                          'AdaptModel', 'Bradford');
        cdata.cforms = {adapt, main_cform};
        c = assigncform(@applycformsequence, 'xyz', 'rgb', 'double', cdata);
    end
end

% ------------------------------------------------------------
function c = assigncform(c_func,space_in,space_out,encoding,cdata)

% make the cform struct

c.c_func = c_func;
c.ColorSpace_in = space_in;
c.ColorSpace_out = space_out;
c.encoding = encoding;
c.cdata = cdata;

% ------------------------------------------------------------
function out = is_valid_mattrc(mattrc)

has_redc = isfield(mattrc,'RedColorant');
has_greenc = isfield(mattrc,'GreenColorant');
has_bluec = isfield(mattrc,'BlueColorant');
has_redtrc = isfield(mattrc,'RedTRC');
has_greentrc = isfield(mattrc,'GreenTRC');
has_bluetrc = isfield(mattrc,'BlueTRC');

if (has_redc && has_greenc && has_bluec && has_redtrc && has_greentrc ...
    && has_bluetrc)
    out = true;

    % Check data types
    if isempty(mattrc.RedColorant) || ~isa(mattrc.RedColorant,'double')
        out = false;
    elseif isempty(mattrc.GreenColorant) || ~isa(mattrc.GreenColorant,'double')
        out = false;
    elseif isempty(mattrc.BlueColorant) || ~isa(mattrc.BlueColorant,'double')
        out = false;
    elseif isempty(mattrc.RedTRC) || (~isa(mattrc.RedTRC,'uint16') && ~isa(mattrc.RedTRC,'struct'))
        out = false;
    elseif isempty(mattrc.GreenTRC) || (~isa(mattrc.GreenTRC,'uint16') && ~isa(mattrc.GreenTRC,'struct'))
        out = false;
    elseif isempty(mattrc.BlueTRC) || (~isa(mattrc.BlueTRC,'uint16') && ~isa(mattrc.BlueTRC,'struct'))
        out = false;
    end
else
    out = false;
end

% ------------------------------------------------------------
function out = load_sRGB_profile()

persistent sRGB_profile
if isempty(sRGB_profile)
    sRGB_profile = iccread('sRGB.icm');
end

out = sRGB_profile;


% ------------------------------------------------------------
function out = load_swop_profile()

persistent swop_profile
if isempty(swop_profile)
    swop_profile = iccread('swopcmyk.icm');
end

out = swop_profile;

