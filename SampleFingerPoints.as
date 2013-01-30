package {
	import com.leapmotion.leap.*;
	import com.leapmotion.leap.util.*;
	import com.leapmotion.leap.events.*;
	import flash.display.Sprite;

	public class SampleFingerPoints extends Sprite {
		private var leap:LeapMotion;

		// Set up plenty of "pointables" to use as a pool for rendering to avoid costs of multiple dynamic instantiations of movieclips
		// actually create a couple extra pointables to account for two hands, some pointers and Polydactyl users ;)
		private var pointerTip_0:fingerTip = new fingerTip();
		private var pointerTip_1:fingerTip = new fingerTip();
		private var pointerTip_2:fingerTip = new fingerTip();
		private var pointerTip_3:fingerTip = new fingerTip();
		private var pointerTip_4:fingerTip = new fingerTip();
		private var pointerTip_5:fingerTip = new fingerTip();
		private var pointerTip_6:fingerTip = new fingerTip();
		private var pointerTip_7:fingerTip = new fingerTip();
		private var pointerTip_8:fingerTip = new fingerTip();
		private var pointerTip_9:fingerTip = new fingerTip();
		private var pointerTip_10:fingerTip = new fingerTip();
		private var pointerTip_11:fingerTip = new fingerTip();
		private var pointerTip_12:fingerTip = new fingerTip();
		private var pointerTip_13:fingerTip = new fingerTip();
		private var pointerTip_14:fingerTip = new fingerTip();
		private var pointerTip_15:fingerTip = new fingerTip();
		private var pointerTip_16:fingerTip = new fingerTip();
		private var pointerTip_17:fingerTip = new fingerTip();
		private var pointerTip_18:fingerTip = new fingerTip();
		private var pointerTip_19:fingerTip = new fingerTip();
		private var pointerTip_20:fingerTip = new fingerTip();

		private var pointablesContainer:Sprite = new Sprite();

		private var activeItems_arr:Array = [];
		private var posZ:Number = 0;
		private var posX:Number = 0;
		private var posY:Number = 0;
		
		private var fingerLoop:uint = 0;
		private var handLoop:uint = 0;
		private var pointerCount:uint =0;
		
		private var item:Object;

		public function SampleFingerPoints () {
			leap = new LeapMotion();
			leap.controller.addEventListener ( LeapEvent.LEAPMOTION_INIT, onInit );
			leap.controller.addEventListener ( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
			leap.controller.addEventListener ( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
			leap.controller.addEventListener ( LeapEvent.LEAPMOTION_EXIT, onExit );
			leap.controller.addEventListener ( LeapEvent.LEAPMOTION_FRAME, onFrame );
		}

		private function onInit ( event:LeapEvent ):void {
			trace ( "Initialized" );

			addChild (pointablesContainer);

			pointablesContainer.addChild (pointerTip_0);
			pointablesContainer.addChild (pointerTip_1);
			pointablesContainer.addChild (pointerTip_2);
			pointablesContainer.addChild (pointerTip_3);
			pointablesContainer.addChild (pointerTip_4);
			pointablesContainer.addChild (pointerTip_5);
			pointablesContainer.addChild (pointerTip_6);
			pointablesContainer.addChild (pointerTip_7);
			pointablesContainer.addChild (pointerTip_8);
			pointablesContainer.addChild (pointerTip_9);
			pointablesContainer.addChild (pointerTip_10);
			pointablesContainer.addChild (pointerTip_11);
			pointablesContainer.addChild (pointerTip_12);
			pointablesContainer.addChild (pointerTip_13);
			pointablesContainer.addChild (pointerTip_14);
			pointablesContainer.addChild (pointerTip_15);
			pointablesContainer.addChild (pointerTip_16);
			pointablesContainer.addChild (pointerTip_17);
			pointablesContainer.addChild (pointerTip_18);
			pointablesContainer.addChild (pointerTip_19);
			pointablesContainer.addChild (pointerTip_20);

		}

		private function onConnect ( event:LeapEvent ):void {
			trace ( "Connected" );
		}

		private function onDisconnect ( event:LeapEvent ):void {
			trace ( "Disconnected" );
		}

		private function onExit ( event:LeapEvent ):void {
			trace ( "Exited" );
		}

		public function drawPointables (frame:Object):void {

			fingerLoop = 0;
			handLoop = 0;
			
			
			pointerCount = frame.fingers.length;
			
			
			// reset arrays (refactor to vectors for speed) and remove all unused pointers
			activeItems_arr.length = 0;
			removePointerTips (pointerCount);

			if (pointerCount>=1) {

				for (fingerLoop = 0; fingerLoop<=pointerCount-1; fingerLoop++) {
					item = this["pointerTip_" + fingerLoop];
					activeItems_arr.push (item);
				
					pointablesContainer.addChild (activeItems_arr[fingerLoop]);
					
					posX = 0;
					posY = 0;
					posZ = 0;
					this["pointerTip_" + fingerLoop].visible = true;

					
					posX = parseFloat(frame.fingers[fingerLoop].tipPosition.x)
					posY = parseFloat(frame.fingers[fingerLoop].tipPosition.y);
					// revisit this to add real depth and not psuedo scaled depth - true 3D next!
					posZ = 4 + parseFloat(frame.fingers[fingerLoop].tipPosition.z) / 20 * 1;//z
					// keep the pseudo scale from getting too small 
					if (posZ<.5) {
						posZ = .5;
					}

					// Revisit scaling to adjust dimensions - perhaps allow for calibration of
					// min/max rect, etc. - but for now position them x,y and scaleX,scaleY to simulate z depth
					this["pointerTip_" + fingerLoop].x=stage.stageWidth/2-(posX/stage.stageWidth)*-(stage.stageWidth*2);
					this["pointerTip_" + fingerLoop].y=470-(posY)*1.25;//470
					this["pointerTip_" + fingerLoop].scaleX = posZ;
					this["pointerTip_" + fingerLoop].scaleY = posZ;

				}
			}
			


		}

		public function removePointerTips (pointerCount:Number):void {
			// Need to add intelligence to only remove pointers with unused ID's to make more efficient
			while (pointablesContainer.numChildren > 0) {
				pointablesContainer.removeChildAt (0);
			}
		}

		private function onFrame ( event:LeapEvent ):void {
			// Get the most recent frame and report some basic information
			var frame:Frame = event.frame;
			
			drawPointables(frame);
			
			//trace ( "Frame id: " + frame.id + ", timestamp: " + frame.timestamp + ", hands: " + frame.hands.length + ", fingers: " + frame.fingers.length + ", tools: " + frame.tools.length );

			/*if (frame.hands.length > 0) {
				// Get the first hand
				var hand:Hand = frame.hands[0];
				
				

				// Check if the hand has any fingers
				var fingers:Vector.<Finger >  = hand.fingers;
				if (! fingers.length == 0) {
					// Calculate the hand's average finger tip position
					var avgPos:Vector3 = Vector3.zero();
					for each (var finger:Finger in fingers) {
						avgPos = avgPos.plus(finger.tipPosition);
					}

					avgPos = avgPos.divide(fingers.length);
					trace ( "Hand has " + fingers.length + " fingers, average finger tip position: " + avgPos );
				}

				// Get the hand's sphere radius and palm position
				trace ( "Hand sphere radius: " + hand.sphereRadius + " mm, palm position: " + hand.palmPosition );

				// Get the hand's normal vector and direction
				var normal:Vector3 = hand.palmNormal;
				var direction:Vector3 = hand.direction;

				// Calculate the hand's pitch, roll, and yaw angles
				trace ( "Hand pitch: " + LeapMath.toDegrees( direction.pitch ) + " degrees, " + "roll: " + LeapMath.toDegrees( normal.roll ) + " degrees, " + "yaw: " + LeapMath.toDegrees( direction.yaw ) + " degrees\n" );
			}*/
		}
	}
}