# Extending hexLog functionlity and providing domain information

## DomainLoggerContext

Simplest way to extend your logs with domain information is to use `DomainLoggerContext` instead of the defualt one:

```haxe
LogManager.context = new DomainLoggerContext(TopLevelDomain.DOMAIN);
```

This way default messageFactory for every logger will become a DomainMessageFactory with specified domain.

## TraceEverythingDomainConfiguration

Essentially a copy of a standard `TraceEverythingConfiguration` but using `DomainLayout` for the trace target.

## DomainMessageFactory

Creates a `IMessage` instance implementation which contains a domain information. Messages created by this factory implement `IDomainMessage` interface which is extension of standard `IMessage`.

## DomainLayout

Basic implementation of a layout which deals with the additional domain information. Not that fallback behavior is necessary because not every message is `IDomainMessage`.

## DomainFilter

Basic implementation of a filter that handles domain information. For the same reason as `DomainLayout` filter has to deal with potentially missing the domain information.
