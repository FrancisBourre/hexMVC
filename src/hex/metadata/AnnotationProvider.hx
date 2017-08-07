package hex.metadata;

import haxe.rtti.Meta;
import hex.collection.HashMap;
import hex.core.IAnnotationParsable;
import hex.core.IApplicationContext;
import hex.core.ICoreFactory;
import hex.di.IDependencyInjector;
import hex.di.IInjectorListener;
import hex.domain.Domain;
import hex.domain.TopLevelDomain;
import hex.error.IllegalArgumentException;
import hex.event.MessageType;
import hex.log.ILogger;
import hex.util.Stringifier;

/**
 * Don't look inside please,
 * It will be soon deprecated.
 * @author Francis Bourre
 */
class AnnotationProvider 
	implements IInjectorListener
	implements IAnnotationProvider
{
	static var _initialized 	: Bool = false;
	static var __Domains		: Map<IApplicationContext, Map<Domain, IAnnotationProvider>>;

	static var _DefaultApplicationContext;
	
	var _domain 				: Domain;
	var _parent 				: IAnnotationProvider;
	var _cache 					: HashMap<Class<Dynamic>, ClassMetaDataVO>;
	var _metadata 				: Map<String, String->Dynamic>;
	var _instances 				: Map<String, Array<InstanceVO>>;

	function new( domain : Domain, parent : IAnnotationProvider = null ) 
	{
		this._domain 			= domain;
		this._parent 			= parent;
		this._cache 			= new HashMap();
		this._metadata 			= new Map();
		this._instances 		= new Map();
	}
	
	static public function release() : Void
	{
		AnnotationProvider._initialized = false;
		AnnotationProvider.__Domains = new Map();
	}
	
	static public function getAnnotationProvider( ?domain : Domain, ?parentDomain : Domain, context : IApplicationContext = null ) : IAnnotationProvider
	{
		if ( __Domains == null ) __Domains = new Map();
		if ( _DefaultApplicationContext == null ) _DefaultApplicationContext = new InternalApplicationContext();
		if ( context == null ) context = _DefaultApplicationContext;
		if (!__Domains.exists(context))
		{
			var m = new Map();
			__Domains.set( context, m );
			
			var provider = new AnnotationProvider( TopLevelDomain.DOMAIN, null );
			m.set( TopLevelDomain.DOMAIN, provider );
		}
		
		if ( domain == null )
		{
			domain = TopLevelDomain.DOMAIN;
		}
		
		if ( parentDomain == null && domain != TopLevelDomain.DOMAIN )
		{
			parentDomain = domain.getParent();
		}
		
		if ( !__Domains.get(context).exists( domain ) )
		{
			__Domains.get(context).set( domain, new AnnotationProvider( domain, __Domains.get(context).get( parentDomain ) ) );
		}
		
		return __Domains.get(context).get( domain );
	}
	
	public function registerMetaData( metaDataName : String, providerMethod : String->Dynamic ) : Void 
	{
		if ( !this._metadata.exists( metaDataName ) )
		{
			this._metadata.set( metaDataName, providerMethod );
			
			var voCollection : Array<InstanceVO> = this._instances.get( metaDataName );
			
			if ( voCollection != null )
			{
				for ( vo in voCollection )
				{
					if ( vo.metaDataName == metaDataName )
					{
						Reflect.setProperty( vo.owner, vo.propertyName, providerMethod( vo.metaDataValue ) );
					}
				}
			}
			
			if ( this._parent != null )
			{
				AnnotationProvider._unregisterInstances( metaDataName, cast this._parent );
			}
		}
		else
		{
			throw new IllegalArgumentException( "registerMetaData failed. '" + metaDataName + "' is already registered in '" + Stringifier.stringify( this ) + "'" );
		}
	}
	
	static private function _unregisterInstances( metaDataName : String, provider : AnnotationProvider ) : Void
	{
		provider._instances.remove( metaDataName );

		if ( provider._parent != null )
		{
			AnnotationProvider._unregisterInstances( metaDataName, cast provider._parent );
		}
	}
	
	public function clear() : Void 
	{
		this._cache 				= new HashMap();
		this._metadata 				= new Map();
		this._instances 			= new Map();
	}
	
	private function _do( instance : {}, property : PropertyMetaDataVO ) : Void
	{
		var metaDataName : String = property.metaDataName;

		if ( this._metadata.exists( metaDataName ) )
		{	
			var providerMethod : String->Dynamic = this._metadata.get( metaDataName );
			Reflect.setProperty( instance, property.propertyName, providerMethod( property.metaDataValue ) );
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
			
			if ( this._parent != null )
			{
				( cast this._parent )._do( instance, property );
			}
		}
	}
	
	public function parse( instance : {} ) : Void 
	{
		var classMetaDataVO : ClassMetaDataVO = this._parse( instance );
	
		if ( classMetaDataVO != null )
		{
			var properties : Array<PropertyMetaDataVO> = classMetaDataVO.properties;
			for ( property in properties )
			{
				this._do( instance, property );
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
			if ( this._cache.containsKey( classReference ) )
			{
				classMetaDataVO = this._cache.get( classReference );
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
				
				this._cache.put( classReference, classMetaDataVO );
			}
		}
		
		return classMetaDataVO;
	}
	
	public function onPreConstruct( target : IDependencyInjector, instance : Dynamic, instanceType : Class<Dynamic> ): Void
	{
		if ( Std.is( instance, IAnnotationParsable ) )
		{
			this.parse( instance );
		}
	}
	
	public function onPostConstruct( target : IDependencyInjector, instance : Dynamic, instanceType : Class<Dynamic> ) : Void
	{
		
	}
	
	public function registerInjector( injector : IDependencyInjector ) : Void
	{
		injector.addListener( this );
	}

	public function unregisterInjector( injector : IDependencyInjector ) : Void
	{
		injector.removeListener( this );
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

private class InternalApplicationContext implements IApplicationContext
{
	public function new() 
	{
		
	}
	
	public function getName() : String 
	{
		return '';
	}
	
	public function getDomain() : Domain 
	{
		return null;
	}
	
	public function dispatch( messageType : MessageType, ?data : Array<Dynamic> ) : Void 
	{
		
	}
	
	public function getCoreFactory() : ICoreFactory 
	{
		return null;
	}
	
	public function getInjector() : IDependencyInjector 
	{
		return null;
	}
	
	public var isInitialized( get, null ) : Bool;
	function get_isInitialized() : Bool 
	{
		return isInitialized;
	}
	
	public var isReleased( get, null ) : Bool;
	function get_isReleased() : Bool 
	{
		return isReleased;
	}
	
	public function initialize( context : IApplicationContext ) : Void 
	{
		
	}
	
	public function release() : Void 
	{
		
	}
	
	public function getLogger() : ILogger 
	{
		return null;
	}
}