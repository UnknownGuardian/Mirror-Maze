package  
{
	import flash.events.Event;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Bullet extends SpriteSheetAnimation
	{
		public var spriteSheet:SpriteSheetAnimation;
		public var speed:int = 4;
		public function Bullet(isShadow:Boolean = true) 
		{
			super(Content.bulletMagicka, 80, 50, 60, true, true);
			getChildAt(0).x = -40;
			getChildAt(0).y = -25;
			
			if (isShadow)
				blendMode = 'subtract';
		}
		
		override public function animate(e:Event):void
		{
			trace(x, y);
			if (x > stage.stageWidth + 15 || x < -15 || y < -15 || y > 600)
			{
				destroy();
				return;
			}
			
			for (var q:int = 0 ; q < Platform.enemy.length; q++)
			{
				if (!Platform.enemy[q].isDisabled && hitTestObject(Platform.enemy[q]))
				{
					Platform.enemy[q].disable();
					//Platform.enemy[q] = Platform.enemy[Platform.enemy.length - 1];
					//Platform.enemy.length--;
					trace(Platform.enemy);
					destroy();
					return;
				}
			}
			if (rotation == 0)
			{
				x += speed;
			}
			else if (rotation == 90)
			{
				y += speed;
			}
			else if (rotation == 180)
			{
				x -= speed;
			}
			else if (rotation == -90)
			{
				y -= speed;
			}
			super.animate(e);
		}
		
	}

}