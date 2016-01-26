package hex.event;

import hex.control.async.AsyncCommand;
import hex.core.IAnnotationParsable;
import hex.error.IllegalArgumentException;
import hex.metadata.AnnotationProvider;
import hex.util.ClassUtil;

/**
 * ...
 * @author Francis Bourre
 */
class ClassAdapter
{
	var _callbackTarget 	: Dynamic;
	var _callbackMethod 	: Dynamic;
	
	var _adapterClass 		: Class<IAdapterStrategy>;
	var _adapterInstance	: IAdapterStrategy;
	
	var _factoryTarget 		: Dynamic;
	var _factoryMethod 		: Dynamic;
	
	public function new() 
	{

	}
	
	public function setCallBackMethod( callbackTarget : Dynamic, callbackMethod : Dynamic ) : Void
	{
		this._callbackTarget = callbackTarget;
		this._callbackMethod = callbackMethod;
	}

	public function setAdapterClass( adapterClass : Class<IAdapterStrategy> ) : Void
	{
		this._adapterClass = adapterClass;
	}
	
	public function setFactoryMethod( factoryTarget : Dynamic, factoryMethod : Dynamic ) : Void
	{
		this._factoryTarget = factoryTarget;
		this._factoryMethod = factoryMethod;
	}
	
	public function getCallbackAdapter() : Dynamic
	{
		var callbackTarget 				: Dynamic 				= this._callbackTarget;
		var callbackMethod 				: Dynamic 				= this._callbackMethod;
		
		var adapterInstance 			: IAdapterStrategy 		= null;
		var adapterClass 				: Class<Dynamic> 		= null;
		
		var factoryTarget 				: Dynamic 				= null;
		var factoryMethod 				: Dynamic 				= null;
		
		var isEventAdapterStrategyMacro : Bool 					= false;

		if ( this._adapterClass != null )
		{
			adapterClass 	= this._adapterClass;
			factoryTarget 	= this._factoryTarget;
			factoryMethod 	= this._factoryMethod;
			
			isEventAdapterStrategyMacro = ClassUtil.classExtendsOrImplements( this._adapterClass, MacroAdapterStrategy );

			if ( !isEventAdapterStrategyMacro )
			{
				adapterInstance = this._adapterInstance =
						this._factoryMethod != null ?
						cast this._factoryMethod( this._adapterClass ) :
						cast ( Type.createInstance( this._adapterClass, [] ) );
			}
		}

		var f : Array<Dynamic>->Void = function ( rest : Array<Dynamic> ) : Void
		{
			var result : Dynamic = null;

			if ( isEventAdapterStrategyMacro )
			{
				var aSyncCommand : MacroAdapterStrategy;

				if ( factoryTarget != null && factoryMethod != null )
				{
					aSyncCommand = cast factoryMethod( adapterClass );
				}
				else
				{
					aSyncCommand = cast( Type.createInstance( adapterClass, []  ) );
				}
				
				#if debug
					if ( Std.is(aSyncCommand, IAdapterStrategy) == false )
					{
						throw new IllegalArgumentException("adapterInstance class should extend AdapterStrategy. Check if you passed the correct class");
					}
				#end
				
				if ( Std.is( aSyncCommand, IAnnotationParsable ) )
				{
					AnnotationProvider.getInstance().parse( aSyncCommand );
				}
	
				adapterInstance = aSyncCommand;
				Reflect.callMethod( aSyncCommand, aSyncCommand.adapt, rest );
				aSyncCommand.preExecute();
				var handler = new MacroAdapterStrategyHandler( callbackTarget, callbackMethod );
				aSyncCommand.addCompleteHandler( handler, handler.onAsyncCommandComplete );	
				aSyncCommand.execute();

				return;
			}
			else if ( adapterInstance != null )
			{
				if ( Std.is( adapterInstance, IAnnotationParsable ) )
				{
					AnnotationProvider.getInstance().parse( adapterInstance );
				}
				
				#if debug
					if ( Std.is(adapterInstance, IAdapterStrategy) == false )
					{
						throw new IllegalArgumentException("adapterInstance class should extend AdapterStrategy. Check if you passed the correct class");
					}
				#end
				
				result = Reflect.callMethod( adapterInstance, adapterInstance.adapt, [rest] );
			}

			Reflect.callMethod( callbackTarget, callbackMethod, Std.is( result, Array ) ? result : [result] );
		}
		
		return Reflect.makeVarArgs( f );
	}
}

private class MacroAdapterStrategyHandler
{
	public var scope 	: Dynamic;
	public var callback	: AsyncCommand->Void;

	public function new( scope : Dynamic, callback : AsyncCommand->Void ) 
	{
		this.scope = scope;
		this.callback = callback;
	}
	
	public function onAsyncCommandComplete( command : AsyncCommand ) : Void
	{
		if ( callback != null )
		{
			Reflect.callMethod( scope, callback, [command.getResult()] );
		}
	}
}