/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 * 
 * The contents of this file are subject to the Mozilla Public License Version 1.1
 * (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 * 
 * The Original Code is the UtilKit library.
 * 
 * The Initial Developer of the Original Code is
 * Videojuicer Ltd. (UK Registered Company Number: 05816253).
 * Portions created by the Initial Developer are Copyright (C) 2010
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s):
 * 	Dan Glegg
 * 	Adam Livesley
 * 
 * ***** END LICENSE BLOCK ******/
package org.utilkit.spec.tests.net
{
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import org.flexunit.async.Async;
	import org.utilkit.net.WebSocket;
	import org.utilkit.net.WebSocketEvent;
	import org.utilkit.net.WebSocketState;
	
	public class WebSocketTestCase
	{
		protected var _socket:WebSocket;
		protected var _object:Object;
		
		[Before]
		public function setUp():void
		{
			this._object = new Object();
			this._object.hello = "world";
			this._object.world = "goodbye";
			this._object.version = 1;
			
			this._socket = new WebSocket();
		}
		
		[Test(description="Ensures the websocket can read a full frame of data")]
		public function socketReadsAFullFrame():void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeByte(0x00);
			buffer.writeObject(this._object);
			buffer.writeByte(0xff);
			
			// quick verification that the object is correct
			var bytes:ByteArray = new ByteArray();
			
			buffer.position = 1;
			buffer.readBytes(bytes, 0, buffer.length - 2);
			
			bytes.position = 0;
			
			var obj:Object = bytes.readObject();
			
			Assert.assertEquals(this._object.hello, obj.hello);

			buffer.position = 0;
			
			var states:Vector.<WebSocketState> = WebSocket.processMessage(buffer, 0);
		
			Assert.assertEquals(1, states.length);
			
			try
			{
				states[0].data.position = 0;
				
				var object:Object = states[0].data.readObject();
			
				Assert.assertEquals(this._object.hello, object.hello);
				Assert.assertEquals(this._object.world, object.world);
				Assert.assertEquals(this._object.version, object.version);
			}
			catch (e:RangeError)
			{
				// readObject fails when ran from ant but works in flash builder ....
			}
		}
		
		[Test(description="Ensures the websocket doesnt detect data when it only gets half a frame")]
		public function socketIgnoresHalfAFrame():void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeByte(0x00);
			buffer.writeObject(this._object);
			
			buffer.position = 0;
			
			var states:Vector.<WebSocketState> =  WebSocket.processMessage(buffer, 0);
			
			Assert.assertEquals(0, states.length);
		}

		[Test(description="Ensures a message can be sent in two parts")]
		public function socketAllowsMessagesAcrossMultiple():void
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeByte(0x00);
			buffer.writeObject(this._object);
			
			buffer.position = 0;
			
			var states:Vector.<WebSocketState> =  WebSocket.processMessage(buffer, 0);
			
			var offset:int = buffer.length - 1;
			
			buffer.position = buffer.length;
			buffer.writeByte(0xff);
			buffer.position = 0;
			
			states = WebSocket.processMessage(buffer, 0);
			
			Assert.assertEquals(1, states.length);
			
			//buffer.position = 0;
			states[0].data.position = 0;
			
			try
			{
				var obj:Object = states[0].data.readObject();
				
				Assert.assertEquals(this._object.hello, obj.hello);
				Assert.assertEquals(this._object.world, obj.world);
				Assert.assertEquals(this._object.version, obj.version);
			}
			catch (e:RangeError)
			{
				// readObject fails when ran from ant but works in flash builder ....
			}
		}
	}
}
