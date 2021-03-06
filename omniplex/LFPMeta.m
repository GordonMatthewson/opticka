classdef LFPMeta < analysisCore
	
	properties
		%verbosity
		verbose = true;
	end
	
	properties (SetAccess = protected, GetAccess = public)
		%> cells (sites)
		cells@cell
		%> display list
		list@cell
		%> raw LFP objects
		raw@cell
		%> meta results
		results
	end
	
	properties (SetAccess = protected, GetAccess = public, Transient = true)
		%> version
		version@double = 0.85
	end
	
	properties (Dependent = true, SetAccess = private, GetAccess = public)
		%> number of loaded units
		nSites
	end
	
	properties (SetAccess = private, GetAccess = private)
		oldDir@char
		previousSelection@double = 0
	end
	
	%=======================================================================
	methods %------------------PUBLIC METHODS
	%=======================================================================

		% ===================================================================
		%> @brief Constructor
		%>
		%> @param varargin
		%> @return
		% ===================================================================
		function me=LFPMeta(varargin)
			if nargin == 0; varargin.name = 'LFPMeta';end
			me=me@analysisCore(varargin); %superclass constructor
			if nargin>0; me.parseArgs(varargin, me.allowedProperties); end
			if isempty(me.name);me.name = 'LFPMeta'; end
			me.plotRange = [-0.35 0.35];
			makeUI(me);
		end
		
		% ===================================================================
		%> @brief add LFPAnalysis objects to the meta list
		%>
		%> @param
		%> @return
		% ===================================================================
		function add(me, varargin)
			[file,path]=uigetfile('*.mat','Meta-Analysis:Choose LFP source File','Multiselect','on');
			if ~iscell(file) && ~ischar(file)
				warning('Meta-Analysis Error: No File Specified')
				return
			end
	
			cd(path);
			if ischar(file)
				file = {file};
			end
			
			addtic = tic;
			l = length(file);
			for ll = 1:length(file)
				notifyUI(me,sprintf('Loading %g of %g Cells...',ll,l));
				load(file{ll});
				if exist('lfp','var') && isa(lfp,'LFPAnalysis')
					optimiseSize(lfp);
					idx = me.nSites+1;
					me.raw{idx} = lfp;
					for i = 1:2
						if ~isempty(lfp.selectedTrials)
							me.cells{idx,i}.name = [lfp.selectedTrials{i}.name];
						else
							me.cells{idx,i}.name = 'unknown';
						end
						me.cells{idx,i}.weight = 1;
						me.cells{idx,i}.selLFP = lfp.selectedLFP;
						me.cells{idx,i}.selUnit = lfp.sp.selectedUnit;
						me.cells{idx,i}.type = 'LFPAnalysis';
					end
				else
					warndlg('This file wasn''t an LFPAnalysis MAT file...')
					return
				end

				t = [me.cells{idx,1}.name '>>>' me.cells{idx,2}.name];
				if strcmpi(me.cells{idx,1}.type,'oPro')
					t = regexprep(t,'[\|\s][\d\-\.]+','');
				else
					
				end
				t = [lfp.lfpfile ' : ' t];
				me.list{idx} = t;

				set(me.handles.list,'String',me.list);
				set(me.handles.list,'Value',me.nSites);

				clear lfp
			end
			
			fprintf('Cell loading took %.5g seconds\n',toc(addtic))
			notifyUI(me,sprintf('Loaded %g Cells, you now need to process them...',me.nSites));
			
		end
		
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function process(me, varargin)
			if me.nSites > 0
				analMethod = get(me.handles.analmethod,'Value');
				if isempty(me.options) || isempty(me.options.stats); initialise(me); end%initialise the various analysisCore options fields
				for i = 1 : me.nSites
					notifyUI(me,sprintf('Reprocessing the timelock/frequency analysis for site %i',i));
					me.raw{i}.doPlots = false;
					me.raw{i}.options.stats = me.options.stats;
					me.raw{i}.baselineWindow = me.baselineWindow;
					me.raw{i}.measureRange = me.measureRange;
					me.raw{i}.plotRange = me.plotRange;
					
					if analMethod == 1 %timelock
						cfg = [];cfg.keeptrials = 'yes';
						me.raw{i}.ftTimeLockAnalysis(cfg);
	
					else
						me.raw{i}.ftFrequencyAnalysis([],...
							me.options.tw,...
							me.options.cycles,...
							me.options.smth,...
							me.options.width);
					end
					
				end
				notifyUI(me,'Reprocessing complete for %i sites',i);
				plotSite(me);
			end
		end
		
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function run(me,varargin)
			if me.nSites > 0
				
				am = get(me.handles.analmethod,'Value');
				
				for i = 1: me.nSites
					
					me.raw{i}.doPlots = false;
					me.raw{i}.options.stats = me.options.stats;
					me.raw{i}.baselineWindow = me.baselineWindow;
					me.raw{i}.measureRange = me.measureRange;
					me.raw{i}.plotRange = me.plotRange;
					
					if am == 1 %timelock
						if ~isfield(me.raw{i}.results,'av')
							errordlg('You have''nt Processed the data yet...')
						end
						metaA{i} = me.raw{i}.results.av{1};
						metaB{i} = me.raw{i}.results.av{2};
						metaA{i}.label = {'LFP'}; %force an homogeneous label name
						metaB{i}.label = {'LFP'};
						metaA{i}.dimord = 'chan_time';
						metaB{i}.dimord = 'chan_time';
					else
						
						metaA{i} = me.raw{i}.(['fq' me.options.method]){1};
						metaB{i} = me.raw{i}.(['fq' me.options.method]){1};
						
					end
					
					
				end
				
				if am == 1 %timelock
					cfg						= [];
					cfg.channel				= 'all';
					cfg.keepindividual	= 'no';
					cfg.parameter			= 'avg';
					cfg.method				= 'across'; %(default) or 'within', see below.
