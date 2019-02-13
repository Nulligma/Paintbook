package ui.other 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import settings.CustomUI;
	import settings.System;
	/**
	 * ...
	 * @author Nulligma
	 */
	public class SideBarUI extends Sprite
	{
		private var _sW:int;
		private var _sH:int;
		
		private var _linkIndex:int;
		
		public function SideBarUI() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			_sW = System.stageWidth;
			_sH = System.stageHeight;
			
			var sp:Sprite;
			
			sp = new Sprite;
			sp.graphics.beginFill(0x222222,1); 
			sp.graphics.drawRect(0, 0, _sH * 0.083, _sH); sp.graphics.endFill();
			
			var myShadow:DropShadowFilter = new DropShadowFilter();
			myShadow.distance = 5;
			myShadow.color = 0x000000;
			myShadow.blurX = 5;
			myShadow.blurY = 5;
			myShadow.quality = 3;
			myShadow.angle = 180;
			sp.filters = [myShadow];
			addChild(sp);
			
			sp = new Game4xIcon;
			sp.scaleX = sp.scaleY = (_sH * 0.083 / 50);
			sp.x = _sH * 0.083/2;
			sp.y = _sH / 8;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {  _linkIndex = 0; } );
			sp.addEventListener(MouseEvent.MOUSE_UP, goToLink);
			
			sp = new RateAppIcon;
			sp.scaleX = sp.scaleY = (_sH * 0.083 / 50);
			sp.x = _sH * 0.083/2;
			sp.y = _sH / 8 + sp.height*1.5;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {  _linkIndex = 1; } );
			sp.addEventListener(MouseEvent.MOUSE_UP, goToLink);
			
			sp = new DonateIcon;
			sp.scaleX = sp.scaleY = (_sH * 0.083 / 50);
			sp.x = _sH * 0.083/2;
			sp.y = _sH / 2;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {  _linkIndex = 2; } );
			sp.addEventListener(MouseEvent.MOUSE_UP, goToLink);
			
			sp = new sideFbIcon;
			sp.scaleX = sp.scaleY = (_sH * 0.083 / 50);
			sp.x = _sH * 0.083/2;
			sp.y = _sH - _sH / 8 - sp.height*1.5;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {  _linkIndex = 3; } );
			sp.addEventListener(MouseEvent.MOUSE_UP, goToLink);
			
			
			sp = new sideTwitIcon;
			sp.scaleX = sp.scaleY = (_sH * 0.083 / 50);
			sp.x = _sH * 0.083/2;
			sp.y = _sH - _sH / 8;
			addChild(sp);
			sp.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {  _linkIndex = 4; } );
			sp.addEventListener(MouseEvent.MOUSE_UP, goToLink);
		}
		
		private function goToLink(e:MouseEvent):void
		{
			var url:String;
			var request:URLRequest;
			switch (_linkIndex) 
			{
				case 0:
					url = "http://www.nulligma.com/projects/4x/getMobile/";
					request= new URLRequest(url);
				break;
				case 1:
					url= "https://chrome.google.com/webstore/detail/gmcjlbdhigbboelbkbmiebbibemkonpm/reviews";
					request = new URLRequest(url);
				break;
				case 2:
					url= "https://www.paypal.com/cgi-bin/webscr";
					request = new URLRequest(url);
					var paypalVariable:URLVariables = new URLVariables();
					paypalVariable.cmd = "_s-xclick";
					paypalVariable.hosted_button_id = "G448KKGQB665C";
					request.data = paypalVariable;
				break;
				case 3:
					url = "https://www.facebook.com/Nulligma"
					request = new URLRequest(url);
				break;
				case 4:
					url = "https://twitter.com/nulligma"
					request = new URLRequest(url);
				break;
				default:
			}
			
			navigateToURL(request, "_blank");
		}
		
	}

}