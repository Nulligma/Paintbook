package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	import settings.CustomUI;
	import settings.MessagePrefrences;
	import settings.System;
	import ui.message.Warning;
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	import flash.events.Event;

	/**
	 * ...
	 * @author GrafixGames
	 */
	public class MainClass extends Sprite
	{
		private var dmsg:Warning;
		private var timer:Timer;
		
		public function MainClass() 
		{
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private  function onInvoke(event:InvokeEvent):void 
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
			
			//timer = new Timer(2000,1);
			//timer.addEventListener(TimerEvent.TIMER, start);
			//timer.start();
			
			init();
		}
		private function start(e:TimerEvent):void 
		{
			init();
		}
		private function init()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			
			System.stageHeight = stage.stageHeight;
			System.stageWidth = stage.stageWidth;
			
			System.isFullScreen = true;
			
			BackBoard.instance.loadAssets();
			
			addChild(BackBoard.instance);
			
			/*timer = new Timer(300000,0);
			timer.addEventListener(TimerEvent.TIMER, showDonateMsg);
			timer.start();*/
		}
		
		private function showDonateMsg(e:TimerEvent):void 
		{
			if (!dmsg && !MessagePrefrences.hideDonateWarning)
			{
				dmsg = new Warning(Warning.DONATE, removeDonationMsg, "Donate?", Warning.DONATE_MSG[int(Math.random()*Warning.DONATE_MSG.length)]);
				addChild(dmsg);
			}
		}
		
		private function removeDonationMsg():void
		{
			removeChild(dmsg);
			
			if (dmsg.status == 1)
			{
				//pay money
				
			}
			
			dmsg = null;
		}
	}

}