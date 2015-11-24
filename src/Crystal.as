package  
{
	import flash.display.Sprite;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Crystal extends SpriteSheetAnimation
	{
		private var distanceToTrigger:int = 20;
		
		public function Crystal() 
		{
			super(Content.crystal, 50, 50, 40, true, false);
			getChildAt(0).x = -width / 2;
			getChildAt(0).y = -height / 2;
		}
		
		public function bothOnCrystal(g:Gurin, m:Malon):Boolean
		{
			return  g.hitTestObject(m) && g.hitTestObject(this) && hitTestObject(m);// < distanceToTrigger//(hit(g, m) && hit(m, this) && hit(g, this));
		}
		
		public function hit(obj:Sprite, other:Sprite):Boolean
		{
			trace(Math.abs(obj.x - other.x),  Math.abs(obj.y - other.y));
			return (Math.abs(obj.x - other.x) < distanceToTrigger && Math.abs(obj.y - other.y) < distanceToTrigger);
		}
		
	}

}