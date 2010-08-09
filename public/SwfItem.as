package 
{
	import flash.display.*;	
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.utils.Timer;	

	import com.sQrt121.utils.ContentLoader;
	import com.sQrt121.utils.CustomEvent;
	
	
	public class  SwfItem extends MovieClip
	{
		// PUBLIC CONSTANTS
		
		
		// PRIVATE CONSTANTS		
		
		
		// PUBLIC VARS

					
		// PRIVATE VARS
		private var oItemData:Object;
		private var tTimer:Timer;
		
		public function SwfItem(oItemData:Object)
		{
			this.oItemData		= oItemData;			
			
			this.addEventListener("IMGL", loadedContent);
			ContentLoader.addJob("content", [oItemData.path[0]], this, "IMGL");
		}
		
		private function loadedContent(e:CustomEvent):void
		{					
			this.parent.nContentWidth		= e.params.aContent[0].width;
			this.parent.nContentHeight		= e.params.aContent[0].height;
			
			this.addChild(e.params.aContent[0]);
			this.dispatchEvent(new Event("IHBL", true));
			
			startTimer();
			
		}
		private function startTimer():void
		{			
			tTimer	= new Timer(int(oItemData.delay[0]) * 1000, 1);
			tTimer.addEventListener("timer", timerHandler);
			tTimer.start();			
		}		
        private function timerHandler(event:TimerEvent):void
		{
			this.dispatchEvent(new Event("IHFDT", true));
        }
		
		
		
		
		
		
		
		
		
		public function kill():void
		{
			try { tTimer.stop() }
			catch (e:Error) { }
			trace("killed");
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	}
}