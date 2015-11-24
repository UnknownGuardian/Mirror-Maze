package  
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Head extends SpriteSheetAnimation
	{
		public var spriteSheet:SpriteSheetAnimation;
		private var directionFacing:uint = 0;
		public var xPos:int = 0;
		public var yPos:int = 0;
		public var speed:int = 2;
		
		public var left_foot_x:int;
		public var right_foot_x:int;
		public var foot_y:int;
		public var bottom:int;
		public var top:int;
		public var left_foot:int;
		public var right_foot:int;
		public var left:int;
		public var right:int;
		public var up:int;
		public var down:int;
		
		public var isDisabled:Boolean = false;
		
		public function Head() 
		{
			super(Content.enemyHead, 65, 65, 4, false, false);
			getChildAt(0).x = -width/2 - 20;
			getChildAt(0).y = -height / 2 - 18;
			//blendMode = 'overlay';
		}
		public function getFuturePoint():void
		{
			if (directionFacing == 0)//down
			{
				xPos = x;
				yPos = y + speed;
			}
			else if (directionFacing == 1)//left
			{
				xPos = x - speed;
				yPos = y;
			}
			else if (directionFacing == 2)//right
			{
				xPos = x + speed;
				yPos = y;
			}
			else if (directionFacing == 3)//up
			{
				xPos = x;
				yPos = y - speed;
			}
		}
		
		public function move():void
		{
			if (isDisabled)
			{
				alpha += 0.005;
				filters = [new GlowFilter(0x000000, 1,  60 - alpha * 60, 60 - alpha * 60)];
				if (alpha > 0.99) { isDisabled = false; filters = []; }
				return;
			}
			//trace(directionFacing, down, left, right, up);
			if (directionFacing == 0)//down
			{
				if (down!= 0)
				{
					setDirection(3);
					y -= speed;
				}
				else
					y = yPos;
			}
			else if (directionFacing == 1)//left
			{
				if (left != 0)
				{
					setDirection(2);
					x -= speed;
				}
				else
					x = xPos;
			}
			else if (directionFacing == 2)//right
			{
				if (right != 0)
				{
					setDirection(1);
					x += speed;
				}
				else
					x = xPos;
			}
			else if (directionFacing == 3)//up
			{
				if (up != 0)
				{
					setDirection(0);
					y += speed;
				}
				else
					y = yPos;
			}
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
					frameNumber = 1;
				}
				else if (directionFacing == 2)//right
				{
					frameNumber = 2;
				}
				else if (directionFacing == 3)//up
				{
					frameNumber = 3;
				}
			}
			drawTile(frameNumber);
		}
		
		override public function animate(e:Event):void
		{
			return;
			
			
			if (!isMoving) return;
			if (delay != 2) { delay++; return; }
			delay = 0;
			
			frameNumber++;
			if (directionFacing == 0)//down
			{
				if (frameNumber >= 4) frameNumber = 0;
			}
			else if (directionFacing == 1)//left
			{
				if (frameNumber >= 8) frameNumber = 1;
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
		
		public function disable():void
		{
			isDisabled = true;
			alpha = 0;
		}
		
	}

}