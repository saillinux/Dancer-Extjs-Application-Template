package 
{
	import flash.display.*;	
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.utils.Timer;	

	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.TextShortcuts;
	
	import com.sQrt121.utils.ContentLoader;
	import com.sQrt121.utils.CustomEvent;
	
	
	public class  BackgroundManager extends MovieClip
	{
		// PUBLIC CONSTANTS
		
		
		// PRIVATE CONSTANTS		
		
		
		// PUBLIC VARS
		public var xml:XML;
					
		// PRIVATE VARS		
		private var mcCurrentBackground:MovieClip;
		private var mcPreviousBackground:MovieClip;
		private var mcNavi:MovieClip;
		private var mcBackgroundContainer:MovieClip;
		private var nSection:uint;
		private var nID:uint;
		private var tTimer:Timer;
		private var bLoading:Boolean;
		
		
		public function BackgroundManager()
		{
			initialSetup();
			addEventListener( Event.ADDED_TO_STAGE, init );			
		}
		private function initialSetup():void
		{
			ColorShortcuts.init ();
			DisplayShortcuts.init ();
			FilterShortcuts.init ();
			TextShortcuts.init ();
					
		}
		private function init(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
		
			stage.scaleMode		= StageScaleMode.NO_SCALE;
			stage.align			= StageAlign.TOP_LEFT;		
			
			this.addEventListener("LXML", loadedXML);
			ContentLoader.addJob("xml", ["xml/background.xml"], this, "LXML", false);
			
		}	
		
		// XML IS LOADED
		private function loadedXML(e:CustomEvent):void
		{
			xml	= e.params.aContent[0];
			

			initBackgroundContainer();
			changeSection(0);
		}
		
		
		
		
		
		
		private function initBackgroundContainer():void
		{
			mcBackgroundContainer	= new MovieClip();
			this.addChild(mcBackgroundContainer)
			
			
			this.addEventListener("IHBL", contentLoaded);
			this.addEventListener("IRFR", removeItem);
			this.addEventListener("IHFDT", itemFinishedDisplayTime);
			this.addEventListener("NaviChangedItem", naviChangeItem);
		}
		
		
		// CHANGING A SECTION
		public function changeSection(nNumber:uint):void
		{
			nSection	= nNumber;			
			nID			= 0;
			
			if (mcNavi)
			{
				mcNavi.kill();
				this.removeChild(mcNavi);	
				mcNavi	= null;
			}
			
			
			if (xml.section[nSection].navi[0] == "on")
				addNavi();
		
			changeBackgroundItem(xml.section[nSection].id[nID]);
			
			
		}
		private function addNavi():void
		{
			mcNavi	= new NavigationButtons(xml.navi[0], xml.section[nSection].id.length());
			this.addChild(mcNavi);			
		}
		private function naviChangeItem(e:CustomEvent):void
		{
			nID	= e.params.nNumber;	
			changeBackgroundItem(xml.section[nSection].id[nID]);	
		}
		
		
		
		
		
		
		
		
		// CHANGING A BACKGROUND ITEM
		public function changeBackgroundItem(nNumber:uint):void
		{
			if (mcCurrentBackground	&& bLoading)
			{
				ContentLoader.killAll();
				mcCurrentBackground.killItem();
				mcBackgroundContainer.removeChild(mcCurrentBackground);
			
				trace("SS")
			}
			else
			{
				mcPreviousBackground	= mcCurrentBackground;
			}

			mcCurrentBackground	= new BackgroundItem(xml.item[nNumber]);
			mcBackgroundContainer.addChild(mcCurrentBackground);
			bLoading	= true;
			
			
			
			if (xml.section[nSection].navi[0] == "on")
			{
				mcNavi.manageNavi(nID);
				mcNavi.dispatchEvent(new Event("LAOn"));
			}
		}
		private function contentLoaded(e:Event):void
		{	
			bLoading	= false;
			
			if (xml.section[nSection].navi[0] == "on")		
				mcNavi.dispatchEvent(new Event("LAOff"));
			
			
			if (mcPreviousBackground)
				mcPreviousBackground.hideItem();
		}		
        private function itemFinishedDisplayTime(e:Event):void
		{
			if (xml.section[nSection].id.length() > 1 && xml.section[nSection].autoplay[0] == "on" && !bLoading)
			{
				nID	= (nID + 1) % xml.section[nSection].id.length();
				changeBackgroundItem(xml.section[nSection].id[nID]);
			}
        }
		private function removeItem(e:Event):void
		{
			//mcBackgroundContainer.removeChild(mcPreviousBackground);
			mcBackgroundContainer.removeChildAt(0);
		}
	
	
	}
}