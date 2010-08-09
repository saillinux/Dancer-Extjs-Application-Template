package com.sQrt121.utils
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.display.LoaderInfo;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import com.sQrt121.utils.CustomEvent;
	
	/**
	 * ...
	 * @author sQrt121
	 */
	public class CustomLoader extends EventDispatcher 
	{
		// PUBLIC CONSTANTS
		
		
		// PRIVATE CONSTANTS		
		
		
		// PUBLIC VARS
		public var content:*;
		
					
		// PRIVATE VARS			
		private var lLoader:*;
		private var urlReq:URLRequest;	
		private var nInstantProgress:uint;
		private var nTotalProgress:uint;
		private var bTotal:Boolean;	
		private var ceEvent:CustomEvent;
		private var aSource:String;
		private var sType:String;
		
		
		public function CustomLoader(aSource:String, sType:String)
		{	
			this.nInstantProgress	= 0;
			this.nTotalProgress		= 0;
			this.bTotal				= true;		
			this.aSource			= aSource;
			this.sType				= sType;
			
			
			configureLoader();
			
		}
		private function configureLoader():void
		{
			switch (sType) 
			{
				case "xml":
					lLoader			= new URLLoader();
					urlReq			= new URLRequest(aSource);
					lLoader.addEventListener(Event.COMPLETE, contentLoaded);
					lLoader.addEventListener(ProgressEvent.PROGRESS, loadProgress);
					break;
				case "content":
					lLoader			= new Loader();
					urlReq			= new URLRequest(aSource);
					lLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, contentLoaded);
					lLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
					break;				
			}
						
			lLoader.load(urlReq);	
			
		}
		private function loadProgress(e:ProgressEvent):void
		{
			if (bTotal)
			{
				bTotal	= false;
				ceEvent	= new CustomEvent("ItemSize", {nTotal:e.bytesTotal});
				this.dispatchEvent(ceEvent);	
			}
		
			nInstantProgress	= e.bytesLoaded - nTotalProgress;
			nTotalProgress		= e.bytesLoaded;
			
			ceEvent	= new CustomEvent("InstantProgress", {nInstant:nInstantProgress});
			this.dispatchEvent(ceEvent);	
		}	
		private function contentLoaded(e:Event):void
		{
					
			switch (sType) 
			{
				case "xml":					
					content = new XML(e.target.data);						
					break;
				case "content":					
					content	= e.currentTarget.content;		
					break;				
			}
				
			this.dispatchEvent(new Event("ItemLoaded"));			
		}
		public function killLoader():void
		{
			try { lLoader.close() }
			catch (e:Error) { }
			
			switch (sType) 
			{
				case "xml":					
					lLoader.removeEventListener(Event.COMPLETE, contentLoaded);
					lLoader.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
					break;
				case "content":					
					lLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, contentLoaded);
					lLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
					break;				
			}
			
			lLoader	= null;
		}
		
	}
	
}