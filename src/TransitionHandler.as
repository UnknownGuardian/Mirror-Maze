package  
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class TransitionHandler
	{
		public static var speed:Number = 20;
		public static var p1:Point = new Point(320,240);
		public static var p2:Point = new Point(320,240);
		public static var p3:Point = new Point(320,240);
		public static var p4:Point = new Point(320, 240);
		private static var _callback:Function;
		private static var isForward:Boolean = true;
		private static var isActive:Boolean = false;
		public function TransitionHandler() 
		{
			
		}
		
		public static function startDiamondTween(s:DisplayObject, callback:Function, forward:Boolean = true):void
		{
			if (isActive) throw new Error("Diamond Tween Already is Playing");
			speed = 20;
			if (forward)
			{
				p1 = new Point(320,240);
				p2 = new Point(320,240);
				p3 = new Point(320,240);
				p4 = new Point(320, 240);
			}
			else 
			{
				if (s.width > s.height)
				{
					p1 = new Point(320 + s.width,240);
					p2 = new Point(320 - s.width,240);
					p3 = new Point(320,240 + s.width);
					p4 = new Point(320, 240 - s.width);
				}
				else
				{
					p1 = new Point(320 + s.height,240);
					p2 = new Point(320 - s.height,240);
					p3 = new Point(320,240 + s.height);
					p4 = new Point(320, 240 - s.height);
				}
			}
			_callback = callback;
			isForward = forward;
			
			var m:Sprite = new Sprite();
			s.mask = m;
			s.addEventListener(Event.ENTER_FRAME, tweenDiamondMask);
			s.parent.addChild(m);
			s.cacheAsBitmap = true;
			m.cacheAsBitmap = true;
			m.filters = [new GlowFilter(0x000000, 1, 64, 64, 3)]
			isActive = true;
		}
		
		static private function tweenDiamondMask(e:Event):void 
		{
			var m:Sprite = e.currentTarget.mask;
			if(m.width < e.currentTarget.width*1.3 && isForward)
			{
				p1.x += speed;
				p2.x -= speed;
				p3.y += speed;
				p4.y -= speed;		
				speed++;
				
				m.graphics.clear();
				m.graphics.beginFill(0x000000, 1);
				m.graphics.moveTo(p1.x, p1.y);
				m.graphics.lineTo(p3.x, p3.y);
				m.graphics.lineTo(p2.x, p2.y);
				m.graphics.lineTo(p4.x, p4.y);
				m.graphics.lineTo(p1.x, p1.y);
				m.graphics.endFill();
			}
			else if ((Math.abs(m.width) >= speed || m.width == 0)&& !isForward) //speed != 20 to prevent immediate trigger
			{
				p1.x -= speed;
				p2.x += speed;
				p3.y -= speed;
				p4.y += speed;		
				speed++;
				m.graphics.clear();
				m.graphics.beginFill(0x000000, 1);
				m.graphics.moveTo(p1.x, p1.y);
				m.graphics.lineTo(p3.x, p3.y);
				m.graphics.lineTo(p2.x, p2.y);
				m.graphics.lineTo(p4.x, p4.y);
				m.graphics.lineTo(p1.x, p1.y);
				m.graphics.endFill();
			}
			else
			{
				isActive = false;
				e.currentTarget.removeEventListener(Event.ENTER_FRAME, tweenDiamondMask);
				e.currentTarget.parent.removeChild(e.currentTarget.mask);
				e.currentTarget.mask = null;
				if (_callback != null)
				{
					_callback(e.currentTarget);
					_callback = null;
				}
			}
		}
		
	}

}