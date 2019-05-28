package layers.setups
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import tools.ToolManager;
	
	/**
	 * ...
	 * @author GrafixGames
	 */
	public class LayerList 
	{
		static private var _instance:LayerList;
		
		private var head:Object = null;
		private var tail:Object = null;
		
		private var front:Object;
		private var back:Object;
		private var selected:Object;
		
		private var id:uint = 1;
		
		public function LayerList()
		{
			
		}
		
		public function initNewLayer(width:Number,height:Number,copy:Boolean = false,bitData:BitmapData = null):void 
		{
			var layerObject:Object = new Object;
			
			layerObject.bitmap = new Bitmap(new BitmapData(width, height, true, 0x000000));
			
			if(copy)
				layerObject.bitmap.bitmapData = bitData.clone();
			
			layerObject.back = head;
			layerObject.front = null;
			
			layerObject.name = "Layer #" + id;
			layerObject.id = id;
			id++;
			
			layerObject.color = uint(Math.random() * 0xffffff);
			layerObject.bitmap.blendMode = "normal";
			layerObject.tintColor = 0x000000;
			layerObject.tintAlpha = 0;
			
			if (tail == null)
			{
				tail = layerObject;
			}
			
			if (head != null)
				head.front = layerObject;
			
			head = layerObject;
			
			selected = layerObject;
			
			if (ToolManager.initialized)
				ToolManager.workArea(ToolManager.workingCanvas, selected.bitmap.bitmapData);
		}
		
		public function pick(layerObject:Object):void
		{
			//Search layerObject with the help of its id
			
			selected = layerObject;
			
			var backOfS:Object = selected.back;
			if (backOfS == null)
				tail = selected.front;
			else
				backOfS.front = selected.front;
			
			var frontOfS:Object = selected.front;
			if (frontOfS == null)
				head = selected.back;
			else
				frontOfS.back = selected.back;
			
			front = selected.front;
			back = selected.back;
		}
		
		public function move(pos:String):void
		{
			if (pos == "up")
			{
				back = front;
				front = front.front;
			}
			else if (pos == "down")
			{
				front = back;
				back = back.back;
			}
		}
		
		public function drop():void
		{
			selected.front = front;
			selected.back = back;
			
			if (front == null)
				head = selected;
			else
				front.back = selected;
			
			if (back == null)
				tail = selected;
			else
				back.front = selected;
		}
		
		public function deleteLayer(layerObject:Object, merge:Boolean = false):void
		{
			if (layerObject.front == null && layerObject.back == null)
			{
				return;
			}
			
			if (layerObject.back == null)
			{
				if (merge) return;
				
				tail = layerObject.front;
				tail.back = null;
				selected = tail;
			}
			else
			{
				var backOfLO:Object = layerObject.back;
				backOfLO.front = layerObject.front;
				selected = layerObject.back;
				
				if(merge) backOfLO.bitmap.bitmapData.draw(layerObject.bitmap.bitmapData);
			}
			
			if (layerObject.front == null)
			{
				head = layerObject.back;
				head.front = null;
				selected = head;
			}
			else
			{
				var frontOfLO:Object = layerObject.front;
				frontOfLO.back = layerObject.back;
			}
			
			layerObject.bitmap.bitmapData.dispose();
			layerObject.front = null;
			layerObject.back = null;
			layerObject = null;
		}
		
		public function get currentLayer():BitmapData
		{
			return selected.bitmap.bitmapData;
		}
		
		public function headObject():Object
		{
			return head;
		}
		
		public function tailObject():Object
		{
			return tail;
		}
		
		public function getLayerByName(name:String):Object
		{
			var layerObject:Object = this.tailObject();
			while (layerObject != null)
			{
				if (layerObject.name == name)
				{
					return layerObject;
				}
				layerObject = layerObject.front;
			}
			
			return layerObject
		}
		
		public function getLength():int
		{
			var length:int = 0;
			var layerObject:Object = this.tailObject();
			while (layerObject != null)
			{
				length++;
				layerObject = layerObject.front;
			}
			return length;
		}
		
		public function set currentLayerObject(s:Object):void
		{
			selected = s;
			ToolManager.workArea(ToolManager.workingCanvas, selected.bitmap.bitmapData);
		}
		
		public function get currentLayerObject():Object
		{
			return selected;
		}
		
		static public function get instance():LayerList 
		{
			if (!_instance)
				_instance = new LayerList();
			
			return _instance;
		}
		
		static public function loadWith(inst:LayerList):void
		{
			_instance = inst;
		}
		
	}
}