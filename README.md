# hexMVC

[![TravisCI Build Status](https://travis-ci.org/DoclerLabs/hexMVC.svg?branch=master)](https://travis-ci.org/DoclerLabs/hexMVC)
hexMVC is a powerful MVC+S framework

## Dependencies

* [hexCore](https://github.com/DoclerLabs/hexCore)
* [hexInject](https://github.com/DoclerLabs/hexInject)
	
	
## ServiceLocator example
```haxe
private class MModule extends Module
{
	public function new( serviceLocator : IStatefulConfig )
	{
		super();
		this._addStatefulConfigs( [serviceLocator] );
		this._addStatelessConfigClasses( [MStatelessCommandConfig, MStatelessModelConfig] );
	}
	
	override private function _getRuntimeDependencies() : IRuntimeDependencies
	{
		var rt : RuntimeDependencies = new RuntimeDependencies();
		rt.addServiceDependencies( [IGitService] );
		return rt;
	}
	
	override public function _onInitialisation() : Void 
	{
		this.sendRequest( new PayloadEvent( "doSomething", this, [new ExecutionPayload( something, ISomething )] ) );
	}
}
```
	
## Model config example
```haxe
private class MStatelessModelConfig extends StatelessModelConfig
{
	override public function configure() : Void 
	{
		this.mapModel( IMModel, MModel  );
	}
}
```


## Command config example
```haxe
private class MStatefulCommandConfig extends StatefulCommandConfig
{
	public function new()
	{
		super();
	}
	
	override public function configure( injector : IDependencyInjector ) : Void
	{
		super.configure( injector );
		this.map( "test", TestCommand ).once().withGuards( MyGuardClass ).withCompleteHandlers([ function( e : AsyncCommandEvent ){ trace( e ); } ]);
	}
}
```


## Command example
```haxe
@:rtti
private class TestCommand extends AsyncCommand implements IHTTPServiceListener<GitServiceEvent>
{
	@inject
    public var model : IMModel;
	
	@inject
    public var service : IGitService;

    override public function execute( ?e : IEvent ) : Void
    {
		this.service.addHTTPServiceListener( this );
		this.service.call();
    }
	
	public function onServiceTimeout( event : GitServiceEvent ) : Void 
	{
		this._handleFail();
	}
	
	public function onServiceComplete( e : GitServiceEvent ) : Void 
	{
		this.model.setValue( e.getData() );
		this._handleComplete();
	}
	
	public function onServiceFail( e : GitServiceEvent ) : Void 
	{
		this._handleFail();
	}
	
	public function onServiceCancel( e : GitServiceEvent ) : Void 
	{
		this._handleCancel();
	}
}
```