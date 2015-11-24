package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import net.profusiondev.net.SaveSystem;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Menu extends Sprite
	{
		public var main:Sprite = new Sprite();
		public var credits:Sprite = new Sprite();
		public static var game:Platform;
		
		public function Menu() 
		{
			if (game) game.kill();
			game = new Platform();
			
			main.addChild(Content.mainMenu);
			credits.addChild(Content.creditsMenu);
			
			main.addChild(createLayOver(41, 263, 175, 51, gotoNewGameFromMain));
			
			main.addChild(createLayOver(429, 263, 175, 51, gotoCreditsFromMain));
			main.addChild(createLayOver(429, 371, 175, 51, gotoMoreFromMain));
			
			credits.addChild(createLayOver(240, 404, 165, 50, gotoMainFromCredits));
			credits.addChild(createLayOver(32, 154, 260, 66, gotoDavidFromCredits, false));
			credits.addChild(createLayOver(398, 154, 209, 66, gotoUnknownGuardianFromCredits, false));
			
			SaveSystem.createOrLoadSlot("Slot1");
			SaveSystem.openSlot("Slot1");
			if ((SaveSystem.getCurrentSlot().readBoolean("isCreated")))
			{
				//if the player has played before, create a continue button
				main.addChild(createLayOver(41, 371, 175, 51, gotoResumeGameFromMain));
			}
			else
			{
				//otherwise save that the player has been here and has is currently on level 1
				SaveSystem.getCurrentSlot().write("isCreated", true);
				SaveSystem.getCurrentSlot().write("CurrentLevel", LevelData.currentLevel);
				SaveSystem.saveCurrentSlot();
			}
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			show("main");
		}
		
		
		public function show(t:String):void
		{			
			addChild(this[t]);
			TransitionHandler.startDiamondTween(this[t], removeOtherObjects);
		}
		
		public function removeOtherObjects(s:Sprite):void
		{
			if (main.parent && s != main)
			{
				removeChild(main);
			}
			if (credits.parent && s != credits)
			{
				removeChild(credits);
			}
		}
		
		
		public function kill():void
		{			
			if (main.parent) {
				removeChild(main);
			}
			if (credits.parent)	{
				removeChild(credits);
			}
			while (main.numChildren > 0) {
				main.getChildAt(0).removeEventListener(MouseEvent.ROLL_OVER, showHighlight);
				main.getChildAt(0).removeEventListener(MouseEvent.ROLL_OUT, hideHighlight);
				main.removeChildAt(0);
			}
			while (credits.numChildren > 0)	{
				credits.getChildAt(0).removeEventListener(MouseEvent.ROLL_OVER, showHighlight);
				credits.getChildAt(0).removeEventListener(MouseEvent.ROLL_OUT, hideHighlight);
				credits.removeChildAt(0);
			}
			game.init();
			stage.addChild(game);
			
			parent.removeChild(this);
			game = null;
		}
		
		
		public function createLayOver(X:int, Y:int, Width:int, Height:int, onClick:Function, hardLight:Boolean = true ):Sprite
		{
			var s:Sprite = new Sprite();
			s.x = X;
			s.y = Y;
			s.blendMode = 'overlay';
			var m:Matrix = new Matrix();
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
		
		
		
		
		
		
		public function gotoNewGameFromMain(e:MouseEvent):void {
			LevelData.currentLevel = 0; //started an entire new game. starts with 0 to ensure pre-game level + comic
			SaveSystem.getCurrentSlot().write("CurrentLevel", 0);
			SaveSystem.saveCurrentSlot();
			kill();
		}
		public function gotoResumeGameFromMain(e:MouseEvent):void {
			LevelData.currentLevel = SaveSystem.getCurrentSlot().readInt("CurrentLevel");
			kill();
		}
		public function gotoCreditsFromMain(e:MouseEvent):void {
			show("credits");
		}
		public function gotoMoreFromMain(e:MouseEvent):void {
			var targetURL:URLRequest = new URLRequest("http://profusiongames.com/");
			navigateToURL(targetURL);
		}
		public function gotoMainFromCredits(e:MouseEvent):void {
			show("main");
		}
		public function gotoDavidFromCredits(e:MouseEvent):void {
			var targetURL:URLRequest = new URLRequest("http://davidarcila.com/");
			navigateToURL(targetURL);
		}
		public function gotoUnknownGuardianFromCredits(e:MouseEvent):void {
			var targetURL:URLRequest = new URLRequest("http://profusiongames.com/");
			navigateToURL(targetURL);
		}
		
		
		
		public function showHighlight(e:MouseEvent):void
		{
			e.currentTarget.alpha = 1;
			e.currentTarget.filters = [new GlowFilter(0xFFE303, 0.2, 16, 16), new GlowFilter(0x236B8E,0.3,30,0,4)];
		}
		public function hideHighlight(e:MouseEvent):void
		{
			e.currentTarget.alpha = 0;
			e.currentTarget.filters = [];
		}
	}

}