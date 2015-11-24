package hex.service.stateless.http;

import haxe.Http;
import hex.core.IMetaDataParsable;
import hex.service.stateless.AsyncStatelessService;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPService<EventClass:ServiceEvent, ConfigurationClass:ServiceConfiguration> extends AsyncStatelessService<EventClass, ConfigurationClass> implements IHTTPService<EventClass, ConfigurationClass> implements IURLConfigurable implements IMetaDataParsable
{
	private function new() 
	{
		super();
	}
	
	private var _request 			: Http;
	private var _excludedParameters : Array<String>;
	private var _timestamp 			: Float;

	override public function call() : Void
	{
		this._timestamp = Date.now().getTime ();
		this._createRequest();
		super.call();
		this._request.request( ( cast this._configuration ).requestMethod == HTTPRequestMethod.POST );
	}
	
	private function _createRequest() : Void
	{
		this._request = new Http( ( cast this._configuration ).serviceUrl );
		
		( cast this._configuration ).parameterFactory.setParameters( this._request, ( cast this._configuration ).parameters, _excludedParameters );
		this.timeoutDuration = ( cast this.getConfiguration() ).serviceTimeout;
		
		this._request.async 		= true;
		this._request.onData 		= this._onData;
		this._request.onError 		= this._onError;
		this._request.onStatus 		= this._onStatus;
		
		var requestHeaders : Array<HTTPRequestHeader> = ( cast this._configuration ).requestHeaders;
		if ( requestHeaders != null )
		{
			for ( header in requestHeaders )
			{
				this._request.addHeader ( header.name, header.value );
			}
		}
	}

	public function setExcludedParameters( excludedParameters : Array<String> ) : Void
	{
		this._excludedParameters = excludedParameters;
	}

	public var url( get, null ) : String;
	public function get_url() : String
	{
		return ( cast this._configuration ).serviceUrl;
	}
	
	public var method( get, null ) : HTTPRequestMethod;
	public function get_method() : HTTPRequestMethod
	{
		return ( cast this._configuration ).requestMethod;
	}
	
	public var dataFormat( get, null ) : String;
	public function get_dataFormat() : String
	{
		return ( cast this._configuration ).dataFormat;
	}
	
	public var timeout( get, null ) : UInt;
	public function get_timeout() : UInt
	{
		return ( cast this._configuration ).serviceTimeout;
	}

	override public function release() : Void
	{
		if ( this._request != null )
		{
			this._request.onData 	= null;
			this._request.onError 	= null;
			this._request.onStatus 	= null;
			
			this._request.cancel();
		}

		super.release();
	}

	public function setParameters( parameters : HTTPServiceParameters ) : Void
	{
		( cast this._configuration ).parameters = parameters;
	}

	public function getParameters() : HTTPServiceParameters
	{
		return ( cast this._configuration ).parameters;
	}

	public function addHeader( header : HTTPRequestHeader ) : Void
	{
		( cast this._configuration ).requestHeaders.push( header );
	}

	override private function _getRemoteArguments() : Array<Dynamic>
	{
		this._createRequest();
		return [ this._request ];
	}

	private function _onData( result : String ) : Void
	{
		this._onResultHandler( result );
	}

	private function _onError( msg : String ) : Void
	{
		this._onErrorHandler( msg );
	}
	
	private function _onStatus( status : Int ) : Void
	{
		//trace( "_onStatus:", status );
	}

	public function setURL( url : String ) : Void
	{
		( cast this._configuration ).serviceUrl = url;
	}
	
	/**
     * Event handling
     */
	public function addHTTPServiceListener( listener : IHTTPServiceListener<EventClass> ) : Void
	{
		this._ed.addEventListener( StatelessServiceEventType.COMPLETE, listener.onServiceComplete );
		this._ed.addEventListener( StatelessServiceEventType.FAIL, listener.onServiceFail );
		this._ed.addEventListener( StatelessServiceEventType.CANCEL, listener.onServiceCancel );
		this._ed.addEventListener( AsyncStatelessServiceEventType.TIMEOUT, listener.onServiceTimeout );
	}

	public function removeHTTPServiceListener( listener : IHTTPServiceListener<EventClass> ) : Void
	{
		this._ed.removeEventListener( StatelessServiceEventType.COMPLETE, listener.onServiceComplete );
		this._ed.removeEventListener( StatelessServiceEventType.FAIL, listener.onServiceFail );
		this._ed.removeEventListener( StatelessServiceEventType.CANCEL, listener.onServiceCancel );
		this._ed.removeEventListener( AsyncStatelessServiceEventType.TIMEOUT, listener.onServiceTimeout );
	}
}