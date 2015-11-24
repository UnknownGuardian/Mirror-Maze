package  
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class UserInterface extends Sprite
	{
		public var score:NumberDisplay;
		public var time:NumberDisplay;
		public var level:NumberDisplay;
		public var options:Sprite;
		
		public var musicOn:Sprite;
		public var musicOff:Sprite;
		public var soundOn:Sprite;
		public var soundOff:Sprite;
		public var qualityHigh:Sprite;
		public var qualityLow:Sprite;
		
		public function UserInterface() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			addChild(Content.topBar);
			Content.topBar.filters = [ new DropShadowFilter(4, 90, 0x000000, 1)];
			options = new Sprite();
			addChild(options);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			score = new NumberDisplay();
			score.x = 35;
			score.y = 8;
			score.number = 0;
			addChild(score);
			
			time = new NumberDisplay();
			time.x = 220;
			time.y = 8;
			time.number = 0;
			addChild(time);
			
			level = new NumberDisplay();
			level.x = 390;
			level.y = 8;
			level.number = 1;
			addChild(level);
			
			options.addChild(Content.optionsMenu);
			options.visible = false;
			options.mouseEnabled = false;
			options.mouseChildren = false;
			Content.optionsMenu.x = (stage.stageWidth - Content.optionsMenu.width) / 2;
			Content.optionsMenu.y = (stage.stageHeight - Content.optionsMenu.height) / 2;
			//trace(Content.optionsMenu.x, Content.optionsMenu.y);
			addChild(createLayOver(601, 2, 35, 35, gotoOptionsFromGame));
			
			musicOn = createLayOver(215, 151, 52, 32, turnMusicOn, 'overlayspecial', true);	options.addChild(musicOn);
			options.addChild(createLayOver(268, 151, 108, 32, null, 'overlay'));
			musicOff = createLayOver(377, 151, 52, 32, turnMusicOff, 'overlayspecial'); options.addChild(musicOff);
			soundOn = createLayOver(215, 194, 52, 32, turnSoundOn, 'overlayspecial', true); options.addChild(soundOn);
			options.addChild(createLayOver(268, 194, 108, 32, null, 'overlay'));
			soundOff = createLayOver(377, 194, 52, 32, turnSoundOff, 'overlayspecial'); options.addChild(soundOff);
			qualityHigh = createLayOver(215, 238, 52, 32, setQualityHigh, 'overlayspecial', true); options.addChild(qualityHigh);
			options.addChild(createLayOver(268, 238, 108, 32, null, 'overlay'));
			qualityLow = createLayOver(377, 238, 52, 32, setQualityLow, 'overlayspecial'); options.addChild(qualityLow);
			
			options.addChild(createLayOver(196, 296, 108, 31, gotoGameFromOptions, 'overlay'));
			options.addChild(createLayOver(337, 296, 108, 31, gotoMenuFromOptions, 'overlay'));
			options.addChild(createLayOver(255, 347, 135, 31, gotoMoreGamesFromOptions, 'overlay'));
			
			/*
			45,76 52 32		97,76 	109 32		207,76  52 32
			45,119 52 32		97,119 	109 32		207,119  52 32
			45,164 52 32		97,164 	109 32		207,164  52 32

			26,221  108 31				167,221 108 31

			85,272 135 31


			170.5 75
			*/
		}
		
		public function setQualityLow(e:MouseEvent):void  {	stage.quality = Options.qaulity = StageQuality.MEDIUM;	qualityHigh.alpha = 0; }
		public function setQualityHigh(e:MouseEvent):void {	stage.quality = Options.qaulity = StageQuality.BEST; 	qualityLow.alpha = 0; }
		public function turnSoundOff(e:MouseEvent):void	{	Options.isSoundOn = false; soundOn.alpha = 0; }		
		public function turnSoundOn(e:MouseEvent):void  {	Options.isSoundOn = true; soundOff.alpha = 0;}		
		public function turnMusicOff(e:MouseEvent):void {	Options.isMusicOn = false; musicOn.alpha = 0; }		
		public function turnMusicOn(e:MouseEvent):void	{	Options.isMusicOn = true;  musicOff.alpha = 0; }
		
		public function gotoOptionsFromGame(e:MouseEvent):void
		{
			if (options.visible) return;
			Platform.isPaused = true;
			options.visible = true;
			options.mouseEnabled = true;
			options.mouseChildren = true;
			TransitionHandler.startDiamondTween(options, null);
		}
		
		
		
		public function gotoMoreGamesFromOptions(e:MouseEvent):void {
			var targetURL:URLRequest = new URLRequest("http://profusiongames.com/");
			navigateToURL(targetURL);
		}
		public function gotoMenuFromOptions(e:MouseEvent):void {
			stage.addChild(new Menu());
		}
		public function gotoGameFromOptions(e:MouseEvent):void {
			options.mouseEnabled = false;
			options.mouseChildren = false;
			TransitionHandler.startDiamondTween(options, function():void { options.visible = false; Platform.isPaused = false; }, false);
		}
		
		public function kill():void
		{
			while (numChildren != 0) removeChildAt(0);
			while (options.numChildren != 0) options.removeChildAt(0);
			
			musicOn = null;
			musicOff = null;
			soundOn = null;
			soundOff = null;
			qualityHigh = null;
			qualityLow = null;
			
			parent.removeChild(this);
		}
		
		override public function get height():Number
		{
			return getChildAt(0).height;
		}
		
		
		
		
		
		public function createLayOver(X:int, Y:int, Width:int, Height:int, onClick:Function, blendmode:String = 'overlay', isOn:Boolean = false):Sprite
		{
			var s:Sprite = new Sprite();
			s.x = X;
			s.y = Y;
			
			if (blendmode != 'overlayspecial')
			{
				s.blendMode = blendmode
				s.graphics.beginFill(0xFFFFFF, 1);
			}
			else
			{
				s.blendMode = 'overlay'
				s.graphics.beginFill(0xFFFFFF, .5);
			}
			s.graphics.drawRect(0, 0, Width, Height);
			s.graphics.endFill();
			if(!isOn)
				s.alpha = 0;
			else
				s.filters = [new GlowFilter(0xFFFFFF, 0.2, 16, 16), new GlowFilter(0xFFFFFF,0.3,30,0,4)];
			s.addEventListener(MouseEvent.ROLL_OVER, showHighlight, false, 0, true);
			s.addEventListener(MouseEvent.ROLL_OUT, hideHighlight, false, 0, true);
			if(onClick != null)
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
			if (musicOff == e.currentTarget && !Options.isMusicOn) return;
			if (musicOn == e.currentTarget && Options.isMusicOn) return;
			if (soundOff == e.currentTarget && !Options.isSoundOn) return;
			if (soundOn == e.currentTarget && Options.isSoundOn) return;
			if (qualityHigh == e.currentTarget && Options.qaulity == StageQuality.BEST) return;
			if (qualityLow == e.currentTarget && Options.qaulity == StageQuality.MEDIUM) return;
			e.currentTarget.alpha = 0;
			e.currentTarget.filters = [];
		}
	}

}