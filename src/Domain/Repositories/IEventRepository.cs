using {{DomainName}}.Domain.Entities;

namespace {{DomainName}}.Domain.Repositories;

public interface IEventRepository
{
    Task<Event> GetByIdAsync(Guid id, CancellationToken cancellationToken);
    Task AddAsync(Event evt, CancellationToken cancellationToken);
    Task UpdateAsync(Event evt, CancellationToken cancellationToken);
}