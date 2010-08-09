package com.sQrt121.utils
{
	import com.sQrt121.utils.LoadJob;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import com.sQrt121.utils.CustomEvent;
	import com.sQrt121.utils.LoadJob;
	/**
	 * ...
	 * @author sQrt121
	 */
	public class ContentLoader
	{
		// PUBLIC CONSTANTS
		
		
		// PRIVATE CONSTANTS		
		
		
		// PUBLIC VARS
		
					
		// PRIVATE VARS	
		private static var oJobs:Object;
		private static var nJobNumber:uint;
		
		
		
		public function ContentLoader()
		{
			
		}		
		public static function addJob(sType:String, aSources:Array, mcTarget:MovieClip, sCompleteEvent:String, bCancelable:Boolean = true, mcPreloader = null, sProgressEvent:String	= "NONE"):void
		{
			if (oJobs == null)
			{
				oJobs			= { };
				oJobs.job		= [];	
				nJobNumber		= 0;				
			}		
			
			oJobs.job[nJobNumber]				= new LoadJob(sType, aSources, mcTarget, sCompleteEvent, mcPreloader, sProgressEvent);
			oJobs.job[nJobNumber].bCancelable	= bCancelable;
			oJobs.job[nJobNumber].nNumber		= nJobNumber;
			oJobs.job[nJobNumber].addEventListener("LJF", kill);
			
			nJobNumber++;
		}		
		public static function killAll():void
		{
			for (var i : int = 0; i < oJobs.job.length; i ++)
			{
				if (oJobs.job[i] != null)
				{
					if (oJobs.job[i].bCancelable)
					{						
						killThis(i);
					}
				}
			}
		}
		private static function kill(e:CustomEvent):void
		{
			killThis(e.params.nJobNumber);
		}
		public static function killThis(nNumber):void
		{		
			for (var i : int = 0; i < oJobs.job[nNumber].aLoaders.length; i ++)
			{		
				oJobs.job[nNumber].aLoaders [i].killLoader();	
				oJobs.job[nNumber].aLoaders [i]	= null;	
			}	
			oJobs.job[nNumber].removeEventListener("LJF", kill);
			oJobs.job[nNumber].mcTarget		= null;	
			oJobs.job[nNumber].mcPreloader	= null;				
			oJobs.job[nNumber]				= null;	
			
		}		
	}
	
}