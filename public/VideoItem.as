package 
{
	import flash.display.*;	
	import flash.events.*;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.*;
	import flash.text.*;
	import flash.geom.*;
	//import fl.video.*;
	

	import com.sQrt121.utils.CustomEvent;
	
	
	public class  VideoItem extends MovieClip
	{
		// PUBLIC CONSTANTS
		
		
		// PRIVATE CONSTANTS		
		
		
		// PUBLIC VARS

					
		// PRIVATE VARS
		private var oItemData:Object;
		private var ncConnection:NetConnection;
		private var nsStream:NetStream;
		private var vVideo:Video;
		private var nStartCounter:int;
		private var nCounter:int;
		
		public function VideoItem(oItemData:Object)
		{
			this.oItemData		= oItemData;			
			
			initVideo();
		}
		
		
		
		private function initVideo():void
		{
		
			ncConnection = new NetConnection();
			ncConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ncConnection.connect(null);			
			
		}
		private function playVideo():void
		{
			nsStream.play(oItemData.path[0].toString());		
			trace(oItemData.path[0])
		}		
		private function resetVideo():void 
		{			
			//nsStream.pause();
			nsStream.seek(0);			
		}		
		public function onMetaData(info:Object):void 
		{		
			this.parent.nContentWidth	= info.width;
			this.parent.nContentHeight	= info.height;	
			
			vVideo.width				= info.width;
			vVideo.height				= info.height;	
			
			startPlaying();
		}		
		public function onXMPData(info:Object):void 
		{			
			
		}
				
		private function netStatusHandler(event:NetStatusEvent):void {
            switch (event.info.code) {
                case "NetConnection.Connect.Success":
                    connectStream();
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace("Unable to locate video: " + oItemData.path[0]);
                    break;
				case "NetStream.Play.Start":
					trace("start");
					startPlaying();
					break;				
				case "NetStream.Buffer.Full":
					trace("buffer");			
					//startPlaying();
					break;
					
				case "NetStream.Play.Stop":
					trace("STOP");			
					reachedEndOfVideo();
					break;
            }
        }
        private function connectStream():void 
		{	
			nsStream = new NetStream(ncConnection);
			nsStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			nsStream.client = this;
			nsStream.bufferTime = Number(oItemData.buffertime[0]);
			
			
			
			vVideo	= new Video();
			vVideo.attachNetStream(nsStream);			
			vVideo.smoothing = oItemData.smoothing[0];
			
			
			playVideo();
			
			
			var _sndTransform					= new SoundTransform(Number(oItemData.volume[0]));		
			nsStream.soundTransform				= _sndTransform;	
        }
		private function startPlaying():void
		{
			nStartCounter++;
			if (nStartCounter == 2)
			{
				this.addChild(vVideo);
				this.dispatchEvent(new Event("IHBL", true));
			}
		}
		private function reachedEndOfVideo():void
		{
			if (oItemData.loops[0] == 0)
			{
				resetVideo();
				//playVideo();
			}
			else
			{
				nCounter++
								
				if (nCounter == oItemData.loops[0])
				{
					this.dispatchEvent(new Event("IHFDT", true));
				}
				else
				{
					resetVideo();
				}
				
				
				resetVideo();
				//playVideo();
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		public function kill():void
		{
			nsStream.pause();
			nsStream		= null;
			ncConnection	= null;
			trace("killed");
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	}
}