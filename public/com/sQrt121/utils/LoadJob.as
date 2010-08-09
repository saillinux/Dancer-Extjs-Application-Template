package com.sQrt121.utils
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.sQrt121.utils.CustomLoader;
	import com.sQrt121.utils.CustomEvent;
	
	/**
	 * ...
	 * @author sQrt121
	 */
	public class LoadJob extends EventDispatcher
	{
		// PUBLIC CONSTANTS
		
		
		// PRIVATE CONSTANTS		
		
		
		// PUBLIC VARS
		public var mcTarget:MovieClip;
		public var mcPreloader:MovieClip;
		public var aLoaders:Array;
		public var nNumber:uint;
		public var bCancelable:Boolean;
					
		// PRIVATE VARS			
		private var sType:String;
		private var aSources:Array;
		private var aLoadedContent:Array;
		private var nJobTotalSize:uint;
		private var nJobTotalProgress:uint;
		private var nItemFinishedCount:uint;
		private var ceEvent:CustomEvent;		
		private var sCompleteEvent:String;		
		private var sProgressEvent:String;
		
		
		
		public function LoadJob(sType:String, aSources:Array, mcTarget:MovieClip, sCompleteEvent:String, mcPreloader:MovieClip, sProgressEvent:String):void
		{
			this.nJobTotalSize		= 0;
			this.nJobTotalProgress	= 0;
			this.nItemFinishedCount	= 0;
			this.aLoaders			= [];
			this.sType				= sType;
			this.aSources			= aSources;
			this.aLoadedContent		= [];
			this.mcTarget			= mcTarget;
			this.sCompleteEvent		= sCompleteEvent;
			this.bCancelable		= bCancelable;
			this.mcPreloader		= mcPreloader;
			this.sProgressEvent		= sProgressEvent;
			
			initJob();
		}	
		private function initJob():void
		{
			for (var i : int = 0; i < aSources.length; i ++)
			{				
				aLoaders [i] = new CustomLoader (aSources[i], sType);
				aLoaders [i].addEventListener("ItemSize", computeSize);
				if (sProgressEvent != "NONE")
					aLoaders [i].addEventListener("InstantProgress", computeProgress);
				aLoaders [i].addEventListener("ItemLoaded", itemLoaded);
			}			
		}
		private function computeSize(e:CustomEvent):void
		{
			nJobTotalSize	+= e.params.nTotal;
		}
		private function computeProgress(e:CustomEvent):void
		{
			nJobTotalProgress += e.params.nInstant;
			trace(nJobTotalProgress / nJobTotalSize);
			
			ceEvent	= new CustomEvent(sProgressEvent, {nLoaded:nJobTotalProgress, nTotal:nJobTotalSize});
			mcPreloader.dispatchEvent(ceEvent);
		}
		private function itemLoaded(e:Event):void
		{
			nItemFinishedCount++;	
			
			if (nItemFinishedCount == aSources.length)
			{
				for (var i : int = 0; i < aSources.length; i ++)
				{
					aLoadedContent[i]	= aLoaders [i].content;
				}
				
				ceEvent	= new CustomEvent(sCompleteEvent, {aContent:aLoadedContent});
				mcTarget.dispatchEvent(ceEvent);
				
				ceEvent	= new CustomEvent("LJF", {nJobNumber:nNumber});
				this.dispatchEvent(ceEvent);
			}
			
		}		
		
	}
	
}