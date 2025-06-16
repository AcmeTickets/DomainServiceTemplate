using {{DomainName}}.Domain.Entities;
using {{DomainName}}.Domain.Events;
using Xunit;

namespace {{DomainName}}.Test.UnitTests.Domain;

public class EventTests
{
    [Fact]
    public void Create_Should_SetProperties_And_RaiseEventCreatedEvent()
    {
        // Arrange
        var name = "Test Event";
        var startDate = DateTime.UtcNow.AddDays(1);
        var endDate = DateTime.UtcNow.AddDays(2);

        // Act
        var evt = Event.Create(name, startDate, endDate);

        // Assert
        Assert.NotEqual(Guid.Empty, evt.Id);
        Assert.Equal(name, evt.Name);
        Assert.Equal(startDate, evt.StartDate);
        Assert.Equal(endDate, evt.EndDate);
        Assert.Equal(EventStatus.Active, evt.Status);
        Assert.Single(evt.DomainEvents);
        Assert.IsType<EventCreatedEvent>(evt.DomainEvents.First());
        var domainEvent = (EventCreatedEvent)evt.DomainEvents.First();
        Assert.Equal(evt.Id, domainEvent.EventId);
        Assert.Equal(name, domainEvent.Name);
    }
}
