package hex.metadata;

import haxe.rtti.Meta;
import hex.collection.HashMap;
import hex.core.IMetaDataParsable;
import hex.error.IllegalArgumentException;
import hex.inject.IInjector;
import hex.inject.InjectionEvent;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class MetadataProvider implements IMetadataProvider
{
	static private var _Instance 		: IMetadataProvider = null;
	static private var _META_DATA 		: HashMap<Class<Dynamic>, Dynamic> = new HashMap();
	
	private var _metadata 				: Map<String, ProviderHandler>;
	private var _instances 				: Map<String, Array<InstanceVO>>;

	private function new() 
	{
		this._metadata 				= new Map();
		this._instances 			= new Map();
	}
	
	static public function getInstance( injector : IInjector = null ) : IMetadataProvider
	{
		if ( MetadataProvider._Instance == null )
		{
			MetadataProvider._Instance = new MetadataProvider();
		}

		if ( injector != null )
		{
			MetadataProvider._Instance.registerInjector( injector );
		}

		return MetadataProvider._Instance;
	}
	
	public function registerMetaData( metaDataName : String, scope : Dynamic, providerMethod : String->Dynamic ) : Void 
	{
		if ( !this._metadata.exists( metaDataName ) )
		{
			var providerHandler : ProviderHandler = new ProviderHandler( scope, providerMethod );
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
					var instanceVO : InstanceVO = new InstanceVO( instance, property.propertyName, property.metaDataName, property.metaDataValue );
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
	
	private function _parse( object : {} ) : ClassMetaDataVO
	{
		var classMetaDataVO : ClassMetaDataVO = null;
		
		//try to retrieve class
		var classReference : Class<Dynamic> = Type.getClass( object );

		if ( classReference != null )
		{
			//try to get cache
			if ( MetadataProvider._META_DATA.containsKey( classReference ) )
			{
				classMetaDataVO = MetadataProvider._META_DATA.get( classReference );
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
					var metaDataName = Reflect.fields( o )[ 0 ];
					var metaDataValue = Reflect.field( o, metaDataName )[ 0 ];
					properties.push( new PropertyMetaDataVO( propertyName, metaDataName, metaDataValue ) );
				}
				
				MetadataProvider._META_DATA.put( classReference, classMetaDataVO );
			}
		}
		
		return classMetaDataVO;
	}
	
	public function registerInjector( injector : IInjector ) : Void
	{
		injector.addInjectionEventListener( InjectionEvent.POST_CONSTRUCT, _onPostconstruct );
	}

	public function unregisterInjector( injector : IInjector ) : Void
	{
		injector.removeInjectionEventListener( InjectionEvent.POST_CONSTRUCT, _onPostconstruct );
	}
	
	private function _onPostconstruct( event : InjectionEvent ) : Void
	{
		if ( Std.is( event.instance, IMetaDataParsable ) )
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