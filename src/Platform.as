package {
	
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import net.profusiondev.net.SaveSystem;
	
	
	public class Platform extends Sprite
	{
		public static var isPaused:Boolean = false;
		public var hud:UserInterface;
		public var instructionsWindow:PWindow;
		//public var highScoresWindow:PScrollingContentWindow;
		//public var finalTimeWindow:PWindowExtra;
		public var frameCounter:int = 0;
		public var bulletCounter:int = 0;
		public var coinCounter:int = 0;
		public var deathCounter:int = 0;
		
		private var over:String = "";
		
		
		//key presses
		public var leftPressed:Boolean = false;
		public var rightPressed:Boolean = false;
		public var upPressed:Boolean = false;
		public var downPressed:Boolean = false;
		public var spacePressed:Boolean = false;
		public var mousePressed:Boolean = false;
		
		//location of the player
		private var gurinXPos:Number = 0;
		private var gurinYPos:Number = 0;
		private var malonXPos:Number = 0;
		private var malonYPos:Number = 0;
		
		//width, height of the file
		public static var tile_size:Number = 40;
		
		//tile properties
		private var water_acceleration:Number = 2//1;
		private var water_friction:Number = 1.2;//0.8;
		private var air_acceleration:Number = 4;//0.5;
		private var air_friction:Number = 0.7;
		private var ice_acceleration:Number = 4;// 0.14;
		private var ice_friction:Number = 1;//0.96;
		private var treadmill_speed:Number = 1;// 2;
		
		//player properties
		private var playerRightSide:int = 16//18//5;
		private var playerLeftSide:int = 17//19//6;
		private var playerTopSide:int = 16//18//6;
		private var playerBottomSide:int = 17//19//6;
		
		private var gravity:Number = 0; // 0.5;
		private var jump_speed:Number = 0;// 7;
		private var climbing:Boolean = false;
		private var climb_speed:Number = 0;//2.6;
		
		//in game objects
		private var coins:Array = new Array();
		public static var level:Array = new Array();
		private var levelObj:Array = new Array
		private var keys:Array = new Array();
		private var player:Array = new Array();
		public static var enemy:Array = new Array();
		public var crystal:Crystal;
		
		//tiles that are steppable on (e.g. non air)
		private var walkable_tiles:Array = new Array(0, 44);
		//public static var trapTiles:Array = [0,7];
		
		//player
		private var gurin:Gurin = new Gurin();
		private var malon:Malon = new Malon();
		private var staticWizard:StaticWizard = new StaticWizard();
		
		//holds level graphics in a container. Make it easy for scroll
		private var level_container:Sprite = new Sprite();
		
		private var correctionSpeed:Number = 2.5;
		
		//temp vars to hold position of tiles relative to gurin
		private var ginCageTrap:Boolean = false;
		private var gbottom:Number;
		private var gleft:Number;
		private var gright:Number;
		private var gtop:Number;
		private var gbottom_left:Number;
		private var gbottom_right:Number;
		private var gtop_left:Number;
		private var gtop_right:Number;
		private var gprev_bottom:Number;
		private var gfriction:Number;
		private var gspeed:Number;
		private var gbonus_speed:Number = 0;
		private var gurinXSpeed:Number = 0;
		private var gurinYSpeed:Number = 0;
		//temp vars to hold position of tiles relative to malon
		private var minCageTrap:Boolean = false;
		private var mbottom:Number;
		private var mleft:Number;
		private var mright:Number;
		private var mtop:Number;
		private var mbottom_left:Number;
		private var mbottom_right:Number;
		private var mtop_left:Number;
		private var mtop_right:Number;
		private var mprev_bottom:Number;
		private var mfriction:Number;
		private var mspeed:Number;
		private var mbonus_speed:Number = 0;
		private var malonXSpeed:Number = 0;
		private var malonYSpeed:Number = 0;
		
		//more temp player properties
		private var climbdir:Number;
		private var current_tile:Number;
		private var walking:Boolean;
		private var scoreWindow:LevelScore;
		
		private var bulletLimiterMax:int = 61;
		private var bulletLimiter:int = 0;
		
		
		public function Platform()
		{
		}
		public function init(levelData:String = ""):void
		{
			//decode level
			if (levelData != "")
			{
				var data:Array = levelData.split("_");
				var levelWidth:int = int(data[0]);
				var levelHeight:int = int(data[1]);
				trace("------------------Gathered Data--------------------");
				trace("Have: " + data[2]);
				var i:int = 0;
				var q:int = 0;
				for (i = 0; i < levelHeight; i++)
				{
					level[i] = [];
					for (q = 0; q < levelWidth; q++)
					{
						level[i].push(0);
					}
				}
				trace("------------------Building Level--------------------");
				var count:int = 0;
				for (q = 0; q < levelWidth; q++)
				
				{
					for (i = 0; i < levelHeight; i++)
					{
						level[i][q] = int(data[2].substring(count, count + 1))-1;
						count++;
					}
				}
				trace("------------------Level Built--------------------");
				for (i = 0; i < levelHeight; i++)
				{
					trace(level[i]);
				}
				trace("-----------------Adding Items--------------------");
				trace("Have: " + data[3]);
				var playerEndX:int;
				var playerEndY:int;
				count = 0;
				for (q = 0; q < levelWidth; q++)
				{
					for (i = 0; i < levelHeight; i++)
					{
						var itemType:int = int(data[3].substring(count, count + 1)) - 1;
						trace(itemType);
						switch(itemType)
						{
							case 1 : { keys[0] = [i,q]; break; }
							case 2 : { coins.push([i, q]); break; }
							case 3 : { player =   [i, q] ; break; }
							case 4 : { playerEndX = i; playerEndY = q; break; }
						}
						count++;
					}
				}
				
				keys[0].push(playerEndX, playerEndY);
			}
			else
			{
				//level definition. Perhaps recode this to our way? or something
				/*
				level[0] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
				level[1] = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
				level[2] = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 1, 0, 0, 0, 0, 1];
				level[3] = [1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1];
				level[4] = [1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1];
				level[5] = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 1];
				level[6] = [1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 1, 0, 0, 0, 0, 0, 1];
				level[7] = [1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 1];
				level[8] = [1, 1, 1, 1, 0, 9, 0, 0, 0, 5, 5, 0, 0, 0, 7, 0, 0, 6, 0, 0, 0, 0, 7, 0, 1];
				level[9] = [1, 1, 1, 1, 1, 1, 1, 2, 2, 8, 8, 8, 8, 1, 1, 3, 3, 1, 4, 4, 1, 8, 1, 8, 1];
				*/
				/*
				level[0]  = [9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9];
				level[1]  = [9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9];
				level[2]  = [9,0,1,1,1,0,1,1,1,0,1,1,1,0,1,1,9];
				level[3]  = [9,1,1,0,1,0,1,0,1,1,1,0,1,0,1,0,9];
				level[4]  = [9,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9];
				level[5]  = [9,0,1,1,1,1,1,0,1,0,1,1,1,1,1,0,9];
				level[6]  = [9,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9];
				level[7]  = [9,1,1,0,1,0,1,0,1,0,1,0,1,0,1,1,9];
				level[8]  = [9,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9];
				level[9]  = [9,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,9];
				level[10] = [9,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9];
				level[11] = [9,9,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9];
				level[12] = [9,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,9];
				level[13] = [9,0,7,7,7,0,0,0,1,0,0,0,0,0,0,0,9];
				level[14] = [9,0,7,7,7,0,0,0,1,0,0,0,0,0,0,0,9];
				level[15] = [9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9];
				*/
				LevelData.retrieveLevel(level, LevelData.currentLevel);
			}
			
			player = [7,14,9,14];
			//player = [1, 1,];
			coins = [	
			];
			
			//enemy[0] = ["head", 2, 10,0];
			//enemy[1] = ["eye", 3, 10,0];
			//enemy[1] = [3, 3, -2];
			
			//keys[0] = [1, 5, 5, 8];
			
			hud = new UserInterface();
			
			
			addEventListener(Event.ADDED_TO_STAGE, displayInstructions);
		}
		public function displayInstructions(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, displayInstructions);
			
			stage.addChild(hud);
			create_level(level);
			onEnterFrame();
			
			instructionsWindow = new PWindow(300,300,"Welcome to Minimal Platformer.\n\n\nCompete internationally against other users for the best scores.\n\nTime - Coins - Combo", removeWindow,null);
			instructionsWindow.y = stage.stageHeight / 2;
			stage.addChild(instructionsWindow);
			
			PAnimation.centerWindow(instructionsWindow);
			PAnimation.fadeInWindow(instructionsWindow);
			
		}
		
		public function removeWindow(e:MouseEvent):void
		{
			PAnimation.moveWindowRight(instructionsWindow, stage.stageWidth / 2);
			PAnimation.fadeOutWindow(instructionsWindow, startGame);
		}
		public function startGame():void
		{
			
			if (instructionsWindow)
			{
				instructionsWindow.kill();
				stage.removeChild(instructionsWindow);
				instructionsWindow = null;
			}
			/*if (finalTimeWindow)
			{
				finalTimeWindow.kill();
				stage.removeChild(finalTimeWindow);
				finalTimeWindow = null;
			}*/
			stage.stageFocusRect = false;
			stage.focus = this;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
			level_container.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			level_container.addEventListener(MouseEvent.MOUSE_UP, mUp);
			frameCounter = 0;
			coinCounter = 0;
			deathCounter = 0;
		}
		
		private function mDown(e:MouseEvent):void 
		{
			mousePressed = true;
		}
		
		private function mUp(e:MouseEvent):void 
		{
			mousePressed = false;
		}
		
		/*
		private function traceSpot(e:MouseEvent):void 
		{
			trace("[" + e.currentTarget.y / tile_size + ",", e.currentTarget.x / tile_size + "],");
			e.currentTarget.graphics.beginFill(0xFF00FF, 1);
			e.currentTarget.graphics.drawCircle(tile_size/2, tile_size/2, 3);
			e.currentTarget.graphics.endFill();
		}*/
		
		public function key_down(e:KeyboardEvent):void
		{
			var k:int = e.keyCode;
			
			if (k == 32) {
				spacePressed = true;
			}
			
			if ( k == 65 || k == 37 ) {
				leftPressed = true;
			}
			
			if ( k == 87 || k == 38 ) {
				upPressed = true;
			}
			
			if ( k == 68 || k == 39 ) {
				rightPressed = true;
			}
			
			if ( k == 83 || k == 40 ) {
				downPressed = true;
			}
		}
		
		public function key_up(e:KeyboardEvent):void
		{
			var k:int = e.keyCode;
			
			if (k == 32) {
				spacePressed = false;
			}
			
			if ( k == 65 || k == 37 ) {
				leftPressed = false;
			}
			
			if ( k == 87 || k == 38 ) {
				upPressed = false;
			}
			
			if ( k == 68 || k == 39 ) {
				rightPressed = false;
			}
			
			if ( k == 83 || k == 40 ) {
				downPressed = false;
			}
		}
		
		public function create_level(l:Array):void
		{
			var level_height:Number = l.length;
			var level_width:Number = l[0].length;
			
			addChild(level_container);
			
			/*
			for (var j:Number = 0; j<level_height; j++)
			{
				levelObj[j] = new Array();
				for (var i:Number = 0; i<level_width; i++)
				{
					//if (l[j][i] != 0)
					{
						var t:Tile = new Tile();
						//t.addEventListener(MouseEvent.CLICK, traceSpot);
						t.x = i*tile_size;
						t.y = j*tile_size;
						t.gotoAndStop(l[j][i]+1);
						levelObj[j][i] = t;
						level_container.addChild(levelObj[j][i]);
					}
				}
			}
			*/
			
			for (var j:Number = 0; j<level_height; j++)
			{
				levelObj[j] = new Array();
				for (var i:Number = 0; i<level_width; i++)
				{
					var t:Tile = new Tile();
					t.x = i*tile_size;
					t.y = j*tile_size;
					t.gotoAndStop(l[j][i] + 1);
					levelObj[j][i] = t;
					level_container.addChild(levelObj[j][i]);
				}
			}
			
			crystal = new Crystal();
			crystal.x = 8*tile_size;
			//crystal.x = 2*tile_size;
			crystal.y = tile_size*6;
			level_container.addChild(crystal);
			
			var stack:Array = [];
			for (j = 0; j<level_height; j++) //ground, traps
			{
				for (i = 0; i<level_width; i++)
				{
					if (LevelData.isTrap(l[j][i]) || LevelData.isGround(l[j][i])) 
					//if (Platform.trapTiles.indexOf(l[j][i]) != -1) 
					{ 
						
						stack.push(levelObj[j][i]);
					}
				}
			}
			for (j = 0; j<level_height; j++) //everything else
			{
				for (i = 0; i<level_width; i++)
				{
					//if (Platform.trapTiles.indexOf(l[j][i]) == -1)stack.push(levelObj[j][i]);
					if (!LevelData.isTrap(l[j][i]) && !LevelData.isGround(l[j][i])) stack.push(levelObj[j][i]);
				}
			}
			for (j = 0; j < stack.length; j++)
			{
				level_container.setChildIndex(stack[j], level_container.numChildren-1);
			}
			
			place_player();
			
			
			level_container.addChild(malon);
			level_container.addChild(gurin);
			
			
			
			level_container.setChildIndex(malon, level_container.numChildren - 1);
			level_container.setChildIndex(gurin, level_container.numChildren - 1);
			level_container.setChildIndex(crystal, level_container.numChildren - 1);
			
			
			for (var m:int = 0; m < coins.length; m++)
			{
				var c:coin = new coin();
				c.x = coins[m][0] * tile_size + tile_size / 2;
				c.y = coins[m][1] * tile_size + tile_size/2 + 1;
				
				coins[m] = c;
				level_container.addChild(coins[m]);
			}
			
			coins.push(crystal);
			for (var n:int = 0; n < keys.length; n++)
			{
				var _k:key = new key();
				_k.x = keys[n][0] * tile_size + tile_size / 2;
				_k.y = keys[n][1] * tile_size + tile_size / 2 + 1;
				_k.openX = keys[n][2];
				_k.openY = keys[n][3];
				keys[n] = _k;
				level_container.addChild(keys[n]);
			}
			
			for (var k:int = 0; k < enemy.length; k++)
			{
				if (enemy[k][0] == "head")
				{
					var h:Head = new Head();
					h.x = enemy[k][1] * tile_size + tile_size / 2;
					h.y = enemy[k][2] * tile_size + tile_size / 2 + 1;
					h.setDirection(enemy[k][3]);
					enemy[k] = h;
				}
				else if (enemy[k][0] == "eye")
				{
					var h2:Eye = new Eye();
					h2.x = enemy[k][1] * tile_size + tile_size / 2;
					h2.y = enemy[k][2] * tile_size + tile_size / 2 + 1;
					h2.setDirection(enemy[k][3]);
					enemy[k] = h2;
				}
				level_container.addChild(enemy[k]);
			}			
		}
		
		
		public function onEnterFrame(event:Event = null):void
		{
			if (Platform.isPaused) return;
			
			frameCounter++;
			hud.time.number = frameCounter;
			
			ground_under_feet();
			
			walking = false;
			if (leftPressed) {  //right, left priority over up down
				gurinXSpeed = -gspeed;
				malonXSpeed = mspeed;
				walking = true;
				gurinYSpeed = 0;
				malonYSpeed = 0;
				gurin.setDirection(1);
				malon.setDirection(2);
			}
			else if (rightPressed) {
				gurinXSpeed = gspeed;
				malonXSpeed = -mspeed
				walking = true;
				gurinYSpeed = 0;
				malonYSpeed = 0;
				gurin.setDirection(2);
				malon.setDirection(1);
			}
			else if (upPressed) {
				gurinYSpeed = -gspeed;
				malonYSpeed = -mspeed;
				walking = true;
				gurinXSpeed = 0;
				malonXSpeed = 0;
				gurin.setDirection(3);
				malon.setDirection(3);
			}
			else if (downPressed) {
				gurinYSpeed = gspeed;
				malonYSpeed = mspeed;
				walking = true;
				gurinXSpeed = 0;
				malonXSpeed = 0;
				gurin.setDirection(0);
				malon.setDirection(0);
			}
			if (!walking) {
				gurinXSpeed = 0;
				gurinYSpeed = 0;
				malonXSpeed = 0;
				malonYSpeed = 0;
			}
			gurin.isMoving = walking;
			malon.isMoving = walking;
			check_collisions();
			gurin.x = gurinXPos;
			gurin.y = gurinYPos;
			malon.x = malonXPos;
			malon.y = malonYPos;
			
			
			
			//level_container.x = 320-int((malonXPos+gurinXPos)/2);
			level_container.x = 0;
			//level_container.y = int(-gurinYPos + 240);
			//level_container.y = int( -gurinYPos + 240); //position it should be is int( -gurinYPos + stage.stageHeight/2)
			
			//280 because 240 + hud height (~40px)
			level_container.y += (( (-gurinYPos-malonYPos)/2 + 280)-level_container.y)/10; //position it should be is int( -gurinYPos + stage.stageHeight/2)
			if (level_container.y > hud.height + tile_size / 2) level_container.y = hud.height + tile_size / 2;
			if (level_container.y < -level_container.height / 4  + 50) level_container.y = -level_container.height / 4  + 50;
			//if (level_container.y < -level.length/4*61 ) level_container.y = -level.length/4*61
			//trace(level_container.height, level_container.y, -level.length/4*61);
			
			for (var i:int = 0; i < enemy.length; i++)
			{
				if (malon.hitTestObject(enemy[i]) || gurin.hitTestObject(enemy[i])) //if the enemy hits a player
				{
					gspeed = 0;
					gfriction = 0;
					mspeed = 0;
					mfriction = 0;
					TweenLite.to(malon, 1.4, { y:"-30", alpha:0} );
					TweenLite.to(gurin, 1.5, { y:"-30", alpha:0, onComplete:place_player } );
					Platform.isPaused = true;
					if(Math.random() > 0.5)
						SoundManager.instance.playSound(new soundHurt1());
					else
						SoundManager.instance.playSound(new soundHurt2());
					deathCounter++;
					return;
				}
				if (enemy[i] is Head)
				{
					var h:Head = enemy[i];
					h.getFuturePoint(); //set xPos and yPos to future pos
					
					h.left_foot_x = Math.floor((h.xPos-30)/tile_size);
					h.right_foot_x = Math.floor((h.xPos+30)/tile_size);
					h.foot_y = Math.floor((h.yPos+27)/tile_size);
					h.bottom = Math.floor((h.yPos+26)/tile_size);
					h.top = Math.floor((h.yPos-26)/tile_size);
					h.left_foot = level[h.foot_y][h.left_foot_x];
					h.right_foot = level[h.foot_y][h.right_foot_x];
					h.left = level[h.bottom][h.left_foot_x];
					h.right = level[h.bottom][h.right_foot_x];
					h.up = level[h.top][int(h.yPos / tile_size)];
					h.down = level[h.bottom][int(h.yPos / tile_size)];
					
					h.move();
				}
				else if (enemy[i] is Eye)
				{
					var h2:Eye = enemy[i];
					h2.getFuturePoint(); //set xPos and yPos to future pos
					
					h2.left_foot_x = Math.floor((h2.xPos-30)/tile_size);
					h2.right_foot_x = Math.floor((h2.xPos+30)/tile_size);
					h2.foot_y = Math.floor((h2.yPos+27)/tile_size);
					h2.bottom = Math.floor((h2.yPos+26)/tile_size);
					h2.top = Math.floor((h2.yPos-26)/tile_size);
					h2.left_foot = level[h2.foot_y][h2.left_foot_x];
					h2.right_foot = level[h2.foot_y][h2.right_foot_x];
					h2.left = level[h2.bottom][h2.left_foot_x];
					h2.right = level[h2.bottom][h2.right_foot_x];
					h2.up = level[h2.top][int(h2.yPos / tile_size)];
					h2.down = level[h2.bottom][int(h2.yPos / tile_size)];
					
					h2.move();
				}
				/*
				enemy[i].xPos = enemy[i].x;
				enemy[i].yPos = enemy[i].y;
				
				enemy[i].xPos += enemy[i].speed;
				
				enemy[i].left_foot_x = Math.floor((enemy[i].xPos-playerLeftSide)/tile_size);
				enemy[i].right_foot_x = Math.floor((enemy[i].xPos+playerRightSide)/tile_size);
				enemy[i].foot_y = Math.floor((enemy[i].yPos+9)/tile_size);
				enemy[i].bottom = Math.floor((enemy[i].yPos+8)/tile_size);
				enemy[i].left_foot = level[enemy[i].foot_y][enemy[i].left_foot_x];
				enemy[i].right_foot = level[enemy[i].foot_y][enemy[i].right_foot_x];
				enemy[i].left = level[enemy[i].bottom][enemy[i].left_foot_x];
				enemy[i].right = level[enemy[i].bottom][enemy[i].right_foot_x];
				
				if (enemy[i].left_foot != 0 && enemy[i].right_foot != 0 && enemy[i].left == 0 && enemy[i].right == 0)
				{
					enemy[i].x = enemy[i].xPos;
				}
				else {
					enemy[i].speed *= -1;
				}*/
				
			}
			
			for (var j:int = 0; j < coins.length; j++)
			{
				if(coins[j] != crystal && coins[j].hitTestObject(gurin))
				{
					if (coins[j].parent)
					{
						coinCounter++;
						coins[j].parent.removeChild(coins[j]);
					}
				}
				else
				{
					if (crystal.bothOnCrystal(gurin, malon))
					{
						gotoLevelScore();
						//endGame(); 
					}
				}
			}
			
			for (var k:int = 0; k < keys.length; k++)
			{
				if(keys[k].hitTestObject(gurin))
				{
					level[keys[k].openY][keys[k].openX] = 0;
					
					level_container.removeChild(levelObj[keys[k].openY][keys[k].openX]);
					level_container.removeChild(keys[k]);
				}
			}
			
			
			bulletLimiter++;
			if (bulletLimiter > bulletLimiterMax)
			{ 
				if (mousePressed)
				{
					bulletCounter++;
					
					bulletLimiter = 0;
					var bullet:Bullet = new Bullet(false);
					bullet.x = gurin.x + gurin.getChildAt(0).x/2;
					bullet.y = gurin.y + gurin.getChildAt(0).y/2;
					bullet.rotation = gurin.getFacingRotation();
					if (bullet.rotation == 90 || bullet.rotation == -90) bullet.x -= 3;
					level_container.addChild(bullet);
					SoundManager.instance.playSound(new soundFireball());
					
					if (LevelData.currentLevel == 0) return; // do not fire shadows bullet on pregame level since shadow does not exist
					
					var shadowBullet:Bullet = new Bullet(true);
					shadowBullet.x = malon.x + malon.getChildAt(0).x / 2;
					shadowBullet.y = malon.y + malon.getChildAt(0).y/2;
					shadowBullet.rotation = malon.getFacingRotation();
					if (shadowBullet.rotation == 90 || shadowBullet.rotation == -90) shadowBullet.x -= 3;
					level_container.addChild(shadowBullet);
					SoundManager.instance.playSound(new soundFireball());
					
				}
			}
		}
		
		public function ground_under_feet():void
		{
			gbonus_speed = 0;
			var gleft_foot_x:Number = Math.floor((gurinXPos-playerLeftSide)/tile_size);
			var gright_foot_x:Number = Math.floor((gurinXPos+playerRightSide)/tile_size);
			var gfoot_y:Number = Math.floor((gurinYPos+9)/tile_size);//var gfoot_y:Number = Math.floor((gurinYPos+9)/tile_size);
			var gleft_foot:Number = level[gfoot_y][gleft_foot_x];
			var gright_foot:Number = level[gfoot_y][gright_foot_x];
			
			//below correct for all g -> m replacements
			mbonus_speed = 0;
			var mleft_foot_x:Number = Math.floor((malonXPos-playerLeftSide)/tile_size);
			var mright_foot_x:Number = Math.floor((malonXPos+playerRightSide)/tile_size);
			var mfoot_y:Number = Math.floor((malonYPos+9)/tile_size);//var mfoot_y:Number = Math.floor((malonYPos+9)/tile_size);
			var mleft_foot:Number = level[mfoot_y][mleft_foot_x];
			var mright_foot:Number = level[mfoot_y][mright_foot_x];
			
			
			
			if (gleft_foot != 0) {
				current_tile = gleft_foot;
			} else {
				current_tile = gright_foot;
			}
			if (LevelData.isGround(current_tile))
			{
				gspeed = air_acceleration;
				gfriction = air_friction;
				if (LevelData.isTrap(current_tile))
				{
					if (current_tile == 7) //water, slow down
					{
						gspeed = water_acceleration;
						gfriction = water_friction;
					}
					else if (current_tile == 46 && gleft_foot == 46 && gright_foot == 46) // cage, other has to tag user, swaps focus of camera
					{
						ginCageTrap = true;
						gspeed = 0;
						gfriction = 0;
						if (minCageTrap && ginCageTrap)//both in traps
						{
							if (gurin.hitTestObject(malon) ) //same trap
							{
								gspeed = air_acceleration;
								gfriction = air_friction;
								mspeed = air_acceleration;//move malon too
								mfriction = air_friction;//move malon too
								//TODO Sound effect
								return;

							}
							else //they are in 2 separate traps
							{
								gspeed = 0;
								gfriction = 0;
								TweenLite.to(malon, 1.4, { y:"-30", alpha:0} );
								TweenLite.to(gurin, 1.5, { y:"-30", alpha:0, onComplete:place_player } );
								Platform.isPaused = true;
								SoundManager.instance.playSound(new soundDeath());
								deathCounter++;
								return;
							}
						}
					}
					else if (current_tile == 47 && gleft_foot == 47 && gright_foot == 47) //pit, kills user resets
					{
						TweenLite.to(gurin, 1.5, { y:"-30", alpha:0, onComplete:place_player } );
						Platform.isPaused = true;
						SoundManager.instance.playSound(new soundDeath());
					}
					//place_player(); //die animation
				}
			}
			/*switch (current_tile) {
				case 0 :
				case 44 :
					gspeed = air_acceleration;
					gfriction = air_friction;
					break;
				case 1 :
					over = "ground";
					gspeed = ground_acceleration;
					gfriction = ground_friction;
					break;
				case 2 :
					over = "ice";
					gspeed = ice_acceleration;
					gfriction = ice_friction;
					break;
				case 3 :
					over = "treadmill";
					gspeed = ground_acceleration;
					gfriction = ground_friction;
					gbonus_speed = -treadmill_speed;  //left moving
					break;
				case 4 :
					over = "treadmill";
					gspeed = ground_acceleration;
					gfriction = ground_friction;
					gbonus_speed = treadmill_speed;  //right moving
					break;
				case 5 :
					over = "cloud";
					gspeed = ground_acceleration;
					gfriction = ground_friction;  //jump up able platform
					break;
				case 6 :
					over = "ladder";
					gspeed = ground_acceleration;
					gfriction = ground_friction;
					break;
					
				case 7 :
					over = "trampoline";
					gspeed = ground_acceleration;
					gfriction = ground_friction;
					break;
				case 8 :
					over = "spikes";
					if (gleft_foot == 8 && gright_foot == 8)
					{
						place_player();
					}
					break;
			}*/
			
			
			
			//below correct for all g -> m replacements
			if (mleft_foot != 0) {
				current_tile = mleft_foot;
			} else {
				current_tile = mright_foot;
			}
			if (LevelData.isGround(current_tile))
			{
				mspeed = air_acceleration;
				mfriction = air_friction;
				if (LevelData.isTrap(current_tile))
				{
					if (current_tile == 7) //water, slow down
					{
						mspeed = water_acceleration;
						mfriction = water_friction;
					}
					else if (current_tile == 46 && mleft_foot == 46 && mright_foot == 46) // cage, other has to tag user, swaps focus of camera
					{
						minCageTrap = true;
						mspeed = 0;
						mfriction = 0;
					}
					else if (current_tile == 47) //pit, kills user resets
					{
						TweenLite.to(malon, 1, { y:"-10", alpha:0.5, onComplete:place_player } );
						Platform.isPaused = true;
						SoundManager.instance.playSound(new soundDeath());
					}
				}
			}
			/*
			switch (current_tile) {
				case 0 :
				case 44 :
					mspeed = air_acceleration;
					mfriction = air_friction;
					break;
				case 1 :
					over = "ground";
					mspeed = ground_acceleration;
					mfriction = ground_friction;
					break;
				case 2 :
					over = "ice";
					mspeed = ice_acceleration;
					mfriction = ice_friction;
					break;
				case 3 :
					over = "treadmill";
					mspeed = ground_acceleration;
					mfriction = ground_friction;
					mbonus_speed = -treadmill_speed;  //left moving
					break;
				case 4 :
					over = "treadmill";
					mspeed = ground_acceleration;
					mfriction = ground_friction;
					mbonus_speed = treadmill_speed;  //right moving
					break;
				case 5 :
					over = "cloud";
					mspeed = ground_acceleration;
					mfriction = ground_friction;  //jump up able platform
					break;
				case 6 :
					over = "ladder";
					mspeed = ground_acceleration;
					mfriction = ground_friction;
					break;
					
				case 7 :
					over = "trampoline";
					mspeed = ground_acceleration;
					mfriction = ground_friction;
					break;
				case 8 :
					over = "spikes";
					if (mleft_foot == 8 && mright_foot == 8)
					{
						place_player();
					}
					break;
			}*/
			
			
		}
		
		public function check_collisions():void
		{
			//below correct for all g -> m replacements
			gurinYPos += gurinYSpeed;
			malonYPos += malonYSpeed;
			get_edges();

			
			
			if (gurinYSpeed>0) {
				if ((!LevelData.isGround(gbottom_right)/*gbottom_right != 0*/ && gbottom_right != playerLeftSide) || (!LevelData.isGround(gbottom_left)/*gbottom_left != 0*/ && gbottom_left != playerLeftSide)) {
					if (gbottom_right != playerRightSide && gbottom_left != playerRightSide) {
						if ((gbottom_right == 7 || gbottom_left == 7) && (Math.abs(gurinYSpeed)>1)) //this should never be triggered, since 7 is an unused tile
						{
							// trampoline
							gurinYSpeed *= -1;
							//jumping = true;
							//falling = true;
						}else {
							gurinYPos = gbottom*tile_size-playerBottomSide;
							gurinYSpeed = 0;
							//falling = false;
							//jumping = false;
							
						}
					} else {
						if (gprev_bottom<gbottom) {
							gurinYPos = gbottom*tile_size-playerBottomSide;
							gurinYSpeed = 0;
							//falling = false;
							//jumping = false;
							//TODO Predict down paths
						}
					}
				}
			}
						
			if (gurinYSpeed<0) {
				if ((!LevelData.isGround(gtop_right)/*gtop_right != 0*/ && gtop_right != playerRightSide && gtop_right != playerLeftSide) || (!LevelData.isGround(gtop_left)/*gtop_left != 0*/ && gtop_left != playerRightSide && gtop_left != playerLeftSide)) {
					gurinYPos = gbottom*tile_size+1+playerTopSide;
					gurinYSpeed = 0;
					//falling = false;
					//jumping = false;
					
					//TODO Predict up paths
				}
			}
			gurinXPos += gurinXSpeed;
			get_edges();
					 
			if (gurinXSpeed < 0) {
				if (!is_walkable(gtop_left) || !is_walkable(gbottom_left)) {
					gurinXPos = (gleft + 1) * tile_size + playerLeftSide;
					gurinXSpeed = 0;
					//TODO Predict left paths
				}
			}
											   
			if (gurinXSpeed>0) {
				if (!is_walkable(gtop_right) || !is_walkable(gbottom_right)) {
					gurinXPos = gright * tile_size - playerLeftSide;
					gurinXSpeed = 0;
					//TODO Predict right paths
				}
			}
			
			gprev_bottom = gbottom;
			
			
			
			
			
			
			///////////m part
			if (malonYSpeed>0) {
				if ((!LevelData.isGround(mbottom_right)/*mbottom_right != 0*/ && mbottom_right != playerLeftSide) || (!LevelData.isGround(mbottom_left)/*mbottom_left != 0*/ && mbottom_left != playerLeftSide)) {
					if (mbottom_right != playerRightSide && mbottom_left != playerRightSide) {
						if ((mbottom_right == 7 || mbottom_left == 7) && (Math.abs(malonYSpeed)>1))//this should never be triggered, since 7 is an unused tile
						{
							// trampoline
							malonYSpeed *= -1;
						}else {
							malonYPos = mbottom*tile_size-playerBottomSide;
							malonYSpeed = 0;
						}
					} else {
						if (mprev_bottom<mbottom) {
							malonYPos = mbottom*tile_size-playerBottomSide;
							malonYSpeed = 0;
							//TODO Predict down paths
						}
					}
				}
			}
						
			if (malonYSpeed<0) {
				if ((!LevelData.isGround(mtop_right)/*mtop_right != 0*/ && mtop_right != playerRightSide && mtop_right != playerLeftSide) || (!LevelData.isGround(mtop_left)/*mtop_left != 0*/ && mtop_left != playerRightSide && mtop_left != playerLeftSide)) {
					malonYPos = mbottom*tile_size+1+playerTopSide;
					malonYSpeed = 0;
					//TODO Predict up paths
				}
			}
			malonXPos += malonXSpeed;
			get_edges();
					 
			if (malonXSpeed < 0) {
				if (!is_walkable(mtop_left) || !is_walkable(mbottom_left)) {
					malonXPos = (mleft + 1) * tile_size + playerLeftSide;
					malonXSpeed = 0;
					//TODO Predict left paths
				}
			}
											   
			if (malonXSpeed>0) {
				if (!is_walkable(mtop_right) || !is_walkable(mbottom_right)) {
					malonXPos = mright * tile_size - playerLeftSide;
					malonXSpeed = 0;
					//TODO Predict right paths
				}
			}
			
			mprev_bottom = mbottom;
		}
		
		public function get_edges():void
		{
			gright = Math.floor((gurinXPos+playerRightSide)/tile_size);
			gleft = Math.floor((gurinXPos-playerLeftSide)/tile_size);
			gbottom = Math.floor((gurinYPos+playerBottomSide-1)/tile_size);
			gtop = Math.floor((gurinYPos-playerTopSide-1)/tile_size);

			gtop_right = level[gtop][gright];
			gtop_left = level[gtop][gleft];
			gbottom_left = level[gbottom][gleft];
			gbottom_right = level[gbottom][gright];
			
			trace(LevelData.isGround(gtop_left), LevelData.isGround(gtop_right), LevelData.isGround(gbottom_left), LevelData.isGround(gbottom_right));
			
			//TOP
			if (!LevelData.isGround(gtop_left) && LevelData.isGround(gtop_right))
			{
				gurinXPos+=correctionSpeed;
				gurin.x+=correctionSpeed;
			}
			if (LevelData.isGround(gtop_left) && !LevelData.isGround(gtop_right))
			{
				gurinXPos-=correctionSpeed;
				gurin.x-=correctionSpeed;
			}
			
			//BOTTOM
			if (!LevelData.isGround(gbottom_left) && LevelData.isGround(gbottom_right))
			{
				gurinXPos+=correctionSpeed;
				gurin.x+=correctionSpeed;
			}
			if (LevelData.isGround(gbottom_left) && !LevelData.isGround(gbottom_right))
			{
				gurinXPos-=correctionSpeed;
				gurin.x-=correctionSpeed;
			}
			
			//LEFT
			if (!LevelData.isGround(gbottom_left) && LevelData.isGround(gtop_left))
			{
				gurinYPos-=correctionSpeed;
				gurin.y-=correctionSpeed;
			}
			if (LevelData.isGround(gbottom_left) && !LevelData.isGround(gtop_left))
			{
				gurinYPos+=correctionSpeed;
				gurin.y+=correctionSpeed;
			}
			
			//RIGHT
			if (!LevelData.isGround(gbottom_right) && LevelData.isGround(gtop_right))
			{
				gurinYPos-=correctionSpeed;
				gurin.y-=correctionSpeed;
			}
			if (LevelData.isGround(gbottom_right) && !LevelData.isGround(gtop_right))
			{
				gurinYPos+=correctionSpeed;
				gurin.y+=correctionSpeed;
			}
			
			//below correct for all g -> m replacements
			mright = Math.floor((malonXPos+playerRightSide)/tile_size);
			mleft = Math.floor((malonXPos-playerLeftSide)/tile_size);
			mbottom = Math.floor((malonYPos+playerBottomSide-1)/tile_size);
			mtop = Math.floor((malonYPos-playerTopSide-1)/tile_size);

			mtop_right = level[mtop][mright];
			mtop_left = level[mtop][mleft];
			mbottom_left = level[mbottom][mleft];
			mbottom_right = level[mbottom][mright];
			
			//TOP
			if (!LevelData.isGround(mtop_left) && LevelData.isGround(mtop_right))
			{
				malonXPos+=correctionSpeed;
				malon.x+=correctionSpeed;
			}
			if (LevelData.isGround(mtop_left) && !LevelData.isGround(mtop_right))
			{
				malonXPos-=correctionSpeed;
				malon.x-=correctionSpeed;
			}
			
			//BOTTOM
			if (!LevelData.isGround(mbottom_left) && LevelData.isGround(mbottom_right))
			{
				malonXPos+=correctionSpeed;
				malon.x+=correctionSpeed;
			}
			if (LevelData.isGround(mbottom_left) && !LevelData.isGround(mbottom_right))
			{
				malonXPos-=correctionSpeed;
				malon.x-=correctionSpeed;
			}
			
			//LEFT
			if (!LevelData.isGround(mbottom_left) && LevelData.isGround(mtop_left))
			{
				malonYPos-=correctionSpeed;
				malon.y-=correctionSpeed;
			}
			if (LevelData.isGround(mbottom_left) && !LevelData.isGround(mtop_left))
			{
				malonYPos+=correctionSpeed;
				malon.y+=correctionSpeed;
			}
			
			//RIGHT
			if (!LevelData.isGround(mbottom_right) && LevelData.isGround(mtop_right))
			{
				malonYPos-=correctionSpeed;
				malon.y-=correctionSpeed;
			}
			if (LevelData.isGround(mbottom_right) && !LevelData.isGround(mtop_right))
			{
				malonYPos+=correctionSpeed;
				malon.y+=correctionSpeed;
			}
		}
		
		public function place_player():void
		{
			gurinXPos = (player[0] * tile_size) + (tile_size / 2);
			gurinYPos = (player[1] * tile_size) + (tile_size / 2 + 1);
			malonXPos = (player[2] * tile_size) + (tile_size / 2);
			malonYPos = (player[3] * tile_size) + (tile_size / 2 + 1);
			
			gurin.x = gurinXPos;
			gurin.y = gurinYPos;
			gurin.alpha = 1;
			ginCageTrap = false;
			
			malon.x = malonXPos
			malon.y = malonYPos;
			if(LevelData.currentLevel != 0)
				malon.alpha = 1;
			minCageTrap = false;
			
			if (LevelData.currentLevel == 0)
			{
				staticWizard.x = tile_size * 8;
				staticWizard.y = tile_size * 5;
				level_container.addChild(staticWizard);
			}
			else if (staticWizard.parent != null)
			{
				staticWizard.destroy();
			}
			
			Platform.isPaused = false;
		}
		
		public function is_walkable(tile:int):Boolean {
			return LevelData.isGround(tile);
			
			
			
			
			var walkable:Boolean = false;
			for (var i:int = 0; i < walkable_tiles.length; i++)
			{
				if (tile == walkable_tiles[i])
				{
					walkable = true;
					break;
				}
			}
			
			return (walkable);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function gotoLevelScore():void
		{
			LevelData.currentLevel++;
			SaveSystem.getCurrentSlot().write("CurrentLevel", LevelData.currentLevel);
			
			scoreWindow = new LevelScore(this, frameCounter,bulletCounter,10001,1000);
			stage.addChild(scoreWindow);
			TransitionHandler.startDiamondTween(scoreWindow, null);
			
			Platform.isPaused = true;
		}
		
		public function gotoNextLevelFromLevelScore(e:MouseEvent):void
		{
			TransitionHandler.startDiamondTween(scoreWindow, function():void { Platform.isPaused = false; scoreWindow.kill(); } , false);
			rebuildLevel();
		}
		public function gotoReplayLevelFromLevelScore(e:MouseEvent):void
		{
			LevelData.currentLevel--;
			TransitionHandler.startDiamondTween(scoreWindow, function():void { Platform.isPaused = false; scoreWindow.kill(); } , false);
			rebuildLevel();
		}
		
		
		
		
		
		
		
		
		
		
		public function rebuildLevel():void
		{
			LevelData.retrieveLevel(level, LevelData.currentLevel);
			var level_height:Number = level.length;
			var level_width:Number = level[0].length;
			
			
			for (var j:Number = 0; j<level_height; j++)
			{
				for (var i:Number = 0; i<level_width; i++)
				{
					levelObj[j][i].gotoAndStop(level[j][i] + 1);
				}
			}
			
			var stack:Array = [];
			for (j = 0; j<level_height; j++) //ground, traps
			{
				for (i = 0; i<level_width; i++)
				{
					if (LevelData.isTrap(level[j][i])|| LevelData.isGround(level[j][i])) 
					//if (Platform.trapTiles.indexOf(l[j][i]) != -1) 
					{ 
						
						stack.push(levelObj[j][i]);
					}
				}
			}
			for (j = 0; j<level_height; j++) //everything else
			{
				for (i = 0; i<level_width; i++)
				{
					//if (Platform.trapTiles.indexOf(l[j][i]) == -1)stack.push(levelObj[j][i]);
					if (!LevelData.isTrap(level[j][i])&& !LevelData.isGround(level[j][i])) stack.push(levelObj[j][i]);
				}
			}
			for (j = 0; j < stack.length; j++)
			{
				level_container.setChildIndex(stack[j], level_container.numChildren-1);
			}
			level_container.setChildIndex(malon, level_container.numChildren-1);
			level_container.setChildIndex(gurin, level_container.numChildren-1);
			level_container.setChildIndex(crystal, level_container.numChildren-1);
			place_player();
			coins = [crystal];
			if(LevelData.currentLevel != 0) //if its not level 0, move to correct location
				crystal.y = tile_size;
			frameCounter = 0;
			bulletCounter = 0;
			/*
			for (var m:int = 0; m < coins.length; m++)
			{
				var c:coin = new coin();
				c.x = coins[m][0] * tile_size + tile_size / 2;
				c.y = coins[m][1] * tile_size + tile_size/2 + 1;
				
				coins[m] = c;
				level_container.addChild(coins[m]);
			}
			for (var n:int = 0; n < keys.length; n++)
			{
				var _k:key = new key();
				_k.x = keys[n][0] * tile_size + tile_size / 2;
				_k.y = keys[n][1] * tile_size + tile_size / 2 + 1;
				_k.openX = keys[n][2];
				_k.openY = keys[n][3];
				keys[n] = _k;
				level_container.addChild(keys[n]);
			}
			
			for (var k:int = 0; k < enemy.length; k++)
			{
				var foe:patrol = new patrol();
				foe.speed = enemy[k][2];
				foe.x = enemy[k][0] * tile_size + tile_size / 2;
				foe.y = enemy[k][1] * tile_size + tile_size / 2 + 1;
				
				enemy[k] = foe;
				level_container.addChild(enemy[k]);
			}
			*/
		}
		
		
		
		
		
		
		
		
		
		public function kill():void
		{
			var i:int = 0;
			for (i = 0; i < coins.length; i++)
			{
				if (coins[i].parent)
					coins[i].parent.removeChild(coins[i]);
			}
			for (i = 0; i < levelObj.length; i++)
			{
				if (levelObj[i].parent)
					levelObj[i].parent.removeChild(levelObj[i]);
			}
			for (i = 0; i < keys.length; i++)
			{
				if (keys[i].parent)
					keys[i].parent.removeChild(keys[i]);
			}
			
			level.length = 0;
			coins.length = 0;
			levelObj.length = 0;
			keys.length = 0;
			
			while (level_container.numChildren > 0)
			{
				level_container.removeChildAt(0);
			}
			
			gurin.destroy();
			gurin = null;
			malon.destroy();
			malon = null;
			crystal.destroy();
			crystal = null;
			
			hud.kill();
			hud = null;
			
			scoreWindow.kill();
			scoreWindow = null;
			
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			level_container.removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
			level_container.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			
			parent.removeChild(this);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		/*
		
		public function endGame():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, key_down);
			stage.removeEventListener(KeyboardEvent.KEY_UP, key_up);
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var scoreFrames:PlayerScore = new PlayerScore();
			scoreFrames.Name = ((Math.random() * 90)>>0) + "test";
			scoreFrames.Points = frameCounter;
			Leaderboards.Save(scoreFrames, "Frames", null, null);
			
			var scoreCoins:PlayerScore = new PlayerScore();
			scoreCoins.Name = scoreFrames.Name;
			scoreCoins.Points = coinCounter;
			Leaderboards.Save(scoreCoins, "Coins", null, null);
			
			var scoreCombo:PlayerScore = new PlayerScore();
			scoreCombo.Name = scoreFrames.Name;
			scoreCombo.Points = (999999999-coinCounter)*1.5 + (frameCounter)*2;
			Leaderboards.Save(scoreCombo, "Combo", null, null);
			
			finalTimeWindow = new PWindowExtra(300, 300, "You beat the level in\n" + frameCounter + "\nframes with\n" + coinCounter + "\ncoins!", closeTimeWindow, backToMenu, "Highscores", viewHighScores);
			finalTimeWindow.y = stage.stageHeight / 2;
			stage.addChild(finalTimeWindow);
			
			PAnimation.centerWindow(finalTimeWindow);
			PAnimation.fadeInWindow(finalTimeWindow);
		}
		
		public function viewHighScores(e:MouseEvent):void
		{
			Leaderboards.List("Combo", loadedHighScores,{perpage:50, highest:false});
			
			highScoresWindow = new PScrollingContentWindow(300, 300, "= HighScores =", "Loading Scores", closeHighScoreWindow);
			highScoresWindow.x = stage.stageWidth / 2;
			highScoresWindow.y = stage.stageHeight / 2;
			stage.addChild(highScoresWindow);
			PAnimation.fadeInWindow(highScoresWindow);
		}
		
		public function loadedHighScores(scores:Array, numscores:int, response:Object):void
		{
			if (!highScoresWindow || highScoresWindow.parent == null) return;
			
			if(response.Success)
			{
				trace(scores.length + " scores returned out of " + numscores);
				highScoresWindow.notification.defaultTextFormat = new TextFormat("Arial", 12,null,null,null,null,null,null,'left');
				highScoresWindow.notification.text = "Rank      Score               User\n";
				for(var i:int=0; i<scores.length; i++)
				{
					var score:PlayerScore = scores[i];
					
					highScoresWindow.notification.appendText(getFormattedScore(score,i+1));
					//highScoresWindow.notification.appendText("  " + (i+1) + "\t\t" + score.Name + "\t\t\t\t" + score.Points + "\n");
					trace(" - " + score.Name + " got " + score.Points + " on " + score.SDate);
					
					// including custom data?  score.CustomData["property"]
				}
				highScoresWindow.notification.appendText("\n  ");
			}
			else
			{
				// score listing failed because of response.ErrorCode
				highScoresWindow.notification.appendText("Error: " + response.ErrorCode);
			}
		}
		
		public function getFormattedScore(score:PlayerScore, num:int):String
		{
			var s:String = "";
			s += "  ";
			s += num;
			if (num < 10) s += "  ";
			s += "          ";
			s += score.Points;
			if (score.Points < 100) s += "  ";
			if (score.Points < 1000) s += "  ";
			if (score.Points < 10000) s += "  ";
			s += "          ";
			s += score.Name.substr(0, 20);
			s += "\n";
			return s;
		}
		
		public function closeHighScoreWindow(e:MouseEvent):void
		{
			PAnimation.fadeOutWindow(highScoresWindow, killHighScoresWindow );
		}
		
		public function killHighScoresWindow():void
		{
			highScoresWindow.kill()
			highScoresWindow = null;
		}
		
		public function backToMenu(e:MouseEvent):void
		{
			var i:int = 0;
			for (i = 0; i < coins.length; i++)
			{
				if (coins[i].parent)
					coins[i].parent.removeChild(coins[i]);
			}
			for (i = 0; i < levelObj.length; i++)
			{
				if (levelObj[i].parent)
					levelObj[i].parent.removeChild(levelObj[i]);
			}
			for (i = 0; i < keys.length; i++)
			{
				if (keys[i].parent)
					keys[i].parent.removeChild(keys[i]);
			}
			
			level.length = 0;
			coins.length = 0;
			levelObj.length = 0;
			keys.length = 0;
			
			while (level_container.numChildren > 0)
			{
				level_container.removeChildAt(0);
			}
			
			gurin = null;
			crystal = null;
			
			stage.removeChild(hud);
			hud = null;
			
			
			PAnimation.moveWindowRight(finalTimeWindow, stage.stageWidth / 2);
			PAnimation.fadeOutWindow(finalTimeWindow, createMenu);
		}
		
		public function createMenu():void
		{
			var m:MainMenu = new MainMenu();
			stage.addChild(m);
			parent.removeChild(this);
		}
		
		public function closeTimeWindow(e:MouseEvent):void
		{
			PAnimation.moveWindowRight(finalTimeWindow, stage.stageWidth / 2);
			PAnimation.fadeOutWindow(finalTimeWindow, startGame);
			
			leftPressed = false;
			rightPressed = false;
			upPressed = false
			downPressed = false;
			spacePressed = false;
			falling = false;
			climbing = false;
			gurinXSpeed = gurinYSpeed = 0;
			malonXSpeed = malonYSpeed = 0;
			
			var i:int = 0;
			for (i = 0; i < coins.length; i++)
			{
				level_container.addChild(coins[i]);
			}
			
			place_player();
			onEnterFrame();
		}
		*/
	}
}
