package org.utilkit.util
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.system.System;
	
	import org.utilkit.UtilKit;

	public class Environment
	{
		protected static var __stageRoot:Stage;
		
		public static function attachToStageRoot(stage:Stage):void
		{
			Environment.__stageRoot = stage;
		}
		
		public static function get embeddedURL():String
		{
			var location:String = Environment.callExternalMethod("document.location.toString") as String;
			
			return location;
		}
		
		public static function get embeddedHostname():String
		{
			var hostname:String = Environment.callExternalMethod("document.location.hostname.toString") as String;
			
			if (hostname == null || hostname == "")
			{
				var embeddedURL:String = Environment.embeddedURL;
				
				if (embeddedURL != null && embeddedURL.indexOf("file://") != -1)
				{
					hostname = "localhost";
				}
			}
			
			if (hostname == null)
			{
				hostname = "unknown";
			}
			
			return hostname;
		}
		
		public static function get userAgent():String
		{
			var agent:String = Environment.callExternalMethod("navigator.userAgent.toString") as String;
			
			if (agent == null)
			{
				agent = "unknown";
			}
			
			return agent;
		}
		
		public static function callExternalMethod(method:String):*
		{
			var result:* = null;
			
			if (ExternalInterface.available)
			{
				try
				{
					result = ExternalInterface.call(method);
				}
				catch (e:Error)
				{
					
				}
				catch (e:SecurityError)
				{
					
				}
			}
			
			return result;
		}
		
		public static function openWindow(request:URLRequest, target:String = "_blank"):void
		{
			if (Environment.inFullscreenMode)
			{
				UtilKit.logger.warn("Opening URL in browser, but currently running in fullscreen mode. Dropping down to window mode now ...");
				
				Environment.toggleScreenMode(true);
			}
			
			navigateToURL(request, target);
		}
		
		public static function copyToClipboard(text:String):void
		{
			System.setClipboard(text);
		}
		
		public static function openWindowUrl(url:String, target:String = "_blank"):void
		{	
			Environment.openWindow(new URLRequest(url), target);
		}
		
		public static function get inFullscreenMode():Boolean
		{
			return (Environment.__stageRoot != null && Environment.__stageRoot.displayState == StageDisplayState.FULL_SCREEN);
		}
		
		public static function get inWindowMode():Boolean
		{
			return (Environment.__stageRoot != null && Environment.__stageRoot.displayState == StageDisplayState.NORMAL);
		}
		
		public static function get screenSize():String
		{
			return Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY;
		}
		
		public static function get language():String
		{
			return Capabilities.language;
		}
		
		public static function get cpuArchitecture():String
		{
			var architecture:String = "unknown";
			
			// cpuArchitecture property can return the following strings: "PowerPC", "x86", "SPARC", and "ARM". The server string is ARCH.
			// alpha, arm, arm32, hppa1.1, m68k, mips, ppc, rs6000, vax, x86, unknown.
			switch (Capabilities.cpuArchitecture)
			{
				case "PowerPC":
					architecture = "ppc";
					break;
				case "x86":
					architecture = "x86";
					break;
				case "x64":
					architecture = "x64";
					break;
				case "SPARC":
					architecture = "mips";
					break;
				case "ARM":
					architecture = "arm";
					break;
			}
			
			return architecture;
		}
		
		public static function get operatingSystem():String
		{
			var operatingSystem:String = "unknown";
			
			// [Read Only] Specifies the current operating system. The os property can return the following strings: "Windows XP", "Windows 2000", "Windows NT", "Windows 98/ME", "Windows 95", "Windows CE" (available only in Flash Player SDK, not in the desktop version), "Linux", and "Mac OS X.Y.Z" (where X.Y.Z is the version number, for example: Mac OS 10.5.2). The server string is OS.
			// Do not use Capabilities.os to determine a capability based on the operating system if a more specific capability property exists. Basing a capability on the operating system is a bad idea, since it can lead to problems if an application does not consider all potential target operating systems. Instead, use the property corresponding to the capability for which you are testing. For more information, see the Capabilities class description.
			
			var os:String = Capabilities.os;
			var sections:Array = os.split(" ");
			
			switch (sections[0])
			{
				case "Linux":
					operatingSystem = "linux";
					break;
				case "Mac":
					operatingSystem = "macos";
					break;
				case "iPhone":
					operatingSystem = "arm32";
					break;
				case "Windows":
					var windows:String = sections.slice(1).join(" ");
					
					operatingSystem = "win";
					
					switch (windows)
					{
						case "Mobile":
							operatingSystem = "";
							break;
						case "CEPC":
							operatingSystem = "";
							break;
						case "PocketPC":
							operatingSystem = "";
							break;
						case "SmartPhone":
							operatingSystem = "";
							break;
						case "CE":
							operatingSystem = "win16";
							break;
						case "ME":
							operatingSystem = "win16";
							break;
						case "2000":
							operatingSystem = "winnt";
							break;
						case "NT":
							operatingSystem = "winnt";
							break;
						case "95":
							operatingSystem = "win9x";
							break;
						case "98":
							operatingSystem = "win9x";
							break;
						case "XP":
							operatingSystem = "";
							break;
						case "XP 64":
							operatingSystem = "";
							break;
						case "Server 2003":
							operatingSystem = "";
							break;
						case "Server 2003 R2":
							operatingSystem = "";
							break;
						case "Home Server":
							operatingSystem = "";
							break;
						case "Server 2008":
							operatingSystem = "";
							break;
						case "Server 2008 R2":
							operatingSystem = "";
							break;
						case "Vista":
							operatingSystem = "";
							break;
						case "7":
							operatingSystem = "";
							break;
					}
					break;
			}
			
			return operatingSystem;
		}
		
		public static function toggleScreenMode(exceptFullscreen:Boolean = false):void
		{
			if (Environment.__stageRoot != null)
			{
				var stage:Stage = Environment.__stageRoot;
				
				stage.fullScreenSourceRect = null;
				
				if(stage.displayState == StageDisplayState.FULL_SCREEN)
				{
					stage.displayState = StageDisplayState.NORMAL;
				}
				else if (!exceptFullscreen)
				{
					stage.displayState = StageDisplayState.FULL_SCREEN;
				}
			}
		}
	}
}