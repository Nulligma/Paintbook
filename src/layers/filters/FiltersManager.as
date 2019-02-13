package layers.filters
{
	import flash.display.DisplayObject;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Singleton class
	 * @author Thomas John (thomas.john@open-design.be) www.open-design.be
	 */
	public class FiltersManager
	{
		// our unique instance of this class 
		private static var instance:FiltersManager = new FiltersManager();
		private var dFilters:Dictionary = new Dictionary(false);
		
		private var filterArray:Array;
		private var testFilter:*;
		
		/**
		 * Constructor : check if an instance already exists and if it does throw an error
		 */
		public function FiltersManager()
		{
			if (instance)
				throw new Error("FiltersManager can only be accessed through FiltersManager.getInstance()");
			// init 
			
			filterArray = new Array;
			
			filterArray[0] = new Object;
			filterArray[0].number = 0;
			
			filterArray[1] = new Object;
			filterArray[1].number = 1;
			
			filterArray[2] = new Object;
			filterArray[2].number = 2;
			
			filterArray[3] = new Object;
			filterArray[3].number = 3;
			
			filterArray[4] = new Object;
			filterArray[4].number = 4;
			
			filterArray[5] = new Object;
			filterArray[5].number = 5;
		}
		
		/**
		 * Get unique instance of this singleton class
		 * @return <filtersManager> Instance of this class
		 */
		public static function getInstance():FiltersManager
		{
			return instance;
		}
		
		public function add(target:DisplayObject, filter:BitmapFilter):void
		{
			var tmp:Array = dFilters[target] as Array;
			if (tmp == null)
			{
				tmp = dFilters[target] = target.filters;
			}
			
			tmp.push(filter);
			target.filters = tmp;
		}
		
		public function remove(target:DisplayObject, filter:BitmapFilter, findByNormal:Boolean = false):void
		{
			var tmp:Array = dFilters[target] as Array;
			if (tmp == null)
				tmp = dFilters[target] = target.filters;
			
			var index:int
			if(!findByNormal)
				index = splIndexOf(tmp, filter);
			else
				index = indexOf(tmp, filter);
			
			
			if (index < 0)
				return;
			tmp.splice(index, 1);
			target.filters = tmp;
			
		}
		
		public function splIndexOf(filters:Array, filter:*):int
		{
			var index:int = filters.length;
			var f:*;
			
			var filterClass:Class = Class(getDefinitionByName(getQualifiedClassName(filter)));
			var baseClass:Class;
			while (index--)
			{
				f = filters[index];
				baseClass = Class(getDefinitionByName(getQualifiedClassName(filters[index])));
				
				if (baseClass == GlowFilter && filterClass == GlowFilter)
				{
					if (f.inner && filter.inner)
						return index;
					else if (!f.inner && !filter.inner)
						return index;
				}
				else if (baseClass == DropShadowFilter && filterClass == DropShadowFilter)
				{
					if (f.inner && filter.inner)
						return index;
					else if (!f.inner && !filter.inner)
						return index;
				}
				else if (baseClass == BevelFilter && filterClass == BevelFilter)
				{
					return index;
				}
				else if (baseClass == BlurFilter && filterClass == BlurFilter)
				{
					return index;
				}
			}
			return -1;
		}
		
		public function indexOf(filters:Array, filter:BitmapFilter):int
		{
			var index:int = filters.length;
			var f:BitmapFilter;
			while (index--)
			{
				f = filters[index];
				if (f == filter)
				{
					return index;
				}
			}
			return -1;
		}
		
		public function getfilterObject(index:int):Object
		{
			return filterArray[index] as Object;
		}
		
		public function updateDictOf(object:DisplayObject):void
		{
			dFilters[object] = object.filters;
		}
		
		public function updateFiltersFor(object:DisplayObject):void
		{
			filterArray[0].applied = false; filterArray[0].filter = null;
			filterArray[1].applied = false;	filterArray[1].filter = null;
			filterArray[2].applied = false;	filterArray[2].filter = null;
			filterArray[3].applied = false;	filterArray[3].filter = null;
			filterArray[4].applied = false;	filterArray[4].filter = null;
			filterArray[5].applied = false;
			
			var arr:Array = object.filters;
			var clss:Class;
			
			for (var i:int = 0; i < arr.length; i++)
			{
				clss = Class(getDefinitionByName(getQualifiedClassName(arr[i])));
				
				if (clss == GlowFilter)
				{
					if (arr[i].inner)
					{
						filterArray[0].filter = arr[i] as GlowFilter;
						filterArray[0].applied = true;
					}
					else
					{
						filterArray[1].filter = arr[i] as GlowFilter;
						filterArray[1].applied = true;
					}
				}
				else if (clss == DropShadowFilter)
				{
					if (arr[i].inner)
					{
						filterArray[2].filter = arr[i];
						filterArray[2].applied = true;
					}
					else
					{
						filterArray[3].filter = arr[i];
						filterArray[3].applied = true;
					}
				}
				else if (clss == BevelFilter)
				{
					filterArray[4].filter = arr[i];
					filterArray[4].applied = true;
				}
			}
			
			if (!filterArray[0].filter) { filterArray[0].filter = new GlowFilter; filterArray[0].filter.inner = true; testFilter = filterArray[0].filter}
			if (!filterArray[1].filter) { filterArray[1].filter = new GlowFilter; filterArray[1].filter.inner = false; }
			if (!filterArray[2].filter) { filterArray[2].filter = new DropShadowFilter; filterArray[2].filter.inner = true; }
			if (!filterArray[3].filter) { filterArray[3].filter = new DropShadowFilter; filterArray[3].filter.inner = false; }
			if (!filterArray[4].filter) { filterArray[4].filter = new BevelFilter; }
			
			if (1 - object.transform.colorTransform.redMultiplier != 0)
				filterArray[5].applied = true;
			
			/*
			filterArray[5].tint = object.transform.colorTransform;
			
			var c:uint = object.transform.colorTransform.color;

			var red:uint = (c>>16)&0xFF;
			var green:uint = (c>>8)&0xFF;
			var blue:uint = c&0xFF;
			
			var mul:Number = 1-object.transform.colorTransform.redMultiplier;
			mul==0?1:mul;

			red = red/mul;
			blue = blue/mul;
			green = green/mul;

			red = red>255?255:red;
			green = green>255?255:green;
			blue = blue>255?255:blue;

			filterArray[5].tintColor = red<<16|green<<8|blue;
			*/
			
		}
		
	}

}