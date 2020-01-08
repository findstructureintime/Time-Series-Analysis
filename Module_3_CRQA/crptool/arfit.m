function varargout=arfit(varargin)
% ARFIT   AR parameter estimation via Yule-Walker method.
%    ARFIT(X,P) opens a GUI for AR coefficients 
%    estimation for the vector X using the Yule-Walker 
%    method. The coefficients and order selection criterias
%    for all orders until the maximal order P will be 
%    solved. The coefficients are solved by the Levinson-
%    Durbin algorithmus. The criteria are normalized in 
%    order to show them in the same plot.
%
%    A=ARFIT(X,P) returns the vector A of length (P+1) of 
%    the AR coefficients and the noise level for the
%    corresponding AR model of the model order P. The GUI
%    is suppressed.
%
%    [A Y]=ARFIT(X,P) returns the vector Y of a realization
%    of the resulting AR model. The GUI is suppressed.
%
%    Example: x = rand(3,1);
%             a = [.8 .3 -.25 .9]';
%             for i = 4:1000,
%                x(i) = sum(a(1:3) .* x(i-1:-1:i-3)) + a(end) * randn;
%             end
%             arfit(x,10)

% Copyright (c) 2002-2007 by AMRON
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% $Date: 2007/12/20 16:26:05 $
% $Revision: 2.7 $
%
% $Log: arfit.m,v $
% Revision 2.7  2007/12/20 16:26:05  marwan
% changed gpl splash behaviour
%
% Revision 2.6  2007/05/24 12:30:55  marwan
% definitions of criteria checked and corrected
%
% Revision 2.5  2006/02/14 11:45:49  marwan
% *** empty log message ***
%
% Revision 2.4  2005/03/16 11:19:02  marwan
% help text modified
%
% Revision 2.3  2004/11/10 07:05:48  marwan
% initial import
%
%
% This program is part of the new generation XXII series.
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% programme properties

global props

init_properties
crit=[];
for i=1:6
    props.criteria_line(i).Marker='none';
    props.criteria_line(i).LineWidth=props.line.LineWidth;
    props.criteria_line(i).LineStyle=props.line.LineStyle;
end
    props.criteria_line(6).LineStyle=':';
    props.criteria_line(1).Color=[ 0   0   0];
    props.criteria_line(2).Color=[.8   0   0];
    props.criteria_line(3).Color=[ 0   0  .8];
    props.criteria_line(4).Color=[ 0  .6   0];
    props.criteria_line(5).Color=[.47 .4  .1];
    props.criteria_line(6).Color=[.6  .6  .6];

if ~isempty(findobj('Tag','helpdlgbox')), delete(findobj('tag','helpdlgbox')), end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% splash the GPL

splash_gpl('crp');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% check and read the input

error(nargchk(1,3,nargin));
if nargout>2, error('Too many output arguments.'), end


%%%%%% read the command line

if isnumeric(varargin{1})==1 		
   i_double=find(cellfun('isclass',varargin,'double'));
   i_char=find(cellfun('isclass',varargin,'char'));

