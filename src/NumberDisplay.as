package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class NumberDisplay extends SpriteSheetAnimation
	{
		public var one:SpriteSheetAnimation;
		private var _number:int = 98765432;
		
		public function NumberDisplay() 
		{
			super(Content.numbers, 20, 22, 10, false, false);
			//canvasBitmap.x = -width;
			//getChildAt(0).y = 0;
			removeChildAt(0);
			canvasBitmapData = new BitmapData(tileWidth*10, tileHeight, true, 0x00000000);
            canvasBitmap = new Bitmap(canvasBitmapData);
			addChild(canvasBitmap);
			drawTile(0);
		}
		
		public function set number(num:int):void
		{
			_number = num;
			drawTile(0);
		}
		
		override public function drawTile(tileNumber:int):void
        {
			canvasBitmapData.lock();
			canvasBitmapData.fillRect(new Rectangle(0, 0, width, height), 0x00000000); //clear it
			tileNumber = _number;
			var iterations:int = 0;
			while (tileNumber > 0 || (tileNumber == 0 && iterations == 0))
			{
				var temp:int = tileNumber % 10;
				tileRectangle.x = int((temp % rowLength)) * tileWidth;
				tileRectangle.y = int((temp / rowLength)) * tileHeight;
				tilePoint.x = (9 - iterations) * tileWidth
				canvasBitmapData.copyPixels(tileSheetBitmapData, tileRectangle, tilePoint);
				tileNumber /= 10;
				iterations++;
			}
			canvasBitmapData.unlock();
		}
		
	}

}