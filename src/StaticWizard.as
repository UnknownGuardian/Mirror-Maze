package  
{
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class StaticWizard extends SpriteSheetAnimation
	{
		
		public function StaticWizard() 
		{
			super(Content.wizard, 32, 48, 16, false, false);
			getChildAt(0).x = -width/2;
			getChildAt(0).y = -height/2;
		}
	}

}