package hex.view.viewhelper;

import hex.di.IDependencyInjector;
import hex.event.Dispatcher;
import hex.module.IModule;

/**
 * ...
 * @author Francis Bourre
 */
class ViewHelperManager
{
	static var _mInstances 	= new Map<IModule, ViewHelperManager>();
	static var _DISPATCHER 	= new Dispatcher<{}>();
	
	var _owner 				: IModule;
	var _dispatcher 		: Dispatcher<{}>;
	var _viewHelpers 		: Array<IViewHelperTypedef>;
	
	public function new ( owner : IModule ) 
	{
		this._owner = owner;
		this._dispatcher = new Dispatcher<{}>();
		this._viewHelpers = [];
	}
	
	static public function getInstance( owner : IModule ) : ViewHelperManager
	{
		var viewHelperManager : ViewHelperManager = ViewHelperManager._mInstances.get( owner );
		if ( viewHelperManager == null )
		{
			viewHelperManager = new ViewHelperManager( owner );
			ViewHelperManager._mInstances.set( owner, viewHelperManager );
			ViewHelperManager.notifyViewHelperManagerCreation( viewHelperManager );
		}

		return viewHelperManager;
	}
	
	static public function release( owner : IModule ) : Void
	{
		var viewHelperManager : ViewHelperManager = ViewHelperManager._mInstances.get( owner );
		if ( viewHelperManager != null )
		{
			ViewHelperManager.notifyViewHelperManagerRelease( viewHelperManager );
			viewHelperManager.releaseAllViewHelpers();
			ViewHelperManager._mInstances.remove( owner );
		}
	}
	
	public function getOwner() : IModule
	{
		return this._owner;
	}
	
	public function releaseAllViewHelpers() : Void
	{
		var len : UInt = this._viewHelpers.length;

		for ( i in 0...len )
		{
			var viewHelper : IViewHelperTypedef = this._viewHelpers[ len-i-1 ];
			this._viewHelpers.splice( len-i-1, 1 );
			viewHelper.removeHandler( ViewHelperMessage.RELEASE, this, this._onViewHelperRelease );
			viewHelper.release();
			this._notifyViewHelperRelease( viewHelper );
		}
	}
	
	public function buildViewHelper( injector : IDependencyInjector, clazz : Class<IViewHelperTypedef>, view : IView ) : IViewHelperTypedef
	{
		var viewHelper : IViewHelperTypedef = injector.instantiateUnmapped( clazz );

		if ( viewHelper != null )
		{
			this._notifyViewHelperCreation( viewHelper );

			injector.mapToValue( clazz,  viewHelper );
			viewHelper.setOwner( this._owner );
			viewHelper.view = view;
			viewHelper.addHandler( ViewHelperMessage.RELEASE, this, this._onViewHelperRelease );
			this._viewHelpers.push( viewHelper );
		}

		return viewHelper;
	}
	
	public function size() : Int
	{
		return this._viewHelpers.length;
	}
	
	function _onViewHelperRelease( viewHelper : IViewHelperTypedef ) : Void
	{
		this._notifyViewHelperRelease( viewHelper );

		var index : Int = this._viewHelpers.indexOf( viewHelper );
		if ( index != -1 )
		{
			this._viewHelpers.splice( index, 1 );
		}
	}
	
	/**
	 * Event System
	 */
	public function addListener( listener : IViewHelperManagerListener ) : Void
	{
		this._dispatcher.addHandler( ViewHelperManagerMessage.VIEW_HELPER_CREATION, listener, listener.onViewHelperCreation );
		this._dispatcher.addHandler( ViewHelperManagerMessage.VIEW_HELPER_RELEASE, listener, listener.onViewHelperRelease );
	}

	public function removeListener( listener : IViewHelperManagerListener ) : Void
	{
		this._dispatcher.removeHandler( ViewHelperManagerMessage.VIEW_HELPER_CREATION, listener, listener.onViewHelperCreation );
		this._dispatcher.removeHandler( ViewHelperManagerMessage.VIEW_HELPER_RELEASE, listener, listener.onViewHelperRelease );
	}

	function _notifyViewHelperCreation( viewHelper : IViewHelperTypedef ) : Void
	{
		this._dispatcher.dispatch( ViewHelperManagerMessage.VIEW_HELPER_CREATION, [ viewHelper ] );
	}

	function _notifyViewHelperRelease( viewHelper : IViewHelperTypedef ) : Void
	{
		this._dispatcher.dispatch( ViewHelperManagerMessage.VIEW_HELPER_RELEASE, [ viewHelper ] );
	}
	
	/**
	 * Main Event System
	 */
	static public function addGlobalListener( listener : IMainViewHelperManagerListener ) : Void
	{
		ViewHelperManager._DISPATCHER.addHandler( MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_CREATION, listener, listener.onViewHelperManagerCreation );
		ViewHelperManager._DISPATCHER.addHandler( MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_RELEASE, listener, listener.onViewHelperManagerRelease );
	}

	static public function removeGlobalListener( listener : IMainViewHelperManagerListener ) : Void
	{
		ViewHelperManager._DISPATCHER.removeHandler( MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_CREATION, listener, listener.onViewHelperManagerCreation );
		ViewHelperManager._DISPATCHER.removeHandler( MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_RELEASE, listener, listener.onViewHelperManagerRelease );
	}

	static function notifyViewHelperManagerCreation( viewHelperManager : ViewHelperManager ) : Void
	{
		ViewHelperManager._DISPATCHER.dispatch( MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_CREATION, [ viewHelperManager ] );
	}

	static function notifyViewHelperManagerRelease( viewHelperManager : ViewHelperManager ) : Void
	{
		ViewHelperManager._DISPATCHER.dispatch( MainViewHelperManagerMessage.VIEW_HELPER_MANAGER_RELEASE, [ viewHelperManager ] );
	}
}