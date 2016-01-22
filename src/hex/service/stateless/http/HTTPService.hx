package hex.service.stateless.http;

import haxe.Http;
import hex.core.IAnnotationParsable;
import hex.log.Stringifier;
import hex.service.stateless.AsyncStatelessService;

/**
 * ...
 * @author Francis Bourre
 */
class HTTPService<ServiceConfigurationType:HTTPServiceConfiguration> extends AsyncStatelessService<ServiceConfigurationType> implements IHTTPService<ServiceConfigurationType> implements IURLConfigurable implements IAnnotationParsable
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
		this._request.request( this._configuration.requestMethod == HTTPRequestMethod.POST );
	}
	
	private function _createRequest() : Void
	{
		this._request = new Http( this._configuration.serviceUrl );
		
		this._configuration.parameterFactory.setParameters( this._request, this._configuration.parameters, _excludedParameters );
		this.timeoutDuration = this._configuration.serviceTimeout;
		
		#if js
			this._request.async 		= true; //TODO: check with flash
		#end
		this._request.onData 		= this._onData;
		this._request.onError 		= this._onError;
		this._request.onStatus 		= this._onStatus;
		
		var requestHeaders : Array<HTTPRequestHeader> = this._configuration.requestHeaders;
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
		return this._configuration.serviceUrl;
	}
	
	public var method( get, null ) : HTTPRequestMethod;
	public function get_method() : HTTPRequestMethod
	{
		return this._configuration.requestMethod;
	}
	
	public var dataFormat( get, null ) : String;
	public function get_dataFormat() : String
	{
		return this._configuration.dataFormat;
	}
	
	public var timeout( get, null ) : UInt;
	public function get_timeout() : UInt
	{
		return this._configuration.serviceTimeout;
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
		this._configuration.parameters = parameters;
	}

	public function getParameters() : HTTPServiceParameters
	{
		return this._configuration.parameters;
	}

	public function addHeader( header : HTTPRequestHeader ) : Void
	{
		this._configuration.requestHeaders.push( header );
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
		
	}

	public function setURL( url : String ) : Void
	{
		this._configuration.serviceUrl = url;
	}
	
	/**
     * Event handling
     */
	public function addHTTPServiceListener( listener : IHTTPServiceListener<ServiceConfigurationType> ) : Void
	{
		this._ed.addHandler( StatelessServiceMessage.COMPLETE, listener, listener.onServiceComplete );
		this._ed.addHandler( StatelessServiceMessage.FAIL, listener, listener.onServiceFail );
		this._ed.addHandler( StatelessServiceMessage.CANCEL, listener, listener.onServiceCancel );
		this._ed.addHandler( AsyncStatelessServiceMessage.TIMEOUT, listener, listener.onServiceTimeout );
	}

	public function removeHTTPServiceListener( listener : IHTTPServiceListener<ServiceConfigurationType> ) : Void
	{
		this._ed.removeHandler( StatelessServiceMessage.COMPLETE, listener, listener.onServiceComplete );
		this._ed.removeHandler( StatelessServiceMessage.FAIL, listener, listener.onServiceFail );
		this._ed.removeHandler( StatelessServiceMessage.CANCEL, listener, listener.onServiceCancel );
		this._ed.removeHandler( AsyncStatelessServiceMessage.TIMEOUT, listener, listener.onServiceTimeout );
	}
}