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
	
	import com.sQrt121.utils.CustomEvent;
	
	
		
	public class  NavigationButtons extends MovieClip
	{
		// PUBLIC CONSTANTS
		
		
		// PRIVATE CONSTANTS		
		
		
		// PUBLIC VARS

					
		// PRIVATE VARS
		private var oNaviData:Object;
		private var nItems:uint;
		private var mcNavi:MovieClip;
		private var mcCurrentItem:MovieClip;
		private var nStageWidth:uint;
		private var nStageHeight:uint;		
				
		public function NavigationButtons(oNaviData:Object, nItems:uint)
		{
			this.oNaviData		= oNaviData;			
			this.nItems			= nItems;	
			
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

			addNavi();
			initResize();
		}
		private function addNavi():void
		{
			mcNavi	= new MovieClip();
			this.addChild(mcNavi);
			
			this.addEventListener("LAOn", startLoadingAnimation);
			this.addEventListener("LAOff", stopLoadingAnimation);
			
			
			addNaviButtons();
			positionNaviButtons();
			positionNavi();
			showNaviButtons();
		}
		private function addNaviButtons():void
		{
			for (var i:uint	= 0; i < nItems; i++)
			{
				var _mcItem:MovieClip	= new mc_Button();
				
				
				Tweener.addTween(_mcItem, 	{ _color: oNaviData.color[0]} );
				//Tweener.addTween(_mcItem.mcBottom,	{ _color: oNaviData.color[1]} );
				
				_mcItem.alpha			= 0;
				//_mcItem.mcBottom.alpha	= 0;
				
				_mcItem.nNumber			= i;
				_mcItem.bLoading		= false;
				_mcItem.buttonMode		= true;
				
				mcNavi.addChild(_mcItem);								
				
				_mcItem.addEventListener(MouseEvent.CLICK, clickButton);
				_mcItem.addEventListener(MouseEvent.MOUSE_OVER, overButton);
				_mcItem.addEventListener(MouseEvent.MOUSE_OUT, outButton);				
			}
		}
		private function clickButton(e:MouseEvent):void
		{
			if (mcCurrentItem != e.currentTarget)
			{
				var ceEvent	= new CustomEvent("NaviChangedItem", {nNumber:e.currentTarget.nNumber});
				this.dispatchEvent(ceEvent);	
			}
		}
		private function overButton(e:MouseEvent):void
		{	
			if (e.currentTarget != mcCurrentItem)
				selectItem(e.currentTarget);			
		}
		private function outButton(e:MouseEvent):void
		{		
			if (e.currentTarget != mcCurrentItem)
				deselectItem(e.currentTarget);			
		}
		private function selectItem(mc):void
		{					
			Tweener.addTween(mc,		{ _color:oNaviData.color[1], time:1, transition:"easeoutexpo" } );				
			//Tweener.addTween(mc.mcBottom,	{ alpha:1, time:1, transition:"easeoutexpo" } );			
		}
		private function deselectItem(mc):void
		{	
			Tweener.addTween(mc,		{ _color:oNaviData.color[0], time:1, transition:"easeoutexpo" } );					
			//Tweener.addTween(mc.mcBottom,	{ alpha:0, time:1, transition:"easeoutexpo" } );		
		}
		private function positionNaviButtons():void
		{	
			var _x:uint;
			for (var i:uint = 0; i < nItems; i++)
			{
				var _mcItem:MovieClip	= mcNavi.getChildAt(i) as MovieClip;			
				_mcItem.x				= _x;			
				_mcItem.y				= 0;	
				
				_x						+= _mcItem.width + int(oNaviData.spacer[0]);
			}
		}
		private function showNaviButtons():void
		{				
			for (var i:uint = 0; i < nItems; i++)
			{
				var _mcItem:MovieClip	= mcNavi.getChildAt(i) as MovieClip;
				Tweener.addTween(_mcItem, { alpha:1, time:1, delay: i/15, transition:"easeoutexpo" } );		
			}
		}
		private function positionNavi():void
		{
			mcNavi.x	= nStageWidth	- mcNavi.width  + int(oNaviData.x[0]);
			mcNavi.y	= int(oNaviData.y[0]);
		}
		private function startLoadingAnimation(e:Event):void
		{
			mcCurrentItem.bLoading	= true;
			loadingAnimation(mcCurrentItem, 0,"easeinexpo");
		}
		private function stopLoadingAnimation(e:Event):void
		{
			mcCurrentItem.bLoading	= false;			
		}
		private function loadingAnimation(mc, nNumber, sTransition):void
		{
			
			Tweener.addTween(mc,	
			{ 
				alpha:nNumber,
				time:.3,
				transition:sTransition,
				onComplete:function()
				{
					if (nNumber == 0)
					{
						loadingAnimation(mc, 1,"easeoutexpo");
					}
					else if (mc.bLoading)
					{
						loadingAnimation(mc, 0,"easeinexpo")
					}
				}
			} );
		
		}
		
		
		
		
		// MANAGE NAVI
		public function manageNavi(nNumber:uint):void
		{
			if (mcCurrentItem)
			{
				mcCurrentItem.bLoading	= false;
				deselectItem(mcCurrentItem);
			}
			
			
			mcCurrentItem			= mcNavi.getChildAt(nNumber) as MovieClip;
			
			selectItem(mcCurrentItem);
		}
		
		
		public function kill():void
		{
			stage.removeEventListener (Event.RESIZE, mainResizeHandler);
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
			
			positionNavi();
			
		}	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	}
}