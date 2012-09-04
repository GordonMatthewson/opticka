%> SEDITOR GUI to manually edit values from a stimulus class passed to it from opticka
classdef seditor < handle
	
	properties
		handles
		fn
		stim
		cprop
		ckind
		otherstimuli
		mversion
		optickahandle = 0
	end
	
	methods
		function obj = seditor(stimin, ohandlein)
			if exist('stimin','var')
				obj.stim = stimin;
				obj.stim.reset(); %remove temporary/transient properties
			end
			if exist('ohandlein','var')
				obj.optickahandle = ohandlein;
			end
			
			obj.mversion = str2double(regexp(version,'(?<ver>^\d\.\d\d)','match','once'));
			obj.handles = struct();
			oldlook=javax.swing.UIManager.getLookAndFeel;
			newlook='javax.swing.plaf.metal.MetalLookAndFeel';
			if obj.mversion < 7.12 && (ismac || ispc)
				javax.swing.UIManager.setLookAndFeel(newlook);
			end
			obj.buildGUI();
			drawnow;
			if obj.mversion < 7.12 && (ismac || ispc)
				javax.swing.UIManager.setLookAndFeel(oldlook);
			end
			if ~isempty(obj.stim)
				obj.fn = fieldnames(obj.stim);
				set(obj.handles.StimEditorPropertyList,'String',obj.fn);
			end
			obj.StimEditorPropertyList_Callback;
		end
		
		function buildGUI(obj)
			% Creation of all uicontrols
			
			% --- FIGURE -------------------------------------
			obj.handles.figure1 = figure( ...
				'Tag', 'figure1', ...
				'Units', 'pixels', ...
				'Position', [200 500 400 250], ...
				'Name', 'Stimulus Editor', ...
				'MenuBar', 'none', ...
				'NumberTitle', 'off', ...
				'Color', [0.9 0.9 0.9]);
			
			obj.handles.panel = uiextras.BoxPanel('Parent',obj.handles.figure1,...
				'TitleColor',[1 0.75 0.25],'Title','Properties:');
			obj.handles.vbox = uiextras.VBox('Parent',obj.handles.panel);
			
			% --- POPUP MENU -------------------------------------
			obj.handles.StimEditorPropertyList = uicontrol( ...
				'Parent', obj.handles.vbox, ...
				'Tag', 'StimEditorPropertyList', ...
				'Style', 'popupmenu', ...
				'Units', 'pixels', ...
				'FontName', 'Helvetica', ...
				'FontSize', 12, ...
				'BackgroundColor', [1 1 1], ...
				'String', '0', ...
				'Callback', @obj.StimEditorPropertyList_Callback);
			
			% --- EDIT TEXTS -------------------------------------
			
			obj.handles.StimEditorEdit = uicontrol( ...
				'Parent', obj.handles.vbox, ...
				'Tag', 'StimEditorEdit', ...
				'Style', 'edit', ...
				'Units', 'pixels',...
				'FontName', 'Menlo', ...
				'FontSize', 20, ...
				'TooltipString', 'Enter a number, logical or string depending on type here', ...
				'BackgroundColor', [1 1 1], ...
				'String', '0', ...
				'Callback', @obj.StimEditorEdit_Callback);
			obj.handles.StimEditorText = uicontrol( ...
				'Parent', obj.handles.vbox, ...
				'Tag', 'StimEditorText', ...
				'Style', 'text', ...
				'Units', 'pixels', ...
				'FontName', 'Helvetica', ...
				'FontSize', 12, ...
				'ForegroundColor',[0.3 0.3 0.3],...
				'String', 'Number');
			
			
			obj.handles.StimEditorStimList = uicontrol( ...
				'Parent', obj.handles.vbox, ...
				'Tag', 'StimEditorEdit', ...
				'Style', 'edit', ...
				'Units', 'pixels', ...
				'FontName', 'Helvetica', ...
				'FontSize', 11, ...
				'TooltipString', 'Put a range of other stimuli in the list to modify', ...
				'String', '', ...
				'Callback', @obj.StimEditorStimList_Callback);
			uicontrol( ...
				'Parent', obj.handles.vbox, ...
				'Tag', 'text42', ...
				'Style', 'text', ...
				'Units', 'pixels', ...
				'FontName', 'Helvetica', ...
				'FontSize', 10, ...
				'ForegroundColor',[0.7 0.7 0.7],...
				'String', 'Other Stimuli to modify (can specify range 2:8 etc.)');
			
			obj.handles.hbox = uiextras.HBox('Parent',obj.handles.vbox);
			
			% --- PUSHBUTTONS -------------------------------------
			obj.handles.StimEditorOK = uicontrol( ...
				'Parent', obj.handles.hbox, ...
				'Tag', 'StimEditorOK', ...
				'Style', 'pushbutton', ...
				'Units', 'pixels', ...
				'FontName', 'Helvetica', ...
				'FontSize', 10, ...
				'String', 'OK', ...
				'Callback', @obj.StimEditorOK_Callback);
			
			uiextras.Empty('Parent',obj.handles.hbox);
			
			obj.handles.StimEditorChange = uicontrol( ...
				'Parent', obj.handles.hbox, ...
				'Tag', 'StimEditorChange', ...
				'Style', 'pushbutton', ...
				'Units', 'pixels', ...
				'FontName', 'Helvetica', ...
				'FontSize', 10, ...
				'Enable', 'off',...
				'String', 'Change', ...
				'Callback', @obj.StimEditorEdit_Callback);
			
			obj.handles.vbox.Sizes = [-3 -5 -2 -2 -1 -2];
			obj.handles.vbox.MinimumSizes = [25 100 25 25 15 25];
			obj.handles.hbox.Sizes = [-3 -2 -1];
		end
		
		%% ---------------------------------------------------------------------------
		function StimEditorOK_Callback(obj,hObject,evendata) %#ok<INUSD>
			close(obj.handles.figure1)
		end
		
		%% ---------------------------------------------------------------------------
		function StimEditorEdit_Callback(obj,hObject,evendata) %#ok<INUSD>
			s=get(obj.handles.StimEditorEdit,'String');
			switch obj.ckind
				case 'number'
					s=str2num(s);
					obj.stim.(obj.cprop) = s;
					
				case 'logical'
					s=str2num(s);
					if s > 0
						s=true;
					else
						s=false;
					end
					obj.stim.(obj.cprop) = s;
					
				case 'string'
					obj.stim.(obj.cprop) = s;
			end
			fprintf('\n->Modify %s : %g',obj.cprop,s)
			
			if isappdata(obj.optickahandle,'o') %check opticka is running
				o = getappdata(obj.optickahandle,'o');
				if ~isempty(obj.otherstimuli) %check if other stimuli are tagged to edit too
					for i=1:length(obj.otherstimuli)
						if ~isempty(findprop(o.r.stimulus{obj.otherstimuli(i)},obj.cprop)) %check it has this porperty
							o.r.stimulus{obj.otherstimuli(i)}.(obj.cprop) = s;
							fprintf(' | +stim%g',obj.otherstimuli(i))
						end
					end
				end
				fprintf('\n');
				o.modifyStimulus; %flush the opticka UI and do what's needed
			end
		end
		
		%% ---------------------------------------------------------------------------
		function StimEditorStimList_Callback(obj,hObject,evendata) %#ok<INUSD>
			ts = get(hObject,'String');
			ts = regexprep(ts,'-',':');
			obj.otherstimuli = str2num(ts);
		end
		
		%% ---------------------------------------------------------------------------
		function StimEditorPropertyList_Callback(obj,hObject,evendata) %#ok<INUSD>
			v=get(obj.handles.StimEditorPropertyList,'Value');
			s=get(obj.handles.StimEditorPropertyList,'String');
			obj.cprop=s{v};
			editvalue = obj.stim.(obj.cprop);
			if isnumeric(editvalue)
				obj.ckind='number';
				editvalue = num2str(editvalue);
				set(obj.handles.StimEditorText,'String','Property type: Number')
			elseif islogical(editvalue)
				obj.ckind='logical';
				editvalue = num2str(editvalue);
				set(obj.handles.StimEditorText,'String','Property type: Logical')
			else
				obj.ckind = 'string';
				set(obj.handles.StimEditorText,'String','Property type: String')
			end
			set(obj.handles.StimEditorEdit,'String',editvalue);
		end
		
	end
	
end

