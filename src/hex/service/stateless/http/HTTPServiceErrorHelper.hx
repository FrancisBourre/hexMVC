package hex.service.stateless.http;

import haxe.Timer;
import hex.model.ModelDispatcher;
import hex.service.stateless.StatelessServiceMessage;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPServiceErrorHelper
{
	var _dispatcher 	: HTTPServiceErrorHelperDispatcher;
	var _service 		: HTTPService<HTTPServiceConfiguration>;
	var _timer 			: Timer;
	
	var _timeout 		: UInt;
	var _retryCount 	: UInt;
	var _retryMaxCount 	: UInt;
	
	public function new( service : HTTPService<HTTPServiceConfiguration>, retryMaxCount : UInt = 3, timeout : UInt = 5000 )
	{
		this._dispatcher	= new HTTPServiceErrorHelperDispatcher();
		this._service 		= service;
		this._timeout 		= timeout;
		this._retryMaxCount = retryMaxCount;
		this._retryCount	= 0;
	}
	
	public function addListener( listener : IHTTPServiceErrorHelperListener<Dynamic> ) : Bool
	{
		return this._dispatcher.addListener( listener );
	}
	
	public function removeListener( listener : IHTTPServiceErrorHelperListener<Dynamic> ) : Bool
	{
		return this._dispatcher.removeListener( listener );
	}
	
	public function stopTimer() : Void
	{
		if ( this._timer != null )
		{
			this._timer.stop();
		}
	}
	
	public function retry() : Bool
	{
		this.stopTimer();
		
		if ( this._retryCount < this._retryMaxCount )
		{
			this._retryCount++;
			this._startTimer();
			return true;
		}
		else
		{
			this._release();
			return false;
		}
	}
	
	function _startTimer() : Void
	{
		this.stopTimer();
		Timer.delay( this._retry, this._timeout );
	}
	
	function _retry() : Void
	{
		if ( !this._service.hasCompleted )
		{
			this._service.addHandler( StatelessServiceMessage.COMPLETE, this, this._onServiceComplete );
			this._service.call();
		}
		else
		{
			this._release();
		}
	}
	
	function _onServiceComplete( service : HTTPService<HTTPServiceConfiguration> ) : Void
	{
		this._release();
	}
	
	function _release() : Void
	{
		this._dispatcher.onReleaseHelper( this._service );
	}
}

class HTTPServiceErrorHelperDispatcher extends ModelDispatcher<IHTTPServiceErrorHelperListener<Dynamic>> implements IHTTPServiceErrorHelperListener<Dynamic>
{
	public function onReleaseHelper( service : Dynamic ) : Void
	{
		
	}
}