//Created by UnknownGuardian
//Extends a modified package

package net.profusiondev.graphics
{
	import flash.display.Bitmap;
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class SpriteSheetAnimation extends SpriteSheet 
	{
		public var frameNumber:int = 0;
		public var numFrames:int = 0;
		public var isAnimating:Boolean = false;
		public var destroyWhenComplete:Boolean = false;
		
		//original bitmap
		//how wide each cell is
		//how tall each cell is
		//how many frames. just for use of bitmaps with empty slots
		//play the animation immediately?
		//destroy after playing once?
		public function SpriteSheetAnimation(tileSheetBitmap:Bitmap, Width:Number, Height:Number, numberOfFrames:int , startImmediately:Boolean, destroyOnComplete:Boolean ):void
		{
			super(tileSheetBitmap, Width, Height);
			
			numFrames = numberOfFrames;
			destroyWhenComplete = destroyOnComplete;
			
			if (startImmediately)
			{
				addEventListener(Event.ENTER_FRAME, animate);
				isAnimating = true;
			}
		}
		public function startAnimation():void
		{
			if (!isAnimating)
			{
				addEventListener(Event.ENTER_FRAME, animate);
				isAnimating = true;
			}
		}
		public function animate(e:Event):void
		{
				drawTile(frameNumber);
				
				frameNumber++;
				if (frameNumber >= numFrames)
				{
					frameNumber = 0;
					if (destroyWhenComplete)
					{
						destroy();
					}
				}
		}
		public function stopAnimation():void
		{
			if (isAnimating)
			{
				removeEventListener(Event.ENTER_FRAME, animate);
				isAnimating = false;
			}
		}
		
		public function destroy():void
		{
			if (parent != null)
			{
				parent.removeChild(this);
				if (isAnimating)
				{
					removeEventListener(Event.ENTER_FRAME, animate);
				}
			}
		}
		
		public function center():void
		{
			getChildAt(0).x = -getChildAt(0).width / 2;
			getChildAt(0).y = -getChildAt(0).height / 2;
		}
	}
	
}