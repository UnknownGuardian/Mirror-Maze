package //based off  com.cheezeworld's sound manager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	public class SoundManager extends EventDispatcher
	{
		private static var m_instance:SoundManager;
		private var m_doesMusicLoop:Boolean;
		private var m_music:Sound;
		private var m_pausedPosition:Number;
		private var m_sounds:Dictionary;
		private var m_musicChannel:SoundChannel;
		private var m_musicTransform:SoundTransform;
		private var m_soundTransform:SoundTransform;
		private const INFINITE_LOOP:int = 9999;
		
		
		public var isMusicPlaying:Boolean;
		
		
 		public static function get instance():SoundManager
		{
 			if(SoundManager.m_instance == null)
 			{
 				SoundManager.m_instance = new SoundManager(new SingletonEnforcer());
 			}
 			return SoundManager.m_instance;
 		}
 		
 		
		
 		public function SoundManager( enforcer:SingletonEnforcer )
		{
			m_musicChannel = new SoundChannel();
			m_musicTransform = new SoundTransform( 1 );
			m_soundTransform = new SoundTransform( 1 );
			m_sounds = new Dictionary();
		}
		
		public function playSound( sound:Sound, loops:int = 0 ) : void
		{			
			if( m_sounds[ sound ] == null )
			{
				m_sounds[ sound ] = sound.play( 0, loops, m_soundTransform );				
			}
			else
			{
				m_sounds[ sound ] = sound.play( 0, loops, m_soundTransform );
			}
		}
		
		public function stopSound( sound:Sound ) : void
		{
			if( m_sounds[ sound ] == null )
			{
				m_sounds[ sound ] = sound.play();				
			}
			m_sounds[ sound ].stop();
		}
		
		public function playMusic( music:Sound, a_doesLoop:Boolean = false ) : void
		{
			m_doesMusicLoop = a_doesLoop;
			m_music = music;
			m_musicChannel = music.play( 0, ( a_doesLoop ? INFINITE_LOOP : 1 ), m_musicTransform);
			m_musicChannel.addEventListener( Event.SOUND_COMPLETE, onMusicEnd );
			isMusicPlaying = true;
		}
		
		public function pauseMusic() : void
		{
			m_pausedPosition = m_musicChannel.position;
			m_musicChannel.stop();
			isMusicPlaying = false;
		}
		
		public function unpauseMusic() : void
		{
			m_musicChannel = m_music.play( m_pausedPosition, ( m_doesMusicLoop ? INFINITE_LOOP : 1 ), m_musicTransform );
			m_musicChannel.addEventListener( Event.SOUND_COMPLETE, onMusicEnd );
			isMusicPlaying = true;
		}
		
		public function stopMusic() : void
		{
			m_musicChannel.stop();
			isMusicPlaying = false;
		}
		
		public function get soundVolume():Number
		{ 
			return m_soundTransform.volume;
		}		
		public function setSoundVolume( volume:Number ) : void
		{
			m_soundTransform.volume = volume;
		}
		
		public function get musicVolume():Number
		{ 
			return m_musicTransform.volume;
		}
		public function setMusicVolume( volume:Number ) : void
		{
			m_musicTransform.volume = volume;
			m_musicChannel.soundTransform = m_musicTransform;
		}
		
		private function onMusicEnd( e:Event ) : void
		{
			isMusicPlaying = false;
			dispatchEvent( e.clone() );
		}
	}
}

class SingletonEnforcer{}