function y=normalize(x)
%NORMALIZE   Normalizes data series.
%   Y=NORMALIZE(X) normalizes the matrix X to zero-mean and
%   standard deviation one (Y=(X-mean(X))/std(X)).

% Copyright (c) 1998-2001 by AMRON
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% $Date: 2004/11/10 07:07:51 $
% $Revision: 2.1 $
%
% $Log: normalize.m,v $
% Revision 2.1  2004/11/10 07:07:51  marwan
% initial import
%
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.


error(nargchk(1,1,nargin));
if nargout>1, error('Too many output arguments'), end
if min(size(x))==1
    y=(x-mean(x))/std(x);
else

  for i=1:size(x,2);
    y(:,i)=(x(:,i)-mean(x(:,i)))/std(x(:,i));
  end

end
