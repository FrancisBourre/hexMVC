package hex.metadata;

import haxe.rtti.Meta;
import hex.collection.HashMap;
import hex.core.IAnnotationParsable;
import hex.di.IDependencyInjector;
import hex.di.InjectionEvent;
import hex.domain.Domain;
import hex.domain.TopLevelDomain;
import hex.error.IllegalArgumentException;
import hex.error.IllegalStateException;
import hex.log.Stringifier;

/**
 * ...
 * @author Francis Bourre
 */
class AnnotationProvider implements IAnnotationProvider
{
	static var _initialized 	: Bool = false;
	static var _Domains			: Map<Domain, IAnnotationProvider> = new Map();
	static var _Parents			: Map<Domain, Domain> = new Map();
	
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
		AnnotationProvider._Domains = new Map();
		AnnotationProvider._Parents = new Map();
	}
	
	static public function getAnnotationProvider( ?domain : Domain, ?parentDomain : Domain ) : IAnnotationProvider
	{
		if ( !AnnotationProvider._initialized )
		{
			AnnotationProvider._initialized = true;
			var provider = new AnnotationProvider( TopLevelDomain.DOMAIN, null );
			AnnotationProvider._Domains.set( TopLevelDomain.DOMAIN, provider );
		}
		
		if ( domain == null )
		{
			domain = TopLevelDomain.DOMAIN;
		}
		
		if ( parentDomain == null && domain != TopLevelDomain.DOMAIN )
		{
			if ( !AnnotationProvider._Parents.exists( domain ) )
			{
				parentDomain = TopLevelDomain.DOMAIN;
			}
			else
			{
				parentDomain = AnnotationProvider._Parents.get( domain );
			}
		}
		
		if ( !AnnotationProvider._Domains.exists( domain ) )
		{
			AnnotationProvider._Domains.set( domain, new AnnotationProvider( domain, AnnotationProvider._Domains.get( parentDomain ) ) );
		}
		
		return AnnotationProvider._Domains.get( domain );
	}
	
	static public function registerToParentDomain( domain : Domain, parentDomain : Domain) : Void
	{
		if ( !AnnotationProvider._Parents.exists( domain ) )
		{
			AnnotationProvider._Parents.set( domain, parentDomain );
		}
		else
		{
			throw new IllegalStateException( 	"'" + domain.getName() + "' cannot be registered to '" + parentDomain.getName() +
													"' parent domain, it's already registered to '" + 
														AnnotationProvider._Parents.get( domain ).getName() 
															+ "' parent domain" );
		}
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
	
	public function registerInjector( injector : IDependencyInjector ) : Void
	{
		injector.addEventListener( InjectionEvent.PRE_CONSTRUCT, _onPostconstruct );
	}

	public function unregisterInjector( injector : IDependencyInjector ) : Void
	{
		injector.removeEventListener( InjectionEvent.PRE_CONSTRUCT, _onPostconstruct );
	}
	
	function _onPostconstruct( event : InjectionEvent ) : Void
	{
		if ( Std.is( event.instance, IAnnotationParsable ) )
		{
			this.parse( event.instance );
		}
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