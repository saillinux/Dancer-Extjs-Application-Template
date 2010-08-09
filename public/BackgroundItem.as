package 
{
	import flash.display.*;	
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	import flash.geom.*;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.TextShortcuts;
	
	import com.sQrt121.utils.ContentLoader;
	import com.sQrt121.utils.CustomEvent;
	
	
	public class  BackgroundItem extends MovieClip
	{
		// PUBLIC CONSTANTS
		
		
		// PRIVATE CONSTANTS		
		
		
		// PUBLIC VARS
		public var nContentWidth:uint;
		public var nContentHeight:uint;
					
		// PRIVATE VARS
		private var oItemData:Object;
		private var mcItem:MovieClip;
		private var mcEffect:MovieClip;
		private var nStageWidth:uint;
		private var nStageHeight:uint;
		private var nContentScaler;
		private var btPattern:Bitmap;
		private var nCounter:uint;
		
		public function BackgroundItem(oItemData:Object)
		{
			this.oItemData	= oItemData;
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
			
			nStageWidth			= stage.stageWidth;
			nStageHeight		= stage.stageHeight;	

			this.addEventListener("IHBL", contentLoaded);
			
			switch (oItemData.type[0].toString())
			{
				case "image":
					mcItem			= new ImageItem(oItemData);					
					break;
					
				case "swf":
					mcItem			= new SwfItem(oItemData);					
					break;
					
				case "video":
					mcItem			= new VideoItem(oItemData);						
					break;
			}	
			
			this.addChildAt(mcItem, 0);
			
			initEffect();
			initResize();	
		}	
		
		private function contentLoaded(e:Event):void
		{
			mcItem.alpha	= 0;

			resizeItem();
			positionItem();
			
			buildPattern();
			
			initResize();			
			
			showItem();
		}	
		
		private function initEffect():void
		{			
			mcEffect	=	new MovieClip();
			this.addChild(mcEffect);
			
			if (oItemData.effectpattern[0] != "none")
			{		
				this.addEventListener("PATTL", loadedPattern);
				ContentLoader.addJob("content", [oItemData.effectpattern[0]], this, "PATTL");		
			}			
		}
		private function loadedPattern(e:CustomEvent):void
		{
			btPattern	= e.params.aContent[0];	
			buildPattern();
		}
		
		private function buildPattern():void
		{	
			nCounter++;
			
			if (nCounter == 2)
			{
				//var _nColoms:uint		= Math.ceil(3000 / btPattern.width);
				//var _nRows:uint			= Math.ceil(1600 / btPattern.height);

				mcEffect.alpha			= Number(oItemData.effectalpha[0]);
				
				mcEffect.graphics.beginBitmapFill(btPattern.bitmapData, null, true);
				mcEffect.graphics.drawRect(0, 0, 3000, 2000);
				mcEffect.graphics.endFill();
				
				//addChild(mySprite);
				/*	
				for (var i:uint = 0; i < _nRows;i++)
				{
					for (var j:uint = 0; j < _nColoms;j++)
					{	
						var _btPattern:Bitmap 	= new Bitmap(btPattern.bitmapData.clone());           			
						_btPattern.x			= btPattern.width * j;
						_btPattern.y			= btPattern.height * i;
						mcEffect.addChild(_btPattern);	
						
					}
				}*/
			}
		}
		private function resizeItem():void
		{
			switch (oItemData.resize[0].toString())
			{
				case "scale":		
					nContentScaler		= Math.max(nStageWidth / nContentWidth, nStageHeight / nContentHeight);
					mcItem.width		= Math.round(nContentWidth * nContentScaler);
					mcItem.height		= Math.round(nContentHeight * nContentScaler);				
					break;	
				
				case "strech":
					mcItem.width		= nStageWidth;
					mcItem.height		= nStageHeight;
					break;
					
				case "fit":	
					nContentScaler		= Math.min(nStageWidth / nContentWidth, nStageHeight / nContentHeight);
					mcItem.width		= Math.round(nContentWidth * nContentScaler);
					mcItem.height		= Math.round(nContentHeight * nContentScaler);		
					break;
					
				case "none":					
					break;
				
			}
		}
		private function positionItem():void
		{
			
			switch (oItemData.verticalalign[0].toString())
			{
				case "top":				
					mcItem.y	= 0;				
				break
				case "center":
					mcItem.y	= Math.round((nStageHeight - mcItem.height) / 2);
				break
				case "bottom":
					mcItem.y	= nStageHeight - mcItem.height;
				break
			}
			switch (oItemData.horizontalalign[0].toString())
			{
				case "left":
					mcItem.x	= 0;
					break;
				case "center":				
					mcItem.x	= Math.round((nStageWidth - mcItem.width) / 2);				
					break;
				case "right":
					mcItem.x	= nStageWidth - mcItem.width;	
					break;
			}
	
		}
		private function showItem():void
		{		
			Tweener.addTween(mcItem, { alpha:oItemData.alpha[0], time:1, transition:"easeoutexpo" } );
		}
		public function hideItem():void
		{
			Tweener.removeTweens(this)
			//trace(Tweener.removeTweens(mcItem,"alpha"))
			//Tweener.addTween(mcItem, { alpha:0, time:1, transition:"easeoutexpo", onComplete:function() { trace(this.parent); this.parent.killItem(); this.parent.removeItem(); }} );
			Tweener.addTween(this, { alpha:0, time:1, transition:"easeoutexpo", onComplete:this.removeItem} );
			//Tweener.addCaller(this, {onUpdate:this.killItem, time:1, count:1});
			
			killItem();
		}
		public function killItem():void
		{
			//Tweener.removeTweens(mcItem);
			mcItem.kill();
			stage.removeEventListener (Event.RESIZE, mainResizeHandler);	
			//removeItem();
		}
		public function removeItem():void
		{
			this.dispatchEvent(new Event("IRFR", true));
		}
		
		
		
		
		// RESIZE		
		private function initResize():void
		{
			stage.addEventListener (Event.RESIZE, mainResizeHandler);
		}
		private function mainResizeHandler(e:Event):void
		{
			nStageWidth			= stage.stageWidth;
			nStageHeight		= stage.stageHeight;			
			
			resizeItem();
			positionItem();
		}	
		
		
		
		
		
		
		
		
		
		
		
	
	}
}