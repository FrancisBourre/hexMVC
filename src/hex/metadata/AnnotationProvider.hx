package hex.metadata;

import haxe.rtti.Meta;
import hex.collection.HashMap;
import hex.core.IAnnotationParsable;
import hex.error.IllegalArgumentException;
import hex.inject.IInjector;
import hex.inject.InjectionEvent;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationProvider implements IAnnotationProvider
{
	static var _Instance 		: IAnnotationProvider = null;
	static var _META_DATA 		= new HashMap();
	
	var _metadata 				: Map<String, ProviderHandler>;
	var _instances 				: Map<String, Array<InstanceVO>>;

	function new() 
	{
		this._metadata 				= new Map();
		this._instances 			= new Map();
	}
	
	static public function getInstance( injector : IInjector = null ) : IAnnotationProvider
	{
		if ( AnnotationProvider._Instance == null )
		{
			AnnotationProvider._Instance = new AnnotationProvider();
		}

		if ( injector != null )
		{
			AnnotationProvider._Instance.registerInjector( injector );
		}

		return AnnotationProvider._Instance;
	}
	
	public function registerMetaData( metaDataName : String, scope : Dynamic, providerMethod : String->Dynamic ) : Void 
	{
		if ( !this._metadata.exists( metaDataName ) )
		{
			var providerHandler = new ProviderHandler( scope, providerMethod );
			this._metadata.set( metaDataName, providerHandler );
			
			var voCollection : Array<InstanceVO> = this._instances.get( metaDataName );
			
			if ( voCollection != null )
			{
				for ( vo in voCollection )
				{
					if ( vo.metaDataName == metaDataName )
					{
						Reflect.setProperty( vo.owner, vo.propertyName, providerHandler.call( vo.metaDataValue ) );
					}
				}
			}
		}
		else
		{
			throw new IllegalArgumentException( "registerMetaData failed. '" + metaDataName + "' is already registered in '" + Stringifier.stringify( this ) + "'" );
		}
	}
	
	public function clear() : Void 
	{
		this._metadata 				= new Map();
		this._instances 			= new Map();
	}
	
	public function parse( instance : {} ) : Void 
	{
		var classMetaDataVO : ClassMetaDataVO = this._parse( instance );
		
		if ( classMetaDataVO != null )
		{
			var properties : Array<PropertyMetaDataVO> = classMetaDataVO.properties;
			for ( property in properties )
			{
				var metaDataName : String = property.metaDataName;

				if ( this._metadata.exists( metaDataName ) )
				{
					var providerHandler : ProviderHandler = this._metadata.get( metaDataName );
					Reflect.setProperty( instance, property.propertyName, providerHandler.call( property.metaDataValue ) );
				}
				else
				{
					var instanceVO = new InstanceVO( instance, property.propertyName, property.metaDataName, property.metaDataValue );
					if ( this._instances.exists( metaDataName ) )
					{
						this._instances.get( metaDataName ).push( instanceVO );
					}
					else
					{
						this._instances.set( metaDataName, [ instanceVO ] );
					}
				}
			}
		}
	}
	
	function _parse( object : {} ) : ClassMetaDataVO
	{
		var classMetaDataVO : ClassMetaDataVO = null;
		
		//try to retrieve class
		var classReference : Class<Dynamic> = Type.getClass( object );

		if ( classReference != null )
		{
			//try to get cache
			if ( AnnotationProvider._META_DATA.containsKey( classReference ) )
			{
				classMetaDataVO = AnnotationProvider._META_DATA.get( classReference );
			}
			else
			{
				classMetaDataVO = new ClassMetaDataVO();
				var properties : Array<PropertyMetaDataVO> = classMetaDataVO.properties;
				
				var metadata = Meta.getFields( classReference );
				var fields = Reflect.fields( metadata );
				for ( propertyName in fields )
				{
					var o = Reflect.field( metadata, propertyName );
					var f = Reflect.fields( o );
					if ( f != null )
					{
						var metaDataName = f[ 0 ];
						if ( metaDataName != null )
						{
							var field = Reflect.field( o, metaDataName );
							if ( field != null )
							{
								var metaDataValue = field[ 0 ];
								properties.push( new PropertyMetaDataVO( propertyName, metaDataName, metaDataValue ) );
							}
						}
					}
				}
				
				AnnotationProvider._META_DATA.put( classReference, classMetaDataVO );
			}
		}
		
		return classMetaDataVO;
	}
	
	public function registerInjector( injector : IInjector ) : Void
	{
		injector.addInjectionEventListener( InjectionEvent.PRE_CONSTRUCT, _onPostconstruct );
	}

	public function unregisterInjector( injector : IInjector ) : Void
	{
		injector.removeInjectionEventListener( InjectionEvent.PRE_CONSTRUCT, _onPostconstruct );
	}
	
	function _onPostconstruct( event : InjectionEvent ) : Void
	{
		if ( Std.is( event.instance, IAnnotationParsable ) )
		{
			this.parse( event.instance );
		}
	}
}

private class ProviderHandler
{
	public var scope		: Dynamic;
	public var callback		: String->Dynamic;
	
	public function new( scope : Dynamic, callback : String->Dynamic )
	{
		this.scope 		= scope;
		this.callback 	= callback;
	}
	
	public function call( metaDataValue : String ) : Dynamic
	{
		return Reflect.callMethod( this.scope, this.callback, [ metaDataValue ] );
	}
}

private class ClassMetaDataVO
{
	public var classReference	: Class<Dynamic>;
	public var properties		: Array<PropertyMetaDataVO>;
	
	public function new()
	{
		this.properties = [];
	}
}

private class PropertyMetaDataVO
{
	public var propertyName		: String;
	public var metaDataName		: String;
	public var metaDataValue	: String;
	
	public function new( ?propertyName : String, ?metaDataName : String, ?metaDataValue : String )
	{
		this.propertyName 	= propertyName;
		this.metaDataName 	= metaDataName;
		this.metaDataValue 	= metaDataValue;
	}
}

private class InstanceVO
{
	public var owner			: Dynamic;
	public var propertyName		: String;
	public var metaDataName		: String;
	public var metaDataValue	: String;
	
	public function new( owner : Dynamic, ?propertyName : String, ?metaDataName : String, ?metaDataValue : String )
	{
		this.owner 			= owner;
		this.propertyName 	= propertyName;
		this.metaDataName 	= metaDataName;
		this.metaDataValue 	= metaDataValue;
	}
}