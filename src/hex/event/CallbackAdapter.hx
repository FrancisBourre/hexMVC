package hex.event;

import hex.error.IllegalArgumentException;
import hex.util.ClassUtil;

/**
 * ...
 * @author Francis Bourre
 */
class CallbackAdapter
{
	private var _callback 		: Dynamic;
	private var _adapterMethod 	: Dynamic;
	private var _adapterClass 	: Class<IEventAdapterStrategy>;
	private var _adapterInstance: IEventAdapterStrategy;
	private var _factoryMethod 	: Dynamic;
		
	public function new( callback : Dynamic, ?adapterStrategy : Dynamic, ?factoryMethod : Dynamic ) 
	{
		this.setCallBack( callback );

		if ( adapterStrategy != null )
		{
			if ( Std.is( adapterStrategy, Class ) && ClassUtil.classExtendsOrImplements( adapterStrategy, IEventAdapterStrategy ) )
			{
				this.setAdapterClass( adapterStrategy );

				if ( factoryMethod != null )
				{
					this._factoryMethod = factoryMethod;
				}

			} else if ( Reflect.isFunction( adapterStrategy ) )
			{
				this.setAdapterMethod( adapterStrategy );

			} else
			{
				throw new IllegalArgumentException( this + " constructor failed, adapterStrategy argument should be only instance of Function or Class." );
			}
		}
	}

	public function setCallBack( callback : Dynamic ) : Void
	{
		this._callback = callback;
	}

	public function setAdapterMethod( adapterMethod : Dynamic ) : Void
	{
		this._adapterMethod = adapterMethod;
	}

	public function setAdapterClass( adapterClass : Class<IEventAdapterStrategy> ) : Void
	{
		this._adapterClass = adapterClass;
	}
	
	public function getCallbackAdapter() : Dynamic
	{
		/*var adapterMethod 		: Dynamic;
		var adapterInstance 	: IEventAdapterStrategy;
		var adapterClass 		: Class;
		var factoryMethod 		: Dynamic;

		if ( this._adapterClass != null )
		{
			adapterClass = this._adapterClass;
			factoryMethod = this._factoryMethod;
			var isEventAdapterStrategyMacro : Bool =  ClassUtil.classExtendsOrImplements( this._adapterClass, EventAdapterStrategyMacro );

			if ( !isEventAdapterStrategyMacro )
			{
				adapterInstance = this._adapterInstance =
						this._factoryMethod != null ?
						cast this._factoryMethod( this._adapterClass ) :
						cast ( new this._adapterClass() );
			}
		}
		else if ( this._adapterMethod != null )
		{
			adapterMethod = this._adapterMethod;
		}

		var callback : Dynamic = this._callback;

		return function( ... rest ) : void
		{
			var result : Array;

			if ( adapterMethod != null )
			{
				result = adapterMethod( rest );

			}
			else if ( isEventAdapterStrategyMacro )
			{
				var aSyncCommand:EventAdapterStrategyMacro = factoryMethod ? factoryMethod( adapterClass ) as EventAdapterStrategyMacro : ( new adapterClass() ) as EventAdapterStrategyMacro;
				if ( aSyncCommand is IMetaDataParsable ) MetaDataProvider.getInstance().parse( aSyncCommand );
				adapterInstance = aSyncCommand;
				aSyncCommand.adapt.apply( null, rest );
				aSyncCommand.preExecute();
				aSyncCommand.addCompleteHandler( function ( cmd:EventAdapterStrategyMacro )
				{
					callback.apply( null, cmd.returnPayload );
				} );
				aSyncCommand.execute();
				return;
			}
			else if ( adapterInstance )
			{
				if ( adapterInstance is IMetaDataParsable ) MetaDataProvider.getInstance().parse( adapterInstance );
				result = adapterInstance.adapt.apply( null, rest );
			}

			if ( result is Array || result is Vector )
			{
				callback.apply( null, result );

			} else
			{
				callback( result );
			}
		}*/
		
		return null;
	}
}