% 					cfg.latency				= me.measureRange;
% 					cfg.normalizevar		= 'N' or 'N-1' (default = 'N-1')
					avgA = ft_timelockgrandaverage(cfg, metaA{:});
					avgB = ft_timelockgrandaverage(cfg, metaB{:});
				else
					
				end
				
				me.handles.axistabs.Selection = 2;
				ho = me.handles.axisall;
				delete(ho.Children);
				h = uipanel('Parent',ho,'units', 'normalized', 'position', [0 0 1 1]);
				ha = axes('Parent',h);
				e = analysisCore.var2SE(avgA.var, avgA.dof);
				areabar(avgA.time,avgA.avg, e, [0.5 0.5 0.5],0.5,'k.-');
				hold on
				e = analysisCore.var2SE(avgB.var, avgB.dof);
				areabar(avgB.time, avgB.avg, e, [0.5 0.5 0.5],0.5,'r.-');
				hold off
				legend('Group A','Group B')
				grid on
				xlim(me.plotRange)
				title('Population average')
				xlabel('Time (s)');
				ylabel('Voltage (mV) �1S.E.');

			end
			
		end
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function load(me, varargin)
			[file,path]=uigetfile('*.mat','Meta-Analysis:Choose MetaAnalysis');
			if ~ischar(file)
				errordlg('No File Specified', 'Meta-Analysis Error');
				return
			end
			
			cd(path);
			load(file);
			if exist('lfpmet','var') && isa(fgmet,'LFPMeta')
				reset(me);
				me.raw = lfpmet.raw;
				me.cells = lfpmet.cells;
				me.list = lfpmet.list;
				me.mint = lfpmet.mint;
				me.maxt = lfpmet.maxt;
				set(me.handles.list,'String',me.list);
				set(me.handles.list,'Value',me.nSites);
			end
			
			clear lfpmet
		end
		
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function save(me, varargin)
			[file,path] = uiputfile('*.mat','Save Meta Analysis:');
			if ~ischar(file)
				errordlg('No file selected...')
				return 
			end
			me.oldDir = pwd;
			cd(path);
			lfpmet = me; %#ok<NASGU>
			save(file,'lfpmet');
			clear lfpmet;
			cd(me.oldDir);
		end
		
		% ===================================================================
		%> @brief
		%>
		%> @param
		%> @return
		% ===================================================================
		function spawn(me, varargin)
			gh = gca;
			h = figure;
			figpos(1,[1000 800]);
			set(h,'Color',[1 1 1]);
			hh = copyobj(gh,h);
		end
		
		% ===================================================================
		%> @brief
		%>
		%> @param
		%> @return
		% ===================================================================
		function toggleSaccades(me, varargin)
			if me.nSites > 0
				firstState = false;
				for i = 1 : me.nSites
					if i == 1
						me.raw{i}.toggleSaccadeRealign
						firstState = me.raw{i}.p.saccadeRealign; %keep our first state saved
					else
						if firstState ~= me.raw{i}.p.saccadeRealign; %make sure all states will sync to first
							me.raw{i}.toggleSaccadeRealign
						end
					end
					
				end
			end
		end
		
		% ===================================================================
		%> @brief
		%>
		%> @param
		%> @return
		% ===================================================================
		function value = get.nSites(me)
			value = length(me.list);
			if isempty(value)
				value = 0;
				return
			elseif value == 1 && iscell(me.list) && isempty(me.list{1})
				value = 0;
			end
		end
		
		
		% ===================================================================
		%> @brief
		%>
		%> @param
		%> @return
		% ===================================================================
		function quit(me, varargin)
			reset(me);
			closeUI(me);
		end

	end%-------------------------END PUBLIC METHODS--------------------------------%
	
	%=======================================================================
	methods (Hidden = true) %------------------Hidden METHODS
	%=======================================================================
	
		% ===================================================================
		%> @brief plot individual
		%>
		%> @param
		%> @return
		% ===================================================================
		function select(me, varargin)
			if me.nSites > 0
				tab = me.handles.axistabs.Selection;
				sel = get(me.handles.list,'Value');
				me.raw{sel}.select();
				me.plotsite();
			end
		end
		
		% ===================================================================
		%> @brief plot individual
		%>
		%> @param
		%> @return
		% ===================================================================
		function plotSite(me, varargin)
			if me.nSites > 0
				me.handles.axistabs.Selection = 1;
				plot(me);
			end
		end
		
		% ===================================================================
		%> @brief plot individual
		%>
		%> @param
		%> @return
		% ===================================================================
		function plot(me, varargin)
			if me.nSites > 0
				tab = me.handles.axistabs.Selection;
				sel = get(me.handles.list,'Value');
				switch tab
					case 1
						if sel ~= me.previousSelection;
							ho = me.handles.axisind;
							delete(ho.Children);
							h = uipanel('Parent',ho,'units', 'normalized', 'position', [0 0 1 1]);
							me.raw{sel}.plotDestination = h;
							plot(me.raw{sel},'timelock');
							me.previousSelection = sel;
						end
					case 2
