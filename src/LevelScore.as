package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class LevelScore extends Sprite
	{
		public var time:NumberDisplay;
		public var bulletsShot:NumberDisplay;
		public var deaths:NumberDisplay;
		public var score:NumberDisplay;
		
		public var scoreTime:int = 99999;
		public var scoreBullets:int = 99999;
		public var scoreDeaths:int = 99999;
		public var scoreScore:int = 99999;
		
		public var plat:Platform;
		
		public function LevelScore(platform:Platform = null, _time:int = 99999, _bullets:int = 99999, _deaths:int = 99999, _score:int = 99999 ) 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			scoreTime = _time;
			scoreBullets = _bullets;
			scoreDeaths = _deaths;
			scoreScore = _score;
			
			plat = platform;
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var bd:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight);
			bd.draw(stage);
			var b:Bitmap = new Bitmap(bd);
			addChild(b);
			addChild(Content.levelComplete);
			Content.levelComplete.x  = stage.stageWidth / 2 - Content.levelComplete.width / 2;
			Content.levelComplete.y  = stage.stageHeight / 2 - Content.levelComplete.height / 2;
			
			time = new NumberDisplay();
			time.number = scoreTime;
			time.x = 270;
			time.y = 148;
			addChild(time);
			
			bulletsShot = new NumberDisplay();
			bulletsShot.number = scoreBullets;
			bulletsShot.x = 270;
			bulletsShot.y = 198;
			addChild(bulletsShot);
			
			deaths = new NumberDisplay();
			deaths.number = scoreDeaths;
			deaths.x = 270;
			deaths.y = 246;
			addChild(deaths);
			
			score = new NumberDisplay();
			score.number = scoreScore;
			score.x = 270;
			score.y = 303;
			addChild(score);
			
			
			addChild(createLayOver(Content.levelComplete.x + 32, Content.levelComplete.y + 276, 143, 32, plat.gotoReplayLevelFromLevelScore));
			addChild(createLayOver(Content.levelComplete.x + 233, Content.levelComplete.y + 276, 120, 32, plat.gotoNextLevelFromLevelScore));
		}
		
		public function kill():void
		{
			time.destroy();
			bulletsShot.destroy();
			deaths.destroy();
			score.destroy();
			
			while (numChildren != 0) removeChildAt(0);
			
			plat = null;
			time = null;
			bulletsShot = null
			deaths = null;
			score = null;
			
			parent.removeChild(this);
		}
		
		
		public function createLayOver(X:int, Y:int, Width:int, Height:int, onClick:Function, hardLight:Boolean = true ):Sprite
		{
			var s:Sprite = new Sprite();
			s.x = X;
			s.y = Y;
			s.blendMode = 'overlay';
			//var m:Matrix = new Matrix();
			//m.createGradientBox(Width, Height,1.5*3.141592);
			//s.graphics.beginGradientFill("linear", [0xFFFFFF, 0xFFFFFF], [0.2, 0.01], [0, 255], m);
			if(hardLight)
				s.graphics.beginFill(0xFFFFFF, 1);
			else
				s.graphics.beginFill(0xFFFFFF, 0.5);
			s.graphics.drawRect(0, 0, Width, Height);
			s.graphics.endFill();
			s.alpha = 0;
			s.addEventListener(MouseEvent.ROLL_OVER, showHighlight, false, 0, true);
			s.addEventListener(MouseEvent.ROLL_OUT, hideHighlight, false, 0, true);
			s.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			return s;
		}
		
		
		public function showHighlight(e:MouseEvent):void
		{
			e.currentTarget.alpha = 1;
			e.currentTarget.filters = [new GlowFilter(0xFFFFFF, 0.2, 16, 16), new GlowFilter(0xFFFFFF,0.3,30,0,4)];
		}
		public function hideHighlight(e:MouseEvent):void
		{
			e.currentTarget.alpha = 0;
			e.currentTarget.filters = [];
		}
	}

}