%%%%%% check whether to create the gui
   nogui=0;
   check_gui={'gui','nog','sil'};		% gui, nogui, silent
   if ~isempty(i_char)
      temp_gui=0;
      for i=1:length(i_char), 
          temp_gui=temp_gui+strcmpi(varargin{i_char(i)}(1:3),check_gui'); 
      end
      nogui=min(find(temp_gui))-1;
   else
      nogui=0;
   end
   if nargout>0, nogui=1; end

%%%%%% get the numeric input variables
   if ~isempty(i_double)
      for i=1:length(i_double), 
         if i==1
	    x=varargin{i_double(i)};
	    x=x(:); 
	    maxm=3;
	 elseif i==2
	    maxm=varargin{i_double(i)};
	    if max(size(maxm))>1, 
	       if ~nogui
	          h=warndlg('The order must be scalar. Using the first value.','Input Parameters'); 
	          set(h,props.msgboxwin),h2=guihandles(h);set(h2.OKButton,props.msgbox)
                  set(h,'Tag','helpdlgbox','HandleVisibility','On');
		  uiwait(h)
	       else
	          warning('The order must be scalar. Using the first value.'); 
	       end
	    end
	    maxm=maxm(1); 
	 end
      end
      in_m=maxm;
   else
      error('No data set found.')
   end
   if nogui==0 & isempty(findobj('Tag','arfit_Fig'))
      action='init';
   else
      action='update';
   end

%%%%%% read from the gui
else
  % get the handles
  nogui=0;
  h_fig=findobj('Tag','arfit_fig'); h_fig=h_fig(1);
  h_data_axes=findobj('Tag','data_axes','Parent',h_fig);
  h_model_axes=findobj('Tag','model_axes','Parent',h_fig);
  h_criteria_axes=findobj('Tag','criteria_axes','Parent',h_fig);
  h_edit_maxorder=findobj('Tag','edit_maxorder','Parent',h_fig);
  h_popup_order=findobj('Tag','popup_order','Parent',h_fig);
  h_listbox_coeff=findobj('Tag','listbox_coeff','Parent',h_fig);
  h_button_model=findobj('Tag','button_model','Parent',h_fig);
  h_button_copyws=findobj('Tag','button_copyws','Parent',h_fig);
  h_button_print=findobj('Tag','button_print','Parent',h_fig);

  % get values
  x=get(h_fig,'UserData');
  crit=get(h_criteria_axes,'UserData');
  maxm=str2num(get(h_edit_maxorder,'String'));
  in_m=get(h_popup_order,'Value');
  txt=[repmat('show order ',maxm,1),num2str([1:maxm]'),repmat('|',maxm,1)]';
  txt=reshape(txt,1,prod(size(txt)));
  set(h_popup_order,'String',txt(1:end-1));
  if in_m>maxm
    in_m=maxm; 
    set(h_popup_order,'Value',maxm);
  end
  show_crit=[];
  for k=1:5; 
     h=findobj('Tag',['criteria',num2str(k)],'Parent',h_fig);
     if ~isempty(h);
       show_crit=[show_crit k*get(h,'Value')];
     end
  end
  noshow_crit=find(~show_crit);
  show_crit=find(show_crit);
  action=varargin{1};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% switch routines

%try 
switch(action)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% initialization
  case 'init'

  h=figure(props.window,...				% Plot Figure
            'Tag','arfit_fig',...
	    'MenuBar','Figure',...
            'Position',[35.0000 41.3571 129.6667 27.2143],...
	    'Name','AR Fit',...
	    'DeleteFcn','arfit close',...
	    'PaperPosition',[0.25 0.25 7.7677 11.193],...
            'PaperType','a4',...
	    'PaperOrientation','portrait',...
	    'UserData',x);
  
  set(0,'showhidden','on')
  h=findobj('Label','&Help','Type','uimenu');
  if isempty(h)
    h=uimenu('Label','&Help');
    h2=uimenu('Parent',h(1),'Label','&Help Arfit','Callback','helpwin arfit');
  else
    h1=flipud(get(h(1),'Children'));
    set(h1(1),'Separator','on')
    h2=uimenu('Parent',h(1),'Label','&Help Arfit','Callback','helpwin arfit');
    copyobj(h1,h(1))
    delete(h1)
  end
  set(0,'showhidden','off')

%%%%% logo
  h=axes(props.axes,...
            'Position',[69 6.5 6.8 3.5]);    
  logo=load('logo');
  h2=imagesc([logo.logo fliplr(logo.logo)]);
  set(h2,'Tag','uniLogo')
  set(h,props.logo,'Tag','axes_logo')
  h=uicontrol(props.text,...
            'Tag','text',...
	    'String','Uni Potsdam',...
            'Position',[66 2 22  3.5714]);    
  h2=textwrap(h,{[char(169),' AGNLD'],'University of Potsdam','2002-2007'});
  set(h,'String',h2)

%%%%% data and model axes
%  h=uicontrol(props.frame,...
%            'Tag','frame',...
%            'Position',[3.1667  1.2857 58.5000 24.3571]);    
  h=uicontrol(props.frame,...
            'Tag','frame',...
            'Position',[3.1667  25.6428 58.5000 .15]);    
  h=uicontrol(props.text,...
            'Tag','text',...
	    'String','Data and Model Plot');    
  pos=get(h,'Extent');
  set(h,'Position',[5.0000 25.1429-.33 pos(3) pos(4)])    
  h=axes;
  h2=plot(x);
  title('Data')
  set(h2,'Tag','data_line',props.line)
  set(h,props.axes,...
            'Tag','data_axes',...
            'Position',[6.5000 14.4286 53.5000  8.5]);
  h=axes(props.axes,...
            'Tag','model_axes',...
            'Position',[6.5000  2.7143 53.5000  8.5]);    

%%%%% criteria
%  h=uicontrol(props.frame,...
%            'Tag','frame',...
%            'Position',[64.8333 16.2857 61.8333  9.3571]);    
  h=uicontrol(props.frame,...
            'Tag','frame',...
            'Position',[64.8333 25.6428 61.8333  .15]);    
  h=uicontrol(props.text,...
            'Tag','text',...
	    'String','Criteria');
  pos=get(h,'Extent');
  set(h,'Position',[66.3333 25.1429-.33 pos(3) pos(4)])    
  h=axes('NextPlot','add');    
  for k=1:5,
      h2=plot(0,0,'Tag',['criteria_line',num2str(k)],'Visible','off',props.criteria_line(k));
  end
  set(h,props.axes,...
            'Tag','criteria_axes',...
            'Position',[69.8333 18.000 34.3  5.7857]);
  h=uicontrol(props.checkbox,...
            'Tag','criteria1',...
	    'ForegroundColor',props.criteria_line(1).Color,...
	    'String','Variance',...
	    'Tooltip','Variance of the residues.',...
	    'Value',1,...
	    'Callback','arfit criteria',...
            'Position',[108.0000 23.3571 17  1.6429]);    
  h=uicontrol(props.checkbox,...
            'Tag','criteria2',...
	    'ForegroundColor',props.criteria_line(2).Color,...
	    'String','PACF Crit.',...
	    'Value',0,...
	    'Callback','arfit criteria',...
 	    'Tooltip','Partial Auto Correlation Function.',...
            'Position',[108.0000 21.7143 17  1.6429]);    
  h=uicontrol(props.checkbox,...
            'Tag','criteria3',...
	    'ForegroundColor',props.criteria_line(3).Color,...
	    'String','AIC Criterion',...
	    'Value',0,...
	    'Callback','arfit criteria',...
 	    'Tooltip','Akaike''s Information Criterion.',...
            'Position',[108.0000 20.1429 17  1.6429]);    
  h=uicontrol(props.checkbox,...
            'Tag','criteria4',...
	    'String','BIC Criterion',...
	    'ForegroundColor',props.criteria_line(4).Color,...
 	    'Value',0,...
	    'Callback','arfit criteria',...
 	    'Tooltip','Bayesian Information Criterion.',...
            'Position',[108.0000 18.5000 17  1.6429]);    
  h=uicontrol(props.checkbox,...
            'Tag','criteria5',...
	    'ForegroundColor',props.criteria_line(5).Color,...
	    'Tooltip','Criterion asses whether the residues follows white noise.',...
 	    'String','White Noise',...
	    'Value',0,...
	    'Callback','arfit criteria',...
            'Position',[108.0000 16.8571 17  1.6429]);    
%	    'Tooltip','Hannan-Quinn Criterion.',...
% 	    'String','HQ Criterion',...

%%%%% AR coefficients field
%  h=uicontrol(props.frame,...
%            'Tag','frame',...
%            'Position',[64.8333  1.2857 61.8333 13.6429]);    
  h=uicontrol(props.frame,...
            'Tag','frame',...
            'Position',[64.8333 14.3571  61.8333 .15]);    
  h=uicontrol(props.text,...
            'Tag','text',...
	    'String','AR Coefficients');    
  pos=get(h,'Extent');
  set(h,'Position',[66.5000 13.8571-.33 pos(3) pos(4)])    
  h=uicontrol(props.text,...
            'Tag','text',...
	    'String','Max. Order:');    
  pos=get(h,'Extent');
  set(h,'Position',[68.0000 12.08  pos(3) pos(4)])    
  h=uicontrol(props.edit,...
            'Tag','edit_maxorder',...
	    'Tooltip','Select the maximal order.',...
	    'String',num2str(maxm),...
	    'Callback','arfit update',...
            'Position',[81.5000 12.2857  5.3333  1.5000]);    
  in_m=maxm; 
  txt=[repmat('order ',maxm,1),num2str([1:maxm]'),repmat('|',maxm,1)]';
  txt=reshape(txt,1,prod(size(txt)));
  h=uicontrol(props.popup,...
            'Tag','popup_order',...
	    'String',txt(1:end-1),...
	    'Value',maxm,...
	    'Tooltip','Select the order to show their coefficients.',...
	    'Callback','arfit update',...
	    'Enable','off',...
            'Position',[88.8333 12.1429 16.5000  1.7143]);    
  h=uicontrol(props.listbox,...
            'Tag','listbox_coeff',...
	    'String','No Coeffs',...
	    'Tooltip','AR coefficients of the selected order.',...
	    'Enable','off',...
	    'ButtonDownFcn','arfit update',...
            'Position',[88.8333  2.3571 16.5000  9.7857]);    
  h=uicontrol(props.button,...
            'Tag','button_help',...
	    'String','Help',...
	    'Tooltip','Opens the help window.',...
 	    'Callback','helpwin arfit',...
           'Position',[108.0000  2.3571 17  2.0000]);    
  h=uicontrol(props.button,...
            'Tag','button_close',...
	    'String','Close',...
	    'Tooltip','Closes this window.',...
	    'Callback','close',...
            'Position',[108.0000  4.71425 17  2.0000]);    
  h=uicontrol(props.button,...
            'Tag','button_model',...
	    'String','Make Model',...
	    'Tooltip','Copy model to the workspace.',...
	    'Callback','arfit make_model',...
	    'Enable','off',...
            'Position',[108.0000  9.42855 17  2.0000]);    
  h=uicontrol(props.button,...
            'Tag','button_copyws',...
	    'String','To Workspace',...
	    'Tooltip','Copy coefficients to the Matlab workspace.',...
	    'Callback','arfit copyws',...
	    'Enable','off',...
            'Position',[108.0000 11.7857 17  2.0000]);    
  h=uicontrol(props.button,...
            'Tag','button_print',...
	    'String','Print',...
	    'Tooltip','Print the figure.',...
	    'Enable','on',...
	    'Callback','arfit print',...
            'Position',[108.0000  7.0714 17  2.0000]);    


  tags={'arfit_fig';'axes_logo';'frame';'text';'data_axes';'model_axes';'criteria_axes';'criteria1';'criteria2';'criteria3';'criteria4';'criteria5';'edit_maxorder';'popup_order';'listbox_coeff';'button_help';'button_close';'button_model';'button_copyws';'button_print';};
  h=[];
  for i=1:length(tags); h=[h; findobj('Tag',tags{i})]; end
  set(h,'Units','Norm');
  arfit update
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% close
  case 'close'

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% print
  case 'print'

    h=[];
    h=[h; findobj('Tag','criteria1','Parent',gcf)];
    h=[h; findobj('Tag','criteria2','Parent',gcf)];
    h=[h; findobj('Tag','criteria3','Parent',gcf)];
    h=[h; findobj('Tag','criteria4','Parent',gcf)];
    h=[h; findobj('Tag','criteria5','Parent',gcf)];
    h=[h; findobj('Tag','button_help','Parent',gcf)];
    h=[h; findobj('Tag','button_print','Parent',gcf)];
    h=[h; findobj('Tag','button_close','Parent',gcf)];
    h=[h; findobj('Tag','button_copyws','Parent',gcf)];
    h=[h; findobj('Tag','button_model','Parent',gcf)];
    set(h,'Visible','Off')
    h2=[];
    h2=[h2; findobj('Tag','popup_order','Parent',gcf)];
    h2=[h2; findobj('Tag','listbox_coeff','Parent',gcf)];
    h2=[h2; findobj('Tag','criteria_axes','Parent',gcf)];
    
    set(h2,'Units','Character')
    for k=1:length(h2);
      pos(k,:)=get(h2(k),'Position');
      set(h2(k),'Position',[pos(k,1:2) pos(k,3)+15 pos(k,4)])
    end

    set(h_fig,'CurrentAxes',h_criteria_axes);
    txt=[{'Var'};{'PACF'};{'AIC'};{'BIC'};{'HQ'};];
    h3=[];
    for k=1:length(show_crit);
       h3=[h3 findobj('Tag',['criteria_line',num2str(show_crit(k))],'Parent',h_criteria_axes)];
    end
    h4=legend(h3,txt(show_crit),-1);
    drawnow
    
    h_dlg=printdlg;
    waitfor(h_dlg)

    delete(h4)
    for k=1:length(h2);
      set(h2(k),'Position',pos(k,:))
    end
    set(h2,'Units','Normalize')
    set(h,'Visible','On')

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show criteria
  case 'criteria'

    set(h_fig,'CurrentAxes',h_criteria_axes)
    h=findobj('Tag','significance_line1','Parent',h_criteria_axes);
    signif=get(h,'UserData');

    for k=1:length(noshow_crit)
       h=findobj('Tag',['criteria_line',num2str(noshow_crit(k))],'Parent',h_criteria_axes);
       if ~isempty(h)
         set(h,'Visible','Off')
       end
    end
    
      for k=1:length(show_crit)
         h=findobj('Tag',['criteria_line',num2str(show_crit(k))],'Parent',h_criteria_axes);
         if isempty(h)
            h=plot(1:maxm,crit(:,show_crit(k)), 'Tag',['criteria_line',num2str(show_crit(k))]);
            
            set(h,'Parent',h_criteria_axes,'Tag','criteria_line',props.criteria_line(k),'Visible','On')
            set(h_criteria_axes,props.axes,...
                       'YTickLabel',[],...
	               'Tag','criteria_axes',...
		       'Xlim',[1 maxm],...
                       'Units','Norm',...
		       'UserData',crit,...
		       'NextPlot','add')
	 else
            set(h,'YData',crit(:,show_crit(k)),'XData',[1:size(crit,1)],'Visible','On')
	 end
      end
      
      % significance line for PACF
      h=findobj('Tag','significance_line1','Parent',h_criteria_axes);
      if isempty(h)
        h=line([1 maxm],[signif(1) signif(1)])
        set(h,props.criteria_line(6),...
	         'Parent',h_criteria_axes,...
		     'LineWidth',2,...
	         'Tag','significance_line1',...
             'Color', props.criteria_line(2).Color, ...
	         'Visible','Off')
      else
        set(h,'YData',[signif(1) signif(1)],...
	      'XData',[1 maxm],...
	      'Visible','Off')
      end
    
      if strcmpi(get(findobj('Tag','criteria_line2','Parent',h_criteria_axes),'Visible'),'on')
         set(h,'Visible','On')
      else
         set(h,'Visible','Off')
      end
      
      % significance line for Q criterion
      h=findobj('Tag','significance_line2','Parent',h_criteria_axes);
      if isempty(h)
        h=line([1 maxm],[signif(2) signif(2)]);
        set(h,props.criteria_line(6),...
	         'Parent',h_criteria_axes,...
		     'LineWidth',2,...
             'Color', props.criteria_line(5).Color, ...
	         'Tag','significance_line2',...
	         'Visible','Off')
      else
        set(h,'YData',[signif(2) signif(2)],...
	      'XData',[1 maxm],...
	      'Visible','Off')
      end
    
      if strcmpi(get(findobj('Tag','criteria_line5','Parent',h_criteria_axes),'Visible'),'on')
         set(h,'Visible','On')
      else
         set(h,'Visible','Off')
      end
      set(h_criteria_axes,'YTickLabel',[],'YLimMode','Auto','XLim',[1 maxm])
    

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% copy coefficients to the workspace
  case 'copyws'

  results=get(h_listbox_coeff,'UserData');
  a=[results{1}(in_m,1:in_m), results{2}(in_m)];
  set(0,'DefaultUIControlBackgroundColor',props.msgbox.BackgroundColor);
  answer = inputdlg('The AR coefficients will be stored in the variable:','Copy AR Coefficients',1);
  
  if ~isempty(answer), assignin('base',answer{1},a), end

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% copy AR model to the workspace
  case 'make_model'

  results=get(h_listbox_coeff,'UserData');
  a=results{1};
  v=results{2};
  
  y=make_model(a,v,in_m,length(x));
  %%%% plot the model data
  set(h_fig,'CurrentAxes',h_model_axes)
  h=findobj('Tag','model_line','Parent',h_model_axes);
  if isempty(h)
    h=plot(y);
    set(h,'Parent',h_model_axes,'Tag','model_line',props.line)
  else
    set(h,'YData',y,'XData',[1:length(y)])
  end
  set(h_model_axes,'Tag','model_axes')
  title('Model Data')

  set(0,'DefaultUIControlBackgroundColor',props.msgbox.BackgroundColor);
  answer = inputdlg('The AR model will be stored in the variable:','Copy AR Model',1);
  
  if ~isempty(answer), assignin('base',answer{1},y), end
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% update model
  case 'update'

  if ~nogui, setptr(h_fig,'watch'), end
  % covariance matrix:
  xm=mean(x);N=length(x);
  warning off
  for k=0:N;
    C(k+1)=mean((x(1:N-k)-xm).*(x(1+k:N)-xm))*(N-k)/N;
  end
  warning on
  
  P(1)=C(1);
  a(1,1)=1;
  
  % Levinson-Durbin algorithmus
  for m=1:maxm
    l=1:m-1;
    if m==1
      K(1+1)=(C(1+1))/P(1-1+1);
    else
      K(m+1)=(C(m+1)-sum(a(m-1+1,1+(1:m-1)).*C(m-(1:m-1)+1),2))/P(m-1+1);
    end
    P(m+1)=(1-K(m+1)^2)*P(m-1+1);
    a(m+1,m+1)=K(m+1);
    a(m+1,l+1)=a(m-1+1,l+1)-K(m+1)*a(m-1+1,m-l+1);
  end
  
  % varianz
  for p=1:maxm;
    l=1:p;
%    V(p)=C(1)-sum(a(p+1,l+1).*C(l+1));
    V(p)=C(1)-sum(a(p+1,l+1).^l .*C(l+1));
  end
  
  % criterias: 1 - residues variance 
  %            2 - PACF criteria
  %            3 - AIC criteria
  %            4 - BIC criteria
  %            (5 - HQ criteria)
  %            5 - Q criteria
  crit=zeros(maxm,5);
  for m=1:maxm
    clear y
    
%      y(i,1)=sum(a(m+1,(1:m)+1)'.*x(i-(m:-1:1)))+V(m)*randn;
%      for i=m+1:N; y(i,1)=sum(a(m+1,(1:m)+1)'.*x(i-1:-1:i-m)); end
     y=filter([0 a(m+1,(1:m)+1)],1,x);
    epsilon=(x-y);
    epsilon_mean=mean(epsilon(m:end));
    sigma=var(epsilon);
    clear rho
    for k=1:25;
      i=m+1:N-k-1;
      rho(k)=sum((epsilon(i+1)-epsilon_mean).*(epsilon(i+k+1)-epsilon_mean))/sum((epsilon(i+1)-epsilon_mean).^2);
    end
    crit(m,1)=sigma; % Variance of the residues
    crit(m,2)=abs(a(m+1,m+1)); % PACF
    crit(m,3)=log(sigma)+2*(m)/(N); % AIC
    crit(m,4)=log(sigma)+(m)*log(N)/(N); % BIC
%    crit(m,5)=log(sigma)+2*(m+1)*5*log(log(N-m))/(N-m);
    crit(m,5)=N*sum(rho.^2);
    
  end
%  signif(1)=1.96 * std(diag(a(2:end,2:end))) / (max(crit(:,2))-min(crit(:,2))); % significance level for the PACF criterion
  signif(1)=1.96 * sqrt(1/N) / (max(crit(:,2))-min(crit(:,2))); % significance level for the PACF criterion
  signif(2)=30/(max(crit(:,5))-min(crit(:,5))); % significance level for the Q criterion

  for k=1:size(crit,2);crit(:,k)=(crit(:,k)-min(crit(:,k)))/(max(crit(:,k))-min(crit(:,k)));end

  
  y=make_model(a(2:end,2:end),V,in_m,N);
  
%%%% graphical output
  if nogui==0
  
    %%%% enable all disabled objects
    set(h_popup_order,'Enable','On')
    set(h_listbox_coeff,'Enable','On')
    set(h_button_model,'Enable','On')
    set(h_button_copyws,'Enable','On')
    
    %%%% show the coefficients
    space_max=length(num2str(in_m));
    clear txt
    for i=1:in_m
     space=space_max-length(num2str(i));
     txt(i)={['a(',num2str(i),'):',repmat(' ',1,space),sprintf('% 6.4f',a(in_m+1,i+1))]};
    end
    txt(end+1)={['b: ',repmat(' ',1,space_max+1),sprintf('% 6.4f',V(in_m))]};
    set(h_listbox_coeff,'String',txt,'Value',1)
    
    %%%% plot the model data
    set(h_fig,'CurrentAxes',h_model_axes)
    h=findobj('Tag','model_line','Parent',h_model_axes);
    if isempty(h)
      h=plot(y);
      set(h,'Parent',h_model_axes,'Tag','model_line',props.line)
    else
      set(h,'YData',y,'XData',[1:length(y)])
    end
    set(h_model_axes,'Tag','model_axes',props.axes,'Units','Norm')
    title('Model Data')
    
    %%%% plot the criteria data

    if ~isempty(show_crit)
      set(h_fig,'CurrentAxes',h_criteria_axes)
      for k=1:length(show_crit)
        h=findobj('Tag',['criteria_line',num2str(show_crit(k))],'Parent',h_criteria_axes);
        if isempty(h)
          h=plot(1:maxm,crit(:,show_crit(k)));
          set(h,props.criteria_line(show_crit(k)),...
	         'Parent',h_criteria_axes,...
	         'Tag',['criteria_line',num2str(show_crit(k))],...
	         'Visible','On')
        else
            set(h,'YData',crit(:,show_crit(k)),...
	         'XData',[1:size(crit,1)],...
	         'Visible','On')
        end
    end
    
      % significance line for PACF criterion
      h=findobj('Tag','significance_line1','Parent',h_criteria_axes);
      if isempty(h)
        h=line([1 maxm],[signif(1) signif(1)]);
        set(h,props.criteria_line(6),...
	         'Parent',h_criteria_axes,...
	         'Tag','significance_line1',...
             'Color', props.criteria_line(2).Color, ...
	         'UserData',signif,...
             'LineWidth',2,...
	         'Visible','Off')
      else
        set(h,'YData',[signif(1) signif(1)],...
	      'XData',[1 maxm],...
	      'UserData',signif,...
	      'Visible','Off')
      end
      if strcmpi(get(findobj('Tag','criteria_line2','Parent',h_criteria_axes),'Visible'),'on')
         set(h,'Visible','On')
      else
         set(h,'Visible','Off')
      end
    
      % significance line for Q criterion
      h=findobj('Tag','significance_line2','Parent',h_criteria_axes);
      if isempty(h)
        h=line([1 maxm],[signif(2) signif(2)]);
        set(h,props.criteria_line(6),...
	         'Parent',h_criteria_axes,...
	         'Tag','significance_line2',...
	         'UserData',signif,...
             'Color', props.criteria_line(5).Color, ...
             'LineWidth',2,...
	         'Visible','Off')
      else
        set(h,'YData',[signif(2) signif(2)],...
	      'XData',[1 maxm],...
	      'UserData',signif,...
	      'Visible','Off')
      end
      if strcmpi(get(findobj('Tag','criteria_line5','Parent',h_criteria_axes),'Visible'),'on')
         set(h,'Visible','On')
      else
         set(h,'Visible','Off')
      end
     
      set(h_criteria_axes,props.axes,...
           'Tag','criteria_axes',...
	       'YTickLabel',[],...
           'Xlim',[1 maxm],...
           'Ylim',[0 1],...
	       'UserData',crit,...
	       'Units','Norm',...
	       'NextPlot','add')
    end
    
    set(h_listbox_coeff,'UserData',{a(2:end,2:end);V})

  else
      varargout{1}=[a(in_m+1,2:end), V(in_m)];
      varargout{2}=y;
  end
  if ~nogui, setptr(h_fig,'arrow'), end
end

try, set(0,props.root), end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% error handling
if 0
%catch
  if ~isempty(findobj('Tag','TMWWaitbar')), delete(findobj('Tag','TMWWaitbar')), end
  z=whos;x=lasterr;y=lastwarn;in=varargin{1};
  if ischar(in), in2=in; else, in2=[]; end
  in=whos('in');
  if ~strcmpi(lasterr,'Interrupt')
    fid=fopen('error.log','w');
    err=fprintf(fid,'%s\n','Please send us the following error report. Provide a brief');
    err=fprintf(fid,'%s\n','description of what you were doing when this problem occurred.');
    err=fprintf(fid,'%s\n','E-mail or FAX this information to us at:');
    err=fprintf(fid,'%s\n','    E-mail:  marwan@agnld.uni-potsdam.de');
    err=fprintf(fid,'%s\n','       Fax:  ++49 +331 977 1142');
    err=fprintf(fid,'%s\n\n\n','Thank you for your assistance.');
    err=fprintf(fid,'%s\n',repmat('-',50,1));
    err=fprintf(fid,'%s\n',datestr(now,0));
    err=fprintf(fid,'%s\n',['Matlab ',char(version),' on ',computer]);
    err=fprintf(fid,'%s\n',repmat('-',50,1));
    err=fprintf(fid,'%s\n',x);
    err=fprintf(fid,'%s\n',y);
    err=fprintf(fid,'%s\n',[' during ==> arfit:',action]);
    err=fprintf(fid,'%s\n',[' criteria ==> ',num2str(crit)]);
    err=fprintf(fid,'%s',[' input ==> ',mat2str(size(x))]);
    err=fprintf(fid,'%s\n',[' errorcode ==> no errorcode available']);
    err=fprintf(fid,'%s\n',' workspace dump ==>');
    if ~isempty(z), 
      err=fprintf(fid,'%s\n',['Name',char(9),'Size',char(9),'Bytes',char(9),'Class']);
    for j=1:length(z);
      err=fprintf(fid,'%s\n',[z(j).name,char(9),num2str(z(j).size),char(9),num2str(z(j).bytes),char(9),z(j).class]);
    end, end
    err=fclose(fid);
    disp('------------------------------');
    disp('        ERROR OCCURED');
    disp('   during executing arfit');
    disp('------------------------------');
    disp(x);
    disp(['   during ',action]);
    disp('----------------------------');
    disp('   Please send us the error report. For your convenience, ')
    disp('   this information has been recorded in: ')
    disp(['   ',fullfile(pwd,'error.log')]), disp(' ')
    disp('   Provide a brief description of what you were doing when ')
    disp('   this problem occurred.'), disp(' ')
    disp('   E-mail or FAX this information to us at:')
    disp('       E-mail:  marwan@agnld.uni-potsdam.de')
    disp('          Fax:  ++49 +331 977 1142'), disp(' ')
    disp('   Thank you for your assistance.')
    warning('on')
  end
  set(0,props.root)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sub-programme make AR model
function y=make_model(a,V,in_m,N)

y=filter(V(in_m),[1 -a(in_m,(1:in_m))],randn(N,1));