% 						ho = me.handles.axisall;
% 						delete(ho.Children);
% 						h = uipanel('Parent',ho,'units', 'normalized', 'position', [0 0 1 1]);
						
				end
				
			end
		end
		
		% ===================================================================
		%> @brief showInfo shows the info box for the plexon parsed data
		%>
		%> @param
		%> @return
		% ===================================================================
		function setOptions(me, varargin)
			initialise(me);
			setTimeFreqOptions(me);
			setStats(me);
		end
		
		% ===================================================================
		%> @brief
		%>
		%> @param
		%> @return
		% ===================================================================
		function editweight(me, varargin)
			if me.nSites > 0
				sel = get(me.handles.list,'Value');
				w = str2num(get(me.handles.weight,'String'));
				if length(w) == 2;
					me.cells{sel,1}.weight = w(1);
					me.cells{sel,2}.weight = w(2);
					if min(w) == 0
						s = me.list{sel};
						s = regexprep(s,'^\*+','');
						s = ['**' s];
						me.list{sel} = s;
						set(me.handles.list,'String',me.list);
					elseif min(w) < 1
						s = me.list{sel};
						s = regexprep(s,'^\*+','');
						s = ['*' s];
						me.list{sel} = s;
						set(me.handles.list,'String',me.list);
					else
						s = me.list{sel};
						s = regexprep(s,'^\*+','');
						me.list{sel} = s;
						set(me.handles.list,'String',me.list);
					end
				end
				replot(me);
			end
		end
		
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function remove(me, varargin)
			if me.nSites > 0
				sel = get(me.handles.list,'Value');
				me.cells(sel,:) = [];
				me.list(sel) = [];
				me.raw(sel) = [];
				if sel > 1
					set(me.handles.list,'Value',sel-1);
				end
				set(me.handles.list,'String',me.list);
			end
		end
		
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function reparse(me,varargin)
			if me.nSites > 0
				sel = get(me.handles.list,'Value');
				me.raw{sel}.reparse;
			end
		end

		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function parse(me,varargin)
			if me.nSites > 0
				sel = get(me.handles.list,'Value');
				me.raw{sel}.parse;
			end
		end
		
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function reset(me,varargin)
			try
				notifyUI(me,'Resetting all data...');
				drawnow
				me.raw = cell(1);
				me.cells = cell(1);
				me.list = cell(1);
				if isfield(me.handles,'list')
					set(me.handles.list,'Value',1);
					set(me.handles.list,'String',{''});
				end
				ho = me.handles.axisind;
				delete(ho.Children);
				ho = me.handles.axisall;
				delete(ho.Children);
				me.handles.axistabs.SelectedChild=1;
				if isfield(me.handles,'axis1')
					me.handles.axistabs.SelectedChild=2; 
					axes(me.handles.axis2);cla
					me.handles.axistabs.SelectedChild=1; 
					axes(me.handles.axis1); cla
					set(me.handles.root,'Title',['Number of Cells Loaded: ' num2str(me.nSites)]);
				end
			end
		end
		
	end%-------------------------END HIDDEN METHODS--------------------------------%
	
	%=======================================================================
	methods (Access = protected) %------------------PRIVATE METHODS
	%=======================================================================
		
		% ===================================================================
		%> @brief
		%>
		%> @param
		%> @return
		% ===================================================================
		function [psth1,psth2,time]=computeAverage(me)
			
			for idx = 1:me.nSites
				
				
			end
			
		end
		
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function closeUI(me)
			try delete(me.handles.parent); end %#ok<TRYNC>
			me.handles = struct();
			me.openUI = false;
		end
		
		% ===================================================================
		%> @brief
		%>
		%> @param
		%> @return
		% ===================================================================
		function makeUI(me)
			if ~isempty(me.handles) && isfield(me.handles,'root') && isa(me.handles.root,'uix.BoxPanel')
				fprintf('---> UI already open!\n');
				return
			end
			if ~exist('parent','var')
				parent = figure('Tag','LMAMeta', ...
					'Name', ['LFP Meta Analysis V' num2str(me.version)], ...
					'MenuBar', 'none', ...
					'CloseRequestFcn', @me.quit, ...
					'NumberTitle', 'off');
				figpos(1,[1600 800])
			end
			me.handles(1).parent = parent;
			
			%make context menu
			hcmenu = uicontextmenu;
			uimenu(hcmenu,'Label','Parse (selected)','Callback',@me.parse,'Accelerator','a');
			uimenu(hcmenu,'Label','Reparse (selected)','Callback',@me.reparse,'Accelerator','e');
			uimenu(hcmenu,'Label','Select (selected)','Callback',@me.select,'Accelerator','s');
			uimenu(hcmenu,'Label','Remove (selected)','Callback',@me.remove,'Accelerator','r');
			uimenu(hcmenu,'Label','Reanalyse (all)','Callback',@me.process,'Separator','on');
			uimenu(hcmenu,'Label','Compute average (all)','Callback',@me.run);
			uimenu(hcmenu,'Label','Toggle Saccades (all)','Callback',@me.toggleSaccades);
			uimenu(hcmenu,'Label','Reset (all)','Callback',@me.reset);
			
			fs = 11;
			SansFont = 'Helvetica';
			MonoFont = 'Menlo';
			bgcolor = [0.89 0.89 0.89];
			bgcoloredit = [0.9 0.9 0.9];

			handles.parent = me.handles.parent; %#ok<*PROP>
			handles.root = uix.BoxPanel('Parent',parent,...
				'Title','Please load some data...',...
				'FontName',SansFont,...
				'FontSize',fs+2,...
				'FontWeight','bold',...
				'Padding',0,...
				'TitleColor',[0.8 0.78 0.76],...
				'BackgroundColor',bgcolor);

			handles.hbox = uix.HBoxFlex('Parent', handles.root,'Padding',0,...
				'Spacing', 5, 'BackgroundColor', bgcolor);
			handles.axistabs = uix.TabPanel('Parent', handles.hbox,'Padding',0,...
				'BackgroundColor',bgcolor,'TabWidth',120,'FontSize', fs+1,'FontName',SansFont);
			handles.axisind = uix.Panel('Parent', handles.axistabs,'Padding',0,...
				'BackgroundColor',bgcolor);
			handles.axisall = uix.Panel('Parent', handles.axistabs,'Padding',0,...
				'BackgroundColor',bgcolor);
			handles.axistabs.TabTitles = {'Individual','Population'};

			handles.controls = uix.VBox('Parent', handles.hbox,'Padding',0,'Spacing',0,'BackgroundColor',bgcolor);
			handles.controls1 = uix.Grid('Parent', handles.controls,'Padding',4,'Spacing',2,'BackgroundColor',bgcolor);
			handles.controls2 = uix.Grid('Parent', handles.controls,'Padding',4,'Spacing',0,'BackgroundColor',bgcolor);
			handles.controls3 = uix.Grid('Parent', handles.controls,'Padding',4,'Spacing',2,'BackgroundColor',bgcolor);
			
			handles.loadbutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMAloadbutton',...
				'FontSize', fs,...
				'Tooltip','Load a previous meta analysis',...
				'Callback',@me.load,...
				'String','Load');
			handles.savebutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMAsavebutton',...
				'Tooltip','Save the meta-analysis',...
				'FontSize', fs,...
				'Callback',@me.save,...
				'String','Save');
			handles.addbutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMAaddbutton',...
				'FontSize', fs,...
				'Tooltip','Add a singe LFP item',...
				'Callback',@me.add,...
				'String','Add');
			handles.removebutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMAremovebutton',...
				'FontSize', fs,...
				'Tooltip','Remove a single item',...
				'Callback',@me.remove,...
				'String','Remove');
			handles.processbutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMArunbutton',...
				'FontSize', fs,...
				'Tooltip','(Re)Process the individual LFPs',...
				'Callback',@me.process,...
				'String','Process');
			handles.runbutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMArunbutton',...
				'FontSize', fs,...
				'Callback',@me.run,...
				'String','Run');
			handles.spawnbutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMAspawnbutton',...
				'FontSize', fs,...
				'Callback',@me.spawn,...
				'String','Spawn');
			handles.resetbutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMAreplotbutton',...
				'FontSize', fs,...
				'Callback',@me.reset,...
				'String','Reset');
			handles.optionsbutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMAsettingsbutton',...
				'FontSize', fs,...
				'Callback',@me.setOptions,...
				'String','Options');
			handles.saccbutton = uicontrol('Style','pushbutton',...
				'Parent',handles.controls1,...
				'Tag','LMAsaccbutton',...
				'FontSize', fs,...
				'Tooltip','Toggle Saccade Realign',...
				'Callback',@me.toggleSaccades,...
				'String','Toggle Saccades');
			handles.weight = uicontrol('Style','edit',...
				'Parent',handles.controls1,...
				'Tag','LMAweight',...
				'FontSize', fs,...
				'Enable','off',...
				'Tooltip','Cell Weight',...
				'Callback',@me.editweight,...
				'String','1 1');
			
			handles.list = uicontrol('Style','listbox',...
				'Parent',handles.controls2,...
				'Tag','LMAlistbox',...
				'Min',1,...
				'Max',1,...
				'FontSize',fs+1,...
				'FontName',MonoFont,...
				'Callback',@me.plotSite,...
				'String',{''},...
				'uicontextmenu',hcmenu);
			
			handles.analmethod = uicontrol('Style','popupmenu',...
				'Parent',handles.controls3,...
				'FontSize', fs,...
				'Tag','LMAanalmethod',...
				'String',{'timelock','power'});
			
			set(handles.hbox,'Widths', [-3 -1]);
			set(handles.controls,'Heights', [70 -1 95]);
			set(handles.controls1,'Heights', [-1 -1 -1])
			set(handles.controls3,'Widths', [-1], 'Heights', [-1])

			me.handles = handles;
			me.openUI = true;
		end
		
		% ===================================================================
		%> @brief
		%>
		%> @param
		%> @return
		% ===================================================================
		function notifyUI(me, varargin)
			if nargin > 2
				info = sprintf(varargin{:});
			else
				info = varargin{1};
			end
			try set(me.handles.root,'Title',info); drawnow; end %#ok<TRYNC>
		end
		
		% ===================================================================
		%> @brief 
		%>
		%> @param
		%> @return
		% ===================================================================
		function updateUI(me)
			
		end
	end	
end
