using {{DomainName}}.Application.Commands;
using {{DomainName}}.Application.DTOs;

namespace {{DomainName}}.Application.Services;

public interface IEventService
{
    Task<EventDto> AddEventAsync(AddEventCommand command, CancellationToken cancellationToken);
    Task ExpireEventAsync(ExpireEventCommand command, CancellationToken cancellationToken);
    Task CloseEventAsync(CloseEventCommand command, CancellationToken cancellationToken);
}
