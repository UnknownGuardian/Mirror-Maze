package  
{
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Content
	{
		[Embed(source = 'data/Gurin.png')]private static var sheetHero:Class;
		public static var hero:Bitmap = new sheetHero();
		[Embed(source = 'data/Malon.png')]private static var sheetShadow:Class;
		public static var shadow:Bitmap = new sheetShadow();
		[Embed(source = 'data/Wizard.png')]private static var sheetWizard:Class;
		public static var wizard:Bitmap = new sheetWizard();
		
		[Embed(source = 'data/Crystal.png')]private static var sheetCrystal:Class;
		public static var crystal:Bitmap = new sheetCrystal();
		
		[Embed(source = 'data/TopBar.jpg')]private static var imageTopBar:Class;
		public static var topBar:Bitmap = new imageTopBar();
		[Embed(source = 'data/Numbers.png')]private static var imageNumbers:Class;
		public static var numbers:Bitmap = new imageNumbers();
		
		
		
		
		
		[Embed(source = 'data/MainMenu.jpg')]private static var imageMenuMain:Class;
		public static var mainMenu:Bitmap = new imageMenuMain();
		
		[Embed(source='data/CreditsMenu.jpg')]private static var imageMenuCredits:Class;
		public static var creditsMenu:Bitmap = new imageMenuCredits();
		
		[Embed(source='data/OptionsMenu.png')]private static var imageMenuOptions:Class;
		public static var optionsMenu:Bitmap = new imageMenuOptions();
		
		[Embed(source='data/LevelCompleteMenu.png')]private static var imageLevelComplete:Class;
		public static var levelComplete:Bitmap = new imageLevelComplete();
		
		
		[Embed(source = 'data/EnemyHead.png')]private static var imageEnemyHead:Class;
		public static var enemyHead:Bitmap = new imageEnemyHead();
		
		[Embed(source = 'data/EnemyEye.png')]private static var imageEnemyEye:Class;
		public static var enemyEye:Bitmap = new imageEnemyEye();
		
		
		[Embed(source = 'data/BulletMagicka.png')]private static var imageBulletMagicka:Class;
		public static var bulletMagicka:Bitmap = new imageBulletMagicka();
		
		
		public function Content() 
		{
			
		}
		
	}

}