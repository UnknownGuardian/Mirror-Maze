package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Gurin extends SpriteSheetAnimation
	{
		public var spriteSheet:SpriteSheetAnimation;
		private var directionFacing:uint = 0;
		public var isMoving:Boolean = false;
		public var delay:int = 0;
		
		public function Gurin() 
		{
			super(Content.hero, 32, 48, 16, true, false);
			getChildAt(0).x = -width - 4;
			getChildAt(0).y = -height;
		}
		
		public function setDirection(num:uint):void
		{
			if (directionFacing != num)
			{
				directionFacing = num;
				if (directionFacing == 0)//down
				{
					frameNumber = 0;
				}
				else if (directionFacing == 1)//left
				{
					frameNumber = 5;
				}
				else if (directionFacing == 2)//right
				{
					frameNumber = 9;
				}
				else if (directionFacing == 3)//up
				{
					frameNumber = 13;
				}
			}
		}
		
		public function getFacingRotation():Number
		{
			if (directionFacing == 0)//down
			{
				return 90;
			}
			else if (directionFacing == 1)//left
			{
				return 180;
			}
			else if (directionFacing == 2)//right
			{
				return 0;
			}
			else if (directionFacing == 3)//up
			{
				return 270;
			}
			return 0;
		}
		
		override public function animate(e:Event):void
		{
			if (!isMoving) return;
			if (delay != 2) { delay++; return; }
			delay = 0;
			drawTile(frameNumber);
			frameNumber++;
			if (directionFacing == 0)//down
			{
				if (frameNumber >= 4) frameNumber = 0;
			}
			else if (directionFacing == 1)//left
			{
				if (frameNumber >= 8) frameNumber = 5;
			}
			else if (directionFacing == 2)//right
			{
				if (frameNumber >= 12) frameNumber = 9;
			}
			else if (directionFacing == 3)//up
			{
				if (frameNumber >= 16) frameNumber = 13;
			}
		}
	}

}