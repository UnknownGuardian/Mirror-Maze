package  
{
	import flash.display.StageQuality;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Options
	{
		private static var _isMusicOn:Boolean = true;
		public static var _isSoundOn:Boolean = true;
		public static var qaulity:String = StageQuality.BEST;
		
		public function Options() 
		{
			
		}
		
		public static function get isMusicOn():Boolean
		{
			return _isMusicOn;
		}
		
		public static function set isMusicOn(b:Boolean):void
		{
			_isMusicOn = b;
			SoundManager.instance.setMusicVolume( b ? 1:0);
		}
		
		
		public static function get isSoundOn():Boolean
		{
			return _isSoundOn;
		}
		
		public static function set isSoundOn(b:Boolean):void
		{
			_isSoundOn = b;
			SoundManager.instance.setSoundVolume( b ? 1:0);
		}
	}

}